From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH v3 01/11] block: make generic_make_request handle
 arbitrarily sized bios
Date: Fri, 22 May 2015 10:49:06 -0700
Message-ID: <CAF1ivSZt1q0QiezakjYT9xPbj-fAuEv-1ZSVrX5Qu9Tg0T2x+A@mail.gmail.com>
References: <1430980461-5235-1-git-send-email-mlin@kernel.org>
	<1430980461-5235-2-git-send-email-mlin@kernel.org>
	<x49twv9kevg.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <x49twv9kevg.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Ming Lin <mlin@kernel.org>, lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dpark@posteo.net>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: dm-devel.ids

On Mon, May 18, 2015 at 9:52 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>
>> +static struct bio *blk_bio_segment_split(struct request_queue *q,
>> +                                      struct bio *bio,
>> +                                      struct bio_set *bs)
>> +{
>
> Funny name for a function that also merges segments.  ;-)  I admit I am

I'm trying to understand ... but I didn't see it also merges segments.

> at a loss for coming up with a better name that won't overflow 80
> columns.
>
> Other than that, this looks sane.
>
> Cheers,
> Jeff
