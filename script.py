import sys


def print_help():
    help_message = """
    Usage: script.py [OPTIONS]

    Options:
    -h, --help     Show this help message and exit.
    -t, --task     Perform a basic task.
    """
    print(help_message)


def perform_task():
    print("Performing a basic task...")


if __name__ == "__main__":
    if len(sys.argv) > 1:
        if sys.argv[1] in ['-h', '--help']:
            print_help()
        elif sys.argv[1] in ['-t', '--task']:
            perform_task()
        else:
            print("Unknown option. Use -h or --help for usage information.")
    else:
        print("No arguments provided. Use -h or --help for usage information.")
