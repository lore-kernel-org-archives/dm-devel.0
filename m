From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [git pull] device-mapper update for 2.6.25
Date: Fri, 8 Feb 2008 03:24:23 +0000
Message-ID: <20080208032423.GX8075@agk.fab.redhat.com>
References: <20080208024532.GC24157@agk.fab.redhat.com> <20080207190447.b4dcfe0c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763540AbYBHD0R@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080207190447.b4dcfe0c.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Brian Wood <brian.j.wood@intel.com>, Daniel Walker <dwalker@mvista.com>, Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Brassow <jbrassow@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Milan Broz <mbroz@redhat.com>, Paul Jimenez <pj@place.org>, "Robert P. J. Day" <rpjday@crashcourse.ca>, Vasily Averin <vvs@sw.ru>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Feb 07, 2008 at 07:04:47PM -0800, Andrew Morton wrote:
> On Fri, 8 Feb 2008 02:45:32 +0000 Alasdair G Kergon <agk@redhat.com> wrote:
> 
> >       dm: move deferred bio flushing to workqueue
> 
> To my unpracticed eye this one looks fairly fundamental.  Unfortunately the
> changelog:
> 
>   Add a single-thread workqueue for each mapped device and move flushing
>   of the lists of pushback and deferred bios to this new workqueue.
> 
> tells us nothing of the reasons for this change.  (It should have done so!)
> 
> It _looks_ pretty unscalable.  Perhaps these deferred BIOs don't happen
> very often?
 
Indeed - it's a rare occurrence - happens when the dm device is
suspended/resumed which usually means it was being reconfigured by something in
userspace.

It's the first patch of a series that will provide barrier support (slated for
2.6.26).

The appearance of all these workqueues in dm goes back to this old change:
  md-dm-reduce-stack-usage-with-stacked-block-devices.patch

Alasdair
-- 
agk@redhat.com
