import json
import subprocess
import requests
import hashlib
import time
from pathlib import Path
from types import SimpleNamespace

CACHE_DIR = Path("/home/eschb/.cache/input_changes")
CACHE_TTL_SECONDS = 12 * 60 * 60  # 12 hours

def cleanup_cache():
    """Remove expired cache files."""
    if not CACHE_DIR.exists():
        return

    now = time.time()
    for path in CACHE_DIR.glob("*.json"):
        try:
            if path.stat().st_mtime < (now - CACHE_TTL_SECONDS):
                path.unlink()
        except OSError:
            # Ignore files that can't be accessed/deleted
            pass

cleanup_cache()

def get_github_token():
    result = subprocess.run(
        ["gh", "auth", "token"],
        capture_output=True,
        text=True,
        check=True
    )
    return result.stdout.strip()

TOKEN = get_github_token()


def _cache_path_for_endpoint(endpoint: str) -> Path:
    endpoint_hash = hashlib.sha256(endpoint.encode("utf-8")).hexdigest()
    return CACHE_DIR / f"{endpoint_hash}.json"


def _read_cache(endpoint: str):
    cache_path = _cache_path_for_endpoint(endpoint)
    if not cache_path.exists():
        return None

    max_age = time.time() - CACHE_TTL_SECONDS
    if cache_path.stat().st_mtime < max_age:
        return None

    with cache_path.open("r", encoding="utf-8") as f:
        return json.load(f)


def _write_cache(endpoint: str, data) -> None:
    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    cache_path = _cache_path_for_endpoint(endpoint)
    with cache_path.open("w", encoding="utf-8") as f:
        json.dump(data, f)


def github_api_request(endpoint: str, use_cache: bool = True):
    if use_cache:
        cached = _read_cache(endpoint)
        if cached is not None:
            return cached

    headers = {
        "Authorization": f"Bearer {TOKEN}",
        "Accept": "application/vnd.github+json",
    }
    url = f"https://api.github.com{endpoint}"

    response = requests.get(url, headers=headers, timeout=30)
    response.raise_for_status()
    data = response.json()

    if use_cache:
        _write_cache(endpoint, data)

    return data


x = json.load(open("/home/eschb/nixcfg/flake.lock"))
x = SimpleNamespace(x)


def boring(s):
    cats = [
        ["merge "],
        ["flake.lock"],
        ["bump", "inputs"],
        ["bump", "lock"],
        ["chore("],
        ["chore:"],
        ["ci:"],
        ["docs:"],
        ["doc:"],
        ["darwin"],
        ["automatic update"],
        ["cross compil"],
        ["build(deps): bump"]
    ]
    return any(all(sub in s.lower() for sub in cat) for cat in cats)

everything = []
for input, v in x.nodes.items():
    if "locked" not in v:
        continue
    if not v.get("flake", True):
        continue

    o = v["original"]
    locked = SimpleNamespace(v["locked"])

    if locked.type == "github":
        owner = locked.owner
        repo = locked.repo
        rev = locked.rev

        ref = o.get("ref", "HEAD")
        user_url = f"https://github.com/{owner}/{repo}/compare/{rev}...{ref}"
        api_endpoint = f"/repos/{owner}/{repo}/compare/{rev}...{ref}?per_page=0"
        response = github_api_request(api_endpoint)
        if response["status"] == "identical":
            continue

        everything.append((input, response["total_commits"], user_url, response))
    
everything.sort(key=lambda x: x[1])
nl = False
for input, changes, url, response in everything:
    # if input not in x.nodes[x.root]["inputs"]:
    #     continue
    print("\n" * nl + f"{input}: {changes} changes")
    print(url)
    non_boring = []
    for c in (response["commits"]):
        msg = c["commit"]["message"].splitlines()[0]
        non_boring += [msg] * (not boring(msg))

    if len(non_boring) < 300:
        for m in non_boring:
            print(m)
    
    nl = True
