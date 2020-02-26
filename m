From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm-integrity: Prevent RMW for full tag area
 writes
Date: Wed, 26 Feb 2020 09:14:31 -0500 (EST)
Message-ID: <alpine.LRH.2.02.2002260906280.17883@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200220190445.2222af54@luklap> <alpine.LRH.2.02.2002251127070.1014@file01.intranet.prod.int.rdu2.redhat.com> <20200226092705.61b7dcf4@luklap>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200226092705.61b7dcf4@luklap>
Sender: linux-kernel-owner@vger.kernel.org
To: Lukas Straub <lukasstraub2@web.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, dm-devel <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Wed, 26 Feb 2020, Lukas Straub wrote:

> > > -		data = dm_bufio_read(ic->bufio, *metadata_block, &b);
> > > -		if (IS_ERR(data))
> > > -			return PTR_ERR(data);
> > > +		/* Don't read tag area from disk if we're going to overwrite it completely */
> > > +		if (op == TAG_WRITE && *metadata_offset == 0 && total_size >= ic->metadata_run) {
> >
> > Hi
> >
> > This is incorrect logic because ic->metadata_run is in the units of
> > 512-byte sectors and total_size is in bytes.
> >
> > If I correct the bug and change it to "if (op == TAG_WRITE &&
> > *metadata_offset == 0 && total_size >= ic->metadata_run << SECTOR_SHIFT)",
> > then the benchmark doesn't show any performance advantage at all.
> 
> Uh oh, looking at it again i have mixed up sectors/bytes elsewhere too.
> Actually, could we rewrite this check like
>  total_size >= (1U << SECTOR_SHIFT << ic->log2_buffer_sectors)?
> this should work, right?
> So we only have to overwrite part of the tag area, as long as it's whole sectors.
> 
> > You would need much bigger bios to take advantage for this - for example,
> > if we have 4k block size and 64k metadata buffer size and 4-byte crc32,
> > there are 65536/4=16384 tags in one metadata buffer and we would need
> > 16384*4096=64MiB bio to completely overwrite the metadata buffer. Such big
> > bios are not realistic.
> 
> What prevents us from using a single sector as the tag area? (Which was 

Single sector writes perform badly on SSDs (and on disks with 4k physical 
sector size). We would need at least 4k.

There's another problem - using smaller metadata blocks will degrade read 
performance, because we would need to issue more requests to read the 
metadata.

> my assumption with this patch) Then we would have (with 512b sectors) 
> 512/4 = 128 tags = 64k bio, which is still below the optimal write size 

4096/4*4096 = 4MiB - it may be possible, but it's still large.

> of raid5/6. I just tried to accomplish this, but there seems to be 
> minimum limit of interleave_sectors.
> 
> Regards,
> Lukas Straub

Mikulas
