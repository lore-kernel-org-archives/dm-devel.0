From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 3/4] dm: convert dm_dev_internal.count from
        atomic_t to refcount_t
Date: Thu, 23 Nov 2017 15:49:41 +0000
Message-ID: <20171123154941.GA15790@agk-dp.fab.redhat.com>
References: <1508485059-21881-1-git-send-email-elena.reshetova@intel.com> <1508485059-21881-4-git-send-email-elena.reshetova@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1508485059-21881-4-git-send-email-elena.reshetova@intel.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: dm-devel@redhat.com, keescook@chromium.org, snitzer@redhat.com, peterz@infradead.org, shli@kernel.org, koverstreet@google.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, ejt@redhat.comg, kent.overstreet@gmail.com, agk@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Fri, Oct 20, 2017 at 10:37:38AM +0300, Elena Reshetova wrote:
>  	} else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
>  		r = upgrade_mode(dd, mode, t->md);
>  		if (r)
>  			return r;
> +		refcount_inc(&dd->count);
>  	}

Missing here:

        else
		refcount_inc(&dd->count);

?

Alasdair
