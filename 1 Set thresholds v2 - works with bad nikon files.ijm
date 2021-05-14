if(isOpen("Results")){
	selectWindow("Results");
	run("Close");
}
close("*");
run("Bio-Formats Macro Extensions");
in_dir = getDirectory("Select input directory:");
file_list = getFileList(in_dir);
setBatchMode(true);

for(a=0; a<file_list.length; a++){
	if(endsWith(file_list[a],  ".nd2")){
		run("Bio-Formats Importer", "open=[" + in_dir + file_list[a] + "] autoscale color_mode=Composite concatenate_series open_all_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		rename(file_list[a]);
		run("Split Channels");
		selectWindow("C1-" + file_list[a]);
		resetMinAndMax();
		setBatchMode("show");
		setAutoThreshold("Default dark stack");
		run("Threshold...");
		waitForUser("Please adjust threshold");
		getThreshold(lower, upper);
		if(getBoolean("Process this image?")){
			setResult("Directory", nResults, in_dir);
			setResult("File", nResults-1, file_list[a]);
			setResult("Lower", nResults-1, lower);
			setResult("Upper", nResults-1, upper);
			updateResults();
		}
		close("*");
	}
}

saveAs("Results", in_dir + "Sample thresholds.csv");