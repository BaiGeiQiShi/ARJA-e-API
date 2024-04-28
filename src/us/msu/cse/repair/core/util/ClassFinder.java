package us.msu.cse.repair.core.util;

import java.io.File;
import java.io.IOException;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

import java.net.URL;
import java.net.URLClassLoader;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.Iterator;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.SuffixFileFilter;
import org.apache.commons.io.filefilter.TrueFileFilter;

public class ClassFinder {
	Set<String> binJavaClasses;
	Set<String> binExecuteTestClasses;
	Set<String> binAbstractTestClasses;

	Set<String> dependences;

	private String binJavaDir;
	private String binTestDir;

	public ClassFinder(String binJavaDir, String binTestDir, Set<String> dependences)
			throws ClassNotFoundException, IOException {
		this.binJavaDir = binJavaDir;
		this.binTestDir = binTestDir;
		this.dependences = dependences;

		List<String> tempList = new ArrayList<String>();
		tempList.add(binJavaDir);
		tempList.add(binTestDir);
		if (dependences != null)
			tempList.addAll(dependences);

		URL urls[] = Helper.getURLs(tempList);

		URLClassLoader classLoader = new URLClassLoader(urls);

		binExecuteTestClasses = new HashSet<String>();
		binAbstractTestClasses = new HashSet<String>();
		binJavaClasses = new HashSet<String>();

		scanTestDir(classLoader);
		scanJavaDir();

		//Get catena4j executed test classes
		List<String> commandList = new ArrayList<String>();
		commandList.add("timeout");
		commandList.add("-s");
		commandList.add("9");
		commandList.add("600");
		commandList.add("catena4j");
		commandList.add("export");
		commandList.add("-p");
		commandList.add("tests.all");

		ProcessBuilder prob = new ProcessBuilder(commandList);
		Process process = prob.start();

		String output = convertStreamToStr(process.getInputStream());
		String[] testedClasses = output.split("\n");
		Iterator<String> iter = binExecuteTestClasses.iterator();
		while(iter.hasNext()){
			boolean iscontains = false;
			String next = iter.next();
			for(String testedClass : testedClasses){
				if( next.equals(testedClass)){
					iscontains = true;
				}
			}
			if(!iscontains){
				iter.remove();
			}
		}

		//Check output
		for (String binExecuteTestClass : binExecuteTestClasses){
			System.out.println(binExecuteTestClass);
		}


		classLoader.close();

	}

	public ClassFinder(String binJavaDir, String binTestDir) throws ClassNotFoundException, IOException {
		this.binTestDir = binTestDir;
		this.binJavaDir = binJavaDir;

		URL testURL = new File(binTestDir).toURI().toURL();
		URL javaURL = new File(binJavaDir).toURI().toURL();

		URLClassLoader classLoader = new URLClassLoader(new URL[] { testURL, javaURL });

		binExecuteTestClasses = new HashSet<String>();
		binAbstractTestClasses = new HashSet<String>();
		binJavaClasses = new HashSet<String>();

		scanTestDir(classLoader);
		scanJavaDir();

		classLoader.close();
	}

	void scanTestDir(URLClassLoader classLoader) throws ClassNotFoundException {
		Collection<File> files = FileUtils.listFiles(new File(binTestDir), new SuffixFileFilter(".class"),
				TrueFileFilter.INSTANCE);

		File dir = new File(binTestDir);

		for (File file : files) {
			String relative = dir.toURI().relativize(file.toURI()).getPath();

			String temp = relative.replace("/", ".");
			String className = temp.substring(0, temp.length() - 6);

			Class<?> target = classLoader.loadClass(className);

			if (JUnitIdentifier.isJUnitTest(target)) {
				if (!Helper.isAbstractClass(target))
					binExecuteTestClasses.add(className);
				else
					binAbstractTestClasses.add(className);
			}
		}
	}

	void scanJavaDir() throws ClassNotFoundException {
		File dir = new File(binJavaDir);
		
		Collection<File> files = FileUtils.listFiles(dir, new SuffixFileFilter(".class"),
				TrueFileFilter.INSTANCE);

		for (File file : files) {
			String relative = dir.toURI().relativize(file.toURI()).getPath();

			String temp = relative.replace("/", ".");
			String className = temp.substring(0, temp.length() - 6);

			if (!binExecuteTestClasses.contains(className) && !binAbstractTestClasses.contains(className))
				binJavaClasses.add(className);
		}
	}

	public Set<String> findBinExecuteTestClasses() {
		return this.binExecuteTestClasses;
	}

	public Set<String> findBinJavaClasses() {
		return this.binJavaClasses;
	}

	public String convertStreamToStr(InputStream is) throws IOException {
        	if (is != null) {
            	Writer writer = new StringWriter();
            	char[] buffer = new char[1024];
            	try {
                	Reader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
                	int n;
                	while ((n = reader.read(buffer)) != -1) {
                    		writer.write(buffer, 0, n);
                	}
            	} catch (UnsupportedEncodingException e) {
                	e.printStackTrace();
            	} catch (IOException e) {
                	e.printStackTrace();
            	} finally {
                	is.close();
            	}
            		return writer.toString();
        	} else {
            		return "";
        	}
    	}

}
