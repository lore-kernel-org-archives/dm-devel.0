From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH 01/10] block: make generic_make_request handle arbitrarily
 sized bios
Date: Wed, 6 May 2015 00:13:14 -0700
Message-ID: <CAF1ivSZKSEfvXg_EUWkxkigLPVZNxQ0uEY7kns8CfE=nfLrCoQ@mail.gmail.com>
References: <1430203717-13307-1-git-send-email-mlin@kernel.org>
	<1430203717-13307-2-git-send-email-mlin@kernel.org>
	<20150428114320.GA9790@lst.de>
	<5549AFD4.5020803@kernel.org>
	<20150506064849.GB5181@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150506064849.GB5181@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lin <mlin@kernel.org>, Christoph Hellwig <hch@lst.de>, lkml <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dongsu.park@profitbricks.com>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, Keith Busch <keith.busch@intel.com>
List-Id: dm-devel.ids

On Tue, May 5, 2015 at 11:48 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, May 05, 2015 at 11:08:20PM -0700, Ming Lin wrote:
>> How about below incremental patch?
>
>> -
>> -             /*
>> -              * If the queue doesn't support SG gaps and adding this
>> -              * offset would create a gap, disallow it.
>> -              */
>> -             if (q->queue_flags & (1 << QUEUE_FLAG_SG_GAPS) &&
>> -                 bvec_gap_to_prev(prev, offset))
>> -                     return 0;
>
> You need to keep the explicit checks for the BLOCK_PC case, as we can't
> split those.

I'll keep it. Thanks.

>
> Otherwise it looks fine.
