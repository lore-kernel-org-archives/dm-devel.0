From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: RE: [PATCH] [RFC] switch DM tables to readonly
	automatically
Date: Wed, 30 Apr 2008 10:19:51 +0200
Message-ID: <1209543591.26745.9.camel@plop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
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
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


> Hi all,
>=20
> this patch switches the device-mapper table to read-only status automat=
ically if one underlying device returns -EROFS.
>=20
> Rationale:
> Whenever a SCSI device is switched to read-only a table reload from mul=
tipath-tools fails, without any indication about the reason. And it's act=
ually quite tricky to detect the read-only status from userland. And quit=
e pointless, too, as the kernel already knows about it.
>=20
> And we now can create tables for CD-ROMs, too, without having to use th=
e '-r' flag to dmsetup ...
>=20
> Christophe, this might also fix your problem.
>=20
It seems it will solve the map creation error on read-only LU, but what a=
bout these LU becoming writable ? ...
as is the case with the Symmetrix R2 upon spliting the synchronisation li=
nk.
Will the devmap become writable too automagically or is the multipathd da=
emon expected to take action the promote the map RW ?

Thanks for caring anyway.

> As usual, comments etc are welcome.
>=20
> Cheers,
>=20
> Hannes
> --
> Dr. Hannes Reinecke                   zSeries & Storage
> hare suse de                          +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
>=20
