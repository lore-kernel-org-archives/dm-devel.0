From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 01/14] block: Generalized bio pool freeing
Date: Thu, 24 May 2012 09:19:14 -0700
Message-ID: <20120524161914.GD27983@google.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
	<1337817771-25038-2-git-send-email-koverstreet@google.com>
	<20120524160944.GB27983@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120524160944.GB27983-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

On Thu, May 24, 2012 at 09:09:44AM -0700, Tejun Heo wrote:
> On Wed, May 23, 2012 at 05:02:38PM -0700, Kent Overstreet wrote:
> > With the old code, when you allocate a bio from a bio pool you have to
> > implement your own destructor that knows how to find the bio pool the
> > bio was originally allocated from.
> > 
> > This adds a new field to struct bio (bi_pool) and changes
> > bio_alloc_bioset() to use it. This makes various bio destructors
> > unnecessary, so they're then deleted.
> > 
> > Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Change-Id: I5eb66c1d6910757f4af8755b8857dcbe4619cf8d
> 
> Please drop Change-ID tag and it would be great how you tested the
> changes, other than that,
> 
>  Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

To add a bit here too.  Please explain "why" you're making this
change.  Is it because bi_destructor interface is cumbersome?  Adding
bi_pool is overhead - why is it justified?  Is it because one pointer
is fine to add to struct bio (which I kinda agree) or are there future
changes which will reverse the overhead (which is the case here).

In general, I find the descriptions insufficient.  They don't describe
the reasons and reasoning behind the patch.

Thanks.

-- 
tejun
