From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH 02/13] dm: kill dm_rq_bio_destructor
Date: Fri, 18 May 2012 11:50:27 -0700
Message-ID: <20120518185027.GA9673@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <f07bc0f57562d98078e0f4c507cae165aa159e7c.1337308722.git.koverstreet@google.com>
 <20120518155729.GB19388@google.com>
 <20120518164319.GJ29330@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120518164319.GJ29330-FDJ95KluN3Z0klwcnFlA1dvLeJWuRmrY@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Junichi Nomura <j-nomura-JhyGz2TFV9J8UrSeD/g0lQ@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Fri, May 18, 2012 at 05:43:19PM +0100, Alasdair G Kergon wrote:
> On Fri, May 18, 2012 at 08:57:29AM -0700, Tejun Heo wrote:
> > Please explain why this is done and how it's safe.  Alasdair / dm
> > folks, can you please ack this?
>  
> I think it's relying on there being never more than one reference on those 
> bios so that that endio fn, called exactly once, always frees it and there
> are no dm_puts elsewhere.

Is that a safe assumption? From my perusal of the code it certainly
looks like it should be, but I don't know dm all that well.

Seems like it might be better to use bio set's front_pad to put it in
the same allocation as the bio, but I don't really want to get into that
myself.
