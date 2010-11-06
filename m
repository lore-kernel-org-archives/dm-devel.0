From: Brem Belguebli <brem.belguebli@gmail.com>
Subject: sysstat metrics on a mirrored logical volume
Date: Sat, 06 Nov 2010 16:02:58 +0100
Message-ID: <1289055778.7144.34.camel@newgen.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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

Hi,

I have a mirrored logical volume with a in memory log (core log), built on top of 2 multipath'ed devices, for which I'm getting 
weird perf data collected by sysstat (sar -d).

To summarize, the transfers/s metric (tps) for the devmapper managed devices (mpath/lv_mimage,lv) show values up to 7 times greater 
than the values I get per physical path.

I don't think the devicemapper overhead (if any) explains this (8 times), but I can't figure out how to interpret this. 
  
	* Logical volume lvol1 is the only lv on VG vg10 and is mirrored (corelog) on top of /dev/mapper/mpath10 and /dev/mapper/mpath1.

	* Each mpath device is made of 4 physical paths, in a multibus setup (round robin)  

	* PE size on VG10 is 4MB

	* /dev/mapper/vg10-lvol1 is has a ext3 fs with a block size of 4kB, journal size is 128 MB 

	* perfdata is collected with a sar -d 1 7200 -f mysarfile  

Below an example of what I'm getting 

Each mirror leg, vg10-lvol1_mimage_0 corresponding to mpath10 and vg10-lvol1_mimage_1 corresponding to mpath1, show a transfer 
rate of 25217 tps and while each underlying physical path show 800 ~ 1000 tps.

I expected to get ~ 4000 tps.

Raw  results: 
     
mpath10
Time	    DEV	       tps
08:07:33 PM dev253-7   25217.64

vg10-lvol1_mimage_0
Time	    DEV	       tps
08:07:33 PM dev253-112 25217.64

paths
Time        DEV        tps
08:07:33 PM dev8-0     1011.22
08:07:33 PM dev66-64   1074.55
08:07:33 PM dev68-128  1056.51
08:07:33 PM dev70-192  972.55

mpath10 (360060xxx) dm-7 HP,OPEN-V
[size=31G][features=0][hwhandler=0][rw]
\_ round-robin 0 [prio=0][active]
 \_ 0:0:2:1  sdak 66:64   [active][undef]
 \_ 0:0:0:1  sda  8:0     [active][undef]
 \_ 2:0:0:1  sdbu 68:128  [active][undef]
 \_ 2:0:2:1  sdde 70:192  [active][undef]

vg10-lvol1_mimage_1
Time        DEV        tps
08:07:33 PM dev253-111 25219.24

mpath1
Time        DEV       tps
08:07:33 PM dev253-16 25219.24

paths
Time        DEV       tps
08:07:33 PM dev65-32  810.82
08:07:33 PM dev67-96  757.11
08:07:33 PM dev69-160 818.64
08:07:33 PM dev71-224 787.58

mpath1 (360060yyy) dm-16 HP,OPEN-V
[size=31G][features=0][hwhandler=0][rw]
\_ round-robin 0 [prio=0][active]
 \_ 0:0:3:1  sdbc 67:96   [active][undef]
 \_ 2:0:1:1  sdcm 69:160  [active][undef]
 \_ 2:0:3:1  sddw 71:224  [active][undef]
 \_ 0:0:1:1  sds  65:32   [active][undef]

vg10-lvol1
Time        DEV        tps
08:07:33 PM dev253-113 18597.60

dumpe2fs -h /dev/mapper/vg10-lvol1
Block size:               4096
Fragment size:            4096
Fragments per group:      32768
Inode size:		  128
Journal size:             128M

vgdisplay -v vg10
PE Size               4.00 MB


Rgds
Brem
