#!/usr/bin/perl
use File::Copy;
use File::Compare;


if($ARGV[0] eq "init"){
    init();
    
}
elsif($ARGV[0] eq "add"){
    shift @ARGV;
    add(@ARGV);
    
    
}
elsif($ARGV[0] eq "commit"){
    if($ARGV[1] eq "-m"){
        #commit with commit message
        commit($ARGV[2]);
    }
    elsif($ARGV[1] eq "-a" and $ARGV[2] eq "-m"){
        #add all file in current directory to index
        @allFiles=glob("*");
        @Files= grep(!/legit.pl/, @allFiles);
        
        add(@Files);
        #commit with commit message
        commit($ARGV[3]);
    }
    else{
        print("please print -m or -a")
    }
    
}
elsif($ARGV[0] eq "show"){
    
    show($ARGV[1]);
}
elsif($ARGV[0] eq "log"){
    
    logs($ARGV[1]);
    
}
elsif($ARGV[0] eq "rm"){
    
    shift @ARGV;
    
    if($ARGV[0] eq "--cached"){
        shift @ARGV;
        #remove index
        if($ARGV[0] eq "--force"){
            shift @ARGV;
            remove_cached_force(@ARGV);
        }
        else{
            remove_cached(@ARGV);
        }
    }
    elsif($ARGV[0] eq "--force"){
        shift @ARGV;
        if($ARGV[0] eq "--cached"){
            shift @ARGV;
            remove_force_cached(@ARGV);
        }else{
            remove_force(@ARGV);
        }
        
    }
    else{
        remove(@ARGV);
    }
    
}
elsif($ARGV[0] eq "status"){
    set_status();
    status();
    
}


sub init(){
    if( -d ".legit" ){
        print("legit.pl: error: .legit already exists\n");
        
    }
    else{
        mkdir ".legit";
        if( -e ".legit" and -d ".legit" ){
            mkdir ".legit/index",0755 or warn "can not make fred directory : $!\n";
            mkdir ".legit/deleted",0755 or warn "can not make fred directory : $!\n";
            print("Initialized empty legit repository in .legit\n");
        }
        
    }
}
sub add(){
    
    if(!( -d ".legit" )){
        print("legit.pl: error: no .legit directory containing legit repository exists\n");
        return;
    }
    
    for $i (@_){
        if(-f $i){
            
            copy("$i", ".legit/index/$i") or die "The copy operation failed: $!";
            
            
        }
        elsif(-f ".legit/index/$i"){
            unlink(".legit/index/$i") or die "Could not delete the file!\n";
        }
        else{
            
            print("legit.pl: error: can not open 'non_existent_file'\n");
            return;
            
        }
    }
    
}
sub commit(){
    
    if(!( -d ".legit" )){
        print("legit.pl: error: no .legit directory containing legit repository exists\n");
        return;
    }
    
    opendir (DIR,'.legit/index/')or die "$!";
    my @files1 = grep{!/^\./} readdir(DIR);
    
    opendir (DIR,'.legit/')or die "$!";
    my @list_dir = grep{!/^\./} readdir(DIR)or die "$!";
    
    my $i = scalar @list_dir -2;
    
    if( $i == 0 ){
        
        mkdir ".legit/$i",0755 or warn "can not make fred directory : $!\n";
        
        for my $file1 (@files1){
            if(-f ".legit/index/$file1"){
                
                copy(".legit/index/$file1", ".legit/$i/$file1") or die "The copy operation failed: $!";
            }
        }
        mkdir ".legit/$i/log",0755 or warn "can not make fred directory : $!\n";
        open(FH , '>',".legit/$i/log/log") or die $!;
        print FH $_[0];
        close(FH);
        print("Committed as commit $i\n");
        
    }
    elsif( $i > 0 ){
        
        my $path = $i-1;
        my @files2 = grep{!/log/} glob(".legit/$path/*");
        
        my $count_file1 = scalar @files1;
        my $count_file2 = 0;
        
        for my $file1 (@files1){
               
            if((compare(".legit/index/$file1",".legit/$path/$file1") != 0)){
                $count_file2++;
                
                
            }
             
        }
        my $k = scalar @files2;
        #print("$count_file1 $k $count_file2\n@files2\n");
        if(($count_file1 == $k and $count_file2!=0) or $k!= $count_file1 ){
            mkdir ".legit/$i",0755 or warn "can not make fred directory : $!\n";
            for $file1 (@files1){
                if((-f ".legit/index/$file1")){
                    copy(".legit/index/$file1", ".legit/$i/$file1") or die "The copy operation failed: $!";
                }
            }
            mkdir ".legit/$i/log",0755 or warn "can not make fred directory : $!\n";
            open(FH , '>',".legit/$i/log/log") or die $!;
            print FH $_[0];
            close(FH);
            print("Committed as commit $i\n");
        }
        elsif($k !=0 and $count_file1 == 0 ){
            mkdir ".legit/$i",0755 or warn "can not make fred directory : $!\n";
            mkdir ".legit/$i/log",0755 or warn "can not make fred directory : $!\n";
            open(FH , '>',".legit/$i/log/log") or die $!;
            print FH $_[0];
            close(FH);
            print("Committed as commit $i\n");
        }
        else{
            print("nothing to commit\n");
            
        }
    }
    
    
    else{
        print("nothing to commit\n");
        
    }
    
    
}
sub show(){
    my $f = $_[0];
    if(!( -d ".legit" )){
        print("legit.pl: error: no .legit directory containing legit repository exists\n");
        return;
    }
    if($_[0] =~ /^\:/){
        $f =~ /:(.*)/;
        
        #find the index
        if( -f ".legit/index/$1"){
            
            open(FILE ,'<',".legit/index/$1") or die "$1 can not open ,$!";
            
            while (<FILE>){
                
                print "$_";
                
            }
            
            close(FILE);
        }
        else{
            
            print("legit.pl: error: '$1' not found in index\n");
        }
    }
    else{
        $f =~ /(.*):(.*)/;
        #find the commit
        if(-d ".legit/$1"){
            if(-f ".legit/$1/$2"){
                open(FILE ,'<',".legit/$1/$2") or die "$1 can not open ,$!";
                
                while (<FILE>){
                    
                    print "$_";
                    
                }
                
                close(FILE);
            }
            else{
                
                print("legit.pl: error: '$2' not found in commit $1\n");
            }
        }
        else{
            print("legit.pl: error: unknown commit '$1'\n");
        }
    }
}
sub logs(){
    opendir (DIR,'.legit/')or die "$!";
    my @files1 = grep{/\d/} readdir(DIR)or die "$!";
    
    my $count = @files1;
    my @files1 = sort @files1;
    for(my $i=$count-1;$i>=0;$i--){
        
        if( -d ".legit/$files1[$i]"){
            print("$files1[$i] ");
            if(-f ".legit/$files1[$i]/log/log"){
                open(F,'<',".legit/$files1[$i]/log/log");
                while(<F>){
                    print("$_\n");
                }
                
                close(F);
            }
        }
    }
    
}

sub remove(){
    my @check = @_;
    for my $check_file (@check){
        
        $index_file = ".legit/index/$check_file";
        opendir (DIR,'.legit/')or die "$!";
        my @list_dir = grep{!/^\./} readdir(DIR)or die "$!";
        my $i = scalar @list_dir -3;
        $commited_file = ".legit/$i/$check_file";
        
        if(! -f $check_file or ! -f $index_file){
            print("legit.pl: error: '$check_file' is not in the legit repository\n");
            exit(1);
        }
        if(compare($check_file,$commited_file)!=0 and compare($check_file,$index_file)!=0 and compare($commited_file,$index_file)!=0){
            print("legit.pl: error: '$check_file' in index is different to both working file and repository\n");
            exit(1);
        }
        elsif(compare($check_file,$commited_file)!=0 and compare($check_file,$index_file)!=0 and compare($commited_file,$index_file)==0){
            print("legit.pl: error: '$check_file' in repository is different to working file\n");
            exit(1);
        }
        elsif(compare($check_file,$commited_file)!=0 and compare($check_file,$index_file)==0 and compare($commited_file,$index_file)!=0){
            print("legit.pl: error: '$check_file' has changes staged in the index\n");
            exit(1);
        }
        else{
            copy("$check_file", ".legit/deleted/$check_file") or die "The copy operation failed: $!";
            unlink "$check_file";
            unlink "$index_file";
        }
    }
}
sub remove_cached_force(){
    my @check = @_;
    for my $check_file (@check){
        $index_file = ".legit/index/$check_file";
        if(! -f $check_file or ! -f $index_file){
            print("legit.pl: error: '$check_file' is not in the legit repository\n");
            exit(1);
        }
        
        unlink "$index_file";
    }
}
sub remove_cached(){
    my @check = @_;
    
    for my $check_file (@check){
        $index_file = ".legit/index/$check_file";
        opendir (DIR,'.legit/')or die "$!";
        my @list_dir = grep{!/^\./} readdir(DIR)or die "$!";
        my $i = scalar @list_dir -3;
        $commited_file = ".legit/$i/$check_file";
        
        if(! -f $check_file or ! -f $index_file){
            print("legit.pl: error: '$check_file' is not in the legit repository\n");
            exit(1);
        }
        if(compare($check_file,$commited_file)!=0 and compare($check_file,$index_file)!=0 and compare($commited_file,$index_file)!=0){
        
            print("legit.pl: error: '$check_file' in index is different to both working file and repository\n");
            exit(1);
        }
        unlink "$index_file";
    }
}
sub remove_force_cached(){
    my @check = @_;
    for my $check_file (@check){
        $index_file = ".legit/index/$check_file";
        if(! -f $check_file or ! -f $index_file){
            print("legit.pl: error: '$check_file' is not in the legit repository\n");
            exit(1);
        }
        unlink "$index_file";
    }
}
sub remove_force(){
    my @check = @_;
    for my $check_file (@check){
        $index_file = ".legit/index/$check_file";
        if(! -f $check_file or ! -f $index_file){
            print("legit.pl: error: '$check_file' is not in the legit repository\n");
            exit(1);
        }
        unlink "$check_file";
        unlink "$index_file";
    }
}

sub set_status(){
    opendir (DIR,'.legit/index')or die "$!";
    my @all_files = grep{!/^\./} readdir(DIR);
   
    for my $file (@all_files){
        if (! -f $file){
            copy(".legit/index/$file", ".legit/deleted/$file") or die "The copy operation failed: $!";
        }
    }
    
}
sub status(){
    my @all_files=glob("*");
    @all_files = grep{!/legit.pl/} @all_files;
    
    opendir (DIR,'.legit/deleted')or die "$!";
    my @delete_files = grep{!/^\./} readdir(DIR);
    
    push @all_files,@delete_files;
    
    my @all_files = grep { ++$count{ $_ } < 2; } @all_files;
    my @all_files = sort @all_files;
    for my $file (@all_files){
        
        my $index_file = ".legit/index/$file";
        opendir (DIR,'.legit/')or die "$!";
        my @list_dir = grep{!/^\./} readdir(DIR)or die "$!";
        my $i = scalar @list_dir -3;
        my $commited_file = ".legit/$i/$file";
        
        if(-f $index_file and -f $commited_file and -f $file){
            if(compare($file,$commited_file)!=0 and compare($file,$index_file)!=0 and compare($commited_file,$index_file)!=0){
                print("$file - file changed, different changes staged for commit\n");
            }
            elsif(compare($file,$commited_file)!=0 and compare($file,$index_file)==0 and compare($commited_file,$index_file)!=0){
                print("$file - file changed, changes staged for commit\n");
            }
            elsif(compare($file,$commited_file)!=0 and compare($file,$index_file)!=0 and compare($commited_file,$index_file)==0){
                print("$file - file changed, changes not staged for commit\n");
            }
            else{
                print("$file - same as repo\n");
            }
            
        }
        elsif(! -f $file){
            if(! -f $index_file){
                
                if(-f $commited_file){
                    print("$file - deleted\n");
                }
            }
            else{
                
                print("$file - file deleted\n");
            }
        }
        elsif(-f $file and -f $index_file ){
            print("$file - added to index\n");
        }
        else{
            print("$file - untracked\n");
        }
        
        
        
    }
    
}



