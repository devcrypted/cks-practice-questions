import typer
from rich.console import Console
from rich.panel import Panel
from rich.theme import Theme
from rich import print
import os
import subprocess
from pathlib import Path

# Setup rich console
custom_theme = Theme({
    "info": "cyan",
    "warning": "yellow",
    "error": "bold red",
    "success": "bold green"
})
console = Console(theme=custom_theme)

app = typer.Typer(help="CKA/CKS/CKAD Practice Environment Manager")

STATE_FILE = Path(".current_question")
CLUSTER_NAME = "practice-cluster"
QUESTIONS_DIR = Path("questions")

def ensure_root():
    if not QUESTIONS_DIR.exists():
        console.print("[error]Error:[/error] Please run this script from the root of the repository.")
        raise typer.Exit(code=1)

def get_question_dir(target_num: str) -> Path:
    for q_dir in QUESTIONS_DIR.iterdir():
        if q_dir.is_dir() and q_dir.name.startswith(f"{target_num}-"):
            return q_dir
    return None

def run_command(cmd: str, cwd: Path = None):
    try:
        subprocess.run(cmd, shell=True, check=True, cwd=cwd)
    except subprocess.CalledProcessError as e:
        console.print(f"[error]Command failed with exit code {e.returncode}:[/error] {cmd}")
        raise typer.Exit(code=e.returncode)

@app.command()
def start(number: str = typer.Argument(..., help="The 3-digit question number (e.g., 001, 002)")):
    """Start a practice question environment."""
    ensure_root()
    # Normalize input
    q_num = f"{int(number):03d}"

    q_dir = get_question_dir(q_num)
    if not q_dir:
        console.print(f"[error]Error:[/error] Could not find question directory starting with '{q_num}'")
        raise typer.Exit(code=1)

    console.print(Panel(f"Starting Question: [bold]{q_dir.name}[/bold]", style="info"))

    console.print("[info]Ensuring clean cluster state...[/info]")
    subprocess.run(f"kind delete cluster --name {CLUSTER_NAME}", shell=True, stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)

    kind_config = q_dir / "setup" / "kind.yaml"
    if kind_config.exists():
        console.print("[info]Creating cluster with custom configuration...[/info]")
        run_command(f"kind create cluster --name {CLUSTER_NAME} --config {kind_config}")
    else:
        console.print("[info]Creating default cluster...[/info]")
        run_command(f"kind create cluster --name {CLUSTER_NAME}")

    STATE_FILE.write_text(q_num)

    prep_script = q_dir / "prepare-environment.sh"
    if prep_script.exists():
        console.print("\n[info]Running preparation scripts...[/info]")
        run_command("bash prepare-environment.sh", cwd=q_dir)
    else:
        console.print("[warning]Warning:[/warning] No prepare-environment.sh found.")

    readme_path = q_dir / "README.md"
    console.print("\n[success]Environment is ready![/success]")
    console.print(f"View the question details at: [bold]{readme_path.absolute()}[/bold]")
    console.print("When done, verify your solution with: [bold]python start.py verify[/bold]")

@app.command()
def question():
    """Print the absolute path to the current question's README.md."""
    ensure_root()
    if not STATE_FILE.exists():
        console.print("[error]No active question.[/error] Start one with: python start.py start <number>")
        raise typer.Exit(code=1)

    active_num = STATE_FILE.read_text().strip()
    q_dir = get_question_dir(active_num)

    if q_dir and (q_dir / "README.md").exists():
        print(str((q_dir / "README.md").absolute()))
    else:
        console.print(f"[error]Error:[/error] Could not locate README for active question {active_num}.")
        raise typer.Exit(code=1)

@app.command()
def verify():
    """Verify your solution for the active question."""
    ensure_root()
    if not STATE_FILE.exists():
        console.print("[error]No active question.[/error] Start one with: python start.py start <number>")
        raise typer.Exit(code=1)

    active_num = STATE_FILE.read_text().strip()
    q_dir = get_question_dir(active_num)

    verify_script = q_dir / "verify.sh"
    if q_dir and verify_script.exists():
        console.print(f"[info]Running verification for Question {q_dir.name}...[/info]")
        run_command("bash verify.sh", cwd=q_dir)
    else:
        console.print(f"[error]Error:[/error] Could not locate verify.sh for active question {active_num}.")
        raise typer.Exit(code=1)

@app.command()
def delete():
    """Delete the practice kind cluster and clear state."""
    console.print("[info]Deleting practice cluster...[/info]")
    subprocess.run(f"kind delete cluster --name {CLUSTER_NAME}", shell=True)
    if STATE_FILE.exists():
        STATE_FILE.unlink()
    console.print("[success]Environment cleaned and state reset.[/success]")

if __name__ == "__main__":
    app()
