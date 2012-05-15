From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Bcache v13 05/16] Export get_random_int()
Date: Tue, 15 May 2012 09:44:40 -0700
Message-ID: <20120515164440.GB20827@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <5278ad493eb3ad441b2091b4c119d741e47f5c97.1336619038.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5278ad493eb3ad441b2091b4c119d741e47f5c97.1336619038.git.koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Wed, May 09, 2012 at 11:09:13PM -0400, Kent Overstreet wrote:
> This is needed for bcache - it needs a fast source of random numbers for
> the throttling code in order to fuzz IO sizes, but the random numbers
> don't need to be any good (and it immediately converts it to a
> binomially distributed random number with popcount anyways).
> 
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Please cc the maintainer (for other patches too).

Thanks.

-- 
tejun
