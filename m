From: Ritesh Raj Sarraf <rrs@researchut.com>
Subject: Re: dm-crypt low performance
Date: Wed, 14 Jan 2009 01:22:07 +0530
Message-ID: <200901140122.14374.rrs@researchut.com>
References: <0ths36-dce.ln1@news.researchut.com> <496CB858.70803@redhat.com>
	<200901132307.47381.rrs@researchut.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1748734944=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200901132307.47381.rrs@researchut.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: rjw@sisk.pl, device-mapper development <dm-devel@redhat.com>, linux-pm@lists.linux-foundation.org
List-Id: dm-devel.ids

--===============1748734944==
Content-Type: multipart/signed; boundary="nextPart1861260.ZdNtoRABJL";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1861260.ZdNtoRABJL
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Okay!! I think I now have the correct steps to reproduce it consistently.

=2D---total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system-- =
=20
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw  =20
 10  25   0  64   0   1| 128k   15M| 158B    0 |   0     0 |3475  6007
 10  35   0  53   0   2|  75M   15M|   0     0 |   0     0 |3741  6414
  9  35   7  47   0   1|  74M   15M|   0     0 |   0     0 |3798  6372
  9  36   3  50   0   2|  72M   13M|   0     0 |   0     0 |3476  5915
  9  28   0  62   0   1|  31M   14M|   0     0 |   0     0 |3455  5850
 10  23   0  65   0   1|   0    14M|  92B    0 |   0     0 |3103  5343
  3  21   0  75   0   1|   0    13M|  92B    0 |   0     0 |3056  4698
  2  21   0  76   0   1|   0    14M|  92B    0 |   0     0 |3121  4699
  3  20   0  76   0   1|   0    13M|   0     0 |   0     0 |2973  4487
  1  20   0  78   0   1|   0    13M|   0    65B|   0     0 |2991  4487
  4  22   0  72   0   1|  15M   13M|   0     0 |   0     0 |3147  4881
 10  21   5  63   0   1|  70M 3084k|   0     0 |   0     0 |2658  4568
  9  32  11  46   0   1|  72M 9848k|   0     0 |   0     0 |3192  5481
 10  37   0  51   0   2|  74M   17M|   0     0 |   0     0 |4042  6892
 10  28   0  61   0   1|  23M   16M|   0     0 |   0     0 |3619  6116
  2  26   0  71   0   1|   0    17M|   0     0 |   0     0 |3748  5736
  5  29   2  63   0   1|  34M   16M|   0     0 |   0     0 |3763  6144
  4  34   4  56   0   2|  40M   17M|   0     0 |   0     0 |3895  6392
  7  34   0  58   0   2|  44M   18M|   0     0 |   0     0 |3993  6056
 15  31   0  51   1   1|  50M   18M|   0    65B|   0  4096B|3816  7130
  1  37   0  60   0   2|  72M   17M|   0     0 |   0     0 |4079  6412 ^C

The above result is from a freshly booted linux with the same suspected fau=
lty=20
USB HDD enclosure. I ran it on 2 kernels, one standard and one debug, and b=
oth=20
gave similar results.
So shouldn't be faulty hardware.


So then with my standard kernel, I booted + hibernated and then resumed and=
=20
then again ran the I/O. Here are the same results.

=2D---total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw=20
  1   1   0  97   0   0|   0   896k|  54B    0 |   0     0 | 666   778=20
  2   2   0  95   0   0|   0   864k|  54B   78B|   0     0 | 693   834=20
  1   1   0  98   0   0|   0   864k|   0     0 |   0     0 | 649   691=20
  1   1   0  98   0   0|   0   896k|   0     0 |   0     0 | 655   727=20
  2   2   0  96   0   0|   0  1112k|   0     0 |   0     0 | 700   854=20
  2   1   0  97   0   0|   0  1032k|   0     0 |   0     0 | 669   865=20
  2   1   0  96   0   0|   0  1048k|   0     0 |   0     0 | 650   816=20
  2   2   0  97   0   0|   0   896k|   0     0 |   0     0 | 663   808=20
  0   2   0  98   0   0|   0   864k|   0     0 |   0     0 | 635   686=20
  3  13   0  82   0   0|  59M  928k|   0     0 |   0     0 |1326  1393=20
  1  13   0  86   0   0|  74M  896k|   0     0 |   0     0 |1472  1388=20
  2   8   0  90   0   0|  40M  928k|   0     0 |   0     0 |1163  1195=20
  1   1   0  97   0   0|   0   864k|   0     0 |   0     0 | 738   829=20
  2   2   0  96   0   0|   0   896k|   0     0 |   0     0 | 787   902=20
  1   2   0  97   0   0|   0  1048k|   0     0 |   0     0 | 766   911=20
  1   1   0  97   0   0|   0   896k|  92B    0 |   0     0 | 766   927=20
  2   2  30  66   0   0|   0  1080k|  92B    0 |   0     0 | 750   868=20
  1   1  51  47   0   0|   0   864k|  92B    0 |   0     0 | 712   808=20
  1   1  50  47   0   0|   0   896k|  92B    0 |   0     0 | 722   872=20
  1   2  10  86   0   0|   0   864k| 184B    0 |   0     0 | 748   972=20
  1   1   0  98   0   0|   0   864k|  92B    0 |   0     0 | 730   817=20

So this seems to be happening on my laptop when the OS has used the=20
hibernation feature. I'm of-course doing a luksClose and USB device=20
disconnection before hibernation.

Here's the usb device listing after hibernation/resume.

rrs@learner:~$ cat /tmp/lsusb.suspend
Bus 005 Device 005: ID 046d:08c6 Logitech, Inc. QuickCam for DELL Notebooks
Bus 005 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 007: ID 05e3:0702 Genesys Logic, Inc. USB 2.0 IDE Adapter
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 005: ID 046d:c00c Logitech, Inc. Optical Wheel Mouse
Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub


And here's the usb device listing after a fresh boot.

rrs@learner:~$ lsusb
Bus 005 Device 004: ID 05e3:0702 Genesys Logic, Inc. USB 2.0 IDE Adapter
Bus 005 Device 003: ID 046d:08c6 Logitech, Inc. QuickCam for DELL Notebooks
Bus 005 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 004: ID 046d:c00c Logitech, Inc. Optical Wheel Mouse
Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub


Ritesh




On Tuesday 13 Jan 2009 23:07:45 Ritesh Raj Sarraf wrote:
> On Tuesday 13 Jan 2009 21:20:48 Milan Broz wrote:
> > Ritesh Raj Sarraf wrote:
> > > I'm using dm-crypt on an external USB enclosure ide hdd. I copied 20Gb
> > > of data on to the encrypted device and am suffering severe performance
> > > penalty. After a couple of seconds, all processes involved in the I/O
> > > keep stalling. They periodically resume, just for a couple of seconds
> > > and then again stall.
> > >
> > > Running linux 2.6.26.
> >
> > Please can you try it without dm-crypt involved?
> > Just copy 20Gb to your unencrypted disk attached through USB.
> >
> > I saw this problem with plain USB attached storage some time ago too.
> >
> > There is only one thread in dm-crypt and it is waiting for io_schedule,
> > so I think it is not dm-crypt who is blocking it, but the layer
> > below the dm-crypt.
>
> So I tried the following.
>
> Copied 20Gb of data to a partition on the External USB disk. Here are the
> results:
>
> ----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
> usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw
>  11  10   0  79   0   1|  22M   39M|2864B 2454B|   0     0 |2048  3793
>  12   9   1  76   0   1|  23M   39M|  81k 8686B|   0     0 |2166  3635
>  13   8  16  62   0   1|  27M   43M|  12k 5036B|   0     0 |2127  3526
>  14   8  37  40   0   1|  24M   42M|7138B 5140B|   0     0 |2047  3415
>   7   8  47  36   0   0|  35M   40M|2451B 2538B|   0     0 |2002  3179
>   4   9  49  37   0   0|  41M   40M|4081B  276B|   0     0 |1974  2956
>   1   9  50  38   0   1|  40M   40M|   0   276B|   0     0 |1912  2774
>   1   8  50  39   0   1|  40M   40M|  92B    0 |   0     0 |2018  2958
>   2   9  48  39   0   0|  44M   40M| 362B  276B|   0     0 |2097  3191
>   8   8  45  38   0   1|  27M   33M|  23k 4181B|   0     0 |1919  3009
>   8   8  50  34   0   0|  31M   26M|  10k 2570B|   0     0 |1760  2724
>  21  11  33  30   0   3|  40M   40M| 204k   17k|   0     0 |2360  3845
>  13   8  43  36   0   0|  35M   39M|  12k 5354B|   0     0 |2083  3349
>  16   8  41  35   0   0|  30M   35M|5738B 4158B|   0     0 |1904  3118
>   8  10  47  33   0   1|  40M   37M|1718B 1255B|   0     0 |1932  3130
>   3   9  49  39   0   1|  40M   40M|   0     0 |   0     0 |2124  3065
>   4   9  46  41   0   0|  40M   40M|   0     0 |   0     0 |1971  3088
>   6   9  46  40   0   0|  40M   41M| 850B  723B|   0     0 |2059  3155
>   3  10  46  39   0   1|  40M   42M|1958B 1651B|   0     0 |2054  3217
>   8  12  41  38   0   1|  41M   39M|2741B 1342B|   0     0 |2083  3647
>   4   8  47  40   0   0|  39M   39M|2062B 1299B|   0     0 |2060  3328
>
> Looks good.
>
> Then I tried copying 20Gb of data to the dm-crypted partition on the same
> USB disk. Here are the results:
>
> ----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
> usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw
>   3  28   0  67   0   1|  20M   41M|   0     0 |   0     0 |1972  3036
>  25  29   0  44   0   2|  39M   42M|   0    78B|  52k    0 |1800  3612
>  41  22   0  35   0   1|8952k   40M|  54B   65B|   0     0 |1493  3471
>  21  24   0  54   0   1|2040k   42M|1469B 1591B|   0     0 |2180  5170
>  16  24   0  59   0   1|  14M   44M|  25k 4962B|   0     0 |1991  4541
>  12  11  17  58   0   2|  36M   19M|  28k 2964B|  44k    0 |2351  3774
>  19  28  14  37   0   1|  40M   19M|  72k 5062B|   0     0 |1707  3906
>  14  29   0  54   0   3|  58M   42M| 108k 7586B|   0     0 |2431  4646
>   8  23   0  67   0   2|  44M   35M|  77k 4188B|   0     0 |2948  4587
>  22  19   6  50   0   1|  30M   38M|  41k 2666B|   0     0 |2127  3924
>   6  33  29  31   0   1|  52M   38M|7628B 1511B|   0     0 |2055  3375
>   4  25   0  70   0   1|4624k   39M|4447B 1429B|   0     0 |1808  2749
>  10  32   3  52   1   2|  53M   42M|  27k 2296B|   0     0 |2144  4474
>   5  17   0  77   0   1|  88k   38M|5515B  420B|   0     0 |2261  3338
>   6  24   1  67   0   1|  66M   37M|   0     0 |   0     0 |2741  4099
>   2  27  17  53   0   1|  64M   32M|   0     0 |  32k    0 |2331  3356
>   2  35  17  43   0   2|  71M   39M|   0     0 |   0     0 |2460  3713
>   3  33   5  57   0   2|  69M   40M| 189B  202B|   0     0 |2212  3366
>   1  36   0  61   0   1|  72M   42M|   0     0 |   0     0 |2296  3481
>   1  35   0  62   0   2|  69M   40M|   0    65B|   0     0 |2235  3425
>   2  24   0  73   0   1|  37M   39M|   0     0 |   0     0 |2033  2912 ^C
>
> The above 2 results are from a 2.5" SATA disk attached to a USB 2.0
> enclosure which has one USB connector connected to the laptop's USB port.
> This is a self-powered disk enclosure. Filesystems is use were, vfat for
> the former result and ext3 for the latter.
>
> Below are results from a different disk.
>
> ----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
> usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw
>  10  17  26  44   0   2|  32M   35M|   0     0 |   0     0 |3889    18k
>  12  20  34  35   0   0|  34M   36M|   0     0 |   0     0 |3923    19k
>  14  20  21  42   0   1|  36M   36M|   0   648B|   0     0 |4036    20k
>  14  22  21  41   0   0|  45M   37M|   0   324B|   0     0 |4140    24k
>  15  21  10  52   0   2|  35M   35M| 448B  520B|   0     0 |3947    19k
>  10  19  31  40   0   0|  30M   35M|   0     0 |   0     0 |3885    17k
>  18  22  14  46   0   0|  36M   37M|  92B    0 |   0     0 |4029    21k
>  16  21  18  43   0   1|  40M   36M|  92B    0 |   0     0 |3966    21k
>  11  23  28  37   0   0|  37M   36M|  92B    0 |   0     0 |3986    20k
>  11  17  31  41   0   0|  30M   35M|   0     0 |   0     0 |3893    19k
>  12  19   6  62   0   1|  29M   34M|   0     0 |   0     0 |3895    18k
>  12  19   0  67   0   2|  29M   35M|   0     0 |   0     0 |3974    17k
>  17  15   0  66   0   1|  15M   33M|   0     0 |   0     0 |3802    11k
>  32  17   5  46   0   0|  27M   36M| 108B  357B|   0     0 |3943    14k
>  17  14   2  65   0   1|  14M   33M|   0     0 |   0     0 |3884    11k
>  21  20  17  40   0   2|  28M   35M|   0     0 |   0     0 |3916    17k
>  17  24   8  50   0   0|  40M   37M|  55B   96B|   0     0 |3982    22k
>  19  27  13  41   0   0|  52M   37M|   0     0 |   0     0 |4265    29k
>  20  25  13  42   0   0|  40M   36M|   0     0 |   0     0 |3979    22k
>  21  28   8  41   1   2|  52M   36M| 420B  520B|   0     0 |4082    27k
>  20  32  16  31   0   0|  68M   38M|   0     0 |   0     0 |4343    33k^C
>
> This result is from a 2.5" SATA disk connected to a USB 2.0 enclosure with
> 2 USB connectors connected to the laptop. The filesystem is fuse (ntfs-3g=
).
> Looks good.
>
>
> Here's the interesting one.
>
> ----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
> usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw
>  11   3  82   2   0   1|1655k  267k|   0     0 |5486B   12k|1259  1863
>  16  23  25  35   0   0|1360k    0 |3022B  336B|  32k    0 | 972  3043
>   2  44  15  40   0   0|  64k    0 |   0     0 |   0     0 | 902  1141
>   4   3  93   0   0   0|   0     0 |   0     0 |   0     0 | 769  1235
>   5   2  92   0   0   0|   0   368k| 426B  520B|   0     0 | 557  1100
>   4   3  93   0   0   0|   0     0 |  92B    0 |   0     0 | 506  1041
>   4   3  94   0   0   0|   0     0 |   0     0 |   0     0 | 628  1005
>   4   2  93   0   0   0|   0     0 |   0     0 |   0     0 | 547  1036
>   6   2  92   0   0   0|   0     0 |   0     0 |   0     0 | 574   995
>   4   2  94   0   0   0|   0     0 |   0     0 |   0     0 | 593  1126
>   6   3  91   0   0   0|   0     0 | 141B   84B|   0     0 | 684  1165
>   4   3  93   0   0   0|   0     0 |   0     0 |   0     0 | 514  1044
>   4   2  93   0   0   0|   0     0 |   0     0 |   0     0 | 485   850
>   4   3  92   0   0   0|   0     0 | 227B  484B|   0     0 | 645  1116
>   3   2  94   0   0   0|   0     0 |   0     0 |   0     0 | 619  1009
>   4   3  92   1   0   0|8192B 1472k| 108B  292B|   0     0 | 608  1072
>   5   3  92   0   0   0|   0     0 | 187B   72B|   0     0 | 786  1208
>   4   2  94   0   0   0|   0     0 |   0     0 |   0     0 | 587  1098
>   3   3  94   0   0   0|   0     0 |   0     0 |   0     0 | 500   939 ^C
>
>
> This result is from a *3.5"* ATA disk connected to a USB 2.0 enclosure wi=
th
> 2 USB connectors connected to the laptop. The enclosure is externally
> powered. The disk is partition-less. The entire disk (/dev/sdb) is LUKS
> encrypted. The filesystem is ext3.
>
> As soon as I initiated the I/O, the performance went down (as mentioned in
> the above result). Also, the usb port was reset immediately which resulted
> in a read-only filesystem.
>
> Here are the relevant logs.
>
> [44125.008940] usb 5-8: new high speed USB device using ehci_hcd and
> address 10
> [44125.375160] usb 4-2: new full speed USB device using uhci_hcd and
> address 2 [44125.488926] usb 4-2: device descriptor read/64, error -71
> [44125.717839] usb 4-2: not running at top speed; connect to a high speed
> hub [44125.732838] usb 4-2: configuration #1 chosen from 1 choice
> [44125.735518] scsi5 : SCSI emulation for USB Mass Storage devices
> [44125.736912] usb 4-2: New USB device found, idVendor=3D05e3, idProduct=
=3D0702
> [44125.736928] usb 4-2: New USB device strings: Mfr=3D0, Product=3D1,
> SerialNumber=3D0
> [44125.736933] usb 4-2: Product: USB TO IDE
> [44125.737807] usb-storage: device found at 2
> [44125.737814] usb-storage: waiting for device to settle before scanning
> [44130.771126] usb-storage: device scan complete
> [44130.774592] scsi 5:0:0:0: Direct-Access     ST325082 4A             =20
> 0811 PQ: 0 ANSI: 0
> [44130.780522] sd 5:0:0:0: [sdb] 488397168 512-byte hardware sectors
> (250059 MB)
> [44130.787520] sd 5:0:0:0: [sdb] Test WP failed, assume Write Enabled
> [44130.787520] sd 5:0:0:0: [sdb] Assuming drive cache: write through
> [44130.792520] sd 5:0:0:0: [sdb] 488397168 512-byte hardware sectors
> (250059 MB)
> [44130.799520] sd 5:0:0:0: [sdb] Test WP failed, assume Write Enabled
> [44130.799520] sd 5:0:0:0: [sdb] Assuming drive cache: write through
> [44130.799520]  sdb: unknown partition table
> [44130.830056] sd 5:0:0:0: [sdb] Attached SCSI disk
> [44130.830056] sd 5:0:0:0: Attached scsi generic sg2 type 0
> [44273.057272] kjournald starting.  Commit interval 5 seconds
> [44273.064954] EXT3 FS on dm-2, internal journal
> [44273.065232] EXT3-fs: mounted filesystem with ordered data mode.
> [44306.991719] usb 4-2: reset full speed USB device using uhci_hcd and
> address 2
> [44307.232054] usb 4-2: reset full speed USB device using uhci_hcd and
> address 2
> [44307.468171] usb 4-2: reset full speed USB device using uhci_hcd and
> address 2
> [44307.600787] usb 4-2: failed to restore interface 0 altsetting 0
> (error=3D-71) [44307.601609] usb 4-2: USB disconnect, address 2
> [44307.601609] sd 5:0:0:0: [sdb] Result: hostbyte=3DDID_ERROR
> driverbyte=3DDRIVER_OK,SUGGEST_OK
> [44307.601609] end_request: I/O error, dev sdb, sector 248121664
> [44307.601609] Buffer I/O error on device dm-2, logical block 31015079
> [44307.601609] lost page write due to I/O error on dm-2
> [44307.601609] Buffer I/O error on device dm-2, logical block 31015080
> [44307.601609] lost page write due to I/O error on dm-2
> [44307.601609] Buffer I/O error on device dm-2, logical block 31015081
> [44307.601609] lost page write due to I/O error on dm-2
> [44307.601609] Buffer I/O error on device dm-2, logical block 31015082
> [44307.601609] lost page write due to I/O error on dm-2
> [44307.601635] Buffer I/O error on device dm-2, logical block 31015083
> [44307.601639] lost page write due to I/O error on dm-2
> [44307.601648] Buffer I/O error on device dm-2, logical block 31015084
> [44307.602572] lost page write due to I/O error on dm-2
> [44307.602572] Buffer I/O error on device dm-2, logical block 31015085
> [44307.602572] lost page write due to I/O error on dm-2
> [44307.602572] Buffer I/O error on device dm-2, logical block 31015086
> [44307.602572] lost page write due to I/O error on dm-2
> [44307.602572] sd 5:0:0:0: [sdb] Result: hostbyte=3DDID_ERROR
> driverbyte=3DDRIVER_OK,SUGGEST_OK
> [44307.602572] end_request: I/O error, dev sdb, sector 248121728
> [44307.602572] Buffer I/O error on device dm-2, logical block 31015087
> [44307.602572] lost page write due to I/O error on dm-2
> [44307.602572] Buffer I/O error on device dm-2, logical block 31015088
> [44307.602572] lost page write due to I/O error on dm-2
> [44307.602572] sd 5:0:0:0: [sdb] Result: hostbyte=3DDID_ERROR
> driverbyte=3DDRIVER_OK,SUGGEST_OK
> [44307.602572] end_request: I/O error, dev sdb, sector 248121792
> [44307.602572] sd 5:0:0:0: [sdb] Result: hostbyte=3DDID_ERROR
> driverbyte=3DDRIVER_OK,SUGGEST_OK
> [44307.602572] end_request: I/O error, dev sdb, sector 248121856
> [44307.602572] sd 5:0:0:0: [sdb] Result: hostbyte=3DDID_ERROR
> driverbyte=3DDRIVER_OK,SUGGEST_OK
> [44307.602572] end_request: I/O error, dev sdb, sector 248121920
> [44307.602573] sd 5:0:0:0: [sdb] Result: hostbyte=3DDID_ERROR
> driverbyte=3DDRIVER_OK,SUGGEST_OK
> [44307.602573] end_request: I/O error, dev sdb, sector 248121984
> [44307.603601] sd 5:0:0:0: [sdb] Result: hostbyte=3DDID_NO_CONNECT
> driverbyte=3DDRIVER_OK,SUGGEST_OK
> [44307.603609] end_request: I/O error, dev sdb, sector 248122048
> [44307.604568] sd 5:0:0:0: [sdb] Result: hostbyte=3DDID_NO_CONNECT
> driverbyte=3DDRIVER_OK,SUGGEST_OK
> [44307.604568] end_request: I/O error, dev sdb, sector 248122112
> [44307.625509] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44307.763898] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44307.763898] ------------[ cut here ]------------
> [44307.763898] WARNING: at fs/buffer.c:1186 mark_buffer_dirty+0x20/0x67()
> [44307.763898] Modules linked in: sha256_generic aes_i586 aes_generic cbc
> nls_utf8 nls_cp437 vfat fat nls_base usb_storage usbhid hid ff_memless
> tcp_diag inet_diag tun nvidia(P) rfcomm l2cap bluetooth xt_limit
> nf_conntrack_ipv6 ipv6 nf_conntrack_proto_dccp ts_kmp nf_conntrack_amanda
> nf_conntrack_irc nf_conntrack_sip nf_conntrack_netbios_ns nf_conntrack_pp=
tp
> nf_conntrack_proto_gre nf_conntrack_netlink nfnetlink nf_conntrack_ftp
> nf_conntrack_tftp nf_conntrack_sane xt_conntrack nf_conntrack_proto_sctp
> nf_conntrack_proto_udplite nf_conntrack_h323 acpi_cpufreq
> cpufreq_conservative cpufreq_stats cpufreq_userspace cpufreq_powersave
> ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf_conntrack
> ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge kvm_intel k=
vm
> fuse configfs loop firewire_sbp2 dm_crypt snd_hda_intel snd_usb_audio
> snd_pcm_oss snd_mixer_oss snd_pcm snd_usb_lib snd_hwdep arc4 snd_seq_dummy
> ecb crypto_blkcipher snd_seq_oss snd_seq_midi snd_rawmidi uvcvideo iwl3945
> snd_seq_midi_event compat_ioctl32 snd_seq joydev mac80211 videodev i2c_i8=
01
> snd_timer snd_seq_device iTCO_wdt led_class serio_raw snd v4l1_compat
> intel_agp wmi rng_core i2c_core ac cfg80211 psmouse pcspkr agpgart button
> battery video output soundcore snd_page_alloc evdev dcdbas ext3 jbd mbcac=
he
> dm_mirror dm_log dm_snapshot dm_mod sg sr_mod cdrom sd_mod ata_generic
> ata_piix firewire_ohci firewire_core libata scsi_mod crc_itu_t dock b44
> ide_pci_generic ide_core ohci1394 sdhci ieee1394 mmc_core ricoh_mmc ssb
> pcmcia pcmcia_core
> firmware_class mii ehci_hcd uhci_hcd usbcore thermal processor fan
> thermal_sys [44307.763898] Pid: 8632, comm: cp Tainted: P        =20
> 2.6.26-custom #1 [44307.763921]  [<c01219c0>] warn_on_slowpath+0x40/0x79
> [44307.763921]  [<c0119aee>] check_preempt_wakeup+0x97/0xd1
> [44307.763921]  [<c011a404>] try_to_wake_up+0xe8/0xf1
> [44307.763922]  [<c023397e>] vt_console_print+0x32/0x278
> [44307.763922]  [<c023397e>] vt_console_print+0x32/0x278
> [44307.763922]  [<c023394c>] vt_console_print+0x0/0x278
> [44307.763937]  [<c0121c56>] __call_console_drivers+0x4f/0x5b
> [44307.763950]  [<c013484a>] up+0x9/0x2a
> [44307.763969]  [<c0122066>] release_console_sem+0x172/0x18b
> [44307.764087]  [<c0194ed5>] mark_buffer_dirty+0x20/0x67
> [44307.764102]  [<f8b9dccb>] ext3_commit_super+0x3a/0x4e [ext3]
> [44307.764147]  [<f8b9f0e2>] ext3_handle_error+0x6e/0x8e [ext3]
> [44307.764178]  [<f8b9f18d>] ext3_error+0x3a/0x40 [ext3]
> [44307.764237]  [<f8b94707>] read_block_bitmap+0x90/0x115 [ext3]
> [44307.764307]  [<f8b95272>] ext3_new_blocks+0x199/0x569 [ext3]
> [44307.764395]  [<f8b98c45>] ext3_get_blocks_handle+0x332/0x785 [ext3]
> [44307.764395]  [<c0194ac9>] __find_get_block+0x162/0x16c
> [44307.764395]  [<c015bad2>] __rmqueue+0x16/0x1b5
> [44307.764395]  [<f8b99137>] ext3_get_block+0x9f/0xd3 [ext3]
> [44307.764469]  [<c0195ef8>] __block_prepare_write+0x16e/0x373
> [44307.764469]  [<c0196245>] block_write_begin+0x6c/0xc3
> [44307.764469]  [<f8b99098>] ext3_get_block+0x0/0xd3 [ext3]
> [44307.764469]  [<f8b98814>] ext3_write_begin+0xc1/0x168 [ext3]
> [44307.764487]  [<f8b99098>] ext3_get_block+0x0/0xd3 [ext3]
> [44307.764896]  [<c015912d>] generic_file_buffered_write+0xfa/0x56a
> [44307.764997]  [<f8b11925>] journal_stop+0x145/0x14e [jbd]
> [44307.765065]  [<c0159b98>] __generic_file_aio_write_nolock+0x3fa/0x445
> [44307.765141]  [<c018acfa>] mnt_want_write+0x1a/0x5e
> [44307.765157]  [<c018b649>] mnt_drop_write+0x1a/0xb2
> [44307.765172]  [<c015a194>] generic_file_aio_read+0x474/0x4fa
> [44307.765203]  [<c0159c43>] generic_file_aio_write+0x60/0xb7
> [44307.765253]  [<f8b95f6c>] ext3_file_write+0x19/0x85 [ext3]
> [44307.765289]  [<c017815d>] do_sync_write+0xc0/0x107
> [44307.765369]  [<c013140a>] autoremove_wake_function+0x0/0x2d
> [44307.765394]  [<c011e114>] hrtick_set+0x7b/0xe6
> [44307.765455]  [<c017809d>] do_sync_write+0x0/0x107
> [44307.765469]  [<c01789d9>] vfs_write+0x84/0x121
> [44307.765495]  [<c0178b0e>] sys_write+0x3c/0x63
> [44307.765525]  [<c010398a>] syscall_call+0x7/0xb
> [44307.765894]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> [44307.765894] ---[ end trace 2a0ce193654d04fb ]---
> [44307.884076] usb 4-2: new full speed USB device using uhci_hcd and
> address 3 [44308.017388] usb 4-2: device descriptor read/all, error -71
> [44308.026550] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.047000] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.056026] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.075044] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.090090] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.102860] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.117901] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.122647] usb 4-2: new full speed USB device using uhci_hcd and
> address 4 [44308.127745] EXT3-fs error (device dm-2): read_block_bitmap:
> Cannot read block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.136581] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.150331] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.159068] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.168617] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.185580] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.200611] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.204343] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.217310] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.228915] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.254557] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.270601] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.300419] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.301453] usb 4-2: string descriptor 0 read error: -71
> [44308.301572] usb 4-2: configuration #1 chosen from 1 choice
> [44308.308850] usb 4-2: can't set config #1, error -71
> [44308.308899] usb 4-2: New USB device found, idVendor=3D05e3, idProduct=
=3D0702
> [44308.308899] usb 4-2: New USB device strings: Mfr=3D0, Product=3D1,
> SerialNumber=3D0
> [44308.328418] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.336523] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.367727] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.384314] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.399502] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.423943] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.439201] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.450486] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.460527] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.464059] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.477362] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.498686] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.516538] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.520738] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.540687] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.557256] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.579235] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.590239] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.605335] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.628031] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44308.990689] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read
> block bitmap - block_group =3D 966, block_bitmap =3D 31653888
> [44309.667656] Aborting journal on device dm-2.
> [44309.668659] __journal_remove_journal_head: freeing b_committed_data
> [44309.668659] __journal_remove_journal_head: freeing b_frozen_data
> [44309.668659] __journal_remove_journal_head: freeing b_frozen_data
> [44309.668659] __journal_remove_journal_head: freeing b_frozen_data
> [44309.668659] __journal_remove_journal_head: freeing b_frozen_data
> [44309.668659] __journal_remove_journal_head: freeing b_frozen_data
> [44309.668659] __journal_remove_journal_head: freeing b_frozen_data
> [44309.679137] ext3_abort called.
> [44309.679137] EXT3-fs error (device dm-2): ext3_journal_start_sb: Detect=
ed
> aborted journal
> [44309.679137] Remounting filesystem read-only
> [44338.161517] __ratelimit: 26116 messages suppressed
> [44338.161517] Buffer I/O error on device dm-2, logical block 8
> [44338.161517] lost page write due to I/O error on dm-2
> [44338.161517] Buffer I/O error on device dm-2, logical block 1027
> [44338.161517] lost page write due to I/O error on dm-2
> [44338.161517] Buffer I/O error on device dm-2, logical block 1539
> [44338.161517] lost page write due to I/O error on dm-2
> [44338.161531] Buffer I/O error on device dm-2, logical block 30998528
> [44338.161538] lost page write due to I/O error on dm-2
> [44338.162759] Buffer I/O error on device dm-2, logical block 30998529
> [44338.162767] lost page write due to I/O error on dm-2
> [44338.162776] Buffer I/O error on device dm-2, logical block 30998530
> [44338.162781] lost page write due to I/O error on dm-2
>
>
> This makes me feel that it might be a hardware issue.
>
> Ritesh

=2D-=20
Ritesh Raj Sarraf
RESEARCHUT - http://www.researchut.com
"Necessity is the mother of invention."


--nextPart1861260.ZdNtoRABJL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkls8OcACgkQ4Rhi6gTxMLwuZQCgrVlbDxh3EU700KgnKoxWU28D
l0YAn1ufVooRHQyglelO6IHiamVDgRgW
=ahoY
-----END PGP SIGNATURE-----

--nextPart1861260.ZdNtoRABJL--


--===============1748734944==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1748734944==--
