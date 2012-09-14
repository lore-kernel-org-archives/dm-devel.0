From: Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v10 3/8] dm: Use bioset's front_pad for
	dm_rq_clone_bio_info
Date: Fri, 14 Sep 2012 20:05:38 +0100
Message-ID: <20120914190538.GN15728@agk-dp.fab.redhat.com>
References: <1347050642-7080-1-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1347050642-7080-1-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Fri, Sep 07, 2012 at 01:44:01PM -0700, Kent Overstreet wrote:
> Previously, dm_rq_clone_bio_info needed to be freed by the bio's
> destructor to avoid a memory leak in the blk_rq_prep_clone() error path.
> This gets rid of a memory allocation and means we can kill
> dm_rq_bio_destructor.
> 
> The _rq_bio_info_cache kmem cache is unused now and needs to be deleted,
> but due to the way io_pool is used and overloaded this looks not quite
> trivial so I'm leaving it for a later patch.
 
Acked-by: Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

> +/*
> + * Unused now, and needs to be deleted. But since io_pool is overloaded and it's
> + * still used for _io_cache, I'm leaving this for a later cleanup
> + */

Please avoid "I" in a source file unless you are the author of the file or
put your name after your comments.

An unattributed "FIXME" style of comment here would be fine.

Alasdair
