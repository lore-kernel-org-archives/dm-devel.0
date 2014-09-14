From: Nir Soffer <nsoffer@redhat.com>
Subject: Re: [PATCH 5/6] multipath.conf: add all_devs device
 option
Date: Sun, 14 Sep 2014 09:28:32 -0400 (EDT)
Message-ID: <1425146769.37577990.1410701312018.JavaMail.zimbra@redhat.com>
References: <1410543892-29826-1-git-send-email-bmarzins@redhat.com>
	<1410543892-29826-6-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1410543892-29826-6-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

----- Original Message -----
> From: "Benjamin Marzinski" <bmarzins@redhat.com>
> To: "device-mapper development" <dm-devel@redhat.com>
> Cc: "Christophe Varoqui" <christophe.varoqui@gmail.com>
> Sent: Friday, September 12, 2014 8:44:51 PM
> Subject: [dm-devel] [PATCH 5/6] multipath.conf: add all_devs device option
> 
> Sometimes users want to to be able to set a configuration value for all
> their devices (for instance, they may want all devices to set no_path_retry
> to fail). The builtin device configurations make this tricky, since
> they need to change each one device configuration individually.  To avoid
> that, this patch adds a new device config option, "all_devs". When this is
> set to "yes", the options set in this devices section will override those
> values in all the builtin configs.
> 
> For instance, to make all builtin configs set no_path_retry to fail, you
> could add:
> 
> devices {
> 	device {
> 		all_devs yes
> 		no_path_retry fail
> 	}
> }
> 
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/config.c | 59
>  +++++++++++++++++++++++++++++++++++++++++++++++++++
>  libmultipath/config.h |  1 +
>  libmultipath/dict.c   | 38 +++++++++++++++++++++++++++++++++
>  3 files changed, 98 insertions(+)
> 
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 39963b4..d326765 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -112,6 +112,8 @@ find_hwe (vector hwtable, char * vendor, char * product,
> char * revision)
>  	 * continuing to the generic entries
>  	 */
>  	vector_foreach_slot_backwards (hwtable, tmp, i) {
> +		if (tmp->all_devs == 1)
> +			continue;
>  		if (hwe_regmatch(tmp, &hwe))
>  			continue;
>  		ret = tmp;
> @@ -353,6 +355,59 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
>  	return 0;
>  }
>  
> +#define overwrite_str(s) \
> +do { \
> +	if (src->s) { \
> +		if (dst->s) \
> +			FREE(dst->s); \
> +		if (!(dst->s = set_param_str(src->s))) \
> +			return 1; \
> +	} \
> +} while(0)
> +
> +#define overwrite_num(s) \
> +do { \
> +	if (src->s) \
> +		dst->s = src->s; \
> +} while(0)
> +
> +static int
> +overwrite_hwe (struct hwentry * dst, struct hwentry * src)
> +{
> +	/* don't overwrite vendor, product, revision or all_devs */
> +	overwrite_str(uid_attribute);
> +	overwrite_str(features);
> +	overwrite_str(hwhandler);
> +	overwrite_str(selector);
> +	overwrite_str(checker_name);
> +	overwrite_str(prio_name);
> +	overwrite_str(prio_args);
> +	overwrite_str(alias_prefix);
> +	overwrite_str(bl_product);
> +	overwrite_num(pgpolicy);
> +	overwrite_num(pgfailback);
> +	overwrite_num(rr_weight);
> +	overwrite_num(no_path_retry);
> +	overwrite_num(minio);
> +	overwrite_num(minio_rq);
> +	overwrite_num(flush_on_last_del);
> +	overwrite_num(fast_io_fail);
> +	overwrite_num(dev_loss);
> +	overwrite_num(user_friendly_names);
> +	overwrite_num(retain_hwhandler);
> +	overwrite_num(detect_prio);
> +
> +	/*
> +	 * Make sure features is consistent with
> +	 * no_path_retry
> +	 */
> +	if (dst->no_path_retry == NO_PATH_RETRY_FAIL)
> +		remove_feature(&dst->features, "queue_if_no_path");
> +	else if (dst->no_path_retry != NO_PATH_RETRY_UNDEF)
> +		add_feature(&dst->features, "queue_if_no_path");

This duplicates the same code in merge_hwe(). It would be a good idea
to extract a function for this and call it from both places.

> +	return 0;
> +}
> +
>  int
>  store_hwe (vector hwtable, struct hwentry * dhwe)
>  {
> @@ -438,6 +493,10 @@ restart:
>  			break;
>  		j = n;
>  		vector_foreach_slot_after(hw, hwe2, j) {
> +			if (hwe2->all_devs == 1) {
> +				overwrite_hwe(hwe1, hwe2);
> +				continue;
> +			}

This code is already little tricky, and adding it here
means you will overwrite again when the loop restarts.

Why not do this as separate step before factorizing?

1. read config
2. override built-in devices with all_devs settings
3. factorize (remove duplicates)

>  			if (hwe_regmatch(hwe1, hwe2))
>  				continue;
>  			/* dup */
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index 844ee12..2097879 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -47,6 +47,7 @@ struct hwentry {
>  	char * prio_args;
>  	char * alias_prefix;
>  
> +	int all_devs;
>  	int pgpolicy;
>  	int pgfailback;
>  	int rr_weight;
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 7de7a67..5b4fbe6 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -918,6 +918,32 @@ device_handler(vector strvec)
>  }
>  
>  static int
> +all_devs_handler(vector strvec)
> +{
> +	char * buff;
> +	struct hwentry *hwe = VECTOR_LAST_SLOT(conf->hwtable);
> +
> +	if (!hwe)
> +		return 1;
> +
> +	buff = set_value(strvec);
> +	if (!buff)
> +		return 1;
> +
> +	if ((strlen(buff) == 2 && !strcmp(buff, "no")) ||
> +	    (strlen(buff) == 1 && !strcmp(buff, "0")))
> +		hwe->all_devs = 0;
> +	else if ((strlen(buff) == 3 && !strcmp(buff, "yes")) ||
> +		 (strlen(buff) == 1 && !strcmp(buff, "1")))
> +		hwe->all_devs = 1;
> +	else
> +		hwe->all_devs = 0;

Why not:

    hwe->all_devs = !strcmp(buff, "1") || !strcmp(buff, "yes");

> +
> +	FREE(buff);
> +	return 0;
> +}

Nir
