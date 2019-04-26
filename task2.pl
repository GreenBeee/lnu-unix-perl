#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;

my $size = @ARGV;
my $argv_test = $ARGV[0] eq "--test";
my $is_test = ($size == 1 and $argv_test);
if ($size != 1 and not $is_test) {
    print "usage: python task2.py [startedDir]\n";
    print "[startedDir] - started directory\n";
    print "To run tests: perl task1.py --test\n";
    exit(1)
}


sub handle {
    my ($started_dir) = @_;
    my $maxNumber = 0;
    my $maxName = $started_dir;

    use File::Find qw(finddepth);
    my @files;
    finddepth(sub {
        return if ($_ eq '.' || $_ eq '..');
        push @files, $File::Find::name;
    }, $started_dir);
    foreach (@files) {
        if (-d $_) {
            my @filesInDir = glob($_ . "/*");
            my $sizeInDir = @filesInDir;
            if ($sizeInDir > $maxNumber) {
                $maxNumber = $sizeInDir;
                $maxName = $_;
            }
        }
    }
    return($maxName, $maxNumber)
}

if (not $is_test) {
    my ($maxName, $maxNumber) = handle($ARGV[0]);
    print "Max subdir is $maxName with $maxNumber subdirectories\n";
}
else {
    test();
}

sub test {
    my $startedDir = '/Users/admin/PycharmProjects/perl/testSecondTaskForTest';
    mkdir $startedDir;

    print "Create different subdirectories in directory: $startedDir";
    my ($maxNameExpected, $maxNumberExpected) = createSomeFilesInDir($startedDir);

    print "Run method\n";
    my ($maxName, $maxNumber) = handle($startedDir);

    print "Run tests\n";

    if ($maxNameExpected eq $maxName) {
        print "First test runs successfully\n";
    }
    else {
        print "First test failed\n";
    }

    if ($maxNumberExpected eq $maxNumber) {
        print "Second test runs successfully\n";
    }
    else {
        print "Second test failed\n";
    }
    print "Clean up\n";
    removeFilesFromDirectory($startedDir);
}

sub createSomeFilesInDir {
    my ($startedDir) = @_;
    my $sub_1 = $startedDir . "/sub1";
    my $sub_2 = $startedDir . "/sub2";
    my $sub_3 = $startedDir . "/sub3";
    my $sub_4 = $sub_1 . "/sub4";
    my $sub_5 = $sub_1 . "/sub5";
    my $sub_6 = $sub_2 . "/sub6";
    my $sub_7 = $sub_3 . "/sub7";
    my $sub_8 = $sub_3 . "/sub8";
    my $sub_9 = $sub_3 . "/sub9";
    my $sub_10 = $sub_3 . "/sub10";
    my $sub_11 = $sub_4 . "/sub11";
    my $sub_12 = $sub_4 . "/sub12";

    mkdir $sub_1;
    mkdir $sub_2;
    mkdir $sub_3;
    mkdir $sub_4;
    mkdir $sub_5;
    mkdir $sub_6;
    mkdir $sub_7;
    mkdir $sub_8;
    mkdir $sub_9;
    mkdir $sub_10;
    mkdir $sub_11;
    mkdir $sub_12;
    return($sub_3, 4);
}

sub removeFilesFromDirectory {
    my ($dir) = @_;

    use File::Find qw(finddepth);
    my @files;
    finddepth(sub {
        return if ($_ eq '.' || $_ eq '..');
        push @files, $File::Find::name;
    }, $dir);

    foreach (@files) {
        unlink($_);
        if (-d $_) {
            rmdir $_;
        }
    }
    rmdir $dir;
}