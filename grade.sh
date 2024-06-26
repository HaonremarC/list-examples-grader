CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'
#!/bin/bash

# Clean up any previous submissions and grading areas
rm -rf student-submission
rm -rf grading-area

# Create the grading area
mkdir grading-area

# Clone the student's repository
git clone $1 student-submission
echo 'Finished cloning'

# Check if the required file exists
if [[ ! -f student-submission/ListExamples.java ]]; then
  echo "ListExamples.java not found in the repository. Please check the submission."
  exit 1
fi

# Copy the student's file and the test file to the grading area
cp student-submission/ListExamples.java grading-area/
cp TestListExamples.java grading-area/

# Navigate to the grading area
cd grading-area

# Set the CLASSPATH environment variable to include JUnit JAR files
export CLASSPATH=".:../lib/hamcrest-core-1.3.jar:../lib/junit-4.13.2.jar"

# Print the current directory and its contents for debugging
echo "Current directory: $(pwd)"
echo "Contents of grading-area:"
ls -l

# Compile the code
javac ListExamples.java TestListExamples.java 2> compile_errors.txt
if [[ $? -ne 0 ]]; then
  echo "Compilation failed. See compile_errors.txt for details."
  cat compile_errors.txt
  exit 1
fi

# Run the tests
java org.junit.runner.JUnitCore TestListExamples > test_output.txt

# Check the results
TEST_OUTPUT=$(cat test_output.txt)
if grep -q "FAILURES!!!" test_output.txt; then
  echo "Some tests failed."
  echo "$TEST_OUTPUT"
else
  echo "All tests passed."
  echo "$TEST_OUTPUT"
fi

