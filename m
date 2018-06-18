From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v3 1/5] md: Avoid namespace collision with bitmap API
Date: Mon, 18 Jun 2018 16:57:41 +0300
Message-ID: <49e96a4ecb3566139bef0b36093143077ceafd3f.camel@linux.intel.com>
References: <20180618131003.88110-1-andriy.shevchenko@linux.intel.com>
         <20180618131003.88110-2-andriy.shevchenko@linux.intel.com>
         <20180618134454.GA25547@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618134454.GA25547@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Yury Norov <ynorov@caviumnetworks.com>, linux-kernel@vger.kernel.org, mika.westerberg@linux.intel.com, Joe Perches <joe@perches.com>
List-Id: dm-devel.ids

On Mon, 2018-06-18 at 09:44 -0400, Mike Snitzer wrote:
> On Mon, Jun 18 2018 at  9:09am -0400,
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> 
> > bitmap API (include/linux/bitmap.h) has 'bitmap' prefix for its
> > methods.
> > 
> > On the other hand MD bitmap API is special case.
> > Adding 'md' prefix to it to avoid name space collision.
> > 
> > No functional changes intended.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  drivers/md/dm-raid.c                          |   6 +-
> >  drivers/md/md-bitmap.c                        | 301 +++++++++----
> > -----
> >  drivers/md/md-bitmap.h                        |  46 +--
> >  drivers/md/md-cluster.c                       |  16 +-
> >  drivers/md/md.c                               |  44 +--
> >  .../md/persistent-data/dm-space-map-common.c  |  12 +-
> >  drivers/md/raid1.c                            |  20 +-
> >  drivers/md/raid10.c                           |  26 +-
> >  drivers/md/raid5-cache.c                      |   2 +-
> >  drivers/md/raid5.c                            |  24 +-
> >  10 files changed, 244 insertions(+), 253 deletions(-)
> 
> Seems my previous mail just missed your v3 cutoff but...
> 
> <snip>
> 
> All of these drivers/md/persistent-data/dm-space-map-common.c renames
> are wrong.

So, let me understand this clear, the naming problem appears in one file
only. The rest is fine. Correct?

>   DM is the only consumer (it is confusing because all DM and
> MD code lives in drivers/md/ despite only sharing a bit of MD code).
> 
> Anyway, please rename bitmap methods in this file to have a
> "dm_bitmap"
> prefix instead.  Thanks.

Ah, okay, will do this in v4 later this week.

Thanks for review!

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
