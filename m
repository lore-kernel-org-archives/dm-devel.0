From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH v5 00/11] simplify block layer based on immutable biovecs
Date: Mon, 27 Jul 2015 15:16:08 -0700
Message-ID: <CAF1ivSaQvJE2WNA1eyRwueV-4+6XyLHZwkAAQ6Pp3OpZJF8XGw@mail.gmail.com>
References: <1436166674-31362-1-git-send-email-mlin@kernel.org>
	<1436764355.30675.10.camel@hasee>
	<20150713153537.GA30898@redhat.com>
	<1437675702.11359.25.camel@ssi>
	<20150727175048.GA18183@redhat.com>
	<1438035090.28978.19.camel@ssi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438035090.28978.19.camel@ssi>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jeff Moyer <jmoyer@redhat.com>, Dongsu Park <dpark@posteo.net>, Kent Overstreet <kent.overstreet@gmail.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Jul 27, 2015 at 3:11 PM, Ming Lin <mlin@kernel.org> wrote:
> It's more interesting if we look at how many bios are allocated for each
> application IO request.
>
> e.g. 10+2 RAID6 with 128K chunk.
>
> Assume we only consider device max_segments limitation.
>
> # cat /sys/block/md0/queue/max_segments
> 126
>
> So blk_queue_split() will split the bio if its size > 126 pages(504K
> bytes).

Fix myself.

I mean, blk_queue_split() will split the bio if bi_phys_segments > 126
