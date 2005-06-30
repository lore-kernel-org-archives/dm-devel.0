From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: LVM/DM transfer size scaling issue
Date: Thu, 30 Jun 2005 08:45:39 -0400
Message-ID: <42C3E973.4090700@hp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000106040609080006020108"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

This is a multi-part message in MIME format.
--------------000106040609080006020108
Content-Type: multipart/related;
	boundary="------------060704070605070600050504"


--------------060704070605070600050504
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
[Not sure if this is the right forum - apologies in advance if it's
not...]<br>
<br>
I'm running some LVM/DM scaling performance runs on a 4-way IA64 box
(HP RX2600), that is equipped with four dual-U320 SCSI host bus
adapters. Each bus has 7 U320 disk drives (15K) attached for a total of
56 drives. [Each dual-U320 HBA is capable of doing on the order of
512MB/sec sustained throughput, I've measured the system using direct
IO (no LVM) at being able to read data at up to 1.8GB/sec.] The system
has RHEL4 Update 1 Beta bits installed (2.6.9 based kernel). <br>
<br>
The test program is the SPEW benchmark, and was run with the DIRECT IO
flag set. <br>
<br>
There were ten (10) LVM volumes used, they were all constructed with a
16KB stripe size. The volumes were -<br>
<br>
Volume 1 - 1 disk<br>
Volume 2 - 2 disks, each disk on a separate U320 bus<br>
Volume 3 - 3 disks, each disk on a separate U320 bus<br>
...<br>
Volume 8 - 8 disks, each disk on a separate U320 bus<br>
Volume 9 - 9 disks, 1 disk on 7 buses, 2 disks each on 1 U320 bus<br>
Volume 10 - 10 disks, 1 disk on 6 buses, 2 disks each on 2 U320 buses<br>
<br>
I then ran 4 groups of tests, with each group consisting of a separate
run against each of the 10 volumes. The groups had a block size
associated with it based upon the number of disks in a volume. Thus the
first group of runs had a block size of 16KB times the number of disks
in the volume. [The idea being to have a single transfer split into one
16KB against each of the disks in the volume.] The second group had a
block size of 32KB times the number of disks in the volume. [The idea
here was to see the effects of the wrapping - for example, for Volume 2
with 2 disks (striped at 16KB) we would expect each 64KB initial
transfer to be split into four 16KB-transfers, with the first and third
delivered to the first drive in the volume, and the second and fourth
transfer going to the second drive in the volume.] The third group had
a block size of 48KB times the number of disks, and the fourth had a
block size of 64KB times the number of disks in the volume.<br>
<br>
The expectation was to see that the overall performance would be at
least as good or hopefully even better as the overall transfer size
increased. [If for no other reasons except that (a) the amount of time
spent doing IO transfers at the device level should dwarf any overhead
at the application/LVM(DM) layers, and (b) the targetted devices could
be given multiple commands and thus reduce idle time.] However, that is
*not* what was seen. The accompanying xmgrace-generated chart
illustrates this (I've also attached the xmgrace file itself, in case
you are having problems with the .png file included...):<br>
<br>
<img alt="" src="cid:part1.09000705.09040005@hp.com" height="612"
 width="792"><br>
<br>
Here we see the black line showing scaling along the first group (16KB
per segmenet/disk per transfer) - in fact we see good scaling up to 4
disks (pretty linear), with a slight hiccup, and then it continues
onwards at less of an increase. Something strange at 5 disks happens,
and again at 9/10 disks - the latter perhaps due to the fact that we're
wrapping on the disks now (some adapters have two disks busy at a
time). I'm going to look into the actual bus/target mappings for the
volumes to see if they play a role.<br>
<br>
But note, when we go to group 2 (32KB per segment per transfer), the
performance is always slightly lower up to 3 disks, and then starting
at 4 disks we see almost a flattening out (with a big dip at volume 6).
We do see some (slight) scaling again from 32KB to 48KB and then 64KB,
but we never again attain the rate of simply issuing the 16KB per
segment initial requests.<br>
<br>
It's interesting to see the dip at 6-disks per volume for all the
transfer sizes that wrap. <br>
<br>
I've been investigating this, but was wondering if anyone had noticed
something like this - or perhaps had a ready explanation for this...<br>
<br>
Alan D. Brunelle<br>
HP<br>
</body>
</html>

--------------060704070605070600050504
Content-Type: image/png;
 name="spew_lvm.png"
Content-Transfer-Encoding: base64
Content-ID: <part1.09000705.09040005@hp.com>
Content-Disposition: inline;
 filename="spew_lvm.png"

iVBORw0KGgoAAAANSUhEUgAAAxgAAAJkCAMAAAClNHdYAAAAOVBMVEX///8AAAD/AAAA/wAA
AP///wC8j4/c3NyUANMA////AP//pQByIbxnB0hA4NAAiwDAwMCBgYFCQkITWeDyAAAACXBI
WXMAAAsTAAALEwEAmpwYAAAAM3RFWHRUaXRsZQAvd29yay9jb21tb24vZGF0YS9sdm0vMjAw
NV8wNl8yOS9zcGV3X2x2bS5hZ3JzhMMxAAAACnRFWHRBdXRob3IAYWRiPNEcrgAAABV0RVh0
U29mdHdhcmUAR3JhY2UtNS4xLjE3S1loEAAAAAx0RVh0RGVzY3JpcHRpb24AEwkhIwAAIABJ
REFUeF7tnYmioyoQRJN59wPU///YZzeLiIBsKh3rzOQmkcVSugK4JJ8PAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKAPk7/g
85nnbaHzMrGoB/PsL9kxu+m7N5Or1y6iv95SAKLMX4Vd8PXicVoWN+j85OCiHthqtUJ+Z7VO
/EJHunqz6DfLd57NGw0tWjeDCprt/S7kHvuOMfXP+pl3in1hXrv7inMrnfo1/XVWrqRt74Ec
pl1LBmLKfasD9GRRD2YT9qTBvl7Dnl5Oy7QtXi3EAamEa9+4W6HL6ABdVI5F6Vbv1HKVid+b
589OiLevdtnWNXMSLXI62N07IIpdZDtB+OFW3jXr4vkkvKgLTsTN7mtemYpOvWYlUQvXy2ZH
lOl7JlWLqU05w6mbXxijzHbLZ9cK/qeAu7v0K+o4bDr6C8G4DUmfd04geL6YFzfgYou64A7Q
DsaYlCq1ZjO9UJthsu58pXNQN+PUxjHr1K27H53b7hV3JHkwhs2+Gei7dUK0ahhDLG5jLzQo
2d55A4dl90kcWdQHdwBzMIZdTnlsYJIOJ+ptRrts4kVRY5ilpjsy2ZzEgzGcoZhJ+Tpm4UmH
fg2ksev6d2+9MFg/cX0XHBet4/11Wkt/eXarjhDRUJvjjZerZxP4Ey/iv7N6R0vdeIoZY9nZ
lnXYcZ2jypsYxIxhC9qhGS/ZHxw7GMO6QA/UaBdas6zLYAy5uB+ui/sZSDGybENmCpGDC46L
1jBcjUFxRcZYeJq8UJBQdFIqZVfLGTUNnnTKpKrbHeqKGGPa+UJNnjexThnahmP/o0La5rMV
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
--------------060704070605070600050504--

--------------000106040609080006020108
Content-Type: text/plain;
 name="spew_lvm.agr"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="spew_lvm.agr"

# Grace project file
#
@version 50117
@page size 792, 612
@page scroll 5%
@page inout 5%
@link page off
@map font 0 to "Times-Roman", "Times-Roman"
@map font 1 to "Times-Italic", "Times-Italic"
@map font 2 to "Times-Bold", "Times-Bold"
@map font 3 to "Times-BoldItalic", "Times-BoldItalic"
@map font 4 to "Helvetica", "Helvetica"
@map font 5 to "Helvetica-Oblique", "Helvetica-Oblique"
@map font 6 to "Helvetica-Bold", "Helvetica-Bold"
@map font 7 to "Helvetica-BoldOblique", "Helvetica-BoldOblique"
@map font 8 to "Courier", "Courier"
@map font 9 to "Courier-Oblique", "Courier-Oblique"
@map font 10 to "Courier-Bold", "Courier-Bold"
@map font 11 to "Courier-BoldOblique", "Courier-BoldOblique"
@map font 12 to "Symbol", "Symbol"
@map font 13 to "ZapfDingbats", "ZapfDingbats"
@map color 0 to (255, 255, 255), "white"
@map color 1 to (0, 0, 0), "black"
@map color 2 to (255, 0, 0), "red"
@map color 3 to (0, 255, 0), "green"
@map color 4 to (0, 0, 255), "blue"
@map color 5 to (255, 255, 0), "yellow"
@map color 6 to (188, 143, 143), "brown"
@map color 7 to (220, 220, 220), "grey"
@map color 8 to (148, 0, 211), "violet"
@map color 9 to (0, 255, 255), "cyan"
@map color 10 to (255, 0, 255), "magenta"
@map color 11 to (255, 165, 0), "orange"
@map color 12 to (114, 33, 188), "indigo"
@map color 13 to (103, 7, 72), "maroon"
@map color 14 to (64, 224, 208), "turquoise"
@map color 15 to (0, 139, 0), "green4"
@reference date 0
@date wrap off
@date wrap year 1950
@default linewidth 1.0
@default linestyle 1
@default color 1
@default pattern 1
@default font 0
@default char size 1.000000
@default symbol size 1.000000
@default sformat "%.8g"
@background color 0
@page background fill on
@timestamp off
@timestamp 0.03, 0.03
@timestamp color 1
@timestamp rot 0
@timestamp font 0
@timestamp char size 1.000000
@timestamp def "Wed Jun 29 16:48:16 2005"
@r0 off
@link r0 to g0
@r0 type above
@r0 linestyle 1
@r0 linewidth 1.0
@r0 color 1
@r0 line 0, 0, 0, 0
@r1 off
@link r1 to g0
@r1 type above
@r1 linestyle 1
@r1 linewidth 1.0
@r1 color 1
@r1 line 0, 0, 0, 0
@r2 off
@link r2 to g0
@r2 type above
@r2 linestyle 1
@r2 linewidth 1.0
@r2 color 1
@r2 line 0, 0, 0, 0
@r3 off
@link r3 to g0
@r3 type above
@r3 linestyle 1
@r3 linewidth 1.0
@r3 color 1
@r3 line 0, 0, 0, 0
@r4 off
@link r4 to g0
@r4 type above
@r4 linestyle 1
@r4 linewidth 1.0
@r4 color 1
@r4 line 0, 0, 0, 0
@g0 on
@g0 hidden false
@g0 type XY
@g0 stacked false
@g0 bar hgap 0.000000
@g0 fixedpoint off
@g0 fixedpoint type 0
@g0 fixedpoint xy 0.000000, 0.000000
@g0 fixedpoint format general general
@g0 fixedpoint prec 6, 6
@with g0
@    world 0.5, 0, 10.5, 400
@    stack world 0, 0, 0, 0
@    znorm 1
@    view 0.150000, 0.150000, 1.150000, 0.850000
@    title "IA64 4-way w/ U320 SPEW LVM"
@    title font 0
@    title size 1.500000
@    title color 1
@    subtitle ""
@    subtitle font 0
@    subtitle size 1.000000
@    subtitle color 1
@    xaxes scale Normal
@    yaxes scale Normal
@    xaxes invert off
@    yaxes invert off
@    xaxis  on
@    xaxis  type zero false
@    xaxis  offset 0.000000 , 0.000000
@    xaxis  bar on
@    xaxis  bar color 1
@    xaxis  bar linestyle 1
@    xaxis  bar linewidth 1.0
@    xaxis  label "Segments per volume"
@    xaxis  label layout para
@    xaxis  label place auto
@    xaxis  label char size 1.000000
@    xaxis  label font 0
@    xaxis  label color 1
@    xaxis  label place normal
@    xaxis  tick on
@    xaxis  tick major 1
@    xaxis  tick minor ticks 0
@    xaxis  tick default 6
@    xaxis  tick place rounded true
@    xaxis  tick in
@    xaxis  tick major size 1.000000
@    xaxis  tick major color 1
@    xaxis  tick major linewidth 1.0
@    xaxis  tick major linestyle 1
@    xaxis  tick major grid off
@    xaxis  tick minor color 1
@    xaxis  tick minor linewidth 1.0
@    xaxis  tick minor linestyle 1
@    xaxis  tick minor grid off
@    xaxis  tick minor size 0.500000
@    xaxis  ticklabel on
@    xaxis  ticklabel format decimal
@    xaxis  ticklabel prec 0
@    xaxis  ticklabel formula ""
@    xaxis  ticklabel append ""
@    xaxis  ticklabel prepend ""
@    xaxis  ticklabel angle 0
@    xaxis  ticklabel skip 0
@    xaxis  ticklabel stagger 0
@    xaxis  ticklabel place normal
@    xaxis  ticklabel offset auto
@    xaxis  ticklabel offset 0.000000 , 0.010000
@    xaxis  ticklabel start type auto
@    xaxis  ticklabel start 0.000000
@    xaxis  ticklabel stop type auto
@    xaxis  ticklabel stop 0.000000
@    xaxis  ticklabel char size 1.000000
@    xaxis  ticklabel font 0
@    xaxis  ticklabel color 1
@    xaxis  tick place both
@    xaxis  tick spec type none
@    yaxis  on
@    yaxis  type zero false
@    yaxis  offset 0.000000 , 0.000000
@    yaxis  bar on
@    yaxis  bar color 1
@    yaxis  bar linestyle 1
@    yaxis  bar linewidth 1.0
@    yaxis  label "MBytes per second"
@    yaxis  label layout para
@    yaxis  label place auto
@    yaxis  label char size 1.000000
@    yaxis  label font 0
@    yaxis  label color 1
@    yaxis  label place normal
@    yaxis  tick on
@    yaxis  tick major 100
@    yaxis  tick minor ticks 3
@    yaxis  tick default 6
@    yaxis  tick place rounded true
@    yaxis  tick in
@    yaxis  tick major size 1.000000
@    yaxis  tick major color 1
@    yaxis  tick major linewidth 1.0
@    yaxis  tick major linestyle 3
@    yaxis  tick major grid on
@    yaxis  tick minor color 1
@    yaxis  tick minor linewidth 1.0
@    yaxis  tick minor linestyle 2
@    yaxis  tick minor grid on
@    yaxis  tick minor size 0.500000
@    yaxis  ticklabel on
@    yaxis  ticklabel format general
@    yaxis  ticklabel prec 5
@    yaxis  ticklabel formula ""
@    yaxis  ticklabel append ""
@    yaxis  ticklabel prepend ""
@    yaxis  ticklabel angle 0
@    yaxis  ticklabel skip 0
@    yaxis  ticklabel stagger 0
@    yaxis  ticklabel place both
@    yaxis  ticklabel offset auto
@    yaxis  ticklabel offset 0.000000 , 0.010000
@    yaxis  ticklabel start type auto
@    yaxis  ticklabel start 0.000000
@    yaxis  ticklabel stop type auto
@    yaxis  ticklabel stop 0.000000
@    yaxis  ticklabel char size 1.000000
@    yaxis  ticklabel font 0
@    yaxis  ticklabel color 1
@    yaxis  tick place both
@    yaxis  tick spec type none
@    altxaxis  off
@    altyaxis  off
@    legend on
@    legend loctype view
@    legend 0.22, 0.8
@    legend box color 1
@    legend box pattern 1
@    legend box linewidth 1.0
@    legend box linestyle 1
@    legend box fill color 0
@    legend box fill pattern 1
@    legend font 0
@    legend char size 0.800000
@    legend color 1
@    legend length 4
@    legend vgap 1
@    legend hgap 1
@    legend invert false
@    frame type 0
@    frame linestyle 1
@    frame linewidth 1.0
@    frame color 1
@    frame pattern 1
@    frame background color 0
@    frame background pattern 0
@    s0 hidden false
@    s0 type xy
@    s0 symbol 1
@    s0 symbol size 1.000000
@    s0 symbol color 1
@    s0 symbol pattern 1
@    s0 symbol fill color 1
@    s0 symbol fill pattern 0
@    s0 symbol linewidth 1.0
@    s0 symbol linestyle 1
@    s0 symbol char 65
@    s0 symbol char font 0
@    s0 symbol skip 0
@    s0 line type 1
@    s0 line linestyle 1
@    s0 line linewidth 1.0
@    s0 line color 1
@    s0 line pattern 1
@    s0 baseline type 0
@    s0 baseline off
@    s0 dropline off
@    s0 fill type 0
@    s0 fill rule 0
@    s0 fill color 1
@    s0 fill pattern 1
@    s0 avalue off
@    s0 avalue type 2
@    s0 avalue char size 1.000000
@    s0 avalue font 0
@    s0 avalue color 1
@    s0 avalue rot 0
@    s0 avalue format general
@    s0 avalue prec 3
@    s0 avalue prepend ""
@    s0 avalue append ""
@    s0 avalue offset 0.000000 , 0.000000
@    s0 errorbar on
@    s0 errorbar place both
@    s0 errorbar color 1
@    s0 errorbar pattern 1
@    s0 errorbar size 1.000000
@    s0 errorbar linewidth 1.0
@    s0 errorbar linestyle 1
@    s0 errorbar riser linewidth 1.0
@    s0 errorbar riser linestyle 1
@    s0 errorbar riser clip off
@    s0 errorbar riser clip length 0.100000
@    s0 comment "/work/common/data/lvm/2005_06_29/results.dat"
@    s0 legend  "16KB per segment transfers"
@    s1 hidden false
@    s1 type xy
@    s1 symbol 1
@    s1 symbol size 1.000000
@    s1 symbol color 2
@    s1 symbol pattern 1
@    s1 symbol fill color 2
@    s1 symbol fill pattern 0
@    s1 symbol linewidth 1.0
@    s1 symbol linestyle 1
@    s1 symbol char 65
@    s1 symbol char font 0
@    s1 symbol skip 0
@    s1 line type 1
@    s1 line linestyle 1
@    s1 line linewidth 1.0
@    s1 line color 2
@    s1 line pattern 1
@    s1 baseline type 0
@    s1 baseline off
@    s1 dropline off
@    s1 fill type 0
@    s1 fill rule 0
@    s1 fill color 1
@    s1 fill pattern 1
@    s1 avalue off
@    s1 avalue type 2
@    s1 avalue char size 1.000000
@    s1 avalue font 0
@    s1 avalue color 1
@    s1 avalue rot 0
@    s1 avalue format general
@    s1 avalue prec 3
@    s1 avalue prepend ""
@    s1 avalue append ""
@    s1 avalue offset 0.000000 , 0.000000
@    s1 errorbar on
@    s1 errorbar place both
@    s1 errorbar color 2
@    s1 errorbar pattern 1
@    s1 errorbar size 1.000000
@    s1 errorbar linewidth 1.0
@    s1 errorbar linestyle 1
@    s1 errorbar riser linewidth 1.0
@    s1 errorbar riser linestyle 1
@    s1 errorbar riser clip off
@    s1 errorbar riser clip length 0.100000
@    s1 comment "/work/common/data/lvm/2005_06_29/results.dat"
@    s1 legend  "32KB"
@    s2 hidden false
@    s2 type xy
@    s2 symbol 1
@    s2 symbol size 1.000000
@    s2 symbol color 3
@    s2 symbol pattern 1
@    s2 symbol fill color 3
@    s2 symbol fill pattern 0
@    s2 symbol linewidth 1.0
@    s2 symbol linestyle 1
@    s2 symbol char 65
@    s2 symbol char font 0
@    s2 symbol skip 0
@    s2 line type 1
@    s2 line linestyle 1
@    s2 line linewidth 1.0
@    s2 line color 3
@    s2 line pattern 1
@    s2 baseline type 0
@    s2 baseline off
@    s2 dropline off
@    s2 fill type 0
@    s2 fill rule 0
@    s2 fill color 1
@    s2 fill pattern 1
@    s2 avalue off
@    s2 avalue type 2
@    s2 avalue char size 1.000000
@    s2 avalue font 0
@    s2 avalue color 1
@    s2 avalue rot 0
@    s2 avalue format general
@    s2 avalue prec 3
@    s2 avalue prepend ""
@    s2 avalue append ""
@    s2 avalue offset 0.000000 , 0.000000
@    s2 errorbar on
@    s2 errorbar place both
@    s2 errorbar color 3
@    s2 errorbar pattern 1
@    s2 errorbar size 1.000000
@    s2 errorbar linewidth 1.0
@    s2 errorbar linestyle 1
@    s2 errorbar riser linewidth 1.0
@    s2 errorbar riser linestyle 1
@    s2 errorbar riser clip off
@    s2 errorbar riser clip length 0.100000
@    s2 comment "/work/common/data/lvm/2005_06_29/results.dat"
@    s2 legend  "48KB"
@    s3 hidden false
@    s3 type xy
@    s3 symbol 1
@    s3 symbol size 1.000000
@    s3 symbol color 4
@    s3 symbol pattern 1
@    s3 symbol fill color 4
@    s3 symbol fill pattern 0
@    s3 symbol linewidth 1.0
@    s3 symbol linestyle 1
@    s3 symbol char 65
@    s3 symbol char font 0
@    s3 symbol skip 0
@    s3 line type 1
@    s3 line linestyle 1
@    s3 line linewidth 1.0
@    s3 line color 4
@    s3 line pattern 1
@    s3 baseline type 0
@    s3 baseline off
@    s3 dropline off
@    s3 fill type 0
@    s3 fill rule 0
@    s3 fill color 1
@    s3 fill pattern 1
@    s3 avalue off
@    s3 avalue type 2
@    s3 avalue char size 1.000000
@    s3 avalue font 0
@    s3 avalue color 1
@    s3 avalue rot 0
@    s3 avalue format general
@    s3 avalue prec 3
@    s3 avalue prepend ""
@    s3 avalue append ""
@    s3 avalue offset 0.000000 , 0.000000
@    s3 errorbar on
@    s3 errorbar place both
@    s3 errorbar color 4
@    s3 errorbar pattern 1
@    s3 errorbar size 1.000000
@    s3 errorbar linewidth 1.0
@    s3 errorbar linestyle 1
@    s3 errorbar riser linewidth 1.0
@    s3 errorbar riser linestyle 1
@    s3 errorbar riser clip off
@    s3 errorbar riser clip length 0.100000
@    s3 comment "/work/common/data/lvm/2005_06_29/results.dat"
@    s3 legend  "64KB"
@target G0.S0
@type xy
1 70.52
2 138.21
3 201.13
4 271.44
5 275.3
6 319.66
7 356
8 366.55
9 327.93
10 362.51
&
@target G0.S1
@type xy
1 64.62
2 103.68
3 190.05
4 202.64
5 210.48
6 160.71
7 171.36
8 170.12
9 188.88
10 206.91
&
@target G0.S2
@type xy
1 70.32
2 106.69
3 190.09
4 209.55
5 251.58
6 185.25
7 210.11
8 224.61
9 218.05
10 219.72
&
@target G0.S3
@type xy
1 70.41
2 109.8
3 190.6
4 216.79
5 264.03
6 202.39
7 225.53
8 240.77
9 252.18
10 245.6
&

--------------000106040609080006020108
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------000106040609080006020108--
