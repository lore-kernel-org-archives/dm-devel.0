From: Tore Anderson <tore@linpro.no>
Subject: Re: Use LVM on /dev/mapper/diskname and iSCSI
Date: Tue, 20 Nov 2007 08:36:54 +0100
Message-ID: <47428E96.2090008@linpro.no>
References: <1195480602.6074.3.camel@sanderbal>
	<47419854.2000508@linpro.no>	<1195484847.6074.16.camel@sanderbal>	<20071119185021.GA23100@us.ibm.com>
	<1195506996.11489.23.camel@sanderbal>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1195506996.11489.23.camel@sanderbal>
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

* S. J. van Harmelen

> I have a storage server with an MD3000 attached to it. This server
> runs the multipath-tools to create redundant paths:
>=20
> root@storage:~# multipath -ll
> <snip>
> xen (360019b9000d7e11000004485473faa94) dm-0 DELL    ,MD3000       =20
> [size=3D200G][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D3][active]
>  \_ 1:0:0:3 sde 8:64  [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 1:0:1:3 sdi 8:128 [active][ghost]
> <snip>

I think you need hwhandler =3D "1 rdac" for the MD3000 to be able to fail
over properly.  At least a colleague that have played with it told me so.

> On the XenSource server I use a shared iSCSI storage so multiple
> servers can access the same data so I can do live migrations. When I
> add the storage XenSource creates a PV and then when I create a VM,
> it creates LV's for each virtual harddisk.
>=20
> So far so good I guess, as the XenSource machine uses the multipathed
> drive, right?

You absolutely need to keep LVM (in dom0) from using /dev/sde or
/dev/sdi as the PV (instead of /dev/mapper/xen).  You can accomplish
this with a filter line in lvm.conf:

filter =3D [ "a|^/dev/mapper/xen$|", "r|.*|" ]

Which means that a device node that is exactly =C2=AB/dev/mapper/xen=C2=BB=
 is
considered a valid PV candidate, all other devices are rejected.

From the email you sent with earlier pvscan output you got /dev/dm-0 as
the active PV, with pvs you got /dev/sde (and with both you got I/O
errors to the passive paths).  It can't be relied upon that you'll get
dm-0 (which is absolutely necessary if you want dm-multipath to serve
any purpose) in the future unless you force LVM to only look for PVs in
the multipath'ed block devices.

> Now I would like to take snapshots of the whole PV so I can make=20
> backups. My thoughts where to make a PV on /dev/mapper/xen that spans
> the whole disk, and then create a single LV on it.

You can only take snapshots of LVs, not PVs.  And you would have to
create a VG first with /dev/mapper/xen as a PV (you can't add LVs
directly on PVs).  But I think you've got the basic idea correct.  :-)

> If I then take the path to that single LV, say /dev/volumegroup/disk1
> as target for iSCSI, then the XenSsource server should only see that
> LV as the shared iSCSI repository.
>=20
> But then XenSource wil create a PV and a couple of LV's in the
> existing LV (created on the storage server and shared true iSCSI).
> Could that create any problems or can I just do that?

I see no reason why that wouldn't work.  Try it and see?  Inside the
domU the Linux kernel won't know that its available block devices are
really mapped to another LVM implementation that runs in dom0.  LVM is
probably clever enough to disregard that LV-containing-a-PV as a valid
PV candidate, but if not the filter line in lvm.conf should handle it.

Regards
--=20
Tore Anderson
