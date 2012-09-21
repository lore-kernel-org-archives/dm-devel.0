From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 23/26] raid1: use bio_alloc_pages()
Date: Thu, 20 Sep 2012 21:51:46 -0700
Message-ID: <20120921045146.GB29160@moria.home.lan>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-24-git-send-email-koverstreet@google.com>
 <20120921004827.GA7264@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120921004827.GA7264-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

On Thu, Sep 20, 2012 at 05:48:27PM -0700, Tejun Heo wrote:
> On Mon, Sep 10, 2012 at 05:22:34PM -0700, Kent Overstreet wrote:
> > Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> > CC: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
> 
> I think it's better to merge this and the previous patch.  It's not
> like we're converting a lot of users.

Ok, will do.
