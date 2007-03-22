From: malahal@us.ibm.com
Subject: Re: [Patch 7 of 14] Device Mapper Mirror
Date: Thu, 22 Mar 2007 10:04:31 -0700
Message-ID: <20070322170431.GA9631@us.ibm.com>
References: <1162915417.17899.48.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1162915417.17899.48.camel@hydrogen.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: heinzm@redhat.com, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

I applied this patch(set) but I couldn't create any mirror devices with
"handle_errors" feature because the following code assumes that the
device list is the last to be given.

mirror_ctr()
{
	....
	if (argc != nr_mirrors * 2) {
                ti->error = "Wrong number of mirror arguments";
                dm_destroy_dirty_log(dl);
                return -EINVAL;
        }
}

Changing the condition to "(argc < nr_mirrors * 2)" worked fine. Anyone else
using this patch? Are there any updates to this patch set?

Thanks, Malahal.


Jonathan Brassow [jbrassow@redhat.com] wrote:
>  brassow
> 
> This patch adds the ability to specify desired features in the mirror
> constructor/mapping table.
> 
> The first feature of interest is "handle_errors".  Currently, mirroring
> will ignore any I/O errors from the devices.  Subsequent patches will
> check for this flag and handle the errors.  If flag/feature is not
> present, mirror will do nothing - maintaining backwards compatibility.
> 
> Index: linux-2.6.18.1/drivers/md/dm-raid1.c
> ===================================================================
> --- linux-2.6.18.1.orig/drivers/md/dm-raid1.c	2006-11-01 14:16:14.000000000 -0600
> +++ linux-2.6.18.1/drivers/md/dm-raid1.c	2006-11-01 14:16:15.000000000 -0600
> @@ -114,6 +114,8 @@ struct region {
>  /*-----------------------------------------------------------------
>   * Mirror set structures.
>   *---------------------------------------------------------------*/
> +#define DM_FEATURE_HANDLE_ERRORS 0x1
> +
>  struct mirror {
>  	atomic_t error_count;
>  	struct dm_dev *dev;
> @@ -130,6 +132,9 @@ struct mirror_set {
>  	struct bio_list reads;
>  	struct bio_list writes;
>  
> +	/* Features */
> +	uint64_t feature_flags;
> +
>  	/* recovery */
>  	region_t nr_regions;
>  	int in_sync;
> @@ -1037,14 +1042,63 @@ static struct dirty_log *create_dirty_lo
>  	return dl;
>  }
>  
> +static int parse_features(struct mirror_set *ms,
> +			  unsigned int argc, char **argv,
> +			  unsigned int *args_used)
> +{
> +	int i;
> +	unsigned int features_argc, used = 0;
> +	struct dm_target *ti = ms->ti;
> +
> +	*args_used = 0;
> +
> +	if (!argc)
> +		return 0;
> +
> +	if (sscanf(argv[0], "%u", &features_argc) != 1) {
> +		ti->error = "Invalid number of features";
> +		return -EINVAL;
> +	}
> +
> +	argc--;
> +	argv++;
> +	used++;
> +
> +	if (features_argc > argc) {
> +		ti->error = "Not enough arguments to support feature count";
> +		return -EINVAL;
> +	}
> +
> +	for (i = 0; i < features_argc; i++) {
> +		if (!strcmp("handle_errors", argv[i]))
> +			ms->feature_flags |= DM_FEATURE_HANDLE_ERRORS;
> +		else {
> +			ti->error = "Unknown feature argument";
> +			return -EINVAL;
> +		}
> +		used++;
> +	}
> +
> +	*args_used = used;
> +	return 0;
> +}
> +
>  /*
> - * Construct a mirror mapping:
> + * mirror_ctr
> + * @ti
> + * @argc
> + * @argv
>   *
> - * log_type #log_params <log_params>
> - * #mirrors [mirror_path offset]{2,}
> + * Allowable argument list is as follows:
> + *     log_type #log_params <log_params> \
> + *     #mirrors <device1> <offset1> ... <deviceN> <offsetN> \
> + *     <# feature args> <feature args>
>   *
> - * log_type is "core" or "disk"
> - * #log_params is between 1 and 3
> + * Refer to log implementation for log specific parameters.
> + * Current features include:
> + *     handle_errors
> + *
> + * Returns: 0 on success, -EXXX on failure
>   */
>  #define DM_IO_PAGES 64
>  static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> @@ -1096,6 +1150,22 @@ static int mirror_ctr(struct dm_target *
>  	ti->private = ms;
>   	ti->split_io = ms->rh.region_size;
>  
> +	/* check for features */
> +	r = parse_features(ms, argc, argv, &args_used);
> +	if (r) {
> +		free_context(ms, ti, ms->nr_mirrors);
> +		return r;
> +	}
> +
> +	argv += args_used;
> +	argc -= args_used;
> +
> +	if (argc) {
> +		ti->error = "Wrong number of mirror arguments";
> +		free_context(ms, ti, ms->nr_mirrors);
> +		return -EINVAL;
> +	}
> +
>  	r = kcopyd_client_create(DM_IO_PAGES, &ms->kcopyd_client);
>  	if (r) {
>  		free_context(ms, ti, ms->nr_mirrors);
> @@ -1243,6 +1313,9 @@ static int mirror_status(struct dm_targe
>  		for (m = 0; m < ms->nr_mirrors; m++)
>  			DMEMIT(" %s %llu", ms->mirror[m].dev->name,
>  				(unsigned long long)ms->mirror[m].offset);
> +
> +		if (ms->feature_flags & DM_FEATURE_HANDLE_ERRORS)
> +			DMEMIT(" 1 handle_errors");
>  	}
>  
>  	return 0;
> 
