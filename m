From: Ritesh Raj Sarraf <rrs@researchut.com>
Subject: Re: dm-crypt low performance
Date: Tue, 13 Jan 2009 23:07:45 +0530
Message-ID: <200901132307.47381.rrs@researchut.com>
References: <0ths36-dce.ln1@news.researchut.com> <496CB858.70803@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0334662826=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <496CB858.70803@redhat.com>
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
Cc: dm-crypt@saout.de, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0334662826==
Content-Type: multipart/signed; boundary="nextPart615940068.Sy5SZTDCAf";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart615940068.Sy5SZTDCAf
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 13 Jan 2009 21:20:48 Milan Broz wrote:
> Ritesh Raj Sarraf wrote:
> > I'm using dm-crypt on an external USB enclosure ide hdd. I copied 20Gb =
of
> > data on to the encrypted device and am suffering severe performance
> > penalty. After a couple of seconds, all processes involved in the I/O
> > keep stalling. They periodically resume, just for a couple of seconds a=
nd
> > then again stall.
> >
> > Running linux 2.6.26.
>
> Please can you try it without dm-crypt involved?
> Just copy 20Gb to your unencrypted disk attached through USB.
>
> I saw this problem with plain USB attached storage some time ago too.
>
> There is only one thread in dm-crypt and it is waiting for io_schedule,
> so I think it is not dm-crypt who is blocking it, but the layer
> below the dm-crypt.

So I tried the following.

Copied 20Gb of data to a partition on the External USB disk. Here are the=20
results:

=2D---total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw=20
 11  10   0  79   0   1|  22M   39M|2864B 2454B|   0     0 |2048  3793=20
 12   9   1  76   0   1|  23M   39M|  81k 8686B|   0     0 |2166  3635=20
 13   8  16  62   0   1|  27M   43M|  12k 5036B|   0     0 |2127  3526=20
 14   8  37  40   0   1|  24M   42M|7138B 5140B|   0     0 |2047  3415=20
  7   8  47  36   0   0|  35M   40M|2451B 2538B|   0     0 |2002  3179=20
  4   9  49  37   0   0|  41M   40M|4081B  276B|   0     0 |1974  2956=20
  1   9  50  38   0   1|  40M   40M|   0   276B|   0     0 |1912  2774=20
  1   8  50  39   0   1|  40M   40M|  92B    0 |   0     0 |2018  2958=20
  2   9  48  39   0   0|  44M   40M| 362B  276B|   0     0 |2097  3191=20
  8   8  45  38   0   1|  27M   33M|  23k 4181B|   0     0 |1919  3009
  8   8  50  34   0   0|  31M   26M|  10k 2570B|   0     0 |1760  2724
 21  11  33  30   0   3|  40M   40M| 204k   17k|   0     0 |2360  3845
 13   8  43  36   0   0|  35M   39M|  12k 5354B|   0     0 |2083  3349
 16   8  41  35   0   0|  30M   35M|5738B 4158B|   0     0 |1904  3118
  8  10  47  33   0   1|  40M   37M|1718B 1255B|   0     0 |1932  3130
  3   9  49  39   0   1|  40M   40M|   0     0 |   0     0 |2124  3065
  4   9  46  41   0   0|  40M   40M|   0     0 |   0     0 |1971  3088
  6   9  46  40   0   0|  40M   41M| 850B  723B|   0     0 |2059  3155
  3  10  46  39   0   1|  40M   42M|1958B 1651B|   0     0 |2054  3217
  8  12  41  38   0   1|  41M   39M|2741B 1342B|   0     0 |2083  3647
  4   8  47  40   0   0|  39M   39M|2062B 1299B|   0     0 |2060  3328

Looks good.

Then I tried copying 20Gb of data to the dm-crypted partition on the same U=
SB=20
disk. Here are the results:

=2D---total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw=20
  3  28   0  67   0   1|  20M   41M|   0     0 |   0     0 |1972  3036
 25  29   0  44   0   2|  39M   42M|   0    78B|  52k    0 |1800  3612
 41  22   0  35   0   1|8952k   40M|  54B   65B|   0     0 |1493  3471
 21  24   0  54   0   1|2040k   42M|1469B 1591B|   0     0 |2180  5170
 16  24   0  59   0   1|  14M   44M|  25k 4962B|   0     0 |1991  4541
 12  11  17  58   0   2|  36M   19M|  28k 2964B|  44k    0 |2351  3774
 19  28  14  37   0   1|  40M   19M|  72k 5062B|   0     0 |1707  3906
 14  29   0  54   0   3|  58M   42M| 108k 7586B|   0     0 |2431  4646
  8  23   0  67   0   2|  44M   35M|  77k 4188B|   0     0 |2948  4587
 22  19   6  50   0   1|  30M   38M|  41k 2666B|   0     0 |2127  3924
  6  33  29  31   0   1|  52M   38M|7628B 1511B|   0     0 |2055  3375
  4  25   0  70   0   1|4624k   39M|4447B 1429B|   0     0 |1808  2749
 10  32   3  52   1   2|  53M   42M|  27k 2296B|   0     0 |2144  4474
  5  17   0  77   0   1|  88k   38M|5515B  420B|   0     0 |2261  3338
  6  24   1  67   0   1|  66M   37M|   0     0 |   0     0 |2741  4099
  2  27  17  53   0   1|  64M   32M|   0     0 |  32k    0 |2331  3356
  2  35  17  43   0   2|  71M   39M|   0     0 |   0     0 |2460  3713
  3  33   5  57   0   2|  69M   40M| 189B  202B|   0     0 |2212  3366
  1  36   0  61   0   1|  72M   42M|   0     0 |   0     0 |2296  3481
  1  35   0  62   0   2|  69M   40M|   0    65B|   0     0 |2235  3425
  2  24   0  73   0   1|  37M   39M|   0     0 |   0     0 |2033  2912 ^C

The above 2 results are from a 2.5" SATA disk attached to a USB 2.0 enclosu=
re=20
which has one USB connector connected to the laptop's USB port. This is a=20
self-powered disk enclosure. Filesystems is use were, vfat for the former=20
result and ext3 for the latter.

Below are results from a different disk.

=2D---total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system-- =
=20
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw  =20
 10  17  26  44   0   2|  32M   35M|   0     0 |   0     0 |3889    18k
 12  20  34  35   0   0|  34M   36M|   0     0 |   0     0 |3923    19k
 14  20  21  42   0   1|  36M   36M|   0   648B|   0     0 |4036    20k
 14  22  21  41   0   0|  45M   37M|   0   324B|   0     0 |4140    24k
 15  21  10  52   0   2|  35M   35M| 448B  520B|   0     0 |3947    19k
 10  19  31  40   0   0|  30M   35M|   0     0 |   0     0 |3885    17k
 18  22  14  46   0   0|  36M   37M|  92B    0 |   0     0 |4029    21k
 16  21  18  43   0   1|  40M   36M|  92B    0 |   0     0 |3966    21k
 11  23  28  37   0   0|  37M   36M|  92B    0 |   0     0 |3986    20k
 11  17  31  41   0   0|  30M   35M|   0     0 |   0     0 |3893    19k
 12  19   6  62   0   1|  29M   34M|   0     0 |   0     0 |3895    18k
 12  19   0  67   0   2|  29M   35M|   0     0 |   0     0 |3974    17k
 17  15   0  66   0   1|  15M   33M|   0     0 |   0     0 |3802    11k
 32  17   5  46   0   0|  27M   36M| 108B  357B|   0     0 |3943    14k
 17  14   2  65   0   1|  14M   33M|   0     0 |   0     0 |3884    11k
 21  20  17  40   0   2|  28M   35M|   0     0 |   0     0 |3916    17k
 17  24   8  50   0   0|  40M   37M|  55B   96B|   0     0 |3982    22k
 19  27  13  41   0   0|  52M   37M|   0     0 |   0     0 |4265    29k
 20  25  13  42   0   0|  40M   36M|   0     0 |   0     0 |3979    22k
 21  28   8  41   1   2|  52M   36M| 420B  520B|   0     0 |4082    27k
 20  32  16  31   0   0|  68M   38M|   0     0 |   0     0 |4343    33k^C

This result is from a 2.5" SATA disk connected to a USB 2.0 enclosure with =
2=20
USB connectors connected to the laptop. The filesystem is fuse (ntfs-3g).
Looks good.


Here's the interesting one.

=2D---total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw
 11   3  82   2   0   1|1655k  267k|   0     0 |5486B   12k|1259  1863
 16  23  25  35   0   0|1360k    0 |3022B  336B|  32k    0 | 972  3043
  2  44  15  40   0   0|  64k    0 |   0     0 |   0     0 | 902  1141
  4   3  93   0   0   0|   0     0 |   0     0 |   0     0 | 769  1235
  5   2  92   0   0   0|   0   368k| 426B  520B|   0     0 | 557  1100
  4   3  93   0   0   0|   0     0 |  92B    0 |   0     0 | 506  1041
  4   3  94   0   0   0|   0     0 |   0     0 |   0     0 | 628  1005
  4   2  93   0   0   0|   0     0 |   0     0 |   0     0 | 547  1036
  6   2  92   0   0   0|   0     0 |   0     0 |   0     0 | 574   995
  4   2  94   0   0   0|   0     0 |   0     0 |   0     0 | 593  1126
  6   3  91   0   0   0|   0     0 | 141B   84B|   0     0 | 684  1165
  4   3  93   0   0   0|   0     0 |   0     0 |   0     0 | 514  1044
  4   2  93   0   0   0|   0     0 |   0     0 |   0     0 | 485   850
  4   3  92   0   0   0|   0     0 | 227B  484B|   0     0 | 645  1116
  3   2  94   0   0   0|   0     0 |   0     0 |   0     0 | 619  1009
  4   3  92   1   0   0|8192B 1472k| 108B  292B|   0     0 | 608  1072
  5   3  92   0   0   0|   0     0 | 187B   72B|   0     0 | 786  1208
  4   2  94   0   0   0|   0     0 |   0     0 |   0     0 | 587  1098
  3   3  94   0   0   0|   0     0 |   0     0 |   0     0 | 500   939 ^C


This result is from a *3.5"* ATA disk connected to a USB 2.0 enclosure with=
 2=20
USB connectors connected to the laptop. The enclosure is externally powered=
=2E=20
The disk is partition-less. The entire disk (/dev/sdb) is LUKS encrypted.
The filesystem is ext3.

As soon as I initiated the I/O, the performance went down (as mentioned in =
the=20
above result). Also, the usb port was reset immediately which resulted in a=
=20
read-only filesystem.

Here are the relevant logs.

[44125.008940] usb 5-8: new high speed USB device using ehci_hcd and addres=
s=20
10                                      =20
[44125.375160] usb 4-2: new full speed USB device using uhci_hcd and addres=
s 2                                       =20
[44125.488926] usb 4-2: device descriptor read/64, error -71               =
                                          =20
[44125.717839] usb 4-2: not running at top speed; connect to a high speed h=
ub                                        =20
[44125.732838] usb 4-2: configuration #1 chosen from 1 choice              =
                                          =20
[44125.735518] scsi5 : SCSI emulation for USB Mass Storage devices         =
                                          =20
[44125.736912] usb 4-2: New USB device found, idVendor=3D05e3, idProduct=3D=
0702                                          =20
[44125.736928] usb 4-2: New USB device strings: Mfr=3D0, Product=3D1,=20
SerialNumber=3D0                                     =20
[44125.736933] usb 4-2: Product: USB TO IDE                                =
                                          =20
[44125.737807] usb-storage: device found at 2                              =
                                          =20
[44125.737814] usb-storage: waiting for device to settle before scanning   =
                                          =20
[44130.771126] usb-storage: device scan complete                           =
                                          =20
[44130.774592] scsi 5:0:0:0: Direct-Access     ST325082 4A               08=
11=20
PQ: 0 ANSI: 0                          =20
[44130.780522] sd 5:0:0:0: [sdb] 488397168 512-byte hardware sectors (25005=
9=20
MB)                                     =20
[44130.787520] sd 5:0:0:0: [sdb] Test WP failed, assume Write Enabled      =
                                          =20
[44130.787520] sd 5:0:0:0: [sdb] Assuming drive cache: write through       =
                                          =20
[44130.792520] sd 5:0:0:0: [sdb] 488397168 512-byte hardware sectors (25005=
9=20
MB)                                     =20
[44130.799520] sd 5:0:0:0: [sdb] Test WP failed, assume Write Enabled      =
                                          =20
[44130.799520] sd 5:0:0:0: [sdb] Assuming drive cache: write through       =
                                          =20
[44130.799520]  sdb: unknown partition table                               =
                                          =20
[44130.830056] sd 5:0:0:0: [sdb] Attached SCSI disk                        =
                                          =20
[44130.830056] sd 5:0:0:0: Attached scsi generic sg2 type 0                =
                                          =20
[44273.057272] kjournald starting.  Commit interval 5 seconds              =
                                          =20
[44273.064954] EXT3 FS on dm-2, internal journal                           =
                                          =20
[44273.065232] EXT3-fs: mounted filesystem with ordered data mode.         =
                                          =20
[44306.991719] usb 4-2: reset full speed USB device using uhci_hcd and addr=
ess=20
2                                     =20
[44307.232054] usb 4-2: reset full speed USB device using uhci_hcd and addr=
ess=20
2                                     =20
[44307.468171] usb 4-2: reset full speed USB device using uhci_hcd and addr=
ess=20
2                                     =20
[44307.600787] usb 4-2: failed to restore interface 0 altsetting 0 (error=
=3D-71)                                       =20
[44307.601609] usb 4-2: USB disconnect, address 2                          =
                                          =20
[44307.601609] sd 5:0:0:0: [sdb] Result: hostbyte=3DDID_ERROR=20
driverbyte=3DDRIVER_OK,SUGGEST_OK                          =20
[44307.601609] end_request: I/O error, dev sdb, sector 248121664           =
                                          =20
[44307.601609] Buffer I/O error on device dm-2, logical block 31015079     =
                                          =20
[44307.601609] lost page write due to I/O error on dm-2                    =
                                          =20
[44307.601609] Buffer I/O error on device dm-2, logical block 31015080     =
                                          =20
[44307.601609] lost page write due to I/O error on dm-2                    =
                                          =20
[44307.601609] Buffer I/O error on device dm-2, logical block 31015081     =
                                          =20
[44307.601609] lost page write due to I/O error on dm-2                    =
                                          =20
[44307.601609] Buffer I/O error on device dm-2, logical block 31015082     =
                                          =20
[44307.601609] lost page write due to I/O error on dm-2                    =
                                          =20
[44307.601635] Buffer I/O error on device dm-2, logical block 31015083     =
                                          =20
[44307.601639] lost page write due to I/O error on dm-2                    =
                                          =20
[44307.601648] Buffer I/O error on device dm-2, logical block 31015084     =
                                          =20
[44307.602572] lost page write due to I/O error on dm-2                    =
                                          =20
[44307.602572] Buffer I/O error on device dm-2, logical block 31015085     =
                                          =20
[44307.602572] lost page write due to I/O error on dm-2                    =
                                          =20
[44307.602572] Buffer I/O error on device dm-2, logical block 31015086     =
                                          =20
[44307.602572] lost page write due to I/O error on dm-2                    =
                                          =20
[44307.602572] sd 5:0:0:0: [sdb] Result: hostbyte=3DDID_ERROR=20
driverbyte=3DDRIVER_OK,SUGGEST_OK                          =20
[44307.602572] end_request: I/O error, dev sdb, sector 248121728           =
                                          =20
[44307.602572] Buffer I/O error on device dm-2, logical block 31015087     =
                                          =20
[44307.602572] lost page write due to I/O error on dm-2                    =
                                          =20
[44307.602572] Buffer I/O error on device dm-2, logical block 31015088     =
                                          =20
[44307.602572] lost page write due to I/O error on dm-2                    =
                                          =20
[44307.602572] sd 5:0:0:0: [sdb] Result: hostbyte=3DDID_ERROR=20
driverbyte=3DDRIVER_OK,SUGGEST_OK                          =20
[44307.602572] end_request: I/O error, dev sdb, sector 248121792           =
                                          =20
[44307.602572] sd 5:0:0:0: [sdb] Result: hostbyte=3DDID_ERROR=20
driverbyte=3DDRIVER_OK,SUGGEST_OK                          =20
[44307.602572] end_request: I/O error, dev sdb, sector 248121856           =
                                          =20
[44307.602572] sd 5:0:0:0: [sdb] Result: hostbyte=3DDID_ERROR=20
driverbyte=3DDRIVER_OK,SUGGEST_OK                          =20
[44307.602572] end_request: I/O error, dev sdb, sector 248121920           =
                                          =20
[44307.602573] sd 5:0:0:0: [sdb] Result: hostbyte=3DDID_ERROR=20
driverbyte=3DDRIVER_OK,SUGGEST_OK                          =20
[44307.602573] end_request: I/O error, dev sdb, sector 248121984           =
                                          =20
[44307.603601] sd 5:0:0:0: [sdb] Result: hostbyte=3DDID_NO_CONNECT=20
driverbyte=3DDRIVER_OK,SUGGEST_OK                     =20
[44307.603609] end_request: I/O error, dev sdb, sector 248122048           =
                                          =20
[44307.604568] sd 5:0:0:0: [sdb] Result: hostbyte=3DDID_NO_CONNECT=20
driverbyte=3DDRIVER_OK,SUGGEST_OK                     =20
[44307.604568] end_request: I/O error, dev sdb, sector 248122112           =
                                          =20
[44307.625509] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44307.763898] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44307.763898] ------------[ cut here ]------------                        =
                                          =20
[44307.763898] WARNING: at fs/buffer.c:1186 mark_buffer_dirty+0x20/0x67()  =
                                          =20
[44307.763898] Modules linked in: sha256_generic aes_i586 aes_generic cbc=20
nls_utf8 nls_cp437 vfat fat nls_base usb_storage usbhid hid ff_memless tcp_=
diag=20
inet_diag tun nvidia(P) rfcomm l2cap bluetooth xt_limit nf_conntrack_ipv6 i=
pv6=20
nf_conntrack_proto_dccp ts_kmp nf_conntrack_amanda nf_conntrack_irc=20
nf_conntrack_sip nf_conntrack_netbios_ns nf_conntrack_pptp=20
nf_conntrack_proto_gre nf_conntrack_netlink nfnetlink nf_conntrack_ftp=20
nf_conntrack_tftp nf_conntrack_sane xt_conntrack nf_conntrack_proto_sctp=20
nf_conntrack_proto_udplite nf_conntrack_h323 acpi_cpufreq cpufreq_conservat=
ive=20
cpufreq_stats cpufreq_userspace cpufreq_powersave ipt_MASQUERADE iptable_na=
t=20
nf_nat nf_conntrack_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp=20
iptable_filter ip_tables x_tables bridge kvm_intel kvm fuse configfs loop=20
firewire_sbp2 dm_crypt snd_hda_intel snd_usb_audio snd_pcm_oss snd_mixer_os=
s=20
snd_pcm snd_usb_lib snd_hwdep arc4 snd_seq_dummy ecb crypto_blkcipher=20
snd_seq_oss snd_seq_midi snd_rawmidi uvcvideo iwl3945 snd_seq_midi_event=20
compat_ioctl32 snd_seq joydev mac80211 videodev i2c_i801 snd_timer=20
snd_seq_device iTCO_wdt led_class serio_raw snd v4l1_compat intel_agp wmi=20
rng_core i2c_core ac cfg80211 psmouse pcspkr agpgart button battery video=20
output soundcore snd_page_alloc evdev dcdbas ext3 jbd mbcache dm_mirror dm_=
log=20
dm_snapshot dm_mod sg sr_mod cdrom sd_mod ata_generic ata_piix firewire_ohc=
i=20
firewire_core libata scsi_mod crc_itu_t dock b44 ide_pci_generic ide_core=20
ohci1394 sdhci ieee1394 mmc_core ricoh_mmc ssb pcmcia pcmcia_core=20
firmware_class mii ehci_hcd uhci_hcd usbcore thermal processor fan thermal_=
sys                                        =20
[44307.763898] Pid: 8632, comm: cp Tainted: P          2.6.26-custom #1    =
                                          =20
[44307.763921]  [<c01219c0>] warn_on_slowpath+0x40/0x79                    =
                                          =20
[44307.763921]  [<c0119aee>] check_preempt_wakeup+0x97/0xd1                =
                                          =20
[44307.763921]  [<c011a404>] try_to_wake_up+0xe8/0xf1                      =
                                          =20
[44307.763922]  [<c023397e>] vt_console_print+0x32/0x278                   =
                                          =20
[44307.763922]  [<c023397e>] vt_console_print+0x32/0x278                   =
                                          =20
[44307.763922]  [<c023394c>] vt_console_print+0x0/0x278                    =
                                          =20
[44307.763937]  [<c0121c56>] __call_console_drivers+0x4f/0x5b              =
                                          =20
[44307.763950]  [<c013484a>] up+0x9/0x2a                                   =
                                          =20
[44307.763969]  [<c0122066>] release_console_sem+0x172/0x18b               =
                                          =20
[44307.764087]  [<c0194ed5>] mark_buffer_dirty+0x20/0x67                   =
                                          =20
[44307.764102]  [<f8b9dccb>] ext3_commit_super+0x3a/0x4e [ext3]            =
                                          =20
[44307.764147]  [<f8b9f0e2>] ext3_handle_error+0x6e/0x8e [ext3]            =
                                          =20
[44307.764178]  [<f8b9f18d>] ext3_error+0x3a/0x40 [ext3]                   =
                                          =20
[44307.764237]  [<f8b94707>] read_block_bitmap+0x90/0x115 [ext3]           =
                                          =20
[44307.764307]  [<f8b95272>] ext3_new_blocks+0x199/0x569 [ext3]            =
                                          =20
[44307.764395]  [<f8b98c45>] ext3_get_blocks_handle+0x332/0x785 [ext3]     =
                                          =20
[44307.764395]  [<c0194ac9>] __find_get_block+0x162/0x16c                  =
                                          =20
[44307.764395]  [<c015bad2>] __rmqueue+0x16/0x1b5                          =
                                          =20
[44307.764395]  [<f8b99137>] ext3_get_block+0x9f/0xd3 [ext3]               =
                                          =20
[44307.764469]  [<c0195ef8>] __block_prepare_write+0x16e/0x373             =
                                          =20
[44307.764469]  [<c0196245>] block_write_begin+0x6c/0xc3                   =
                                          =20
[44307.764469]  [<f8b99098>] ext3_get_block+0x0/0xd3 [ext3]                =
                                          =20
[44307.764469]  [<f8b98814>] ext3_write_begin+0xc1/0x168 [ext3]            =
                                          =20
[44307.764487]  [<f8b99098>] ext3_get_block+0x0/0xd3 [ext3]                =
                                          =20
[44307.764896]  [<c015912d>] generic_file_buffered_write+0xfa/0x56a        =
                                          =20
[44307.764997]  [<f8b11925>] journal_stop+0x145/0x14e [jbd]                =
                                          =20
[44307.765065]  [<c0159b98>] __generic_file_aio_write_nolock+0x3fa/0x445   =
                                          =20
[44307.765141]  [<c018acfa>] mnt_want_write+0x1a/0x5e                      =
                                          =20
[44307.765157]  [<c018b649>] mnt_drop_write+0x1a/0xb2                      =
                                          =20
[44307.765172]  [<c015a194>] generic_file_aio_read+0x474/0x4fa             =
                                          =20
[44307.765203]  [<c0159c43>] generic_file_aio_write+0x60/0xb7              =
                                          =20
[44307.765253]  [<f8b95f6c>] ext3_file_write+0x19/0x85 [ext3]              =
                                          =20
[44307.765289]  [<c017815d>] do_sync_write+0xc0/0x107                      =
                                          =20
[44307.765369]  [<c013140a>] autoremove_wake_function+0x0/0x2d             =
                                          =20
[44307.765394]  [<c011e114>] hrtick_set+0x7b/0xe6                          =
                                          =20
[44307.765455]  [<c017809d>] do_sync_write+0x0/0x107                       =
                                          =20
[44307.765469]  [<c01789d9>] vfs_write+0x84/0x121                          =
                                          =20
[44307.765495]  [<c0178b0e>] sys_write+0x3c/0x63                           =
                                          =20
[44307.765525]  [<c010398a>] syscall_call+0x7/0xb                          =
                                          =20
[44307.765894]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D                                                               =
               =20
[44307.765894] ---[ end trace 2a0ce193654d04fb ]---                        =
                                          =20
[44307.884076] usb 4-2: new full speed USB device using uhci_hcd and addres=
s 3                                       =20
[44308.017388] usb 4-2: device descriptor read/all, error -71              =
                                          =20
[44308.026550] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.047000] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.056026] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.075044] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.090090] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.102860] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.117901] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.122647] usb 4-2: new full speed USB device using uhci_hcd and addres=
s 4                                       =20
[44308.127745] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.136581] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.150331] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.159068] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.168617] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.185580] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.200611] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.204343] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.217310] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.228915] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.254557] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.270601] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.300419] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.301453] usb 4-2: string descriptor 0 read error: -71                =
                                          =20
[44308.301572] usb 4-2: configuration #1 chosen from 1 choice              =
                                          =20
[44308.308850] usb 4-2: can't set config #1, error -71                     =
                                          =20
[44308.308899] usb 4-2: New USB device found, idVendor=3D05e3, idProduct=3D=
0702                                          =20
[44308.308899] usb 4-2: New USB device strings: Mfr=3D0, Product=3D1,=20
SerialNumber=3D0                                     =20
[44308.328418] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.336523] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.367727] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.384314] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.399502] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.423943] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.439201] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.450486] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.460527] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.464059] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.477362] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.498686] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.516538] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.520738] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.540687] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.557256] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.579235] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.590239] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.605335] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.628031] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44308.990689] EXT3-fs error (device dm-2): read_block_bitmap: Cannot read=
=20
block bitmap - block_group =3D 966, block_bitmap =3D 31653888              =
                                                                           =
              =20
[44309.667656] Aborting journal on device dm-2.                            =
                                          =20
[44309.668659] __journal_remove_journal_head: freeing b_committed_data     =
                                          =20
[44309.668659] __journal_remove_journal_head: freeing b_frozen_data        =
                                          =20
[44309.668659] __journal_remove_journal_head: freeing b_frozen_data
[44309.668659] __journal_remove_journal_head: freeing b_frozen_data
[44309.668659] __journal_remove_journal_head: freeing b_frozen_data
[44309.668659] __journal_remove_journal_head: freeing b_frozen_data
[44309.668659] __journal_remove_journal_head: freeing b_frozen_data
[44309.679137] ext3_abort called.
[44309.679137] EXT3-fs error (device dm-2): ext3_journal_start_sb: Detected=
=20
aborted journal
[44309.679137] Remounting filesystem read-only
[44338.161517] __ratelimit: 26116 messages suppressed
[44338.161517] Buffer I/O error on device dm-2, logical block 8
[44338.161517] lost page write due to I/O error on dm-2
[44338.161517] Buffer I/O error on device dm-2, logical block 1027
[44338.161517] lost page write due to I/O error on dm-2
[44338.161517] Buffer I/O error on device dm-2, logical block 1539
[44338.161517] lost page write due to I/O error on dm-2
[44338.161531] Buffer I/O error on device dm-2, logical block 30998528
[44338.161538] lost page write due to I/O error on dm-2
[44338.162759] Buffer I/O error on device dm-2, logical block 30998529
[44338.162767] lost page write due to I/O error on dm-2
[44338.162776] Buffer I/O error on device dm-2, logical block 30998530
[44338.162781] lost page write due to I/O error on dm-2


This makes me feel that it might be a hardware issue.

Ritesh
=2D-=20
Ritesh Raj Sarraf
RESEARCHUT - http://www.researchut.com
"Necessity is the mother of invention."


--nextPart615940068.Sy5SZTDCAf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkls0WsACgkQ4Rhi6gTxMLzbvgCfdf3OnEd1txSlb8MptzfxVTGc
/roAn0zhrUl+hreCj0x2qCe8vWxpyI7I
=We9l
-----END PGP SIGNATURE-----

--nextPart615940068.Sy5SZTDCAf--


--===============0334662826==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0334662826==--
