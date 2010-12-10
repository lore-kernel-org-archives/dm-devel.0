From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 0 of 8] DM RAID: a wrapper target for MD RAID456
	(skeleton)
Date: Fri, 10 Dec 2010 17:22:19 -0600
Message-ID: <1292023339.15299.23.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-wUI6/QMB+376Es5HVRaP"
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
Cc: agk@redhat.com
List-Id: dm-devel.ids


--=-wUI6/QMB+376Es5HVRaP
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

I've pulled out the minimum patches required to create a usable RAID456
target through device-mapper.  I feel these patches are ready for
inclusion.  The superblock/bitmap support is mostly working, but there
is some polishing left to do on those yet, so I will start treating
those as a separate bunch.  The patches I'm including are:
	md-backout-dm-dirty-log.patch
	md-minor-updates.patch
	md-fix-null-pointer-deref.patch

	dm-raid-seed-module.patch
	dm-target-callbacks-and-congestion-fn.patch
	dm-unplug-callback.patch
	dm-raid-iterate_devices-and-io_hints.patch
The DM patches can be applied independent of the MD patches.  There is
no need to wait for one side or the other to get their patches in first.

I'm fairly happy with the device-mapper table arguments, but I'd like
people to give some careful thought to the names of the optional
arguments, which are:

[[no]sync]		No change.
[write_back=<int>]	This sets 'mddev->bitmap_info.max_write_behind'.
			Should this be 'max_write_behind', 'MaxWriteBehind',
			'WriteBehind'?
[daemon_sleep=<int>]	This is specified in seconds.  More granularity?
			'DaemonSleep'?
[stripecache=<int>]	Should this be 'stripe_cache' or 'StripeCache'?
[minspeed=<int>]	This sets the minimum RAID recovery speed in kB.
			Should this be 'min_recovery_speed' or some other
			variant?
[maxspeed=<int>]	Same questions as 'minspeed'.
[rebuild=<int>]		This argument is used to specify (by index) which
			drive to rebuild in an array.  This is probably
			fine as it is.

I've tar'ed up my quilt directory that contains the above patches for
convenience.  I've also included the script that generates the
device-mapper tables.

 brassow



--=-wUI6/QMB+376Es5HVRaP
Content-Disposition: attachment; filename=dm-raid-patches.tgz
Content-Type: application/x-compressed-tar; name=dm-raid-patches.tgz
Content-Transfer-Encoding: base64

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
a3ttr+21vbbX9tpe/57X/wNCh1uLAMgAAP==


--=-wUI6/QMB+376Es5HVRaP
Content-Disposition: attachment; filename=gime_raid.pl
Content-Type: application/x-perl; name=gime_raid.pl
Content-Transfer-Encoding: 7bit

#!/usr/bin/perl -w

$name="raid";
$raid_type="";
$mdp="none";
$sync="";
$chunk_size="";
$minspeed="";
$maxspeed="";
$daemon_sleep="";
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
		(/^daemon_sleep$/) && do { $daemon_sleep = $b; last; };
		(/^minspeed$/) && do { $minspeed = $b; last; };
		(/^maxspeed$/) && do { $maxspeed = $b; last; };
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
	print "  [no]sync           Force either sync or no sync\n";
	print "  chunk_size=<arg>   Specify chunk size.  Default: 1M\n";
	print "  rebuild=<arg>      Index of drive needing rebuild.\n";
	print "  daemon_sleep=<arg> \n";
	print "  minspeed=<arg>     Minimum array resync speed.\n";
	print "  maxspeed=<arg>     Maximum array resync speed.\n";
	print "  mdp=<arg>          none*, start, middle, or end.\n";
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
	for ($i = 0; $i < @rebuild; $i++) {
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
	$n += ($daemon_sleep) ? 1 : 0;
	$n += ($minspeed) ? 1 : 0;
	$n += ($maxspeed) ? 1 : 0;
	$n += @rebuild;	
	$raid_args = "$raid_type $n $chunk_size_bb";
	for ($i = 0; $i < @rebuild; $i++) {
		$raid_args .= " rebuild=$rebuild[$i]";
	}
	if ($sync) {
		$raid_args .= " $sync";
	}
	if ($daemon_sleep) {
		$raid_args .= " daemon_sleep=$daemon_sleep";
	}
	if ($minspeed) {
		$raid_args .= " minspeed=$minspeed";
	}
	if ($maxspeed) {
		$raid_args .= " maxspeed=$maxspeed";
	}
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

--=-wUI6/QMB+376Es5HVRaP
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-wUI6/QMB+376Es5HVRaP--
