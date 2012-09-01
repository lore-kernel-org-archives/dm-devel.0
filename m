From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Date: Fri, 31 Aug 2012 19:13:48 -0700
Message-ID: <20120901021348.GB19535@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120830220745.GI27257-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: dm-devel.ids

Hello, Vivek.

On Thu, Aug 30, 2012 at 06:07:45PM -0400, Vivek Goyal wrote:
> Here is one quick and dirty proof of concept patch. It checks for stack
> depth and if remaining space is less than 20% of stack size, then it
> defers the bio submission to per queue worker.

So, it removes breadth-first walking of bio construction by ensuring
stack overflow never happens by bouncing to workqueue if stack usage
seems too high.

I do like removal of breadth-first walking.  It makes failure
scenarios a lot less mind-bending.  That said, Kent is right that this
can incur significant overhead for certain configurations, and looking
at stack usage in block layer is rather nasty both in design and
implementation.

If we're gonna need rescuer anyway and can get it right and the
mechanism can be contained in block proper relatively well, I think it
would be better to make bread-first walking safe.  Both are nasty in
their own ways after all.

Thanks.

-- 
tejun
