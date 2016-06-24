From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: block: fix blk_queue_split() resource exhaustion
Date: Fri, 24 Jun 2016 11:15:47 -0400
Message-ID: <20160624151547.GA13898@redhat.com>
References: <1466583730-28595-1-git-send-email-lars.ellenberg@linbit.com>
 <CACVXFVOtzcPpmg9Z_P6xN99dW=Sb_cCQNd-VcP0s5Nk0yHbwXQ@mail.gmail.com>
 <20160624142711.GF3239@soda.linbit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160624142711.GF3239@soda.linbit>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Ming Lei <ming.lei@canonical.com>, linux-block@vger.kernel.org, Roland Kammerer <roland.kammerer@linbit.com>, Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Takashi Iwai <tiwai@suse.de>, Jiri Kosina <jkosina@suse.cz>, Zheng Liu <gnehzuil.liu@gmail.com>, Keith Busch <keith.busch@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Fri, Jun 24 2016 at 10:27am -0400,
Lars Ellenberg <lars.ellenberg@linbit.com> wrote:

> On Fri, Jun 24, 2016 at 07:36:57PM +0800, Ming Lei wrote:
> > >
> > > This is not a theoretical problem.
> > > At least int DRBD, and an unfortunately high IO concurrency wrt. the
> > > "max-buffers" setting, without this patch we have a reproducible deadlock.
> > 
> > Is there any log about the deadlock? And is there any lockdep warning
> > if it is enabled?
> 
> In DRBD, to avoid potentially very long internal queues as we wait for
> our replication peer device and local backend, we limit the number of
> in-flight bios we accept, and block in our ->make_request_fn() if that
> number exceeds a configured watermark ("max-buffers").
> 
> Works fine, as long as we could assume that once our make_request_fn()
> returns, any bios we "recursively" submitted against the local backend
> would be dispatched. Which used to be the case.

It'd be useful to know whether this patch fixes your issue:
https://patchwork.kernel.org/patch/7398411/

Ming Lei didn't like it due to concerns about I contexts changing
(whereby breaking merging that occurs via plugging).

But if it _does_ fix your issue then the case for the change is
increased; and we just need to focus on addressing Ming's concerns
(Mikulas has some ideas).

Conversely, and in parallel, Mikulas can look to see if your approach
fixes the observed dm-snapshot deadlock that he set out to fix.
