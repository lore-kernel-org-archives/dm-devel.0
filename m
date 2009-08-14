From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: rdac path failure - Sun 6140
Date: Fri, 14 Aug 2009 15:22:23 -0700
Message-ID: <1250288543.30287.4.camel@chandra-ubuntu>
References: <f7500f4e0908131150r54b21a0dr9cb7d4a8456e69e8@mail.gmail.com>
	<E463DF2B2E584B4A82673F53D62C2EF474AEB7FC@cosmail01.lsi.com>
	<f7500f4e0908131327x442a5ddfkc6e2aef58cf5bbfc@mail.gmail.com>
	<f7500f4e0908131334u39831f68i2eeccc77953ba786@mail.gmail.com>
	<E463DF2B2E584B4A82673F53D62C2EF474B79EF1@cosmail01.lsi.com>
	<f7500f4e0908140858n327f2c29rcc01f39a5e263827@mail.gmail.com>
	<E463DF2B2E584B4A82673F53D62C2EF474B7A04A@cosmail01.lsi.com>
	<f7500f4e0908141326p4f4ccb30t3691b69e5034fd48@mail.gmail.com>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f7500f4e0908141326p4f4ccb30t3691b69e5034fd48@mail.gmail.com>
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


On Fri, 2009-08-14 at 13:26 -0700, Stewart Smith wrote:
> Interesting.
>=20
> I just grabbed 2.6.30.4 from kernel.org and I can no longer reproduce
> the issue with that kernel.  I did not add in your debugging version
> of scsi_dh_rdac.c yet.
>=20
> Somewhere between vmlinuz-2.6.29.4-167.fc11 and the generic 2.6.30.4
> (using the same kernel .config) this problem was fixed.

That is good :)

I do not have a fc11 install.... If it is not a hassle, can you send  a
diff of scsi_dh_rdac.c and dm-mpath.c, we should understand what fixed
the problem.
>=20
> Its now running over 350 MB/s with 16 sequential writers using both
> active paths.
>=20
>=20
>=20
>=20
> # fio --filename=3D/san0/vol1/test --direct=3D1 --rw=3Dwrite --bs=3D8m
> --size=3D32G --numjobs=3D16 --runtime=3D60 --group_reporting --name=3Df=
ile1
>=20
> Run status group 0 (all jobs):
>   WRITE: io=3D21,416MiB, aggrb=3D355MiB/s, minb=3D355MiB/s, maxb=3D355M=
iB/s,
> mint=3D60342msec, maxt=3D60342msec
>=20
> Disk stats (read/write):
>   dm-1: ios=3D3/85697, merge=3D0/0, ticks=3D11/21809639, in_queue=3D218=
10085,
> util=3D99.94%, aggrios=3D0/11402, aggrmerge=3D0/10022, aggrticks=3D2/28=
05880,
> aggrin_queue=3D2805875, aggrutil=3D97.09%
>     sdf: ios=3D0/22732, merge=3D0/20168, ticks=3D0/6090166,
> in_queue=3D6090145, util=3D97.09%
>     sdn: ios=3D3/22876, merge=3D0/19921, ticks=3D11/5133355,
> in_queue=3D5133356, util=3D96.16%
>     sdb: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.00=
%
>     sdj: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.00=
%
>=20
>=20
> Thanks!
> --
> Stewart
>=20
>=20
>=20
>=20
> On Fri, Aug 14, 2009 at 9:21 AM, Moger, Babu<Babu.Moger@lsi.com> wrote:
> >> -----Original Message-----
> >> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.co=
m] On
> >> Behalf Of Stewart Smith
> >> Sent: Friday, August 14, 2009 10:58 AM
> >> To: device-mapper development
> >> Subject: Re: [dm-devel] rdac path failure - Sun 6140
> >>
> >> I will test this today.
> >>
> >> Does everything look OK from a configuration standpoint?  Should the
> >
> >  I have verified your configuration file. It looks fine..
> >
> >> RDAC virtual HBA drivers from LSI be a requirement?  I am not
> >> currently using them.
> >
> >  You can't use both the solutions at once. You are fine..
> >
> >> Thank you,
> >> --
> >> Stew
> >>
> >>
> >>
> >>
> >> On Thu, Aug 13, 2009 at 5:05 PM, Moger, Babu<Babu.Moger@lsi.com> wro=
te:
> >> > Stew,
> >> >
> >> >      I don=E2=80=99t see much information about this failure in th=
e logs. Right
> >> now
> >> > device handlers don=E2=80=99t provide much information on failures=
.  We are
> >> working
> >> > on to add some more debug levels.  I am attaching my draft code
> >> > (scsi_dh_rdac.c) here.  Please use this only for your testing. It =
is not
> >> > been approved/reviewed yet. I still need to submit this one to com=
munity
> >> for
> >> > approval. The code is attached.  Please replace this file with
> >> > scsi_dh_rdac.c in the directory /driver/scsi/device_handlers and r=
ebuild
> >> the
> >> > kernel.  This should give more information from the target point o=
f
> >> view.
> >> > Please send me the /var/log/messages file after the failure. Let s=
ee if
> >> we
> >> > can get more information..
> >> >
> >> >
> >> >
> >> > Thanks
> >> >
> >> > Babu Moger
> >> >
> >> > ________________________________
> >> >
> >> > From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.=
com]
> >> On
> >> > Behalf Of Stewart Smith
> >> > Sent: Thursday, August 13, 2009 3:35 PM
> >> > To: device-mapper development
> >> > Subject: Re: [dm-devel] rdac path failure - Sun 6140
> >> >
> >> >
> >> >
> >> >
> >> >
> >> > Same sequence of events, with multipathd -v3
> >> >
> >> >
> >> >
> >> > Aug 13 16:28:48.627  kernel: device-mapper: multipath: Failing pat=
h
> >> 8:208.
> >> >
> >> > Aug 13 16:28:48.000  multipathd: vol1: rr_weight =3D 2 (LUN settin=
g)
> >> >
> >> > Aug 13 16:28:48.000  multipathd: vol1: pgfailback =3D -2 (controll=
er
> >> setting)
> >> >
> >> > Aug 13 16:28:48.000  multipathd: pg_timeout =3D NONE (internal def=
ault)
> >> >
> >> > Aug 13 16:28:48.000  multipathd: 8:208: mark as failed
> >> >
> >> > Aug 13 16:28:48.000  multipathd: uevent 'change' from
> >> > '/devices/virtual/block/dm-1'
> >> >
> >> > Aug 13 16:28:48.000  multipathd: UDEV_LOG=3D3
> >> >
> >> > Aug 13 16:28:48.000  multipathd: ACTION=3Dchange
> >> >
> >> > Aug 13 16:28:48.000  multipathd: DEVPATH=3D/devices/virtual/block/=
dm-1
> >> >
> >> > Aug 13 16:28:48.000  multipathd: SUBSYSTEM=3Dblock
> >> >
> >> > Aug 13 16:28:48.000  multipathd: DM_TARGET=3Dmultipath
> >> >
> >> > Aug 13 16:28:48.000  multipathd: DM_ACTION=3DPATH_FAILED
> >> >
> >> > Aug 13 16:28:48.000  multipathd: DM_SEQNUM=3D1
> >> >
> >> > Aug 13 16:28:48.000  multipathd: DM_PATH=3D8:208
> >> >
> >> > Aug 13 16:28:48.000  multipathd: DM_NR_VALID_PATHS=3D3
> >> >
> >> > Aug 13 16:28:48.000  multipathd: DM_NAME=3Dvol1
> >> >
> >> > Aug 13 16:28:48.000  multipathd:
> >> > DM_UUID=3Dmpath-3600a0b800048335200001e5d48b68a9b
> >> >
> >> > Aug 13 16:28:48.000  multipathd: MAJOR=3D253
> >> >
> >> > Aug 13 16:28:48.000  multipathd: MINOR=3D1
> >> >
> >> > Aug 13 16:28:48.000  multipathd: DEVTYPE=3Ddisk
> >> >
> >> > Aug 13 16:28:48.000  multipathd: SEQNUM=3D1738
> >> >
> >> > Aug 13 16:28:48.000  multipathd: UDEVD_EVENT=3D1
> >> >
> >> > Aug 13 16:28:48.000  multipathd: DEVNAME=3D/dev/dm-1
> >> >
> >> > Aug 13 16:28:50.000  multipathd: 8:208: reinstated
> >> >
> >> > Aug 13 16:28:50.000  multipathd: vol1: remaining active paths: 4
> >> >
> >> > Aug 13 16:28:50.000  multipathd: sdj: rdac prio =3D 3
> >> >
> >> > Aug 13 16:28:50.000  multipathd: sdn: rdac prio =3D 3
> >> >
> >> > Aug 13 16:28:50.000  multipathd: sdb: rdac prio =3D 0
> >> >
> >> > Aug 13 16:28:50.000  multipathd: sdd: rdac prio =3D 0
> >> >
> >> > Aug 13 16:28:50.763  kernel: device-mapper: multipath: Failing pat=
h
> >> 8:208.
> >> >
> >> > Aug 13 16:28:50.000  multipathd: uevent 'change' from
> >> > '/devices/virtual/block/dm-1'
> >> >
> >> > Aug 13 16:28:50.000  multipathd: UDEV_LOG=3D3
> >> >
> >> > Aug 13 16:28:50.000  multipathd: ACTION=3Dchange
> >> >
> >> > Aug 13 16:28:50.000  multipathd: DEVPATH=3D/devices/virtual/block/=
dm-1
> >> >
> >> > Aug 13 16:28:50.000  multipathd: SUBSYSTEM=3Dblock
> >> >
> >> > Aug 13 16:28:50.000  multipathd: DM_TARGET=3Dmultipath
> >> >
> >> > Aug 13 16:28:50.000  multipathd: DM_ACTION=3DPATH_REINSTATED
> >> >
> >> > Aug 13 16:28:50.000  multipathd: DM_SEQNUM=3D2
> >> >
> >> > Aug 13 16:28:50.000  multipathd: DM_PATH=3D8:208
> >> >
> >> > Aug 13 16:28:50.000  multipathd: DM_NR_VALID_PATHS=3D4
> >> >
> >> > Aug 13 16:28:50.000  multipathd: DM_NAME=3Dvol1
> >> >
> >> > Aug 13 16:28:50.000  multipathd:
> >> > DM_UUID=3Dmpath-3600a0b800048335200001e5d48b68a9b
> >> >
> >> > Aug 13 16:28:50.000  multipathd: MAJOR=3D253
> >> >
> >> > Aug 13 16:28:50.000  multipathd: MINOR=3D1
> >> >
> >> > Aug 13 16:28:50.000  multipathd: DEVTYPE=3DdiskAug 13 16:28:50.000
> >> >  multipathd: SEQNUM=3D1739Aug 13 16:28:50.000  multipathd: UDEVD_E=
VENT=3D1
> >> >
> >> > Aug 13 16:28:50.000  multipathd: vol1: rr_weight =3D 2 (LUN settin=
g)
> >> >
> >> > Aug 13 16:28:50.000  multipathd: vol1: pgfailback =3D -2 (controll=
er
> >> setting)
> >> >
> >> > Aug 13 16:28:50.000  multipathd: pg_timeout =3D NONE (internal def=
ault)
> >> >
> >> > Aug 13 16:28:50.000  multipathd: 8:208: mark as failed
> >> >
> >> > Aug 13 16:28:50.000  multipathd: vol1: remaining active paths: 3
> >> >
> >> > Aug 13 16:28:50.000  multipathd: vol1: rr_weight =3D 2 (LUN settin=
g)
> >> >
> >> > Aug 13 16:28:50.000  multipathd: vol1: pgfailback =3D -2 (controll=
er
> >> setting)
> >> >
> >> > Aug 13 16:28:50.000  multipathd: uevent 'change' from
> >> > '/devices/virtual/block/dm-1'
> >> >
> >> > Aug 13 16:28:50.000  multipathd: UDEV_LOG=3D3
> >> >
> >> > Aug 13 16:28:50.000  multipathd: ACTION=3Dchange
> >> >
> >> > Aug 13 16:28:50.000  multipathd: DEVPATH=3D/devices/virtual/block/=
dm-1
> >> >
> >> > Aug 13 16:28:50.000  multipathd: SUBSYSTEM=3Dblock
> >> >
> >> > Aug 13 16:28:50.000  multipathd: DM_TARGET=3Dmultipath
> >> >
> >> > Aug 13 16:28:50.000  multipathd: DM_ACTION=3DPATH_FAILED
> >> >
> >> > Aug 13 16:28:50.000  multipathd: DM_SEQNUM=3D3
> >> >
> >> > Aug 13 16:28:50.000  multipathd: DM_PATH=3D8:208
> >> >
> >> > Aug 13 16:28:50.000  multipathd: DM_NR_VALID_PATHS=3D3
> >> >
> >> > Aug 13 16:28:50.000  multipathd: DM_NAME=3Dvol1
> >> >
> >> > Aug 13 16:28:50.000  multipathd:
> >> > DM_UUID=3Dmpath-3600a0b800048335200001e5d48b68a9b
> >> >
> >> > Aug 13 16:28:50.000  multipathd: MAJOR=3D253
> >> >
> >> > Aug 13 16:28:50.000  multipathd: MINOR=3D1
> >> >
> >> > Aug 13 16:28:50.000  multipathd: DEVTYPE=3Ddisk
> >> >
> >> > Aug 13 16:28:50.000  multipathd: SEQNUM=3D1740
> >> >
> >> > Aug 13 16:28:50.000  multipathd: UDEVD_EVENT=3D1
> >> >
> >> > Aug 13 16:28:50.000  multipathd: DEVNAME=3D/dev/dm-1
> >> >
> >> > Aug 13 16:29:00.000  multipathd: 8:208: reinstated
> >> >
> >> > Aug 13 16:29:00.000  multipathd: vol1: remaining active paths: 4
> >> >
> >> > Aug 13 16:29:00.000  multipathd: sdj: rdac prio =3D 3
> >> >
> >> > Aug 13 16:29:00.000  multipathd: sdn: rdac prio =3D 3
> >> >
> >> > Aug 13 16:29:00.000  multipathd: sdb: rdac prio =3D 0
> >> >
> >> > Aug 13 16:29:00.000  multipathd: sdd: rdac prio =3D 0
> >> >
> >> > Aug 13 16:29:00.000  multipathd: vol1: rr_weight =3D 2 (LUN settin=
g)
> >> >
> >> > Aug 13 16:29:00.000  multipathd: vol1: pgfailback =3D -2 (controll=
er
> >> setting)
> >> >
> >> > Aug 13 16:29:00.000  multipathd: uevent 'change' from
> >> > '/devices/virtual/block/dm-1'
> >> >
> >> > Aug 13 16:29:00.000  multipathd: UDEV_LOG=3D3
> >> >
> >> > Aug 13 16:29:00.000  multipathd: ACTION=3Dchange
> >> >
> >> > Aug 13 16:29:00.000  multipathd: DEVPATH=3D/devices/virtual/block/=
dm-1
> >> >
> >> > Aug 13 16:29:00.000  multipathd: SUBSYSTEM=3Dblock
> >> >
> >> > Aug 13 16:29:00.000  multipathd: DM_TARGET=3Dmultipath
> >> >
> >> > Aug 13 16:29:00.000  multipathd: DM_ACTION=3DPATH_REINSTATED
> >> >
> >> > Aug 13 16:29:00.000  multipathd: DM_SEQNUM=3D4
> >> >
> >> > Aug 13 16:29:00.000  multipathd: DM_PATH=3D8:208
> >> >
> >> > Aug 13 16:29:00.000  multipathd: DM_NR_VALID_PATHS=3D4
> >> >
> >> > Aug 13 16:29:00.000  multipathd: DM_NAME=3Dvol1
> >> >
> >> > Aug 13 16:29:00.000  multipathd:
> >> > DM_UUID=3Dmpath-3600a0b800048335200001e5d48b68a9b
> >> >
> >> > Aug 13 16:29:00.000  multipathd: MAJOR=3D253
> >> >
> >> > Aug 13 16:29:00.000  multipathd: MINOR=3D1
> >> >
> >> > Aug 13 16:29:00.000  multipathd: DEVTYPE=3Ddisk
> >> >
> >> > Aug 13 16:29:00.000  multipathd: SEQNUM=3D1741
> >> >
> >> > Aug 13 16:29:00.000  multipathd: UDEVD_EVENT=3D1
> >> >
> >> > Aug 13 16:29:00.000  multipathd: DEVNAME=3D/dev/dm-1
> >> >
> >> > Aug 13 16:29:02.753  kernel: device-mapper: multipath: Failing pat=
h
> >> 8:208.
> >> >
> >> > Aug 13 16:29:02.000  multipathd: vol1: rr_weight =3D 2 (LUN settin=
g)
> >> >
> >> > Aug 13 16:29:02.000  multipathd: vol1: pgfailback =3D -2 (controll=
er
> >> setting)
> >> >
> >> > Aug 13 16:29:02.000  multipathd: pg_timeout =3D NONE (internal def=
ault)
> >> >
> >> > Aug 13 16:29:02.000  multipathd: 8:208: mark as failed
> >> >
> >> > Aug 13 16:29:02.000  multipathd: uevent 'change' from
> >> > '/devices/virtual/block/dm-1'
> >> >
> >> > Aug 13 16:29:02.000  multipathd: UDEV_LOG=3D3
> >> >
> >> > Aug 13 16:29:02.000  multipathd: ACTION=3Dchange
> >> >
> >> > Aug 13 16:29:02.000  multipathd: DEVPATH=3D/devices/virtual/block/=
dm-1
> >> >
> >> > Aug 13 16:29:02.000  multipathd: SUBSYSTEM=3Dblock
> >> >
> >> > Aug 13 16:29:02.000  multipathd: DM_TARGET=3Dmultipath
> >> >
> >> > Aug 13 16:29:02.000  multipathd: DM_ACTION=3DPATH_FAILED
> >> >
> >> > Aug 13 16:29:02.000  multipathd: DM_SEQNUM=3D5
> >> >
> >> > Aug 13 16:29:02.000  multipathd: DM_PATH=3D8:208
> >> >
> >> > Aug 13 16:29:02.000  multipathd: DM_NR_VALID_PATHS=3D3
> >> >
> >> > Aug 13 16:29:02.000  multipathd: DM_NAME=3Dvol1
> >> >
> >> > Aug 13 16:29:02.000  multipathd:
> >> > DM_UUID=3Dmpath-3600a0b800048335200001e5d48b68a9b
> >> >
> >> > Aug 13 16:29:02.000  multipathd: MAJOR=3D253
> >> >
> >> > Aug 13 16:29:02.000  multipathd: MINOR=3D1
> >> >
> >> > Aug 13 16:29:02.000  multipathd: DEVTYPE=3Ddisk
> >> >
> >> > Aug 13 16:29:02.000  multipathd: SEQNUM=3D1742
> >> >
> >> > Aug 13 16:29:02.000  multipathd: UDEVD_EVENT=3D1
> >> >
> >> > Aug 13 16:29:02.000  multipathd: DEVNAME=3D/dev/dm-1
> >> >
> >> > Aug 13 16:29:10.000  multipathd: 8:208: reinstated
> >> >
> >> > Aug 13 16:29:10.000  multipathd: vol1: remaining active paths: 4
> >> >
> >> > Aug 13 16:29:10.000  multipathd: sdj: rdac prio =3D 3
> >> >
> >> > Aug 13 16:29:10.000  multipathd: sdn: rdac prio =3D 3
> >> >
> >> > Aug 13 16:29:10.000  multipathd: sdb: rdac prio =3D 0
> >> >
> >> > Aug 13 16:29:10.000  multipathd: sdd: rdac prio =3D 0
> >> >
> >> > Aug 13 16:29:10.000  multipathd: vol1: rr_weight =3D 2 (LUN settin=
g)
> >> >
> >> > Aug 13 16:29:10.000  multipathd: vol1: pgfailback =3D -2 (controll=
er
> >> setting)
> >> >
> >> > Aug 13 16:29:10.000  multipathd: uevent 'change' from
> >> > '/devices/virtual/block/dm-1'
> >> >
> >> > Aug 13 16:29:10.000  multipathd: UDEV_LOG=3D3
> >> >
> >> > Aug 13 16:29:10.000  multipathd: ACTION=3Dchange
> >> >
> >> > Aug 13 16:29:10.000  multipathd: DEVPATH=3D/devices/virtual/block/=
dm-1
> >> >
> >> > Aug 13 16:29:10.000  multipathd: SUBSYSTEM=3Dblock
> >> >
> >> > Aug 13 16:29:10.000  multipathd: DM_TARGET=3Dmultipath
> >> >
> >> > Aug 13 16:29:10.000  multipathd: DM_ACTION=3DPATH_REINSTATED
> >> >
> >> > Aug 13 16:29:10.000  multipathd: DM_SEQNUM=3D6
> >> >
> >> > Aug 13 16:29:10.000  multipathd: DM_PATH=3D8:208
> >> >
> >> > Aug 13 16:29:10.000  multipathd: DM_NR_VALID_PATHS=3D4
> >> >
> >> > Aug 13 16:29:10.000  multipathd: DM_NAME=3Dvol1
> >> >
> >> > Aug 13 16:29:10.000  multipathd:
> >> > DM_UUID=3Dmpath-3600a0b800048335200001e5d48b68a9b
> >> >
> >> > Aug 13 16:29:10.000  multipathd: MAJOR=3D253
> >> >
> >> > Aug 13 16:29:10.000  multipathd: MINOR=3D1
> >> >
> >> > Aug 13 16:29:10.000  multipathd: DEVTYPE=3Ddisk
> >> >
> >> > Aug 13 16:29:10.000  multipathd: SEQNUM=3D1743
> >> >
> >> > Aug 13 16:29:10.000  multipathd: UDEVD_EVENT=3D1
> >> >
> >> > Aug 13 16:29:10.000  multipathd: DEVNAME=3D/dev/dm-1
> >> >
> >> >
> >> >
> >> >
> >> >
> >> >
> >> >
> >> >
> >> >
> >> > On Thu, Aug 13, 2009 at 1:27 PM, Stewart Smith <stew@cleepdar.com>
> >> wrote:
> >> >
> >> >
> >> >
> >> > after a fresh, multipath -F and start of multipathd with -v 2 I se=
e the
> >> > following messages.
> >> >
> >> >
> >> >
> >> > After starting multipathd I mounted /dev/mapper/vol1 and generated=
 some
> >> > simple I/O to it using dd
> >> >
> >> >
> >> >
> >> >
> >> >
> >> > Aug 13 16:23:14.888 localhost kernel: device-mapper: multipath: Fa=
iling
> >> path
> >> > 8:208.
> >> >
> >> > Aug 13 16:23:14.000 localhost multipathd: 8:208: mark as failed
> >> >
> >> > Aug 13 16:23:16.000 localhost multipathd: 8:208: reinstated
> >> >
> >> > Aug 13 16:23:30.462 localhost kernel: device-mapper: multipath: Fa=
iling
> >> path
> >> > 8:208.
> >> >
> >> > Aug 13 16:23:30.000 localhost multipathd: 8:208: mark as failed
> >> >
> >> > Aug 13 16:23:39.000 localhost multipathd: 8:208: reinstated
> >> >
> >> > Aug 13 16:23:46.430 localhost kernel: device-mapper: multipath: Fa=
iling
> >> path
> >> > 8:208.
> >> >
> >> > Aug 13 16:23:46.000 localhost multipathd: 8:208: mark as failed
> >> >
> >> > Aug 13 16:23:51.041 localhost kernel: device-mapper: multipath: Fa=
iling
> >> path
> >> > 8:208.
> >> >
> >> > Aug 13 16:23:51.000 localhost multipathd: 8:208: mark as failed
> >> >
> >> > Aug 13 16:23:59.000 localhost multipathd: 8:208: reinstated
> >> >
> >> > Aug 13 16:24:06.465 localhost kernel: device-mapper: multipath: Fa=
iling
> >> path
> >> > 8:208.
> >> >
> >> > Aug 13 16:24:06.000 localhost multipathd: 8:208: mark as failed
> >> >
> >> > Aug 13 16:24:09.000 localhost multipathd: 8:208: reinstated
> >> >
> >> >
> >> >
> >> >
> >> >
> >> > Thanks,
> >> >
> >> > --
> >> >
> >> > Stew
> >> >
> >> >
> >> >
> >> >
> >> >
> >> >
> >> >
> >> > On Thu, Aug 13, 2009 at 12:42 PM, Moger, Babu <Babu.Moger@lsi.com>
> >> wrote:
> >> >
> >> > Do you have /var/log/messages file for this problem?
> >> >
> >> > Thanks
> >> > Babu Moger
> >> >
> >> >> -----Original Message-----
> >> >> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat=
.com]
> >> On
> >> >> Behalf Of Stewart Smith
> >> >> Sent: Thursday, August 13, 2009 1:51 PM
> >> >> To: dm-devel@redhat.com
> >> >> Subject: [dm-devel] rdac path failure - Sun 6140
> >> >>
> >> >> Hello All,
> >> >>
> >> >> I am seeing many of these messages when my Sun 6140 array is unde=
r
> >> heavy
> >> >> I/O
> >> >> device-mapper: multipath: Failing path 8:208.
> >> >> device-mapper: multipath: Failing path 8:208.
> >> >> device-mapper: multipath: Failing path 8:208.
> >> >> device-mapper: multipath: Failing path 8:208.
> >> >> device-mapper: multipath: Failing path 8:208.
> >> >>
> >> >>
> >> >> I am running a Fedora 10 server, with two fiber connections to tw=
o
> >> >> different switches.  Both controllers on the 6140 have one connec=
tion
> >> >> to each switch as well.  The end result is that I see four paths =
to
> >> >> each LUN.
> >> >>
> >> >> When the volume is mounted and under significant load I see the
> >> >> messages above every few seconds.  They seem to appear every
> >> >> "no_path_retry" seconds.
> >> >>
> >> >> The 6140 controller firmware is up to date at version 07.50.08.10=
 and
> >> >> I have installed the latest firmware for my Emulex LPe11002 cards=
.  I
> >> >> have reproduced the problem using both Cisco MDS and Brocade fibe=
r
> >> >> channel switches as well.
> >> >>
> >> >> Using CAM, I have set the initiator Host Type to "Linux" at the
> >> >> moment.  I have tried other options as well without success.
> >> >>
> >> >> I have NOT installed the RDAC drivers from either Sun or LSI -
> >> >> primarily because they do not seem to build on my Fedora 10 kerne=
l.
> >> >>
> >> >> Any ideas would be greatly appreciated!!!
> >> >>
> >> >> configs and debugging multipathd output is below.
> >> >>
> >> >>
> >> >>
> >> >>
> >> >>
> >> >> Kernel: 2.6.27.24-170.2.68.fc10.x86_64
> >> >>
> >> >> # multipath -lll
> >> >> vol1 (3600a0b800048335200001e5d48b68a9b) dm-1 SUN,CSM200_R
> >> >> [size=3D12T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac][r=
w]
> >> >> \_ round-robin 0 [prio=3D6][active]
> >> >>  \_ 5:0:1:2 sdj 8:144 [active][ready]
> >> >>  \_ 2:0:1:2 sdn 8:208 [active][ready]
> >> >> \_ round-robin 0 [prio=3D0][enabled]
> >> >>  \_ 2:0:0:2 sdb 8:16  [active][ghost]
> >> >>  \_ 5:0:0:2 sdd 8:48  [active][ghost]
> >> >>
> >> >>
> >> >> # cat /etc/multipath.conf
> >> >>
> >> >> blacklist {
> >> >>         devnode "^sd[a-z][[0-9]*]"
> >> >>         devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
> >> >>         devnode "^hd[a-z][0-9]*"
> >> >>         devnode "^cciss!c[0-9]d[0-9](p[0-9]*)*"
> >> >> }
> >> >>
> >> >> defaults {
> >> >>         udev_dir                /dev
> >> >>         polling_interval        10
> >> >>         selector                "round-robin 0"
> >> >>         path_grouping_policy    multibus
> >> >>         getuid_callout          "/sbin/scsi_id --whitelisted /dev=
/%n"
> >> >>         prio                    alua
> >> >>         path_checker            readsector0
> >> >>         rr_min_io               100
> >> >>         max_fds                 8192
> >> >>         rr_weight               priorities
> >> >>         failback                immediate
> >> >>         no_path_retry           fail
> >> >>         user_friendly_names     yes
> >> >> }
> >> >> devices {
> >> >>         device {
> >> >>                 vendor                  "SUN"
> >> >>                 product                 "CSM200_R"
> >> >>                 product_blacklist       "Universal Xport"
> >> >>                 getuid_callout          "/sbin/scsi_id --whitelis=
ted
> >> >> /dev/%n"
> >> >>                 features                "0"
> >> >>                 hardware_handler        "1 rdac"
> >> >>                 path_selector           "round-robin 0"
> >> >>                 path_grouping_policy    group_by_prio
> >> >>                 failback                immediate
> >> >>                 rr_weight               uniform
> >> >>                 no_path_retry           queue
> >> >>                 rr_min_io               1000
> >> >>                 path_checker            rdac
> >> >>                 prio                    rdac
> >> >>         }
> >> >> }
> >> >>
> >> >> multipaths {
> >> >>         multipath {
> >> >>                 wwid
> >>  3600a0b800048335200001e5d48b68a9b
> >> >>                 alias                   vol1
> >> >>                 rr_weight               priorities
> >> >>                 no_path_retry           5
> >> >>                 rr_min_io               100
> >> >>         }
> >> >> }
> >> >>
> >> >>
> >> >>
> >> >> # multipathd -d v3
> >> >>
> >> >>
> >> >> Aug 13 14:48:53 | sdb: ownership set to vol1
> >> >> Aug 13 14:48:53 | sdb: not found in pathvec
> >> >> Aug 13 14:48:53 | sdb: mask =3D 0xc
> >> >> Aug 13 14:48:53 | sdb: path checker =3D rdac (controller setting)
> >> >> Aug 13 14:48:53 | sdb: state =3D 4
> >> >> Aug 13 14:48:53 | sdb: rdac prio =3D 0
> >> >> Aug 13 14:48:53 | sdd: ownership set to vol1
> >> >> Aug 13 14:48:53 | sdd: not found in pathvec
> >> >> Aug 13 14:48:53 | sdd: mask =3D 0xc
> >> >> Aug 13 14:48:53 | sdd: path checker =3D rdac (controller setting)
> >> >> Aug 13 14:48:53 | sdd: state =3D 4
> >> >> Aug 13 14:48:53 | sdd: rdac prio =3D 0
> >> >> Aug 13 14:48:53 | sdj: ownership set to vol1
> >> >> Aug 13 14:48:53 | sdj: not found in pathvec
> >> >> Aug 13 14:48:53 | sdj: mask =3D 0xc
> >> >> Aug 13 14:48:53 | sdj: path checker =3D rdac (controller setting)
> >> >> Aug 13 14:48:53 | sdj: state =3D 2
> >> >> Aug 13 14:48:53 | sdj: rdac prio =3D 3
> >> >> Aug 13 14:48:53 | sdn: ownership set to vol1
> >> >> Aug 13 14:48:53 | sdn: not found in pathvec
> >> >> Aug 13 14:48:53 | sdn: mask =3D 0xc
> >> >> Aug 13 14:48:53 | sdn: path checker =3D rdac (controller setting)
> >> >> Aug 13 14:48:53 | sdn: state =3D 2
> >> >> Aug 13 14:48:53 | sdn: rdac prio =3D 3
> >> >> Aug 13 14:48:53 | vol1: pgfailback =3D -2 (controller setting)
> >> >> Aug 13 14:48:53 | vol1: pgpolicy =3D group_by_prio (controller se=
tting)
> >> >> Aug 13 14:48:53 | vol1: selector =3D round-robin 0 (controller se=
tting)
> >> >> Aug 13 14:48:53 | vol1: features =3D 0 (controller setting)
> >> >> Aug 13 14:48:53 | vol1: hwhandler =3D 1 rdac (controller setting)
> >> >> Aug 13 14:48:53 | vol1: rr_weight =3D 2 (LUN setting)
> >> >> Aug 13 14:48:53 | vol1: minio =3D 100 (LUN setting)
> >> >> Aug 13 14:48:53 | vol1: no_path_retry =3D 5 (multipath setting)
> >> >> Aug 13 14:48:53 | pg_timeout =3D NONE (internal default)
> >> >> Aug 13 14:48:53 | vol1: set ACT_CREATE (map does not exist)
> >> >> create: vol1 (3600a0b800048335200001e5d48b68a9b) n/a SUN,CSM200_R
> >> >> [size=3D12T][features=3D0][hwhandler=3D1 rdac][n/a]
> >> >> \_ round-robin 0 [prio=3D6][undef]
> >> >>  \_ 5:0:1:2 sdj 8:144 [undef][ready]
> >> >>  \_ 2:0:1:2 sdn 8:208 [undef][ready]
> >> >> \_ round-robin 0 [prio=3D0][undef]
> >> >>  \_ 2:0:0:2 sdb 8:16 [undef][ghost]
> >> >>  \_ 5:0:0:2 sdd 8:48 [undef][ghost]
> >> >>
> >> >
> >> >> --
> >> >> dm-devel mailing list
> >> >> dm-devel@redhat.com
> >> >> https://www.redhat.com/mailman/listinfo/dm-devel
> >> >
> >> > --
> >> > dm-devel mailing list
> >> > dm-devel@redhat.com
> >> > https://www.redhat.com/mailman/listinfo/dm-devel
> >> >
> >> >
> >> >
> >> >
> >>
> >> --
> >> dm-devel mailing list
> >> dm-devel@redhat.com
> >> https://www.redhat.com/mailman/listinfo/dm-devel
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> >
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
