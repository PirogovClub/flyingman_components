class utils {
  void createExternalStoragePrivateFile() {
    // Create a path where we will place our private file on external
    // storage.
    File file = new File(getExternalFilesDir(null), "DemoFile.jpg");

    try {
      // Very simple code to copy a picture from the application's
      // resource into the external file.  Note that this code does
      // no error checking, and assumes the picture is small (does not
      // try to copy it in chunks).  Note that if external storage is
      // not currently mounted this will silently fail.
      InputStream
    is = getResources().openRawResource(R.drawable.balloons);
    OutputStream os = new FileOutputStream(file);
    byte[] data = new byte[is.available()];
    is.read(data);
    os.write(data);
    is.close();
    os.close();
    } catch (IOException e) {
    // Unable to create file, likely because external storage is
    // not currently mounted.
    Log.w("ExternalStorage", "Error writing " + file, e);
    }
  }
}