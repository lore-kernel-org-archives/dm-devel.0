From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [2.6.29 PATCH 01/02] dm target: use module refcount
	directly
Date: Thu, 8 Jan 2009 14:50:09 -0600
Message-ID: <F36B0AAE-AF42-48F5-B2AB-743ACD6EA786@redhat.com>
References: <20090107204143.GR3512@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090107204143.GR3512@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>

  brassow

On Jan 7, 2009, at 2:41 PM, Alasdair G Kergon wrote:

> From: Cheng Renquan <crquan@gmail.com>
>
> The tt_internal's 'use' field is superfluous: the module's refcount  
> can do
> the work properly.  An acceptable side-effect is that this increases  
> the
> reference counts reported by 'lsmod'.
>
> Remove the superfluous test when removing a target module.
>
> Signed-off-by: Cheng Renquan <crquan@gmail.com>
> Reviewed-by: Alasdair G Kergon <agk@redhat.com>
> Signed-off-by: Alasdair G Kergon <agk@redhat.com>
> ---
> drivers/md/dm-target.c |   20 +++-----------------
> 1 files changed, 3 insertions(+), 17 deletions(-)
>
> Index: linux-2.6.28/drivers/md/dm-target.c
> ===================================================================
> --- linux-2.6.28.orig/drivers/md/dm-target.c	2009-01-07  
> 20:29:57.000000000 +0000
> +++ linux-2.6.28/drivers/md/dm-target.c	2009-01-07  
> 20:30:57.000000000 +0000
> @@ -18,7 +18,6 @@ struct tt_internal {
> 	struct target_type tt;
>
> 	struct list_head list;
> -	long use;
> };
>
> static LIST_HEAD(_targets);
> @@ -44,12 +43,8 @@ static struct tt_internal *get_target_ty
> 	down_read(&_lock);
>
> 	ti = __find_target_type(name);
> -	if (ti) {
> -		if ((ti->use == 0) && !try_module_get(ti->tt.module))
> -			ti = NULL;
> -		else
> -			ti->use++;
> -	}
> +	if (ti && !try_module_get(ti->tt.module))
> +		ti = NULL;
>
> 	up_read(&_lock);
> 	return ti;
> @@ -77,10 +72,7 @@ void dm_put_target_type(struct target_ty
> 	struct tt_internal *ti = (struct tt_internal *) t;
>
> 	down_read(&_lock);
> -	if (--ti->use == 0)
> -		module_put(ti->tt.module);
> -
> -	BUG_ON(ti->use < 0);
> +	module_put(ti->tt.module);
> 	up_read(&_lock);
>
> 	return;
> @@ -140,12 +132,6 @@ void dm_unregister_target(struct target_
> 		BUG();
> 	}
>
> -	if (ti->use) {
> -		DMCRIT("Attempt to unregister target still in use: %s",
> -		       t->name);
> -		BUG();
> -	}
> -
> 	list_del(&ti->list);
> 	kfree(ti);
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
