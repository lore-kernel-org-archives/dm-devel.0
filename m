From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] block: Avoid deadlocks with bio allocation by
 stacking drivers
Date: Mon, 10 Sep 2012 16:13:26 -0700
Message-ID: <20120910231326.GG7677@google.com>
References: <1347055973-11581-3-git-send-email-koverstreet@google.com>
 <20120908193641.GB12773@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120910002810.GA23241@moria.home.lan>
 <20120910172210.GC14103@google.com>
 <20120910202435.GG16360@google.com>
 <20120910204010.GA32310@google.com>
 <20120910213349.GH16360@google.com>
 <20120910213710.GA7677@google.com>
 <20120910215633.GA19739@google.com>
 <20120910220910.GB7677@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120910220910.GB7677-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
List-Id: dm-devel.ids

Hello, again.

On Mon, Sep 10, 2012 at 03:09:10PM -0700, Tejun Heo wrote:
> I'm still a bit scared but think this is correct.
> 
>  Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> One last thing is that we may want to add @name on bioset creation so
> that we can name the workqueue properly but that's for another patch.

Yet another thing that I noticed in a different discussion.

  http://thread.gmane.org/gmane.linux.network.drbd.devel/2130

Before this, I think bios didn't get reordered while they're traveling
down the stacked bio drivers.  After this, I don't think that's true
anymore.  Currently, IIRC, we don't have any ordering functionality at
bio interface, so I don't think this breaks anything but this can lead
to stupidly subtle bugs if the upper layer is making assumption on
ordering somehow.  It's something which at least should be noted, I
think.  Whether we want to update the code so that ordering is
maintained, I don't know.  I hope not.  It's already crazy complex. :(

Thanks.

-- 
tejun
