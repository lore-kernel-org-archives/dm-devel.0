From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] dm: sparse: Annotate field with __rcu for checking
Date: Sun, 28 Sep 2014 00:34:10 -0700
Message-ID: <20140928073409.GC5015@linux.vnet.ibm.com>
References: <1411671049-20441-1-git-send-email-bobby.prani@gmail.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1411671049-20441-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, josh@joshtriplett.org
List-Id: dm-devel.ids

On Thu, Sep 25, 2014 at 02:50:43PM -0400, Pranith Kumar wrote:
> Annotate the map field with __rcu since this is a rcu pointer which is checked
> by sparse.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Queued them both, thank you!

Josh, given this change, are you OK with my applying your Reviewed-by
to the RCU_INIT_POINTER() patch?

							Thanx, Paul

> ---
>  drivers/md/dm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 32b958d..746411b 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -140,7 +140,7 @@ struct mapped_device {
>  	 * Use dm_get_live_table{_fast} or take suspend_lock for
>  	 * dereference.
>  	 */
> -	struct dm_table *map;
> +	struct dm_table __rcu *map;
> 
>  	unsigned long flags;
> 
> -- 
> 2.1.0
> 
