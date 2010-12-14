From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH][rfc] md: Close mem leak in userspace_ctr()
Date: Tue, 14 Dec 2010 17:18:16 -0500
Message-ID: <20101214221816.GA14227@redhat.com>
References: <alpine.LNX.2.00.1012140034300.26491@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1012140034300.26491@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Dec 13 2010 at  6:40pm -0500,
Jesper Juhl <jj@chaosbits.net> wrote:

> Hi,
> 
> There's a small memory leak in 
> drivers/md/dm-log-userspace-base.c::userspace_ctr().
> 
> The call to build_constructor_string() dynamically allocates memory for 
> its last argument, but we do not always clean up that allocated memory.

I'm not seeing a leak.

The kfree() that you've added to the build_constructor_string() failure
path isn't needed because build_constructor_string() only returns error
if the kzalloc() failed.

Mike

> diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
> index 1ed0094..71a3049 100644
> --- a/drivers/md/dm-log-userspace-base.c
> +++ b/drivers/md/dm-log-userspace-base.c
> @@ -99,26 +99,22 @@ static int build_constructor_string(struct dm_target *ti,
>  				    char **ctr_str)
>  {
>  	int i, str_size;
> -	char *str = NULL;
> -
> -	*ctr_str = NULL;
>  
>  	for (i = 0, str_size = 0; i < argc; i++)
>  		str_size += strlen(argv[i]) + 1; /* +1 for space between args */
>  
>  	str_size += 20; /* Max number of chars in a printed u64 number */
>  
> -	str = kzalloc(str_size, GFP_KERNEL);
> -	if (!str) {
> +	*ctr_str = kzalloc(str_size, GFP_KERNEL);
> +	if (!*ctr_str) {
>  		DMWARN("Unable to allocate memory for constructor string");
>  		return -ENOMEM;
>  	}
>  
> -	str_size = sprintf(str, "%llu", (unsigned long long)ti->len);
> +	str_size = sprintf(*ctr_str, "%llu", (unsigned long long)ti->len);
>  	for (i = 0; i < argc; i++)
> -		str_size += sprintf(str + str_size, " %s", argv[i]);
> +		str_size += sprintf(*ctr_str + str_size, " %s", argv[i]);
>  
> -	*ctr_str = str;
>  	return str_size;
>  }
>  
> @@ -140,7 +136,7 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
>  {
>  	int r = 0;
>  	int str_size;
> -	char *ctr_str = NULL;
> +	char *ctr_str;
>  	struct log_c *lc = NULL;
>  	uint64_t rdata;
>  	size_t rdata_size = sizeof(rdata);
> @@ -173,6 +169,7 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
>  
>  	str_size = build_constructor_string(ti, argc - 1, argv + 1, &ctr_str);
>  	if (str_size < 0) {
> +		kfree(ctr_str);
>  		kfree(lc);
>  		return str_size;
>  	}
