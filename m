From: Claudio Cuqui <claudio@c3systems.com.br>
Subject: Multipath not "seeing" last luns when create mpath
	devices
Date: Wed, 06 Jun 2007 13:41:05 -0300
Message-ID: <4666E3A1.2050308@c3systems.com.br>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1660612530=="
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
To: christophe.varoqui@free.fr, dm-devel@redhat.com
List-Id: dm-devel.ids

This is a cryptographically signed message in MIME format.

--===============1660612530==
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=sha1; boundary="------------ms080203070304050209040507"

This is a cryptographically signed message in MIME format.

--------------ms080203070304050209040507
Content-Type: multipart/alternative;
	boundary="------------090006000104030108010704"

This is a multi-part message in MIME format.
--------------090006000104030108010704
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

*Distro - Fedora Core 6 - x86_64 - fully updated

Relevant packages:

lvm2-2.02.17-1.fc6
device-mapper-multipath-0.4.7-5
device-mapper-1.02.13-1.fc6
kernel-2.6.20-1.2952.fc6

HBA: Qlogic 2300

Storage: EMC Clariion CX700 - Flarecode = 02,19,700,5030

How reproducible: All the time

Problems:

1-) Lots of error messages when running lvm commands (even after 
filtering passive devices in lvm.conf)

*filter = [ "r|/dev/cdrom|", "r|/dev/sdc|",  "r|/dev/sdd|", 
"r|/dev/sde|",  "r|/dev/sdf|", "r|/dev/sdg|", "r|/dev/sdh|", 
"r|/dev/sdi|", "r|/dev/sdj|", "r|/dev/sdk|", "r|/dev/sdl|", 
"r|/dev/sdm|", "r|/dev/sdn|", "r|/dev/sdo|", "r|/dev/sdp|", 
"r|/dev/sdq|", "r|/dev/sdr|", "r|/dev/sds|", "r|/dev/sdt|", 
"r|/dev/sdu|", "r|/dev/sdv|", "r|/dev/sdw|", "r|/dev/sdx|", 
"r|/dev/sdy|", "r|/dev/sdz|", "r|/dev/sdaa|", "r|/dev/sdab|", 
"r|/dev/sdac|", "r|/dev/sdad|", "r|/dev/sdaf|", "r|/dev/sdag|", 
"r|/dev/sdah|", "r|/dev/sdai|", "r|/dev/sdaj|",  "r|/dev/sdak|",  
"r|/dev/sdal|",  "r|/dev/sdam|",  "r|/dev/sdan|", "a/.*/" ]*


*[root@pop-16 mapper]# vgdisplay -v pop_16-c3-data
    Using volume group(s) on command line
    Finding volume group "pop_16-c3-data"
  /dev/sdq: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdah: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdah1: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdc: read failed after 0 of 4096 at 0: Input/output error
  /dev/sds: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdc1: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdaj: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdaj1: read failed after 0 of 4096 at 0: Input/output error
  /dev/sde: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdu: read failed after 0 of 4096 at 0: Input/output error
  /dev/sde1: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdv: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdal: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdal1: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdg: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdx: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdan: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdi: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdz: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdk: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdab: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdab1: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdm: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdad: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdad1: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdo: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdaf: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdaf1: read failed after 0 of 4096 at 0: Input/output error
  --- Volume group ---
  VG Name               pop_16-c3-data
  System ID
  Format                lvm2
  Metadata Areas        19
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                19
  Act PV                19
  VG Size               949.41 GB
  PE Size               32.00 MB
  Total PE              30381
  Alloc PE / Size       0 / 0
  Free  PE / Size       30381 / 949.41 GB
  VG UUID               3dwnTE-OAUx-ArDu-rjT5-AfhE-IfO3-fRwNTB

  --- Physical volumes ---
  PV Name               /dev/mapper/mpath0p1
  PV UUID               VWhmRd-JivO-8omn-fVou-yjEA-0euc-3KXrvh
  PV Status             allocatable
  Total PE / Free PE    1599 / 1599

  PV Name               /dev/mapper/mpath1p1
  PV UUID               13dA0R-fO0J-c7iJ-xywx-zgDO-SCxe-WBn8hh
  PV Status             allocatable
  Total PE / Free PE    1599 / 1599

  PV Name               /dev/mapper/mpath2p1
  PV UUID               f0VMoA-B22o-EmHv-bhc7-kdhP-8pKt-nNZsRw
  PV Status             allocatable
  Total PE / Free PE    1599 / 1599

  PV Name               /dev/mapper/mpath3p1
  PV UUID               jkexds-FRF6-h7II-Pvo4-Egt2-sYF7-VYxbsw
  PV Status             allocatable
  Total PE / Free PE    1599 / 1599

  PV Name               /dev/mapper/mpath4p1
  PV UUID               EioQEG-QkyY-0jrq-VRIn-Q9eB-kZYG-pJsy41
  PV Status             allocatable
  Total PE / Free PE    1599 / 1599

  PV Name               /dev/mapper/mpath5p1
  PV UUID               0dKa9d-1pGf-QKyr-uXF3-6zXi-3zFn-kreM6b
  PV Status             allocatable
  Total PE / Free PE    1599 / 1599

  PV Name               /dev/mapper/mpath6p1
  PV UUID               BvRVTl-FbX0-gV95-mRw9-VZ3f-bvCX-tK3efR
  PV Status             allocatable
  Total PE / Free PE    1599 / 1599

  PV Name               /dev/mapper/mpath7p1
  PV UUID               XQh0xL-q9K6-A0fh-SDlY-xXjt-3rVH-2HRXJC
  PV Status             allocatable
  Total PE / Free PE    1599 / 1599

  PV Name               /dev/mapper/mpath8p1
  PV UUID               2mnlzf-f4hY-nY1n-OXzz-y7ZE-rQo6-yQi0Ah
  PV Status             allocatable
  Total PE / Free PE    1599 / 1599

  PV Name               /dev/mapper/mpath9p1
  PV UUID               coOwD2-vH3X-6z12-w0h9-Agsn-Ev7a-69wtrj
  PV Status             allocatable
  Total PE / Free PE    1599 / 1599

  PV Name               /dev/mapper/mpath10p1
  PV UUID               bsP07P-QWFW-Or1f-KYp9-fRwR-VLLx-GL3UsF
  PV Status             allocatable
  Total PE / Free PE    1599 / 1599

  PV Name               /dev/mapper/mpath11p1
  PV UUID               OkU3MI-YqIy-pXjk-hsd3-Fohv-vwtJ-YC1jOi
  PV Status             allocatable
  Total PE / Free PE    1599 / 1599

  PV Name               /dev/mapper/mpath12p1
  PV UUID               orunjk-eCaq-iaQ2-iZwT-ln1D-M2Tq-OUFLOf
  PV Status             allocatable
  Total PE / Free PE    1599 / 1599

  PV Name               /dev/mapper/mpath13p1
  PV UUID               bYUcec-anGk-gMK3-6Ttd-5iKS-3YKd-x3Ze2G
  PV Status             allocatable
  Total PE / Free PE    1599 / 1599

  PV Name               /dev/mapper/mpath14p1
  PV UUID               1jzOd8-sfA7-RQCK-3biI-fehy-i98t-AU3tMA
  PV Status             allocatable
  Total PE / Free PE    1599 / 1599

  PV Name               /dev/mapper/mpath15p1
  PV UUID               eWWFSH-0TWX-ov7V-n32f-Hjka-aqkg-c9Kf8F
  PV Status             allocatable
  Total PE / Free PE    1599 / 1599

  PV Name               /dev/mapper/mpath16p1
  PV UUID               WQnpWM-vwTw-JQue-GxA5-3Vp1-gTiD-G887LI
  PV Status             allocatable
  Total PE / Free PE    1599 / 1599

*  PV Name               /dev/sdam1
  PV UUID               tFprMl-oO6o-gQUV-E9Zg-Vztr-iD3w-f6isoZ
  PV Status             allocatable
  Total PE / Free PE    1599 / 1599

(When this volume groups was created using vgcreate I especified 
/dev/mapper/mpath17p1 and not /dev/sdam1 - probably related with problem 
nro 2)
*
  PV Name               /dev/mapper/mpath18p1
  PV UUID               HVjnhn-KbhX-ysyZ-FZCB-uOk3-yB2W-FqIDVZ
  PV Status             allocatable
  Total PE / Free PE    1599 / 1599*


2-) Multipath is unable to create all mpath devices. Server "see" 20 lun 
pairs but multipath create only 19 mpath devices (mpath0-18). And I have 
erratic results running multipath command. Ex:

*[root@pop-16 mapper]# multipath
error calling out /sbin/scsi_id -g -u -s /block/sda
mpath17: remove (wwid changed)
create: mpath17 (3600601603d34130058c23305c612dc11)  DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=1][undef]
 \_ 1:0:1:17 sdam 66:96  [undef][ready]
\_ round-robin 0 [prio=0][undef]
 \_ 1:0:0:17 sds  65:32  [undef][ready]
[root@pop-16 mapper]#

*Running the same command 1 second later:

*[root@pop-16 mapper]# multipath
error calling out /sbin/scsi_id -g -u -s /block/sda
mpath17: remove (wwid changed)
create: mpath17 (3600601601034130078a83aeac412dc11)  DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=0][undef]
 \_ 1:0:1:18 sdan 66:112 [undef][ready]
\_ round-robin 0 [prio=1][undef]
 \_ 1:0:0:18 sdt  65:48  [undef][ready]
[root@pop-16 mapper]#

*and again:

*root@pop-16 mapper]# multipath
error calling out /sbin/scsi_id -g -u -s /block/sda
mpath17: remove (wwid changed)
create: mpath17 (3600601603d34130058c23305c612dc11)  DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=1][undef]
 \_ 1:0:1:17 sdam 66:96  [undef][ready]
\_ round-robin 0 [prio=0][undef]
 \_ 1:0:0:17 sds  65:32  [undef][ready]
[root@pop-16 mapper]#*

What I "think" is causing this problem:

*===== paths list =====
uuid                              hcil     dev  dev_t  pri dm_st  
chk_st  vend
3600601603d3413000c3492f6c512dc11 1:0:1:5  sdaa 65:160 1   
[undef][ready] DGC,
36006016010341300f6eb2cdcc412dc11 1:0:1:6  sdab 65:176 0   
[undef][ready] DGC,
3600601603d3413000d3492f6c512dc11 1:0:1:7  sdac 65:192 1   
[undef][ready] DGC,
36006016010341300f7eb2cdcc412dc11 1:0:1:8  sdad 65:208 0   
[undef][ready] DGC,
3600601603d341300f6a2dafdc512dc11 1:0:1:9  sdae 65:224 1   
[undef][ready] DGC,
36006016010341300f8eb2cdcc412dc11 1:0:1:10 sdaf 65:240 0   
[undef][ready] DGC,
3600601603d341300f7a2dafdc512dc11 1:0:1:11 sdag 66:0   1   
[undef][ready] DGC,
3600601601034130026e740e3c412dc11 1:0:1:12 sdah 66:16  0   
[undef][ready] DGC,
3600601603d341300f8a2dafdc512dc11 1:0:1:13 sdai 66:32  1   
[undef][ready] DGC,
3600601601034130027e740e3c412dc11 1:0:1:14 sdaj 66:48  0   
[undef][ready] DGC,
3600601603d341300f9a2dafdc512dc11 1:0:1:15 sdak 66:64  1   
[undef][ready] DGC,
3600601601034130028e740e3c412dc11 1:0:1:16 sdal 66:80  0   
[undef][ready] DGC,
3600601603d34130058c23305c612dc11 1:0:1:17 sdam 66:96  1   
[undef][ready] DGC,
3600601601034130078a83aeac412dc11 1:0:1:18 sdan 66:112 0   
[undef][ready] DGC,
3600601603d34130059c23305c612dc11 1:0:1:19 sdao 66:128 1   
[undef][ready] DGC,
                                  0:2:0:0  sda  8:0    0   
[undef][ready] Mega
360060160103413007ab51dd5c412dc11 1:0:0:0  sdb  8:16   1   
[undef][ready] DGC,
3600601603d3413000a3492f6c512dc11 1:0:0:1  sdc  8:32   0   
[undef][ready] DGC,
360060160103413007bb51dd5c412dc11 1:0:0:2  sdd  8:48   1   
[undef][ready] DGC,
3600601603d3413000b3492f6c512dc11 1:0:0:3  sde  8:64   0   
[undef][ready] DGC,
360060160103413007cb51dd5c412dc11 1:0:0:4  sdf  8:80   1   
[undef][ready] DGC,
3600601603d3413000c3492f6c512dc11 1:0:0:5  sdg  8:96   0   
[undef][ready] DGC,
36006016010341300f6eb2cdcc412dc11 1:0:0:6  sdh  8:112  1   
[undef][ready] DGC,
3600601603d3413000d3492f6c512dc11 1:0:0:7  sdi  8:128  0   
[undef][ready] DGC,
36006016010341300f7eb2cdcc412dc11 1:0:0:8  sdj  8:144  1   
[undef][ready] DGC,
3600601603d341300f6a2dafdc512dc11 1:0:0:9  sdk  8:160  0   
[undef][ready] DGC,
36006016010341300f8eb2cdcc412dc11 1:0:0:10 sdl  8:176  1   
[undef][ready] DGC,
3600601603d341300f7a2dafdc512dc11 1:0:0:11 sdm  8:192  0   
[undef][ready] DGC,
3600601601034130026e740e3c412dc11 1:0:0:12 sdn  8:208  1   
[undef][ready] DGC,
3600601603d341300f8a2dafdc512dc11 1:0:0:13 sdo  8:224  0   
[undef][ready] DGC,
3600601601034130027e740e3c412dc11 1:0:0:14 sdp  8:240  1   
[undef][ready] DGC,
3600601603d341300f9a2dafdc512dc11 1:0:0:15 sdq  65:0   0   
[undef][ready] DGC,
3600601601034130028e740e3c412dc11 1:0:0:16 sdr  65:16  1   
[undef][ready] DGC,
3600601603d34130058c23305c612dc11 1:0:0:17 sds  65:32  0   
[undef][ready] DGC,
3600601601034130078a83aeac412dc11 1:0:0:18 sdt  65:48  1   
[undef][ready] DGC,
3*600601603d34130059c23305c612dc11 1:0:0:19 sdu  65:64  0   
[undef][ready] DGC,
360060160103413007ab51dd5c412dc11 1:0:1:0  sdv  65:80  0   
[undef][ready] DGC,*
3600601603d3413000a3492f6c512dc11 1:0:1:1  sdw  65:96  1   
[undef][ready] DGC,
360060160103413007bb51dd5c412dc11 1:0:1:2  sdx  65:112 0   
[undef][ready] DGC,
3600601603d3413000b3492f6c512dc11 1:0:1:3  sdy  65:128 1   
[undef][ready] DGC,
360060160103413007cb51dd5c412dc11 1:0:1:4  sdz  65:144 0   
[undef][ready] DGC,*

Other thing that I noted, was when I run dmsetup info for all devices 
(except mpath 17) I had something like:

*[root@pop-16 mapper]# dmsetup info mpath0
Name:              mpath0
State:             ACTIVE
Tables present:    LIVE
Open count:        1
Event number:      2
Major, minor:      253, 23
Number of targets: 1
UUID: mpath-360060160103413007ab51dd5c412dc11

*But, when I run for mpath17 I get:

*[root@pop-16 mapper]# dmsetup info mpath17
Name:              mpath17
State:             ACTIVE
Tables present:    LIVE
Open count:        0
Event number:      1
Major, minor:      253, 20
Number of targets: 1
UUID: mpath-3600601601034130078a83aeac412dc11*

Any ideas about what can be causing this ?

Regards !

Claudio Cuqui

Additional information:

*[root@pop-16 mapper]# cat /etc/multipath.conf | grep -v ^#

defaults {
        user_friendly_names yes
}
defaults {
        udev_dir                /dev
        polling_interval        10
        selector                "round-robin 0"
        #path_grouping_policy   multibus
        path_grouping_policy    failover
        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        prio_callout            /bin/true
        path_checker            readsector0
        rr_min_io               100
        rr_weight               priorities
        failback                immediate
        no_path_retry           fail
        user_friendly_name      yes
}
devnode_blacklist {
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|sda|st)[0-9]*"
        devnode "^hd[a-z]"
        devnode "^cciss!c[0-9]d[0-9]*"
}
devices {
       device {
               vendor                  "DGC"
               product                 "*"
               bl_product              "LUN_Z"
               path_grouping_policy    failover
               getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
               prio_callout            "/sbin/mpath_prio_emc /dev/%n"
               hardware_handler        "1 emc"
               features                "0"
               path_checker            emc_clariion
               failback                immediate
       }
}

[root@pop-16 mapper]# ls -1 mpath*
mpath0
mpath0p1
mpath1
mpath1p1
mpath2
mpath2p1
mpath3
mpath3p1
mpath4
mpath4p1
mpath5
mpath5p1
mpath6
mpath6p1
mpath7
mpath7p1
mpath8
mpath8p1
mpath9
mpath9p1
mpath10
mpath10p1
mpath11
mpath11p1
mpath12
mpath12p1
mpath13
mpath13p1
mpath14
mpath14p1
mpath15
mpath15p1
mpath16
mpath16p1
mpath17
mpath18
mpath18p1

*[root@pop-16 mapper]# cat /proc/scsi/scsi

*Attached devices:
Host: scsi0 Channel: 00 Id: 06 Lun: 00
  Vendor: PE/PV    Model: 1x3 SCSI BP      Rev: 1.1
  Type:   Processor                        ANSI SCSI revision: 02
Host: scsi0 Channel: 02 Id: 00 Lun: 00
  Vendor: MegaRAID Model: LD 0 RAID1   34G Rev: 422A
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 00 Lun: 01
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 00 Lun: 02
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 00 Lun: 03
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 00 Lun: 04
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 00 Lun: 05
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 00 Lun: 06
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 00 Lun: 07
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 00 Lun: 08
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 00 Lun: 09
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 00 Lun: 10
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 00 Lun: 11
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 00 Lun: 12
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 00 Lun: 13
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 00 Lun: 14
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 00 Lun: 15
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 00 Lun: 16
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 00 Lun: 17
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 00 Lun: 18
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 00 Lun: 19
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 01 Lun: 00
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 01 Lun: 01
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 01 Lun: 02
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 01 Lun: 03
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 01 Lun: 04
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 01 Lun: 05
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 01 Lun: 06
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 01 Lun: 07
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 01 Lun: 08
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 01 Lun: 09
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 01 Lun: 10
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 01 Lun: 11
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 01 Lun: 12
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 01 Lun: 13
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 01 Lun: 14
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 01 Lun: 15
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 01 Lun: 16
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 01 Lun: 17
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 01 Lun: 18
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi1 Channel: 00 Id: 01 Lun: 19
  Vendor: DGC      Model: RAID 5           Rev: 0219
  Type:   Direct-Access                    ANSI SCSI revision: 04
[root@pop-16 mapper]#
*
[root@pop-16 dev]# multipath -ll

*mpath2 (3600601603d3413000a3492f6c512dc11) dm-24 DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:0:1  sdc  8:32   [active][ready]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:1:1  sdw  65:96  [active][ready]
mpath1 (360060160103413007bb51dd5c412dc11) dm-25 DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:0:2  sdd  8:48   [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:1:2  sdx  65:112 [active][ready]
mpath0 (360060160103413007ab51dd5c412dc11) dm-23 DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:0:0  sdb  8:16   [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:1:0  sdv  65:80  [active][ready]
mpath18 (3600601603d3413000b3492f6c512dc11) dm-26 DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:0:3  sde  8:64   [active][ready]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:1:3  sdy  65:128 [active][ready]
*mpath17 (3600601601034130078a83aeac412dc11) dm-20 DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:1:18 sdan 66:112 [active][ready]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:0:18 sdt  65:48  [active][ready]*
mpath16 (3600601603d34130059c23305c612dc11) dm-22 DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:1:19 sdao 66:128 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:0:19 sdu  65:64  [active][ready]
mpath9 (36006016010341300f6eb2cdcc412dc11) dm-9 DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:1:6  sdab 65:176 [active][ready]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:0:6  sdh  8:112  [active][ready]
mpath15 (3600601603d341300f9a2dafdc512dc11) dm-18 DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:1:15 sdak 66:64  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:0:15 sdq  65:0   [active][ready]
mpath8 (3600601603d341300f7a2dafdc512dc11) dm-14 DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:1:11 sdag 66:0   [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:0:11 sdm  8:192  [active][ready]
mpath14 (3600601601034130028e740e3c412dc11) dm-19 DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:1:16 sdal 66:80  [active][ready]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:0:16 sdr  65:16  [active][ready]
mpath7 (3600601603d341300f6a2dafdc512dc11) dm-12 DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:1:9  sdae 65:224 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:0:9  sdk  8:160  [active][ready]
mpath13 (3600601601034130027e740e3c412dc11) dm-17 DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:1:14 sdaj 66:48  [active][ready]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:0:14 sdp  8:240  [active][ready]
mpath6 (3600601603d3413000c3492f6c512dc11) dm-8 DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:1:5  sdaa 65:160 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:0:5  sdg  8:96   [active][ready]
mpath12 (3600601603d341300f8a2dafdc512dc11) dm-16 DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:1:13 sdai 66:32  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:0:13 sdo  8:224  [active][ready]
mpath5 (36006016010341300f7eb2cdcc412dc11) dm-11 DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:1:8  sdad 65:208 [active][ready]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:0:8  sdj  8:144  [active][ready]
mpath11 (3600601601034130026e740e3c412dc11) dm-15 DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:1:12 sdah 66:16  [active][ready]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:0:12 sdn  8:208  [active][ready]
mpath4 (3600601603d3413000d3492f6c512dc11) dm-10 DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:1:7  sdac 65:192 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:0:7  sdi  8:128  [active][ready]
mpath10 (36006016010341300f8eb2cdcc412dc11) dm-13 DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:1:10 sdaf 65:240 [active][ready]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:0:10 sdl  8:176  [active][ready]
mpath3 (360060160103413007cb51dd5c412dc11) dm-27 DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:0:4  sdf  8:80   [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:1:4  sdz  65:144 [active][ready]
[root@pop-16 dev]#
*
[root@pop-16 dev]# multipath -v 3

*dm-0: blacklisted
dm-10: blacklisted
dm-11: blacklisted
dm-12: blacklisted
dm-13: blacklisted
dm-14: blacklisted
dm-15: blacklisted
dm-16: blacklisted
dm-17: blacklisted
dm-18: blacklisted
dm-19: blacklisted
dm-1: blacklisted
dm-20: blacklisted
dm-22: blacklisted
dm-23: blacklisted
dm-24: blacklisted
dm-25: blacklisted
dm-26: blacklisted
dm-27: blacklisted
dm-28: blacklisted
dm-29: blacklisted
dm-2: blacklisted
dm-31: blacklisted
dm-32: blacklisted
dm-33: blacklisted
dm-34: blacklisted
dm-35: blacklisted
dm-36: blacklisted
dm-37: blacklisted
dm-38: blacklisted
dm-39: blacklisted
dm-3: blacklisted
dm-40: blacklisted
dm-41: blacklisted
dm-42: blacklisted
dm-43: blacklisted
dm-44: blacklisted
dm-45: blacklisted
dm-46: blacklisted
dm-4: blacklisted
dm-5: blacklisted
dm-6: blacklisted
dm-7: blacklisted
dm-8: blacklisted
dm-9: blacklisted
fd0: blacklisted
hdc: blacklisted
md0: blacklisted
ram0: blacklisted
ram10: blacklisted
ram11: blacklisted
ram12: blacklisted
ram13: blacklisted
ram14: blacklisted
ram15: blacklisted
ram1: blacklisted
ram2: blacklisted
ram3: blacklisted
ram4: blacklisted
ram5: blacklisted
ram6: blacklisted
ram7: blacklisted
ram8: blacklisted
ram9: blacklisted
sdaa: not found in pathvec
sdaa: mask = 0x1f
sdaa: bus = 1
sdaa: dev_t = 65:160
sdaa: size = 104857600
sdaa: vendor = DGC
sdaa: product = RAID 5
sdaa: rev = 0219
sdaa: h:b:t:l = 1:0:1:5
sdaa: tgt_node_name = 0x50060160b060189e
sdaa: serial = CK200050300477
sdaa: path checker = emc_clariion (controler setting)
sdaa: state = 2
sdaa: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdaa: prio = 1
sdaa: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdaa: uid = 3600601603d3413000c3492f6c512dc11 (callout)
sdab: not found in pathvec
sdab: mask = 0x1f
sdab: bus = 1
sdab: dev_t = 65:176
sdab: size = 104857600
sdab: vendor = DGC
sdab: product = RAID 5
sdab: rev = 0219
sdab: h:b:t:l = 1:0:1:6
sdab: tgt_node_name = 0x50060160b060189e
sdab: serial = CK200050300477
sdab: path checker = emc_clariion (controler setting)
sdab: state = 2
sdab: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdab: prio = 0
sdab: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdab: uid = 36006016010341300f6eb2cdcc412dc11 (callout)
sdac: not found in pathvec
sdac: mask = 0x1f
sdac: bus = 1
sdac: dev_t = 65:192
sdac: size = 104857600
sdac: vendor = DGC
sdac: product = RAID 5
sdac: rev = 0219
sdac: h:b:t:l = 1:0:1:7
sdac: tgt_node_name = 0x50060160b060189e
sdac: serial = CK200050300477
sdac: path checker = emc_clariion (controler setting)
sdac: state = 2
sdac: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdac: prio = 1
sdac: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdac: uid = 3600601603d3413000d3492f6c512dc11 (callout)
sdad: not found in pathvec
sdad: mask = 0x1f
sdad: bus = 1
sdad: dev_t = 65:208
sdad: size = 104857600
sdad: vendor = DGC
sdad: product = RAID 5
sdad: rev = 0219
sdad: h:b:t:l = 1:0:1:8
sdad: tgt_node_name = 0x50060160b060189e
sdad: serial = CK200050300477
sdad: path checker = emc_clariion (controler setting)
sdad: state = 2
sdad: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdad: prio = 0
sdad: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdad: uid = 36006016010341300f7eb2cdcc412dc11 (callout)
sdae: not found in pathvec
sdae: mask = 0x1f
sdae: bus = 1
sdae: dev_t = 65:224
sdae: size = 104857600
sdae: vendor = DGC
sdae: product = RAID 5
sdae: rev = 0219
sdae: h:b:t:l = 1:0:1:9
sdae: tgt_node_name = 0x50060160b060189e
sdae: serial = CK200050300477
sdae: path checker = emc_clariion (controler setting)
sdae: state = 2
sdae: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdae: prio = 1
sdae: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdae: uid = 3600601603d341300f6a2dafdc512dc11 (callout)
sdaf: not found in pathvec
sdaf: mask = 0x1f
sdaf: bus = 1
sdaf: dev_t = 65:240
sdaf: size = 104857600
sdaf: vendor = DGC
sdaf: product = RAID 5
sdaf: rev = 0219
sdaf: h:b:t:l = 1:0:1:10
sdaf: tgt_node_name = 0x50060160b060189e
sdaf: serial = CK200050300477
sdaf: path checker = emc_clariion (controler setting)
sdaf: state = 2
sdaf: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdaf: prio = 0
sdaf: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdaf: uid = 36006016010341300f8eb2cdcc412dc11 (callout)
sdag: not found in pathvec
sdag: mask = 0x1f
sdag: bus = 1
sdag: dev_t = 66:0
sdag: size = 104857600
sdag: vendor = DGC
sdag: product = RAID 5
sdag: rev = 0219
sdag: h:b:t:l = 1:0:1:11
sdag: tgt_node_name = 0x50060160b060189e
sdag: serial = CK200050300477
sdag: path checker = emc_clariion (controler setting)
sdag: state = 2
sdag: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdag: prio = 1
sdag: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdag: uid = 3600601603d341300f7a2dafdc512dc11 (callout)
sdah: not found in pathvec
sdah: mask = 0x1f
sdah: bus = 1
sdah: dev_t = 66:16
sdah: size = 104857600
sdah: vendor = DGC
sdah: product = RAID 5
sdah: rev = 0219
sdah: h:b:t:l = 1:0:1:12
sdah: tgt_node_name = 0x50060160b060189e
sdah: serial = CK200050300477
sdah: path checker = emc_clariion (controler setting)
sdah: state = 2
sdah: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdah: prio = 0
sdah: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdah: uid = 3600601601034130026e740e3c412dc11 (callout)
sdai: not found in pathvec
sdai: mask = 0x1f
sdai: bus = 1
sdai: dev_t = 66:32
sdai: size = 104857600
sdai: vendor = DGC
sdai: product = RAID 5
sdai: rev = 0219
sdai: h:b:t:l = 1:0:1:13
sdai: tgt_node_name = 0x50060160b060189e
sdai: serial = CK200050300477
sdai: path checker = emc_clariion (controler setting)
sdai: state = 2
sdai: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdai: prio = 1
sdai: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdai: uid = 3600601603d341300f8a2dafdc512dc11 (callout)
sdaj: not found in pathvec
sdaj: mask = 0x1f
sdaj: bus = 1
sdaj: dev_t = 66:48
sdaj: size = 104857600
sdaj: vendor = DGC
sdaj: product = RAID 5
sdaj: rev = 0219
sdaj: h:b:t:l = 1:0:1:14
sdaj: tgt_node_name = 0x50060160b060189e
sdaj: serial = CK200050300477
sdaj: path checker = emc_clariion (controler setting)
sdaj: state = 2
sdaj: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdaj: prio = 0
sdaj: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdaj: uid = 3600601601034130027e740e3c412dc11 (callout)
sdak: not found in pathvec
sdak: mask = 0x1f
sdak: bus = 1
sdak: dev_t = 66:64
sdak: size = 104857600
sdak: vendor = DGC
sdak: product = RAID 5
sdak: rev = 0219
sdak: h:b:t:l = 1:0:1:15
sdak: tgt_node_name = 0x50060160b060189e
sdak: serial = CK200050300477
sdak: path checker = emc_clariion (controler setting)
sdak: state = 2
sdak: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdak: prio = 1
sdak: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdak: uid = 3600601603d341300f9a2dafdc512dc11 (callout)
sdal: not found in pathvec
sdal: mask = 0x1f
sdal: bus = 1
sdal: dev_t = 66:80
sdal: size = 104857600
sdal: vendor = DGC
sdal: product = RAID 5
sdal: rev = 0219
sdal: h:b:t:l = 1:0:1:16
sdal: tgt_node_name = 0x50060160b060189e
sdal: serial = CK200050300477
sdal: path checker = emc_clariion (controler setting)
sdal: state = 2
sdal: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdal: prio = 0
sdal: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdal: uid = 3600601601034130028e740e3c412dc11 (callout)
sdam: not found in pathvec
sdam: mask = 0x1f
sdam: bus = 1
sdam: dev_t = 66:96
sdam: size = 104857600
sdam: vendor = DGC
sdam: product = RAID 5
sdam: rev = 0219
sdam: h:b:t:l = 1:0:1:17
sdam: tgt_node_name = 0x50060160b060189e
sdam: serial = CK200050300477
sdam: path checker = emc_clariion (controler setting)
sdam: state = 2
sdam: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdam: prio = 1
sdam: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdam: uid = 3600601603d34130058c23305c612dc11 (callout)
sdan: not found in pathvec
sdan: mask = 0x1f
sdan: bus = 1
sdan: dev_t = 66:112
sdan: size = 104857600
sdan: vendor = DGC
sdan: product = RAID 5
sdan: rev = 0219
sdan: h:b:t:l = 1:0:1:18
sdan: tgt_node_name = 0x50060160b060189e
sdan: serial = CK200050300477
sdan: path checker = emc_clariion (controler setting)
sdan: state = 2
sdan: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdan: prio = 0
sdan: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdan: uid = 3600601601034130078a83aeac412dc11 (callout)
sdao: not found in pathvec
sdao: mask = 0x1f
sdao: bus = 1
sdao: dev_t = 66:128
sdao: size = 104857600
sdao: vendor = DGC
sdao: product = RAID 5
sdao: rev = 0219
sdao: h:b:t:l = 1:0:1:19
sdao: tgt_node_name = 0x50060160b060189e
sdao: serial = CK200050300477
sdao: path checker = emc_clariion (controler setting)
sdao: state = 2
sdao: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdao: prio = 1
sdao: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdao: uid = 3600601603d34130059c23305c612dc11 (callout)
sda: not found in pathvec
sda: mask = 0x1f
sda: bus = 1
sda: dev_t = 8:0
sda: size = 70774784
sda: vendor = MegaRAID
sda: product = LD 0 RAID1   34G
sda: rev = 422A
sda: h:b:t:l = 0:2:0:0
sda: serial =
sda: path checker = readsector0 (config file default)
sda: state = 2
sda: getprio = /bin/true (config file default)
sda: prio = 0
sda: getuid = /sbin/scsi_id -g -u -s /block/%n (config file default)
error calling out /sbin/scsi_id -g -u -s /block/sda
sdb: not found in pathvec
sdb: mask = 0x1f
sdb: bus = 1
sdb: dev_t = 8:16
sdb: size = 104857600
sdb: vendor = DGC
sdb: product = RAID 5
sdb: rev = 0219
sdb: h:b:t:l = 1:0:0:0
sdb: tgt_node_name = 0x50060160b060189e
sdb: serial = CK200050300477
sdb: path checker = emc_clariion (controler setting)
sdb: state = 2
sdb: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdb: prio = 1
sdb: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdb: uid = 360060160103413007ab51dd5c412dc11 (callout)
sdc: not found in pathvec
sdc: mask = 0x1f
sdc: bus = 1
sdc: dev_t = 8:32
sdc: size = 104857600
sdc: vendor = DGC
sdc: product = RAID 5
sdc: rev = 0219
sdc: h:b:t:l = 1:0:0:1
sdc: tgt_node_name = 0x50060160b060189e
sdc: serial = CK200050300477
sdc: path checker = emc_clariion (controler setting)
sdc: state = 2
sdc: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdc: prio = 0
sdc: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdc: uid = 3600601603d3413000a3492f6c512dc11 (callout)
sdd: not found in pathvec
sdd: mask = 0x1f
sdd: bus = 1
sdd: dev_t = 8:48
sdd: size = 104857600
sdd: vendor = DGC
sdd: product = RAID 5
sdd: rev = 0219
sdd: h:b:t:l = 1:0:0:2
sdd: tgt_node_name = 0x50060160b060189e
sdd: serial = CK200050300477
sdd: path checker = emc_clariion (controler setting)
sdd: state = 2
sdd: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdd: prio = 1
sdd: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdd: uid = 360060160103413007bb51dd5c412dc11 (callout)
sde: not found in pathvec
sde: mask = 0x1f
sde: bus = 1
sde: dev_t = 8:64
sde: size = 104857600
sde: vendor = DGC
sde: product = RAID 5
sde: rev = 0219
sde: h:b:t:l = 1:0:0:3
sde: tgt_node_name = 0x50060160b060189e
sde: serial = CK200050300477
sde: path checker = emc_clariion (controler setting)
sde: state = 2
sde: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sde: prio = 0
sde: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sde: uid = 3600601603d3413000b3492f6c512dc11 (callout)
sdf: not found in pathvec
sdf: mask = 0x1f
sdf: bus = 1
sdf: dev_t = 8:80
sdf: size = 104857600
sdf: vendor = DGC
sdf: product = RAID 5
sdf: rev = 0219
sdf: h:b:t:l = 1:0:0:4
sdf: tgt_node_name = 0x50060160b060189e
sdf: serial = CK200050300477
sdf: path checker = emc_clariion (controler setting)
sdf: state = 2
sdf: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdf: prio = 1
sdf: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdf: uid = 360060160103413007cb51dd5c412dc11 (callout)
sdg: not found in pathvec
sdg: mask = 0x1f
sdg: bus = 1
sdg: dev_t = 8:96
sdg: size = 104857600
sdg: vendor = DGC
sdg: product = RAID 5
sdg: rev = 0219
sdg: h:b:t:l = 1:0:0:5
sdg: tgt_node_name = 0x50060160b060189e
sdg: serial = CK200050300477
sdg: path checker = emc_clariion (controler setting)
sdg: state = 2
sdg: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdg: prio = 0
sdg: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdg: uid = 3600601603d3413000c3492f6c512dc11 (callout)
sdh: not found in pathvec
sdh: mask = 0x1f
sdh: bus = 1
sdh: dev_t = 8:112
sdh: size = 104857600
sdh: vendor = DGC
sdh: product = RAID 5
sdh: rev = 0219
sdh: h:b:t:l = 1:0:0:6
sdh: tgt_node_name = 0x50060160b060189e
sdh: serial = CK200050300477
sdh: path checker = emc_clariion (controler setting)
sdh: state = 2
sdh: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdh: prio = 1
sdh: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdh: uid = 36006016010341300f6eb2cdcc412dc11 (callout)
sdi: not found in pathvec
sdi: mask = 0x1f
sdi: bus = 1
sdi: dev_t = 8:128
sdi: size = 104857600
sdi: vendor = DGC
sdi: product = RAID 5
sdi: rev = 0219
sdi: h:b:t:l = 1:0:0:7
sdi: tgt_node_name = 0x50060160b060189e
sdi: serial = CK200050300477
sdi: path checker = emc_clariion (controler setting)
sdi: state = 2
sdi: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdi: prio = 0
sdi: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdi: uid = 3600601603d3413000d3492f6c512dc11 (callout)
sdj: not found in pathvec
sdj: mask = 0x1f
sdj: bus = 1
sdj: dev_t = 8:144
sdj: size = 104857600
sdj: vendor = DGC
sdj: product = RAID 5
sdj: rev = 0219
sdj: h:b:t:l = 1:0:0:8
sdj: tgt_node_name = 0x50060160b060189e
sdj: serial = CK200050300477
sdj: path checker = emc_clariion (controler setting)
sdj: state = 2
sdj: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdj: prio = 1
sdj: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdj: uid = 36006016010341300f7eb2cdcc412dc11 (callout)
sdk: not found in pathvec
sdk: mask = 0x1f
sdk: bus = 1
sdk: dev_t = 8:160
sdk: size = 104857600
sdk: vendor = DGC
sdk: product = RAID 5
sdk: rev = 0219
sdk: h:b:t:l = 1:0:0:9
sdk: tgt_node_name = 0x50060160b060189e
sdk: serial = CK200050300477
sdk: path checker = emc_clariion (controler setting)
sdk: state = 2
sdk: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdk: prio = 0
sdk: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdk: uid = 3600601603d341300f6a2dafdc512dc11 (callout)
sdl: not found in pathvec
sdl: mask = 0x1f
sdl: bus = 1
sdl: dev_t = 8:176
sdl: size = 104857600
sdl: vendor = DGC
sdl: product = RAID 5
sdl: rev = 0219
sdl: h:b:t:l = 1:0:0:10
sdl: tgt_node_name = 0x50060160b060189e
sdl: serial = CK200050300477
sdl: path checker = emc_clariion (controler setting)
sdl: state = 2
sdl: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdl: prio = 1
sdl: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdl: uid = 36006016010341300f8eb2cdcc412dc11 (callout)
sdm: not found in pathvec
sdm: mask = 0x1f
sdm: bus = 1
sdm: dev_t = 8:192
sdm: size = 104857600
sdm: vendor = DGC
sdm: product = RAID 5
sdm: rev = 0219
sdm: h:b:t:l = 1:0:0:11
sdm: tgt_node_name = 0x50060160b060189e
sdm: serial = CK200050300477
sdm: path checker = emc_clariion (controler setting)
sdm: state = 2
sdm: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdm: prio = 0
sdm: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdm: uid = 3600601603d341300f7a2dafdc512dc11 (callout)
sdn: not found in pathvec
sdn: mask = 0x1f
sdn: bus = 1
sdn: dev_t = 8:208
sdn: size = 104857600
sdn: vendor = DGC
sdn: product = RAID 5
sdn: rev = 0219
sdn: h:b:t:l = 1:0:0:12
sdn: tgt_node_name = 0x50060160b060189e
sdn: serial = CK200050300477
sdn: path checker = emc_clariion (controler setting)
sdn: state = 2
sdn: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdn: prio = 1
sdn: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdn: uid = 3600601601034130026e740e3c412dc11 (callout)
sdo: not found in pathvec
sdo: mask = 0x1f
sdo: bus = 1
sdo: dev_t = 8:224
sdo: size = 104857600
sdo: vendor = DGC
sdo: product = RAID 5
sdo: rev = 0219
sdo: h:b:t:l = 1:0:0:13
sdo: tgt_node_name = 0x50060160b060189e
sdo: serial = CK200050300477
sdo: path checker = emc_clariion (controler setting)
sdo: state = 2
sdo: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdo: prio = 0
sdo: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdo: uid = 3600601603d341300f8a2dafdc512dc11 (callout)
sdp: not found in pathvec
sdp: mask = 0x1f
sdp: bus = 1
sdp: dev_t = 8:240
sdp: size = 104857600
sdp: vendor = DGC
sdp: product = RAID 5
sdp: rev = 0219
sdp: h:b:t:l = 1:0:0:14
sdp: tgt_node_name = 0x50060160b060189e
sdp: serial = CK200050300477
sdp: path checker = emc_clariion (controler setting)
sdp: state = 2
sdp: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdp: prio = 1
sdp: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdp: uid = 3600601601034130027e740e3c412dc11 (callout)
sdq: not found in pathvec
sdq: mask = 0x1f
sdq: bus = 1
sdq: dev_t = 65:0
sdq: size = 104857600
sdq: vendor = DGC
sdq: product = RAID 5
sdq: rev = 0219
sdq: h:b:t:l = 1:0:0:15
sdq: tgt_node_name = 0x50060160b060189e
sdq: serial = CK200050300477
sdq: path checker = emc_clariion (controler setting)
sdq: state = 2
sdq: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdq: prio = 0
sdq: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdq: uid = 3600601603d341300f9a2dafdc512dc11 (callout)
sdr: not found in pathvec
sdr: mask = 0x1f
sdr: bus = 1
sdr: dev_t = 65:16
sdr: size = 104857600
sdr: vendor = DGC
sdr: product = RAID 5
sdr: rev = 0219
sdr: h:b:t:l = 1:0:0:16
sdr: tgt_node_name = 0x50060160b060189e
sdr: serial = CK200050300477
sdr: path checker = emc_clariion (controler setting)
sdr: state = 2
sdr: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdr: prio = 1
sdr: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdr: uid = 3600601601034130028e740e3c412dc11 (callout)
sds: not found in pathvec
sds: mask = 0x1f
sds: bus = 1
sds: dev_t = 65:32
sds: size = 104857600
sds: vendor = DGC
sds: product = RAID 5
sds: rev = 0219
sds: h:b:t:l = 1:0:0:17
sds: tgt_node_name = 0x50060160b060189e
sds: serial = CK200050300477
sds: path checker = emc_clariion (controler setting)
sds: state = 2
sds: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sds: prio = 0
sds: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sds: uid = 3600601603d34130058c23305c612dc11 (callout)
sdt: not found in pathvec
sdt: mask = 0x1f
sdt: bus = 1
sdt: dev_t = 65:48
sdt: size = 104857600
sdt: vendor = DGC
sdt: product = RAID 5
sdt: rev = 0219
sdt: h:b:t:l = 1:0:0:18
sdt: tgt_node_name = 0x50060160b060189e
sdt: serial = CK200050300477
sdt: path checker = emc_clariion (controler setting)
sdt: state = 2
sdt: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdt: prio = 1
sdt: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdt: uid = 3600601601034130078a83aeac412dc11 (callout)
sdu: not found in pathvec
sdu: mask = 0x1f
sdu: bus = 1
sdu: dev_t = 65:64
sdu: size = 104857600
sdu: vendor = DGC
sdu: product = RAID 5
sdu: rev = 0219
sdu: h:b:t:l = 1:0:0:19
sdu: tgt_node_name = 0x50060160b060189e
sdu: serial = CK200050300477
sdu: path checker = emc_clariion (controler setting)
sdu: state = 2
sdu: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdu: prio = 0
sdu: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdu: uid = 3600601603d34130059c23305c612dc11 (callout)
sdv: not found in pathvec
sdv: mask = 0x1f
sdv: bus = 1
sdv: dev_t = 65:80
sdv: size = 104857600
sdv: vendor = DGC
sdv: product = RAID 5
sdv: rev = 0219
sdv: h:b:t:l = 1:0:1:0
sdv: tgt_node_name = 0x50060160b060189e
sdv: serial = CK200050300477
sdv: path checker = emc_clariion (controler setting)
sdv: state = 2
sdv: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdv: prio = 0
sdv: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdv: uid = 360060160103413007ab51dd5c412dc11 (callout)
sdw: not found in pathvec
sdw: mask = 0x1f
sdw: bus = 1
sdw: dev_t = 65:96
sdw: size = 104857600
sdw: vendor = DGC
sdw: product = RAID 5
sdw: rev = 0219
sdw: h:b:t:l = 1:0:1:1
sdw: tgt_node_name = 0x50060160b060189e
sdw: serial = CK200050300477
sdw: path checker = emc_clariion (controler setting)
sdw: state = 2
sdw: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdw: prio = 1
sdw: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdw: uid = 3600601603d3413000a3492f6c512dc11 (callout)
sdx: not found in pathvec
sdx: mask = 0x1f
sdx: bus = 1
sdx: dev_t = 65:112
sdx: size = 104857600
sdx: vendor = DGC
sdx: product = RAID 5
sdx: rev = 0219
sdx: h:b:t:l = 1:0:1:2
sdx: tgt_node_name = 0x50060160b060189e
sdx: serial = CK200050300477
sdx: path checker = emc_clariion (controler setting)
sdx: state = 2
sdx: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdx: prio = 0
sdx: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdx: uid = 360060160103413007bb51dd5c412dc11 (callout)
sdy: not found in pathvec
sdy: mask = 0x1f
sdy: bus = 1
sdy: dev_t = 65:128
sdy: size = 104857600
sdy: vendor = DGC
sdy: product = RAID 5
sdy: rev = 0219
sdy: h:b:t:l = 1:0:1:3
sdy: tgt_node_name = 0x50060160b060189e
sdy: serial = CK200050300477
sdy: path checker = emc_clariion (controler setting)
sdy: state = 2
sdy: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdy: prio = 1
sdy: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdy: uid = 3600601603d3413000b3492f6c512dc11 (callout)
sdz: not found in pathvec
sdz: mask = 0x1f
sdz: bus = 1
sdz: dev_t = 65:144
sdz: size = 104857600
sdz: vendor = DGC
sdz: product = RAID 5
sdz: rev = 0219
sdz: h:b:t:l = 1:0:1:4
sdz: tgt_node_name = 0x50060160b060189e
sdz: serial = CK200050300477
sdz: path checker = emc_clariion (controler setting)
sdz: state = 2
sdz: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdz: prio = 0
sdz: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
sdz: uid = 360060160103413007cb51dd5c412dc11 (callout)
===== paths list =====
uuid                              hcil     dev  dev_t  pri dm_st  
chk_st  vend
3600601603d3413000c3492f6c512dc11 1:0:1:5  sdaa 65:160 1   
[undef][ready] DGC,
36006016010341300f6eb2cdcc412dc11 1:0:1:6  sdab 65:176 0   
[undef][ready] DGC,
3600601603d3413000d3492f6c512dc11 1:0:1:7  sdac 65:192 1   
[undef][ready] DGC,
36006016010341300f7eb2cdcc412dc11 1:0:1:8  sdad 65:208 0   
[undef][ready] DGC,
3600601603d341300f6a2dafdc512dc11 1:0:1:9  sdae 65:224 1   
[undef][ready] DGC,
36006016010341300f8eb2cdcc412dc11 1:0:1:10 sdaf 65:240 0   
[undef][ready] DGC,
3600601603d341300f7a2dafdc512dc11 1:0:1:11 sdag 66:0   1   
[undef][ready] DGC,
3600601601034130026e740e3c412dc11 1:0:1:12 sdah 66:16  0   
[undef][ready] DGC,
3600601603d341300f8a2dafdc512dc11 1:0:1:13 sdai 66:32  1   
[undef][ready] DGC,
3600601601034130027e740e3c412dc11 1:0:1:14 sdaj 66:48  0   
[undef][ready] DGC,
3600601603d341300f9a2dafdc512dc11 1:0:1:15 sdak 66:64  1   
[undef][ready] DGC,
3600601601034130028e740e3c412dc11 1:0:1:16 sdal 66:80  0   
[undef][ready] DGC,
3600601603d34130058c23305c612dc11 1:0:1:17 sdam 66:96  1   
[undef][ready] DGC,
3600601601034130078a83aeac412dc11 1:0:1:18 sdan 66:112 0   
[undef][ready] DGC,
3600601603d34130059c23305c612dc11 1:0:1:19 sdao 66:128 1   
[undef][ready] DGC,
                                  0:2:0:0  sda  8:0    0   
[undef][ready] Mega
360060160103413007ab51dd5c412dc11 1:0:0:0  sdb  8:16   1   
[undef][ready] DGC,
3600601603d3413000a3492f6c512dc11 1:0:0:1  sdc  8:32   0   
[undef][ready] DGC,
360060160103413007bb51dd5c412dc11 1:0:0:2  sdd  8:48   1   
[undef][ready] DGC,
3600601603d3413000b3492f6c512dc11 1:0:0:3  sde  8:64   0   
[undef][ready] DGC,
360060160103413007cb51dd5c412dc11 1:0:0:4  sdf  8:80   1   
[undef][ready] DGC,
3600601603d3413000c3492f6c512dc11 1:0:0:5  sdg  8:96   0   
[undef][ready] DGC,
36006016010341300f6eb2cdcc412dc11 1:0:0:6  sdh  8:112  1   
[undef][ready] DGC,
3600601603d3413000d3492f6c512dc11 1:0:0:7  sdi  8:128  0   
[undef][ready] DGC,
36006016010341300f7eb2cdcc412dc11 1:0:0:8  sdj  8:144  1   
[undef][ready] DGC,
3600601603d341300f6a2dafdc512dc11 1:0:0:9  sdk  8:160  0   
[undef][ready] DGC,
36006016010341300f8eb2cdcc412dc11 1:0:0:10 sdl  8:176  1   
[undef][ready] DGC,
3600601603d341300f7a2dafdc512dc11 1:0:0:11 sdm  8:192  0   
[undef][ready] DGC,
3600601601034130026e740e3c412dc11 1:0:0:12 sdn  8:208  1   
[undef][ready] DGC,
3600601603d341300f8a2dafdc512dc11 1:0:0:13 sdo  8:224  0   
[undef][ready] DGC,
3600601601034130027e740e3c412dc11 1:0:0:14 sdp  8:240  1   
[undef][ready] DGC,
3600601603d341300f9a2dafdc512dc11 1:0:0:15 sdq  65:0   0   
[undef][ready] DGC,
3600601601034130028e740e3c412dc11 1:0:0:16 sdr  65:16  1   
[undef][ready] DGC,
3600601603d34130058c23305c612dc11 1:0:0:17 sds  65:32  0   
[undef][ready] DGC,
3600601601034130078a83aeac412dc11 1:0:0:18 sdt  65:48  1   
[undef][ready] DGC,
3600601603d34130059c23305c612dc11 1:0:0:19 sdu  65:64  0   
[undef][ready] DGC,
360060160103413007ab51dd5c412dc11 1:0:1:0  sdv  65:80  0   
[undef][ready] DGC,
3600601603d3413000a3492f6c512dc11 1:0:1:1  sdw  65:96  1   
[undef][ready] DGC,
360060160103413007bb51dd5c412dc11 1:0:1:2  sdx  65:112 0   
[undef][ready] DGC,
3600601603d3413000b3492f6c512dc11 1:0:1:3  sdy  65:128 1   
[undef][ready] DGC,
360060160103413007cb51dd5c412dc11 1:0:1:4  sdz  65:144 0   
[undef][ready] DGC,
params = 0 1 emc 2 2 round-robin 0 1 1 8:32 100 round-robin 0 1 1 65:96 100
status = 1 0 0 2 2 E 0 1 0 8:32 A 0 A 0 1 0 65:96 A 0
sdc: mask = 0x8
sdc: prio = 0
params = 0 1 emc 2 1 round-robin 0 1 1 8:48 100 round-robin 0 1 1 65:112 100
status = 1 0 0 2 1 A 0 1 0 8:48 A 0 E 0 1 0 65:112 A 0
sdx: mask = 0x8
sdx: prio = 0
params = 0 1 emc 2 1 round-robin 0 1 1 8:16 100 round-robin 0 1 1 65:80 100
status = 1 0 0 2 1 A 0 1 0 8:16 A 0 E 0 1 0 65:80 A 0
sdv: mask = 0x8
sdv: prio = 0
params = 0 1 emc 2 2 round-robin 0 1 1 8:64 100 round-robin 0 1 1 65:128 100
status = 1 0 0 2 2 E 0 1 0 8:64 A 0 A 0 1 0 65:128 A 0
sde: mask = 0x8
sde: prio = 0
params = 0 1 emc 2 2 round-robin 0 1 1 66:112 100 round-robin 0 1 1 
65:48 100
status = 1 0 0 2 2 E 0 1 0 66:112 A 0 A 0 1 0 65:48 A 0
sdan: mask = 0x8
sdan: prio = 0
params = 0 1 emc 2 1 round-robin 0 1 1 66:128 100 round-robin 0 1 1 
65:64 100
status = 1 0 0 2 1 A 0 1 0 66:128 A 0 E 0 1 0 65:64 A 0
sdu: mask = 0x8
sdu: prio = 0
params = 0 1 emc 2 2 round-robin 0 1 1 65:176 100 round-robin 0 1 1 
8:112 100
status = 1 0 0 2 2 E 0 1 0 65:176 A 0 A 0 1 0 8:112 A 0
sdab: mask = 0x8
sdab: prio = 0
params = 0 1 emc 2 1 round-robin 0 1 1 66:64 100 round-robin 0 1 1 65:0 100
status = 1 0 0 2 1 A 0 1 0 66:64 A 0 E 0 1 0 65:0 A 0
sdq: mask = 0x8
sdq: prio = 0
params = 0 1 emc 2 1 round-robin 0 1 1 66:0 100 round-robin 0 1 1 8:192 100
status = 1 0 0 2 1 A 0 1 0 66:0 A 0 E 0 1 0 8:192 A 0
sdm: mask = 0x8
sdm: prio = 0
params = 0 1 emc 2 2 round-robin 0 1 1 66:80 100 round-robin 0 1 1 65:16 100
status = 1 0 0 2 2 E 0 1 0 66:80 A 0 A 0 1 0 65:16 A 0
sdal: mask = 0x8
sdal: prio = 0
params = 0 1 emc 2 1 round-robin 0 1 1 65:224 100 round-robin 0 1 1 
8:160 100
status = 1 0 0 2 1 A 0 1 0 65:224 A 0 E 0 1 0 8:160 A 0
sdk: mask = 0x8
sdk: prio = 0
params = 0 1 emc 2 2 round-robin 0 1 1 66:48 100 round-robin 0 1 1 8:240 100
status = 1 0 0 2 2 E 0 1 0 66:48 A 0 A 0 1 0 8:240 A 0
sdaj: mask = 0x8
sdaj: prio = 0
params = 0 1 emc 2 1 round-robin 0 1 1 65:160 100 round-robin 0 1 1 8:96 100
status = 1 0 0 2 1 A 0 1 0 65:160 A 0 E 0 1 0 8:96 A 0
sdg: mask = 0x8
sdg: prio = 0
params = 0 1 emc 2 1 round-robin 0 1 1 66:32 100 round-robin 0 1 1 8:224 100
status = 1 0 0 2 1 A 0 1 0 66:32 A 0 E 0 1 0 8:224 A 0
sdo: mask = 0x8
sdo: prio = 0
params = 0 1 emc 2 2 round-robin 0 1 1 65:208 100 round-robin 0 1 1 
8:144 100
status = 1 0 0 2 2 E 0 1 0 65:208 A 0 A 0 1 0 8:144 A 0
sdad: mask = 0x8
sdad: prio = 0
params = 0 1 emc 2 2 round-robin 0 1 1 66:16 100 round-robin 0 1 1 8:208 100
status = 1 0 0 2 2 E 0 1 0 66:16 A 0 A 0 1 0 8:208 A 0
sdah: mask = 0x8
sdah: prio = 0
params = 0 1 emc 2 1 round-robin 0 1 1 65:192 100 round-robin 0 1 1 
8:128 100
status = 1 0 0 2 1 A 0 1 0 65:192 A 0 E 0 1 0 8:128 A 0
sdi: mask = 0x8
sdi: prio = 0
params = 0 1 emc 2 2 round-robin 0 1 1 65:240 100 round-robin 0 1 1 
8:176 100
status = 1 0 0 2 2 E 0 1 0 65:240 A 0 A 0 1 0 8:176 A 0
sdaf: mask = 0x8
sdaf: prio = 0
params = 0 1 emc 2 1 round-robin 0 1 1 8:80 100 round-robin 0 1 1 65:144 100
status = 1 0 0 2 1 A 0 1 0 8:80 A 0 E 0 1 0 65:144 A 0
sdz: mask = 0x8
sdz: prio = 0
Found matching wwid [3600601603d3413000c3492f6c512dc11] in bindings file.
Setting alias to mpath6
sdaa: ownership set to mpath6
sdaa: not found in pathvec
sdaa: mask = 0xc
sdaa: state = 2
sdaa: prio = 1
sdg: ownership set to mpath6
sdg: not found in pathvec
sdg: mask = 0xc
sdg: state = 2
sdg: prio = 0
mpath6: pgfailback = -2 (controler setting)
mpath6: pgpolicy = failover (controler setting)
mpath6: selector = round-robin 0 (internal default)
mpath6: features = 0 (controler setting)
mpath6: hwhandler = 1 emc (controler setting)
mpath6: rr_weight = 2 (config file default)
mpath6: minio = 100 (config file default)
mpath6: no_path_retry = -1 (config file default)
pg_timeout = NONE (internal default)
mpath6: set ACT_NOTHING (map unchanged)
Found matching wwid [36006016010341300f6eb2cdcc412dc11] in bindings file.
Setting alias to mpath9
sdab: ownership set to mpath9
sdab: not found in pathvec
sdab: mask = 0xc
sdab: state = 2
sdab: prio = 0
sdh: ownership set to mpath9
sdh: not found in pathvec
sdh: mask = 0xc
sdh: state = 2
sdh: prio = 1
mpath9: pgfailback = -2 (controler setting)
mpath9: pgpolicy = failover (controler setting)
mpath9: selector = round-robin 0 (internal default)
mpath9: features = 0 (controler setting)
mpath9: hwhandler = 1 emc (controler setting)
mpath9: rr_weight = 2 (config file default)
mpath9: minio = 100 (config file default)
mpath9: no_path_retry = -1 (config file default)
pg_timeout = NONE (internal default)
mpath9: set ACT_NOTHING (map unchanged)
Found matching wwid [3600601603d3413000d3492f6c512dc11] in bindings file.
Setting alias to mpath4
sdac: ownership set to mpath4
sdac: not found in pathvec
sdac: mask = 0xc
sdac: state = 2
sdac: prio = 1
sdi: ownership set to mpath4
sdi: not found in pathvec
sdi: mask = 0xc
sdi: state = 2
sdi: prio = 0
mpath4: pgfailback = -2 (controler setting)
mpath4: pgpolicy = failover (controler setting)
mpath4: selector = round-robin 0 (internal default)
mpath4: features = 0 (controler setting)
mpath4: hwhandler = 1 emc (controler setting)
mpath4: rr_weight = 2 (config file default)
mpath4: minio = 100 (config file default)
mpath4: no_path_retry = -1 (config file default)
pg_timeout = NONE (internal default)
mpath4: set ACT_NOTHING (map unchanged)
Found matching wwid [36006016010341300f7eb2cdcc412dc11] in bindings file.
Setting alias to mpath5
sdad: ownership set to mpath5
sdad: not found in pathvec
sdad: mask = 0xc
sdad: state = 2
sdad: prio = 0
sdj: ownership set to mpath5
sdj: not found in pathvec
sdj: mask = 0xc
sdj: state = 2
sdj: prio = 1
mpath5: pgfailback = -2 (controler setting)
mpath5: pgpolicy = failover (controler setting)
mpath5: selector = round-robin 0 (internal default)
mpath5: features = 0 (controler setting)
mpath5: hwhandler = 1 emc (controler setting)
mpath5: rr_weight = 2 (config file default)
mpath5: minio = 100 (config file default)
mpath5: no_path_retry = -1 (config file default)
pg_timeout = NONE (internal default)
mpath5: set ACT_NOTHING (map unchanged)
Found matching wwid [3600601603d341300f6a2dafdc512dc11] in bindings file.
Setting alias to mpath7
sdae: ownership set to mpath7
sdae: not found in pathvec
sdae: mask = 0xc
sdae: state = 2
sdae: prio = 1
sdk: ownership set to mpath7
sdk: not found in pathvec
sdk: mask = 0xc
sdk: state = 2
sdk: prio = 0
mpath7: pgfailback = -2 (controler setting)
mpath7: pgpolicy = failover (controler setting)
mpath7: selector = round-robin 0 (internal default)
mpath7: features = 0 (controler setting)
mpath7: hwhandler = 1 emc (controler setting)
mpath7: rr_weight = 2 (config file default)
mpath7: minio = 100 (config file default)
mpath7: no_path_retry = -1 (config file default)
pg_timeout = NONE (internal default)
mpath7: set ACT_NOTHING (map unchanged)
Found matching wwid [36006016010341300f8eb2cdcc412dc11] in bindings file.
Setting alias to mpath10
sdaf: ownership set to mpath10
sdaf: not found in pathvec
sdaf: mask = 0xc
sdaf: state = 2
sdaf: prio = 0
sdl: ownership set to mpath10
sdl: not found in pathvec
sdl: mask = 0xc
sdl: state = 2
sdl: prio = 1
mpath10: pgfailback = -2 (controler setting)
mpath10: pgpolicy = failover (controler setting)
mpath10: selector = round-robin 0 (internal default)
mpath10: features = 0 (controler setting)
mpath10: hwhandler = 1 emc (controler setting)
mpath10: rr_weight = 2 (config file default)
mpath10: minio = 100 (config file default)
mpath10: no_path_retry = -1 (config file default)
pg_timeout = NONE (internal default)
mpath10: set ACT_NOTHING (map unchanged)
Found matching wwid [3600601603d341300f7a2dafdc512dc11] in bindings file.
Setting alias to mpath8
sdag: ownership set to mpath8
sdag: not found in pathvec
sdag: mask = 0xc
sdag: state = 2
sdag: prio = 1
sdm: ownership set to mpath8
sdm: not found in pathvec
sdm: mask = 0xc
sdm: state = 2
sdm: prio = 0
mpath8: pgfailback = -2 (controler setting)
mpath8: pgpolicy = failover (controler setting)
mpath8: selector = round-robin 0 (internal default)
mpath8: features = 0 (controler setting)
mpath8: hwhandler = 1 emc (controler setting)
mpath8: rr_weight = 2 (config file default)
mpath8: minio = 100 (config file default)
mpath8: no_path_retry = -1 (config file default)
pg_timeout = NONE (internal default)
mpath8: set ACT_NOTHING (map unchanged)
Found matching wwid [3600601601034130026e740e3c412dc11] in bindings file.
Setting alias to mpath11
sdah: ownership set to mpath11
sdah: not found in pathvec
sdah: mask = 0xc
sdah: state = 2
sdah: prio = 0
sdn: ownership set to mpath11
sdn: not found in pathvec
sdn: mask = 0xc
sdn: state = 2
sdn: prio = 1
mpath11: pgfailback = -2 (controler setting)
mpath11: pgpolicy = failover (controler setting)
mpath11: selector = round-robin 0 (internal default)
mpath11: features = 0 (controler setting)
mpath11: hwhandler = 1 emc (controler setting)
mpath11: rr_weight = 2 (config file default)
mpath11: minio = 100 (config file default)
mpath11: no_path_retry = -1 (config file default)
pg_timeout = NONE (internal default)
mpath11: set ACT_NOTHING (map unchanged)
Found matching wwid [3600601603d341300f8a2dafdc512dc11] in bindings file.
Setting alias to mpath12
sdai: ownership set to mpath12
sdai: not found in pathvec
sdai: mask = 0xc
sdai: state = 2
sdai: prio = 1
sdo: ownership set to mpath12
sdo: not found in pathvec
sdo: mask = 0xc
sdo: state = 2
sdo: prio = 0
mpath12: pgfailback = -2 (controler setting)
mpath12: pgpolicy = failover (controler setting)
mpath12: selector = round-robin 0 (internal default)
mpath12: features = 0 (controler setting)
mpath12: hwhandler = 1 emc (controler setting)
mpath12: rr_weight = 2 (config file default)
mpath12: minio = 100 (config file default)
mpath12: no_path_retry = -1 (config file default)
pg_timeout = NONE (internal default)
mpath12: set ACT_NOTHING (map unchanged)
Found matching wwid [3600601601034130027e740e3c412dc11] in bindings file.
Setting alias to mpath13
sdaj: ownership set to mpath13
sdaj: not found in pathvec
sdaj: mask = 0xc
sdaj: state = 2
sdaj: prio = 0
sdp: ownership set to mpath13
sdp: not found in pathvec
sdp: mask = 0xc
sdp: state = 2
sdp: prio = 1
mpath13: pgfailback = -2 (controler setting)
mpath13: pgpolicy = failover (controler setting)
mpath13: selector = round-robin 0 (internal default)
mpath13: features = 0 (controler setting)
mpath13: hwhandler = 1 emc (controler setting)
mpath13: rr_weight = 2 (config file default)
mpath13: minio = 100 (config file default)
mpath13: no_path_retry = -1 (config file default)
pg_timeout = NONE (internal default)
mpath13: set ACT_NOTHING (map unchanged)
Found matching wwid [3600601603d341300f9a2dafdc512dc11] in bindings file.
Setting alias to mpath15
sdak: ownership set to mpath15
sdak: not found in pathvec
sdak: mask = 0xc
sdak: state = 2
sdak: prio = 1
sdq: ownership set to mpath15
sdq: not found in pathvec
sdq: mask = 0xc
sdq: state = 2
sdq: prio = 0
mpath15: pgfailback = -2 (controler setting)
mpath15: pgpolicy = failover (controler setting)
mpath15: selector = round-robin 0 (internal default)
mpath15: features = 0 (controler setting)
mpath15: hwhandler = 1 emc (controler setting)
mpath15: rr_weight = 2 (config file default)
mpath15: minio = 100 (config file default)
mpath15: no_path_retry = -1 (config file default)
pg_timeout = NONE (internal default)
mpath15: set ACT_NOTHING (map unchanged)
Found matching wwid [3600601601034130028e740e3c412dc11] in bindings file.
Setting alias to mpath14
sdal: ownership set to mpath14
sdal: not found in pathvec
sdal: mask = 0xc
sdal: state = 2
sdal: prio = 0
sdr: ownership set to mpath14
sdr: not found in pathvec
sdr: mask = 0xc
sdr: state = 2
sdr: prio = 1
mpath14: pgfailback = -2 (controler setting)
mpath14: pgpolicy = failover (controler setting)
mpath14: selector = round-robin 0 (internal default)
mpath14: features = 0 (controler setting)
mpath14: hwhandler = 1 emc (controler setting)
mpath14: rr_weight = 2 (config file default)
mpath14: minio = 100 (config file default)
mpath14: no_path_retry = -1 (config file default)
pg_timeout = NONE (internal default)
mpath14: set ACT_NOTHING (map unchanged)
Found matching wwid [3600601603d34130058c23305c612dc11] in bindings file.
Setting alias to mpath17
sdam: ownership set to mpath17
sdam: not found in pathvec
sdam: mask = 0xc
sdam: state = 2
sdam: prio = 1
sds: ownership set to mpath17
sds: not found in pathvec
sds: mask = 0xc
sds: state = 2
sds: prio = 0
mpath17: pgfailback = -2 (controler setting)
mpath17: pgpolicy = failover (controler setting)
mpath17: selector = round-robin 0 (internal default)
mpath17: features = 0 (controler setting)
mpath17: hwhandler = 1 emc (controler setting)
mpath17: rr_weight = 2 (config file default)
mpath17: minio = 100 (config file default)
mpath17: no_path_retry = -1 (config file default)
pg_timeout = NONE (internal default)
mpath17: remove (wwid changed)
mpath17: set ACT_CREATE (map wwid change)
create: mpath17 (3600601603d34130058c23305c612dc11)  DGC,RAID 5
[size=50G][features=0][hwhandler=1 emc]
\_ round-robin 0 [prio=1][undef]
 \_ 1:0:1:17 sdam 66:96  [undef][ready]
\_ round-robin 0 [prio=0][undef]
 \_ 1:0:0:17 sds  65:32  [undef][ready]
Found matching wwid [3600601601034130078a83aeac412dc11] in bindings file.
Setting alias to mpath17
sdan: ownership set to mpath17
sdan: not found in pathvec
sdan: mask = 0xc
sdan: state = 2
sdan: prio = 0
sdt: ownership set to mpath17
sdt: not found in pathvec
sdt: mask = 0xc
sdt: state = 2
sdt: prio = 1
mpath17: pgfailback = -2 (controler setting)
mpath17: pgpolicy = failover (controler setting)
mpath17: selector = round-robin 0 (internal default)
mpath17: features = 0 (controler setting)
mpath17: hwhandler = 1 emc (controler setting)
mpath17: rr_weight = 2 (config file default)
mpath17: minio = 100 (config file default)
mpath17: no_path_retry = -1 (config file default)
pg_timeout = NONE (internal default)
mpath17: set ACT_CREATE (map does not exist)
mpath17: domap (0) failure for create/reload map
Found matching wwid [3600601603d34130059c23305c612dc11] in bindings file.
Setting alias to mpath16
sdao: ownership set to mpath16
sdao: not found in pathvec
sdao: mask = 0xc
sdao: state = 2
sdao: prio = 1
sdu: ownership set to mpath16
sdu: not found in pathvec
sdu: mask = 0xc
sdu: state = 2
sdu: prio = 0
mpath16: pgfailback = -2 (controler setting)
mpath16: pgpolicy = failover (controler setting)
mpath16: selector = round-robin 0 (internal default)
mpath16: features = 0 (controler setting)
mpath16: hwhandler = 1 emc (controler setting)
mpath16: rr_weight = 2 (config file default)
mpath16: minio = 100 (config file default)
mpath16: no_path_retry = -1 (config file default)
pg_timeout = NONE (internal default)
mpath16: set ACT_NOTHING (map unchanged)
Found matching wwid [360060160103413007ab51dd5c412dc11] in bindings file.
Setting alias to mpath0
sdb: ownership set to mpath0
sdb: not found in pathvec
sdb: mask = 0xc
sdb: state = 2
sdb: prio = 1
sdv: ownership set to mpath0
sdv: not found in pathvec
sdv: mask = 0xc
sdv: state = 2
sdv: prio = 0
mpath0: pgfailback = -2 (controler setting)
mpath0: pgpolicy = failover (controler setting)
mpath0: selector = round-robin 0 (internal default)
mpath0: features = 0 (controler setting)
mpath0: hwhandler = 1 emc (controler setting)
mpath0: rr_weight = 2 (config file default)
mpath0: minio = 100 (config file default)
mpath0: no_path_retry = -1 (config file default)
pg_timeout = NONE (internal default)
mpath0: set ACT_NOTHING (map unchanged)
Found matching wwid [3600601603d3413000a3492f6c512dc11] in bindings file.
Setting alias to mpath2
sdc: ownership set to mpath2
sdc: not found in pathvec
sdc: mask = 0xc
sdc: state = 2
sdc: prio = 0
sdw: ownership set to mpath2
sdw: not found in pathvec
sdw: mask = 0xc
sdw: state = 2
sdw: prio = 1
mpath2: pgfailback = -2 (controler setting)
mpath2: pgpolicy = failover (controler setting)
mpath2: selector = round-robin 0 (internal default)
mpath2: features = 0 (controler setting)
mpath2: hwhandler = 1 emc (controler setting)
mpath2: rr_weight = 2 (config file default)
mpath2: minio = 100 (config file default)
mpath2: no_path_retry = -1 (config file default)
pg_timeout = NONE (internal default)
mpath2: set ACT_NOTHING (map unchanged)
Found matching wwid [360060160103413007bb51dd5c412dc11] in bindings file.
Setting alias to mpath1
sdd: ownership set to mpath1
sdd: not found in pathvec
sdd: mask = 0xc
sdd: state = 2
sdd: prio = 1
sdx: ownership set to mpath1
sdx: not found in pathvec
sdx: mask = 0xc
sdx: state = 2
sdx: prio = 0
mpath1: pgfailback = -2 (controler setting)
mpath1: pgpolicy = failover (controler setting)
mpath1: selector = round-robin 0 (internal default)
mpath1: features = 0 (controler setting)
mpath1: hwhandler = 1 emc (controler setting)
mpath1: rr_weight = 2 (config file default)
mpath1: minio = 100 (config file default)
mpath1: no_path_retry = -1 (config file default)
pg_timeout = NONE (internal default)
mpath1: set ACT_NOTHING (map unchanged)
Found matching wwid [3600601603d3413000b3492f6c512dc11] in bindings file.
Setting alias to mpath18
sde: ownership set to mpath18
sde: not found in pathvec
sde: mask = 0xc
sde: state = 2
sde: prio = 0
sdy: ownership set to mpath18
sdy: not found in pathvec
sdy: mask = 0xc
sdy: state = 2
sdy: prio = 1
mpath18: pgfailback = -2 (controler setting)
mpath18: pgpolicy = failover (controler setting)
mpath18: selector = round-robin 0 (internal default)
mpath18: features = 0 (controler setting)
mpath18: hwhandler = 1 emc (controler setting)
mpath18: rr_weight = 2 (config file default)
mpath18: minio = 100 (config file default)
mpath18: no_path_retry = -1 (config file default)
pg_timeout = NONE (internal default)
mpath18: set ACT_NOTHING (map unchanged)
Found matching wwid [360060160103413007cb51dd5c412dc11] in bindings file.
Setting alias to mpath3
sdf: ownership set to mpath3
sdf: not found in pathvec
sdf: mask = 0xc
sdf: state = 2
sdf: prio = 1
sdz: ownership set to mpath3
sdz: not found in pathvec
sdz: mask = 0xc
sdz: state = 2
sdz: prio = 0
mpath3: pgfailback = -2 (controler setting)
mpath3: pgpolicy = failover (controler setting)
mpath3: selector = round-robin 0 (internal default)
mpath3: features = 0 (controler setting)
mpath3: hwhandler = 1 emc (controler setting)
mpath3: rr_weight = 2 (config file default)
mpath3: minio = 100 (config file default)
mpath3: no_path_retry = -1 (config file default)
pg_timeout = NONE (internal default)
mpath3: set ACT_NOTHING (map unchanged)
Found matching wwid [3600601601034130078a83aeac412dc11] in bindings file.
Setting alias to mpath17
sdan: ownership set to mpath17
sdan: not found in pathvec
sdan: mask = 0xc
sdan: path checker = emc_clariion (controler setting)
sdan: state = 2
sdan: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdan: prio = 0
sdt: ownership set to mpath17
sdt: not found in pathvec
sdt: mask = 0xc
sdt: path checker = emc_clariion (controler setting)
sdt: state = 2
sdt: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
sdt: prio = 1
*mpath17: pgfailback = -2 (controler setting)
mpath17: pgpolicy = failover (controler setting)
mpath17: selector = round-robin 0 (internal default)
mpath17: features = 0 (controler setting)
mpath17: hwhandler = 1 emc (controler setting)
mpath17: rr_weight = 2 (config file default)
mpath17: minio = 100 (config file default)
mpath17: no_path_retry = -1 (config file default)
pg_timeout = NONE (internal default)
mpath17: set ACT_CREATE (map does not exist)
mpath17: domap (0) failure for create/reload map
**
*

--------------090006000104030108010704
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title>Multipath not "seeing" last luns when create mpath devices</title>
</head>
<body bgcolor="#ffffff" text="#000000">
<b>Distro - Fedora Core 6 - x86_64 - fully updated<br>
<br>
Relevant packages:<br>
<br>
lvm2-2.02.17-1.fc6<br>
device-mapper-multipath-0.4.7-5<br>
device-mapper-1.02.13-1.fc6<br>
kernel-2.6.20-1.2952.fc6<br>
<br>
HBA: Qlogic 2300<br>
<br>
Storage: EMC Clariion CX700 - Flarecode = 02,19,700,5030<br>
<br>
How reproducible: All the time<br>
<br>
Problems: <br>
<br>
1-) Lots of error messages when running lvm commands (even after
filtering passive devices in lvm.conf)<br>
<br>
</b>filter = [ "r|/dev/cdrom|", "r|/dev/sdc|",&nbsp; "r|/dev/sdd|",
"r|/dev/sde|",&nbsp; "r|/dev/sdf|", "r|/dev/sdg|", "r|/dev/sdh|",
"r|/dev/sdi|", "r|/dev/sdj|", "r|/dev/sdk|", "r|/dev/sdl|",
"r|/dev/sdm|", "r|/dev/sdn|", "r|/dev/sdo|", "r|/dev/sdp|",
"r|/dev/sdq|", "r|/dev/sdr|", "r|/dev/sds|", "r|/dev/sdt|",
"r|/dev/sdu|", "r|/dev/sdv|", "r|/dev/sdw|", "r|/dev/sdx|",
"r|/dev/sdy|", "r|/dev/sdz|", "r|/dev/sdaa|", "r|/dev/sdab|",
"r|/dev/sdac|", "r|/dev/sdad|", "r|/dev/sdaf|", "r|/dev/sdag|",
"r|/dev/sdah|", "r|/dev/sdai|", "r|/dev/sdaj|",&nbsp; "r|/dev/sdak|",&nbsp;
"r|/dev/sdal|",&nbsp; "r|/dev/sdam|",&nbsp; "r|/dev/sdan|", "a/.*/" ]<b><br>
<br>
<br>
</b>[root@pop-16 mapper]# vgdisplay -v pop_16-c3-data<br>
&nbsp;&nbsp;&nbsp; Using volume group(s) on command line<br>
&nbsp;&nbsp;&nbsp; Finding volume group "pop_16-c3-data"<br>
&nbsp; /dev/sdq: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdah: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdah1: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdc: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sds: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdc1: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdaj: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdaj1: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sde: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdu: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sde1: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdv: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdal: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdal1: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdg: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdx: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdan: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdi: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdz: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdk: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdab: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdab1: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdm: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdad: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdad1: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdo: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdaf: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; /dev/sdaf1: read failed after 0 of 4096 at 0: Input/output error<br>
&nbsp; --- Volume group ---<br>
&nbsp; VG Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pop_16-c3-data<br>
&nbsp; System ID<br>
&nbsp; Format&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; lvm2<br>
&nbsp; Metadata Areas&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 19<br>
&nbsp; Metadata Sequence No&nbsp; 1<br>
&nbsp; VG Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; read/write<br>
&nbsp; VG Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; resizable<br>
&nbsp; MAX LV&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
&nbsp; Cur LV&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
&nbsp; Open LV&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
&nbsp; Max PV&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
&nbsp; Cur PV&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 19<br>
&nbsp; Act PV&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 19<br>
&nbsp; VG Size&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 949.41 GB<br>
&nbsp; PE Size&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 32.00 MB<br>
&nbsp; Total PE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 30381<br>
&nbsp; Alloc PE / Size&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 / 0<br>
&nbsp; Free&nbsp; PE / Size&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 30381 / 949.41 GB<br>
&nbsp; VG UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3dwnTE-OAUx-ArDu-rjT5-AfhE-IfO3-fRwNTB<br>
<br>
&nbsp; --- Physical volumes ---<br>
&nbsp; PV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/mapper/mpath0p1<br>
&nbsp; PV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; VWhmRd-JivO-8omn-fVou-yjEA-0euc-3KXrvh<br>
&nbsp; PV Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; allocatable<br>
&nbsp; Total PE / Free PE&nbsp;&nbsp;&nbsp; 1599 / 1599<br>
<br>
&nbsp; PV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/mapper/mpath1p1<br>
&nbsp; PV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 13dA0R-fO0J-c7iJ-xywx-zgDO-SCxe-WBn8hh<br>
&nbsp; PV Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; allocatable<br>
&nbsp; Total PE / Free PE&nbsp;&nbsp;&nbsp; 1599 / 1599<br>
<br>
&nbsp; PV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/mapper/mpath2p1<br>
&nbsp; PV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; f0VMoA-B22o-EmHv-bhc7-kdhP-8pKt-nNZsRw<br>
&nbsp; PV Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; allocatable<br>
&nbsp; Total PE / Free PE&nbsp;&nbsp;&nbsp; 1599 / 1599<br>
<br>
&nbsp; PV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/mapper/mpath3p1<br>
&nbsp; PV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; jkexds-FRF6-h7II-Pvo4-Egt2-sYF7-VYxbsw<br>
&nbsp; PV Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; allocatable<br>
&nbsp; Total PE / Free PE&nbsp;&nbsp;&nbsp; 1599 / 1599<br>
<br>
&nbsp; PV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/mapper/mpath4p1<br>
&nbsp; PV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; EioQEG-QkyY-0jrq-VRIn-Q9eB-kZYG-pJsy41<br>
&nbsp; PV Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; allocatable<br>
&nbsp; Total PE / Free PE&nbsp;&nbsp;&nbsp; 1599 / 1599<br>
<br>
&nbsp; PV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/mapper/mpath5p1<br>
&nbsp; PV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0dKa9d-1pGf-QKyr-uXF3-6zXi-3zFn-kreM6b<br>
&nbsp; PV Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; allocatable<br>
&nbsp; Total PE / Free PE&nbsp;&nbsp;&nbsp; 1599 / 1599<br>
<br>
&nbsp; PV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/mapper/mpath6p1<br>
&nbsp; PV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BvRVTl-FbX0-gV95-mRw9-VZ3f-bvCX-tK3efR<br>
&nbsp; PV Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; allocatable<br>
&nbsp; Total PE / Free PE&nbsp;&nbsp;&nbsp; 1599 / 1599<br>
<br>
&nbsp; PV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/mapper/mpath7p1<br>
&nbsp; PV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; XQh0xL-q9K6-A0fh-SDlY-xXjt-3rVH-2HRXJC<br>
&nbsp; PV Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; allocatable<br>
&nbsp; Total PE / Free PE&nbsp;&nbsp;&nbsp; 1599 / 1599<br>
<br>
&nbsp; PV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/mapper/mpath8p1<br>
&nbsp; PV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2mnlzf-f4hY-nY1n-OXzz-y7ZE-rQo6-yQi0Ah<br>
&nbsp; PV Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; allocatable<br>
&nbsp; Total PE / Free PE&nbsp;&nbsp;&nbsp; 1599 / 1599<br>
<br>
&nbsp; PV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/mapper/mpath9p1<br>
&nbsp; PV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; coOwD2-vH3X-6z12-w0h9-Agsn-Ev7a-69wtrj<br>
&nbsp; PV Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; allocatable<br>
&nbsp; Total PE / Free PE&nbsp;&nbsp;&nbsp; 1599 / 1599<br>
<br>
&nbsp; PV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/mapper/mpath10p1<br>
&nbsp; PV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsP07P-QWFW-Or1f-KYp9-fRwR-VLLx-GL3UsF<br>
&nbsp; PV Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; allocatable<br>
&nbsp; Total PE / Free PE&nbsp;&nbsp;&nbsp; 1599 / 1599<br>
<br>
&nbsp; PV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/mapper/mpath11p1<br>
&nbsp; PV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; OkU3MI-YqIy-pXjk-hsd3-Fohv-vwtJ-YC1jOi<br>
&nbsp; PV Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; allocatable<br>
&nbsp; Total PE / Free PE&nbsp;&nbsp;&nbsp; 1599 / 1599<br>
<br>
&nbsp; PV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/mapper/mpath12p1<br>
&nbsp; PV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; orunjk-eCaq-iaQ2-iZwT-ln1D-M2Tq-OUFLOf<br>
&nbsp; PV Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; allocatable<br>
&nbsp; Total PE / Free PE&nbsp;&nbsp;&nbsp; 1599 / 1599<br>
<br>
&nbsp; PV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/mapper/mpath13p1<br>
&nbsp; PV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bYUcec-anGk-gMK3-6Ttd-5iKS-3YKd-x3Ze2G<br>
&nbsp; PV Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; allocatable<br>
&nbsp; Total PE / Free PE&nbsp;&nbsp;&nbsp; 1599 / 1599<br>
<br>
&nbsp; PV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/mapper/mpath14p1<br>
&nbsp; PV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1jzOd8-sfA7-RQCK-3biI-fehy-i98t-AU3tMA<br>
&nbsp; PV Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; allocatable<br>
&nbsp; Total PE / Free PE&nbsp;&nbsp;&nbsp; 1599 / 1599<br>
<br>
&nbsp; PV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/mapper/mpath15p1<br>
&nbsp; PV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; eWWFSH-0TWX-ov7V-n32f-Hjka-aqkg-c9Kf8F<br>
&nbsp; PV Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; allocatable<br>
&nbsp; Total PE / Free PE&nbsp;&nbsp;&nbsp; 1599 / 1599<br>
<br>
&nbsp; PV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/mapper/mpath16p1<br>
&nbsp; PV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; WQnpWM-vwTw-JQue-GxA5-3Vp1-gTiD-G887LI<br>
&nbsp; PV Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; allocatable<br>
&nbsp; Total PE / Free PE&nbsp;&nbsp;&nbsp; 1599 / 1599<br>
<br>
<b><font color="#ff0000">&nbsp; PV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/sdam1<br>
&nbsp; PV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; tFprMl-oO6o-gQUV-E9Zg-Vztr-iD3w-f6isoZ<br>
&nbsp; PV Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; allocatable<br>
&nbsp; Total PE / Free PE&nbsp;&nbsp;&nbsp; 1599 / 1599<br>
<br>
(When this volume groups was created using vgcreate I especified
/dev/mapper/mpath17p1 and not /dev/sdam1 - probably related with
problem nro 2)<br>
</font></b><br>
&nbsp; PV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/mapper/mpath18p1<br>
&nbsp; PV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; HVjnhn-KbhX-ysyZ-FZCB-uOk3-yB2W-FqIDVZ<br>
&nbsp; PV Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; allocatable<br>
&nbsp; Total PE / Free PE&nbsp;&nbsp;&nbsp; 1599 / 1599<b><br>
<br>
<br>
2-) Multipath is unable to create all mpath devices. Server "see" 20
lun pairs but multipath create only 19 mpath devices (mpath0-18). And I
have erratic results running multipath command. Ex:<br>
<br>
</b>[root@pop-16 mapper]# multipath<br>
error calling out /sbin/scsi_id -g -u -s /block/sda<br>
mpath17: remove (wwid changed)<br>
create: mpath17 (3600601603d34130058c23305c612dc11)&nbsp; DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=1][undef]<br>
&nbsp;\_ 1:0:1:17 sdam 66:96&nbsp; [undef][ready]<br>
\_ round-robin 0 [prio=0][undef]<br>
&nbsp;\_ 1:0:0:17 sds&nbsp; 65:32&nbsp; [undef][ready]<br>
[root@pop-16 mapper]#<br>
<br>
<b>Running the same command 1 second later:<br>
<br>
</b>[root@pop-16 mapper]# multipath<br>
error calling out /sbin/scsi_id -g -u -s /block/sda<br>
mpath17: remove (wwid changed)<br>
create: mpath17 (3600601601034130078a83aeac412dc11)&nbsp; DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=0][undef]<br>
&nbsp;\_ 1:0:1:18 sdan 66:112 [undef][ready]<br>
\_ round-robin 0 [prio=1][undef]<br>
&nbsp;\_ 1:0:0:18 sdt&nbsp; 65:48&nbsp; [undef][ready]<br>
[root@pop-16 mapper]#<br>
<br>
<b>and again:<br>
<br>
</b>root@pop-16 mapper]# multipath<br>
error calling out /sbin/scsi_id -g -u -s /block/sda<br>
mpath17: remove (wwid changed)<br>
create: mpath17 (3600601603d34130058c23305c612dc11)&nbsp; DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=1][undef]<br>
&nbsp;\_ 1:0:1:17 sdam 66:96&nbsp; [undef][ready]<br>
\_ round-robin 0 [prio=0][undef]<br>
&nbsp;\_ 1:0:0:17 sds&nbsp; 65:32&nbsp; [undef][ready]<br>
[root@pop-16 mapper]#<b><br>
<br>
What I "think" is causing this problem:<br>
<br>
</b>===== paths list =====<br>
uuid&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; hcil&nbsp;&nbsp;&nbsp;&nbsp; dev&nbsp; dev_t&nbsp; pri dm_st&nbsp;
chk_st&nbsp; vend<br>
3600601603d3413000c3492f6c512dc11 1:0:1:5&nbsp; sdaa 65:160 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
36006016010341300f6eb2cdcc412dc11 1:0:1:6&nbsp; sdab 65:176 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d3413000d3492f6c512dc11 1:0:1:7&nbsp; sdac 65:192 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
36006016010341300f7eb2cdcc412dc11 1:0:1:8&nbsp; sdad 65:208 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d341300f6a2dafdc512dc11 1:0:1:9&nbsp; sdae 65:224 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
36006016010341300f8eb2cdcc412dc11 1:0:1:10 sdaf 65:240 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d341300f7a2dafdc512dc11 1:0:1:11 sdag 66:0&nbsp;&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601601034130026e740e3c412dc11 1:0:1:12 sdah 66:16&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d341300f8a2dafdc512dc11 1:0:1:13 sdai 66:32&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601601034130027e740e3c412dc11 1:0:1:14 sdaj 66:48&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d341300f9a2dafdc512dc11 1:0:1:15 sdak 66:64&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601601034130028e740e3c412dc11 1:0:1:16 sdal 66:80&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d34130058c23305c612dc11 1:0:1:17 sdam 66:96&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601601034130078a83aeac412dc11 1:0:1:18 sdan 66:112 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d34130059c23305c612dc11 1:0:1:19 sdao 66:128 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0:2:0:0&nbsp; sda&nbsp; 8:0&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;
[undef][ready] Mega<br>
360060160103413007ab51dd5c412dc11 1:0:0:0&nbsp; sdb&nbsp; 8:16&nbsp;&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d3413000a3492f6c512dc11 1:0:0:1&nbsp; sdc&nbsp; 8:32&nbsp;&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
360060160103413007bb51dd5c412dc11 1:0:0:2&nbsp; sdd&nbsp; 8:48&nbsp;&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d3413000b3492f6c512dc11 1:0:0:3&nbsp; sde&nbsp; 8:64&nbsp;&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
360060160103413007cb51dd5c412dc11 1:0:0:4&nbsp; sdf&nbsp; 8:80&nbsp;&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d3413000c3492f6c512dc11 1:0:0:5&nbsp; sdg&nbsp; 8:96&nbsp;&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
36006016010341300f6eb2cdcc412dc11 1:0:0:6&nbsp; sdh&nbsp; 8:112&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d3413000d3492f6c512dc11 1:0:0:7&nbsp; sdi&nbsp; 8:128&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
36006016010341300f7eb2cdcc412dc11 1:0:0:8&nbsp; sdj&nbsp; 8:144&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d341300f6a2dafdc512dc11 1:0:0:9&nbsp; sdk&nbsp; 8:160&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
36006016010341300f8eb2cdcc412dc11 1:0:0:10 sdl&nbsp; 8:176&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d341300f7a2dafdc512dc11 1:0:0:11 sdm&nbsp; 8:192&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601601034130026e740e3c412dc11 1:0:0:12 sdn&nbsp; 8:208&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d341300f8a2dafdc512dc11 1:0:0:13 sdo&nbsp; 8:224&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601601034130027e740e3c412dc11 1:0:0:14 sdp&nbsp; 8:240&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d341300f9a2dafdc512dc11 1:0:0:15 sdq&nbsp; 65:0&nbsp;&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601601034130028e740e3c412dc11 1:0:0:16 sdr&nbsp; 65:16&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d34130058c23305c612dc11 1:0:0:17 sds&nbsp; 65:32&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601601034130078a83aeac412dc11 1:0:0:18 sdt&nbsp; 65:48&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3<b><font color="#ff0000">600601603d34130059c23305c612dc11 1:0:0:19
sdu&nbsp; 65:64&nbsp; 0&nbsp;&nbsp; [undef][ready] DGC,<br>
360060160103413007ab51dd5c412dc11 1:0:1:0&nbsp; sdv&nbsp; 65:80&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,</font></b><br>
3600601603d3413000a3492f6c512dc11 1:0:1:1&nbsp; sdw&nbsp; 65:96&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
360060160103413007bb51dd5c412dc11 1:0:1:2&nbsp; sdx&nbsp; 65:112 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d3413000b3492f6c512dc11 1:0:1:3&nbsp; sdy&nbsp; 65:128 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
360060160103413007cb51dd5c412dc11 1:0:1:4&nbsp; sdz&nbsp; 65:144 0&nbsp;&nbsp;
[undef][ready] DGC,<b><br>
<br>
Other thing that I noted, was when I run dmsetup info for all devices
(except mpath 17) I had something like:<br>
<br>
</b>[root@pop-16 mapper]# dmsetup info mpath0<br>
Name:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mpath0<br>
State:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ACTIVE<br>
Tables present:&nbsp;&nbsp;&nbsp; LIVE<br>
Open count:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<br>
Event number:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2<br>
Major, minor:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 253, 23<br>
Number of targets: 1<br>
UUID: mpath-360060160103413007ab51dd5c412dc11<br>
<br>
<b>But, when I run for mpath17 I get:<br>
<br>
</b>[root@pop-16 mapper]# dmsetup info mpath17<br>
Name:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mpath17<br>
State:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ACTIVE<br>
Tables present:&nbsp;&nbsp;&nbsp; LIVE<br>
Open count:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Event number:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<br>
Major, minor:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 253, 20<br>
Number of targets: 1<br>
UUID: mpath-3600601601034130078a83aeac412dc11<b><br>
<br>
Any ideas about what can be causing this ? <br>
<br>
Regards !<br>
<br>
Claudio Cuqui<br>
<br>
Additional information:<br>
<br>
</b>[root@pop-16 mapper]# cat /etc/multipath.conf | grep -v ^#<br>
<br>
defaults {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; user_friendly_names yes<br>
}<br>
defaults {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; udev_dir&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; polling_interval&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 10<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; selector&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "round-robin 0"<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; #path_grouping_policy&nbsp;&nbsp; multibus<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_grouping_policy&nbsp;&nbsp;&nbsp; failover<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; getuid_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "/sbin/scsi_id -g -u -s /block/%n"<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; prio_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /bin/true<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_checker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; readsector0<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rr_min_io&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 100<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rr_weight&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; priorities<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; failback&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; immediate<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; no_path_retry&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fail<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; user_friendly_name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; yes<br>
}<br>
devnode_blacklist {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|sda|st)[0-9]*"<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; devnode "^hd[a-z]"<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; devnode "^cciss!c[0-9]d[0-9]*"<br>
}<br>
devices {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; device {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vendor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "DGC"<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; product&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "*"<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bl_product&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "LUN_Z"<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_grouping_policy&nbsp;&nbsp;&nbsp; failover<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; getuid_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "/sbin/scsi_id -g -u -s
/block/%n"<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; prio_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "/sbin/mpath_prio_emc /dev/%n"<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; hardware_handler&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "1 emc"<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; features&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "0"<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_checker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; emc_clariion<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; failback&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; immediate<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>
}<br>
<br>
[root@pop-16 mapper]# ls -1 mpath*<br>
mpath0<br>
mpath0p1<br>
mpath1<br>
mpath1p1<br>
mpath2<br>
mpath2p1<br>
mpath3<br>
mpath3p1<br>
mpath4<br>
mpath4p1<br>
mpath5<br>
mpath5p1<br>
mpath6<br>
mpath6p1<br>
mpath7<br>
mpath7p1<br>
mpath8<br>
mpath8p1<br>
mpath9<br>
mpath9p1<br>
mpath10<br>
mpath10p1<br>
mpath11<br>
mpath11p1<br>
mpath12<br>
mpath12p1<br>
mpath13<br>
mpath13p1<br>
mpath14<br>
mpath14p1<br>
mpath15<br>
mpath15p1<br>
mpath16<br>
mpath16p1<br>
mpath17<br>
mpath18<br>
mpath18p1<br>
<br>
<b>[root@pop-16 mapper]# cat /proc/scsi/scsi<br>
<br>
</b>Attached devices:<br>
Host: scsi0 Channel: 00 Id: 06 Lun: 00<br>
&nbsp; Vendor: PE/PV&nbsp;&nbsp;&nbsp; Model: 1x3 SCSI BP&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 1.1<br>
&nbsp; Type:&nbsp;&nbsp; Processor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 02<br>
Host: scsi0 Channel: 02 Id: 00 Lun: 00<br>
&nbsp; Vendor: MegaRAID Model: LD 0 RAID1&nbsp;&nbsp; 34G Rev: 422A<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 02<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 00<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 01<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 02<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 03<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 04<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 05<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 06<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 07<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 08<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 09<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 10<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 11<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 12<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 13<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 14<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 15<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 16<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 17<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 18<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 19<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 01 Lun: 00<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 01 Lun: 01<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 01 Lun: 02<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 01 Lun: 03<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 01 Lun: 04<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 01 Lun: 05<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 01 Lun: 06<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 01 Lun: 07<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 01 Lun: 08<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 01 Lun: 09<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 01 Lun: 10<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 01 Lun: 11<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 01 Lun: 12<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 01 Lun: 13<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 01 Lun: 14<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 01 Lun: 15<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 01 Lun: 16<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 01 Lun: 17<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 01 Lun: 18<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
Host: scsi1 Channel: 00 Id: 01 Lun: 19<br>
&nbsp; Vendor: DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: RAID 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0219<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 04<br>
[root@pop-16 mapper]#<br>
<b><br>
[root@pop-16 dev]# multipath -ll<br>
<br>
</b>mpath2 (3600601603d3413000a3492f6c512dc11) dm-24 DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=0][enabled]<br>
&nbsp;\_ 1:0:0:1&nbsp; sdc&nbsp; 8:32&nbsp;&nbsp; [active][ready]<br>
\_ round-robin 0 [prio=1][active]<br>
&nbsp;\_ 1:0:1:1&nbsp; sdw&nbsp; 65:96&nbsp; [active][ready]<br>
mpath1 (360060160103413007bb51dd5c412dc11) dm-25 DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=1][active]<br>
&nbsp;\_ 1:0:0:2&nbsp; sdd&nbsp; 8:48&nbsp;&nbsp; [active][ready]<br>
\_ round-robin 0 [prio=0][enabled]<br>
&nbsp;\_ 1:0:1:2&nbsp; sdx&nbsp; 65:112 [active][ready]<br>
mpath0 (360060160103413007ab51dd5c412dc11) dm-23 DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=1][active]<br>
&nbsp;\_ 1:0:0:0&nbsp; sdb&nbsp; 8:16&nbsp;&nbsp; [active][ready]<br>
\_ round-robin 0 [prio=0][enabled]<br>
&nbsp;\_ 1:0:1:0&nbsp; sdv&nbsp; 65:80&nbsp; [active][ready]<br>
mpath18 (3600601603d3413000b3492f6c512dc11) dm-26 DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=0][enabled]<br>
&nbsp;\_ 1:0:0:3&nbsp; sde&nbsp; 8:64&nbsp;&nbsp; [active][ready]<br>
\_ round-robin 0 [prio=1][active]<br>
&nbsp;\_ 1:0:1:3&nbsp; sdy&nbsp; 65:128 [active][ready]<br>
<b>mpath17 (3600601601034130078a83aeac412dc11) dm-20 DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=0][enabled]<br>
&nbsp;\_ 1:0:1:18 sdan 66:112 [active][ready]<br>
\_ round-robin 0 [prio=1][active]<br>
&nbsp;\_ 1:0:0:18 sdt&nbsp; 65:48&nbsp; [active][ready]</b><br>
mpath16 (3600601603d34130059c23305c612dc11) dm-22 DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=1][active]<br>
&nbsp;\_ 1:0:1:19 sdao 66:128 [active][ready]<br>
\_ round-robin 0 [prio=0][enabled]<br>
&nbsp;\_ 1:0:0:19 sdu&nbsp; 65:64&nbsp; [active][ready]<br>
mpath9 (36006016010341300f6eb2cdcc412dc11) dm-9 DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=0][enabled]<br>
&nbsp;\_ 1:0:1:6&nbsp; sdab 65:176 [active][ready]<br>
\_ round-robin 0 [prio=1][active]<br>
&nbsp;\_ 1:0:0:6&nbsp; sdh&nbsp; 8:112&nbsp; [active][ready]<br>
mpath15 (3600601603d341300f9a2dafdc512dc11) dm-18 DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=1][active]<br>
&nbsp;\_ 1:0:1:15 sdak 66:64&nbsp; [active][ready]<br>
\_ round-robin 0 [prio=0][enabled]<br>
&nbsp;\_ 1:0:0:15 sdq&nbsp; 65:0&nbsp;&nbsp; [active][ready]<br>
mpath8 (3600601603d341300f7a2dafdc512dc11) dm-14 DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=1][active]<br>
&nbsp;\_ 1:0:1:11 sdag 66:0&nbsp;&nbsp; [active][ready]<br>
\_ round-robin 0 [prio=0][enabled]<br>
&nbsp;\_ 1:0:0:11 sdm&nbsp; 8:192&nbsp; [active][ready]<br>
mpath14 (3600601601034130028e740e3c412dc11) dm-19 DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=0][enabled]<br>
&nbsp;\_ 1:0:1:16 sdal 66:80&nbsp; [active][ready]<br>
\_ round-robin 0 [prio=1][active]<br>
&nbsp;\_ 1:0:0:16 sdr&nbsp; 65:16&nbsp; [active][ready]<br>
mpath7 (3600601603d341300f6a2dafdc512dc11) dm-12 DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=1][active]<br>
&nbsp;\_ 1:0:1:9&nbsp; sdae 65:224 [active][ready]<br>
\_ round-robin 0 [prio=0][enabled]<br>
&nbsp;\_ 1:0:0:9&nbsp; sdk&nbsp; 8:160&nbsp; [active][ready]<br>
mpath13 (3600601601034130027e740e3c412dc11) dm-17 DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=0][enabled]<br>
&nbsp;\_ 1:0:1:14 sdaj 66:48&nbsp; [active][ready]<br>
\_ round-robin 0 [prio=1][active]<br>
&nbsp;\_ 1:0:0:14 sdp&nbsp; 8:240&nbsp; [active][ready]<br>
mpath6 (3600601603d3413000c3492f6c512dc11) dm-8 DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=1][active]<br>
&nbsp;\_ 1:0:1:5&nbsp; sdaa 65:160 [active][ready]<br>
\_ round-robin 0 [prio=0][enabled]<br>
&nbsp;\_ 1:0:0:5&nbsp; sdg&nbsp; 8:96&nbsp;&nbsp; [active][ready]<br>
mpath12 (3600601603d341300f8a2dafdc512dc11) dm-16 DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=1][active]<br>
&nbsp;\_ 1:0:1:13 sdai 66:32&nbsp; [active][ready]<br>
\_ round-robin 0 [prio=0][enabled]<br>
&nbsp;\_ 1:0:0:13 sdo&nbsp; 8:224&nbsp; [active][ready]<br>
mpath5 (36006016010341300f7eb2cdcc412dc11) dm-11 DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=0][enabled]<br>
&nbsp;\_ 1:0:1:8&nbsp; sdad 65:208 [active][ready]<br>
\_ round-robin 0 [prio=1][active]<br>
&nbsp;\_ 1:0:0:8&nbsp; sdj&nbsp; 8:144&nbsp; [active][ready]<br>
mpath11 (3600601601034130026e740e3c412dc11) dm-15 DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=0][enabled]<br>
&nbsp;\_ 1:0:1:12 sdah 66:16&nbsp; [active][ready]<br>
\_ round-robin 0 [prio=1][active]<br>
&nbsp;\_ 1:0:0:12 sdn&nbsp; 8:208&nbsp; [active][ready]<br>
mpath4 (3600601603d3413000d3492f6c512dc11) dm-10 DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=1][active]<br>
&nbsp;\_ 1:0:1:7&nbsp; sdac 65:192 [active][ready]<br>
\_ round-robin 0 [prio=0][enabled]<br>
&nbsp;\_ 1:0:0:7&nbsp; sdi&nbsp; 8:128&nbsp; [active][ready]<br>
mpath10 (36006016010341300f8eb2cdcc412dc11) dm-13 DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=0][enabled]<br>
&nbsp;\_ 1:0:1:10 sdaf 65:240 [active][ready]<br>
\_ round-robin 0 [prio=1][active]<br>
&nbsp;\_ 1:0:0:10 sdl&nbsp; 8:176&nbsp; [active][ready]<br>
mpath3 (360060160103413007cb51dd5c412dc11) dm-27 DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=1][active]<br>
&nbsp;\_ 1:0:0:4&nbsp; sdf&nbsp; 8:80&nbsp;&nbsp; [active][ready]<br>
\_ round-robin 0 [prio=0][enabled]<br>
&nbsp;\_ 1:0:1:4&nbsp; sdz&nbsp; 65:144 [active][ready]<br>
[root@pop-16 dev]#<br>
<b><br>
[root@pop-16 dev]# multipath -v 3<br>
<br>
</b>dm-0: blacklisted<br>
dm-10: blacklisted<br>
dm-11: blacklisted<br>
dm-12: blacklisted<br>
dm-13: blacklisted<br>
dm-14: blacklisted<br>
dm-15: blacklisted<br>
dm-16: blacklisted<br>
dm-17: blacklisted<br>
dm-18: blacklisted<br>
dm-19: blacklisted<br>
dm-1: blacklisted<br>
dm-20: blacklisted<br>
dm-22: blacklisted<br>
dm-23: blacklisted<br>
dm-24: blacklisted<br>
dm-25: blacklisted<br>
dm-26: blacklisted<br>
dm-27: blacklisted<br>
dm-28: blacklisted<br>
dm-29: blacklisted<br>
dm-2: blacklisted<br>
dm-31: blacklisted<br>
dm-32: blacklisted<br>
dm-33: blacklisted<br>
dm-34: blacklisted<br>
dm-35: blacklisted<br>
dm-36: blacklisted<br>
dm-37: blacklisted<br>
dm-38: blacklisted<br>
dm-39: blacklisted<br>
dm-3: blacklisted<br>
dm-40: blacklisted<br>
dm-41: blacklisted<br>
dm-42: blacklisted<br>
dm-43: blacklisted<br>
dm-44: blacklisted<br>
dm-45: blacklisted<br>
dm-46: blacklisted<br>
dm-4: blacklisted<br>
dm-5: blacklisted<br>
dm-6: blacklisted<br>
dm-7: blacklisted<br>
dm-8: blacklisted<br>
dm-9: blacklisted<br>
fd0: blacklisted<br>
hdc: blacklisted<br>
md0: blacklisted<br>
ram0: blacklisted<br>
ram10: blacklisted<br>
ram11: blacklisted<br>
ram12: blacklisted<br>
ram13: blacklisted<br>
ram14: blacklisted<br>
ram15: blacklisted<br>
ram1: blacklisted<br>
ram2: blacklisted<br>
ram3: blacklisted<br>
ram4: blacklisted<br>
ram5: blacklisted<br>
ram6: blacklisted<br>
ram7: blacklisted<br>
ram8: blacklisted<br>
ram9: blacklisted<br>
sdaa: not found in pathvec<br>
sdaa: mask = 0x1f<br>
sdaa: bus = 1<br>
sdaa: dev_t = 65:160<br>
sdaa: size = 104857600<br>
sdaa: vendor = DGC<br>
sdaa: product = RAID 5<br>
sdaa: rev = 0219<br>
sdaa: h:b:t:l = 1:0:1:5<br>
sdaa: tgt_node_name = 0x50060160b060189e<br>
sdaa: serial = CK200050300477<br>
sdaa: path checker = emc_clariion (controler setting)<br>
sdaa: state = 2<br>
sdaa: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdaa: prio = 1<br>
sdaa: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdaa: uid = 3600601603d3413000c3492f6c512dc11 (callout)<br>
sdab: not found in pathvec<br>
sdab: mask = 0x1f<br>
sdab: bus = 1<br>
sdab: dev_t = 65:176<br>
sdab: size = 104857600<br>
sdab: vendor = DGC<br>
sdab: product = RAID 5<br>
sdab: rev = 0219<br>
sdab: h:b:t:l = 1:0:1:6<br>
sdab: tgt_node_name = 0x50060160b060189e<br>
sdab: serial = CK200050300477<br>
sdab: path checker = emc_clariion (controler setting)<br>
sdab: state = 2<br>
sdab: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdab: prio = 0<br>
sdab: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdab: uid = 36006016010341300f6eb2cdcc412dc11 (callout)<br>
sdac: not found in pathvec<br>
sdac: mask = 0x1f<br>
sdac: bus = 1<br>
sdac: dev_t = 65:192<br>
sdac: size = 104857600<br>
sdac: vendor = DGC<br>
sdac: product = RAID 5<br>
sdac: rev = 0219<br>
sdac: h:b:t:l = 1:0:1:7<br>
sdac: tgt_node_name = 0x50060160b060189e<br>
sdac: serial = CK200050300477<br>
sdac: path checker = emc_clariion (controler setting)<br>
sdac: state = 2<br>
sdac: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdac: prio = 1<br>
sdac: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdac: uid = 3600601603d3413000d3492f6c512dc11 (callout)<br>
sdad: not found in pathvec<br>
sdad: mask = 0x1f<br>
sdad: bus = 1<br>
sdad: dev_t = 65:208<br>
sdad: size = 104857600<br>
sdad: vendor = DGC<br>
sdad: product = RAID 5<br>
sdad: rev = 0219<br>
sdad: h:b:t:l = 1:0:1:8<br>
sdad: tgt_node_name = 0x50060160b060189e<br>
sdad: serial = CK200050300477<br>
sdad: path checker = emc_clariion (controler setting)<br>
sdad: state = 2<br>
sdad: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdad: prio = 0<br>
sdad: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdad: uid = 36006016010341300f7eb2cdcc412dc11 (callout)<br>
sdae: not found in pathvec<br>
sdae: mask = 0x1f<br>
sdae: bus = 1<br>
sdae: dev_t = 65:224<br>
sdae: size = 104857600<br>
sdae: vendor = DGC<br>
sdae: product = RAID 5<br>
sdae: rev = 0219<br>
sdae: h:b:t:l = 1:0:1:9<br>
sdae: tgt_node_name = 0x50060160b060189e<br>
sdae: serial = CK200050300477<br>
sdae: path checker = emc_clariion (controler setting)<br>
sdae: state = 2<br>
sdae: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdae: prio = 1<br>
sdae: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdae: uid = 3600601603d341300f6a2dafdc512dc11 (callout)<br>
sdaf: not found in pathvec<br>
sdaf: mask = 0x1f<br>
sdaf: bus = 1<br>
sdaf: dev_t = 65:240<br>
sdaf: size = 104857600<br>
sdaf: vendor = DGC<br>
sdaf: product = RAID 5<br>
sdaf: rev = 0219<br>
sdaf: h:b:t:l = 1:0:1:10<br>
sdaf: tgt_node_name = 0x50060160b060189e<br>
sdaf: serial = CK200050300477<br>
sdaf: path checker = emc_clariion (controler setting)<br>
sdaf: state = 2<br>
sdaf: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdaf: prio = 0<br>
sdaf: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdaf: uid = 36006016010341300f8eb2cdcc412dc11 (callout)<br>
sdag: not found in pathvec<br>
sdag: mask = 0x1f<br>
sdag: bus = 1<br>
sdag: dev_t = 66:0<br>
sdag: size = 104857600<br>
sdag: vendor = DGC<br>
sdag: product = RAID 5<br>
sdag: rev = 0219<br>
sdag: h:b:t:l = 1:0:1:11<br>
sdag: tgt_node_name = 0x50060160b060189e<br>
sdag: serial = CK200050300477<br>
sdag: path checker = emc_clariion (controler setting)<br>
sdag: state = 2<br>
sdag: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdag: prio = 1<br>
sdag: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdag: uid = 3600601603d341300f7a2dafdc512dc11 (callout)<br>
sdah: not found in pathvec<br>
sdah: mask = 0x1f<br>
sdah: bus = 1<br>
sdah: dev_t = 66:16<br>
sdah: size = 104857600<br>
sdah: vendor = DGC<br>
sdah: product = RAID 5<br>
sdah: rev = 0219<br>
sdah: h:b:t:l = 1:0:1:12<br>
sdah: tgt_node_name = 0x50060160b060189e<br>
sdah: serial = CK200050300477<br>
sdah: path checker = emc_clariion (controler setting)<br>
sdah: state = 2<br>
sdah: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdah: prio = 0<br>
sdah: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdah: uid = 3600601601034130026e740e3c412dc11 (callout)<br>
sdai: not found in pathvec<br>
sdai: mask = 0x1f<br>
sdai: bus = 1<br>
sdai: dev_t = 66:32<br>
sdai: size = 104857600<br>
sdai: vendor = DGC<br>
sdai: product = RAID 5<br>
sdai: rev = 0219<br>
sdai: h:b:t:l = 1:0:1:13<br>
sdai: tgt_node_name = 0x50060160b060189e<br>
sdai: serial = CK200050300477<br>
sdai: path checker = emc_clariion (controler setting)<br>
sdai: state = 2<br>
sdai: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdai: prio = 1<br>
sdai: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdai: uid = 3600601603d341300f8a2dafdc512dc11 (callout)<br>
sdaj: not found in pathvec<br>
sdaj: mask = 0x1f<br>
sdaj: bus = 1<br>
sdaj: dev_t = 66:48<br>
sdaj: size = 104857600<br>
sdaj: vendor = DGC<br>
sdaj: product = RAID 5<br>
sdaj: rev = 0219<br>
sdaj: h:b:t:l = 1:0:1:14<br>
sdaj: tgt_node_name = 0x50060160b060189e<br>
sdaj: serial = CK200050300477<br>
sdaj: path checker = emc_clariion (controler setting)<br>
sdaj: state = 2<br>
sdaj: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdaj: prio = 0<br>
sdaj: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdaj: uid = 3600601601034130027e740e3c412dc11 (callout)<br>
sdak: not found in pathvec<br>
sdak: mask = 0x1f<br>
sdak: bus = 1<br>
sdak: dev_t = 66:64<br>
sdak: size = 104857600<br>
sdak: vendor = DGC<br>
sdak: product = RAID 5<br>
sdak: rev = 0219<br>
sdak: h:b:t:l = 1:0:1:15<br>
sdak: tgt_node_name = 0x50060160b060189e<br>
sdak: serial = CK200050300477<br>
sdak: path checker = emc_clariion (controler setting)<br>
sdak: state = 2<br>
sdak: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdak: prio = 1<br>
sdak: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdak: uid = 3600601603d341300f9a2dafdc512dc11 (callout)<br>
sdal: not found in pathvec<br>
sdal: mask = 0x1f<br>
sdal: bus = 1<br>
sdal: dev_t = 66:80<br>
sdal: size = 104857600<br>
sdal: vendor = DGC<br>
sdal: product = RAID 5<br>
sdal: rev = 0219<br>
sdal: h:b:t:l = 1:0:1:16<br>
sdal: tgt_node_name = 0x50060160b060189e<br>
sdal: serial = CK200050300477<br>
sdal: path checker = emc_clariion (controler setting)<br>
sdal: state = 2<br>
sdal: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdal: prio = 0<br>
sdal: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdal: uid = 3600601601034130028e740e3c412dc11 (callout)<br>
sdam: not found in pathvec<br>
sdam: mask = 0x1f<br>
sdam: bus = 1<br>
sdam: dev_t = 66:96<br>
sdam: size = 104857600<br>
sdam: vendor = DGC<br>
sdam: product = RAID 5<br>
sdam: rev = 0219<br>
sdam: h:b:t:l = 1:0:1:17<br>
sdam: tgt_node_name = 0x50060160b060189e<br>
sdam: serial = CK200050300477<br>
sdam: path checker = emc_clariion (controler setting)<br>
sdam: state = 2<br>
sdam: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdam: prio = 1<br>
sdam: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdam: uid = 3600601603d34130058c23305c612dc11 (callout)<br>
sdan: not found in pathvec<br>
sdan: mask = 0x1f<br>
sdan: bus = 1<br>
sdan: dev_t = 66:112<br>
sdan: size = 104857600<br>
sdan: vendor = DGC<br>
sdan: product = RAID 5<br>
sdan: rev = 0219<br>
sdan: h:b:t:l = 1:0:1:18<br>
sdan: tgt_node_name = 0x50060160b060189e<br>
sdan: serial = CK200050300477<br>
sdan: path checker = emc_clariion (controler setting)<br>
sdan: state = 2<br>
sdan: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdan: prio = 0<br>
sdan: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdan: uid = 3600601601034130078a83aeac412dc11 (callout)<br>
sdao: not found in pathvec<br>
sdao: mask = 0x1f<br>
sdao: bus = 1<br>
sdao: dev_t = 66:128<br>
sdao: size = 104857600<br>
sdao: vendor = DGC<br>
sdao: product = RAID 5<br>
sdao: rev = 0219<br>
sdao: h:b:t:l = 1:0:1:19<br>
sdao: tgt_node_name = 0x50060160b060189e<br>
sdao: serial = CK200050300477<br>
sdao: path checker = emc_clariion (controler setting)<br>
sdao: state = 2<br>
sdao: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdao: prio = 1<br>
sdao: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdao: uid = 3600601603d34130059c23305c612dc11 (callout)<br>
sda: not found in pathvec<br>
sda: mask = 0x1f<br>
sda: bus = 1<br>
sda: dev_t = 8:0<br>
sda: size = 70774784<br>
sda: vendor = MegaRAID<br>
sda: product = LD 0 RAID1&nbsp;&nbsp; 34G<br>
sda: rev = 422A<br>
sda: h:b:t:l = 0:2:0:0<br>
sda: serial =<br>
sda: path checker = readsector0 (config file default)<br>
sda: state = 2<br>
sda: getprio = /bin/true (config file default)<br>
sda: prio = 0<br>
sda: getuid = /sbin/scsi_id -g -u -s /block/%n (config file default)<br>
error calling out /sbin/scsi_id -g -u -s /block/sda<br>
sdb: not found in pathvec<br>
sdb: mask = 0x1f<br>
sdb: bus = 1<br>
sdb: dev_t = 8:16<br>
sdb: size = 104857600<br>
sdb: vendor = DGC<br>
sdb: product = RAID 5<br>
sdb: rev = 0219<br>
sdb: h:b:t:l = 1:0:0:0<br>
sdb: tgt_node_name = 0x50060160b060189e<br>
sdb: serial = CK200050300477<br>
sdb: path checker = emc_clariion (controler setting)<br>
sdb: state = 2<br>
sdb: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdb: prio = 1<br>
sdb: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdb: uid = 360060160103413007ab51dd5c412dc11 (callout)<br>
sdc: not found in pathvec<br>
sdc: mask = 0x1f<br>
sdc: bus = 1<br>
sdc: dev_t = 8:32<br>
sdc: size = 104857600<br>
sdc: vendor = DGC<br>
sdc: product = RAID 5<br>
sdc: rev = 0219<br>
sdc: h:b:t:l = 1:0:0:1<br>
sdc: tgt_node_name = 0x50060160b060189e<br>
sdc: serial = CK200050300477<br>
sdc: path checker = emc_clariion (controler setting)<br>
sdc: state = 2<br>
sdc: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdc: prio = 0<br>
sdc: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdc: uid = 3600601603d3413000a3492f6c512dc11 (callout)<br>
sdd: not found in pathvec<br>
sdd: mask = 0x1f<br>
sdd: bus = 1<br>
sdd: dev_t = 8:48<br>
sdd: size = 104857600<br>
sdd: vendor = DGC<br>
sdd: product = RAID 5<br>
sdd: rev = 0219<br>
sdd: h:b:t:l = 1:0:0:2<br>
sdd: tgt_node_name = 0x50060160b060189e<br>
sdd: serial = CK200050300477<br>
sdd: path checker = emc_clariion (controler setting)<br>
sdd: state = 2<br>
sdd: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdd: prio = 1<br>
sdd: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdd: uid = 360060160103413007bb51dd5c412dc11 (callout)<br>
sde: not found in pathvec<br>
sde: mask = 0x1f<br>
sde: bus = 1<br>
sde: dev_t = 8:64<br>
sde: size = 104857600<br>
sde: vendor = DGC<br>
sde: product = RAID 5<br>
sde: rev = 0219<br>
sde: h:b:t:l = 1:0:0:3<br>
sde: tgt_node_name = 0x50060160b060189e<br>
sde: serial = CK200050300477<br>
sde: path checker = emc_clariion (controler setting)<br>
sde: state = 2<br>
sde: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sde: prio = 0<br>
sde: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sde: uid = 3600601603d3413000b3492f6c512dc11 (callout)<br>
sdf: not found in pathvec<br>
sdf: mask = 0x1f<br>
sdf: bus = 1<br>
sdf: dev_t = 8:80<br>
sdf: size = 104857600<br>
sdf: vendor = DGC<br>
sdf: product = RAID 5<br>
sdf: rev = 0219<br>
sdf: h:b:t:l = 1:0:0:4<br>
sdf: tgt_node_name = 0x50060160b060189e<br>
sdf: serial = CK200050300477<br>
sdf: path checker = emc_clariion (controler setting)<br>
sdf: state = 2<br>
sdf: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdf: prio = 1<br>
sdf: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdf: uid = 360060160103413007cb51dd5c412dc11 (callout)<br>
sdg: not found in pathvec<br>
sdg: mask = 0x1f<br>
sdg: bus = 1<br>
sdg: dev_t = 8:96<br>
sdg: size = 104857600<br>
sdg: vendor = DGC<br>
sdg: product = RAID 5<br>
sdg: rev = 0219<br>
sdg: h:b:t:l = 1:0:0:5<br>
sdg: tgt_node_name = 0x50060160b060189e<br>
sdg: serial = CK200050300477<br>
sdg: path checker = emc_clariion (controler setting)<br>
sdg: state = 2<br>
sdg: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdg: prio = 0<br>
sdg: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdg: uid = 3600601603d3413000c3492f6c512dc11 (callout)<br>
sdh: not found in pathvec<br>
sdh: mask = 0x1f<br>
sdh: bus = 1<br>
sdh: dev_t = 8:112<br>
sdh: size = 104857600<br>
sdh: vendor = DGC<br>
sdh: product = RAID 5<br>
sdh: rev = 0219<br>
sdh: h:b:t:l = 1:0:0:6<br>
sdh: tgt_node_name = 0x50060160b060189e<br>
sdh: serial = CK200050300477<br>
sdh: path checker = emc_clariion (controler setting)<br>
sdh: state = 2<br>
sdh: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdh: prio = 1<br>
sdh: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdh: uid = 36006016010341300f6eb2cdcc412dc11 (callout)<br>
sdi: not found in pathvec<br>
sdi: mask = 0x1f<br>
sdi: bus = 1<br>
sdi: dev_t = 8:128<br>
sdi: size = 104857600<br>
sdi: vendor = DGC<br>
sdi: product = RAID 5<br>
sdi: rev = 0219<br>
sdi: h:b:t:l = 1:0:0:7<br>
sdi: tgt_node_name = 0x50060160b060189e<br>
sdi: serial = CK200050300477<br>
sdi: path checker = emc_clariion (controler setting)<br>
sdi: state = 2<br>
sdi: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdi: prio = 0<br>
sdi: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdi: uid = 3600601603d3413000d3492f6c512dc11 (callout)<br>
sdj: not found in pathvec<br>
sdj: mask = 0x1f<br>
sdj: bus = 1<br>
sdj: dev_t = 8:144<br>
sdj: size = 104857600<br>
sdj: vendor = DGC<br>
sdj: product = RAID 5<br>
sdj: rev = 0219<br>
sdj: h:b:t:l = 1:0:0:8<br>
sdj: tgt_node_name = 0x50060160b060189e<br>
sdj: serial = CK200050300477<br>
sdj: path checker = emc_clariion (controler setting)<br>
sdj: state = 2<br>
sdj: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdj: prio = 1<br>
sdj: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdj: uid = 36006016010341300f7eb2cdcc412dc11 (callout)<br>
sdk: not found in pathvec<br>
sdk: mask = 0x1f<br>
sdk: bus = 1<br>
sdk: dev_t = 8:160<br>
sdk: size = 104857600<br>
sdk: vendor = DGC<br>
sdk: product = RAID 5<br>
sdk: rev = 0219<br>
sdk: h:b:t:l = 1:0:0:9<br>
sdk: tgt_node_name = 0x50060160b060189e<br>
sdk: serial = CK200050300477<br>
sdk: path checker = emc_clariion (controler setting)<br>
sdk: state = 2<br>
sdk: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdk: prio = 0<br>
sdk: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdk: uid = 3600601603d341300f6a2dafdc512dc11 (callout)<br>
sdl: not found in pathvec<br>
sdl: mask = 0x1f<br>
sdl: bus = 1<br>
sdl: dev_t = 8:176<br>
sdl: size = 104857600<br>
sdl: vendor = DGC<br>
sdl: product = RAID 5<br>
sdl: rev = 0219<br>
sdl: h:b:t:l = 1:0:0:10<br>
sdl: tgt_node_name = 0x50060160b060189e<br>
sdl: serial = CK200050300477<br>
sdl: path checker = emc_clariion (controler setting)<br>
sdl: state = 2<br>
sdl: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdl: prio = 1<br>
sdl: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdl: uid = 36006016010341300f8eb2cdcc412dc11 (callout)<br>
sdm: not found in pathvec<br>
sdm: mask = 0x1f<br>
sdm: bus = 1<br>
sdm: dev_t = 8:192<br>
sdm: size = 104857600<br>
sdm: vendor = DGC<br>
sdm: product = RAID 5<br>
sdm: rev = 0219<br>
sdm: h:b:t:l = 1:0:0:11<br>
sdm: tgt_node_name = 0x50060160b060189e<br>
sdm: serial = CK200050300477<br>
sdm: path checker = emc_clariion (controler setting)<br>
sdm: state = 2<br>
sdm: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdm: prio = 0<br>
sdm: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdm: uid = 3600601603d341300f7a2dafdc512dc11 (callout)<br>
sdn: not found in pathvec<br>
sdn: mask = 0x1f<br>
sdn: bus = 1<br>
sdn: dev_t = 8:208<br>
sdn: size = 104857600<br>
sdn: vendor = DGC<br>
sdn: product = RAID 5<br>
sdn: rev = 0219<br>
sdn: h:b:t:l = 1:0:0:12<br>
sdn: tgt_node_name = 0x50060160b060189e<br>
sdn: serial = CK200050300477<br>
sdn: path checker = emc_clariion (controler setting)<br>
sdn: state = 2<br>
sdn: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdn: prio = 1<br>
sdn: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdn: uid = 3600601601034130026e740e3c412dc11 (callout)<br>
sdo: not found in pathvec<br>
sdo: mask = 0x1f<br>
sdo: bus = 1<br>
sdo: dev_t = 8:224<br>
sdo: size = 104857600<br>
sdo: vendor = DGC<br>
sdo: product = RAID 5<br>
sdo: rev = 0219<br>
sdo: h:b:t:l = 1:0:0:13<br>
sdo: tgt_node_name = 0x50060160b060189e<br>
sdo: serial = CK200050300477<br>
sdo: path checker = emc_clariion (controler setting)<br>
sdo: state = 2<br>
sdo: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdo: prio = 0<br>
sdo: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdo: uid = 3600601603d341300f8a2dafdc512dc11 (callout)<br>
sdp: not found in pathvec<br>
sdp: mask = 0x1f<br>
sdp: bus = 1<br>
sdp: dev_t = 8:240<br>
sdp: size = 104857600<br>
sdp: vendor = DGC<br>
sdp: product = RAID 5<br>
sdp: rev = 0219<br>
sdp: h:b:t:l = 1:0:0:14<br>
sdp: tgt_node_name = 0x50060160b060189e<br>
sdp: serial = CK200050300477<br>
sdp: path checker = emc_clariion (controler setting)<br>
sdp: state = 2<br>
sdp: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdp: prio = 1<br>
sdp: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdp: uid = 3600601601034130027e740e3c412dc11 (callout)<br>
sdq: not found in pathvec<br>
sdq: mask = 0x1f<br>
sdq: bus = 1<br>
sdq: dev_t = 65:0<br>
sdq: size = 104857600<br>
sdq: vendor = DGC<br>
sdq: product = RAID 5<br>
sdq: rev = 0219<br>
sdq: h:b:t:l = 1:0:0:15<br>
sdq: tgt_node_name = 0x50060160b060189e<br>
sdq: serial = CK200050300477<br>
sdq: path checker = emc_clariion (controler setting)<br>
sdq: state = 2<br>
sdq: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdq: prio = 0<br>
sdq: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdq: uid = 3600601603d341300f9a2dafdc512dc11 (callout)<br>
sdr: not found in pathvec<br>
sdr: mask = 0x1f<br>
sdr: bus = 1<br>
sdr: dev_t = 65:16<br>
sdr: size = 104857600<br>
sdr: vendor = DGC<br>
sdr: product = RAID 5<br>
sdr: rev = 0219<br>
sdr: h:b:t:l = 1:0:0:16<br>
sdr: tgt_node_name = 0x50060160b060189e<br>
sdr: serial = CK200050300477<br>
sdr: path checker = emc_clariion (controler setting)<br>
sdr: state = 2<br>
sdr: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdr: prio = 1<br>
sdr: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdr: uid = 3600601601034130028e740e3c412dc11 (callout)<br>
sds: not found in pathvec<br>
sds: mask = 0x1f<br>
sds: bus = 1<br>
sds: dev_t = 65:32<br>
sds: size = 104857600<br>
sds: vendor = DGC<br>
sds: product = RAID 5<br>
sds: rev = 0219<br>
sds: h:b:t:l = 1:0:0:17<br>
sds: tgt_node_name = 0x50060160b060189e<br>
sds: serial = CK200050300477<br>
sds: path checker = emc_clariion (controler setting)<br>
sds: state = 2<br>
sds: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sds: prio = 0<br>
sds: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sds: uid = 3600601603d34130058c23305c612dc11 (callout)<br>
sdt: not found in pathvec<br>
sdt: mask = 0x1f<br>
sdt: bus = 1<br>
sdt: dev_t = 65:48<br>
sdt: size = 104857600<br>
sdt: vendor = DGC<br>
sdt: product = RAID 5<br>
sdt: rev = 0219<br>
sdt: h:b:t:l = 1:0:0:18<br>
sdt: tgt_node_name = 0x50060160b060189e<br>
sdt: serial = CK200050300477<br>
sdt: path checker = emc_clariion (controler setting)<br>
sdt: state = 2<br>
sdt: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdt: prio = 1<br>
sdt: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdt: uid = 3600601601034130078a83aeac412dc11 (callout)<br>
sdu: not found in pathvec<br>
sdu: mask = 0x1f<br>
sdu: bus = 1<br>
sdu: dev_t = 65:64<br>
sdu: size = 104857600<br>
sdu: vendor = DGC<br>
sdu: product = RAID 5<br>
sdu: rev = 0219<br>
sdu: h:b:t:l = 1:0:0:19<br>
sdu: tgt_node_name = 0x50060160b060189e<br>
sdu: serial = CK200050300477<br>
sdu: path checker = emc_clariion (controler setting)<br>
sdu: state = 2<br>
sdu: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdu: prio = 0<br>
sdu: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdu: uid = 3600601603d34130059c23305c612dc11 (callout)<br>
sdv: not found in pathvec<br>
sdv: mask = 0x1f<br>
sdv: bus = 1<br>
sdv: dev_t = 65:80<br>
sdv: size = 104857600<br>
sdv: vendor = DGC<br>
sdv: product = RAID 5<br>
sdv: rev = 0219<br>
sdv: h:b:t:l = 1:0:1:0<br>
sdv: tgt_node_name = 0x50060160b060189e<br>
sdv: serial = CK200050300477<br>
sdv: path checker = emc_clariion (controler setting)<br>
sdv: state = 2<br>
sdv: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdv: prio = 0<br>
sdv: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdv: uid = 360060160103413007ab51dd5c412dc11 (callout)<br>
sdw: not found in pathvec<br>
sdw: mask = 0x1f<br>
sdw: bus = 1<br>
sdw: dev_t = 65:96<br>
sdw: size = 104857600<br>
sdw: vendor = DGC<br>
sdw: product = RAID 5<br>
sdw: rev = 0219<br>
sdw: h:b:t:l = 1:0:1:1<br>
sdw: tgt_node_name = 0x50060160b060189e<br>
sdw: serial = CK200050300477<br>
sdw: path checker = emc_clariion (controler setting)<br>
sdw: state = 2<br>
sdw: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdw: prio = 1<br>
sdw: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdw: uid = 3600601603d3413000a3492f6c512dc11 (callout)<br>
sdx: not found in pathvec<br>
sdx: mask = 0x1f<br>
sdx: bus = 1<br>
sdx: dev_t = 65:112<br>
sdx: size = 104857600<br>
sdx: vendor = DGC<br>
sdx: product = RAID 5<br>
sdx: rev = 0219<br>
sdx: h:b:t:l = 1:0:1:2<br>
sdx: tgt_node_name = 0x50060160b060189e<br>
sdx: serial = CK200050300477<br>
sdx: path checker = emc_clariion (controler setting)<br>
sdx: state = 2<br>
sdx: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdx: prio = 0<br>
sdx: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdx: uid = 360060160103413007bb51dd5c412dc11 (callout)<br>
sdy: not found in pathvec<br>
sdy: mask = 0x1f<br>
sdy: bus = 1<br>
sdy: dev_t = 65:128<br>
sdy: size = 104857600<br>
sdy: vendor = DGC<br>
sdy: product = RAID 5<br>
sdy: rev = 0219<br>
sdy: h:b:t:l = 1:0:1:3<br>
sdy: tgt_node_name = 0x50060160b060189e<br>
sdy: serial = CK200050300477<br>
sdy: path checker = emc_clariion (controler setting)<br>
sdy: state = 2<br>
sdy: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdy: prio = 1<br>
sdy: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdy: uid = 3600601603d3413000b3492f6c512dc11 (callout)<br>
sdz: not found in pathvec<br>
sdz: mask = 0x1f<br>
sdz: bus = 1<br>
sdz: dev_t = 65:144<br>
sdz: size = 104857600<br>
sdz: vendor = DGC<br>
sdz: product = RAID 5<br>
sdz: rev = 0219<br>
sdz: h:b:t:l = 1:0:1:4<br>
sdz: tgt_node_name = 0x50060160b060189e<br>
sdz: serial = CK200050300477<br>
sdz: path checker = emc_clariion (controler setting)<br>
sdz: state = 2<br>
sdz: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdz: prio = 0<br>
sdz: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)<br>
sdz: uid = 360060160103413007cb51dd5c412dc11 (callout)<br>
===== paths list =====<br>
uuid&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; hcil&nbsp;&nbsp;&nbsp;&nbsp; dev&nbsp; dev_t&nbsp; pri dm_st&nbsp;
chk_st&nbsp; vend<br>
3600601603d3413000c3492f6c512dc11 1:0:1:5&nbsp; sdaa 65:160 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
36006016010341300f6eb2cdcc412dc11 1:0:1:6&nbsp; sdab 65:176 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d3413000d3492f6c512dc11 1:0:1:7&nbsp; sdac 65:192 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
36006016010341300f7eb2cdcc412dc11 1:0:1:8&nbsp; sdad 65:208 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d341300f6a2dafdc512dc11 1:0:1:9&nbsp; sdae 65:224 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
36006016010341300f8eb2cdcc412dc11 1:0:1:10 sdaf 65:240 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d341300f7a2dafdc512dc11 1:0:1:11 sdag 66:0&nbsp;&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601601034130026e740e3c412dc11 1:0:1:12 sdah 66:16&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d341300f8a2dafdc512dc11 1:0:1:13 sdai 66:32&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601601034130027e740e3c412dc11 1:0:1:14 sdaj 66:48&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d341300f9a2dafdc512dc11 1:0:1:15 sdak 66:64&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601601034130028e740e3c412dc11 1:0:1:16 sdal 66:80&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d34130058c23305c612dc11 1:0:1:17 sdam 66:96&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601601034130078a83aeac412dc11 1:0:1:18 sdan 66:112 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d34130059c23305c612dc11 1:0:1:19 sdao 66:128 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0:2:0:0&nbsp; sda&nbsp; 8:0&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;
[undef][ready] Mega<br>
360060160103413007ab51dd5c412dc11 1:0:0:0&nbsp; sdb&nbsp; 8:16&nbsp;&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d3413000a3492f6c512dc11 1:0:0:1&nbsp; sdc&nbsp; 8:32&nbsp;&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
360060160103413007bb51dd5c412dc11 1:0:0:2&nbsp; sdd&nbsp; 8:48&nbsp;&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d3413000b3492f6c512dc11 1:0:0:3&nbsp; sde&nbsp; 8:64&nbsp;&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
360060160103413007cb51dd5c412dc11 1:0:0:4&nbsp; sdf&nbsp; 8:80&nbsp;&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d3413000c3492f6c512dc11 1:0:0:5&nbsp; sdg&nbsp; 8:96&nbsp;&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
36006016010341300f6eb2cdcc412dc11 1:0:0:6&nbsp; sdh&nbsp; 8:112&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d3413000d3492f6c512dc11 1:0:0:7&nbsp; sdi&nbsp; 8:128&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
36006016010341300f7eb2cdcc412dc11 1:0:0:8&nbsp; sdj&nbsp; 8:144&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d341300f6a2dafdc512dc11 1:0:0:9&nbsp; sdk&nbsp; 8:160&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
36006016010341300f8eb2cdcc412dc11 1:0:0:10 sdl&nbsp; 8:176&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d341300f7a2dafdc512dc11 1:0:0:11 sdm&nbsp; 8:192&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601601034130026e740e3c412dc11 1:0:0:12 sdn&nbsp; 8:208&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d341300f8a2dafdc512dc11 1:0:0:13 sdo&nbsp; 8:224&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601601034130027e740e3c412dc11 1:0:0:14 sdp&nbsp; 8:240&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d341300f9a2dafdc512dc11 1:0:0:15 sdq&nbsp; 65:0&nbsp;&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601601034130028e740e3c412dc11 1:0:0:16 sdr&nbsp; 65:16&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d34130058c23305c612dc11 1:0:0:17 sds&nbsp; 65:32&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601601034130078a83aeac412dc11 1:0:0:18 sdt&nbsp; 65:48&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d34130059c23305c612dc11 1:0:0:19 sdu&nbsp; 65:64&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
360060160103413007ab51dd5c412dc11 1:0:1:0&nbsp; sdv&nbsp; 65:80&nbsp; 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d3413000a3492f6c512dc11 1:0:1:1&nbsp; sdw&nbsp; 65:96&nbsp; 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
360060160103413007bb51dd5c412dc11 1:0:1:2&nbsp; sdx&nbsp; 65:112 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
3600601603d3413000b3492f6c512dc11 1:0:1:3&nbsp; sdy&nbsp; 65:128 1&nbsp;&nbsp;
[undef][ready] DGC,<br>
360060160103413007cb51dd5c412dc11 1:0:1:4&nbsp; sdz&nbsp; 65:144 0&nbsp;&nbsp;
[undef][ready] DGC,<br>
params = 0 1 emc 2 2 round-robin 0 1 1 8:32 100 round-robin 0 1 1 65:96
100<br>
status = 1 0 0 2 2 E 0 1 0 8:32 A 0 A 0 1 0 65:96 A 0<br>
sdc: mask = 0x8<br>
sdc: prio = 0<br>
params = 0 1 emc 2 1 round-robin 0 1 1 8:48 100 round-robin 0 1 1
65:112 100<br>
status = 1 0 0 2 1 A 0 1 0 8:48 A 0 E 0 1 0 65:112 A 0<br>
sdx: mask = 0x8<br>
sdx: prio = 0<br>
params = 0 1 emc 2 1 round-robin 0 1 1 8:16 100 round-robin 0 1 1 65:80
100<br>
status = 1 0 0 2 1 A 0 1 0 8:16 A 0 E 0 1 0 65:80 A 0<br>
sdv: mask = 0x8<br>
sdv: prio = 0<br>
params = 0 1 emc 2 2 round-robin 0 1 1 8:64 100 round-robin 0 1 1
65:128 100<br>
status = 1 0 0 2 2 E 0 1 0 8:64 A 0 A 0 1 0 65:128 A 0<br>
sde: mask = 0x8<br>
sde: prio = 0<br>
params = 0 1 emc 2 2 round-robin 0 1 1 66:112 100 round-robin 0 1 1
65:48 100<br>
status = 1 0 0 2 2 E 0 1 0 66:112 A 0 A 0 1 0 65:48 A 0<br>
sdan: mask = 0x8<br>
sdan: prio = 0<br>
params = 0 1 emc 2 1 round-robin 0 1 1 66:128 100 round-robin 0 1 1
65:64 100<br>
status = 1 0 0 2 1 A 0 1 0 66:128 A 0 E 0 1 0 65:64 A 0<br>
sdu: mask = 0x8<br>
sdu: prio = 0<br>
params = 0 1 emc 2 2 round-robin 0 1 1 65:176 100 round-robin 0 1 1
8:112 100<br>
status = 1 0 0 2 2 E 0 1 0 65:176 A 0 A 0 1 0 8:112 A 0<br>
sdab: mask = 0x8<br>
sdab: prio = 0<br>
params = 0 1 emc 2 1 round-robin 0 1 1 66:64 100 round-robin 0 1 1 65:0
100<br>
status = 1 0 0 2 1 A 0 1 0 66:64 A 0 E 0 1 0 65:0 A 0<br>
sdq: mask = 0x8<br>
sdq: prio = 0<br>
params = 0 1 emc 2 1 round-robin 0 1 1 66:0 100 round-robin 0 1 1 8:192
100<br>
status = 1 0 0 2 1 A 0 1 0 66:0 A 0 E 0 1 0 8:192 A 0<br>
sdm: mask = 0x8<br>
sdm: prio = 0<br>
params = 0 1 emc 2 2 round-robin 0 1 1 66:80 100 round-robin 0 1 1
65:16 100<br>
status = 1 0 0 2 2 E 0 1 0 66:80 A 0 A 0 1 0 65:16 A 0<br>
sdal: mask = 0x8<br>
sdal: prio = 0<br>
params = 0 1 emc 2 1 round-robin 0 1 1 65:224 100 round-robin 0 1 1
8:160 100<br>
status = 1 0 0 2 1 A 0 1 0 65:224 A 0 E 0 1 0 8:160 A 0<br>
sdk: mask = 0x8<br>
sdk: prio = 0<br>
params = 0 1 emc 2 2 round-robin 0 1 1 66:48 100 round-robin 0 1 1
8:240 100<br>
status = 1 0 0 2 2 E 0 1 0 66:48 A 0 A 0 1 0 8:240 A 0<br>
sdaj: mask = 0x8<br>
sdaj: prio = 0<br>
params = 0 1 emc 2 1 round-robin 0 1 1 65:160 100 round-robin 0 1 1
8:96 100<br>
status = 1 0 0 2 1 A 0 1 0 65:160 A 0 E 0 1 0 8:96 A 0<br>
sdg: mask = 0x8<br>
sdg: prio = 0<br>
params = 0 1 emc 2 1 round-robin 0 1 1 66:32 100 round-robin 0 1 1
8:224 100<br>
status = 1 0 0 2 1 A 0 1 0 66:32 A 0 E 0 1 0 8:224 A 0<br>
sdo: mask = 0x8<br>
sdo: prio = 0<br>
params = 0 1 emc 2 2 round-robin 0 1 1 65:208 100 round-robin 0 1 1
8:144 100<br>
status = 1 0 0 2 2 E 0 1 0 65:208 A 0 A 0 1 0 8:144 A 0<br>
sdad: mask = 0x8<br>
sdad: prio = 0<br>
params = 0 1 emc 2 2 round-robin 0 1 1 66:16 100 round-robin 0 1 1
8:208 100<br>
status = 1 0 0 2 2 E 0 1 0 66:16 A 0 A 0 1 0 8:208 A 0<br>
sdah: mask = 0x8<br>
sdah: prio = 0<br>
params = 0 1 emc 2 1 round-robin 0 1 1 65:192 100 round-robin 0 1 1
8:128 100<br>
status = 1 0 0 2 1 A 0 1 0 65:192 A 0 E 0 1 0 8:128 A 0<br>
sdi: mask = 0x8<br>
sdi: prio = 0<br>
params = 0 1 emc 2 2 round-robin 0 1 1 65:240 100 round-robin 0 1 1
8:176 100<br>
status = 1 0 0 2 2 E 0 1 0 65:240 A 0 A 0 1 0 8:176 A 0<br>
sdaf: mask = 0x8<br>
sdaf: prio = 0<br>
params = 0 1 emc 2 1 round-robin 0 1 1 8:80 100 round-robin 0 1 1
65:144 100<br>
status = 1 0 0 2 1 A 0 1 0 8:80 A 0 E 0 1 0 65:144 A 0<br>
sdz: mask = 0x8<br>
sdz: prio = 0<br>
Found matching wwid [3600601603d3413000c3492f6c512dc11] in bindings
file.<br>
Setting alias to mpath6<br>
sdaa: ownership set to mpath6<br>
sdaa: not found in pathvec<br>
sdaa: mask = 0xc<br>
sdaa: state = 2<br>
sdaa: prio = 1<br>
sdg: ownership set to mpath6<br>
sdg: not found in pathvec<br>
sdg: mask = 0xc<br>
sdg: state = 2<br>
sdg: prio = 0<br>
mpath6: pgfailback = -2 (controler setting)<br>
mpath6: pgpolicy = failover (controler setting)<br>
mpath6: selector = round-robin 0 (internal default)<br>
mpath6: features = 0 (controler setting)<br>
mpath6: hwhandler = 1 emc (controler setting)<br>
mpath6: rr_weight = 2 (config file default)<br>
mpath6: minio = 100 (config file default)<br>
mpath6: no_path_retry = -1 (config file default)<br>
pg_timeout = NONE (internal default)<br>
mpath6: set ACT_NOTHING (map unchanged)<br>
Found matching wwid [36006016010341300f6eb2cdcc412dc11] in bindings
file.<br>
Setting alias to mpath9<br>
sdab: ownership set to mpath9<br>
sdab: not found in pathvec<br>
sdab: mask = 0xc<br>
sdab: state = 2<br>
sdab: prio = 0<br>
sdh: ownership set to mpath9<br>
sdh: not found in pathvec<br>
sdh: mask = 0xc<br>
sdh: state = 2<br>
sdh: prio = 1<br>
mpath9: pgfailback = -2 (controler setting)<br>
mpath9: pgpolicy = failover (controler setting)<br>
mpath9: selector = round-robin 0 (internal default)<br>
mpath9: features = 0 (controler setting)<br>
mpath9: hwhandler = 1 emc (controler setting)<br>
mpath9: rr_weight = 2 (config file default)<br>
mpath9: minio = 100 (config file default)<br>
mpath9: no_path_retry = -1 (config file default)<br>
pg_timeout = NONE (internal default)<br>
mpath9: set ACT_NOTHING (map unchanged)<br>
Found matching wwid [3600601603d3413000d3492f6c512dc11] in bindings
file.<br>
Setting alias to mpath4<br>
sdac: ownership set to mpath4<br>
sdac: not found in pathvec<br>
sdac: mask = 0xc<br>
sdac: state = 2<br>
sdac: prio = 1<br>
sdi: ownership set to mpath4<br>
sdi: not found in pathvec<br>
sdi: mask = 0xc<br>
sdi: state = 2<br>
sdi: prio = 0<br>
mpath4: pgfailback = -2 (controler setting)<br>
mpath4: pgpolicy = failover (controler setting)<br>
mpath4: selector = round-robin 0 (internal default)<br>
mpath4: features = 0 (controler setting)<br>
mpath4: hwhandler = 1 emc (controler setting)<br>
mpath4: rr_weight = 2 (config file default)<br>
mpath4: minio = 100 (config file default)<br>
mpath4: no_path_retry = -1 (config file default)<br>
pg_timeout = NONE (internal default)<br>
mpath4: set ACT_NOTHING (map unchanged)<br>
Found matching wwid [36006016010341300f7eb2cdcc412dc11] in bindings
file.<br>
Setting alias to mpath5<br>
sdad: ownership set to mpath5<br>
sdad: not found in pathvec<br>
sdad: mask = 0xc<br>
sdad: state = 2<br>
sdad: prio = 0<br>
sdj: ownership set to mpath5<br>
sdj: not found in pathvec<br>
sdj: mask = 0xc<br>
sdj: state = 2<br>
sdj: prio = 1<br>
mpath5: pgfailback = -2 (controler setting)<br>
mpath5: pgpolicy = failover (controler setting)<br>
mpath5: selector = round-robin 0 (internal default)<br>
mpath5: features = 0 (controler setting)<br>
mpath5: hwhandler = 1 emc (controler setting)<br>
mpath5: rr_weight = 2 (config file default)<br>
mpath5: minio = 100 (config file default)<br>
mpath5: no_path_retry = -1 (config file default)<br>
pg_timeout = NONE (internal default)<br>
mpath5: set ACT_NOTHING (map unchanged)<br>
Found matching wwid [3600601603d341300f6a2dafdc512dc11] in bindings
file.<br>
Setting alias to mpath7<br>
sdae: ownership set to mpath7<br>
sdae: not found in pathvec<br>
sdae: mask = 0xc<br>
sdae: state = 2<br>
sdae: prio = 1<br>
sdk: ownership set to mpath7<br>
sdk: not found in pathvec<br>
sdk: mask = 0xc<br>
sdk: state = 2<br>
sdk: prio = 0<br>
mpath7: pgfailback = -2 (controler setting)<br>
mpath7: pgpolicy = failover (controler setting)<br>
mpath7: selector = round-robin 0 (internal default)<br>
mpath7: features = 0 (controler setting)<br>
mpath7: hwhandler = 1 emc (controler setting)<br>
mpath7: rr_weight = 2 (config file default)<br>
mpath7: minio = 100 (config file default)<br>
mpath7: no_path_retry = -1 (config file default)<br>
pg_timeout = NONE (internal default)<br>
mpath7: set ACT_NOTHING (map unchanged)<br>
Found matching wwid [36006016010341300f8eb2cdcc412dc11] in bindings
file.<br>
Setting alias to mpath10<br>
sdaf: ownership set to mpath10<br>
sdaf: not found in pathvec<br>
sdaf: mask = 0xc<br>
sdaf: state = 2<br>
sdaf: prio = 0<br>
sdl: ownership set to mpath10<br>
sdl: not found in pathvec<br>
sdl: mask = 0xc<br>
sdl: state = 2<br>
sdl: prio = 1<br>
mpath10: pgfailback = -2 (controler setting)<br>
mpath10: pgpolicy = failover (controler setting)<br>
mpath10: selector = round-robin 0 (internal default)<br>
mpath10: features = 0 (controler setting)<br>
mpath10: hwhandler = 1 emc (controler setting)<br>
mpath10: rr_weight = 2 (config file default)<br>
mpath10: minio = 100 (config file default)<br>
mpath10: no_path_retry = -1 (config file default)<br>
pg_timeout = NONE (internal default)<br>
mpath10: set ACT_NOTHING (map unchanged)<br>
Found matching wwid [3600601603d341300f7a2dafdc512dc11] in bindings
file.<br>
Setting alias to mpath8<br>
sdag: ownership set to mpath8<br>
sdag: not found in pathvec<br>
sdag: mask = 0xc<br>
sdag: state = 2<br>
sdag: prio = 1<br>
sdm: ownership set to mpath8<br>
sdm: not found in pathvec<br>
sdm: mask = 0xc<br>
sdm: state = 2<br>
sdm: prio = 0<br>
mpath8: pgfailback = -2 (controler setting)<br>
mpath8: pgpolicy = failover (controler setting)<br>
mpath8: selector = round-robin 0 (internal default)<br>
mpath8: features = 0 (controler setting)<br>
mpath8: hwhandler = 1 emc (controler setting)<br>
mpath8: rr_weight = 2 (config file default)<br>
mpath8: minio = 100 (config file default)<br>
mpath8: no_path_retry = -1 (config file default)<br>
pg_timeout = NONE (internal default)<br>
mpath8: set ACT_NOTHING (map unchanged)<br>
Found matching wwid [3600601601034130026e740e3c412dc11] in bindings
file.<br>
Setting alias to mpath11<br>
sdah: ownership set to mpath11<br>
sdah: not found in pathvec<br>
sdah: mask = 0xc<br>
sdah: state = 2<br>
sdah: prio = 0<br>
sdn: ownership set to mpath11<br>
sdn: not found in pathvec<br>
sdn: mask = 0xc<br>
sdn: state = 2<br>
sdn: prio = 1<br>
mpath11: pgfailback = -2 (controler setting)<br>
mpath11: pgpolicy = failover (controler setting)<br>
mpath11: selector = round-robin 0 (internal default)<br>
mpath11: features = 0 (controler setting)<br>
mpath11: hwhandler = 1 emc (controler setting)<br>
mpath11: rr_weight = 2 (config file default)<br>
mpath11: minio = 100 (config file default)<br>
mpath11: no_path_retry = -1 (config file default)<br>
pg_timeout = NONE (internal default)<br>
mpath11: set ACT_NOTHING (map unchanged)<br>
Found matching wwid [3600601603d341300f8a2dafdc512dc11] in bindings
file.<br>
Setting alias to mpath12<br>
sdai: ownership set to mpath12<br>
sdai: not found in pathvec<br>
sdai: mask = 0xc<br>
sdai: state = 2<br>
sdai: prio = 1<br>
sdo: ownership set to mpath12<br>
sdo: not found in pathvec<br>
sdo: mask = 0xc<br>
sdo: state = 2<br>
sdo: prio = 0<br>
mpath12: pgfailback = -2 (controler setting)<br>
mpath12: pgpolicy = failover (controler setting)<br>
mpath12: selector = round-robin 0 (internal default)<br>
mpath12: features = 0 (controler setting)<br>
mpath12: hwhandler = 1 emc (controler setting)<br>
mpath12: rr_weight = 2 (config file default)<br>
mpath12: minio = 100 (config file default)<br>
mpath12: no_path_retry = -1 (config file default)<br>
pg_timeout = NONE (internal default)<br>
mpath12: set ACT_NOTHING (map unchanged)<br>
Found matching wwid [3600601601034130027e740e3c412dc11] in bindings
file.<br>
Setting alias to mpath13<br>
sdaj: ownership set to mpath13<br>
sdaj: not found in pathvec<br>
sdaj: mask = 0xc<br>
sdaj: state = 2<br>
sdaj: prio = 0<br>
sdp: ownership set to mpath13<br>
sdp: not found in pathvec<br>
sdp: mask = 0xc<br>
sdp: state = 2<br>
sdp: prio = 1<br>
mpath13: pgfailback = -2 (controler setting)<br>
mpath13: pgpolicy = failover (controler setting)<br>
mpath13: selector = round-robin 0 (internal default)<br>
mpath13: features = 0 (controler setting)<br>
mpath13: hwhandler = 1 emc (controler setting)<br>
mpath13: rr_weight = 2 (config file default)<br>
mpath13: minio = 100 (config file default)<br>
mpath13: no_path_retry = -1 (config file default)<br>
pg_timeout = NONE (internal default)<br>
mpath13: set ACT_NOTHING (map unchanged)<br>
Found matching wwid [3600601603d341300f9a2dafdc512dc11] in bindings
file.<br>
Setting alias to mpath15<br>
sdak: ownership set to mpath15<br>
sdak: not found in pathvec<br>
sdak: mask = 0xc<br>
sdak: state = 2<br>
sdak: prio = 1<br>
sdq: ownership set to mpath15<br>
sdq: not found in pathvec<br>
sdq: mask = 0xc<br>
sdq: state = 2<br>
sdq: prio = 0<br>
mpath15: pgfailback = -2 (controler setting)<br>
mpath15: pgpolicy = failover (controler setting)<br>
mpath15: selector = round-robin 0 (internal default)<br>
mpath15: features = 0 (controler setting)<br>
mpath15: hwhandler = 1 emc (controler setting)<br>
mpath15: rr_weight = 2 (config file default)<br>
mpath15: minio = 100 (config file default)<br>
mpath15: no_path_retry = -1 (config file default)<br>
pg_timeout = NONE (internal default)<br>
mpath15: set ACT_NOTHING (map unchanged)<br>
Found matching wwid [3600601601034130028e740e3c412dc11] in bindings
file.<br>
Setting alias to mpath14<br>
sdal: ownership set to mpath14<br>
sdal: not found in pathvec<br>
sdal: mask = 0xc<br>
sdal: state = 2<br>
sdal: prio = 0<br>
sdr: ownership set to mpath14<br>
sdr: not found in pathvec<br>
sdr: mask = 0xc<br>
sdr: state = 2<br>
sdr: prio = 1<br>
mpath14: pgfailback = -2 (controler setting)<br>
mpath14: pgpolicy = failover (controler setting)<br>
mpath14: selector = round-robin 0 (internal default)<br>
mpath14: features = 0 (controler setting)<br>
mpath14: hwhandler = 1 emc (controler setting)<br>
mpath14: rr_weight = 2 (config file default)<br>
mpath14: minio = 100 (config file default)<br>
mpath14: no_path_retry = -1 (config file default)<br>
pg_timeout = NONE (internal default)<br>
mpath14: set ACT_NOTHING (map unchanged)<br>
Found matching wwid [3600601603d34130058c23305c612dc11] in bindings
file.<br>
Setting alias to mpath17<br>
sdam: ownership set to mpath17<br>
sdam: not found in pathvec<br>
sdam: mask = 0xc<br>
sdam: state = 2<br>
sdam: prio = 1<br>
sds: ownership set to mpath17<br>
sds: not found in pathvec<br>
sds: mask = 0xc<br>
sds: state = 2<br>
sds: prio = 0<br>
mpath17: pgfailback = -2 (controler setting)<br>
mpath17: pgpolicy = failover (controler setting)<br>
mpath17: selector = round-robin 0 (internal default)<br>
mpath17: features = 0 (controler setting)<br>
mpath17: hwhandler = 1 emc (controler setting)<br>
mpath17: rr_weight = 2 (config file default)<br>
mpath17: minio = 100 (config file default)<br>
mpath17: no_path_retry = -1 (config file default)<br>
pg_timeout = NONE (internal default)<br>
mpath17: remove (wwid changed)<br>
mpath17: set ACT_CREATE (map wwid change)<br>
create: mpath17 (3600601603d34130058c23305c612dc11)&nbsp; DGC,RAID 5<br>
[size=50G][features=0][hwhandler=1 emc]<br>
\_ round-robin 0 [prio=1][undef]<br>
&nbsp;\_ 1:0:1:17 sdam 66:96&nbsp; [undef][ready]<br>
\_ round-robin 0 [prio=0][undef]<br>
&nbsp;\_ 1:0:0:17 sds&nbsp; 65:32&nbsp; [undef][ready]<br>
Found matching wwid [3600601601034130078a83aeac412dc11] in bindings
file.<br>
Setting alias to mpath17<br>
sdan: ownership set to mpath17<br>
sdan: not found in pathvec<br>
sdan: mask = 0xc<br>
sdan: state = 2<br>
sdan: prio = 0<br>
sdt: ownership set to mpath17<br>
sdt: not found in pathvec<br>
sdt: mask = 0xc<br>
sdt: state = 2<br>
sdt: prio = 1<br>
mpath17: pgfailback = -2 (controler setting)<br>
mpath17: pgpolicy = failover (controler setting)<br>
mpath17: selector = round-robin 0 (internal default)<br>
mpath17: features = 0 (controler setting)<br>
mpath17: hwhandler = 1 emc (controler setting)<br>
mpath17: rr_weight = 2 (config file default)<br>
mpath17: minio = 100 (config file default)<br>
mpath17: no_path_retry = -1 (config file default)<br>
pg_timeout = NONE (internal default)<br>
mpath17: set ACT_CREATE (map does not exist)<br>
mpath17: domap (0) failure for create/reload map<br>
Found matching wwid [3600601603d34130059c23305c612dc11] in bindings
file.<br>
Setting alias to mpath16<br>
sdao: ownership set to mpath16<br>
sdao: not found in pathvec<br>
sdao: mask = 0xc<br>
sdao: state = 2<br>
sdao: prio = 1<br>
sdu: ownership set to mpath16<br>
sdu: not found in pathvec<br>
sdu: mask = 0xc<br>
sdu: state = 2<br>
sdu: prio = 0<br>
mpath16: pgfailback = -2 (controler setting)<br>
mpath16: pgpolicy = failover (controler setting)<br>
mpath16: selector = round-robin 0 (internal default)<br>
mpath16: features = 0 (controler setting)<br>
mpath16: hwhandler = 1 emc (controler setting)<br>
mpath16: rr_weight = 2 (config file default)<br>
mpath16: minio = 100 (config file default)<br>
mpath16: no_path_retry = -1 (config file default)<br>
pg_timeout = NONE (internal default)<br>
mpath16: set ACT_NOTHING (map unchanged)<br>
Found matching wwid [360060160103413007ab51dd5c412dc11] in bindings
file.<br>
Setting alias to mpath0<br>
sdb: ownership set to mpath0<br>
sdb: not found in pathvec<br>
sdb: mask = 0xc<br>
sdb: state = 2<br>
sdb: prio = 1<br>
sdv: ownership set to mpath0<br>
sdv: not found in pathvec<br>
sdv: mask = 0xc<br>
sdv: state = 2<br>
sdv: prio = 0<br>
mpath0: pgfailback = -2 (controler setting)<br>
mpath0: pgpolicy = failover (controler setting)<br>
mpath0: selector = round-robin 0 (internal default)<br>
mpath0: features = 0 (controler setting)<br>
mpath0: hwhandler = 1 emc (controler setting)<br>
mpath0: rr_weight = 2 (config file default)<br>
mpath0: minio = 100 (config file default)<br>
mpath0: no_path_retry = -1 (config file default)<br>
pg_timeout = NONE (internal default)<br>
mpath0: set ACT_NOTHING (map unchanged)<br>
Found matching wwid [3600601603d3413000a3492f6c512dc11] in bindings
file.<br>
Setting alias to mpath2<br>
sdc: ownership set to mpath2<br>
sdc: not found in pathvec<br>
sdc: mask = 0xc<br>
sdc: state = 2<br>
sdc: prio = 0<br>
sdw: ownership set to mpath2<br>
sdw: not found in pathvec<br>
sdw: mask = 0xc<br>
sdw: state = 2<br>
sdw: prio = 1<br>
mpath2: pgfailback = -2 (controler setting)<br>
mpath2: pgpolicy = failover (controler setting)<br>
mpath2: selector = round-robin 0 (internal default)<br>
mpath2: features = 0 (controler setting)<br>
mpath2: hwhandler = 1 emc (controler setting)<br>
mpath2: rr_weight = 2 (config file default)<br>
mpath2: minio = 100 (config file default)<br>
mpath2: no_path_retry = -1 (config file default)<br>
pg_timeout = NONE (internal default)<br>
mpath2: set ACT_NOTHING (map unchanged)<br>
Found matching wwid [360060160103413007bb51dd5c412dc11] in bindings
file.<br>
Setting alias to mpath1<br>
sdd: ownership set to mpath1<br>
sdd: not found in pathvec<br>
sdd: mask = 0xc<br>
sdd: state = 2<br>
sdd: prio = 1<br>
sdx: ownership set to mpath1<br>
sdx: not found in pathvec<br>
sdx: mask = 0xc<br>
sdx: state = 2<br>
sdx: prio = 0<br>
mpath1: pgfailback = -2 (controler setting)<br>
mpath1: pgpolicy = failover (controler setting)<br>
mpath1: selector = round-robin 0 (internal default)<br>
mpath1: features = 0 (controler setting)<br>
mpath1: hwhandler = 1 emc (controler setting)<br>
mpath1: rr_weight = 2 (config file default)<br>
mpath1: minio = 100 (config file default)<br>
mpath1: no_path_retry = -1 (config file default)<br>
pg_timeout = NONE (internal default)<br>
mpath1: set ACT_NOTHING (map unchanged)<br>
Found matching wwid [3600601603d3413000b3492f6c512dc11] in bindings
file.<br>
Setting alias to mpath18<br>
sde: ownership set to mpath18<br>
sde: not found in pathvec<br>
sde: mask = 0xc<br>
sde: state = 2<br>
sde: prio = 0<br>
sdy: ownership set to mpath18<br>
sdy: not found in pathvec<br>
sdy: mask = 0xc<br>
sdy: state = 2<br>
sdy: prio = 1<br>
mpath18: pgfailback = -2 (controler setting)<br>
mpath18: pgpolicy = failover (controler setting)<br>
mpath18: selector = round-robin 0 (internal default)<br>
mpath18: features = 0 (controler setting)<br>
mpath18: hwhandler = 1 emc (controler setting)<br>
mpath18: rr_weight = 2 (config file default)<br>
mpath18: minio = 100 (config file default)<br>
mpath18: no_path_retry = -1 (config file default)<br>
pg_timeout = NONE (internal default)<br>
mpath18: set ACT_NOTHING (map unchanged)<br>
Found matching wwid [360060160103413007cb51dd5c412dc11] in bindings
file.<br>
Setting alias to mpath3<br>
sdf: ownership set to mpath3<br>
sdf: not found in pathvec<br>
sdf: mask = 0xc<br>
sdf: state = 2<br>
sdf: prio = 1<br>
sdz: ownership set to mpath3<br>
sdz: not found in pathvec<br>
sdz: mask = 0xc<br>
sdz: state = 2<br>
sdz: prio = 0<br>
mpath3: pgfailback = -2 (controler setting)<br>
mpath3: pgpolicy = failover (controler setting)<br>
mpath3: selector = round-robin 0 (internal default)<br>
mpath3: features = 0 (controler setting)<br>
mpath3: hwhandler = 1 emc (controler setting)<br>
mpath3: rr_weight = 2 (config file default)<br>
mpath3: minio = 100 (config file default)<br>
mpath3: no_path_retry = -1 (config file default)<br>
pg_timeout = NONE (internal default)<br>
mpath3: set ACT_NOTHING (map unchanged)<br>
Found matching wwid [3600601601034130078a83aeac412dc11] in bindings
file.<br>
Setting alias to mpath17<br>
sdan: ownership set to mpath17<br>
sdan: not found in pathvec<br>
sdan: mask = 0xc<br>
sdan: path checker = emc_clariion (controler setting)<br>
sdan: state = 2<br>
sdan: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdan: prio = 0<br>
sdt: ownership set to mpath17<br>
sdt: not found in pathvec<br>
sdt: mask = 0xc<br>
sdt: path checker = emc_clariion (controler setting)<br>
sdt: state = 2<br>
sdt: getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)<br>
sdt: prio = 1<br>
<b>mpath17: pgfailback = -2 (controler setting)<br>
mpath17: pgpolicy = failover (controler setting)<br>
mpath17: selector = round-robin 0 (internal default)<br>
mpath17: features = 0 (controler setting)<br>
mpath17: hwhandler = 1 emc (controler setting)<br>
mpath17: rr_weight = 2 (config file default)<br>
mpath17: minio = 100 (config file default)<br>
mpath17: no_path_retry = -1 (config file default)<br>
pg_timeout = NONE (internal default)<br>
mpath17: set ACT_CREATE (map does not exist)<br>
mpath17: domap (0) failure for create/reload map<br>
</b><b><br>
</b>
</body>
</html>

--------------090006000104030108010704--

--------------ms080203070304050209040507
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJHzCC
AuowggJToAMCAQICEAL1rL60pB7Fe/iJ8wYRAD4wDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA2MDgxODEyMTg0MVoX
DTA3MDgxODEyMTg0MVowSjEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEnMCUG
CSqGSIb3DQEJARYYY2xhdWRpb0BjM3N5c3RlbXMuY29tLmJyMIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEAr92EBJKzlnXexKFNA53hlgNoDkXQWxzKSETWpWWcHllzZSCvXGcH
j4zNp37Yrs2+/L1Kq3a1uscmL+U1khBfyQJ8AE4JHVo99YQve2bARGV07sZ9PA8F1sT2xgZ5
IH3bmOpZvD3Q+wiynS5Hp7zUqe25sI/187yBUN1tgg/jQPqBOYMHUB01sSET1rdf0G7SA2HT
ZmkbpofvEQOpupPn1Vj2oKhWt9vmuoyUME0wt9B9Da2+gVTH6GNfW5rKfT9F7LU10doYxpXO
2q+iLRxBh8YBBUu5oGtWVP35aHBcMO2BMAEXf8e+PrGuPNfJy6mEiWk1jrds0xn+ZGLbJjWf
KwIDAQABozUwMzAjBgNVHREEHDAagRhjbGF1ZGlvQGMzc3lzdGVtcy5jb20uYnIwDAYDVR0T
AQH/BAIwADANBgkqhkiG9w0BAQUFAAOBgQBUnhlowHLgGtqOk44x6gnSgts2/DBTwvCAQwBN
PZ9QRrWhxfvZhiPd+QtxuQc7Ccz3IUdA3m3WzazTP5rdHG0IPQ55lNpXhCxFU4S0U6Qb1LKy
0CS+023Ei+HQK3ZKcc5qb6HVJwydtq6VWnvmv0EUsoRW7Iu+tDBN1L6tASwG/zCCAuowggJT
oAMCAQICEAL1rL60pB7Fe/iJ8wYRAD4wDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0
ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA2MDgxODEyMTg0MVoXDTA3MDgx
ODEyMTg0MVowSjEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEnMCUGCSqGSIb3
DQEJARYYY2xhdWRpb0BjM3N5c3RlbXMuY29tLmJyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAr92EBJKzlnXexKFNA53hlgNoDkXQWxzKSETWpWWcHllzZSCvXGcHj4zNp37Y
rs2+/L1Kq3a1uscmL+U1khBfyQJ8AE4JHVo99YQve2bARGV07sZ9PA8F1sT2xgZ5IH3bmOpZ
vD3Q+wiynS5Hp7zUqe25sI/187yBUN1tgg/jQPqBOYMHUB01sSET1rdf0G7SA2HTZmkbpofv
EQOpupPn1Vj2oKhWt9vmuoyUME0wt9B9Da2+gVTH6GNfW5rKfT9F7LU10doYxpXO2q+iLRxB
h8YBBUu5oGtWVP35aHBcMO2BMAEXf8e+PrGuPNfJy6mEiWk1jrds0xn+ZGLbJjWfKwIDAQAB
ozUwMzAjBgNVHREEHDAagRhjbGF1ZGlvQGMzc3lzdGVtcy5jb20uYnIwDAYDVR0TAQH/BAIw
ADANBgkqhkiG9w0BAQUFAAOBgQBUnhlowHLgGtqOk44x6gnSgts2/DBTwvCAQwBNPZ9QRrWh
xfvZhiPd+QtxuQc7Ccz3IUdA3m3WzazTP5rdHG0IPQ55lNpXhCxFU4S0U6Qb1LKy0CS+023E
i+HQK3ZKcc5qb6HVJwydtq6VWnvmv0EUsoRW7Iu+tDBN1L6tASwG/zCCAz8wggKooAMCAQIC
AQ0wDQYJKoZIhvcNAQEFBQAwgdExCzAJBgNVBAYTAlpBMRUwEwYDVQQIEwxXZXN0ZXJuIENh
cGUxEjAQBgNVBAcTCUNhcGUgVG93bjEaMBgGA1UEChMRVGhhd3RlIENvbnN1bHRpbmcxKDAm
BgNVBAsTH0NlcnRpZmljYXRpb24gU2VydmljZXMgRGl2aXNpb24xJDAiBgNVBAMTG1RoYXd0
ZSBQZXJzb25hbCBGcmVlbWFpbCBDQTErMCkGCSqGSIb3DQEJARYccGVyc29uYWwtZnJlZW1h
aWxAdGhhd3RlLmNvbTAeFw0wMzA3MTcwMDAwMDBaFw0xMzA3MTYyMzU5NTlaMGIxCzAJBgNV
BAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQD
EyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBDQTCBnzANBgkqhkiG9w0BAQEF
AAOBjQAwgYkCgYEAxKY8VXNV+065yplaHmjAdQRwnd/p/6Me7L3N9VvyGna9fww6YfK/Uc4B
1OVQCjDXAmNaLIkVcI7dyfArhVqqP3FWy688Cwfn8R+RNiQqE88r1fOCdz0Dviv+uxg+B79A
gAJk16emu59l0cUqVIUPSAR/p7bRPGEEQB5kGXJgt/sCAwEAAaOBlDCBkTASBgNVHRMBAf8E
CDAGAQH/AgEAMEMGA1UdHwQ8MDowOKA2oDSGMmh0dHA6Ly9jcmwudGhhd3RlLmNvbS9UaGF3
dGVQZXJzb25hbEZyZWVtYWlsQ0EuY3JsMAsGA1UdDwQEAwIBBjApBgNVHREEIjAgpB4wHDEa
MBgGA1UEAxMRUHJpdmF0ZUxhYmVsMi0xMzgwDQYJKoZIhvcNAQEFBQADgYEASIzRUIPqCy7M
DaNmrGcPf6+svsIXoUOWlJ1/TCG4+DYfqi2fNi/A9BxQIJNwPP2t4WFiw9k6GX6EsZkbAMUa
C4J0niVQlGLH2ydxVyWN3amcOY6MIE9lX5Xa9/eH1sYITq726jTlEBpbNU1341YheILcIRk1
3iSx0x1G/11fZU8xggNkMIIDYAIBATB2MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3
dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJl
ZW1haWwgSXNzdWluZyBDQQIQAvWsvrSkHsV7+InzBhEAPjAJBgUrDgMCGgUAoIIBwzAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0wNzA2MDYxNjQxMDVaMCMG
CSqGSIb3DQEJBDEWBBSkMVt2xgD+AbxwNEqAfWQGz9FhVjBSBgkqhkiG9w0BCQ8xRTBDMAoG
CCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDCBhQYJKwYBBAGCNxAEMXgwdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMc
VGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFs
IEZyZWVtYWlsIElzc3VpbmcgQ0ECEAL1rL60pB7Fe/iJ8wYRAD4wgYcGCyqGSIb3DQEJEAIL
MXigdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkg
THRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECEAL1
rL60pB7Fe/iJ8wYRAD4wDQYJKoZIhvcNAQEBBQAEggEAmTqg4lOyX4ifzXbTLWa55/GryJ5C
9e/1hyYbM994ck445R9n7T23Ew6lN9gkY2cz3B4AAO83MbkbbbDrpFAOI/jX3Esx/FQNmGNE
6aH5/weNOHyLyKy6ME1MjWd6LEQiKkEQvEJu9awRWSO1y7TXOlT7sS1Q6sLb09h+iUAKAz/0
kG2lrIxTPfea62dqYsHE7beOwlsD6hfY8VpAlNBHdzn1bAkoAwu+abZq3W1jmqci0TbfNZqv
yIxODtGcq8svFS0JOD8pRjG9QalEUyU7fvqdaKno+s62XQiMGj5nC0EoWtgrvM8ET2nO/mqw
TfLrPHJaujS4QmuPuHPG1M3OIQAAAAAAAA==
--------------ms080203070304050209040507--


--===============1660612530==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1660612530==--
