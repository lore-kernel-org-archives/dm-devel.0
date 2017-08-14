From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [BUG] BLKZEROOUT on dm-crypt container cause OOM /
 kernel panic
Date: Sun, 13 Aug 2017 22:47:32 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1708132245190.18210@file01.intranet.prod.int.rdu2.redhat.com>
References: <CAGnHSEngW1Ugf66V5henR9fMEev0xcJnKVY9MjJb19gy3CkgNA@mail.gmail.com> <20170809133833.GA25681@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170809133833.GA25681@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, Damien Le Moal <damien.lemoal@wdc.com>
Cc: Tom Yan <tom.ty89@gmail.com>, axboe@kernel.dk, linux-block@vger.kernel.org, "axboe@fb.com" <axboe@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, gmazyland@gmail.com
List-Id: dm-devel.ids



On Wed, 9 Aug 2017, hch@lst.de wrote:

> Does commit 615d22a51c04856efe62af6e1d5b450aaf5cc2c0
> "block: Fix __blkdev_issue_zeroout loop" fix the issue for you?
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

I think that patch is incorrect. sector_t may be a 32-bit type and 
nr_sects << 9 may overflow.

static unsigned int __blkdev_sectors_to_bio_pages(sector_t nr_sects)
{
       sector_t bytes = (nr_sects << 9) + PAGE_SIZE - 1;

       return min(bytes >> PAGE_SHIFT, (sector_t)BIO_MAX_PAGES);
}

Mikulas
