import os     # Python file path utils
import random # for shuffling an array of file paths

# paths: an array of filepath strings eg. "./images"
# valid_file_extensions: an array of valid file extensions eg. ".tif", ".jpg" etc.
def files(paths, valid_file_extensions):
    outlist = []	
    for path in paths:
        for (root, directories, filenames) in os.walk(str(path)):
            for filename in filenames:
                _, ext = os.path.splitext(filename)
                if ext in valid_file_extensions:
                    outlist.append( os.path.join(root, filename) )
    print('outlist: ', outlist)
    return outlist

# paths: an array of filepath strings eg. "./images"
# valid_file_extensions: an array of valid file extensions eg. ".tif", ".jpg" etc.
def files_random(paths, valid_file_extensions):
    got_files = files(paths, valid_file_extensions)
    random.shuffle(got_files)
    random.shuffle(got_files)
    return files 
