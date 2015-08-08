From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH v5 01/11] block: make generic_make_request handle
 arbitrarily sized bios
Date: Fri, 7 Aug 2015 21:22:26 -0800
Message-ID: <20150808052226.GA7050@kmo-pixel>
References: <20150731213831.GA16464@redhat.com>
 <1438412290.26596.14.camel@hasee>
 <20150801163356.GA21478@redhat.com>
 <1438581502.26596.24.camel@hasee>
 <20150804113626.GA12682@lst.de>
 <1438754604.29731.31.camel@hasee>
 <20150807073001.GA17485@lst.de>
 <1438990806.24452.8.camel@ssi>
 <20150808003057.GA1811@kmo-pixel>
 <CAF1ivSYAiRqG1RhxiHE+cfogB_VKyDDs0aE7YbtZ2o6UeGhZcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAF1ivSYAiRqG1RhxiHE+cfogB_VKyDDs0aE7YbtZ2o6UeGhZcQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, lkml <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Dongsu Park <dpark@posteo.net>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, Ming Lin <ming.l@ssi.samsung.com>
List-Id: dm-devel.ids

On Fri, Aug 07, 2015 at 10:17:43PM -0700, Ming Lin wrote:
> On Fri, Aug 7, 2015 at 5:30 PM, Kent Overstreet
> > Ideally we'd get upper layers out of the business of knowing about the queue
> > limits at all - that was the point of the patch series, after all.
> >
> > Instead of using UINT_MAX, would it work to just make the max 1 << 31 sectors?'
> 
> 1 << 31 = 2G bytes = 0x400000 sectors.
> 
> Yes, that works as long as it's multiple of granularity.

Is granularity required to be a power of two? One would hope, but looking at the
code that doesn't appear to be a requirement... ugh, that's terrible...
