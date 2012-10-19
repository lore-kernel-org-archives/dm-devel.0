From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 00/24] Prep work for immutable bio vecs
Date: Thu, 18 Oct 2012 18:14:45 -0700
Message-ID: <20121019011445.GJ13370@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

Hello,

On Mon, Oct 15, 2012 at 01:08:34PM -0700, Kent Overstreet wrote:
> Since last time - split bio integrity stuff out into its own 2 patch series.
> 
> Also changed bio_advance() a bit - it now explicitly special cases discard and
> WRITE_SAME requests, so that partial completions will work. Previously, partial
> completions worked for other requests but would've silently blown up for those
> - this'll be of use later too, for generic bio splitting.
> 
> I've got 3 patch series queued up but they all should be independent - git tree
> is at
> 
> http://evilpiepirate.org/git/linux-bcache.git for-jens
> 
> It's on top of jens' for-next branch.

Your patch series posting is messed up somehow.  I'm gonna review from
the git branch and post comments here but you'll probably have to post
them again.

Thanks.

-- 
tejun
