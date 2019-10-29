From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-snapshot for system updates in Android
Date: Tue, 29 Oct 2019 10:21:14 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1910290957220.25731@file01.intranet.prod.int.rdu2.redhat.com>
References: <20191025101624.GA61225@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191025101624.GA61225@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alessio Balsini <balsini@android.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alasdair G Kergon <agk@redhat.com>, elsk@google.com, dvander@google.com, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com
List-Id: dm-devel.ids

Hi

On Fri, 25 Oct 2019, Alessio Balsini wrote:

> Hello everyone!
>=20
> I hope you will appreciate knowing that we are currently evaluating the u=
se of
> dm-snapshot to implement a mechanism to obtain revertible, space-efficien=
t
> system upgrades in Android.  More specifically, we are using
> dm-snapshot-persistent to test the updated device after reboot, then issu=
e a
> merge in case of success, otherwise, destroy the snapshot.
> This new update mechanism is still under evaluation, but its development =
is
> openly done in AOSP.
>=20
> At the current stage, we have a prototype we are happy with, both in term=
s of
> space consumption overhead (for the COW device) and benchmarking results =
for
> read-write and merge operations.
>=20
> I would be glad if you could provide some feedback on a few points that I=
 don't
> have completely clear.
>=20
>=20
> -- Interface stability
>=20
> To obtain an initial, empty COW device as quick as possible, we force to =
0 only
> its first 32 bit (magic field). This solution looks clear from the kernel=
 code,
> but can we rely on that for all the kernels with SNAPSHOT_DISK_VERSION =
=3D=3D 1?

It will work, but, to be consistent with lvm, I suggest to overwrite the=20
first 4k with zeroes.

> Would you appreciate it if a similar statement is added as part of
> /Documentation, making this solution more stable? Or maybe I can think of
> adding an initialization flag to the dm-snapshot table to explicitly requ=
est
> the COW initialization within the kernel?
>=20
> Another issue we are facing is to be able to know in advance what the min=
imum
> COW device size would be for a given update to be able to allocate the ri=
ght

This is hard to say, it depends on what the user is doing with the phone.=
=20
When dm-snapshot runs out of space, it invalidates the whole snapshot.=20
You'll have to monitor the snapshot space very carefully and take action=20
before it fills up.

I suggest - run main system on the origin target and attach a snapshot=20
that will be used for backup of the data overwritten in the origin. If the=
=20
updated system fails, merge the snapshot back into the origin; if the=20
update succeeds, drop the snapshot. If the user writes too much data to=20
the device, it would invalidate the only the snapshot (so he can't revert=
=20
anymore), but it would not invalidate the origin and the data would not be=
=20
lost.

> size for the COW device in advance.  To do so, we rely on the current COW
> structure that seems to have kept the same stable shape in the last decad=
e, and
> compute the total COW size by knowing the number of modified chunks. The
> formula would be something like that:
>=20
>   table_line_bytes      =3D 64 * 2 / 8;
>   exceptions_per_chunk  =3D chunk_size_bytes / table_line_bytes;
>   total_cow_size_chunks =3D 1 + 1 + modified_chunks
>                         + modified_chunks / exceptions_per_chunk;
>=20
> This formula seems to be valid for all the recent kernels we checked. Aga=
in,
> can we assume it to be valid for all the kernels for which
> SNAPSHOT_DISK_VERSION =3D=3D 1?

Yes, we don't plan to change it.

> -- Alignment
>=20
> Our approach follows the solution proposed by Mikulas [1].
> Being the block alignment of file extents automatically managed by the
> filesystem, using FIEMAP should have no alignment-related performance iss=
ue.
> But in our implementation we hit a misalignment [2] branch which leads to
> dmwarning messages [3, 4].
>=20
> I have a limited experience with the block layer and dm, so I'm still
> struggling in finding the root cause for this, either in user space or ke=
rnel
> space.

I don't know. What is the block size of the filesystem? Are all mappings=20
aligned to this block size?

> But our benchmarks seems to be good, so we were thinking as last option t=
o
> rate-limit or directly remove that warning from our kernels as a temporar=
y
> solution, but we prefer to avoid diverging from mainline. Rate-limiting i=
s a
> solution that would make sense also to be proposed in the list, but compl=
etely
> removing the warning doesn't seem the right thing to do. Maybe we are
> benchmarking something else? What do you think?
>=20
> Many thanks for taking the time to read this, feedbacks would be highly
> appreciated.
>=20
> Regards.
> Alessio
>=20
> [1] https://www.redhat.com/archives/dm-devel/2018-October/msg00363.html
> [2] https://elixir.bootlin.com/linux/v5.3/source/block/blk-settings.c#L54=
0
> [3] https://elixir.bootlin.com/linux/v5.3/source/drivers/md/dm-table.c#L4=
84
> [4] https://elixir.bootlin.com/linux/v5.3/source/drivers/md/dm-table.c#L1=
558

Mikulas
