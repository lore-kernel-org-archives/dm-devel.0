From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH] i/o errors with dm-over-md-raid0
Date: Mon, 18 May 2009 17:05:17 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF46EE888F1@cosmail01.lsi.com>
References: <Pine.LNX.4.64.0905111226120.1438@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0905111226120.1438@hs20-bc2-1.build.redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids


> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] =
On
> Behalf Of Mikulas Patocka
> Sent: Monday, May 11, 2009 11:36 AM
> To: Alasdair G Kergon; Milan Broz
> Cc: dm-devel@redhat.com
> Subject: [dm-devel] [PATCH] i/o errors with dm-over-md-raid0
>=20
> Hi
>=20
> This is an upstream patch for upstream for
> https://bugzilla.redhat.com/show_bug.cgi?id=3D223947
>=20
> The RHEL-5 patch is in the bugzilla, it is different but has the same
> functionality.
>=20
> Milan, if you have time, please could you (or someone else in Brno lab)
> try to reproduce the bug, then apply the patch and verify that it fixed
> it?
>=20
> In short, the RHEL 5 setup is:
> * MD - RAID-0
> * lvm on the top of it
> * one of the logical volumes (linear volume) is exported to xen domU
> * inside xen domU it is partitioned, the key point is that the partitio=
n
> must be unaligned on page boundary (fdisk normally aligns the partition=
 to
> 63 sectors, that will trigger it)
> * install the system on the partitioned disk in domU -> I/O failures in
> dom0
>=20
> In upstream kernel, there are some merge changes, the bug should no lon=
ger
> happen with linear volumes, but you should be able to reproduce it if y=
ou
> use some other dm target --- dm-raid1, dm-snapshot (with chunk size lar=
ger
> than RAID-0 stripe) or dm-stripe (with stripe size larger than RAID-0
> stripe).
>=20
> Mikulas
>=20
> ---
>=20
> Explanation of the bug and fix:
> (https://bugzilla.redhat.com/show_bug.cgi?id=3D223947)
>=20
> In Linux bio architecture, it is the responsibility of the caller that
> he is not creating bio too large for the appropriate block device
> driver.
>=20
> There are several ways how bio size can be limited.
> - There is q->max_hw_sectors that is the upper limit of total number of
>   sectors.
> - These are q->max_phys_segments and q->max_hw_segments that limit
>   number of consecutive segments (before and after iommu merging).
> - There is q->max_segment_size and q->seg_boundary_mask that determine
>   how much data fits in a segment and at which points there are enforce=
d
>   segment boundaries (because some hardware have limitation on entries
>   in its scatter-gather table)

Mikulas,
 I am working on an issue (with our private multipath driver) where I am =
seeing block layer is setting the seg_boundary_mask for my virtual disk a=
s -1 (or 0xffffffffffffffff). However, my corresponding physical disk it =
is being set as 0xffffffff (or 4294967295). I was expecting this value to=
 be set by default as 0xffffffff for all the block devices. However, that=
 is not the case. Do you expect each driver to modify these values?
-Babu Moger
