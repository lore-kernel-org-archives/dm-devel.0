From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 06/16] block: Add an explicit bio flag for
 bios that own their bvec
Date: Mon, 28 May 2012 10:52:11 +0900
Message-ID: <20120528015211.GF9891@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
	<1337977539-16977-7-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1337977539-16977-7-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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

On Fri, May 25, 2012 at 01:25:29PM -0700, Kent Overstreet wrote:
> This is for the new bio splitting code. When we split a bio, if the
> split occured on a bvec boundry we reuse the bvec for the new bio. But
> that means bio_free() can't free it, hence the explicit flag.

I keep having the same complaints.  The explanation isn't detailed
enough.  So, the necessity for this patch arises from the fact that
the current bio_split doesn't use the usual bio allocation path to
create split bio - it just supports fixed bvec allocation via bio_pair
allocation which is allowable because of the severe restrictions the
current bio_split() - but the new bio_split() wants to do it in
general manner and thus wants the usual bvec allocation.

Why do I (or anyone for that matter) have to go forward in the patch
series to reconstruct the rationale?  Why doesn't the patch
description already explain this?  Why isn't this still fixed when
lack of proper patch description has already been pointed out multiple
times?

I'm gonna stop here on this series.

* *Please* spend more effort on patch description and understanding
  and applying the reviews.  If you don't like the opinions expressed
  in reviews, please argue.  If reviews get ignored, why would anyone
  review your patches at all?

* It would probably be better to split the series so that more
  experimental / constroversial stuff is in separate patch series.

Thanks.

-- 
tejun
