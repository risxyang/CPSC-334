//program executing unix commands
//referenced from jeff thompson https://github.com/jeffThompson/ProcessingTeachingSketches/blob/master/Utilities/RunUnixCommands/RunUnixCommands.pde

import java.io.InputStreamReader;

void setup() {

  //String commandToRun = "whoami";
  String commandToRun ="afplay /Users/christineyang/Documents/*F21/CES/PySynth/danube.wav";

  File workingDir = new File(sketchPath(""));   // where to do it - should be full path
  String returnedValues;                        // value to return any results

  // give us some info:
  println("Running command: " + commandToRun);
  println("Location:        " + workingDir);
  println("---------------------------------------------\n");

  // run the command!
  try {
    Process p = Runtime.getRuntime().exec(commandToRun, null, workingDir);

    // variable to check if we've received confirmation of the command
    int i = p.waitFor();

    // if we have an output, print to screen
    if (i == 0) {

      // BufferedReader used to get values back from the command
      BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));

      // read the output from the command
      while ( (returnedValues = stdInput.readLine ()) != null) {
        println(returnedValues);
      }
    }

    // if there are any error messages but we can still get an output, they print here
    else {
      BufferedReader stdErr = new BufferedReader(new InputStreamReader(p.getErrorStream()));

      // if something is returned (ie: not null) print the result
      while ( (returnedValues = stdErr.readLine ()) != null) {
        println(returnedValues);
      }
    }
  }

  // if there is an error, let us know
  catch (Exception e) {
    println("Error running command!");  
    println(e);
    // e.printStackTrace();    // a more verbose debug, if needed
  }

  // when done running command, quit
  println("\n---------------------------------------------");
  println("DONE!");
  exit();
}
