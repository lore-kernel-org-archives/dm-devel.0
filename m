From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH 1/2] dm log: use standard kernel module
	refcounts
Date: Mon, 30 Mar 2009 09:14:11 -0500
Message-ID: <BDDD0B35-8CCC-461F-BAC9-A737635B3C75@redhat.com>
References: <1238088833-9447-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1238088833-9447-1-git-send-email-snitzer@redhat.com>
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

ACK.

  brassow
On Mar 26, 2009, at 12:33 PM, Mike Snitzer wrote:

> Avoid private module usage accounting by removing 'use' from
> dm_dirty_log_internal.  The standard module reference counting is
> sufficient.
>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
> drivers/md/dm-log.c |   19 +++----------------
> 1 files changed, 3 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
> index 737961f..094c8f0 100644
> --- a/drivers/md/dm-log.c
> +++ b/drivers/md/dm-log.c
> @@ -20,7 +20,6 @@ struct dm_dirty_log_internal {
> 	struct dm_dirty_log_type *type;
>
> 	struct list_head list;
> -	long use;
> };
>
> static LIST_HEAD(_log_types);
> @@ -44,12 +43,8 @@ static struct dm_dirty_log_internal  
> *_get_dirty_log_type(const char *name)
> 	spin_lock(&_lock);
>
> 	log_type = __find_dirty_log_type(name);
> -	if (log_type) {
> -		if (!log_type->use && !try_module_get(log_type->type->module))
> -			log_type = NULL;
> -		else
> -			log_type->use++;
> -	}
> +	if (log_type && !try_module_get(log_type->type->module))
> +		log_type = NULL;
>
> 	spin_unlock(&_lock);
>
> @@ -120,10 +115,7 @@ static void put_type(struct dm_dirty_log_type  
> *type)
> 	if (!log_type)
> 		goto out;
>
> -	if (!--log_type->use)
> -		module_put(type->module);
> -
> -	BUG_ON(log_type->use < 0);
> +	module_put(type->module);
>
> out:
> 	spin_unlock(&_lock);
> @@ -173,11 +165,6 @@ int dm_dirty_log_type_unregister(struct  
> dm_dirty_log_type *type)
> 		return -EINVAL;
> 	}
>
> -	if (log_type->use) {
> -		spin_unlock(&_lock);
> -		return -ETXTBSY;
> -	}
> -
> 	list_del(&log_type->list);
>
> 	spin_unlock(&_lock);
> -- 
> 1.6.0.6
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
