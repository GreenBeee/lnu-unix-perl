#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;

my $size = @ARGV;
my $argv_test = $ARGV[0] eq "--test";
my $is_test = ($size == 1 and $argv_test);
if ($size != 4 and not $is_test) {
    print "usage: ./task1.py [startedDir] [filesCount] [threshold] [endDir]\n";
    print "[startedDir] - started directory\n";
    print "[filesCount] - count of files\n";
    print "[threshold] - threshold size of file in byte\n";
    print "[endDir] - directory, where all files that don\'t pass threshold will be copied\n";
    print "To run tests: perl task1.py --test\n";
    exit(1)
}


sub handle {
    my ($started_dir, $files_count, $threshold, $end_dir) = @_;
    my $counter = 0;
    my @files = glob($started_dir . "/*");
    foreach (@files) {
        if (-s $_ <= $threshold and $counter < $files_count) {
            $counter++;
        }
        else {
            rename($_, $end_dir . "/" . basename($_));
        }
    }
}

if (not $is_test) {
    handle($ARGV[0], $ARGV[1], $ARGV[2], $ARGV[3]);
}
else {
    test();
}

sub test {
    my $startedDir = '/Users/admin/PycharmProjects/tasks/test';
    my $filesCount = 2;
    my $threshold = 1;
    my $endDir = '/Users/admin/PycharmProjects/tasks/testOutput';
    my $emptyFilesCount = 4;
    my $fullFilesCount = 3;

    print "Create " . $emptyFilesCount . " empty files and "
        . $fullFilesCount . " files with text in directory: " . $startedDir . "\n";

    createFilesInDir($startedDir, $emptyFilesCount, $fullFilesCount);

    print "Run method\n";
    handle($startedDir, $filesCount, $threshold, $endDir);

    print "Run tests\n";

    my @files = glob($startedDir . "/*");
    my $sizeInTestDir = @files;
    if ($sizeInTestDir == $filesCount) {
        print "First test runs successfully\n";
    }
    else {
        print "First test failed\n";
    }
    my @filesInEndDir = glob($endDir . "/*");
    my $sizeInEndDir = @filesInEndDir;

    if ($sizeInEndDir == $emptyFilesCount + $fullFilesCount - $filesCount) {
        print "Second test runs successfully\n";
    }
    else {
        print "Second test failed\n";
    }
    print "Clean up\n";
    removeFilesFromDirectory($startedDir);
    removeFilesFromDirectory($endDir);
}

sub createFilesInDir {
    my ($startedDir, $emptyFiles, $fullFiles) = @_;
    for (my $i = 0; $i < $emptyFiles; $i = $i + 1) {
        open my $fileHandle, ">>", "$startedDir/emptyFile$i.txt" or die "Can't open '$startedDir/emptyFile$i.txt'\n";
        close $fileHandle;
    }
    for (my $i = 0; $i < $fullFiles; $i = $i + 1) {
        open my $fileHandle, ">>", "$startedDir/fullFile$i.txt" or die "Can't open '$startedDir/fullFile$i.txt'\n";
        print $fileHandle "Some data that has more than 1 byte";
        close $fileHandle;
    }
}

sub removeFilesFromDirectory {
    my ($dir) = @_;
    my @files = glob($dir . "/*");
    foreach (@files) {
        unlink($_);
    }
}