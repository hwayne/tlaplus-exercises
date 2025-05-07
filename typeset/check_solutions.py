"""
A quick script that tests that all of the exercise solutions are correct

Written in part with Claude
"""
import re
from tempfile import TemporaryDirectory # For state cleanup
from pathlib import Path
import argparse
import asyncio


def process_tla(source: Path, solution: str) -> str:
    content = source.read_text()
    
    content = re.sub(
        r'Typeset.+\s*==\s*[^\n]+',
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

async def run_tlc_process(script: str):
    proc = await asyncio.create_subprocess_shell(
        script,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
        shell=True
    )
    stdout, stderr = await proc.communicate()
    return stdout.decode()

parser = argparse.ArgumentParser()
parser.add_argument("--tools_path", 
                    default=r"D:/software/TLA+/tla2tools.jar", # Default to my computer's toolpath for now
                    help="Path to tla2tools.jar")
parser.add_argument("spec", nargs="?", help="Optional name of a specific spec to test")

def get_exercise_files(spec_name=None) -> list[Path]:
    root = Path(__file__).parent
    if spec_name:
        # If a specific spec is requested, look for it
        files = list(root.glob(f"**/{spec_name}.tla"))
        if not files:
            print(f"Warning: No specification file found with name '{spec_name}'")
        return files
    else:
        # Otherwise return all TLA files
        return list(root.glob("**/*.tla"))

async def run_test(exercise, jar_path, temp_dir_base, semaphore):
    # Use semaphore to limit concurrent execution
    async with semaphore:
        solution_file = Path(__file__).parent / '_solutions' / f'{exercise.stem}.txt'
        if not solution_file.exists():
            return None
            
        solution = Path(solution_file).read_text()
        
        # Create a unique directory for each test
        run_dir = Path(temp_dir_base) / f"test_{exercise.stem}"
        run_dir.mkdir()
        
        mc_file = run_dir / 'Test.tla'
        mc_cfg = run_dir / 'Test.cfg'
        mc_cfg.write_text("SPECIFICATION Spec")
        script = f"java -jar {jar_path} -workers 1 -metadir {run_dir} -terse -cleanup {mc_file} -fpmem 20"
        
        mc_file.write_text(process_tla(exercise, solution))
        result = await run_tlc_process(script)
        
        # Return a tuple with exercise name and result status
        return (exercise.stem, parse_result(result))

async def run_tests_async(jar_path, spec_name=None):
    exercises = get_exercise_files(spec_name)
    results = []
    
    # Create a semaphore limiting to 5 concurrent tasks
    semaphore = asyncio.Semaphore(5)
    
    with TemporaryDirectory() as base_dir:
        # Create tasks for all exercises that have solution files
        tasks = []
        for exercise in exercises:
            tasks.append(run_test(exercise, jar_path, base_dir, semaphore))
        
        # Wait for all tasks to complete
        results = await asyncio.gather(*tasks)
        
        # Filter out None results (exercises without solutions)
        results = [r for r in results if r is not None]
    
    # Print results after all tests have finished
    print(f"{'Exercise':<15} {'+ (Pass)':<15}")
    print("-" * 30)
    for name, status in results:
        print(f"{name:<15} {status:<15}")
    
    if spec_name and not results:
        print(f"No solution found for '{spec_name}'")

def run_tests(jar_path, spec_name=None):
    return asyncio.run(run_tests_async(jar_path, spec_name))

if __name__ == "__main__":
    args = parser.parse_args()
    run_tests(args.tools_path, args.spec)

