function [labels] = createImg()
keys={'AA','AG','AC','AT','GA','GG','GC','GT','CA','CG','CC','CT','TA','TG','TC','TT'};
values={1,17,34,51,68,85,102,119,136,153,170,187,204,221,238,255};
gray_values=containers.Map(keys,values);
Fasta_Files = dir('*.fasta'); 
numfiles = length(Fasta_Files);
for i=1:numfiles
   fid = fopen(Fasta_Files(i).name); 
   row=0;
   tline = fgetl(fid);
   labels(i)=extractBetween(tline,2,length(tline));
   while ~feof(fid)
    tline = fgetl(fid);
    row=row+1;
    for j=1:length(tline)-1
        if isKey(gray_values,strcat(tline(j),tline(j+1)))
            pixel_value=gray_values(strcat(tline(j),tline(j+1)));
        else
            pixel_value=0;
        end
        rgbImage(row,j,:)=[pixel_value,pixel_value,pixel_value];
    end
   end
   fclose(fid);
   PNG_FileName=strcat(extractBetween(Fasta_Files(i).name,1,length(Fasta_Files(i).name)-6),'.png');
   rgbImage=uint8(rgbImage);
   imwrite(rgbImage,PNG_FileName{1},'png');
   clear rgbImage;
end
end