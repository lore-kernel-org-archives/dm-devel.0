From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 07/13] pktcdvd: Switch to bio_kmalloc()
Date: Fri, 18 May 2012 09:18:52 -0700
Message-ID: <20120518161852.GG19388@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <04a4d6c2c8b6f0097e3594c6e0932093afffc1da.1337308722.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <04a4d6c2c8b6f0097e3594c6e0932093afffc1da.1337308722.git.koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

On Thu, May 17, 2012 at 10:59:54PM -0400, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org wrote:
> From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> This is prep work for killing bi_destructor

Again, it would be great if the commit message described what
conversion is taking place how and how it's been tested.  Please also
cc the maintainer.

Thanks.

-- 
tejun
