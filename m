From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH 2/2] dm log: remove struct dm_dirty_log_internal
Date: Mon, 30 Mar 2009 09:14:52 -0500
Message-ID: <CFF82B89-2E09-438F-A405-A1648842AA27@redhat.com>
References: <1238088833-9447-1-git-send-email-snitzer@redhat.com>
	<1238088833-9447-2-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1238088833-9447-2-git-send-email-snitzer@redhat.com>
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

Code looks good.  I haven't tested.

  brassow

On Mar 26, 2009, at 12:33 PM, Mike Snitzer wrote:

> Remove the 'dm_dirty_log_internal' structure.  The resulting cleanup
> eliminates extra memory allocations.  Therefore exposing the internal
> list_head to the external 'dm_dirty_log_type' structure is a  
> worthwhile
> compromise.
>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
> drivers/md/dm-log.c          |   60 +++++++++ 
> +-------------------------------
> include/linux/dm-dirty-log.h |    3 ++
> 2 files changed, 18 insertions(+), 45 deletions(-)
>
> diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
> index 094c8f0..f5e5e11 100644
> --- a/drivers/md/dm-log.c
> +++ b/drivers/md/dm-log.c
> @@ -16,34 +16,28 @@
>
> #define DM_MSG_PREFIX "dirty region log"
>
> -struct dm_dirty_log_internal {
> -	struct dm_dirty_log_type *type;
> -
> -	struct list_head list;
> -};
> -
> static LIST_HEAD(_log_types);
> static DEFINE_SPINLOCK(_lock);
>
> -static struct dm_dirty_log_internal *__find_dirty_log_type(const  
> char *name)
> +static struct dm_dirty_log_type *__find_dirty_log_type(const char  
> *name)
> {
> -	struct dm_dirty_log_internal *log_type;
> +	struct dm_dirty_log_type *log_type;
>
> 	list_for_each_entry(log_type, &_log_types, list)
> -		if (!strcmp(name, log_type->type->name))
> +		if (!strcmp(name, log_type->name))
> 			return log_type;
>
> 	return NULL;
> }
>
> -static struct dm_dirty_log_internal *_get_dirty_log_type(const char  
> *name)
> +static struct dm_dirty_log_type *_get_dirty_log_type(const char  
> *name)
> {
> -	struct dm_dirty_log_internal *log_type;
> +	struct dm_dirty_log_type *log_type;
>
> 	spin_lock(&_lock);
>
> 	log_type = __find_dirty_log_type(name);
> -	if (log_type && !try_module_get(log_type->type->module))
> +	if (log_type && !try_module_get(log_type->module))
> 		log_type = NULL;
>
> 	spin_unlock(&_lock);
> @@ -71,14 +65,14 @@ static struct dm_dirty_log_internal  
> *_get_dirty_log_type(const char *name)
> static struct dm_dirty_log_type *get_type(const char *type_name)
> {
> 	char *p, *type_name_dup;
> -	struct dm_dirty_log_internal *log_type;
> +	struct dm_dirty_log_type *log_type;
>
> 	if (!type_name)
> 		return NULL;
>
> 	log_type = _get_dirty_log_type(type_name);
> 	if (log_type)
> -		return log_type->type;
> +		return log_type;
>
> 	type_name_dup = kstrdup(type_name, GFP_KERNEL);
> 	if (!type_name_dup) {
> @@ -100,19 +94,16 @@ static struct dm_dirty_log_type *get_type(const  
> char *type_name)
>
> 	kfree(type_name_dup);
>
> -	return log_type ? log_type->type : NULL;
> +	return log_type;
> }
>
> static void put_type(struct dm_dirty_log_type *type)
> {
> -	struct dm_dirty_log_internal *log_type;
> -
> 	if (!type)
> 		return;
>
> -	spin_lock(&_lock);
> -	log_type = __find_dirty_log_type(type->name);
> -	if (!log_type)
> +	spin_lock(&_lock);
> +	if (!__find_dirty_log_type(type->name))
> 		goto out;
>
> 	module_put(type->module);
> @@ -121,32 +112,15 @@ out:
> 	spin_unlock(&_lock);
> }
>
> -static struct dm_dirty_log_internal *_alloc_dirty_log_type(struct  
> dm_dirty_log_type *type)
> -{
> -	struct dm_dirty_log_internal *log_type = kzalloc(sizeof(*log_type),
> -							 GFP_KERNEL);
> -
> -	if (log_type)
> -		log_type->type = type;
> -
> -	return log_type;
> -}
> -
> int dm_dirty_log_type_register(struct dm_dirty_log_type *type)
> {
> -	struct dm_dirty_log_internal *log_type =  
> _alloc_dirty_log_type(type);
> 	int r = 0;
>
> -	if (!log_type)
> -		return -ENOMEM;
> -
> 	spin_lock(&_lock);
> 	if (!__find_dirty_log_type(type->name))
> -		list_add(&log_type->list, &_log_types);
> -	else {
> -		kfree(log_type);
> +		list_add(&type->list, &_log_types);
> +	else
> 		r = -EEXIST;
> -	}
> 	spin_unlock(&_lock);
>
> 	return r;
> @@ -155,20 +129,16 @@ EXPORT_SYMBOL(dm_dirty_log_type_register);
>
> int dm_dirty_log_type_unregister(struct dm_dirty_log_type *type)
> {
> -	struct dm_dirty_log_internal *log_type;
> -
> 	spin_lock(&_lock);
>
> -	log_type = __find_dirty_log_type(type->name);
> -	if (!log_type) {
> +	if (!__find_dirty_log_type(type->name)) {
> 		spin_unlock(&_lock);
> 		return -EINVAL;
> 	}
>
> -	list_del(&log_type->list);
> +	list_del(&type->list);
>
> 	spin_unlock(&_lock);
> -	kfree(log_type);
>
> 	return 0;
> }
> diff --git a/include/linux/dm-dirty-log.h b/include/linux/dm-dirty- 
> log.h
> index a6600a5..5e8b11d 100644
> --- a/include/linux/dm-dirty-log.h
> +++ b/include/linux/dm-dirty-log.h
> @@ -28,6 +28,9 @@ struct dm_dirty_log_type {
> 	const char *name;
> 	struct module *module;
>
> +	/* For internal device-mapper use */
> +	struct list_head list;
> +
> 	int (*ctr)(struct dm_dirty_log *log, struct dm_target *ti,
> 		   unsigned argc, char **argv);
> 	void (*dtr)(struct dm_dirty_log *log);
> -- 
> 1.6.0.6
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
