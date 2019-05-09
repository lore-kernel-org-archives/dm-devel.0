From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 08/10] dm-integrity: add a bitmap mode
Date: Thu, 9 May 2019 06:19:34 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1905090552580.10009@file01.intranet.prod.int.rdu2.redhat.com>
References: <20190429125746.036036640@debian-a64.vm>
	<20190508175350.GA29513@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190508175350.GA29513@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids



On Wed, 8 May 2019, Mike Snitzer wrote:

> > +static struct bitmap_block_status *sector_to_bitmap_block(struct dm_integrity_c *ic, sector_t sector)
> > +{
> > +	unsigned bit = sector >> (ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit);
> > +	unsigned bitmap_block = bit / (BITMAP_BLOCK_SIZE * 8);
> > +
> > +	BUG_ON(bitmap_block >= ic->n_bitmap_blocks);
> > +	return &ic->bbs[bitmap_block];
> > +}
> > +
> 
> Too many BUG()s and BUG_ON.  The BUG_ON could be left if you think it
> sufficiently unlikely.

The BUGs could only happen if there's a bug in the code. They can't happen 
on disk I/O errors or checksum errors.

> But in general I'd prefer factoring out an &error return but needing to
> check for such a return would slow things down.. so that's probably not
> an option.

Yes. I think it is not a good practice to write recovery code for 
situations that can't happen. Those spurious return codes will just make 
the code harder to understand.

> Maybe we just set a new 'invalid' flag and disallow all operations and
> fail IO?  Point is it is really bad to crash the system because
> dm-integrity lost its way.  Instead we should just mark the device
> invalid (like dm-snapshot does).
>
> Mike

It already has a flag "struct dm_integrity_c->failed" - but this is for 
unrecoverable I/O errors (such as journal errors), not for programming 
errors.

I suggest - if no one complains, you can let it be, if someone complains, 
you can just hide the BUGs behind "#ifdef CONFIG_BUG_ON_DATA_CORRUPTION".

Mikulas
