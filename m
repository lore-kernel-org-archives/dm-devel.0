From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH 07/10] block: kill merge_bvec_fn() completely
Date: Tue, 28 Apr 2015 23:32:00 -0700
Message-ID: <CAF1ivSb0OfbH8diZwep+ay-gYy3eV8yaY_RbdMjTs7Vp2t=WOg@mail.gmail.com>
References: <1430203717-13307-1-git-send-email-mlin@kernel.org>
	<1430203717-13307-8-git-send-email-mlin@kernel.org>
	<20150428173137.GC12975@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20150428173137.GC12975@agk-dp.fab.redhat.com>
Sender: ceph-devel-owner@vger.kernel.org
To: lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dongsu.park@profitbricks.com>, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Yehuda Sadeh <yehuda@inktank.com>, Sage Weil <sage@inktank.com>, Alex Elder <elder@kernel.org>, ceph-devel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dave Chinner <dchinner@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>
List-Id: dm-devel.ids

On Tue, Apr 28, 2015 at 10:31 AM, Alasdair G Kergon <agk@redhat.com> wrote:
> On Mon, Apr 27, 2015 at 11:48:34PM -0700, Ming Lin wrote:
>> As generic_make_request() is now able to handle arbitrarily sized bios,
>> it's no longer necessary for each individual block driver to define its
>> own ->merge_bvec_fn() callback. Remove every invocation completely.
>
> merge_bvec_fn is also about telling the code building up bios what optimum
> maximum size to use.
>
> Have you got some test data to demonstrate that we won't find some situations
> where performance is now lost by code building up bios that are far too big
> and are always going to have to be split up later?

Not yet.
Fengguang will help to run some tests.

Thanks.

>
> Alasdair
>
