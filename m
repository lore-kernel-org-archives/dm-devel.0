From: Lukas Straub <lukasstraub2@web.de>
Subject: Re: [dm-devel] [PATCH] dm-integrity: Prevent RMW for full tag area
 writes
Date: Thu, 27 Feb 2020 13:08:37 +0100
Message-ID: <20200227130837.2707a09e@luklap>
References: <20200220190445.2222af54@luklap>
        <alpine.LRH.2.02.2002251127070.1014@file01.intranet.prod.int.rdu2.redhat.com>
        <20200226092705.61b7dcf4@luklap>
        <alpine.LRH.2.02.2002260906280.17883@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.2002260906280.17883@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, dm-devel <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, 26 Feb 2020 09:14:31 -0500 (EST)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> On Wed, 26 Feb 2020, Lukas Straub wrote:
>
> > > > -		data =3D dm_bufio_read(ic->bufio, *metadata_block, &b);
> > > > -		if (IS_ERR(data))
> > > > -			return PTR_ERR(data);
> > > > +		/* Don't read tag area from disk if we're going to overwrite it=
 completely */
> > > > +		if (op =3D=3D TAG_WRITE && *metadata_offset =3D=3D 0 && total_s=
ize >=3D ic->metadata_run) {
> > >
> > > Hi
> > >
> > > This is incorrect logic because ic->metadata_run is in the units of
> > > 512-byte sectors and total_size is in bytes.
> > >
> > > If I correct the bug and change it to "if (op =3D=3D TAG_WRITE &&
> > > *metadata_offset =3D=3D 0 && total_size >=3D ic->metadata_run << SEC=
TOR_SHIFT)",
> > > then the benchmark doesn't show any performance advantage at all.
> >
> > Uh oh, looking at it again i have mixed up sectors/bytes elsewhere too=
.
> > Actually, could we rewrite this check like
> >  total_size >=3D (1U << SECTOR_SHIFT << ic->log2_buffer_sectors)?
> > this should work, right?
> > So we only have to overwrite part of the tag area, as long as it's who=
le sectors.
> >
> > > You would need much bigger bios to take advantage for this - for exa=
mple,
> > > if we have 4k block size and 64k metadata buffer size and 4-byte crc=
32,
> > > there are 65536/4=3D16384 tags in one metadata buffer and we would n=
eed
> > > 16384*4096=3D64MiB bio to completely overwrite the metadata buffer. =
Such big
> > > bios are not realistic.
> >
> > What prevents us from using a single sector as the tag area? (Which wa=
s
>
> Single sector writes perform badly on SSDs (and on disks with 4k physica=
l
> sector size). We would need at least 4k.
People with SSDs can still use a large tag area.

> There's another problem - using smaller metadata blocks will degrade rea=
d
> performance, because we would need to issue more requests to read the
> metadata.
We can use prefetching, dm-bufio supports that.

> > my assumption with this patch) Then we would have (with 512b sectors)
> > 512/4 =3D 128 tags =3D 64k bio, which is still below the optimal write=
 size
>
> 4096/4*4096 =3D 4MiB - it may be possible, but it's still large.

We don't have to fill whole sector with metadata, we can for example use j=
ust the first
512 bytes (giving 512/4*4096 =3D 512k writes).
The space overhead is negligible:
For 1T of data we have 1G of metadata if we fill the whole sector.
If we use just the first 512 bytes, we get 8G of metadata.

Regards,
Lukas Straub

> > of raid5/6. I just tried to accomplish this, but there seems to be
> > minimum limit of interleave_sectors.
> >
> > Regards,
> > Lukas Straub
>
> Mikulas
>
