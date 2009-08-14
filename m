From: Stewart Smith <stew@cleepdar.com>
Subject: Re: rdac path failure - Sun 6140
Date: Fri, 14 Aug 2009 08:58:00 -0700
Message-ID: <f7500f4e0908140858n327f2c29rcc01f39a5e263827@mail.gmail.com>
References: <f7500f4e0908131150r54b21a0dr9cb7d4a8456e69e8@mail.gmail.com>
	<E463DF2B2E584B4A82673F53D62C2EF474AEB7FC@cosmail01.lsi.com>
	<f7500f4e0908131327x442a5ddfkc6e2aef58cf5bbfc@mail.gmail.com>
	<f7500f4e0908131334u39831f68i2eeccc77953ba786@mail.gmail.com>
	<E463DF2B2E584B4A82673F53D62C2EF474B79EF1@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474B79EF1@cosmail01.lsi.com>
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
List-Id: dm-devel.ids

I will test this today.

Does everything look OK from a configuration standpoint?  Should the
RDAC virtual HBA drivers from LSI be a requirement?  I am not
currently using them.

Thank you,
--
Stew




On Thu, Aug 13, 2009 at 5:05 PM, Moger, Babu<Babu.Moger@lsi.com> wrote:
> Stew,
>
> =A0=A0=A0=A0 I don=92t see much information about this failure in the l=
ogs. Right now
> device handlers don=92t provide much information on failures. =A0We are=
 working
> on to add some more debug levels. =A0I am attaching my draft code
> (scsi_dh_rdac.c) here. =A0Please use this only for your testing. It is =
not
> been approved/reviewed yet. I still need to submit this one to communit=
y for
> approval. The code is attached.=A0 Please replace this file with
> scsi_dh_rdac.c in the directory /driver/scsi/device_handlers and rebuil=
d the
> kernel. =A0This should give more information from the target point of v=
iew.
> Please send me the /var/log/messages file after the failure. Let see if=
 we
> can get more information..
>
>
>
> Thanks
>
> Babu Moger
>
> ________________________________
>
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] =
On
> Behalf Of Stewart Smith
> Sent: Thursday, August 13, 2009 3:35 PM
> To: device-mapper development
> Subject: Re: [dm-devel] rdac path failure - Sun 6140
>
>
>
>
>
> Same sequence of events, with multipathd -v3
>
>
>
> Aug 13 16:28:48.627 =A0kernel: device-mapper: multipath: Failing path 8=
:208.
>
> Aug 13 16:28:48.000 =A0multipathd: vol1: rr_weight =3D 2 (LUN setting)
>
> Aug 13 16:28:48.000 =A0multipathd: vol1: pgfailback =3D -2 (controller =
setting)
>
> Aug 13 16:28:48.000 =A0multipathd: pg_timeout =3D NONE (internal defaul=
t)
>
> Aug 13 16:28:48.000 =A0multipathd: 8:208: mark as failed
>
> Aug 13 16:28:48.000 =A0multipathd: uevent 'change' from
> '/devices/virtual/block/dm-1'
>
> Aug 13 16:28:48.000 =A0multipathd: UDEV_LOG=3D3
>
> Aug 13 16:28:48.000 =A0multipathd: ACTION=3Dchange
>
> Aug 13 16:28:48.000 =A0multipathd: DEVPATH=3D/devices/virtual/block/dm-=
1
>
> Aug 13 16:28:48.000 =A0multipathd: SUBSYSTEM=3Dblock
>
> Aug 13 16:28:48.000 =A0multipathd: DM_TARGET=3Dmultipath
>
> Aug 13 16:28:48.000 =A0multipathd: DM_ACTION=3DPATH_FAILED
>
> Aug 13 16:28:48.000 =A0multipathd: DM_SEQNUM=3D1
>
> Aug 13 16:28:48.000 =A0multipathd: DM_PATH=3D8:208
>
> Aug 13 16:28:48.000 =A0multipathd: DM_NR_VALID_PATHS=3D3
>
> Aug 13 16:28:48.000 =A0multipathd: DM_NAME=3Dvol1
>
> Aug 13 16:28:48.000 =A0multipathd:
> DM_UUID=3Dmpath-3600a0b800048335200001e5d48b68a9b
>
> Aug 13 16:28:48.000 =A0multipathd: MAJOR=3D253
>
> Aug 13 16:28:48.000 =A0multipathd: MINOR=3D1
>
> Aug 13 16:28:48.000 =A0multipathd: DEVTYPE=3Ddisk
>
> Aug 13 16:28:48.000 =A0multipathd: SEQNUM=3D1738
>
> Aug 13 16:28:48.000 =A0multipathd: UDEVD_EVENT=3D1
>
> Aug 13 16:28:48.000 =A0multipathd: DEVNAME=3D/dev/dm-1
>
> Aug 13 16:28:50.000 =A0multipathd: 8:208: reinstated
>
> Aug 13 16:28:50.000 =A0multipathd: vol1: remaining active paths: 4
>
> Aug 13 16:28:50.000 =A0multipathd: sdj: rdac prio =3D 3
>
> Aug 13 16:28:50.000 =A0multipathd: sdn: rdac prio =3D 3
>
> Aug 13 16:28:50.000 =A0multipathd: sdb: rdac prio =3D 0
>
> Aug 13 16:28:50.000 =A0multipathd: sdd: rdac prio =3D 0
>
> Aug 13 16:28:50.763 =A0kernel: device-mapper: multipath: Failing path 8=
:208.
>
> Aug 13 16:28:50.000 =A0multipathd: uevent 'change' from
> '/devices/virtual/block/dm-1'
>
> Aug 13 16:28:50.000 =A0multipathd: UDEV_LOG=3D3
>
> Aug 13 16:28:50.000 =A0multipathd: ACTION=3Dchange
>
> Aug 13 16:28:50.000 =A0multipathd: DEVPATH=3D/devices/virtual/block/dm-=
1
>
> Aug 13 16:28:50.000 =A0multipathd: SUBSYSTEM=3Dblock
>
> Aug 13 16:28:50.000 =A0multipathd: DM_TARGET=3Dmultipath
>
> Aug 13 16:28:50.000 =A0multipathd: DM_ACTION=3DPATH_REINSTATED
>
> Aug 13 16:28:50.000 =A0multipathd: DM_SEQNUM=3D2
>
> Aug 13 16:28:50.000 =A0multipathd: DM_PATH=3D8:208
>
> Aug 13 16:28:50.000 =A0multipathd: DM_NR_VALID_PATHS=3D4
>
> Aug 13 16:28:50.000 =A0multipathd: DM_NAME=3Dvol1
>
> Aug 13 16:28:50.000 =A0multipathd:
> DM_UUID=3Dmpath-3600a0b800048335200001e5d48b68a9b
>
> Aug 13 16:28:50.000 =A0multipathd: MAJOR=3D253
>
> Aug 13 16:28:50.000 =A0multipathd: MINOR=3D1
>
> Aug 13 16:28:50.000 =A0multipathd: DEVTYPE=3DdiskAug 13 16:28:50.000
> =A0multipathd: SEQNUM=3D1739Aug 13 16:28:50.000 =A0multipathd: UDEVD_EV=
ENT=3D1
>
> Aug 13 16:28:50.000 =A0multipathd: vol1: rr_weight =3D 2 (LUN setting)
>
> Aug 13 16:28:50.000 =A0multipathd: vol1: pgfailback =3D -2 (controller =
setting)
>
> Aug 13 16:28:50.000 =A0multipathd: pg_timeout =3D NONE (internal defaul=
t)
>
> Aug 13 16:28:50.000 =A0multipathd: 8:208: mark as failed
>
> Aug 13 16:28:50.000 =A0multipathd: vol1: remaining active paths: 3
>
> Aug 13 16:28:50.000 =A0multipathd: vol1: rr_weight =3D 2 (LUN setting)
>
> Aug 13 16:28:50.000 =A0multipathd: vol1: pgfailback =3D -2 (controller =
setting)
>
> Aug 13 16:28:50.000 =A0multipathd: uevent 'change' from
> '/devices/virtual/block/dm-1'
>
> Aug 13 16:28:50.000 =A0multipathd: UDEV_LOG=3D3
>
> Aug 13 16:28:50.000 =A0multipathd: ACTION=3Dchange
>
> Aug 13 16:28:50.000 =A0multipathd: DEVPATH=3D/devices/virtual/block/dm-=
1
>
> Aug 13 16:28:50.000 =A0multipathd: SUBSYSTEM=3Dblock
>
> Aug 13 16:28:50.000 =A0multipathd: DM_TARGET=3Dmultipath
>
> Aug 13 16:28:50.000 =A0multipathd: DM_ACTION=3DPATH_FAILED
>
> Aug 13 16:28:50.000 =A0multipathd: DM_SEQNUM=3D3
>
> Aug 13 16:28:50.000 =A0multipathd: DM_PATH=3D8:208
>
> Aug 13 16:28:50.000 =A0multipathd: DM_NR_VALID_PATHS=3D3
>
> Aug 13 16:28:50.000 =A0multipathd: DM_NAME=3Dvol1
>
> Aug 13 16:28:50.000 =A0multipathd:
> DM_UUID=3Dmpath-3600a0b800048335200001e5d48b68a9b
>
> Aug 13 16:28:50.000 =A0multipathd: MAJOR=3D253
>
> Aug 13 16:28:50.000 =A0multipathd: MINOR=3D1
>
> Aug 13 16:28:50.000 =A0multipathd: DEVTYPE=3Ddisk
>
> Aug 13 16:28:50.000 =A0multipathd: SEQNUM=3D1740
>
> Aug 13 16:28:50.000 =A0multipathd: UDEVD_EVENT=3D1
>
> Aug 13 16:28:50.000 =A0multipathd: DEVNAME=3D/dev/dm-1
>
> Aug 13 16:29:00.000 =A0multipathd: 8:208: reinstated
>
> Aug 13 16:29:00.000 =A0multipathd: vol1: remaining active paths: 4
>
> Aug 13 16:29:00.000 =A0multipathd: sdj: rdac prio =3D 3
>
> Aug 13 16:29:00.000 =A0multipathd: sdn: rdac prio =3D 3
>
> Aug 13 16:29:00.000 =A0multipathd: sdb: rdac prio =3D 0
>
> Aug 13 16:29:00.000 =A0multipathd: sdd: rdac prio =3D 0
>
> Aug 13 16:29:00.000 =A0multipathd: vol1: rr_weight =3D 2 (LUN setting)
>
> Aug 13 16:29:00.000 =A0multipathd: vol1: pgfailback =3D -2 (controller =
setting)
>
> Aug 13 16:29:00.000 =A0multipathd: uevent 'change' from
> '/devices/virtual/block/dm-1'
>
> Aug 13 16:29:00.000 =A0multipathd: UDEV_LOG=3D3
>
> Aug 13 16:29:00.000 =A0multipathd: ACTION=3Dchange
>
> Aug 13 16:29:00.000 =A0multipathd: DEVPATH=3D/devices/virtual/block/dm-=
1
>
> Aug 13 16:29:00.000 =A0multipathd: SUBSYSTEM=3Dblock
>
> Aug 13 16:29:00.000 =A0multipathd: DM_TARGET=3Dmultipath
>
> Aug 13 16:29:00.000 =A0multipathd: DM_ACTION=3DPATH_REINSTATED
>
> Aug 13 16:29:00.000 =A0multipathd: DM_SEQNUM=3D4
>
> Aug 13 16:29:00.000 =A0multipathd: DM_PATH=3D8:208
>
> Aug 13 16:29:00.000 =A0multipathd: DM_NR_VALID_PATHS=3D4
>
> Aug 13 16:29:00.000 =A0multipathd: DM_NAME=3Dvol1
>
> Aug 13 16:29:00.000 =A0multipathd:
> DM_UUID=3Dmpath-3600a0b800048335200001e5d48b68a9b
>
> Aug 13 16:29:00.000 =A0multipathd: MAJOR=3D253
>
> Aug 13 16:29:00.000 =A0multipathd: MINOR=3D1
>
> Aug 13 16:29:00.000 =A0multipathd: DEVTYPE=3Ddisk
>
> Aug 13 16:29:00.000 =A0multipathd: SEQNUM=3D1741
>
> Aug 13 16:29:00.000 =A0multipathd: UDEVD_EVENT=3D1
>
> Aug 13 16:29:00.000 =A0multipathd: DEVNAME=3D/dev/dm-1
>
> Aug 13 16:29:02.753 =A0kernel: device-mapper: multipath: Failing path 8=
:208.
>
> Aug 13 16:29:02.000 =A0multipathd: vol1: rr_weight =3D 2 (LUN setting)
>
> Aug 13 16:29:02.000 =A0multipathd: vol1: pgfailback =3D -2 (controller =
setting)
>
> Aug 13 16:29:02.000 =A0multipathd: pg_timeout =3D NONE (internal defaul=
t)
>
> Aug 13 16:29:02.000 =A0multipathd: 8:208: mark as failed
>
> Aug 13 16:29:02.000 =A0multipathd: uevent 'change' from
> '/devices/virtual/block/dm-1'
>
> Aug 13 16:29:02.000 =A0multipathd: UDEV_LOG=3D3
>
> Aug 13 16:29:02.000 =A0multipathd: ACTION=3Dchange
>
> Aug 13 16:29:02.000 =A0multipathd: DEVPATH=3D/devices/virtual/block/dm-=
1
>
> Aug 13 16:29:02.000 =A0multipathd: SUBSYSTEM=3Dblock
>
> Aug 13 16:29:02.000 =A0multipathd: DM_TARGET=3Dmultipath
>
> Aug 13 16:29:02.000 =A0multipathd: DM_ACTION=3DPATH_FAILED
>
> Aug 13 16:29:02.000 =A0multipathd: DM_SEQNUM=3D5
>
> Aug 13 16:29:02.000 =A0multipathd: DM_PATH=3D8:208
>
> Aug 13 16:29:02.000 =A0multipathd: DM_NR_VALID_PATHS=3D3
>
> Aug 13 16:29:02.000 =A0multipathd: DM_NAME=3Dvol1
>
> Aug 13 16:29:02.000 =A0multipathd:
> DM_UUID=3Dmpath-3600a0b800048335200001e5d48b68a9b
>
> Aug 13 16:29:02.000 =A0multipathd: MAJOR=3D253
>
> Aug 13 16:29:02.000 =A0multipathd: MINOR=3D1
>
> Aug 13 16:29:02.000 =A0multipathd: DEVTYPE=3Ddisk
>
> Aug 13 16:29:02.000 =A0multipathd: SEQNUM=3D1742
>
> Aug 13 16:29:02.000 =A0multipathd: UDEVD_EVENT=3D1
>
> Aug 13 16:29:02.000 =A0multipathd: DEVNAME=3D/dev/dm-1
>
> Aug 13 16:29:10.000 =A0multipathd: 8:208: reinstated
>
> Aug 13 16:29:10.000 =A0multipathd: vol1: remaining active paths: 4
>
> Aug 13 16:29:10.000 =A0multipathd: sdj: rdac prio =3D 3
>
> Aug 13 16:29:10.000 =A0multipathd: sdn: rdac prio =3D 3
>
> Aug 13 16:29:10.000 =A0multipathd: sdb: rdac prio =3D 0
>
> Aug 13 16:29:10.000 =A0multipathd: sdd: rdac prio =3D 0
>
> Aug 13 16:29:10.000 =A0multipathd: vol1: rr_weight =3D 2 (LUN setting)
>
> Aug 13 16:29:10.000 =A0multipathd: vol1: pgfailback =3D -2 (controller =
setting)
>
> Aug 13 16:29:10.000 =A0multipathd: uevent 'change' from
> '/devices/virtual/block/dm-1'
>
> Aug 13 16:29:10.000 =A0multipathd: UDEV_LOG=3D3
>
> Aug 13 16:29:10.000 =A0multipathd: ACTION=3Dchange
>
> Aug 13 16:29:10.000 =A0multipathd: DEVPATH=3D/devices/virtual/block/dm-=
1
>
> Aug 13 16:29:10.000 =A0multipathd: SUBSYSTEM=3Dblock
>
> Aug 13 16:29:10.000 =A0multipathd: DM_TARGET=3Dmultipath
>
> Aug 13 16:29:10.000 =A0multipathd: DM_ACTION=3DPATH_REINSTATED
>
> Aug 13 16:29:10.000 =A0multipathd: DM_SEQNUM=3D6
>
> Aug 13 16:29:10.000 =A0multipathd: DM_PATH=3D8:208
>
> Aug 13 16:29:10.000 =A0multipathd: DM_NR_VALID_PATHS=3D4
>
> Aug 13 16:29:10.000 =A0multipathd: DM_NAME=3Dvol1
>
> Aug 13 16:29:10.000 =A0multipathd:
> DM_UUID=3Dmpath-3600a0b800048335200001e5d48b68a9b
>
> Aug 13 16:29:10.000 =A0multipathd: MAJOR=3D253
>
> Aug 13 16:29:10.000 =A0multipathd: MINOR=3D1
>
> Aug 13 16:29:10.000 =A0multipathd: DEVTYPE=3Ddisk
>
> Aug 13 16:29:10.000 =A0multipathd: SEQNUM=3D1743
>
> Aug 13 16:29:10.000 =A0multipathd: UDEVD_EVENT=3D1
>
> Aug 13 16:29:10.000 =A0multipathd: DEVNAME=3D/dev/dm-1
>
>
>
>
>
>
>
>
>
> On Thu, Aug 13, 2009 at 1:27 PM, Stewart Smith <stew@cleepdar.com> wrot=
e:
>
>
>
> after a fresh, multipath -F and start of multipathd with -v 2 I see the
> following messages.
>
>
>
> After starting multipathd I mounted /dev/mapper/vol1 and generated some
> simple I/O to it using dd
>
>
>
>
>
> Aug 13 16:23:14.888 localhost kernel: device-mapper: multipath: Failing=
 path
> 8:208.
>
> Aug 13 16:23:14.000 localhost multipathd: 8:208: mark as failed
>
> Aug 13 16:23:16.000 localhost multipathd: 8:208: reinstated
>
> Aug 13 16:23:30.462 localhost kernel: device-mapper: multipath: Failing=
 path
> 8:208.
>
> Aug 13 16:23:30.000 localhost multipathd: 8:208: mark as failed
>
> Aug 13 16:23:39.000 localhost multipathd: 8:208: reinstated
>
> Aug 13 16:23:46.430 localhost kernel: device-mapper: multipath: Failing=
 path
> 8:208.
>
> Aug 13 16:23:46.000 localhost multipathd: 8:208: mark as failed
>
> Aug 13 16:23:51.041 localhost kernel: device-mapper: multipath: Failing=
 path
> 8:208.
>
> Aug 13 16:23:51.000 localhost multipathd: 8:208: mark as failed
>
> Aug 13 16:23:59.000 localhost multipathd: 8:208: reinstated
>
> Aug 13 16:24:06.465 localhost kernel: device-mapper: multipath: Failing=
 path
> 8:208.
>
> Aug 13 16:24:06.000 localhost multipathd: 8:208: mark as failed
>
> Aug 13 16:24:09.000 localhost multipathd: 8:208: reinstated
>
>
>
>
>
> Thanks,
>
> --
>
> Stew
>
>
>
>
>
>
>
> On Thu, Aug 13, 2009 at 12:42 PM, Moger, Babu <Babu.Moger@lsi.com> wrot=
e:
>
> Do you have /var/log/messages file for this problem?
>
> Thanks
> Babu Moger
>
>> -----Original Message-----
>> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]=
 On
>> Behalf Of Stewart Smith
>> Sent: Thursday, August 13, 2009 1:51 PM
>> To: dm-devel@redhat.com
>> Subject: [dm-devel] rdac path failure - Sun 6140
>>
>> Hello All,
>>
>> I am seeing many of these messages when my Sun 6140 array is under hea=
vy
>> I/O
>> device-mapper: multipath: Failing path 8:208.
>> device-mapper: multipath: Failing path 8:208.
>> device-mapper: multipath: Failing path 8:208.
>> device-mapper: multipath: Failing path 8:208.
>> device-mapper: multipath: Failing path 8:208.
>>
>>
>> I am running a Fedora 10 server, with two fiber connections to two
>> different switches.=A0=A0Both=A0controllers on the 6140 have one conne=
ction
>> to each switch as well. =A0The end result is that I see four paths to
>> each LUN.
>>
>> When the volume is mounted and under significant load I see the
>> messages above every few seconds. =A0They seem to appear every
>> "no_path_retry" seconds.
>>
>> The 6140 controller firmware is up to date at version 07.50.08.10 and
>> I have installed the latest firmware for my Emulex LPe11002 cards. =A0=
I
>> have reproduced the problem using both Cisco MDS and Brocade fiber
>> channel switches as well.
>>
>> Using CAM, I have set the initiator Host Type to "Linux" at the
>> moment. =A0I have tried other options as well without success.
>>
>> I have NOT installed the RDAC drivers from either Sun or LSI -
>> primarily because they do not seem to build on my Fedora 10 kernel.
>>
>> Any ideas would be greatly appreciated!!!
>>
>> configs and debugging multipathd output is below.
>>
>>
>>
>>
>>
>> Kernel: 2.6.27.24-170.2.68.fc10.x86_64
>>
>> # multipath -lll
>> vol1 (3600a0b800048335200001e5d48b68a9b) dm-1 SUN,CSM200_R
>> [size=3D12T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac][rw]
>> \_ round-robin 0 [prio=3D6][active]
>> =A0\_ 5:0:1:2 sdj 8:144 [active][ready]
>> =A0\_ 2:0:1:2 sdn 8:208 [active][ready]
>> \_ round-robin 0 [prio=3D0][enabled]
>> =A0\_ 2:0:0:2 sdb 8:16 =A0[active][ghost]
>> =A0\_ 5:0:0:2 sdd 8:48 =A0[active][ghost]
>>
>>
>> # cat /etc/multipath.conf
>>
>> blacklist {
>> =A0 =A0 =A0 =A0 devnode "^sd[a-z][[0-9]*]"
>> =A0 =A0 =A0 =A0 devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
>> =A0 =A0 =A0 =A0 devnode "^hd[a-z][0-9]*"
>> =A0 =A0 =A0 =A0 devnode "^cciss!c[0-9]d[0-9](p[0-9]*)*"
>> }
>>
>> defaults {
>> =A0 =A0 =A0 =A0 udev_dir =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/dev
>> =A0 =A0 =A0 =A0 polling_interval =A0 =A0 =A0 =A010
>> =A0 =A0 =A0 =A0 selector =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"round-robin 0=
"
>> =A0 =A0 =A0 =A0 path_grouping_policy =A0 =A0multibus
>> =A0 =A0 =A0 =A0 getuid_callout =A0 =A0 =A0 =A0 =A0"/sbin/scsi_id --whi=
telisted /dev/%n"
>> =A0 =A0 =A0 =A0 prio =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0alua
>> =A0 =A0 =A0 =A0 path_checker =A0 =A0 =A0 =A0 =A0 =A0readsector0
>> =A0 =A0 =A0 =A0 rr_min_io =A0 =A0 =A0 =A0 =A0 =A0 =A0 100
>> =A0 =A0 =A0 =A0 max_fds =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 8192
>> =A0 =A0 =A0 =A0 rr_weight =A0 =A0 =A0 =A0 =A0 =A0 =A0 priorities
>> =A0 =A0 =A0 =A0 failback =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0immediate
>> =A0 =A0 =A0 =A0 no_path_retry =A0 =A0 =A0 =A0 =A0 fail
>> =A0 =A0 =A0 =A0 user_friendly_names =A0 =A0 yes
>> }
>> devices {
>> =A0 =A0 =A0 =A0 device {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vendor =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0"SUN"
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 product =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 "CSM200_R"
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 product_blacklist =A0 =A0 =A0 "Univers=
al Xport"
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 getuid_callout =A0 =A0 =A0 =A0 =A0"/sb=
in/scsi_id --whitelisted
>> /dev/%n"
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 features =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
"0"
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hardware_handler =A0 =A0 =A0 =A0"1 rda=
c"
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path_selector =A0 =A0 =A0 =A0 =A0 "rou=
nd-robin 0"
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path_grouping_policy =A0 =A0group_by_p=
rio
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 failback =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
immediate
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rr_weight =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
uniform
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 no_path_retry =A0 =A0 =A0 =A0 =A0 queu=
e
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rr_min_io =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
1000
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path_checker =A0 =A0 =A0 =A0 =A0 =A0rd=
ac
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 prio =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0rdac
>> =A0 =A0 =A0 =A0 }
>> }
>>
>> multipaths {
>> =A0 =A0 =A0 =A0 multipath {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wwid =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A03600a0b800048335200001e5d48b68a9b
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 alias =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 vol1
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rr_weight =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
priorities
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 no_path_retry =A0 =A0 =A0 =A0 =A0 5
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rr_min_io =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
100
>> =A0 =A0 =A0 =A0 }
>> }
>>
>>
>>
>> # multipathd -d v3
>>
>>
>> Aug 13 14:48:53 | sdb: ownership set to vol1
>> Aug 13 14:48:53 | sdb: not found in pathvec
>> Aug 13 14:48:53 | sdb: mask =3D 0xc
>> Aug 13 14:48:53 | sdb: path checker =3D rdac (controller setting)
>> Aug 13 14:48:53 | sdb: state =3D 4
>> Aug 13 14:48:53 | sdb: rdac prio =3D 0
>> Aug 13 14:48:53 | sdd: ownership set to vol1
>> Aug 13 14:48:53 | sdd: not found in pathvec
>> Aug 13 14:48:53 | sdd: mask =3D 0xc
>> Aug 13 14:48:53 | sdd: path checker =3D rdac (controller setting)
>> Aug 13 14:48:53 | sdd: state =3D 4
>> Aug 13 14:48:53 | sdd: rdac prio =3D 0
>> Aug 13 14:48:53 | sdj: ownership set to vol1
>> Aug 13 14:48:53 | sdj: not found in pathvec
>> Aug 13 14:48:53 | sdj: mask =3D 0xc
>> Aug 13 14:48:53 | sdj: path checker =3D rdac (controller setting)
>> Aug 13 14:48:53 | sdj: state =3D 2
>> Aug 13 14:48:53 | sdj: rdac prio =3D 3
>> Aug 13 14:48:53 | sdn: ownership set to vol1
>> Aug 13 14:48:53 | sdn: not found in pathvec
>> Aug 13 14:48:53 | sdn: mask =3D 0xc
>> Aug 13 14:48:53 | sdn: path checker =3D rdac (controller setting)
>> Aug 13 14:48:53 | sdn: state =3D 2
>> Aug 13 14:48:53 | sdn: rdac prio =3D 3
>> Aug 13 14:48:53 | vol1: pgfailback =3D -2 (controller setting)
>> Aug 13 14:48:53 | vol1: pgpolicy =3D group_by_prio (controller setting=
)
>> Aug 13 14:48:53 | vol1: selector =3D round-robin 0 (controller setting=
)
>> Aug 13 14:48:53 | vol1: features =3D 0 (controller setting)
>> Aug 13 14:48:53 | vol1: hwhandler =3D 1 rdac (controller setting)
>> Aug 13 14:48:53 | vol1: rr_weight =3D 2 (LUN setting)
>> Aug 13 14:48:53 | vol1: minio =3D 100 (LUN setting)
>> Aug 13 14:48:53 | vol1: no_path_retry =3D 5 (multipath setting)
>> Aug 13 14:48:53 | pg_timeout =3D NONE (internal default)
>> Aug 13 14:48:53 | vol1: set ACT_CREATE (map does not exist)
>> create: vol1 (3600a0b800048335200001e5d48b68a9b) n/a SUN,CSM200_R
>> [size=3D12T][features=3D0][hwhandler=3D1 rdac][n/a]
>> \_ round-robin 0 [prio=3D6][undef]
>> =A0\_ 5:0:1:2 sdj 8:144 [undef][ready]
>> =A0\_ 2:0:1:2 sdn 8:208 [undef][ready]
>> \_ round-robin 0 [prio=3D0][undef]
>> =A0\_ 2:0:0:2 sdb 8:16 [undef][ghost]
>> =A0\_ 5:0:0:2 sdd 8:48 [undef][ghost]
>>
>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
>
>
>
