From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: [dm-devel] [PATCH 3/4] dm: convert dm_dev_internal.count from
        atomic_t to refcount_t
Date: Fri, 24 Nov 2017 07:36:26 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B802C1F07@IRSMSX102.ger.corp.intel.com>
References: <1508485059-21881-1-git-send-email-elena.reshetova@intel.com>
 <1508485059-21881-4-git-send-email-elena.reshetova@intel.com>
 <20171123154941.GA15790@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171123154941.GA15790@agk-dp.fab.redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "keescook@chromium.org" <keescook@chromium.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>, "shli@kernel.org" <shli@kernel.org>, "koverstreet@google.com" <koverstreet@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "ejt@redhat.comg" <ejt@redhat.comg>, "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

> On Fri, Oct 20, 2017 at 10:37:38AM +0300, Elena Reshetova wrote:
> >  	} else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
> >  		r = upgrade_mode(dd, mode, t->md);
> >  		if (r)
> >  			return r;
> > +		refcount_inc(&dd->count);
> >  	}
> 
> Missing here:
> 
>         else
> 		refcount_inc(&dd->count);
> 
> ?

Oh, yes, thanks for catching this! I think this got unnoticed so far and patch was merged, so I am going to send a followup patch now. 

Best Regards,
Elena.

> 
> Alasdair
