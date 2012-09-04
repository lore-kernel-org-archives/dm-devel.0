From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Date: Mon, 3 Sep 2012 20:41:00 -0700
Message-ID: <20120904034100.GA21602@moria.home.lan>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com>
 <20120831014359.GB15218@moria.home.lan>
 <Pine.LNX.4.64.1209031638110.15620@file.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1209031638110.15620-e+HWlsje6Db1wF9wiOj0lkEOCMrvLtNR@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: dm-devel.ids

On Mon, Sep 03, 2012 at 04:41:37PM -0400, Mikulas Patocka wrote:
> ... or another possibility - start a timer when something is put to 
> current->bio_list and use that timer to pop entries off current->bio_list 
> and submit them to a workqueue. The timer can be cpu-local so only 
> interrupt masking is required to synchronize against the timer.
> 
> This would normally run just like the current kernel and in case of 
> deadlock, the timer would kick in and resolve the deadlock.

Ugh. That's a _terrible_ idea.

Remember the old plugging code? You ever have to debug performance
issues caused by it?

> 
> > I could be convinced, but right now I prefer my solution.
> 
> It fixes bio allocation problem, but not other similar mempool problems in 
> dm and md.

I looked a bit more, and actually I think the rest of the problem is
pretty limited in scope - most of those mempool allocations are per
request, not per split.

I'm willing to put some time into converting dm/md over to bioset's
front_pad. I'm having to learn the code for the immutable biovec work,
anyways.
