From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH v5 0/4] block/dm: allow DM to defer
 blk_register_queue() until ready
Date: Mon, 15 Jan 2018 12:29:29 -0500
Message-ID: <20180115172928.GB24260@redhat.com>
References: <20180112150606.6037-1-snitzer@redhat.com>
 <1516036612.10386.2.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516036612.10386.2.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hare@suse.de" <hare@suse.de>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>, "djeffery@redhat.com" <djeffery@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: dm-devel.ids

On Mon, Jan 15 2018 at 12:16pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Fri, 2018-01-12 at 10:06 -0500, Mike Snitzer wrote:
> > I'm submitting this v5 with more feeling now ;)
> 
> Hello Mike,
> 
> Have these patches been tested with lockdep enabled? The following appeared in
> the kernel log when after I started testing Jens' for-next tree of this morning:

So you replied to v5, I emailed a v6 out for the relevant patch.  Just
want to make sure you're testing with either Jens' latest tree or are
using my v6 that fixed blk_mq_unregister_dev() to require caller holds
q->sysfs_lock ?

With the latest code that Jens merged, I do have lockdep enabled in my
kernel... but haven't seen any issues on the 2 testbeds I've been
hammering the changes on.

Ming was concerned about the potential for a lockdep splat (said he
tried expanding the scope of q->sysfs_lock in blk_unregister_queue
before and in doing so got lockdep to trigger).

Once you respond with what it is you're testing, and if it is latest
code, I'll look closer at what you've provided and see if it is real or
that lockdep just needs some training.

Thanks,
Mike
