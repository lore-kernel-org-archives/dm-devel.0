From: christophe.varoqui@free.fr
Subject: Re: Media failures cause Path/Device Failures in
	dm-multipath ?
Date: Wed, 8 Jul 2009 22:44:21 +0200 (CEST)
Message-ID: <666005175.6845321247085861255.JavaMail.root@zimbra16-e3.priv.proxad.net>
References: <1247081696.2984.25.camel@psmith-ubeta.netezza.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1247081696.2984.25.camel@psmith-ubeta.netezza.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: paul@mad-scientist.net, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Mike Christie is working on a patchset to let target errors have to scsi-=
layer retries treatment while retaining the failfast behaviour for transp=
ort errors.

This work should benefit to your problem too, if I'm not mistaken.

Regards,
cvaroqui

----- Mail Original -----
De: "Paul Smith" <paul@mad-scientist.net>
=C3=80: "device-mapper development" <dm-devel@redhat.com>
Envoy=C3=A9: Mercredi 8 Juillet 2009 21h34:56 GMT +01:00 Amsterdam / Berl=
in / Berne / Rome / Stockholm / Vienne
Objet: Re: [dm-devel] Media failures cause Path/Device Failures in dm-mul=
tipath ?

Hi all; does anyone have any thoughts about/comments on this?

It's kind of not so useful to be using this stuff if I can't recover
from a media failure, after all... what am I doing wrong?

Thanks!

On Tue, 2009-07-07 at 17:26 -0400, Paul Smith wrote:
> I have a configuration that has raid1 mirrors (md_raid1) built on top o=
f
> linear segments of multipath'd scsi disks (dm-multipath).  This is Linu=
x
> 2.6.27.25, FYI.  Unfortunately because this is an embedded environment
> it's not easy for us to jump to a newer kernel.
>=20
> In this configuration when a scsi disk reports a media failure (SCSI
> Sense/ASC/ASCQ: 3/11/0), I would expect that the md_raid1 would be able
> to handle the error and read the data from the other mirror and then
> re-write the failed sector on the original image.
>=20
> I have tried this with the no_path_retry attribute as 'fail'  and
> observe the following...=20
>=20
> dm-multipath reports the path failure.=20
> Then it tries the request on the other path, which also gets a path
> failure.
> The failure of both paths fails the device.
>=20
> md-raid1 gets the error and reads from the other mirror.
> When md-raid1 tries to re-write the data it encounters the failed
> device.
>=20
> >From syslog:
>=20
> Jul 1 20:46:27 hostname user.info kernel: sd 3:0:3:0: [sdaz] Result: ho=
stbyte=3D0x00 driverbyte=3D0x08
> Jul 1 20:46:27 hostname user.info kernel: sd 3:0:3:0: [sdaz] Sense Key =
: 0x3 [current]
> Jul 1 20:46:27 hostname user.warn kernel: Info fld=3D0x217795c
> Jul 1 20:46:27 hostname user.info kernel: sd 3:0:3:0: [sdaz] ASC=3D0x11=
 ASCQ=3D0x0
> Jul 1 20:46:27 hostname user.warn kernel: device-mapper: multipath: Fai=
ling path 67:48.
> Jul 1 20:46:27 hostname daemon.notice multipathd: 67:48: mark as failed
> Jul 1 20:46:27 hostname daemon.notice multipathd: encl3Slot4: remaining=
 active paths: 1
> Jul 1 20:46:29 hostname user.info kernel: sd 2:0:29:0: [sdab] Result: h=
ostbyte=3D0x00 driverbyte=3D0x08
> Jul 1 20:46:29 hostname user.info kernel: sd 2:0:29:0: [sdab] Sense Key=
 : 0x3 [current]
> Jul 1 20:46:29 hostname user.warn kernel: Info fld=3D0x217795c
> Jul 1 20:46:29 hostname user.info kernel: sd 2:0:29:0: [sdab] ASC=3D0x1=
1 ASCQ=3D0x0
> Jul 1 20:46:29 hostname user.warn kernel: device-mapper: multipath: Fai=
ling path 65:176.
> Jul 1 20:46:30 hostname daemon.notice multipathd: 65:176: mark as faile=
d
> Jul 1 20:46:30 hostname daemon.notice multipathd: encl3Slot4: remaining=
 active paths: 0
> Jul 1 20:46:30 hostname user.err kernel: raid1: dm-36: rescheduling sec=
tor 35092739
> Jul 1 20:46:30 hostname user.alert kernel: raid1: Disk failure on dm-38=
, disabling device.
> Jul 1 20:46:30 hostname user.alert kernel: raid1: Operation continuing =
on 1 devices.
> Jul 1 20:46:30 hostname user.warn kernel: md: super_written gets error=3D=
-5, uptodate=3D0
> Jul 1 20:46:30 hostname user.alert kernel: raid1: Disk failure on dm-36=
, disabling device.
> Jul 1 20:46:30 hostname user.alert kernel: raid1: Operation continuing =
on 1 devices.
>=20
> When the no_path_retry attribute is set to '3' :
>=20
> dm-multipath reports the path failure.
> Then retries the request on the other path, which also gets a path
> failure.
> On the failure of the second path, the device queues, and enters
> recovery mode.
> On the subsequent poll of the paths they are reinstated and the IOs are
> 'resumed'.....
> ... and of course fail with the media error again.......
> causing a hang...
>=20
> >From syslog:
>=20
> Jul  7 10:54:35 hostname user.info kernel: sd 2:0:19:0: [sds] Result: h=
ostbyte=3D0x00 driverbyte=3D0x08
> Jul  7 10:54:35 hostname user.info kernel: sd 2:0:19:0: [sds] Sense Key=
 : 0x3 [current]
> Jul  7 10:54:35 hostname user.warn kernel: Info fld=3D0x123c016d
> Jul  7 10:54:35 hostname user.info kernel: sd 2:0:19:0: [sds] ASC=3D0x1=
1 ASCQ=3D0x0
> Jul  7 10:54:35 hostname user.warn kernel: device-mapper: multipath: Fa=
iling path 65:32.
> Jul  7 10:54:35 hostname daemon.notice multipathd: 65:32: mark as faile=
d
> Jul  7 10:54:35 hostname daemon.notice multipathd: encl2Slot7: remainin=
g active paths: 1
> Jul  7 10:54:37 hostname user.info kernel: sd 3:0:45:0: [sdcm]
> Jul  7 10:54:37 hostname user.info kernel: Result: hostbyte=3D0x00 driv=
erbyte=3D0x08
> Jul  7 10:54:37 hostname user.info kernel: sd 3:0:45:0: [sdcm] Sense Ke=
y : 0x3
> Jul  7 10:54:37 hostname user.info kernel: [current]
> Jul  7 10:54:37 hostname user.warn kernel: Info fld=3D0x123c016d
> Jul  7 10:54:37 hostname user.info kernel: sd 3:0:45:0: [sdcm]
> Jul  7 10:54:37 hostname user.info kernel: ASC=3D0x11 ASCQ=3D0x0
> Jul  7 10:54:37 hostname user.warn kernel: device-mapper: multipath: Fa=
iling path 69:160.
> Jul  7 10:54:37 hostname daemon.notice multipathd: 69:160: mark as fail=
ed
> Jul  7 10:54:37 hostname daemon.warn multipathd: encl2Slot7: Entering r=
ecovery mode: max_retries=3D3
> Jul  7 10:54:37 hostname daemon.notice multipathd: encl2Slot7: remainin=
g active paths: 0
> Jul  7 10:54:39 hostname daemon.warn multipathd: sds: readsector0 check=
er reports path is up
> Jul  7 10:54:39 hostname daemon.notice multipathd: 65:32: reinstated
> Jul  7 10:54:42 hostname daemon.notice multipathd: encl2Slot7: queue_if=
_no_path enabled
> Jul  7 10:54:42 hostname daemon.warn multipathd: encl2Slot7: Recovered =
to normal mode
> Jul  7 10:54:42 hostname daemon.notice multipathd: encl2Slot7: remainin=
g active paths: 1
> Jul  7 10:54:42 hostname daemon.warn multipathd: sdcm: readsector0 chec=
ker reports path is up
> Jul  7 10:54:42 hostname daemon.notice multipathd: 69:160: reinstated
> Jul  7 10:54:42 hostname daemon.notice multipathd: encl2Slot7: remainin=
g active paths: 2
> Jul  7 10:54:42 hostname user.info kernel: sd 2:0:19:0: [sds] Result: h=
ostbyte=3D0x00 driverbyte=3D0x08
> Jul  7 10:54:42 hostname user.info kernel: sd 2:0:19:0: [sds]
> Jul  7 10:54:42 hostname user.info kernel: Sense Key : 0x3
> Jul  7 10:54:42 hostname user.info kernel: [current]
> Jul  7 10:54:42 hostname user.info kernel:
> Jul  7 10:54:42 hostname user.warn kernel: Info fld=3D0x123c016d
> Jul  7 10:54:42 hostname user.info kernel: sd 2:0:19:0: [sds]
> Jul  7 10:54:42 hostname user.info kernel: ASC=3D0x11 ASCQ=3D0x0
> Jul  7 10:54:42 hostname user.warn kernel: device-mapper: multipath: Fa=
iling path 65:32.
> Jul  7 10:54:43 hostname daemon.notice multipathd: 65:32: mark as faile=
d
> Jul  7 10:54:43 hostname daemon.notice multipathd: encl2Slot7: remainin=
g active paths: 1
>=20
>=20
> Should dm-multipath distinguish media failures from actual device
> errors?
>=20
> Is there a different no_path_retry policy that would fail this request
> by queue subsequent requests?
>=20
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
