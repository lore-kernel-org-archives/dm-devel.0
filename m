From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/1] dm raid: fix compat_features validation
Date: Tue, 11 Oct 2016 10:46:42 -0400
Message-ID: <20161011144642.GA24888@redhat.com>
References: <20161011142835.11620-1-apw@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161011142835.11620-1-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Whitcroft <apw@canonical.com>
Cc: Alasdair Kergon <agk@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Oct 11 2016 at 10:28am -0400,
Andy Whitcroft <apw@canonical.com> wrote:

> In commit ecbfb9f118bce4 ("dm raid: add raid level takeover support") a new
> compatible feature flag was added.  Validation for these compat_features
> was added but this only passes for new raid mappings with this feature
> flag.  This causes previously created raid mappings to be failed at import.
> 
> Check compat_features for any valid combinations.
> 
> Fixes: ecbfb9f118bce4 ("dm raid: add raid level takeover support")
> BugLink: http://bugs.launchpad.net/bugs/1631298
> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> ---
>  drivers/md/dm-raid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> It very much looks like these are intended to be optional extended feature
> flags.  That we should be accepting any valid flag and rejecting any bit
> not in that set.  We should however not be ensuring that specific bits
> are actually set.  Certainly as things stand raid sets built on previous
> kernel versions cannot be assembled.

Right, your patch looks good to me.  But I'll wait for confirmation from
Heinz before I stage your fix.

Thanks,
Mike
