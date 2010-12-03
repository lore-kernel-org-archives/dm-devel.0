From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 0 of 15] DM RAID: a wrapper target for MD RAID456
Date: Fri, 03 Dec 2010 13:53:19 -0600
Message-ID: <1291406002.32354.6.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-+ApX7dhgxqZR0Qozd5Xn"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--=-+ApX7dhgxqZR0Qozd5Xn
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

The forthcoming patches are the second iteration (3rd when including
Neil's original drop) of the DM -> MD translation module, "dm-raid".
There have been some minor changes to some of the 9 patches I posted
last time, so I'm just including all of them along with the new patches
I have.
MD patch reversals and fixes (these can go upstream now):
	md-backout-dm-dirty-log.patch
	md-minor-updates.patch
	md-fix-null-pointer-deref.patch
dm-raid module (some reworking of Neil's original patches):
	dm-raid-seed-module.patch
	dm-target-callbacks-and-congestion-fn.patch
	dm-unplug-callback.patch
	dm-raid-iterate_devices-and-io_hints.patch
	dm-raid-suspend-and-resume-fns.patch
	dm-raid-message-fn.patch
New patches for support of separate metadata devices:
	md-new-param-to-calc_dev_sboffset.patch
	md-new-param-to_sync_page_io.patch
	md-separate-meta-and-data-devs.patch
	dm-raid-allow-metadata-devices.patch
	md-new-superblock-type.patch
	md-add-bitmap-support.patch

So far, the metadata stuff (superblock and bitmaps) is partially working.
The work I'm suffering on right now is the bitmap work.  The bitmap is
being created and updated, but I don't know why it is not being consulted
when the array is activated.  For example, if I kill a machine in the 
middle of write operations, I would expect the bitmap to show that there
is some recovery work to be done, but it does not.  So, I have yet to
figure this out.

I've included below a document that describes some of the dm-raid
design and some of the additional work that remains.  I've also attached 
a script that can be used to create RAID devices through device-mapper 
after the kernel patches have been compiled and built.

If your going to start testing, the non-persistent metadata cases should
be pretty solid.  The persistent metadata cases should work except for
full bitmap support.

 brassow


** preliminary design/descriptive doc **

The dm-raid.c code provides a why to access the functionality of MD
through device-mapper.  This allows us to create RAID4/5/6 (and possibly
MD's RAID1) through device-mapper.  Some of the difficult things to get
straight are translating device-mapper's CTR arguments into the proper
MD settings and making sure we are able to access and configure MD's
various options (recovery speed, write_back settings, etc).  The current
proposed dm-raid CTR arguments are:

	The standard first three device-mapper table arguments, where
	the target_type field is "raid"
		<start> <len> raid \

	This is followed by the parameters that specify the RAID type
	and that RAID type's required and optional arguments.
		<raid_type> <#raid_params> <raid_params> \
	The required arguments for each RAID type may be different.
	Currently, they are ('*' indicates currently unsupported RAID):
		*raid1   <#parms> <chunk_size>
		raid4    <#parms> <chunk_size> <rebuild_A>
		raid5_la <#parms> <chunk_size> <rebuild_A>
		raid5_ra <#parms> <chunk_size> <rebuild_A>
		raid5_ls <#parms> <chunk_size> <rebuild_A>
		raid5_rs <#parms> <chunk_size> <rebuild_A>
		raid6_zr <#parms> <chunk_size> <rebuild_A> <rebuild_B>
		raid6_nr <#parms> <chunk_size> <rebuild_A> <rebuild_B>
		raid6_nc <#parms> <chunk_size> <rebuild_A> <rebuild_B>
	Chunk size is in sectors and the 'rebuild' arguments are used to
	specify that a new device has been added to the array and must
	be rebuilt by parity calculations (or copying if RAID1).  The
	'rebuild' arguments are specified as an index of the array
	elements.
	**FIXME: I'd like to remove the 'rebuild' arguments as required
		 arguments and make them optional - specified as
		 'rebuild=<dev index>'.
	Optional arguments include ('*' indicates not implemented):
		[[no]sync]	Force/Prevent RAID initialization 
		*[write_back=<int>]
		*[daemon_sleep=<int>]
		*[stripecache=<int>]
		*[minspeed=<int>]
		*[maxspeed=<int>]
		**[rebuild=<idx>]	**if moved from required args

	Finally, we have the devices that compose the RAID array.  Each
	array element is given as a metadata device and data device pair.
	If there is no metadata device, a '-' is given for the metadata
	device argument.  If a device is known to have failed, a '- -'
	pair can be specified indicating that there is no data or 
	metadata device available for that position in the array.
	#raid_devs refers to the number of pairings.
		<#raid_devs> { <meta_dev1> <dev1> .. <meta_devN> <devN> }


When translating the device-mapper CTR arguments to MD settings, there
are three arguments that /must/ be set by device-mapper (dm-raid.c) at
CTR time.  They are:

* mddev->recovery_cp:
Determines the initialization state of the array.  The value determines
how far the array has processed the initial recovery.  (Initial recovery
can be parity calculation for RAID456 or copying drives for RAID1.)

* rdev->flags/In_sync:
Determines the state of an individual device.  If !In_sync, then the
device needs to be rebuilt - until then, it is not a useful member
of the array.

* rdev->recovery_offset:
Like mddev->recovery_cp, only for a single device.

Note that even if the array has not yet been initialized, the 
rdev->flags/In_sync bit is still set if the drives are healthy.  If the
array has not been initialized, you would not want to have a device that
is not 'In_sync'.  This is because no trustworthy recovery could occur
for the device because the array had not yet reached a coherent state.

From dm-raid.c, the CTR arguments that control the above are '[no]sync'
and the rebuild parameters.  There is also a slight difference in
behavior depending on whether metadata devices are specified or not.
When there are no metadata devices specified, we won't be able to tell
if the array was shutdown cleanly, so we must assume recovery_cp = 0.
If there is metadata, we will be able to find out if the array was
shutdown cleanly, so we can set 'recovery_cp = MaxSector' and let the
settings change if the metadata requires it.

Translations when metadata devices are not specified:
					[ per device setings  ]
nosync	sync	rebuild | recovery_cp	In_sync	recovery_offset
------------------------|-------------------------------------
0	0	0	| 0		1	MaxSector
0	0	1	| 0		0	0 (INVALID)
0	1	0	| 0		1	MaxSector
0	1	1	| 0		0	0 (INVALID)
1	0	0	| MaxSector	1	MaxSector
1	0	1	| MaxSector	0	0

Translations when metadata devices are specified:
					[ per device setings  ]
nosync	sync	rebuild | recovery_cp	In_sync	recovery_offset
------------------------|-------------------------------------
0	0	0	| MaxSector	1	MaxSector
0	0	1	| MaxSector	0	0
0	1	0	| 0		1	MaxSector
0	1	1	| 0		0	0 (INVALID)
1	0	0	| MaxSector	1	MaxSector
1	0	1	| MaxSector	0	0



--=-+ApX7dhgxqZR0Qozd5Xn
Content-Disposition: attachment; filename=gime_raid.pl
Content-Type: application/x-perl; name=gime_raid.pl
Content-Transfer-Encoding: 7bit

#!/usr/bin/perl -w

$name="raid";
$raid_type="";
$mdp="none";
$sync="";
$chunk_size="";
$device_size="";
$chunk_size_bb = 2048; # 1M (2048 * 512)
$device_size_bb = 0;   # As large as possible
@devices = ();
@rebuild = ();

##
# MAIN
##
foreach (@ARGV) {
	($a, $b) = split(/=/, $_);

	for ($a) {
		(/help/ || /-h/) && do { &usage(); exit(0); };
		(/^raid[1456]/) && do { $raid_type=$a; last; };
		(/^rebuild$/) && do { @rebuild = (@rebuild, $b); last; };
		(/^sync$/ || /^nosync$/) && do { $sync = $a; last; };
		(/^chunk_size$/) && do { $chunk_size = $b; last; };
		(/^size$/) && do { $device_size = $b; last; };
		(/^mdp$/) && do { $mdp = $b; last; };

		(-b $a) && do { @devices = (@devices, $a); last; };

		die "Unknown argument: $a\n";
	}
}

&verify_args();
&print_specs();
&build_raid();

exit(0);


##
# SUB-ROUTINES
##
sub usage()
{
	print "$0 <raid_type> [options] <dev1> .. <devN>\n";
	print "RAID types:\n";
	print "  raid4\n";
	print "  raid5 (raid5_la* raid5_ra raid5_ls raid5_rs)\n";
	print "  raid6 (raid6_zr* raid6_nr raid6_cr)\n";
	print "Options:\n";
	print "  [no]sync          Force either sync or no sync\n";
	print "  chunk_size=<arg>  Specify chunk size.  Default: 1M\n";
	print "  rebuild=<arg>     Index of drive needing rebuild.\n";
	print "  mdp=<arg>         none*, start, middle, or end.\n";
}

sub shorthand_to_bb ($)
{
	my $str = shift;
	my $bb = 0;
	my @suf = ("-", "k", "M", "G", "T");

	if (!($str =~ /^(\d+)(\w*)$/)) {
		die "Unable to parse argument, $str\n";
	}
	$bb = $1;

	for ($i = 0; $2 && (exists $suf[$i]) && ($suf[$i] ne $2); $i++) {}

	$bb *= 2**(10 * $i);

	# Convert to BB
	$bb /= 512;

	return $bb;
}

sub max ($$) { $_[$_[0] < $_[1]] }
sub min ($$) { $_[$_[0] > $_[1]] }

sub calc_max_device_bb ($)
{
	my $rt = shift;
	my $min_bb = 0;
	my $bb;

	foreach (@devices) {
		$bb = `blockdev --getsz $_`;
		chomp $bb;
		$min_bb = ($min_bb) ? min($min_bb, $bb) : $bb;
	}

	if ($mdp ne "none") {
		$min_bb -= 2048;  # 1MB reserve for Metadata
	}

	if ($rt eq "raid1") {
		return $min_bb;
	}

	if ($rt =~ /raid6/) {
		return $min_bb * (@devices - 2);
	}

	return $min_bb * $#devices;
}

sub make_good_size($)
{
	my $o1 = shift;
	my $n1 = $o1;

	if ($o1 > calc_max_device_bb($raid_type)) {
		die "Specified device size too large for devices.\n";
	}

	if ($raid_type =~ /raid6/) {
		$n1 /= (@devices - 2);
		$n1 = int($n1);
		$n1 *= (@devices - 2);
	}		

	if ($raid_type =~ /raid5/) {
		$n1 /= (@devices - 1);
		$n1 = int($n1);
		$n1 *= (@devices - 1);
	}		

	if ($o1 != $n1) {
		print "Size adjusted $o1 -> $n1\n";
	}
	return $n1;
}

sub verify_args()
{
	my $i;
	my $tmp = 0;

	if (!$raid_type) {
		die "Supported RAID type not specified.\n";
	}

	if ($raid_type =~ /^raid5$/) {
		# Need to pick an algorithm for them
		$raid_type = "raid5_la";
	}

	if ($raid_type =~ /^raid6$/) {
		# Need to pick an algorithm for them
		$raid_type = "raid6_zr";
	}

	if ($mdp !~ /none|start|middle|end/) {
		die "Persistent metadata not supported\n";
	}

	if (!@devices) {
		die "No valid block devices given.\n";
	}

	$tmp = ($raid_type =~ /raid6/) ? 2 : ($raid_type eq raid1) ? 0 : 1;
	if ($tmp < @rebuild) {
		die "RAID type \"$raid_type\" cannot rebuild that many drives\n";
	}
	for ($i = 0; $i < $tmp; $i++) {
		if (! exists $rebuild[$i]) {
			$rebuild[$i] = -1;
			next;
		}
		if (($rebuild[$i] < 0) || (! exists $devices[$rebuild[$i]])) {
			die "Bad rebuild index\n";
		}
	}

	if ($chunk_size) {
		$tmp = shorthand_to_bb($chunk_size);
		die "Bad chunk_size\n" unless ($tmp > 0);

		# FIXME: check size and power of 2
		$chunk_size_bb = $tmp;
	}

	if ($device_size) {
		$tmp = shorthand_to_bb($device_size);
		die "Bad device size argument\n" unless ($tmp > 0);

		$device_size_bb = make_good_size($tmp);
	}

	if (!$device_size_bb) {
		$device_size_bb = calc_max_device_bb($raid_type);
		$device_size = "${device_size_bb}BB";
	}
}

sub print_specs()
{
	print "RAID type    : $raid_type\n";
	print "Block devices: @devices\n";
	foreach (@rebuild) {
		print "Rebuilding   : $devices[$_]\n" unless ($_ == -1);
	}
	($sync) && print "Sync         : $sync\n";
	print "Chunk size   : $chunk_size\n" unless (!$chunk_size);
	print "Device size  : $device_size\n";
	print "MDP          : $mdp\n" unless ($mdp eq "none");
	print "\n";
}

sub create_device($$)
{
	my ($name, $table) = @_;

	`echo $table | dmsetup create $name >& /dev/null`;
	if ($?) {
		print STDERR "Failed to create \"$name\":\n";
		die "  $table\n";
	}
}

sub build_raid ()
{
	my ($i, $n, $core_args, $raid_args, $dev_args);
	my $table;

	$core_args = "0 $device_size_bb raid";

	$n = 1;  # chunk_size is manditory
	$n += ($sync) ? 1 : 0;
	$n += @rebuild;	
	$raid_args = "$raid_type $n $chunk_size_bb @rebuild $sync";

	$n = @devices;
	$dev_args = "$n";

	# Calculating max allowable raid1 size
	#  is the same as max single device size
	$n = calc_max_device_bb("raid1");
	for ($i = 0; $i < @devices; $i++) {
		if ($mdp eq "none") {
			$dev_args .= " - $devices[$i]";
			next;
		}

		if ($mdp eq "start") {
			# 1MB metadata areas
			$table="0 2048 linear $devices[$i] 0";
			create_device("${name}_meta$i", $table);
			
			$table = "0 $n linear $devices[$i] 2048";
			create_device("${name}_data$i", $table);
		} elsif ($mdp eq "middle") {
			my $j = $n / 2;
			my $k = $j + 2048;

			$table = "0 2048 linear $devices[$i] $j";
			create_device("${name}_meta$i", $table);

			$table = "0 $j linear $devices[$i] 0\n";
			$table .= "0 $j linear $devices[$i] $k";
			create_device("${name}_data$i", $table);
		} else { # end
			$table = "0 2048 linear $devices[$i] $n";
			create_device("${name}_meta$i", $table);

			$table = "0 $n linear $devices[$i] 0";
			create_device("${name}_data$i", $table);
		}
		$dev_args .= " /dev/mapper/${name}_meta$i";
		$dev_args .= " /dev/mapper/${name}_data$i";
	}

	$table = "$core_args $raid_args $dev_args";
	create_device($name, $table);
}

--=-+ApX7dhgxqZR0Qozd5Xn
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-+ApX7dhgxqZR0Qozd5Xn--
