From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v4 01/11] block: make generic_make_request handle
 arbitrarily sized bios
Date: Fri, 29 May 2015 11:15:35 -0400
Message-ID: <20150529151534.GA27800@redhat.com>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org>
 <1432318723-18829-2-git-send-email-mlin@kernel.org>
 <20150526143626.GA4315@redhat.com>
 <CAF1ivSb3ptYObS3_8bJwWhq98EcNgAgRhN_L-c3uyFfCzdn=9A@mail.gmail.com>
 <20150526160400.GB4715@redhat.com>
 <CAF1ivSZ351yV4re1Ghf5yqPjgq6aXjrZT4yWd+T9msAFsBnDSw@mail.gmail.com>
 <20150528003627.GD32216@agk-dp.fab.redhat.com>
 <CAF1ivSY1w40wixbRZJq0dnT9K15uOMmMmAEUELLdrG5=owFsLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAF1ivSY1w40wixbRZJq0dnT9K15uOMmMmAEUELLdrG5=owFsLA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Dongsu Park <dpark@posteo.net>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: dm-devel.ids

On Fri, May 29 2015 at  3:05P -0400,
Ming Lin <mlin@kernel.org> wrote:

> On Wed, May 27, 2015 at 5:36 PM, Alasdair G Kergon <agk@redhat.com> wrote:
> > On Wed, May 27, 2015 at 04:42:44PM -0700, Ming Lin wrote:
> >> Here are fio results of XFS on a DM stripped target with 2 SSDs + 1 HDD.
> >> Does it make sense?
> >
> > To stripe across devices with different characteristics?
> >
> > Some suggestions.
> >
> > Prepare 3 kernels.
> >   O - Old kernel.
> >   M - Old kernel with merge_bvec_fn disabled.
> 
> How to disable it?
> Maybe just hack it as below?
> 
> void blk_queue_merge_bvec(struct request_queue *q, merge_bvec_fn *mbfn)
> {
>         //q->merge_bvec_fn = mbfn;
> }

Right, there isn't an existing way to disable it, you'd need a hack like
that.
