package com.chatroom.web.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

public class FileUtil {

    public static void writeFileTOLocal(String path, byte[] filebyte) throws IOException {
        File file = new File(path);
        FileOutputStream fos = null;
        try {
            if (!file.exists()) {
                file.createNewFile();
            }
            fos = new FileOutputStream(file);

            fos.write(filebyte);
        } catch (IOException e) {
            throw new IOException(e);
        } finally {
            if (fos != null) {
                fos.close();
            }
        }
    }
}
