"""
A quick script that tests that all of the exercise solutions are correct (pass the _pass spec, fail the _fail spec).

Written in part with Claude 3.5
"""
import subprocess
import re
from tempfile import TemporaryDirectory, NamedTemporaryFile # For state cleanup
from pathlib import Path
import argparse
from dataclasses import dataclass

@dataclass
class Exercise:
    pass_: Path
    fail: Path
    solution: str
    cfg: Path
    name: str

    # TODO move process_tla into a method here

def process_tla(source: Path, solution: str) -> str:
    content = source.read_text()
    
    content = re.sub(
        r'Typeset\s*==\s*[^\n]+',
        solution.replace('\\', '\\\\'), # Escape the solution string to handle TLA+ syntax
        content
    )

    # We want consistent naming of the files, but that means renaming the modules
    content = re.sub(
        r'---- MODULE .+ ----',
        r'---- MODULE Test ----',
        content
    )
    
    return content

def parse_result(result: str) -> str:
    if "unexpected exception" in result:
        return "E"
    elif "Correct" in result:
        return "+"
    elif "Incorrect" in result:
        return "-"
    else:
        return "E"


parser = argparse.ArgumentParser()
parser.add_argument("--tools_path", 
                    default=r"D:/software/TLA+/tla2tools.jar", # Default to my computer's toolpath for now
                    help="Path to tla2tools.jar")

def get_exercise_files():
    root = Path(__file__).parent
    exercises = [f for f in root.iterdir() if f.is_file() and f.suffix == ".tla"] # TODO let this work on nested directories so we can have categories of typesets
    return exercises

def run_tests(jar_path):
    print(f"{'Exercise':<15} {'+ (Pass)':<15}")
    print("-" * 30)
    for exercise in get_exercise_files():
        solution_file = Path(__file__).parent / '_solutions' / f'{exercise.stem}.txt'
        if not solution_file.exists():
            continue
            
        solution = Path(solution_file).read_text()
        with TemporaryDirectory() as run_dir:
            mc_file =  Path(run_dir) / 'Test.tla'
            mc_cfg = Path(run_dir) / 'Test.cfg'
            mc_cfg.write_text("SPECIFICATION Spec")
            script = f"java -jar {jar_path} -workers auto -metadir {run_dir} -terse -cleanup {mc_file}"
            
            mc_file.write_text(process_tla(exercise, solution))
            result = subprocess.run(script, text=True, capture_output=True, shell=True).stdout

            print(f"{exercise.stem:<15} {parse_result(result):<15}")
        

if __name__ == "__main__":
    args = parser.parse_args()
    run_tests(args.tools_path)

