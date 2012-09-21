From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 20/26] block: Add bio_for_each_segment_all()
Date: Thu, 20 Sep 2012 17:35:23 -0700
Message-ID: <20120921003523.GX7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-21-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1347322957-25260-21-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

Hello,

On Mon, Sep 10, 2012 at 05:22:31PM -0700, Kent Overstreet wrote:
> This is part of the immutable bvec prep work; bio_for_each_segment() is
> going to have a different implementation so these need to be split
> apart.
>
> This change is also to better document the intent of code that's using
> it - bio_for_each_segment_all() is only legal to use for code that owns
> the bio.

How about something like following?

 __bio_for_each_segment() iterates bvecs from the specified index
 instead of bio->bv_idx.  Currently, the only usage is to walk all the
 bvecs after the bio has been advanced by specifying 0 index.

 To help immutable bvec implementation, replace it with
 bio_for_each_segment_all() which also better documents the intent of
 code that's using it.  Note that bio_for_each_segment_all() should
 only be used by the code which owns the bio.

-- 
tejun
