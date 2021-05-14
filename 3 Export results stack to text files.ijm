
//Select directories containing TIFs.

source_dir = getDirectory("Select source directory")
output_dir = getDirectory("Select output directory")
file_list = getFileList(source_dir);
setBatchMode(true);

//Loop through only files beginning with Result.
for(a=0; a<file_list.length; a++){
	if(startsWith(file_list[a],  "Result")){
		open(source_dir + file_list[a]);


//Scroll through channels and save.
saveAs("Text Image", output_dir + file_list[a] + "-cells.txt");
run("Next Slice [>]");
saveAs("Text Image", output_dir + file_list[a] + "-gfp-area.txt");
run("Next Slice [>]");
saveAs("Text Image", output_dir + file_list[a] + "-gfp-mean.txt");
run("Next Slice [>]");
saveAs("Text Image", output_dir + file_list[a] + "-gfp-max.txt");
close();
	}
}