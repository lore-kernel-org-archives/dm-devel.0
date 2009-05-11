From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [RFC PATCH dm-ioband] Added in blktrace msgs for dm-ioband
Date: Mon, 11 May 2009 19:31:15 +0900 (JST)
Message-ID: <20090511.193115.189717098.ryov@valinux.co.jp>
References: <20090427.184417.189717449.ryov@valinux.co.jp>
	<49FE5FEB.6040207@cn.fujitsu.com>
	<20090507.092322.71121515.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753161AbZEKKbZ@vger.kernel.org>
In-Reply-To: <20090507.092322.71121515.ryov@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: lizf@cn.fujitsu.com
Cc: Alan.Brunelle@hp.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi Li,

From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [RFC PATCH dm-ioband] Added in blktrace msgs for dm-ioband
Date: Thu, 07 May 2009 09:23:22 +0900 (JST)

> Hi Li,
> 
> From: Li Zefan <lizf@cn.fujitsu.com>
> Subject: Re: [RFC PATCH dm-ioband] Added in blktrace msgs for dm-ioband
> Date: Mon, 04 May 2009 11:24:27 +0800
> 
> > Ryo Tsuruta wrote:
> > > Hi Alan,
> > > 
> > >> Hi Ryo -
> > >>
> > >> I don't know if you are taking in patches, but whilst trying to uncover
> > >> some odd behavior I added some blktrace messages to dm-ioband-ctl.c. If
> > >> you're keeping one code base for old stuff (2.6.18-ish RHEL stuff) and
> > >> upstream you'll have to #if around these (the blktrace message stuff
> > >> came in around 2.6.26 or 27 I think).
> > >>
> > >> My test case was to take a single 400GB storage device, put two 200GB
> > >> partitions on it and then see what the "penalty" or overhead for adding
> > >> dm-ioband on top. To do this I simply created an ext2 FS on each
> > >> partition in parallel (two processes each doing a mkfs to one of the
> > >> partitions). Then I put two dm-ioband devices on top of the two
> > >> partitions (setting the weight to 100 in both cases - thus they should
> > >> have equal access).
> > >>
> > >> Using default values I was seeing /very/ large differences - on the
> > >> order of 3X. When I bumped the number of tokens to a large number
> > >> (10,240) the timings got much closer (<2%). I have found that using
> > >> weight-iosize performs worse than weight (closer to 5% penalty).
> > > 
> > > I could reproduce similar results. One dm-ioband device seems to stop
> > > issuing I/Os for a few seconds at times. I'll investigate more on that.
> > >  
> > >> I'll try to formalize these results as I go forward and report out on
> > >> them. In any event, I thought I'd share this patch with you if you are
> > >> interested...
> > > 
> > > Thanks. I'll include your patche into the next release.
> > >  
> > 
> > IMO we should use TRACE_EVENT instead of adding new blk_add_trace_msg().
> 
> Thanks for your suggestion. I'll use TRACE_EVENT instead.

blk_add_trace_msg() supports both blktrace and tracepoints. I can
get messages from dm-ioband through debugfs. Could you expain why
should we use TRACE_EVENT instead?

> > 
> > >> Here's a sampling from some blktrace output (sorry for the wrapping) - I
> > >> should note that I'm a bit scared to see such large numbers of holds
> > >> going on when the token count should be >5,000 for each device...
> > >> Holding these back in an equal access situation is inhibiting the block
> > >> I/O layer to merge (most) of these (as mkfs performs lots & lots of
> > >> small but sequential I/Os).
> > 
> 
> Thanks,
> Ryo Tsuruta

Thanks,
Ryo Tsuruta
