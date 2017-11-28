From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/4] dm: convert dm_dev_internal.count from atomic_t to
 refcount_t
Date: Tue, 28 Nov 2017 14:02:43 -0500
Message-ID: <20171128190225.GA32559@redhat.com>
References: <1508485059-21881-1-git-send-email-elena.reshetova@intel.com>
 <1508485059-21881-4-git-send-email-elena.reshetova@intel.com>
 <20171123154941.GA15790@agk-dp.fab.redhat.com>
 <2236FBA76BA1254E88B949DDB74E612B802C1F07@IRSMSX102.ger.corp.intel.com>
 <CAMM=eLfrnQqBH06pPnNKfmeF=AjScAxjR1WD7Ur9NAEY=4Sxog@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B802C3EDA@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B802C3EDA@IRSMSX102.ger.corp.intel.com>
Sender: linux-bcache-owner@vger.kernel.org
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Alasdair G Kergon <agk@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "keescook@chromium.org" <keescook@chromium.org>, "peterz@infradead.org" <peterz@infradead.org>, "shli@kernel.org" <shli@kernel.org>, "koverstreet@google.com" <koverstreet@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "ejt@redhat.com" <ejt@redhat.com>, "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Tue, Nov 28 2017 at  5:07am -0500,
Reshetova, Elena <elena.reshetova@intel.com> wrote:

> 
> > On Fri, Nov 24, 2017 at 2:36 AM, Reshetova, Elena
> > <elena.reshetova@intel.com> wrote:
> > >> On Fri, Oct 20, 2017 at 10:37:38AM +0300, Elena Reshetova wrote:
> > >> >     } else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
> > >> >             r = upgrade_mode(dd, mode, t->md);
> > >> >             if (r)
> > >> >                     return r;
> > >> > +           refcount_inc(&dd->count);
> > >> >     }
> > >>
> > >> Missing here:
> > >>
> > >>         else
> > >>               refcount_inc(&dd->count);
> > >>
> > >> ?
> > >
> > > Oh, yes, thanks for catching this! I think this got unnoticed so far and patch was
> > merged, so I am going to send a followup patch now.
> > 
> > I pushed this fix and will send to Linus next week:
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-
> > dm.git/commit/?h=dm-4.15&id=d908af82d06cc420f9581c97c6db941cb87e4434
> 
> 
> I guess you mean this commit:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=c2318d07ead871f058dda62e942ed7b6b1c1cfcf
> 
> Unfortunately it is not correct:
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 88130b5..f6d32ee 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -451,15 +451,15 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
>  			return r;
>  		}
>  
> -		refcount_set(&dd->count, 1);
> +		refcount_set(&dd->count, 0);
>  		list_add(&dd->list, &t->devices);
>  
>  	} else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
>  		r = upgrade_mode(dd, mode, t->md);
>  		if (r)
>  			return r;
> -		refcount_inc(&dd->count);
>  	}
> +	refcount_inc(&dd->count);
>  
> Problem will be here if you hit this refcount_inc() after the refcount_set(&dd->count, 0) earlier. 
> refcount_inc() does not increment on zero value *ever* for security reasons and instead people
> should initialize refcounters to 1 always and do increments from there if needed. 

include/linux/refcount.h:refcount_inc() definitely doesn't avoid
incrementing zero value.

Neither does lib/refcount.c:refcount_inc() but it does spew a WARN_ON by
assuming a zero value means use-after-free.

> This was the reason for the initial change I did, my mistake was just to forget to increment it also
> in case condition (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) fails. 
> 
> I have issues with my intel smpt server for sending patches (I will get it fixed tomorrow from internal network),
> so I am attaching the patch I did end of last week to this thread instead (or alternatively can properly send it tomorrow after fix). 
> Sorry for the delay!

I was tempted to revert your original commits that switch DM code to
using refcount_t.  Already proved more trouble than it is worth.

But I'll drop my commit and take your fix.

Mike
