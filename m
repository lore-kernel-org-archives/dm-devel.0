From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: Patch for setting pgfailback coded default for EMC
	CLARiiON and o thers
Date: Wed, 21 Sep 2005 22:53:54 +0200
Message-ID: <1127336034.14912.37.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321ACC6@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321ACC6@SRMANNING.eng.emc.com>
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

Applied, thanks

On mer, 2005-09-21 at 14:39 -0400, goggin, edward wrote:
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -228,7 +228,7 @@ out:
>  int
>  store_hwe_ext (vector hwtable, char * vendor, char * product, int pgp,
>  	   char * getuid, char * getprio, char * hwhandler,
> -	   char * features, char * checker)
> +	   char * features, char * checker, int pgfailback)
>  {
>  	struct hwentry * hwe;
>  
> @@ -284,6 +284,8 @@ store_hwe_ext (vector hwtable, char * ve
>  	else
>  		hwe->checker_index = get_checker_id(DEFAULT_CHECKER);
>  
> +	hwe->pgfailback = pgfailback;
> +
>  	if (!vector_alloc_slot(hwtable))
>  		goto out;
>  
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -86,8 +86,7 @@ int store_hwe (vector hwtable, char * ve
>  		char * getuid);
>  int store_hwe_ext (vector hwtable, char * vendor, char * product, int pgp,
>  		char * getuid, char * getprio, char * hwhandler,
> -		char * features, char * checker);
> -
> +		char * features, char * checker, int pgfailback);
>  int load_config (char * file);
>  struct config * alloc_config (void);
>  void free_config (struct config * conf);
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -37,13 +37,13 @@ setup_default_hwtable (vector hw)
>  
>  	r += store_hwe_ext(hw, "DGC", "*", GROUP_BY_PRIO, DEFAULT_GETUID,
>  		   "/sbin/mpath_prio_emc /dev/%n", "1 emc",
> -		   "1 queue_if_no_path", "emc_clariion");
> +		   "1 queue_if_no_path", "emc_clariion",
> FAILBACK_IMMEDIATE);
>  	r += store_hwe_ext(hw, "IBM", "3542", GROUP_BY_SERIAL,
> DEFAULT_GETUID,
> -		   NULL, "0", "0", "tur");
> +		   NULL, "0", "0", "tur", FAILBACK_UNDEF);
>  	r += store_hwe_ext(hw, "SGI", "TP9400", MULTIBUS, DEFAULT_GETUID,
> -		   NULL, "0", "0", "tur");
> +		   NULL, "0", "0", "tur", FAILBACK_UNDEF);
>  	r += store_hwe_ext(hw, "SGI", "TP9500", FAILOVER, DEFAULT_GETUID,
> -		   NULL, "0", "0", "tur");
> +		   NULL, "0", "0", "tur", FAILBACK_UNDEF);
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
