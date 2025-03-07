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
        r'Prop\s*==\s*[^\n]+',
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
    elif "No error has been found." in result:
        return "+"
    elif "violated" in result:
        return "-"
    else:
        return "E"


parser = argparse.ArgumentParser()
parser.add_argument("--tools_path", 
                    default=r"D:/software/TLA+/tla2tools.jar", # Default to my computer's toolpath for now
                    help="Path to tla2tools.jar")

def get_exercise_folders():
    root = Path(__file__).parent
    folders = [f for f in root.iterdir() if f.is_dir() and f.name != '_solutions']
    return folders

def run_tests(jar_path):
    exercises = get_exercise_folders()
    exercise_tests = []

    for exercise in exercises:
        solution_file = Path(__file__).parent / '_solutions' / f'{exercise.name}.txt'
        if not solution_file.exists():
            continue
            
        solution = Path(solution_file).read_text()
        
        # Get all files in exercise directory
        pass_files = list(exercise.glob('*_pass.tla'))[0] # temporary, assume one file for now
        fail_files = list(exercise.glob('*_fail.tla'))[0] # temporary, assume one file for now
        cfg = next(exercise.glob('*.cfg'))

        exercise_tests.append(Exercise(
            pass_=pass_files,
            fail=fail_files,
            solution=solution,
            name=exercise.name,
            cfg=cfg
        ))

    # Print table header before the test loop
    print(f"{'Exercise':<15} {'+ (Pass)':<15} {'- (Fail)':<15}")
    print("-" * 45)

    for test in exercise_tests:
        with TemporaryDirectory() as run_dir:
            
            # Copy config file
            mc_file =  Path(run_dir) / 'Test.tla'
            mc_cfg = Path(run_dir) / 'Test.cfg'
            mc_cfg.write_text(test.cfg.read_text())
            script = f"java -jar {jar_path} -workers auto -metadir {run_dir} -terse -cleanup {mc_file}"
            
            mc_file.write_text(process_tla(test.pass_, test.solution))
            pass_result = subprocess.run(script, text=True, capture_output=True, shell=True)
    

            mc_file.write_text(process_tla(test.fail, test.solution))
            fail_result = subprocess.run(script, text=True, capture_output=True, shell=True)

            print(f"{test.name:<15} {parse_result(pass_result.stdout):<15} {parse_result(fail_result.stdout):<15}")
        

if __name__ == "__main__":
    args = parser.parse_args()
    run_tests(args.tools_path)