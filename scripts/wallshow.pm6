use v6;

sub MAIN( Str $wallpapers_directory? = "~/Backgrounds/",
    Int $changing_interval? = 5,
    Bool :v(:$version)
    ) { 
    	 if ($version) {
	    say('wallshow v1.0');
	    exit 0;
    	 }
	 change_background_wallpaper($changing_interval, $wallpapers_directory);
}

sub USAGE(){
print Q:c:to/EOH/; 
Usage: wallshow [OPTIONS] <wallpapers-directory> <changing-interval>
    Utility for changing the background's wallpaper periodically.
Arguments:
    wallpapers-directory	Specify the directory containing the wallpapers 
				to use. (Default: ~/Backgrounds)
    changing-interval		Specify the interval for changing the 
				background's wallpaper. (Default: 5 minutes)
    
Options:
    -v, --version		Prints the current version.	
EOH
}

sub get_real_path ($wallpapers_directory) {
    return chomp QX("readlink -f $wallpapers_directory");
}

sub get_wallpapers ($wallpapers_directory) {
    my $list_wallpapers = QX("ls -p $wallpapers_directory | grep -v /");
    return my @wallpapers_to_use = grep { /\S/ }, split("\n", $list_wallpapers);
}

sub change_background_wallpaper ($changing_interval, $wallpapers_directory) {
   my $real_path = get_real_path($wallpapers_directory);
   my @wallpapers_to_use = get_wallpapers($wallpapers_directory);

   run('nitrogen', '--restore');

   sleep($changing_interval * 60);

   while (1 > 0) {
       for @wallpapers_to_use -> $wallpaper {
       	   run('nitrogen', '--set-auto', "$real_path/$wallpaper");
	   sleep($changing_interval * 60);
       } 	 
   }
}
