rm -R /home/$USER/test_lib
mkdir /home/$USER/test_lib
mkdir /home/$USER/test_lib/src
mkdir /home/$USER/test_lib/src/main
mkdir /home/$USER/test_lib/src/main/java
mkdir /home/$USER/test_lib/src/main/java/com
mkdir /home/$USER/test_lib/src/main/java/com/Converter
cd /home/$USER/test_lib

echo '<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">

    <modelVersion>4.0.0</modelVersion>
    <groupId>com</groupId>
    <artifactId>converter-lib</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.compiler.source>8</maven.compiler.source>
	<maven.compiler.target>8</maven.compiler.target>
    </properties>

</project>
' > "/home/$USER/test_lib/pom.xml"

echo 'package com.Converter;

import java.io.*;
import java.util.*;
//import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.lang.Exception;

public class Converter {

    
    private String[] rawData = null;
    private ArrayList<int[]> data = new ArrayList<int[]>();
    ReentrantLock lock = new ReentrantLock();

    public static void Test() {
        System.out.println("All ready for test!");
    }

    public ArrayList<int[]> StringArray2ListIntArray(String[] indexes) {
        lock.lock();
        try {
            if (rawData != null && rawData.length != 0) {
                throw new Error("Converter was set before!");
            }

            rawData = new String[indexes.length];

	    for(int i = 0; i < indexes.length; i++) {
                rawData[i] = CleanRule(indexes[i]);
                if(!IsRuleCorrect(rawData[i])) {
                    rawData[i] = "";
                    throw new Error("Income data incorrect!");
                }
            }

            SetData();
        }
        finally {
            lock.unlock();
        }

        return data;
    }

    public ArrayList<int[]> GetListIntArray() {
	ArrayList<int[]> result = new ArrayList<int[]>();
	ArrayList<Integer> newResultItem = new ArrayList<Integer>();
        int[] currentId = new int[data.size()];
	
        for(int i = 0; i < currentId.length; i++) {
            currentId[i] = 0;
        }
	
        do {
            for(int i = 0; i < data.size(); i++) {
                newResultItem.add(data.get(i)[currentId[i]]);
            }

            result.add(newResultItem.stream().mapToInt(i -> i).toArray());
            newResultItem.removeAll(newResultItem);

	    currentId = GetNextCurrentId(currentId);
        } while (currentId != null);

        return result;
    }

    public static void Print(ArrayList<int[]> printedData) {
	String message = "Number of arrays: " + printedData.size();
        System.out.println(message);

        for (int[] item : printedData) {
            message = "[";
            boolean isComma = false;
            for(int i : item){
                isComma = true;
                message += i;
                message += ", ";
            }
            if(isComma) {
	        message = message.substring(0, message.length() - 2);
            }
            message += "]";
            System.out.println(message);
        }
    }

    private String CleanRule(String rule) {
        String allowedChar = "0123456789-,";
	    String clearstring = "";
            for(int j = 0; j < rule.length(); j++) {
                if (allowedChar.contains(rule.substring(j, j+1))) {
                    clearstring += rule.substring(j, j+1);
                }
	    }
        return clearstring;
    }

    private boolean IsRuleCorrect(String rule) {
        String allowedChar = "0123456789";
        if (!allowedChar.contains(rule.substring(0,1))) {
            return false;
        }
        if (!allowedChar.contains(rule.substring(rule.length()-1))) {
            return false;
        }
        for(int i = 0; i < rule.length(); i++) {
            if(rule.substring(i, i+1) == "-") {
                if (!allowedChar.contains(rule.substring(i-1, i))) {
                    return false;
                }
                if (!allowedChar.contains(rule.substring(i+1, i+2))) {
                    return false;
                }
            }
        }
        return true;
    }

    private void SetData() {
        for(int i = 0; i < rawData.length; i++) {
            ArrayList<Integer> newData = new ArrayList<Integer>();
            boolean isInterval = false;
            int startIntervalValue = 0;
            int finishIntervalValue = 0;
            int startValueIndex = 0;
            for(int j = 0; j < rawData[i].length(); j++) {
                if (rawData[i].substring(j,j+1).equals("-")) {
                    if (isInterval)
                    {
                        throw new Error("Income data incorrect!");
                    }
                    isInterval = true;
                    startIntervalValue = Integer.parseInt(rawData[i].substring(startValueIndex, j));
                    startValueIndex = j+1;
                } else if (rawData[i].substring(j,j+1).equals(",") && isInterval) {
                    isInterval = false;
                    finishIntervalValue = Integer.parseInt(rawData[i].substring(startValueIndex, j));
		    for (int newDataInt = startIntervalValue; newDataInt <= finishIntervalValue; newDataInt++) {
                        newData.add(newDataInt);
                    }
                    startValueIndex = j+1;
                } else if (rawData[i].substring(j,j+1).equals(",") && !isInterval) {
                    int newDataInt = Integer.parseInt(rawData[i].substring(startValueIndex, j));
                    newData.add(newDataInt);
                    startValueIndex = j+1;
                } else if (j == rawData[i].length() - 1 && isInterval) {
                    isInterval = false;
                    finishIntervalValue = Integer.parseInt(rawData[i].substring(startValueIndex));
		    for (int newDataInt = startIntervalValue; newDataInt <= finishIntervalValue; newDataInt++) {
                        newData.add(newDataInt);
                    }
                    startValueIndex = j+1;
                } else if (j == rawData[i].length() - 1 && !isInterval) {
                    int newDataInt = Integer.parseInt(rawData[i].substring(startValueIndex));
                    newData.add(newDataInt);
                    startValueIndex = j+1;
                } 
            }

            int[] newDataArray = ClearDoubleAndSort(newData);
            data.add(newDataArray);
        }
    }

    private int[] ClearDoubleAndSort(ArrayList<Integer> rawData) {
        ArrayList<Integer> result = new ArrayList<Integer>();
        for (int curInt : rawData) {
            if(!result.contains(curInt)) {
                result.add(curInt);
            }
        }
        result.sort(Comparator.naturalOrder());
        return result.stream().mapToInt(i -> i).toArray();
    }

    private int[] GetNextCurrentId(int[] currentId) {
        boolean ready = false;
        for(int i = (currentId.length - 1); i > -1 && !ready; i--) {
            if (currentId[i] < data.get(i).length-1) {
                currentId[i]++;
                ready = true;
            } else {
                currentId[i]=0;
            }
        }

        if (!ready) {
            currentId = null;
        }

        return currentId;
    }

}
' > "/home/$USER/test_lib/src/main/java/com/Converter/Converter.java"

cd /home/$USER/test_lib

mvn clean package

ls -l /home/$USER/test_lib/target/

mvn install

rm -R /home/$USER/test
mkdir /home/$USER/test
mkdir /home/$USER/test/src
mkdir /home/$USER/test/src/main
mkdir /home/$USER/test/src/main/java
mkdir /home/$USER/test/src/main/java/com
mkdir /home/$USER/test/src/main/java/com/app
cd /home/$USER/test

echo '<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">

    <modelVersion>4.0.0</modelVersion>
    <groupId>com</groupId>
    <artifactId>test</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging>
    <name>test</name>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.compiler.source>8</maven.compiler.source>
	<maven.compiler.target>8</maven.compiler.target>
    </properties>

    <dependencies>
	<dependency>
            <groupId>com</groupId>
            <artifactId>converter-lib</artifactId>
            <version>1.0-SNAPSHOT</version>
        </dependency>
    </dependencies>

<build>
  <plugins>
    <plugin>
      <artifactId>maven-assembly-plugin</artifactId>
      <configuration>
        <archive>
          <manifest>
            <mainClass>com.app.Main</mainClass>
          </manifest>
        </archive>
        <descriptorRefs>
          <descriptorRef>jar-with-dependencies</descriptorRef>
        </descriptorRefs>
      </configuration>
    </plugin>
  </plugins>
</build>

</project>
' > "/home/$USER/test/pom.xml"

echo 'package com.app;

import java.util.ArrayList;

public class Main {
    public static void main(String[] argv) {
        System.out.println("Hello, TeamLead! I`m programm from Sharov Anton! anton_a_sh@yahoo.com");

        try {
            System.out.println("Link library test...");
            com.Converter.Converter.Test();
            System.out.println("Link library test completed!");

	    String[] indexes = new String[] {"1,3-5", "2", "3-4"};
	    test("Smoke test", indexes, false);

            // from -2147483648 to +2147483647
            String[] indexes2 = new String[] {"0", "2147483647"};
            test("Positive border test", indexes2, false);

            System.out.println("Negative reinstallation test...");
            boolean testResult = false;
            try {
                String[] indexes3 = new String[] {"1", "1"};
                com.Converter.Converter converter = new com.Converter.Converter();
                ArrayList<int[]> result3 = converter.StringArray2ListIntArray(indexes3);
                result3 = converter.StringArray2ListIntArray(indexes3);
            } catch (Error er) {
                System.out.println("Error " + er.getMessage());
                testResult = true;
            } catch (Exception ex) {
                System.out.println("Exception " + ex.getMessage());
                testResult = true;
            }
            if (testResult) {
                System.out.println("Reinstallation test success!");
            } else {
                System.out.println("Reinstallation test fail!");
            }


            String[] indexes4 = new String[] {"-1", "1"};
            test("Negative border test", indexes4, true);

            String[] indexes5 = new String[] {"0", "2147483648"};
            test("Second negative border test", indexes5, true);

            String[] indexes6 = new String[] {"1--2", "1"};
            test("Negative spelling error test", indexes6, true);

        }
        catch (Error er) {
            System.out.println(er.getMessage());
        }
        catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
    }

    private static void test(String testName, String[] indexes, boolean isNegative) {
        boolean testResult = !isNegative;        
        try {
            System.out.println(testName + "...");
            com.Converter.Converter converter = new com.Converter.Converter();
            ArrayList<int[]> result1 = converter.StringArray2ListIntArray(indexes);
            System.out.println("first result:");
	    com.Converter.Converter.Print(result1);
	    ArrayList<int[]> result2 = converter.GetListIntArray();
            System.out.println("second result:");
	    com.Converter.Converter.Print(result2);
            System.out.println(testName + " completed!");
        } catch (Error er) {
            System.out.println("Error " + er.getMessage());
            testResult = isNegative;
        } catch (Exception ex) {
            System.out.println("Exception " + ex.getMessage());
            testResult = isNegative;
        }
        if (testResult) {
            System.out.println(testName + " success!");
        } else {
            System.out.println(testName + " fail!");
        }
    }
}
' > "/home/$USER/test/src/main/java/com/app/Main.java"

cd /home/$USER/test

mvn clean compile assembly:single

ls -l /home/$USER/test/target/
java -cp /home/$USER/test/target/test-1.0-SNAPSHOT-jar-with-dependencies.jar com.app.Main
