From: Jeff Garzik <jgarzik-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v6 12/13] block: Add bio_clone_bioset(), bio_clone_kmalloc()
Date: Wed, 22 Aug 2012 13:13:30 -0400
Message-ID: <5035133A.9060805@pobox.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com> <1345655050-28199-13-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345655050-28199-13-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Garzik <jeff-o2qLIJkoznsdnm+yROfE0A@public.gmane.org>
List-Id: dm-devel.ids

On 08/22/2012 01:04 PM, Kent Overstreet wrote:
> Previously, there was bio_clone() but it only allocated from the fs bio
> set; as a result various users were open coding it and using
> __bio_clone().
>
> This changes bio_clone() to become bio_clone_bioset(), and then we add
> bio_clone() and bio_clone_kmalloc() as wrappers around it, making use of
> the functionality the last patch adedd.
>
> This will also help in a later patch changing how bio cloning works.
>
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> CC: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
> CC: Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> CC: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
> CC: Jeff Garzik <jeff-o2qLIJkoznsdnm+yROfE0A@public.gmane.org>
> ---
>   block/blk-core.c       |  8 +-------
>   drivers/block/osdblk.c |  3 +--
>   drivers/md/dm.c        |  4 ++--
>   drivers/md/md.c        | 20 +-------------------
>   fs/bio.c               | 13 ++++++++-----
>   fs/exofs/ore.c         |  5 ++---
>   include/linux/bio.h    | 17 ++++++++++++++---
>   7 files changed, 29 insertions(+), 41 deletions(-)

Acked-by: Jeff Garzik <jgarzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
