From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 0 of 9] DM RAID: a wrapper target for MD RAID456
Date: Thu, 18 Nov 2010 17:40:15 -0600
Message-ID: <1290123615.19020.12.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-dL3YFYpaLmoWAXBnYmtm"
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


--=-dL3YFYpaLmoWAXBnYmtm
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This first set of patches consists of:
- some MD patch reversals and fixes
  md-backout-dm-dirty-log.patch
  md-minor-updates.patch
  md-fix-null-pointer-deref.patch
- Some reworking of Neil's original patches (changing CTR args, etc)
  dm-raid-seed-module.patch
  dm-target-callbacks-and-congestion-fn.patch
  dm-unplug-callback.patch
  dm-raid-iterate_devices-and-io_hints.patch
  dm-raid-suspend-and-resume-fns.patch
  dm-raid-message-fn.patch

I've attached a perl script that makes it easy to build RAID456 via the
device-mapper interfaces.  The script has support for persistent
metadata and bitmaps, but I'm not ready to post those patches yet - so
don't bother changing 'mdp' (aka Metadata Placement).  The following
command should get you started testing:
  $> gime_raid.pl raid4 /dev/sd[bcdef]1

 brassow



--=-dL3YFYpaLmoWAXBnYmtm
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

--=-dL3YFYpaLmoWAXBnYmtm
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-dL3YFYpaLmoWAXBnYmtm--
