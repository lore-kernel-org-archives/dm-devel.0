From: Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 05/26] block: Add bio_end()
Date: Mon, 17 Sep 2012 10:17:24 +0100
Message-ID: <1347873444.2688.3.camel@menhir>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
	 <1347322957-25260-6-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1347322957-25260-6-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

Hi,

On Mon, 2012-09-10 at 17:22 -0700, Kent Overstreet wrote:
> Just a little convenience macro - main reason to add it now is preparing
> for immutable bio vecs, it'll reduce the size of the patch that puts
> bi_sector/bi_size/bi_idx into a struct bvec_iter.
> 
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

GFS2 bits:
Acked-by: Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Steve.
