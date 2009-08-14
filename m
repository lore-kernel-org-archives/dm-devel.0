From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: rdac path failure - Sun 6140
Date: Thu, 13 Aug 2009 18:05:55 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474B79EF1@cosmail01.lsi.com>
References: <f7500f4e0908131150r54b21a0dr9cb7d4a8456e69e8@mail.gmail.com>
	<E463DF2B2E584B4A82673F53D62C2EF474AEB7FC@cosmail01.lsi.com>
	<f7500f4e0908131327x442a5ddfkc6e2aef58cf5bbfc@mail.gmail.com>
	<f7500f4e0908131334u39831f68i2eeccc77953ba786@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_004_E463DF2B2E584B4A82673F53D62C2EF474B79EF1cosmail01lsicom_"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f7500f4e0908131334u39831f68i2eeccc77953ba786@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Stewart Smith <stew@cleepdar.com>
List-Id: dm-devel.ids

--_004_E463DF2B2E584B4A82673F53D62C2EF474B79EF1cosmail01lsicom_
Content-Type: multipart/alternative;
	boundary="_000_E463DF2B2E584B4A82673F53D62C2EF474B79EF1cosmail01lsicom_"

--_000_E463DF2B2E584B4A82673F53D62C2EF474B79EF1cosmail01lsicom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Stew,
     I don't see much information about this failure in the logs. Right now=
 device handlers don't provide much information on failures.  We are workin=
g on to add some more debug levels.  I am attaching my draft code (scsi_dh_=
rdac.c) here.  Please use this only for your testing. It is not been approv=
ed/reviewed yet. I still need to submit this one to community for approval.=
 The code is attached.  Please replace this file with scsi_dh_rdac.c in the=
 directory /driver/scsi/device_handlers and rebuild the kernel.  This shoul=
d give more information from the target point of view. Please send me the /=
var/log/messages file after the failure. Let see if we can get more informa=
tion..

Thanks
Babu Moger
________________________________
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On B=
ehalf Of Stewart Smith
Sent: Thursday, August 13, 2009 3:35 PM
To: device-mapper development
Subject: Re: [dm-devel] rdac path failure - Sun 6140


Same sequence of events, with multipathd -v3

Aug 13 16:28:48.627  kernel: device-mapper: multipath: Failing path 8:208.
Aug 13 16:28:48.000  multipathd: vol1: rr_weight =3D 2 (LUN setting)
Aug 13 16:28:48.000  multipathd: vol1: pgfailback =3D -2 (controller settin=
g)
Aug 13 16:28:48.000  multipathd: pg_timeout =3D NONE (internal default)
Aug 13 16:28:48.000  multipathd: 8:208: mark as failed
Aug 13 16:28:48.000  multipathd: uevent 'change' from '/devices/virtual/blo=
ck/dm-1'
Aug 13 16:28:48.000  multipathd: UDEV_LOG=3D3
Aug 13 16:28:48.000  multipathd: ACTION=3Dchange
Aug 13 16:28:48.000  multipathd: DEVPATH=3D/devices/virtual/block/dm-1
Aug 13 16:28:48.000  multipathd: SUBSYSTEM=3Dblock
Aug 13 16:28:48.000  multipathd: DM_TARGET=3Dmultipath
Aug 13 16:28:48.000  multipathd: DM_ACTION=3DPATH_FAILED
Aug 13 16:28:48.000  multipathd: DM_SEQNUM=3D1
Aug 13 16:28:48.000  multipathd: DM_PATH=3D8:208
Aug 13 16:28:48.000  multipathd: DM_NR_VALID_PATHS=3D3
Aug 13 16:28:48.000  multipathd: DM_NAME=3Dvol1
Aug 13 16:28:48.000  multipathd: DM_UUID=3Dmpath-3600a0b800048335200001e5d4=
8b68a9b
Aug 13 16:28:48.000  multipathd: MAJOR=3D253
Aug 13 16:28:48.000  multipathd: MINOR=3D1
Aug 13 16:28:48.000  multipathd: DEVTYPE=3Ddisk
Aug 13 16:28:48.000  multipathd: SEQNUM=3D1738
Aug 13 16:28:48.000  multipathd: UDEVD_EVENT=3D1
Aug 13 16:28:48.000  multipathd: DEVNAME=3D/dev/dm-1
Aug 13 16:28:50.000  multipathd: 8:208: reinstated
Aug 13 16:28:50.000  multipathd: vol1: remaining active paths: 4
Aug 13 16:28:50.000  multipathd: sdj: rdac prio =3D 3
Aug 13 16:28:50.000  multipathd: sdn: rdac prio =3D 3
Aug 13 16:28:50.000  multipathd: sdb: rdac prio =3D 0
Aug 13 16:28:50.000  multipathd: sdd: rdac prio =3D 0
Aug 13 16:28:50.763  kernel: device-mapper: multipath: Failing path 8:208.
Aug 13 16:28:50.000  multipathd: uevent 'change' from '/devices/virtual/blo=
ck/dm-1'
Aug 13 16:28:50.000  multipathd: UDEV_LOG=3D3
Aug 13 16:28:50.000  multipathd: ACTION=3Dchange
Aug 13 16:28:50.000  multipathd: DEVPATH=3D/devices/virtual/block/dm-1
Aug 13 16:28:50.000  multipathd: SUBSYSTEM=3Dblock
Aug 13 16:28:50.000  multipathd: DM_TARGET=3Dmultipath
Aug 13 16:28:50.000  multipathd: DM_ACTION=3DPATH_REINSTATED
Aug 13 16:28:50.000  multipathd: DM_SEQNUM=3D2
Aug 13 16:28:50.000  multipathd: DM_PATH=3D8:208
Aug 13 16:28:50.000  multipathd: DM_NR_VALID_PATHS=3D4
Aug 13 16:28:50.000  multipathd: DM_NAME=3Dvol1
Aug 13 16:28:50.000  multipathd: DM_UUID=3Dmpath-3600a0b800048335200001e5d4=
8b68a9b
Aug 13 16:28:50.000  multipathd: MAJOR=3D253
Aug 13 16:28:50.000  multipathd: MINOR=3D1
Aug 13 16:28:50.000  multipathd: DEVTYPE=3DdiskAug 13 16:28:50.000  multipa=
thd: SEQNUM=3D1739Aug 13 16:28:50.000  multipathd: UDEVD_EVENT=3D1
Aug 13 16:28:50.000  multipathd: vol1: rr_weight =3D 2 (LUN setting)
Aug 13 16:28:50.000  multipathd: vol1: pgfailback =3D -2 (controller settin=
g)
Aug 13 16:28:50.000  multipathd: pg_timeout =3D NONE (internal default)
Aug 13 16:28:50.000  multipathd: 8:208: mark as failed
Aug 13 16:28:50.000  multipathd: vol1: remaining active paths: 3
Aug 13 16:28:50.000  multipathd: vol1: rr_weight =3D 2 (LUN setting)
Aug 13 16:28:50.000  multipathd: vol1: pgfailback =3D -2 (controller settin=
g)
Aug 13 16:28:50.000  multipathd: uevent 'change' from '/devices/virtual/blo=
ck/dm-1'
Aug 13 16:28:50.000  multipathd: UDEV_LOG=3D3
Aug 13 16:28:50.000  multipathd: ACTION=3Dchange
Aug 13 16:28:50.000  multipathd: DEVPATH=3D/devices/virtual/block/dm-1
Aug 13 16:28:50.000  multipathd: SUBSYSTEM=3Dblock
Aug 13 16:28:50.000  multipathd: DM_TARGET=3Dmultipath
Aug 13 16:28:50.000  multipathd: DM_ACTION=3DPATH_FAILED
Aug 13 16:28:50.000  multipathd: DM_SEQNUM=3D3
Aug 13 16:28:50.000  multipathd: DM_PATH=3D8:208
Aug 13 16:28:50.000  multipathd: DM_NR_VALID_PATHS=3D3
Aug 13 16:28:50.000  multipathd: DM_NAME=3Dvol1
Aug 13 16:28:50.000  multipathd: DM_UUID=3Dmpath-3600a0b800048335200001e5d4=
8b68a9b
Aug 13 16:28:50.000  multipathd: MAJOR=3D253
Aug 13 16:28:50.000  multipathd: MINOR=3D1
Aug 13 16:28:50.000  multipathd: DEVTYPE=3Ddisk
Aug 13 16:28:50.000  multipathd: SEQNUM=3D1740
Aug 13 16:28:50.000  multipathd: UDEVD_EVENT=3D1
Aug 13 16:28:50.000  multipathd: DEVNAME=3D/dev/dm-1
Aug 13 16:29:00.000  multipathd: 8:208: reinstated
Aug 13 16:29:00.000  multipathd: vol1: remaining active paths: 4
Aug 13 16:29:00.000  multipathd: sdj: rdac prio =3D 3
Aug 13 16:29:00.000  multipathd: sdn: rdac prio =3D 3
Aug 13 16:29:00.000  multipathd: sdb: rdac prio =3D 0
Aug 13 16:29:00.000  multipathd: sdd: rdac prio =3D 0
Aug 13 16:29:00.000  multipathd: vol1: rr_weight =3D 2 (LUN setting)
Aug 13 16:29:00.000  multipathd: vol1: pgfailback =3D -2 (controller settin=
g)
Aug 13 16:29:00.000  multipathd: uevent 'change' from '/devices/virtual/blo=
ck/dm-1'
Aug 13 16:29:00.000  multipathd: UDEV_LOG=3D3
Aug 13 16:29:00.000  multipathd: ACTION=3Dchange
Aug 13 16:29:00.000  multipathd: DEVPATH=3D/devices/virtual/block/dm-1
Aug 13 16:29:00.000  multipathd: SUBSYSTEM=3Dblock
Aug 13 16:29:00.000  multipathd: DM_TARGET=3Dmultipath
Aug 13 16:29:00.000  multipathd: DM_ACTION=3DPATH_REINSTATED
Aug 13 16:29:00.000  multipathd: DM_SEQNUM=3D4
Aug 13 16:29:00.000  multipathd: DM_PATH=3D8:208
Aug 13 16:29:00.000  multipathd: DM_NR_VALID_PATHS=3D4
Aug 13 16:29:00.000  multipathd: DM_NAME=3Dvol1
Aug 13 16:29:00.000  multipathd: DM_UUID=3Dmpath-3600a0b800048335200001e5d4=
8b68a9b
Aug 13 16:29:00.000  multipathd: MAJOR=3D253
Aug 13 16:29:00.000  multipathd: MINOR=3D1
Aug 13 16:29:00.000  multipathd: DEVTYPE=3Ddisk
Aug 13 16:29:00.000  multipathd: SEQNUM=3D1741
Aug 13 16:29:00.000  multipathd: UDEVD_EVENT=3D1
Aug 13 16:29:00.000  multipathd: DEVNAME=3D/dev/dm-1
Aug 13 16:29:02.753  kernel: device-mapper: multipath: Failing path 8:208.
Aug 13 16:29:02.000  multipathd: vol1: rr_weight =3D 2 (LUN setting)
Aug 13 16:29:02.000  multipathd: vol1: pgfailback =3D -2 (controller settin=
g)
Aug 13 16:29:02.000  multipathd: pg_timeout =3D NONE (internal default)
Aug 13 16:29:02.000  multipathd: 8:208: mark as failed
Aug 13 16:29:02.000  multipathd: uevent 'change' from '/devices/virtual/blo=
ck/dm-1'
Aug 13 16:29:02.000  multipathd: UDEV_LOG=3D3
Aug 13 16:29:02.000  multipathd: ACTION=3Dchange
Aug 13 16:29:02.000  multipathd: DEVPATH=3D/devices/virtual/block/dm-1
Aug 13 16:29:02.000  multipathd: SUBSYSTEM=3Dblock
Aug 13 16:29:02.000  multipathd: DM_TARGET=3Dmultipath
Aug 13 16:29:02.000  multipathd: DM_ACTION=3DPATH_FAILED
Aug 13 16:29:02.000  multipathd: DM_SEQNUM=3D5
Aug 13 16:29:02.000  multipathd: DM_PATH=3D8:208
Aug 13 16:29:02.000  multipathd: DM_NR_VALID_PATHS=3D3
Aug 13 16:29:02.000  multipathd: DM_NAME=3Dvol1
Aug 13 16:29:02.000  multipathd: DM_UUID=3Dmpath-3600a0b800048335200001e5d4=
8b68a9b
Aug 13 16:29:02.000  multipathd: MAJOR=3D253
Aug 13 16:29:02.000  multipathd: MINOR=3D1
Aug 13 16:29:02.000  multipathd: DEVTYPE=3Ddisk
Aug 13 16:29:02.000  multipathd: SEQNUM=3D1742
Aug 13 16:29:02.000  multipathd: UDEVD_EVENT=3D1
Aug 13 16:29:02.000  multipathd: DEVNAME=3D/dev/dm-1
Aug 13 16:29:10.000  multipathd: 8:208: reinstated
Aug 13 16:29:10.000  multipathd: vol1: remaining active paths: 4
Aug 13 16:29:10.000  multipathd: sdj: rdac prio =3D 3
Aug 13 16:29:10.000  multipathd: sdn: rdac prio =3D 3
Aug 13 16:29:10.000  multipathd: sdb: rdac prio =3D 0
Aug 13 16:29:10.000  multipathd: sdd: rdac prio =3D 0
Aug 13 16:29:10.000  multipathd: vol1: rr_weight =3D 2 (LUN setting)
Aug 13 16:29:10.000  multipathd: vol1: pgfailback =3D -2 (controller settin=
g)
Aug 13 16:29:10.000  multipathd: uevent 'change' from '/devices/virtual/blo=
ck/dm-1'
Aug 13 16:29:10.000  multipathd: UDEV_LOG=3D3
Aug 13 16:29:10.000  multipathd: ACTION=3Dchange
Aug 13 16:29:10.000  multipathd: DEVPATH=3D/devices/virtual/block/dm-1
Aug 13 16:29:10.000  multipathd: SUBSYSTEM=3Dblock
Aug 13 16:29:10.000  multipathd: DM_TARGET=3Dmultipath
Aug 13 16:29:10.000  multipathd: DM_ACTION=3DPATH_REINSTATED
Aug 13 16:29:10.000  multipathd: DM_SEQNUM=3D6
Aug 13 16:29:10.000  multipathd: DM_PATH=3D8:208
Aug 13 16:29:10.000  multipathd: DM_NR_VALID_PATHS=3D4
Aug 13 16:29:10.000  multipathd: DM_NAME=3Dvol1
Aug 13 16:29:10.000  multipathd: DM_UUID=3Dmpath-3600a0b800048335200001e5d4=
8b68a9b
Aug 13 16:29:10.000  multipathd: MAJOR=3D253
Aug 13 16:29:10.000  multipathd: MINOR=3D1
Aug 13 16:29:10.000  multipathd: DEVTYPE=3Ddisk
Aug 13 16:29:10.000  multipathd: SEQNUM=3D1743
Aug 13 16:29:10.000  multipathd: UDEVD_EVENT=3D1
Aug 13 16:29:10.000  multipathd: DEVNAME=3D/dev/dm-1




On Thu, Aug 13, 2009 at 1:27 PM, Stewart Smith <stew@cleepdar.com<mailto:st=
ew@cleepdar.com>> wrote:

after a fresh, multipath -F and start of multipathd with -v 2 I see the fol=
lowing messages.

After starting multipathd I mounted /dev/mapper/vol1 and generated some sim=
ple I/O to it using dd


Aug 13 16:23:14.888 localhost kernel: device-mapper: multipath: Failing pat=
h 8:208.
Aug 13 16:23:14.000 localhost multipathd: 8:208: mark as failed
Aug 13 16:23:16.000 localhost multipathd: 8:208: reinstated
Aug 13 16:23:30.462 localhost kernel: device-mapper: multipath: Failing pat=
h 8:208.
Aug 13 16:23:30.000 localhost multipathd: 8:208: mark as failed
Aug 13 16:23:39.000 localhost multipathd: 8:208: reinstated
Aug 13 16:23:46.430 localhost kernel: device-mapper: multipath: Failing pat=
h 8:208.
Aug 13 16:23:46.000 localhost multipathd: 8:208: mark as failed
Aug 13 16:23:51.041 localhost kernel: device-mapper: multipath: Failing pat=
h 8:208.
Aug 13 16:23:51.000 localhost multipathd: 8:208: mark as failed
Aug 13 16:23:59.000 localhost multipathd: 8:208: reinstated
Aug 13 16:24:06.465 localhost kernel: device-mapper: multipath: Failing pat=
h 8:208.
Aug 13 16:24:06.000 localhost multipathd: 8:208: mark as failed
Aug 13 16:24:09.000 localhost multipathd: 8:208: reinstated


Thanks,
--
Stew



On Thu, Aug 13, 2009 at 12:42 PM, Moger, Babu <Babu.Moger@lsi.com<mailto:Ba=
bu.Moger@lsi.com>> wrote:
Do you have /var/log/messages file for this problem?

Thanks
Babu Moger

> -----Original Message-----
> From: dm-devel-bounces@redhat.com<mailto:dm-devel-bounces@redhat.com> [ma=
ilto:dm-devel-bounces@redhat.com<mailto:dm-devel-bounces@redhat.com>] On
> Behalf Of Stewart Smith
> Sent: Thursday, August 13, 2009 1:51 PM
> To: dm-devel@redhat.com<mailto:dm-devel@redhat.com>
> Subject: [dm-devel] rdac path failure - Sun 6140
>
> Hello All,
>
> I am seeing many of these messages when my Sun 6140 array is under heavy
> I/O
> device-mapper: multipath: Failing path 8:208.
> device-mapper: multipath: Failing path 8:208.
> device-mapper: multipath: Failing path 8:208.
> device-mapper: multipath: Failing path 8:208.
> device-mapper: multipath: Failing path 8:208.
>
>
> I am running a Fedora 10 server, with two fiber connections to two
> different switches.  Both controllers on the 6140 have one connection
> to each switch as well.  The end result is that I see four paths to
> each LUN.
>
> When the volume is mounted and under significant load I see the
> messages above every few seconds.  They seem to appear every
> "no_path_retry" seconds.
>
> The 6140 controller firmware is up to date at version 07.50.08.10 and
> I have installed the latest firmware for my Emulex LPe11002 cards.  I
> have reproduced the problem using both Cisco MDS and Brocade fiber
> channel switches as well.
>
> Using CAM, I have set the initiator Host Type to "Linux" at the
> moment.  I have tried other options as well without success.
>
> I have NOT installed the RDAC drivers from either Sun or LSI -
> primarily because they do not seem to build on my Fedora 10 kernel.
>
> Any ideas would be greatly appreciated!!!
>
> configs and debugging multipathd output is below.
>
>
>
>
>
> Kernel: 2.6.27.24-170.2.68.fc10.x86_64
>
> # multipath -lll
> vol1 (3600a0b800048335200001e5d48b68a9b) dm-1 SUN,CSM200_R
> [size=3D12T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac][rw]
> \_ round-robin 0 [prio=3D6][active]
>  \_ 5:0:1:2 sdj 8:144 [active][ready]
>  \_ 2:0:1:2 sdn 8:208 [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 2:0:0:2 sdb 8:16  [active][ghost]
>  \_ 5:0:0:2 sdd 8:48  [active][ghost]
>
>
> # cat /etc/multipath.conf
>
> blacklist {
>         devnode "^sd[a-z][[0-9]*]"
>         devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
>         devnode "^hd[a-z][0-9]*"
>         devnode "^cciss!c[0-9]d[0-9](p[0-9]*)*"
> }
>
> defaults {
>         udev_dir                /dev
>         polling_interval        10
>         selector                "round-robin 0"
>         path_grouping_policy    multibus
>         getuid_callout          "/sbin/scsi_id --whitelisted /dev/%n"
>         prio                    alua
>         path_checker            readsector0
>         rr_min_io               100
>         max_fds                 8192
>         rr_weight               priorities
>         failback                immediate
>         no_path_retry           fail
>         user_friendly_names     yes
> }
> devices {
>         device {
>                 vendor                  "SUN"
>                 product                 "CSM200_R"
>                 product_blacklist       "Universal Xport"
>                 getuid_callout          "/sbin/scsi_id --whitelisted
> /dev/%n"
>                 features                "0"
>                 hardware_handler        "1 rdac"
>                 path_selector           "round-robin 0"
>                 path_grouping_policy    group_by_prio
>                 failback                immediate
>                 rr_weight               uniform
>                 no_path_retry           queue
>                 rr_min_io               1000
>                 path_checker            rdac
>                 prio                    rdac
>         }
> }
>
> multipaths {
>         multipath {
>                 wwid                    3600a0b800048335200001e5d48b68a9b
>                 alias                   vol1
>                 rr_weight               priorities
>                 no_path_retry           5
>                 rr_min_io               100
>         }
> }
>
>
>
> # multipathd -d v3
>
>
> Aug 13 14:48:53 | sdb: ownership set to vol1
> Aug 13 14:48:53 | sdb: not found in pathvec
> Aug 13 14:48:53 | sdb: mask =3D 0xc
> Aug 13 14:48:53 | sdb: path checker =3D rdac (controller setting)
> Aug 13 14:48:53 | sdb: state =3D 4
> Aug 13 14:48:53 | sdb: rdac prio =3D 0
> Aug 13 14:48:53 | sdd: ownership set to vol1
> Aug 13 14:48:53 | sdd: not found in pathvec
> Aug 13 14:48:53 | sdd: mask =3D 0xc
> Aug 13 14:48:53 | sdd: path checker =3D rdac (controller setting)
> Aug 13 14:48:53 | sdd: state =3D 4
> Aug 13 14:48:53 | sdd: rdac prio =3D 0
> Aug 13 14:48:53 | sdj: ownership set to vol1
> Aug 13 14:48:53 | sdj: not found in pathvec
> Aug 13 14:48:53 | sdj: mask =3D 0xc
> Aug 13 14:48:53 | sdj: path checker =3D rdac (controller setting)
> Aug 13 14:48:53 | sdj: state =3D 2
> Aug 13 14:48:53 | sdj: rdac prio =3D 3
> Aug 13 14:48:53 | sdn: ownership set to vol1
> Aug 13 14:48:53 | sdn: not found in pathvec
> Aug 13 14:48:53 | sdn: mask =3D 0xc
> Aug 13 14:48:53 | sdn: path checker =3D rdac (controller setting)
> Aug 13 14:48:53 | sdn: state =3D 2
> Aug 13 14:48:53 | sdn: rdac prio =3D 3
> Aug 13 14:48:53 | vol1: pgfailback =3D -2 (controller setting)
> Aug 13 14:48:53 | vol1: pgpolicy =3D group_by_prio (controller setting)
> Aug 13 14:48:53 | vol1: selector =3D round-robin 0 (controller setting)
> Aug 13 14:48:53 | vol1: features =3D 0 (controller setting)
> Aug 13 14:48:53 | vol1: hwhandler =3D 1 rdac (controller setting)
> Aug 13 14:48:53 | vol1: rr_weight =3D 2 (LUN setting)
> Aug 13 14:48:53 | vol1: minio =3D 100 (LUN setting)
> Aug 13 14:48:53 | vol1: no_path_retry =3D 5 (multipath setting)
> Aug 13 14:48:53 | pg_timeout =3D NONE (internal default)
> Aug 13 14:48:53 | vol1: set ACT_CREATE (map does not exist)
> create: vol1 (3600a0b800048335200001e5d48b68a9b) n/a SUN,CSM200_R
> [size=3D12T][features=3D0][hwhandler=3D1 rdac][n/a]
> \_ round-robin 0 [prio=3D6][undef]
>  \_ 5:0:1:2 sdj 8:144 [undef][ready]
>  \_ 2:0:1:2 sdn 8:208 [undef][ready]
> \_ round-robin 0 [prio=3D0][undef]
>  \_ 2:0:0:2 sdb 8:16 [undef][ghost]
>  \_ 5:0:0:2 sdd 8:48 [undef][ghost]
>
> --
> dm-devel mailing list
> dm-devel@redhat.com<mailto:dm-devel@redhat.com>
> https://www.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com<mailto:dm-devel@redhat.com>
https://www.redhat.com/mailman/listinfo/dm-devel



--_000_E463DF2B2E584B4A82673F53D62C2EF474B79EF1cosmail01lsicom_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:x=3D"urn:schemas-microsoft-com:office:excel" xmlns:p=3D"urn:schemas-m=
icrosoft-com:office:powerpoint" xmlns:a=3D"urn:schemas-microsoft-com:office=
:access" xmlns:dt=3D"uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:s=3D"=
uuid:BDC6E3F0-6DA3-11d1-A2A3-00AA00C14882" xmlns:rs=3D"urn:schemas-microsof=
t-com:rowset" xmlns:z=3D"#RowsetSchema" xmlns:b=3D"urn:schemas-microsoft-co=
m:office:publisher" xmlns:ss=3D"urn:schemas-microsoft-com:office:spreadshee=
t" xmlns:c=3D"urn:schemas-microsoft-com:office:component:spreadsheet" xmlns=
:odc=3D"urn:schemas-microsoft-com:office:odc" xmlns:oa=3D"urn:schemas-micro=
soft-com:office:activation" xmlns:html=3D"http://www.w3.org/TR/REC-html40" =
xmlns:q=3D"http://schemas.xmlsoap.org/soap/envelope/" xmlns:D=3D"DAV:" xmln=
s:mt=3D"http://schemas.microsoft.com/sharepoint/soap/meetings/" xmlns:x2=3D=
"http://schemas.microsoft.com/office/excel/2003/xml" xmlns:ois=3D"http://sc=
hemas.microsoft.com/sharepoint/soap/ois/" xmlns:dir=3D"http://schemas.micro=
soft.com/sharepoint/soap/directory/" xmlns:ds=3D"http://www.w3.org/2000/09/=
xmldsig#" xmlns:dsp=3D"http://schemas.microsoft.com/sharepoint/dsp" xmlns:u=
dc=3D"http://schemas.microsoft.com/data/udc" xmlns:xsd=3D"http://www.w3.org=
/2001/XMLSchema" xmlns:sub=3D"http://schemas.microsoft.com/sharepoint/soap/=
2002/1/alerts/" xmlns:ec=3D"http://www.w3.org/2001/04/xmlenc#" xmlns:sp=3D"=
http://schemas.microsoft.com/sharepoint/" xmlns:sps=3D"http://schemas.micro=
soft.com/sharepoint/soap/" xmlns:xsi=3D"http://www.w3.org/2001/XMLSchema-in=
stance" xmlns:udcs=3D"http://schemas.microsoft.com/data/udc/soap" xmlns:udc=
xf=3D"http://schemas.microsoft.com/data/udc/xmlfile" xmlns:udcp2p=3D"http:/=
/schemas.microsoft.com/data/udc/parttopart" xmlns:st=3D"&#1;" xmlns:st1=3D"=
urn:schemas-microsoft-com:office:smarttags" xmlns=3D"http://www.w3.org/TR/R=
EC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Diso-8859-1"=
>
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<!--[if !mso]>
<style>
v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style>
<![endif]--><o:SmartTagType
 namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags" name=3D"place"=
/>
<o:SmartTagType namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"PersonName"/>
<!--[if !mso]>
<style>
st1\:*{behavior:url(#default#ieooui) }
</style>
<![endif]-->
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:blue;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-reply;
	font-family:Arial;
	color:navy;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DEN-US link=3Dblue vlink=3Dblue>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Stew,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>=A0=A0=A0=A0 I don&#8217;t see much information about this failure =
in the logs.
Right now device handlers don&#8217;t provide much information on failures.=
 =A0We
are working on to add some more debug levels. =A0I am attaching my draft co=
de (scsi_dh_rdac.c)
here. =A0Please use this only for your testing. It is not been approved/rev=
iewed
yet. I still need to submit this one to community for approval. The code is
attached.=A0 Please replace this file with scsi_dh_rdac.c in the directory
/driver/scsi/device_handlers and rebuild the kernel. =A0This should give mo=
re
information from the target point of view. Please send me the /var/log/mess=
ages
file after the failure. Let see if we can get more information.. </span></f=
ont><font
size=3D2 color=3Dnavy face=3DArial><span style=3D'font-size:10.0pt;font-fam=
ily:Arial;
color:navy'><o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p></span></font></p>

<div>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Thanks</span></font><font color=3Dnavy=
><span
style=3D'color:navy'><o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Babu Moger </span></font><o:p></o:p></=
p>

</div>

<div style=3D'border:none;border-left:solid blue 1.5pt;padding:0in 0in 0in =
4.0pt'>

<div>

<div class=3DMsoNormal align=3Dcenter style=3D'text-align:center'><font siz=
e=3D3
face=3D"Times New Roman"><span style=3D'font-size:12.0pt'>

<hr size=3D2 width=3D"100%" align=3Dcenter tabindex=3D-1>

</span></font></div>

<p class=3DMsoNormal><b><font size=3D2 face=3DTahoma><span style=3D'font-si=
ze:10.0pt;
font-family:Tahoma;font-weight:bold'>From:</span></font></b><font size=3D2
face=3DTahoma><span style=3D'font-size:10.0pt;font-family:Tahoma'>
dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] <b><span
style=3D'font-weight:bold'>On Behalf Of </span></b>Stewart Smith<br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> Thursday, August 13, 2=
009
3:35 PM<br>
<b><span style=3D'font-weight:bold'>To:</span></b> <st1:PersonName w:st=3D"=
on">device-mapper
 development</st1:PersonName><br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> Re: [dm-devel] rdac=
 path
failure - Sun 6140</span></font><o:p></o:p></p>

</div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Same sequence of events, with multipathd -v3<o:p></o:p></span></fon=
t></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

<div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.627 &nbsp;kernel: device-mapper: multipath: Failing
path 8:208.<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.000 &nbsp;multipathd: vol1: rr_weight =3D 2 (LUN se=
tting)<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.000 &nbsp;multipathd: vol1: pgfailback =3D -2 (cont=
roller
setting)<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.000 &nbsp;multipathd: pg_timeout =3D NONE (internal
default)<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.000 &nbsp;multipathd: 8:208: mark as failed<o:p></o=
:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.000 &nbsp;multipathd: uevent 'change' from
'/devices/virtual/block/dm-1'<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.000 &nbsp;multipathd: UDEV_LOG=3D3<o:p></o:p></span=
></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.000 &nbsp;multipathd: ACTION=3Dchange<o:p></o:p></s=
pan></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.000 &nbsp;multipathd:
DEVPATH=3D/devices/virtual/block/dm-1<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.000 &nbsp;multipathd: SUBSYSTEM=3Dblock<o:p></o:p><=
/span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.000 &nbsp;multipathd: DM_TARGET=3Dmultipath<o:p></o=
:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.000 &nbsp;multipathd: DM_ACTION=3DPATH_FAILED<o:p><=
/o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.000 &nbsp;multipathd: DM_SEQNUM=3D1<o:p></o:p></spa=
n></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.000 &nbsp;multipathd: DM_PATH=3D8:208<o:p></o:p></s=
pan></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.000 &nbsp;multipathd: DM_NR_VALID_PATHS=3D3<o:p></o=
:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.000 &nbsp;multipathd: DM_NAME=3Dvol1<o:p></o:p></sp=
an></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.000 &nbsp;multipathd:
DM_UUID=3Dmpath-3600a0b800048335200001e5d48b68a9b<o:p></o:p></span></font><=
/p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.000 &nbsp;multipathd: MAJOR=3D253<o:p></o:p></span>=
</font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.000 &nbsp;multipathd: MINOR=3D1<o:p></o:p></span></=
font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.000 &nbsp;multipathd: DEVTYPE=3Ddisk<o:p></o:p></sp=
an></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.000 &nbsp;multipathd: SEQNUM=3D1738<o:p></o:p></spa=
n></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.000 &nbsp;multipathd: UDEVD_EVENT=3D1<o:p></o:p></s=
pan></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:48.000 &nbsp;multipathd: DEVNAME=3D/dev/dm-1<o:p></o:p=
></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: 8:208: reinstated<o:p></o:p><=
/span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: vol1: remaining active paths:=
 4<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: sdj: rdac prio =3D 3<o:p></o:=
p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: sdn: rdac prio =3D 3<o:p></o:=
p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: sdb: rdac prio =3D 0<o:p></o:=
p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: sdd: rdac prio =3D 0<o:p></o:=
p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.763 &nbsp;kernel: device-mapper: multipath: Failing
path 8:208.<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: uevent 'change' from
'/devices/virtual/block/dm-1'<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: UDEV_LOG=3D3<o:p></o:p></span=
></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: ACTION=3Dchange<o:p></o:p></s=
pan></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd:
DEVPATH=3D/devices/virtual/block/dm-1<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: SUBSYSTEM=3Dblock<o:p></o:p><=
/span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: DM_TARGET=3Dmultipath<o:p></o=
:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: DM_ACTION=3DPATH_REINSTATED<o=
:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: DM_SEQNUM=3D2<o:p></o:p></spa=
n></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: DM_PATH=3D8:208<o:p></o:p></s=
pan></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: DM_NR_VALID_PATHS=3D4<o:p></o=
:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: DM_NAME=3Dvol1<o:p></o:p></sp=
an></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd:
DM_UUID=3Dmpath-3600a0b800048335200001e5d48b68a9b<o:p></o:p></span></font><=
/p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: MAJOR=3D253<o:p></o:p></span>=
</font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: MINOR=3D1<o:p></o:p></span></=
font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: DEVTYPE=3DdiskAug 13 16:28:50=
.000
&nbsp;multipathd: SEQNUM=3D1739Aug 13 16:28:50.000 &nbsp;multipathd:
UDEVD_EVENT=3D1<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: vol1: rr_weight =3D 2 (LUN se=
tting)<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: vol1: pgfailback =3D -2 (cont=
roller
setting)<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: pg_timeout =3D NONE (internal
default)<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: 8:208: mark as failed<o:p></o=
:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: vol1: remaining active paths:=
 3<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: vol1: rr_weight =3D 2 (LUN se=
tting)<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: vol1: pgfailback =3D -2 (cont=
roller
setting)<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: uevent 'change' from
'/devices/virtual/block/dm-1'<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: UDEV_LOG=3D3<o:p></o:p></span=
></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: ACTION=3Dchange<o:p></o:p></s=
pan></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd:
DEVPATH=3D/devices/virtual/block/dm-1<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: SUBSYSTEM=3Dblock<o:p></o:p><=
/span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: DM_TARGET=3Dmultipath<o:p></o=
:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: DM_ACTION=3DPATH_FAILED<o:p><=
/o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: DM_SEQNUM=3D3<o:p></o:p></spa=
n></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: DM_PATH=3D8:208<o:p></o:p></s=
pan></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: DM_NR_VALID_PATHS=3D3<o:p></o=
:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: DM_NAME=3Dvol1<o:p></o:p></sp=
an></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd:
DM_UUID=3Dmpath-3600a0b800048335200001e5d48b68a9b<o:p></o:p></span></font><=
/p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: MAJOR=3D253<o:p></o:p></span>=
</font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: MINOR=3D1<o:p></o:p></span></=
font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: DEVTYPE=3Ddisk<o:p></o:p></sp=
an></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: SEQNUM=3D1740<o:p></o:p></spa=
n></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: UDEVD_EVENT=3D1<o:p></o:p></s=
pan></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:28:50.000 &nbsp;multipathd: DEVNAME=3D/dev/dm-1<o:p></o:p=
></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: 8:208: reinstated<o:p></o:p><=
/span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: vol1: remaining active paths:=
 4<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: sdj: rdac prio =3D 3<o:p></o:=
p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: sdn: rdac prio =3D 3<o:p></o:=
p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: sdb: rdac prio =3D 0<o:p></o:=
p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: sdd: rdac prio =3D 0<o:p></o:=
p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: vol1: rr_weight =3D 2 (LUN se=
tting)<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: vol1: pgfailback =3D -2 (cont=
roller
setting)<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: uevent 'change' from
'/devices/virtual/block/dm-1'<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: UDEV_LOG=3D3<o:p></o:p></span=
></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: ACTION=3Dchange<o:p></o:p></s=
pan></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd:
DEVPATH=3D/devices/virtual/block/dm-1<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: SUBSYSTEM=3Dblock<o:p></o:p><=
/span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: DM_TARGET=3Dmultipath<o:p></o=
:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: DM_ACTION=3DPATH_REINSTATED<o=
:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: DM_SEQNUM=3D4<o:p></o:p></spa=
n></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: DM_PATH=3D8:208<o:p></o:p></s=
pan></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: DM_NR_VALID_PATHS=3D4<o:p></o=
:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: DM_NAME=3Dvol1<o:p></o:p></sp=
an></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd:
DM_UUID=3Dmpath-3600a0b800048335200001e5d48b68a9b<o:p></o:p></span></font><=
/p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: MAJOR=3D253<o:p></o:p></span>=
</font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: MINOR=3D1<o:p></o:p></span></=
font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: DEVTYPE=3Ddisk<o:p></o:p></sp=
an></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: SEQNUM=3D1741<o:p></o:p></spa=
n></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: UDEVD_EVENT=3D1<o:p></o:p></s=
pan></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:00.000 &nbsp;multipathd: DEVNAME=3D/dev/dm-1<o:p></o:p=
></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.753 &nbsp;kernel: device-mapper: multipath: Failing
path 8:208.<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.000 &nbsp;multipathd: vol1: rr_weight =3D 2 (LUN se=
tting)<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.000 &nbsp;multipathd: vol1: pgfailback =3D -2 (cont=
roller
setting)<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.000 &nbsp;multipathd: pg_timeout =3D NONE (internal
default)<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.000 &nbsp;multipathd: 8:208: mark as failed<o:p></o=
:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.000 &nbsp;multipathd: uevent 'change' from
'/devices/virtual/block/dm-1'<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.000 &nbsp;multipathd: UDEV_LOG=3D3<o:p></o:p></span=
></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.000 &nbsp;multipathd: ACTION=3Dchange<o:p></o:p></s=
pan></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.000 &nbsp;multipathd:
DEVPATH=3D/devices/virtual/block/dm-1<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.000 &nbsp;multipathd: SUBSYSTEM=3Dblock<o:p></o:p><=
/span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.000 &nbsp;multipathd: DM_TARGET=3Dmultipath<o:p></o=
:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.000 &nbsp;multipathd: DM_ACTION=3DPATH_FAILED<o:p><=
/o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.000 &nbsp;multipathd: DM_SEQNUM=3D5<o:p></o:p></spa=
n></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.000 &nbsp;multipathd: DM_PATH=3D8:208<o:p></o:p></s=
pan></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.000 &nbsp;multipathd: DM_NR_VALID_PATHS=3D3<o:p></o=
:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.000 &nbsp;multipathd: DM_NAME=3Dvol1<o:p></o:p></sp=
an></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.000 &nbsp;multipathd:
DM_UUID=3Dmpath-3600a0b800048335200001e5d48b68a9b<o:p></o:p></span></font><=
/p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.000 &nbsp;multipathd: MAJOR=3D253<o:p></o:p></span>=
</font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.000 &nbsp;multipathd: MINOR=3D1<o:p></o:p></span></=
font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.000 &nbsp;multipathd: DEVTYPE=3Ddisk<o:p></o:p></sp=
an></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.000 &nbsp;multipathd: SEQNUM=3D1742<o:p></o:p></spa=
n></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.000 &nbsp;multipathd: UDEVD_EVENT=3D1<o:p></o:p></s=
pan></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:02.000 &nbsp;multipathd: DEVNAME=3D/dev/dm-1<o:p></o:p=
></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: 8:208: reinstated<o:p></o:p><=
/span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: vol1: remaining active paths:=
 4<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: sdj: rdac prio =3D 3<o:p></o:=
p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: sdn: rdac prio =3D 3<o:p></o:=
p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: sdb: rdac prio =3D 0<o:p></o:=
p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: sdd: rdac prio =3D 0<o:p></o:=
p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: vol1: rr_weight =3D 2 (LUN se=
tting)<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: vol1: pgfailback =3D -2 (cont=
roller
setting)<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: uevent 'change' from
'/devices/virtual/block/dm-1'<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: UDEV_LOG=3D3<o:p></o:p></span=
></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: ACTION=3Dchange<o:p></o:p></s=
pan></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd:
DEVPATH=3D/devices/virtual/block/dm-1<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: SUBSYSTEM=3Dblock<o:p></o:p><=
/span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: DM_TARGET=3Dmultipath<o:p></o=
:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: DM_ACTION=3DPATH_REINSTATED<o=
:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: DM_SEQNUM=3D6<o:p></o:p></spa=
n></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: DM_PATH=3D8:208<o:p></o:p></s=
pan></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: DM_NR_VALID_PATHS=3D4<o:p></o=
:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: DM_NAME=3Dvol1<o:p></o:p></sp=
an></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd:
DM_UUID=3Dmpath-3600a0b800048335200001e5d48b68a9b<o:p></o:p></span></font><=
/p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: MAJOR=3D253<o:p></o:p></span>=
</font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: MINOR=3D1<o:p></o:p></span></=
font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: DEVTYPE=3Ddisk<o:p></o:p></sp=
an></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: SEQNUM=3D1743<o:p></o:p></spa=
n></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: UDEVD_EVENT=3D1<o:p></o:p></s=
pan></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:29:10.000 &nbsp;multipathd: DEVNAME=3D/dev/dm-1<o:p></o:p=
></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

<p class=3DMsoNormal style=3D'margin-bottom:12.0pt'><font size=3D3
face=3D"Times New Roman"><span style=3D'font-size:12.0pt'><o:p>&nbsp;</o:p>=
</span></font></p>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>On Thu, Aug 13, 2009 at 1:27 PM, Stewart Smith &lt;<a
href=3D"mailto:stew@cleepdar.com">stew@cleepdar.com</a>&gt; wrote:<o:p></o:=
p></span></font></p>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>after a fresh, multipath -F and start of multipathd with -v 2 I see=
 the
following messages.<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>After starting multipathd I mounted /dev/mapper/vol1 and generated =
some
simple I/O to it using dd<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

<div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:23:14.888 localhost kernel: device-mapper: multipath: Fai=
ling
path 8:208.<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:23:14.000 localhost multipathd: 8:208: mark as failed<o:p=
></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:23:16.000 localhost multipathd: 8:208: reinstated<o:p></o=
:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:23:30.462 localhost kernel: device-mapper: multipath: Fai=
ling
path 8:208.&nbsp;<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:23:30.000 localhost multipathd: 8:208: mark as failed<o:p=
></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:23:39.000 localhost multipathd: 8:208: reinstated<o:p></o=
:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:23:46.430 localhost kernel: device-mapper: multipath: Fai=
ling
path 8:208.&nbsp;<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:23:46.000 localhost multipathd: 8:208: mark as failed<o:p=
></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:23:51.041 localhost kernel: device-mapper: multipath: Fai=
ling
path 8:208.&nbsp;<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:23:51.000 localhost multipathd: 8:208: mark as failed<o:p=
></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:23:59.000 localhost multipathd: 8:208: reinstated<o:p></o=
:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:24:06.465 localhost kernel: device-mapper: multipath: Fai=
ling
path 8:208.<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:24:06.000 localhost multipathd: 8:208: mark as failed<o:p=
></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Aug 13 16:24:09.000 localhost multipathd: 8:208: reinstated<o:p></o=
:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Thanks,<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>--<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 color=3D"#888888" face=3D"Times New Rom=
an"><span
style=3D'font-size:12.0pt;color:#888888'>Stew<o:p></o:p></span></font></p>

</div>

</div>

<div>

<div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

<p class=3DMsoNormal style=3D'margin-bottom:12.0pt'><font size=3D3
face=3D"Times New Roman"><span style=3D'font-size:12.0pt'><o:p>&nbsp;</o:p>=
</span></font></p>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>On Thu, Aug 13, 2009 at 12:42 PM, <st1:PersonName w:st=3D"on">Moger=
, Babu</st1:PersonName>
&lt;<a href=3D"mailto:Babu.Moger@lsi.com" target=3D"_blank">Babu.Moger@lsi.=
com</a>&gt;
wrote:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Do you have /var/log/messages file for this problem?<br>
<br>
Thanks<br>
Babu Moger<o:p></o:p></span></font></p>

<div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><br>
&gt; -----Original Message-----<br>
&gt; From: <a href=3D"mailto:dm-devel-bounces@redhat.com" target=3D"_blank"=
>dm-devel-bounces@redhat.com</a>
[mailto:<a href=3D"mailto:dm-devel-bounces@redhat.com" target=3D"_blank">dm=
-devel-bounces@redhat.com</a>]
On<br>
&gt; Behalf Of Stewart Smith<br>
&gt; Sent: Thursday, August 13, 2009 1:51 PM<br>
&gt; To: <a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@=
redhat.com</a><br>
&gt; Subject: [dm-devel] rdac path failure - Sun 6140<br>
&gt;<br>
&gt; Hello All,<br>
&gt;<br>
&gt; I am seeing many of these messages when my Sun 6140 array is under hea=
vy<br>
&gt; I/O<br>
&gt; device-mapper: multipath: Failing path 8:208.<br>
&gt; device-mapper: multipath: Failing path 8:208.<br>
&gt; device-mapper: multipath: Failing path 8:208.<br>
&gt; device-mapper: multipath: Failing path 8:208.<br>
&gt; device-mapper: multipath: Failing path 8:208.<br>
&gt;<br>
&gt;<br>
&gt; I am running a Fedora 10 server, with two fiber connections to two<br>
&gt; different switches.&nbsp;&nbsp;Both&nbsp;controllers on the 6140 have =
one
connection<br>
&gt; to each switch as well. &nbsp;The end result is that I see four paths =
to<br>
&gt; each LUN.<br>
&gt;<br>
&gt; When the volume is mounted and under significant load I see the<br>
&gt; messages above every few seconds. &nbsp;They seem to appear every<br>
&gt; &quot;no_path_retry&quot; seconds.<br>
&gt;<br>
&gt; The 6140 controller firmware is up to date at version 07.50.08.10 and<=
br>
&gt; I have installed the latest firmware for my Emulex LPe11002 cards. &nb=
sp;I<br>
&gt; have reproduced the problem using both Cisco MDS and Brocade fiber<br>
&gt; channel switches as well.<br>
&gt;<br>
&gt; Using <st1:place w:st=3D"on">CAM</st1:place>, I have set the initiator=
 Host
Type to &quot;Linux&quot; at the<br>
&gt; moment. &nbsp;I have tried other options as well without success.<br>
&gt;<br>
&gt; I have NOT installed the RDAC drivers from either Sun or LSI -<br>
&gt; primarily because they do not seem to build on my Fedora 10 kernel.<br=
>
&gt;<br>
&gt; Any ideas would be greatly appreciated!!!<br>
&gt;<br>
&gt; configs and debugging multipathd output is below.<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; Kernel: 2.6.27.24-170.2.68.fc10.x86_64<br>
&gt;<br>
&gt; # multipath -lll<br>
&gt; vol1 (3600a0b800048335200001e5d48b68a9b) dm-1 SUN,CSM200_R<br>
&gt; [size=3D12T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac][rw]<br=
>
&gt; \_ round-robin 0 [prio=3D6][active]<br>
&gt; &nbsp;\_ 5:0:1:2 sdj 8:144 [active][ready]<br>
&gt; &nbsp;\_ 2:0:1:2 sdn 8:208 [active][ready]<br>
&gt; \_ round-robin 0 [prio=3D0][enabled]<br>
&gt; &nbsp;\_ 2:0:0:2 sdb 8:16 &nbsp;[active][ghost]<br>
&gt; &nbsp;\_ 5:0:0:2 sdd 8:48 &nbsp;[active][ghost]<br>
&gt;<br>
&gt;<br>
&gt; # cat /etc/multipath.conf<br>
&gt;<br>
&gt; blacklist {<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; devnode &quot;^sd[a-z][[0-9]*]&quot;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; devnode
&quot;^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*&quot;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; devnode &quot;^hd[a-z][0-9]*&quot;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; devnode &quot;^cciss!c[0-9]d[0-9](p[0-9]*)=
*&quot;<br>
&gt; }<br>
&gt;<br>
&gt; defaults {<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; udev_dir &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
;
&nbsp; &nbsp; &nbsp;/dev<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; polling_interval &nbsp; &nbsp; &nbsp; &nbs=
p;10<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; selector &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
;
&nbsp; &nbsp; &nbsp;&quot;round-robin 0&quot;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; path_grouping_policy &nbsp; &nbsp;multibus=
<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; getuid_callout &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp;&quot;/sbin/scsi_id --whitelisted /dev/%n&quot;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; prio &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp;
&nbsp; &nbsp; &nbsp; &nbsp;alua<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; path_checker &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp;readsector0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; rr_min_io &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p;
&nbsp; &nbsp; 100<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; max_fds &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; 8192<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; rr_weight &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p;
&nbsp; &nbsp; priorities<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; failback &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
;
&nbsp; &nbsp; &nbsp;immediate<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; no_path_retry &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; fail<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; user_friendly_names &nbsp; &nbsp; yes<br>
&gt; }<br>
&gt; devices {<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; device {<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; vendor &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&quot;SUN&quot;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; product &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &quot;CSM200_R&quot;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; product_blackl=
ist
&nbsp; &nbsp; &nbsp; &quot;Universal Xport&quot;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; getuid_callout
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&quot;/sbin/scsi_id --whitelisted<br>
&gt; /dev/%n&quot;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; features &nbsp=
;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&quot;0&quot;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; hardware_handl=
er
&nbsp; &nbsp; &nbsp; &nbsp;&quot;1 rdac&quot;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; path_selector
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &quot;round-robin 0&quot;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
path_grouping_policy &nbsp; &nbsp;group_by_prio<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; failback &nbsp=
;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;immediate<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; rr_weight &nbs=
p;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; uniform<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; no_path_retry
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; queue<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; rr_min_io &nbs=
p;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1000<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; path_checker
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;rdac<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; prio &nbsp; &n=
bsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;rdac<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
&gt; }<br>
&gt;<br>
&gt; multipaths {<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; multipath {<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; wwid &nbsp; &n=
bsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp;3600a0b800048335200001e5d48b68a9b<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; alias &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; vol1<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; rr_weight &nbs=
p;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; priorities<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; no_path_retry
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 5<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; rr_min_io &nbs=
p;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 100<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
&gt; }<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; # multipathd -d v3<br>
&gt;<br>
&gt;<br>
&gt; Aug 13 14:48:53 | sdb: ownership set to vol1<br>
&gt; Aug 13 14:48:53 | sdb: not found in pathvec<br>
&gt; Aug 13 14:48:53 | sdb: mask =3D 0xc<br>
&gt; Aug 13 14:48:53 | sdb: path checker =3D rdac (controller setting)<br>
&gt; Aug 13 14:48:53 | sdb: state =3D 4<br>
&gt; Aug 13 14:48:53 | sdb: rdac prio =3D 0<br>
&gt; Aug 13 14:48:53 | sdd: ownership set to vol1<br>
&gt; Aug 13 14:48:53 | sdd: not found in pathvec<br>
&gt; Aug 13 14:48:53 | sdd: mask =3D 0xc<br>
&gt; Aug 13 14:48:53 | sdd: path checker =3D rdac (controller setting)<br>
&gt; Aug 13 14:48:53 | sdd: state =3D 4<br>
&gt; Aug 13 14:48:53 | sdd: rdac prio =3D 0<br>
&gt; Aug 13 14:48:53 | sdj: ownership set to vol1<br>
&gt; Aug 13 14:48:53 | sdj: not found in pathvec<br>
&gt; Aug 13 14:48:53 | sdj: mask =3D 0xc<br>
&gt; Aug 13 14:48:53 | sdj: path checker =3D rdac (controller setting)<br>
&gt; Aug 13 14:48:53 | sdj: state =3D 2<br>
&gt; Aug 13 14:48:53 | sdj: rdac prio =3D 3<br>
&gt; Aug 13 14:48:53 | sdn: ownership set to vol1<br>
&gt; Aug 13 14:48:53 | sdn: not found in pathvec<br>
&gt; Aug 13 14:48:53 | sdn: mask =3D 0xc<br>
&gt; Aug 13 14:48:53 | sdn: path checker =3D rdac (controller setting)<br>
&gt; Aug 13 14:48:53 | sdn: state =3D 2<br>
&gt; Aug 13 14:48:53 | sdn: rdac prio =3D 3<br>
&gt; Aug 13 14:48:53 | vol1: pgfailback =3D -2 (controller setting)<br>
&gt; Aug 13 14:48:53 | vol1: pgpolicy =3D group_by_prio (controller setting=
)<br>
&gt; Aug 13 14:48:53 | vol1: selector =3D round-robin 0 (controller setting=
)<br>
&gt; Aug 13 14:48:53 | vol1: features =3D 0 (controller setting)<br>
&gt; Aug 13 14:48:53 | vol1: hwhandler =3D 1 rdac (controller setting)<br>
&gt; Aug 13 14:48:53 | vol1: rr_weight =3D 2 (LUN setting)<br>
&gt; Aug 13 14:48:53 | vol1: minio =3D 100 (LUN setting)<br>
&gt; Aug 13 14:48:53 | vol1: no_path_retry =3D 5 (multipath setting)<br>
&gt; Aug 13 14:48:53 | pg_timeout =3D NONE (internal default)<br>
&gt; Aug 13 14:48:53 | vol1: set ACT_CREATE (map does not exist)<br>
&gt; create: vol1 (3600a0b800048335200001e5d48b68a9b) n/a SUN,CSM200_R<br>
&gt; [size=3D12T][features=3D0][hwhandler=3D1 rdac][n/a]<br>
&gt; \_ round-robin 0 [prio=3D6][undef]<br>
&gt; &nbsp;\_ 5:0:1:2 sdj 8:144 [undef][ready]<br>
&gt; &nbsp;\_ 2:0:1:2 sdn 8:208 [undef][ready]<br>
&gt; \_ round-robin 0 [prio=3D0][undef]<br>
&gt; &nbsp;\_ 2:0:0:2 sdb 8:16 [undef][ghost]<br>
&gt; &nbsp;\_ 5:0:0:2 sdd 8:48 [undef][ghost]<br>
&gt;<o:p></o:p></span></font></p>

</div>

</div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>&gt; --<br>
&gt; dm-devel mailing list<br>
&gt; <a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redh=
at.com</a><br>
&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D=
"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
<font color=3D"#888888"><span style=3D'color:#888888'><br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a></span></font><o:p>=
</o:p></span></font></p>

</div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

</div>

</div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

</div>

</body>

</html>

--_000_E463DF2B2E584B4A82673F53D62C2EF474B79EF1cosmail01lsicom_--

--_004_E463DF2B2E584B4A82673F53D62C2EF474B79EF1cosmail01lsicom_
Content-Type: text/plain; name="scsi_dh_rdac.c"
Content-Description: scsi_dh_rdac.c
Content-Disposition: attachment; filename="scsi_dh_rdac.c"; size=19308;
	creation-date="Thu, 13 Aug 2009 17:55:29 GMT";
	modification-date="Thu, 13 Aug 2009 17:55:29 GMT"
Content-Transfer-Encoding: base64

LyoKICogRW5nZW5pby9MU0kgUkRBQyBTQ1NJIERldmljZSBIYW5kbGVyCiAqCiAqIENvcHlyaWdo
dCAoQykgMjAwNSBNaWtlIENocmlzdGllLiBBbGwgcmlnaHRzIHJlc2VydmVkLgogKiBDb3B5cmln
aHQgKEMpIENoYW5kcmEgU2VldGhhcmFtYW4sIElCTSBDb3JwLiAyMDA3CiAqCiAqIFRoaXMgcHJv
Z3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9k
aWZ5CiAqIGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vu
c2UgYXMgcHVibGlzaGVkIGJ5CiAqIHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb247IGVpdGhl
ciB2ZXJzaW9uIDIgb2YgdGhlIExpY2Vuc2UsIG9yCiAqIChhdCB5b3VyIG9wdGlvbikgYW55IGxh
dGVyIHZlcnNpb24uCiAqCiAqIFRoaXMgcHJvZ3JhbSBpcyBkaXN0cmlidXRlZCBpbiB0aGUgaG9w
ZSB0aGF0IGl0IHdpbGwgYmUgdXNlZnVsLAogKiBidXQgV0lUSE9VVCBBTlkgV0FSUkFOVFk7IHdp
dGhvdXQgZXZlbiB0aGUgaW1wbGllZCB3YXJyYW50eSBvZgogKiBNRVJDSEFOVEFCSUxJVFkgb3Ig
RklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0UuICBTZWUgdGhlCiAqIEdOVSBHZW5lcmFs
IFB1YmxpYyBMaWNlbnNlIGZvciBtb3JlIGRldGFpbHMuCiAqCiAqIFlvdSBzaG91bGQgaGF2ZSBy
ZWNlaXZlZCBhIGNvcHkgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlCiAqIGFsb25n
IHdpdGggdGhpcyBwcm9ncmFtOyBpZiBub3QsIHdyaXRlIHRvIHRoZSBGcmVlIFNvZnR3YXJlCiAq
IEZvdW5kYXRpb24sIEluYy4sIDU5IFRlbXBsZSBQbGFjZSAtIFN1aXRlIDMzMCwgQm9zdG9uLCBN
QSAwMjExMS0xMzA3LCBVU0EuCiAqCiAqLwojaW5jbHVkZSA8c2NzaS9zY3NpLmg+CiNpbmNsdWRl
IDxzY3NpL3Njc2lfZWguaD4KI2luY2x1ZGUgPHNjc2kvc2NzaV9kaC5oPgoKI2RlZmluZSBSREFD
X05BTUUgInJkYWMiCiNkZWZpbmUgUkRBQ19SRVRSWV9DT1VOVCA1CgovKgogKiBMU0kgbW9kZSBw
YWdlIHN0dWZmCiAqCiAqIFRoZXNlIHN0cnVjdCBkZWZpbml0aW9ucyBhbmQgdGhlIGZvcm1pbmcg
b2YgdGhlCiAqIG1vZGUgcGFnZSB3ZXJlIHRha2VuIGZyb20gdGhlIExTSSBSREFDIDIuNCBHUEwn
ZAogKiBkcml2ZXIsIGFuZCB0aGVuIGNvbnZlcnRlZCB0byBMaW51eCBjb252ZW50aW9ucy4KICov
CiNkZWZpbmUgUkRBQ19RVUlFU0NFTkNFX1RJTUUgMjA7Ci8qCiAqIFBhZ2UgQ29kZXMKICovCiNk
ZWZpbmUgUkRBQ19QQUdFX0NPREVfUkVEVU5EQU5UX0NPTlRST0xMRVIgMHgyYwoKLyoKICogQ29u
dHJvbGxlciBtb2RlcyBkZWZpbml0aW9ucwogKi8KI2RlZmluZSBSREFDX01PREVfVFJBTlNGRVJf
U1BFQ0lGSUVEX0xVTlMJMHgwMgoKLyoKICogUkRBQyBPcHRpb25zIGZpZWxkCiAqLwojZGVmaW5l
IFJEQUNfRk9SQ0VEX1FVSUVTRU5DRSAweDAyCgojZGVmaW5lIFJEQUNfVElNRU9VVAkoNjAgKiBI
WikKI2RlZmluZSBSREFDX1JFVFJJRVMJMwoKc3RydWN0IHJkYWNfbW9kZV82X2hkciB7Cgl1OAlk
YXRhX2xlbjsKCXU4CW1lZGl1bV90eXBlOwoJdTgJZGV2aWNlX3BhcmFtczsKCXU4CWJsb2NrX2Rl
c2NfbGVuOwp9OwoKc3RydWN0IHJkYWNfbW9kZV8xMF9oZHIgewoJdTE2CWRhdGFfbGVuOwoJdTgJ
bWVkaXVtX3R5cGU7Cgl1OAlkZXZpY2VfcGFyYW1zOwoJdTE2CXJlc2VydmVkOwoJdTE2CWJsb2Nr
X2Rlc2NfbGVuOwp9OwoKc3RydWN0IHJkYWNfbW9kZV9jb21tb24gewoJdTgJY29udHJvbGxlcl9z
ZXJpYWxbMTZdOwoJdTgJYWx0X2NvbnRyb2xsZXJfc2VyaWFsWzE2XTsKCXU4CXJkYWNfbW9kZVsy
XTsKCXU4CWFsdF9yZGFjX21vZGVbMl07Cgl1OAlxdWllc2NlbmNlX3RpbWVvdXQ7Cgl1OAlyZGFj
X29wdGlvbnM7Cn07CgpzdHJ1Y3QgcmRhY19wZ19sZWdhY3kgewoJc3RydWN0IHJkYWNfbW9kZV82
X2hkciBoZHI7Cgl1OAlwYWdlX2NvZGU7Cgl1OAlwYWdlX2xlbjsKCXN0cnVjdCByZGFjX21vZGVf
Y29tbW9uIGNvbW1vbjsKI2RlZmluZSBNT0RFNl9NQVhfTFVOCTMyCgl1OAlsdW5fdGFibGVbTU9E
RTZfTUFYX0xVTl07Cgl1OAlyZXNlcnZlZDJbMzJdOwoJdTgJcmVzZXJ2ZWQzOwoJdTgJcmVzZXJ2
ZWQ0Owp9OwoKc3RydWN0IHJkYWNfcGdfZXhwYW5kZWQgewoJc3RydWN0IHJkYWNfbW9kZV8xMF9o
ZHIgaGRyOwoJdTgJcGFnZV9jb2RlOwoJdTgJc3VicGFnZV9jb2RlOwoJdTgJcGFnZV9sZW5bMl07
CglzdHJ1Y3QgcmRhY19tb2RlX2NvbW1vbiBjb21tb247Cgl1OAlsdW5fdGFibGVbMjU2XTsKCXU4
CXJlc2VydmVkMzsKCXU4CXJlc2VydmVkNDsKfTsKCnN0cnVjdCBjOV9pbnF1aXJ5IHsKCXU4CXBl
cmlwaGVyYWxfaW5mbzsKCXU4CXBhZ2VfY29kZTsJLyogMHhDOSAqLwoJdTgJcmVzZXJ2ZWQxOwoJ
dTgJcGFnZV9sZW47Cgl1OAlwYWdlX2lkWzRdOwkvKiAidmFjZSIgKi8KCXU4CWF2dGVfY3ZwOwoJ
dTgJcGF0aF9wcmlvOwoJdTgJcmVzZXJ2ZWQyWzM4XTsKfTsKCiNkZWZpbmUgU1VCU1lTX0lEX0xF
TgkxNgojZGVmaW5lIFNMT1RfSURfTEVOCTIKCnN0cnVjdCBjNF9pbnF1aXJ5IHsKCXU4CXBlcmlw
aGVyYWxfaW5mbzsKCXU4CXBhZ2VfY29kZTsJLyogMHhDNCAqLwoJdTgJcmVzZXJ2ZWQxOwoJdTgJ
cGFnZV9sZW47Cgl1OAlwYWdlX2lkWzRdOwkvKiAic3VicyIgKi8KCXU4CXN1YnN5c19pZFtTVUJT
WVNfSURfTEVOXTsKCXU4CXJldmlzaW9uWzRdOwoJdTgJc2xvdF9pZFtTTE9UX0lEX0xFTl07Cgl1
OAlyZXNlcnZlZFsyXTsKfTsKCnN0cnVjdCByZGFjX2NvbnRyb2xsZXIgewoJdTgJCQlzdWJzeXNf
aWRbU1VCU1lTX0lEX0xFTl07Cgl1OAkJCXNsb3RfaWRbU0xPVF9JRF9MRU5dOwoJaW50CQkJdXNl
X21zMTA7CglzdHJ1Y3Qga3JlZgkJa3JlZjsKCXN0cnVjdCBsaXN0X2hlYWQJbm9kZTsgLyogbGlz
dCBvZiBhbGwgY29udHJvbGxlcnMgKi8KCXVuaW9uCQkJewoJCXN0cnVjdCByZGFjX3BnX2xlZ2Fj
eSBsZWdhY3k7CgkJc3RydWN0IHJkYWNfcGdfZXhwYW5kZWQgZXhwYW5kZWQ7Cgl9IG1vZGVfc2Vs
ZWN0OwoJdTgJCQlpbmRleDsKCXU4CQkJYXJyYXlfbmFtZVszMV07Cn07CnN0cnVjdCBjOF9pbnF1
aXJ5IHsKCXU4CXBlcmlwaGVyYWxfaW5mbzsKCXU4CXBhZ2VfY29kZTsgLyogMHhDOCAqLwoJdTgJ
cmVzZXJ2ZWQxOwoJdTgJcGFnZV9sZW47Cgl1OAlwYWdlX2lkWzRdOyAvKiAiZWRpZCIgKi8KCXU4
CXJlc2VydmVkMlszXTsKCXU4CXZvbF91bmlxX2lkX2xlbjsKCXU4CXZvbF91bmlxX2lkWzE2XTsK
CXU4CXZvbF91c2VyX2xhYmVsX2xlbjsKCXU4CXZvbF91c2VyX2xhYmVsWzYwXTsKCXU4CWFycmF5
X3VuaXFfaWRfbGVuOwoJdTgJYXJyYXlfdW5pcXVlX2lkWzE2XTsKCXU4CWFycmF5X3VzZXJfbGFi
ZWxfbGVuOwoJdTgJYXJyYXlfdXNlcl9sYWJlbFs2MF07Cgl1OAlsdW5bOF07Cn07CgpzdHJ1Y3Qg
YzJfaW5xdWlyeSB7Cgl1OAlwZXJpcGhlcmFsX2luZm87Cgl1OAlwYWdlX2NvZGU7CS8qIDB4QzIg
Ki8KCXU4CXJlc2VydmVkMTsKCXU4CXBhZ2VfbGVuOwoJdTgJcGFnZV9pZFs0XTsJLyogInN3cjQi
ICovCgl1OAlzd192ZXJzaW9uWzNdOwoJdTgJc3dfZGF0ZVszXTsKCXU4CWZlYXR1cmVzX2VuYWJs
ZWQ7Cgl1OAltYXhfbHVuX3N1cHBvcnRlZDsKCXU4CXBhcnRpdGlvbnNbMjM5XTsgLyogVG90YWwg
YWxsb2NhdGlvbiBsZW5ndGggc2hvdWxkIGJlIDB4RkYgKi8KfTsKCnN0cnVjdCByZGFjX2RoX2Rh
dGEgewoJc3RydWN0IHJkYWNfY29udHJvbGxlcgkqY3RscjsKI2RlZmluZSBVTklOSVRJQUxJWkVE
X0xVTgkoMSA8PCA4KQoJdW5zaWduZWQJCWx1bjsKI2RlZmluZSBSREFDX1NUQVRFX0FDVElWRQkw
CiNkZWZpbmUgUkRBQ19TVEFURV9QQVNTSVZFCTEKCXVuc2lnbmVkIGNoYXIJCXN0YXRlOwoKI2Rl
ZmluZSBSREFDX0xVTl9VTk9XTkVECTAKI2RlZmluZSBSREFDX0xVTl9PV05FRAkJMQojZGVmaW5l
IFJEQUNfTFVOX0FWVAkJMgoJY2hhcgkJCWx1bl9zdGF0ZTsKCXVuc2lnbmVkIGNoYXIJCXNlbnNl
W1NDU0lfU0VOU0VfQlVGRkVSU0laRV07Cgl1bmlvbgkJCXsKCQlzdHJ1Y3QgYzJfaW5xdWlyeSBj
MjsKCQlzdHJ1Y3QgYzRfaW5xdWlyeSBjNDsKCQlzdHJ1Y3QgYzhfaW5xdWlyeSBjODsKCQlzdHJ1
Y3QgYzlfaW5xdWlyeSBjOTsKCX0gaW5xOwp9OwoKc3RhdGljIGNvbnN0IGNoYXIgKmx1bl9zdGF0
ZVtdID0KewoJInVub3duZWQiLAoJIm93bmVkIiwKCSJvd25lZCAoQVZUIG1vZGUpIiwKfTsKCnN0
YXRpYyBMSVNUX0hFQUQoY3Rscl9saXN0KTsKc3RhdGljIERFRklORV9TUElOTE9DSyhsaXN0X2xv
Y2spOwoKLyogCiAqIG1vZHVsZSBwYXJhbWV0ZXIgdG8gZW5hYmxlIHJkYWMgZGVidWcgbG9nZ2lu
Zy4KICogMiBiaXRzIGZvciBlYWNoIHR5cGUgb2YgbG9nZ2luZywgb25seSB0d28gdHlwZXMgZGVm
aW5lZCBmb3Igbm93IAogKiBDYW4gYmUgZW5oYW5jZWQgaWYgcmVxdWlyZWQgYXQgbGF0ZXIgcG9p
bnQKICovCnN0YXRpYyBpbnQgcmRhY19sb2dnaW5nID0gMHhGOwptb2R1bGVfcGFyYW0ocmRhY19s
b2dnaW5nLCBpbnQsIDApOwpNT0RVTEVfUEFSTV9ERVNDKHJkYWNfbG9nZ2luZywgIkEgYml0IG1h
c2sgb2YgcmRhYyBsb2dnaW5nIGxldmVscywgIgoJCSJEZWZhdWx0IGlzIDEgLSBmYWlsb3ZlciBs
b2dnaW5nIGVuYWJsZWQsICIKCQkic2V0IGl0IHRvIDB4RiB0byBlbmFibGUgYWxsIHRoZSBsb2dz
Iik7CgojZGVmaW5lIFJEQUNfTE9HX0ZBSUxPVkVSCTAKI2RlZmluZSBSREFDX0xPR19TRU5TRQkJ
MgoKI2RlZmluZSBSREFDX0xPR19CSVRTCQkyCgojZGVmaW5lIFJEQUNfTE9HX0xFVkVMKFNISUZU
KSAgXAogICAgICAgICgocmRhY19sb2dnaW5nID4+IChTSElGVCkpICYgKCgxIDw8IChSREFDX0xP
R19CSVRTKSkgLSAxKSkKCiNkZWZpbmUgUkRBQ19ERUJVRyhTSElGVCwgc2RldiwgZiwgYXJnLi4u
KSBcCmRvIHsgXAoJaWYgKHVubGlrZWx5KFJEQUNfTE9HX0xFVkVMKFNISUZUKSkpIFwKCQlzZGV2
X3ByaW50ayhLRVJOX0lORk8sIHNkZXYsIFJEQUNfTkFNRSAiOiAiIGYgIlxuIiwgIyMgYXJnKTsg
XAp9IHdoaWxlICgwKTsKCnN0YXRpYyBpbmxpbmUgc3RydWN0IHJkYWNfZGhfZGF0YSAqZ2V0X3Jk
YWNfZGF0YShzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYpCnsKCXN0cnVjdCBzY3NpX2RoX2RhdGEg
KnNjc2lfZGhfZGF0YSA9IHNkZXYtPnNjc2lfZGhfZGF0YTsKCUJVR19PTihzY3NpX2RoX2RhdGEg
PT0gTlVMTCk7CglyZXR1cm4gKChzdHJ1Y3QgcmRhY19kaF9kYXRhICopIHNjc2lfZGhfZGF0YS0+
YnVmKTsKfQoKc3RhdGljIHN0cnVjdCByZXF1ZXN0ICpnZXRfcmRhY19yZXEoc3RydWN0IHNjc2lf
ZGV2aWNlICpzZGV2LAoJCQl2b2lkICpidWZmZXIsIHVuc2lnbmVkIGJ1ZmxlbiwgaW50IHJ3KQp7
CglzdHJ1Y3QgcmVxdWVzdCAqcnE7CglzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSA9IHNkZXYtPnJl
cXVlc3RfcXVldWU7CgoJcnEgPSBibGtfZ2V0X3JlcXVlc3QocSwgcncsIEdGUF9OT0lPKTsKCglp
ZiAoIXJxKSB7CgkJc2Rldl9wcmludGsoS0VSTl9JTkZPLCBzZGV2LAoJCQkJImdldF9yZGFjX3Jl
cTogYmxrX2dldF9yZXF1ZXN0IGZhaWxlZC5cbiIpOwoJCXJldHVybiBOVUxMOwoJfQoKCWlmIChi
dWZsZW4gJiYgYmxrX3JxX21hcF9rZXJuKHEsIHJxLCBidWZmZXIsIGJ1ZmxlbiwgR0ZQX05PSU8p
KSB7CgkJYmxrX3B1dF9yZXF1ZXN0KHJxKTsKCQlzZGV2X3ByaW50ayhLRVJOX0lORk8sIHNkZXYs
CgkJCQkiZ2V0X3JkYWNfcmVxOiBibGtfcnFfbWFwX2tlcm4gZmFpbGVkLlxuIik7CgkJcmV0dXJu
IE5VTEw7Cgl9CgoJcnEtPmNtZF90eXBlID0gUkVRX1RZUEVfQkxPQ0tfUEM7CglycS0+Y21kX2Zs
YWdzIHw9IFJFUV9GQUlMRkFTVF9ERVYgfCBSRVFfRkFJTEZBU1RfVFJBTlNQT1JUIHwKCQkJIFJF
UV9GQUlMRkFTVF9EUklWRVI7CglycS0+cmV0cmllcyA9IFJEQUNfUkVUUklFUzsKCXJxLT50aW1l
b3V0ID0gUkRBQ19USU1FT1VUOwoKCXJldHVybiBycTsKfQoKc3RhdGljIHN0cnVjdCByZXF1ZXN0
ICpyZGFjX2ZhaWxvdmVyX2dldChzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYsCgkJCQkJIHN0cnVj
dCByZGFjX2RoX2RhdGEgKmgpCnsKCXN0cnVjdCByZXF1ZXN0ICpycTsKCXN0cnVjdCByZGFjX21v
ZGVfY29tbW9uICpjb21tb247Cgl1bnNpZ25lZCBkYXRhX3NpemU7CgoJaWYgKGgtPmN0bHItPnVz
ZV9tczEwKSB7CgkJc3RydWN0IHJkYWNfcGdfZXhwYW5kZWQgKnJkYWNfcGc7CgoJCWRhdGFfc2l6
ZSA9IHNpemVvZihzdHJ1Y3QgcmRhY19wZ19leHBhbmRlZCk7CgkJcmRhY19wZyA9ICZoLT5jdGxy
LT5tb2RlX3NlbGVjdC5leHBhbmRlZDsKCQltZW1zZXQocmRhY19wZywgMCwgZGF0YV9zaXplKTsK
CQljb21tb24gPSAmcmRhY19wZy0+Y29tbW9uOwoJCXJkYWNfcGctPnBhZ2VfY29kZSA9IFJEQUNf
UEFHRV9DT0RFX1JFRFVOREFOVF9DT05UUk9MTEVSICsgMHg0MDsKCQlyZGFjX3BnLT5zdWJwYWdl
X2NvZGUgPSAweDE7CgkJcmRhY19wZy0+cGFnZV9sZW5bMF0gPSAweDAxOwoJCXJkYWNfcGctPnBh
Z2VfbGVuWzFdID0gMHgyODsKCQlyZGFjX3BnLT5sdW5fdGFibGVbaC0+bHVuXSA9IDB4ODE7Cgl9
IGVsc2UgewoJCXN0cnVjdCByZGFjX3BnX2xlZ2FjeSAqcmRhY19wZzsKCgkJZGF0YV9zaXplID0g
c2l6ZW9mKHN0cnVjdCByZGFjX3BnX2xlZ2FjeSk7CgkJcmRhY19wZyA9ICZoLT5jdGxyLT5tb2Rl
X3NlbGVjdC5sZWdhY3k7CgkJbWVtc2V0KHJkYWNfcGcsIDAsIGRhdGFfc2l6ZSk7CgkJY29tbW9u
ID0gJnJkYWNfcGctPmNvbW1vbjsKCQlyZGFjX3BnLT5wYWdlX2NvZGUgPSBSREFDX1BBR0VfQ09E
RV9SRURVTkRBTlRfQ09OVFJPTExFUjsKCQlyZGFjX3BnLT5wYWdlX2xlbiA9IDB4Njg7CgkJcmRh
Y19wZy0+bHVuX3RhYmxlW2gtPmx1bl0gPSAweDgxOwoJfQoJY29tbW9uLT5yZGFjX21vZGVbMV0g
PSBSREFDX01PREVfVFJBTlNGRVJfU1BFQ0lGSUVEX0xVTlM7Cgljb21tb24tPnF1aWVzY2VuY2Vf
dGltZW91dCA9IFJEQUNfUVVJRVNDRU5DRV9USU1FOwoJY29tbW9uLT5yZGFjX29wdGlvbnMgPSBS
REFDX0ZPUkNFRF9RVUlFU0VOQ0U7CgoJLyogZ2V0IHJlcXVlc3QgZm9yIGJsb2NrIGxheWVyIHBh
Y2tldCBjb21tYW5kICovCglycSA9IGdldF9yZGFjX3JlcShzZGV2LCAmaC0+Y3Rsci0+bW9kZV9z
ZWxlY3QsIGRhdGFfc2l6ZSwgV1JJVEUpOwoJaWYgKCFycSkKCQlyZXR1cm4gTlVMTDsKCgkvKiBQ
cmVwYXJlIHRoZSBjb21tYW5kLiAqLwoJaWYgKGgtPmN0bHItPnVzZV9tczEwKSB7CgkJcnEtPmNt
ZFswXSA9IE1PREVfU0VMRUNUXzEwOwoJCXJxLT5jbWRbN10gPSBkYXRhX3NpemUgPj4gODsKCQly
cS0+Y21kWzhdID0gZGF0YV9zaXplICYgMHhmZjsKCX0gZWxzZSB7CgkJcnEtPmNtZFswXSA9IE1P
REVfU0VMRUNUOwoJCXJxLT5jbWRbNF0gPSBkYXRhX3NpemU7Cgl9CglycS0+Y21kX2xlbiA9IENP
TU1BTkRfU0laRShycS0+Y21kWzBdKTsKCglycS0+c2Vuc2UgPSBoLT5zZW5zZTsKCW1lbXNldChy
cS0+c2Vuc2UsIDAsIFNDU0lfU0VOU0VfQlVGRkVSU0laRSk7CglycS0+c2Vuc2VfbGVuID0gMDsK
CglyZXR1cm4gcnE7Cn0KCnN0YXRpYyB2b2lkIHJlbGVhc2VfY29udHJvbGxlcihzdHJ1Y3Qga3Jl
ZiAqa3JlZikKewoJc3RydWN0IHJkYWNfY29udHJvbGxlciAqY3RscjsKCWN0bHIgPSBjb250YWlu
ZXJfb2Yoa3JlZiwgc3RydWN0IHJkYWNfY29udHJvbGxlciwga3JlZik7CgoJc3Bpbl9sb2NrKCZs
aXN0X2xvY2spOwoJbGlzdF9kZWwoJmN0bHItPm5vZGUpOwoJc3Bpbl91bmxvY2soJmxpc3RfbG9j
ayk7CglrZnJlZShjdGxyKTsKfQoKc3RhdGljIHN0cnVjdCByZGFjX2NvbnRyb2xsZXIgKmdldF9j
b250cm9sbGVyKHU4ICpzdWJzeXNfaWQsIHU4ICpzbG90X2lkKQp7CglzdHJ1Y3QgcmRhY19jb250
cm9sbGVyICpjdGxyLCAqdG1wOwoKCXNwaW5fbG9jaygmbGlzdF9sb2NrKTsKCglsaXN0X2Zvcl9l
YWNoX2VudHJ5KHRtcCwgJmN0bHJfbGlzdCwgbm9kZSkgewoJCWlmICgobWVtY21wKHRtcC0+c3Vi
c3lzX2lkLCBzdWJzeXNfaWQsIFNVQlNZU19JRF9MRU4pID09IDApICYmCgkJCSAgKG1lbWNtcCh0
bXAtPnNsb3RfaWQsIHNsb3RfaWQsIFNMT1RfSURfTEVOKSA9PSAwKSkgewoJCQlrcmVmX2dldCgm
dG1wLT5rcmVmKTsKCQkJc3Bpbl91bmxvY2soJmxpc3RfbG9jayk7CgkJCXJldHVybiB0bXA7CgkJ
fQoJfQoJY3RsciA9IGttYWxsb2Moc2l6ZW9mKCpjdGxyKSwgR0ZQX0FUT01JQyk7CglpZiAoIWN0
bHIpCgkJZ290byBkb25lOwoKCS8qIGluaXRpYWxpemUgZmllbGRzIG9mIGNvbnRyb2xsZXIgKi8K
CW1lbWNweShjdGxyLT5zdWJzeXNfaWQsIHN1YnN5c19pZCwgU1VCU1lTX0lEX0xFTik7CgltZW1j
cHkoY3Rsci0+c2xvdF9pZCwgc2xvdF9pZCwgU0xPVF9JRF9MRU4pOwoKCS8qIHVwZGF0ZSB0aGUg
Y29udHJvbGxlciBpbmRleCAqLwoJaWYgKHNsb3RfaWRbMV0gPT0gMHgzMSkKCQljdGxyLT5pbmRl
eCA9IDA7CgllbHNlCgkJY3Rsci0+aW5kZXggPSAxOwoKCWtyZWZfaW5pdCgmY3Rsci0+a3JlZik7
CgljdGxyLT51c2VfbXMxMCA9IC0xOwoJbGlzdF9hZGQoJmN0bHItPm5vZGUsICZjdGxyX2xpc3Qp
Owpkb25lOgoJc3Bpbl91bmxvY2soJmxpc3RfbG9jayk7CglyZXR1cm4gY3RscjsKfQoKc3RhdGlj
IGludCBzdWJtaXRfaW5xdWlyeShzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYsIGludCBwYWdlX2Nv
ZGUsCgkJCSAgdW5zaWduZWQgaW50IGxlbiwgc3RydWN0IHJkYWNfZGhfZGF0YSAqaCkKewoJc3Ry
dWN0IHJlcXVlc3QgKnJxOwoJc3RydWN0IHJlcXVlc3RfcXVldWUgKnEgPSBzZGV2LT5yZXF1ZXN0
X3F1ZXVlOwoJaW50IGVyciA9IFNDU0lfREhfUkVTX1RFTVBfVU5BVkFJTDsKCglycSA9IGdldF9y
ZGFjX3JlcShzZGV2LCAmaC0+aW5xLCBsZW4sIFJFQUQpOwoJaWYgKCFycSkKCQlnb3RvIGRvbmU7
CgoJLyogUHJlcGFyZSB0aGUgY29tbWFuZC4gKi8KCXJxLT5jbWRbMF0gPSBJTlFVSVJZOwoJcnEt
PmNtZFsxXSA9IDE7CglycS0+Y21kWzJdID0gcGFnZV9jb2RlOwoJcnEtPmNtZFs0XSA9IGxlbjsK
CXJxLT5jbWRfbGVuID0gQ09NTUFORF9TSVpFKElOUVVJUlkpOwoKCXJxLT5zZW5zZSA9IGgtPnNl
bnNlOwoJbWVtc2V0KHJxLT5zZW5zZSwgMCwgU0NTSV9TRU5TRV9CVUZGRVJTSVpFKTsKCXJxLT5z
ZW5zZV9sZW4gPSAwOwoKCWVyciA9IGJsa19leGVjdXRlX3JxKHEsIE5VTEwsIHJxLCAxKTsKCWlm
IChlcnIgPT0gLUVJTykKCQllcnIgPSBTQ1NJX0RIX0lPOwoKCWJsa19wdXRfcmVxdWVzdChycSk7
CmRvbmU6CglyZXR1cm4gZXJyOwp9CgpzdGF0aWMgaW50IGdldF9sdW4oc3RydWN0IHNjc2lfZGV2
aWNlICpzZGV2LCBzdHJ1Y3QgcmRhY19kaF9kYXRhICpoKQp7CglpbnQgZXJyOwoJc3RydWN0IGM4
X2lucXVpcnkgKmlucXA7CgoJZXJyID0gc3VibWl0X2lucXVpcnkoc2RldiwgMHhDOCwgc2l6ZW9m
KHN0cnVjdCBjOF9pbnF1aXJ5KSwgaCk7CglpZiAoZXJyID09IFNDU0lfREhfT0spIHsKCQlpbnFw
ID0gJmgtPmlucS5jODsKCQlpZiAoaW5xcC0+cGFnZV9jb2RlICE9IDB4YzgpCgkJCXJldHVybiBT
Q1NJX0RIX05PU1lTOwoJCWlmIChpbnFwLT5wYWdlX2lkWzBdICE9ICdlJyB8fCBpbnFwLT5wYWdl
X2lkWzFdICE9ICdkJyB8fAoJCSAgICBpbnFwLT5wYWdlX2lkWzJdICE9ICdpJyB8fCBpbnFwLT5w
YWdlX2lkWzNdICE9ICdkJykKCQkJcmV0dXJuIFNDU0lfREhfTk9TWVM7CgkJaC0+bHVuID0gaW5x
cC0+bHVuWzddOyAvKiBVc2VzIG9ubHkgdGhlIGxhc3QgYnl0ZSAqLwoJfQoJcmV0dXJuIGVycjsK
fQoKc3RhdGljIGludCBnZXRfYXJyYXlfbmFtZShzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYsIHN0
cnVjdCByZGFjX2RoX2RhdGEgKmgpCnsKCWludCBlcnIsIGk7CglzdHJ1Y3QgYzhfaW5xdWlyeSAq
aW5xcDsKCgllcnIgPSBzdWJtaXRfaW5xdWlyeShzZGV2LCAweEM4LCBzaXplb2Yoc3RydWN0IGM4
X2lucXVpcnkpLCBoKTsKCWlmIChlcnIgPT0gU0NTSV9ESF9PSykgewoJCWlucXAgPSAmaC0+aW5x
LmM4OwoJCWlmIChpbnFwLT5wYWdlX2NvZGUgIT0gMHhjOCkKCQkJcmV0dXJuIFNDU0lfREhfTk9T
WVM7CgoJCWZvcihpPTA7IGk8MzA7ICsraSl7CgkJCWgtPmN0bHItPmFycmF5X25hbWVbaV0gPSBp
bnFwLT5hcnJheV91c2VyX2xhYmVsWygyKmkpKzFdOwoJCX0KCQloLT5jdGxyLT5hcnJheV9uYW1l
WzMwXSA9ICdcMCc7Cgl9CgkJCQoJcmV0dXJuIGVycjsKfQoKc3RhdGljIGludCBjaGVja19vd25l
cnNoaXAoc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2LCBzdHJ1Y3QgcmRhY19kaF9kYXRhICpoKQp7
CglpbnQgZXJyOwoJc3RydWN0IGM5X2lucXVpcnkgKmlucXA7CgoJaC0+bHVuX3N0YXRlID0gUkRB
Q19MVU5fVU5PV05FRDsKCWgtPnN0YXRlID0gUkRBQ19TVEFURV9BQ1RJVkU7CgllcnIgPSBzdWJt
aXRfaW5xdWlyeShzZGV2LCAweEM5LCBzaXplb2Yoc3RydWN0IGM5X2lucXVpcnkpLCBoKTsKCWlm
IChlcnIgPT0gU0NTSV9ESF9PSykgewoJCWlucXAgPSAmaC0+aW5xLmM5OwoJCWlmICgoaW5xcC0+
YXZ0ZV9jdnAgPj4gNykgPT0gMHgxKSB7CgkJCS8qIExVTiBpbiBBVlQgbW9kZSAqLwoJCQlzZGV2
X3ByaW50ayhLRVJOX05PVElDRSwgc2RldiwKCQkJCSAgICAiJXM6IEFWVCBtb2RlIGRldGVjdGVk
XG4iLAoJCQkJICAgIFJEQUNfTkFNRSk7CgkJCWgtPmx1bl9zdGF0ZSA9IFJEQUNfTFVOX0FWVDsK
CQl9IGVsc2UgaWYgKChpbnFwLT5hdnRlX2N2cCAmIDB4MSkgIT0gMCkgewoJCQkvKiBMVU4gd2Fz
IG93bmVkIGJ5IHRoZSBjb250cm9sbGVyICovCgkJCWgtPmx1bl9zdGF0ZSA9IFJEQUNfTFVOX09X
TkVEOwoJCX0KCX0KCglpZiAoaC0+bHVuX3N0YXRlID09IFJEQUNfTFVOX1VOT1dORUQpCgkJaC0+
c3RhdGUgPSBSREFDX1NUQVRFX1BBU1NJVkU7CgoJcmV0dXJuIGVycjsKfQoKc3RhdGljIGludCBp
bml0aWFsaXplX2NvbnRyb2xsZXIoc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2LAoJCQkJIHN0cnVj
dCByZGFjX2RoX2RhdGEgKmgpCnsKCWludCBlcnI7CglzdHJ1Y3QgYzRfaW5xdWlyeSAqaW5xcDsK
CgllcnIgPSBzdWJtaXRfaW5xdWlyeShzZGV2LCAweEM0LCBzaXplb2Yoc3RydWN0IGM0X2lucXVp
cnkpLCBoKTsKCWlmIChlcnIgPT0gU0NTSV9ESF9PSykgewoJCWlucXAgPSAmaC0+aW5xLmM0OwoJ
CWgtPmN0bHIgPSBnZXRfY29udHJvbGxlcihpbnFwLT5zdWJzeXNfaWQsIGlucXAtPnNsb3RfaWQp
OwoJCWlmICghaC0+Y3RscikKCQkJZXJyID0gU0NTSV9ESF9SRVNfVEVNUF9VTkFWQUlMOwoJfQoJ
cmV0dXJuIGVycjsKfQoKc3RhdGljIGludCBzZXRfbW9kZV9zZWxlY3Qoc3RydWN0IHNjc2lfZGV2
aWNlICpzZGV2LCBzdHJ1Y3QgcmRhY19kaF9kYXRhICpoKQp7CglpbnQgZXJyOwoJc3RydWN0IGMy
X2lucXVpcnkgKmlucXA7CgoJZXJyID0gc3VibWl0X2lucXVpcnkoc2RldiwgMHhDMiwgc2l6ZW9m
KHN0cnVjdCBjMl9pbnF1aXJ5KSwgaCk7CglpZiAoZXJyID09IFNDU0lfREhfT0spIHsKCQlpbnFw
ID0gJmgtPmlucS5jMjsKCQkvKgoJCSAqIElmIG1vcmUgdGhhbiBNT0RFNl9NQVhfTFVOIGx1bnMg
YXJlIHN1cHBvcnRlZCwgdXNlCgkJICogbW9kZSBzZWxlY3QgMTAKCQkgKi8KCQlpZiAoaW5xcC0+
bWF4X2x1bl9zdXBwb3J0ZWQgPj0gTU9ERTZfTUFYX0xVTikKCQkJaC0+Y3Rsci0+dXNlX21zMTAg
PSAxOwoJCWVsc2UKCQkJaC0+Y3Rsci0+dXNlX21zMTAgPSAwOwoJfQoJcmV0dXJuIGVycjsKfQoK
c3RhdGljIGludCBtb2RlX3NlbGVjdF9oYW5kbGVfc2Vuc2Uoc3RydWN0IHNjc2lfZGV2aWNlICpz
ZGV2LAoJCQkJICAgIHVuc2lnbmVkIGNoYXIgKnNlbnNlYnVmKQp7CglzdHJ1Y3Qgc2NzaV9zZW5z
ZV9oZHIgc2Vuc2VfaGRyOwoJaW50IGVyciA9IFNDU0lfREhfSU8sIHJldDsKCXN0cnVjdCByZGFj
X2RoX2RhdGEgKmggPSBnZXRfcmRhY19kYXRhKHNkZXYpOwoKCXJldCA9IHNjc2lfbm9ybWFsaXpl
X3NlbnNlKHNlbnNlYnVmLCBTQ1NJX1NFTlNFX0JVRkZFUlNJWkUsICZzZW5zZV9oZHIpOwoJaWYg
KCFyZXQpCgkJZ290byBkb25lOwoKCXN3aXRjaCAoc2Vuc2VfaGRyLnNlbnNlX2tleSkgewoJY2Fz
ZSBOT19TRU5TRToKCWNhc2UgQUJPUlRFRF9DT01NQU5EOgoJY2FzZSBVTklUX0FUVEVOVElPTjoK
CQllcnIgPSBTQ1NJX0RIX1JFVFJZOwoJCWJyZWFrOwoJY2FzZSBOT1RfUkVBRFk6CgkJaWYgKHNl
bnNlX2hkci5hc2MgPT0gMHgwNCAmJiBzZW5zZV9oZHIuYXNjcSA9PSAweDAxKQoJCQkvKiBMVU4g
Tm90IFJlYWR5IGFuZCBpcyBpbiB0aGUgUHJvY2VzcyBvZiBCZWNvbWluZwoJCQkgKiBSZWFkeQoJ
CQkgKi8KCQkJZXJyID0gU0NTSV9ESF9SRVRSWTsKCQlicmVhazsKCWNhc2UgSUxMRUdBTF9SRVFV
RVNUOgoJCWlmIChzZW5zZV9oZHIuYXNjID09IDB4OTEgJiYgc2Vuc2VfaGRyLmFzY3EgPT0gMHgz
NikKCQkJLyoKCQkJICogQ29tbWFuZCBMb2NrIGNvbnRlbnRpb24KCQkJICovCgkJCWVyciA9IFND
U0lfREhfUkVUUlk7CgkJYnJlYWs7CglkZWZhdWx0OgoJCWJyZWFrOwoJfQoKZG9uZToKCVJEQUNf
REVCVUcoUkRBQ19MT0dfRkFJTE9WRVIsIHNkZXYsICJhcnJheSAlcywgY3RsciAlZCwgIgoJCSJN
T0RFX1NFTEVDVCByZXR1cm5lZCB3aXRoIHNlbnNlICUwMngvJTAyeC8lMDJ4IiwKCQkoY2hhciAq
KSBoLT5jdGxyLT5hcnJheV9uYW1lLCBoLT5jdGxyLT5pbmRleCwKCQlzZW5zZV9oZHIuc2Vuc2Vf
a2V5LCBzZW5zZV9oZHIuYXNjLCBzZW5zZV9oZHIuYXNjcSk7CgkJCglyZXR1cm4gZXJyOwp9Cgpz
dGF0aWMgaW50IHNlbmRfbW9kZV9zZWxlY3Qoc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2LCBzdHJ1
Y3QgcmRhY19kaF9kYXRhICpoKQp7CglzdHJ1Y3QgcmVxdWVzdCAqcnE7CglzdHJ1Y3QgcmVxdWVz
dF9xdWV1ZSAqcSA9IHNkZXYtPnJlcXVlc3RfcXVldWU7CglpbnQgZXJyLCByZXRyeV9jbnQgPSBS
REFDX1JFVFJZX0NPVU5UOwoKcmV0cnk6CgllcnIgPSBTQ1NJX0RIX1JFU19URU1QX1VOQVZBSUw7
CglycSA9IHJkYWNfZmFpbG92ZXJfZ2V0KHNkZXYsIGgpOwoJaWYgKCFycSkKCQlnb3RvIGRvbmU7
CgoJUkRBQ19ERUJVRyhSREFDX0xPR19GQUlMT1ZFUiwgc2RldiwgImFycmF5ICVzLCBjdGxyICVk
LCAiCgkJIiVzIE1PREVfU0VMRUNUIGNvbW1hbmQiLAoJCShjaGFyICopIGgtPmN0bHItPmFycmF5
X25hbWUsIGgtPmN0bHItPmluZGV4LAoJCShyZXRyeV9jbnQgPT0gUkRBQ19SRVRSWV9DT1VOVCkg
PyAicXVldWVpbmciIDogInJldHJ5aW5nIik7CgoJZXJyID0gYmxrX2V4ZWN1dGVfcnEocSwgTlVM
TCwgcnEsIDEpOwoJYmxrX3B1dF9yZXF1ZXN0KHJxKTsKCWlmIChlcnIgIT0gU0NTSV9ESF9PSykg
ewoJCWVyciA9IG1vZGVfc2VsZWN0X2hhbmRsZV9zZW5zZShzZGV2LCBoLT5zZW5zZSk7CgkJaWYg
KGVyciA9PSBTQ1NJX0RIX1JFVFJZICYmIHJldHJ5X2NudC0tKQoJCQlnb3RvIHJldHJ5OwoJfQoJ
aWYgKGVyciA9PSBTQ1NJX0RIX09LKSB7CgkJaC0+c3RhdGUgPSBSREFDX1NUQVRFX0FDVElWRTsK
CQlSREFDX0RFQlVHKFJEQUNfTE9HX0ZBSUxPVkVSLCBzZGV2LCAiYXJyYXkgJXMsIGN0bHIgJWQs
ICIKCQkJCSJNT0RFX1NFTEVDVCBjb21wbGV0ZWQiLAoJCQkJKGNoYXIgKikgaC0+Y3Rsci0+YXJy
YXlfbmFtZSwgaC0+Y3Rsci0+aW5kZXgpOwoJfQoKZG9uZToKCXJldHVybiBlcnI7Cn0KCnN0YXRp
YyBpbnQgcmRhY19hY3RpdmF0ZShzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYpCnsKCXN0cnVjdCBy
ZGFjX2RoX2RhdGEgKmggPSBnZXRfcmRhY19kYXRhKHNkZXYpOwoJaW50IGVyciA9IFNDU0lfREhf
T0s7CgoJZXJyID0gY2hlY2tfb3duZXJzaGlwKHNkZXYsIGgpOwoJaWYgKGVyciAhPSBTQ1NJX0RI
X09LKQoJCWdvdG8gZG9uZTsKCglpZiAoaC0+Y3Rsci0+dXNlX21zMTAgPT0gLTEpIHsKCQllcnIg
PSBzZXRfbW9kZV9zZWxlY3Qoc2RldiwgaCk7CgkJaWYgKGVyciAhPSBTQ1NJX0RIX09LKQoJCQln
b3RvIGRvbmU7Cgl9CglpZiAoaC0+bHVuX3N0YXRlID09IFJEQUNfTFVOX1VOT1dORUQpCgkJZXJy
ID0gc2VuZF9tb2RlX3NlbGVjdChzZGV2LCBoKTsKZG9uZToKCXJldHVybiBlcnI7Cn0KCnN0YXRp
YyBpbnQgcmRhY19wcmVwX2ZuKHN0cnVjdCBzY3NpX2RldmljZSAqc2Rldiwgc3RydWN0IHJlcXVl
c3QgKnJlcSkKewoJc3RydWN0IHJkYWNfZGhfZGF0YSAqaCA9IGdldF9yZGFjX2RhdGEoc2Rldik7
CglpbnQgcmV0ID0gQkxLUFJFUF9PSzsKCglpZiAoaC0+c3RhdGUgIT0gUkRBQ19TVEFURV9BQ1RJ
VkUpIHsKCQlyZXQgPSBCTEtQUkVQX0tJTEw7CgkJcmVxLT5jbWRfZmxhZ3MgfD0gUkVRX1FVSUVU
OwoJfQoJcmV0dXJuIHJldDsKCn0KCnN0YXRpYyBpbnQgcmRhY19jaGVja19zZW5zZShzdHJ1Y3Qg
c2NzaV9kZXZpY2UgKnNkZXYsCgkJCQlzdHJ1Y3Qgc2NzaV9zZW5zZV9oZHIgKnNlbnNlX2hkcikK
ewoJc3RydWN0IHJkYWNfZGhfZGF0YSAqaCA9IGdldF9yZGFjX2RhdGEoc2Rldik7CgkJCglSREFD
X0RFQlVHKFJEQUNfTE9HX1NFTlNFLCBzZGV2LCAiYXJyYXkgJXMsIGN0bHIgJWQsICIKCQkJImNv
bW1hbmQgcmV0dXJuZWQgd2l0aCBzZW5zZSAlMDJ4LyUwMngvJTAyeCIsCgkJCShjaGFyICopIGgt
PmN0bHItPmFycmF5X25hbWUsIGgtPmN0bHItPmluZGV4LAoJCQlzZW5zZV9oZHItPnNlbnNlX2tl
eSwgc2Vuc2VfaGRyLT5hc2MsIHNlbnNlX2hkci0+YXNjcSk7CgoJc3dpdGNoIChzZW5zZV9oZHIt
PnNlbnNlX2tleSkgewoJY2FzZSBOT1RfUkVBRFk6CgkJaWYgKHNlbnNlX2hkci0+YXNjID09IDB4
MDQgJiYgc2Vuc2VfaGRyLT5hc2NxID09IDB4MDEpCgkJCS8qIExVTiBOb3QgUmVhZHkgLSBMb2dp
Y2FsIFVuaXQgTm90IFJlYWR5IGFuZCBpcyBpbgoJCQkqIHRoZSBwcm9jZXNzIG9mIGJlY29taW5n
IHJlYWR5CgkJCSogSnVzdCByZXRyeS4KCQkJKi8KCQkJcmV0dXJuIEFERF9UT19NTFFVRVVFOwoJ
CWlmIChzZW5zZV9oZHItPmFzYyA9PSAweDA0ICYmIHNlbnNlX2hkci0+YXNjcSA9PSAweDgxKQoJ
CQkvKiBMVU4gTm90IFJlYWR5IC0gU3RvcmFnZSBmaXJtd2FyZSBpbmNvbXBhdGlibGUKCQkJICog
TWFudWFsIGNvZGUgc3luY2hvbmlzYXRpb24gcmVxdWlyZWQuCgkJCSAqCgkJCSAqIE5vdGhpbmcg
d2UgY2FuIGRvIGhlcmUuIFRyeSB0byBieXBhc3MgdGhlIHBhdGguCgkJCSAqLwoJCQlyZXR1cm4g
U1VDQ0VTUzsKCQlpZiAoc2Vuc2VfaGRyLT5hc2MgPT0gMHgwNCAmJiBzZW5zZV9oZHItPmFzY3Eg
PT0gMHhBMSkKCQkJLyogTFVOIE5vdCBSZWFkeSAtIFF1aWVzY2Vuc2UgaW4gcHJvZ3Jlc3MKCQkJ
ICoKCQkJICogSnVzdCByZXRyeSBhbmQgd2FpdC4KCQkJICovCgkJCXJldHVybiBBRERfVE9fTUxR
VUVVRTsKCQlpZiAoc2Vuc2VfaGRyLT5hc2MgPT0gMHhBMSAgJiYgc2Vuc2VfaGRyLT5hc2NxID09
IDB4MDIpCgkJCS8qIExVTiBOb3QgUmVhZHkgLSBRdWllc2NlbnNlIGluIHByb2dyZXNzCgkJCSAq
IG9yIGhhcyBiZWVuIGFjaGlldmVkCgkJCSAqIEp1c3QgcmV0cnkuCgkJCSAqLwoJCQlyZXR1cm4g
QUREX1RPX01MUVVFVUU7CgkJYnJlYWs7CgljYXNlIElMTEVHQUxfUkVRVUVTVDoKCQlpZiAoc2Vu
c2VfaGRyLT5hc2MgPT0gMHg5NCAmJiBzZW5zZV9oZHItPmFzY3EgPT0gMHgwMSkgewoJCQkvKiBJ
bnZhbGlkIFJlcXVlc3QgLSBDdXJyZW50IExvZ2ljYWwgVW5pdCBPd25lcnNoaXAuCgkJCSAqIENv
bnRyb2xsZXIgaXMgbm90IHRoZSBjdXJyZW50IG93bmVyIG9mIHRoZSBMVU4sCgkJCSAqIEZhaWwg
dGhlIHBhdGgsIHNvIHRoYXQgdGhlIG90aGVyIHBhdGggYmUgdXNlZC4KCQkJICovCgkJCWgtPnN0
YXRlID0gUkRBQ19TVEFURV9QQVNTSVZFOwoJCQlyZXR1cm4gU1VDQ0VTUzsKCQl9CgkJYnJlYWs7
CgljYXNlIFVOSVRfQVRURU5USU9OOgoJCWlmIChzZW5zZV9oZHItPmFzYyA9PSAweDI5ICYmIHNl
bnNlX2hkci0+YXNjcSA9PSAweDAwKQoJCQkvKgoJCQkgKiBQb3dlciBPbiwgUmVzZXQsIG9yIEJ1
cyBEZXZpY2UgUmVzZXQsIGp1c3QgcmV0cnkuCgkJCSAqLwoJCQlyZXR1cm4gQUREX1RPX01MUVVF
VUU7CgkJaWYgKHNlbnNlX2hkci0+YXNjID09IDB4OGIgJiYgc2Vuc2VfaGRyLT5hc2NxID09IDB4
MDIpCgkJCS8qCgkJCSAqIFF1aWVzY2VuY2UgaW4gcHJvZ3Jlc3MgLCBqdXN0IHJldHJ5LgoJCQkg
Ki8KCQkJcmV0dXJuIEFERF9UT19NTFFVRVVFOwoJCWJyZWFrOwoJfQoJLyogc3VjY2VzcyBqdXN0
IG1lYW5zIHdlIGRvIG5vdCBjYXJlIHdoYXQgc2NzaS1tbCBkb2VzICovCglyZXR1cm4gU0NTSV9S
RVRVUk5fTk9UX0hBTkRMRUQ7Cn0KCnN0YXRpYyBjb25zdCBzdHJ1Y3Qgc2NzaV9kaF9kZXZsaXN0
IHJkYWNfZGV2X2xpc3RbXSA9IHsKCXsiSUJNIiwgIjE3MjIifSwKCXsiSUJNIiwgIjE3MjQifSwK
CXsiSUJNIiwgIjE3MjYifSwKCXsiSUJNIiwgIjE3NDIifSwKCXsiSUJNIiwgIjE4MTQifSwKCXsi
SUJNIiwgIjE4MTUifSwKCXsiSUJNIiwgIjE4MTgifSwKCXsiSUJNIiwgIjM1MjYifSwKCXsiU0dJ
IiwgIlRQOTQwMCJ9LAoJeyJTR0kiLCAiVFA5NTAwIn0sCgl7IlNHSSIsICJJUyJ9LAoJeyJTVEsi
LCAiT1BFTnN0b3JhZ2UgRDI4MCJ9LAoJeyJTVU4iLCAiQ1NNMjAwX1IifSwKCXsiU1VOIiwgIkxD
U00xMDBfRiJ9LAoJeyJERUxMIiwgIk1EMzAwMCJ9LAoJeyJERUxMIiwgIk1EMzAwMGkifSwKCXsi
TFNJIiwgIklORi0wMS0wMCJ9LAoJeyJFTkdFTklPIiwgIklORi0wMS0wMCJ9LAoJe05VTEwsIE5V
TEx9LAp9OwoKc3RhdGljIGludCByZGFjX2J1c19hdHRhY2goc3RydWN0IHNjc2lfZGV2aWNlICpz
ZGV2KTsKc3RhdGljIHZvaWQgcmRhY19idXNfZGV0YWNoKHN0cnVjdCBzY3NpX2RldmljZSAqc2Rl
dik7CgpzdGF0aWMgc3RydWN0IHNjc2lfZGV2aWNlX2hhbmRsZXIgcmRhY19kaCA9IHsKCS5uYW1l
ID0gUkRBQ19OQU1FLAoJLm1vZHVsZSA9IFRISVNfTU9EVUxFLAoJLmRldmxpc3QgPSByZGFjX2Rl
dl9saXN0LAoJLnByZXBfZm4gPSByZGFjX3ByZXBfZm4sCgkuY2hlY2tfc2Vuc2UgPSByZGFjX2No
ZWNrX3NlbnNlLAoJLmF0dGFjaCA9IHJkYWNfYnVzX2F0dGFjaCwKCS5kZXRhY2ggPSByZGFjX2J1
c19kZXRhY2gsCgkuYWN0aXZhdGUgPSByZGFjX2FjdGl2YXRlLAp9OwoKc3RhdGljIGludCByZGFj
X2J1c19hdHRhY2goc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2KQp7CglzdHJ1Y3Qgc2NzaV9kaF9k
YXRhICpzY3NpX2RoX2RhdGE7CglzdHJ1Y3QgcmRhY19kaF9kYXRhICpoOwoJdW5zaWduZWQgbG9u
ZyBmbGFnczsKCWludCBlcnI7CgoJc2NzaV9kaF9kYXRhID0ga3phbGxvYyhzaXplb2Yoc3RydWN0
IHNjc2lfZGV2aWNlX2hhbmRsZXIgKikKCQkJICAgICAgICsgc2l6ZW9mKCpoKSAsIEdGUF9LRVJO
RUwpOwoJaWYgKCFzY3NpX2RoX2RhdGEpIHsKCQlzZGV2X3ByaW50ayhLRVJOX0VSUiwgc2Rldiwg
IiVzOiBBdHRhY2ggZmFpbGVkXG4iLAoJCQkgICAgUkRBQ19OQU1FKTsKCQlyZXR1cm4gMDsKCX0K
CglzY3NpX2RoX2RhdGEtPnNjc2lfZGggPSAmcmRhY19kaDsKCWggPSAoc3RydWN0IHJkYWNfZGhf
ZGF0YSAqKSBzY3NpX2RoX2RhdGEtPmJ1ZjsKCWgtPmx1biA9IFVOSU5JVElBTElaRURfTFVOOwoJ
aC0+c3RhdGUgPSBSREFDX1NUQVRFX0FDVElWRTsKCgllcnIgPSBnZXRfbHVuKHNkZXYsIGgpOwoJ
aWYgKGVyciAhPSBTQ1NJX0RIX09LKQoJCWdvdG8gZmFpbGVkOwoKCWVyciA9IGNoZWNrX293bmVy
c2hpcChzZGV2LCBoKTsKCWlmIChlcnIgIT0gU0NTSV9ESF9PSykKCQlnb3RvIGZhaWxlZDsKCglp
ZiAoIWgtPmN0bHIpIHsKCQllcnIgPSBpbml0aWFsaXplX2NvbnRyb2xsZXIoc2RldiwgaCk7CgkJ
aWYgKGVyciAhPSBTQ1NJX0RIX09LKQoJCQlnb3RvIGZhaWxlZDsKCQkKCQllcnIgPSBnZXRfYXJy
YXlfbmFtZShzZGV2LCBoKTsKCQlpZiAoZXJyICE9IFNDU0lfREhfT0spCgkJCWdvdG8gZmFpbGVk
OwoJfQoKCWlmICghdHJ5X21vZHVsZV9nZXQoVEhJU19NT0RVTEUpKQoJCWdvdG8gZmFpbGVkOwoK
CXNwaW5fbG9ja19pcnFzYXZlKHNkZXYtPnJlcXVlc3RfcXVldWUtPnF1ZXVlX2xvY2ssIGZsYWdz
KTsKCXNkZXYtPnNjc2lfZGhfZGF0YSA9IHNjc2lfZGhfZGF0YTsKCXNwaW5fdW5sb2NrX2lycXJl
c3RvcmUoc2Rldi0+cmVxdWVzdF9xdWV1ZS0+cXVldWVfbG9jaywgZmxhZ3MpOwoKCXNkZXZfcHJp
bnRrKEtFUk5fTk9USUNFLCBzZGV2LAoJCSAgICAiJXM6IExVTiAlZCAoJXMpXG4iLAoJCSAgICBS
REFDX05BTUUsIGgtPmx1biwgbHVuX3N0YXRlWyhpbnQpaC0+bHVuX3N0YXRlXSk7CgoJcmV0dXJu
IDA7CgpmYWlsZWQ6CglrZnJlZShzY3NpX2RoX2RhdGEpOwoJc2Rldl9wcmludGsoS0VSTl9FUlIs
IHNkZXYsICIlczogbm90IGF0dGFjaGVkXG4iLAoJCSAgICBSREFDX05BTUUpOwoJcmV0dXJuIC1F
SU5WQUw7Cn0KCnN0YXRpYyB2b2lkIHJkYWNfYnVzX2RldGFjaCggc3RydWN0IHNjc2lfZGV2aWNl
ICpzZGV2ICkKewoJc3RydWN0IHNjc2lfZGhfZGF0YSAqc2NzaV9kaF9kYXRhOwoJc3RydWN0IHJk
YWNfZGhfZGF0YSAqaDsKCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CgoJc3Bpbl9sb2NrX2lycXNhdmUo
c2Rldi0+cmVxdWVzdF9xdWV1ZS0+cXVldWVfbG9jaywgZmxhZ3MpOwoJc2NzaV9kaF9kYXRhID0g
c2Rldi0+c2NzaV9kaF9kYXRhOwoJc2Rldi0+c2NzaV9kaF9kYXRhID0gTlVMTDsKCXNwaW5fdW5s
b2NrX2lycXJlc3RvcmUoc2Rldi0+cmVxdWVzdF9xdWV1ZS0+cXVldWVfbG9jaywgZmxhZ3MpOwoK
CWggPSAoc3RydWN0IHJkYWNfZGhfZGF0YSAqKSBzY3NpX2RoX2RhdGEtPmJ1ZjsKCWlmIChoLT5j
dGxyKQoJCWtyZWZfcHV0KCZoLT5jdGxyLT5rcmVmLCByZWxlYXNlX2NvbnRyb2xsZXIpOwoJa2Zy
ZWUoc2NzaV9kaF9kYXRhKTsKCW1vZHVsZV9wdXQoVEhJU19NT0RVTEUpOwoJc2Rldl9wcmludGso
S0VSTl9OT1RJQ0UsIHNkZXYsICIlczogRGV0YWNoZWRcbiIsIFJEQUNfTkFNRSk7Cn0KCgoKc3Rh
dGljIGludCBfX2luaXQgcmRhY19pbml0KHZvaWQpCnsKCWludCByOwoKCXIgPSBzY3NpX3JlZ2lz
dGVyX2RldmljZV9oYW5kbGVyKCZyZGFjX2RoKTsKCWlmIChyICE9IDApCgkJcHJpbnRrKEtFUk5f
RVJSICJGYWlsZWQgdG8gcmVnaXN0ZXIgc2NzaSBkZXZpY2UgaGFuZGxlci4iKTsKCXJldHVybiBy
Owp9CgpzdGF0aWMgdm9pZCBfX2V4aXQgcmRhY19leGl0KHZvaWQpCnsKCXNjc2lfdW5yZWdpc3Rl
cl9kZXZpY2VfaGFuZGxlcigmcmRhY19kaCk7Cn0KCm1vZHVsZV9pbml0KHJkYWNfaW5pdCk7Cm1v
ZHVsZV9leGl0KHJkYWNfZXhpdCk7CgpNT0RVTEVfREVTQ1JJUFRJT04oIk11bHRpcGF0aCBMU0kv
RW5nZW5pbyBSREFDIGRyaXZlciIpOwpNT0RVTEVfQVVUSE9SKCJNaWtlIENocmlzdGllLCBDaGFu
ZHJhIFNlZXRoYXJhbWFuIik7Ck1PRFVMRV9MSUNFTlNFKCJHUEwiKTsK

--_004_E463DF2B2E584B4A82673F53D62C2EF474B79EF1cosmail01lsicom_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--_004_E463DF2B2E584B4A82673F53D62C2EF474B79EF1cosmail01lsicom_--
