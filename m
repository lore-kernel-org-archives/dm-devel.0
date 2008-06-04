From: Hannes Reinecke <hare@suse.de>
Subject: Re: kpartx and udev problem
Date: Wed, 4 Jun 2008 08:45:29 +0200
Message-ID: <20080604064529.GA27327@pentland.suse.de>
References: <20080603215743.GA6113@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080603215743.GA6113@localhost.localdomain>
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

Hi Ron,

On Tue, Jun 03, 2008 at 05:57:43PM -0400, Ron Peterson wrote:
> Hi,
>=20
> I am having trouble getting kpartx to run reliably from udev.  My confi=
g
> files look like:
> _______________________________________________________________________=
_
> /etc/udev/rules.d/z60_multipath.rules:
>=20
> RUN+=3D"socket:/org/kernel/dm/multipath_event"
>=20
> _______________________________________________________________________=
_
> /etc/udev/rules.d/z60_kpartx.rules:
>=20
> KERNEL!=3D"dm-*", GOTO=3D"kpartx_end"
> ACTION=3D=3D"remove", GOTO=3D"kpartx_end"
> ACTION=3D=3D"modify", GOTO=3D"kpartx_end"
>=20
> ACTION=3D=3D"add", \
>     SUBSYSTEM=3D=3D"block", \
>     KERNEL=3D=3D"dm-*", \
>     PROGRAM=3D"/sbin/devmap_name %M %m", \
>     RUN+=3D"/sbin/kpartx -a /dev/mapper/%c"
>=20
> LABEL=3D"kpartx_end"
>=20
> ##
>=20
Ah, yes. That one :-)

> When I run 'multipath', my /dev/mapper directory looks something like:
>=20
> brw-rw---- 1 root disk   253, 22 2008-06-03 12:21 db1
> brw-rw---- 1 root disk   253, 26 2008-06-03 12:21 db1p1
> brw-rw---- 1 root disk   253,  1 2008-06-03 12:21 db2
> brw-rw---- 1 root disk   253,  3 2008-06-03 12:21 db3
> brw-rw---- 1 root disk   253,  4 2008-06-03 12:21 db4
> brw-rw---- 1 root disk   253, 13 2008-06-03 12:21 f3a00
> brw-rw---- 1 root disk   253, 14 2008-06-03 12:21 f3a01
> etc...
>=20
> All of these devices have one or more partitions; i.e. there should be =
a
> db2p1, and a db3p1, and so on.
>=20
> As you can see, /some/ of my partitions are showing up, but others do n=
ot.
>=20
> If I run kpartx manually, it works; e.g.
>=20
> 1110# kpartx -a /dev/mapper/db2
>=20
> 1111# ll /dev/mapper/db2*
> brw-rw---- 1 root disk 253,  1 2008-06-03 12:21 /dev/mapper/db2
> brw-rw---- 1 root disk 253, 33 2008-06-03 12:29 /dev/mapper/db2p1
>=20
> I'm running multipath-tools version 0.4.8 on debian etch, running my ow=
n
> kernel, which at the moment is 2.6.25.4, but I've experienced the same
> trouble on other kernel versions.
>=20
> Interestingly, on kernel 2.6.23.16 as it happens, I was able to make
> this work by wrapping kpartx in a little script called my_kpartx.sh lik=
e
> this:
>=20
> #!/bin/sh
> (
> /bin/sleep 1
> /sbin/kpartx $1 $2
> ) &
>=20
> Then, in my z60_kpartx.rules file, I called /sbin/my_kpartx rather than
> /sbin/kpartx.  This doesn't work in 2.6.25.4 though.
>=20
> So that's my sad tale of woe.  Any suggestions that might cheer me up?
>=20
Quite so.

Problem being the 'interesting' device-mapper design.
Whenever a 'table create' operation is triggered from user-space, it's
actually being broken down by the device-mapper library into 4 distinct
operations:
1. create device dm-X
2. suspend device
3. load table definition
4. resume device

and you'll be getting an 'add' event for the first operation, and a
'change' event for the second and the forth operation.
But clearly the 'add' event is pretty much pointless, as there is
not table loaded at that time, so you wouldn't know what to do with
it. And the device is locked between the second and the fourth
operation, so kpartx would refuse to touch it.

So, in essence: 'add' is evil for device-mapper devices.
Use the 'change' event and check if the dm-device is not suspended
when you get the event.

Or look at the current 'kpartx_id' script. That handles it properly.
(Of course it does. I wrote it :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
