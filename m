From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 09/15] libmultipath: add code to get vendor
 specific vpd data
Date: Wed, 22 Jan 2020 03:46:12 -0600
Message-ID: <20200122094612.GX30153@octiron.msp.redhat.com>
References: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
	<1579227500-17196-10-git-send-email-bmarzins@redhat.com>
	<24099.16814.876570.188848@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <24099.16814.876570.188848@quad.stoffel.home>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: John Stoffel <john@stoffel.org>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

On Sat, Jan 18, 2020 at 12:34:38PM -0500, John Stoffel wrote:
> >>>>> "Benjamin" == Benjamin Marzinski <bmarzins@redhat.com> writes:
> 
> Benjamin> This adds the wildcard 'g' for multipath and path formatted
> Benjamin> printing, which returns extra data from a device's vendor
> Benjamin> specific vpd page.  The specific vendor vpd page to use, and
> Benjamin> the vendor/product id to decode it can be set in the hwentry
> Benjamin> with vpd_vendor_pg and vpd_vendor_id. It can be configured
> Benjamin> in the devices section of multipath.conf with the vpd_vendor
> Benjamin> parameter. Currently, the only devices that use this are HPE
> Benjamin> 3PAR arrays, to return the Volume Name.
> 
> So I've looked over this patch and I see how you've hard-coded the
> 3par entry into the various .c files, but the multipathd.conf example
> really doesn't give a good example of how to use it, nor does the code
> give a good example, or maybe better yet a template set of functions
> for parsing custom VPD info pages.  This is really just a nit.  

Right now, the only thing that someone can do is add

vpd_vendor hp3par

to multipath.conf, and AFAIK, right now there is no reason why anyone
would do that.  I belive that all the devices that use this page already
have it in their built-in config.  When there are more options that can
be used, the man page can be revisited.

About the code, the issue is that there really isn't any standard that
I'm aware of for what's in the vendor specific pages, so I don't really
even know what those would look like.  I had to read the sg_vpd code and
ask HPE specifically for details of their format, to write this.  I
assume something like that will be necessary for each new one of these.

> Also, is the Vendor VPD page always at 0xco, or is that just a 3par
> setting?  I wonder if that constant should be pulled into a #define
> somewhere, so that it's simpler to update/change as needed?
> Especially if other vendors use different pages.

Vendors definitely use different pages. See the Vendor specific VPD
pages section of the "sg_vpd -e" output. I am planning on changing how
these are defined to match Martin Wilck's suggestion.

-Ben

> John
> 
> 
> 
> Benjamin> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> Benjamin> ---
> Benjamin>  libmultipath/config.c      |  4 ++++
> Benjamin>  libmultipath/config.h      |  2 ++
> Benjamin>  libmultipath/dict.c        | 34 ++++++++++++++++++++++++++++++++++
> Benjamin>  libmultipath/discovery.c   | 34 +++++++++++++++++++++++++++++++++-
> Benjamin>  libmultipath/hwtable.c     |  2 ++
> Benjamin>  libmultipath/print.c       | 27 +++++++++++++++++++++++++++
> Benjamin>  libmultipath/propsel.c     | 24 ++++++++++++++++++++++++
> Benjamin>  libmultipath/propsel.h     |  2 ++
> Benjamin>  libmultipath/structs.h     |  9 +++++++++
> Benjamin>  multipath/multipath.conf.5 |  8 ++++++++
> Benjamin>  10 files changed, 145 insertions(+), 1 deletion(-)
> 
> Benjamin> diff --git a/libmultipath/config.c b/libmultipath/config.c
> Benjamin> index 85626e96..72b8d37c 100644
> Benjamin> --- a/libmultipath/config.c
> Benjamin> +++ b/libmultipath/config.c
> Benjamin> @@ -369,6 +369,8 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
> Benjamin>  	merge_num(max_sectors_kb);
> Benjamin>  	merge_num(ghost_delay);
> Benjamin>  	merge_num(all_tg_pt);
> Benjamin> +	merge_num(vpd_vendor_pg);
> Benjamin> +	merge_num(vpd_vendor_id);
> Benjamin>  	merge_num(san_path_err_threshold);
> Benjamin>  	merge_num(san_path_err_forget_rate);
> Benjamin>  	merge_num(san_path_err_recovery_time);
> Benjamin> @@ -517,6 +519,8 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
> hwe-> detect_prio = dhwe->detect_prio;
> hwe-> detect_checker = dhwe->detect_checker;
> hwe-> ghost_delay = dhwe->ghost_delay;
> Benjamin> +	hwe->vpd_vendor_pg = dhwe->vpd_vendor_pg;
> Benjamin> +	hwe->vpd_vendor_id = dhwe->vpd_vendor_id;
>  
> Benjamin>  	if (dhwe->bl_product && !(hwe->bl_product = set_param_str(dhwe->bl_product)))
> Benjamin>  		goto out;
> Benjamin> diff --git a/libmultipath/config.h b/libmultipath/config.h
> Benjamin> index e69aa07c..589146de 100644
> Benjamin> --- a/libmultipath/config.h
> Benjamin> +++ b/libmultipath/config.h
> Benjamin> @@ -87,6 +87,8 @@ struct hwentry {
> Benjamin>  	int max_sectors_kb;
> Benjamin>  	int ghost_delay;
> Benjamin>  	int all_tg_pt;
> Benjamin> +	int vpd_vendor_pg;
> Benjamin> +	int vpd_vendor_id;
> Benjamin>  	char * bl_product;
> Benjamin>  };
>  
> Benjamin> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> Benjamin> index 2b046e1d..d6d8b79b 100644
> Benjamin> --- a/libmultipath/dict.c
> Benjamin> +++ b/libmultipath/dict.c
> Benjamin> @@ -1366,6 +1366,39 @@ def_uxsock_timeout_handler(struct config *conf, vector strvec)
> Benjamin>  	return 0;
> Benjamin>  }
>  
> Benjamin> +static int
> Benjamin> +hw_vpd_vendor_handler(struct config *conf, vector strvec)
> Benjamin> +{
> Benjamin> +	int rc = 0;
> Benjamin> +	char *buff;
> Benjamin> +
> Benjamin> +	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
> Benjamin> +	if (!hwe)
> Benjamin> +		return 1;
> Benjamin> +
> Benjamin> +	buff = set_value(strvec);
> Benjamin> +	if (!buff)
> Benjamin> +		return 1;
> Benjamin> +	if (strcmp(buff, "hp3par") == 0) {
> Benjamin> +		hwe->vpd_vendor_pg = 0xc0;
> Benjamin> +		hwe->vpd_vendor_id = VPD_VP_HP3PAR;
> Benjamin> +	} else
> Benjamin> +		rc = 1;
> Benjamin> +	FREE(buff);
> Benjamin> +	return rc;
> Benjamin> +}
> Benjamin> +
> Benjamin> +static int
> Benjamin> +snprint_hw_vpd_vendor(struct config *conf, char * buff, int len,
> Benjamin> +		      const void * data)
> Benjamin> +{
> Benjamin> +	const struct hwentry * hwe = (const struct hwentry *)data;
> Benjamin> +
> Benjamin> +	if (hwe->vpd_vendor_pg == 0xc0 && hwe->vpd_vendor_id == VPD_VP_HP3PAR)
> Benjamin> +		return snprintf(buff, len, "hp3par");
> Benjamin> +	return 0;
> Benjamin> +}
> Benjamin> +
> Benjamin>  /*
> Benjamin>   * blacklist block handlers
> Benjamin>   */
> Benjamin> @@ -1806,6 +1839,7 @@ init_keywords(vector keywords)
> Benjamin>  	install_keyword("max_sectors_kb", &hw_max_sectors_kb_handler, &snprint_hw_max_sectors_kb);
> Benjamin>  	install_keyword("ghost_delay", &hw_ghost_delay_handler, &snprint_hw_ghost_delay);
> Benjamin>  	install_keyword("all_tg_pt", &hw_all_tg_pt_handler, &snprint_hw_all_tg_pt);
> Benjamin> +	install_keyword("vpd_vendor", &hw_vpd_vendor_handler, &snprint_hw_vpd_vendor);
> Benjamin>  	install_sublevel_end();
>  
> Benjamin>  	install_keyword_root("overrides", &overrides_handler);
> Benjamin> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> Benjamin> index 1d79cbae..d2773c3a 100644
> Benjamin> --- a/libmultipath/discovery.c
> Benjamin> +++ b/libmultipath/discovery.c
> Benjamin> @@ -1103,6 +1103,30 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
> Benjamin>  	return len;
> Benjamin>  }
>  
> Benjamin> +static int
> Benjamin> +parse_vpd_c0_hp3par(const unsigned char *in, size_t in_len,
> Benjamin> +		    char *out, size_t out_len)
> Benjamin> +{
> Benjamin> +	size_t len;
> Benjamin> +
> Benjamin> +	memset(out, 0x0, out_len);
> Benjamin> +	if (in_len <= 4 || (in[4] > 3 && in_len < 44)) {
> Benjamin> +		condlog(3, "HP/3PAR vendor specific VPD page length too short: %lu", in_len);
> Benjamin> +		return -EINVAL;
> Benjamin> +	}
> Benjamin> +	if (in[4] <= 3) /* revision must be > 3 to have Vomlume Name */
> Benjamin> +		return -ENODATA;
> Benjamin> +	len = get_unaligned_be32(&in[40]);
> Benjamin> +	if (len > out_len || len + 44 > in_len) {
> Benjamin> +		condlog(3, "HP/3PAR vendor specific Volume name too long: %lu",
> Benjamin> +			len);
> Benjamin> +		return -EINVAL;
> Benjamin> +	}
> Benjamin> +	memcpy(out, &in[44], len);
> Benjamin> +	out[out_len - 1] = '\0';
> Benjamin> +	return len;
> Benjamin> +}
> Benjamin> +
> Benjamin>  static int
> Benjamin>  get_vpd_sysfs (struct udev_device *parent, int pg, char * str, int maxlen)
> Benjamin>  {
> Benjamin> @@ -1170,7 +1194,9 @@ get_vpd_sgio (int fd, int pg, int vend_id, char * str, int maxlen)
> Benjamin>  			len = (buff_len <= maxlen)? buff_len : maxlen;
> Benjamin>  			memcpy (str, buff, len);
> Benjamin>  		}
> Benjamin> -	} else
> Benjamin> +	} else if (pg == 0xc0 && vend_id == VPD_VP_HP3PAR)
> Benjamin> +		len = parse_vpd_c0_hp3par(buff, buff_len, str, maxlen);
> Benjamin> +	else
> Benjamin>  		len = -ENOSYS;
>  
> Benjamin>  	return len;
> Benjamin> @@ -1544,6 +1570,12 @@ scsi_ioctl_pathinfo (struct path * pp, struct config *conf, int mask)
> Benjamin>  	if (!(mask & DI_SERIAL))
> Benjamin>  		return;
>  
> Benjamin> +	select_vpd_vendor_pg(conf, pp);
> Benjamin> +	select_vpd_vendor_id(conf, pp);
> Benjamin> +
> Benjamin> +	if (pp->vpd_vendor_pg != 0 && get_vpd_sgio(pp->fd, pp->vpd_vendor_pg, pp->vpd_vendor_id, pp->vpd_data, sizeof(pp->vpd_data)) < 0)
> Benjamin> +		condlog(3, "%s: failed to get extra vpd data", pp->dev);
> Benjamin> +
> Benjamin>  	parent = pp->udev;
> Benjamin>  	while (parent) {
> Benjamin>  		const char *subsys = udev_device_get_subsystem(parent);
> Benjamin> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> Benjamin> index 16627ec5..1f27450c 100644
> Benjamin> --- a/libmultipath/hwtable.c
> Benjamin> +++ b/libmultipath/hwtable.c
> Benjamin> @@ -117,6 +117,8 @@ static struct hwentry default_hw[] = {
> Benjamin>  		.no_path_retry = 18,
> Benjamin>  		.fast_io_fail  = 10,
> Benjamin>  		.dev_loss      = MAX_DEV_LOSS_TMO,
> Benjamin> +		.vpd_vendor_pg = 0xc0,
> Benjamin> +		.vpd_vendor_id = VPD_VP_HP3PAR,
> Benjamin>  	},
> Benjamin>  	{
> Benjamin>  		/* RA8000 / ESA12000 */
> Benjamin> diff --git a/libmultipath/print.c b/libmultipath/print.c
> Benjamin> index 907469ad..0aafe3cb 100644
> Benjamin> --- a/libmultipath/print.c
> Benjamin> +++ b/libmultipath/print.c
> Benjamin> @@ -358,6 +358,23 @@ snprint_action (char * buff, size_t len, const struct multipath * mpp)
> Benjamin>  	}
> Benjamin>  }
>  
> Benjamin> +static int
> Benjamin> +snprint_multipath_vpd_data(char * buff, size_t len,
> Benjamin> +			   const struct multipath * mpp)
> Benjamin> +{
> Benjamin> +	struct pathgroup * pgp;
> Benjamin> +	struct path * pp;
> Benjamin> +	int i, j;
> Benjamin> +
> Benjamin> +	vector_foreach_slot(mpp->pg, pgp, i) {
> Benjamin> +		vector_foreach_slot(pgp->paths, pp, j) {
> Benjamin> +			if (strlen(pp->vpd_data))
> Benjamin> +				return snprintf(buff, len, "%s", pp->vpd_data);
> Benjamin> +		}
> Benjamin> +	}
> Benjamin> +	return 0;
> Benjamin> +}
> Benjamin> +
> Benjamin>  /*
> Benjamin>   * path info printing functions
> Benjamin>   */
> Benjamin> @@ -688,6 +705,14 @@ snprint_path_marginal(char * buff, size_t len, const struct path * pp)
> Benjamin>  	return snprintf(buff, len, "normal");
> Benjamin>  }
>  
> Benjamin> +static int
> Benjamin> +snprint_path_vpd_data(char * buff, size_t len, const struct path * pp)
> Benjamin> +{
> Benjamin> +	if (strlen(pp->vpd_data) > 0)
> Benjamin> +		return snprintf(buff, len, "%s", pp->vpd_data);
> Benjamin> +	return 0;
> Benjamin> +}
> Benjamin> +
> Benjamin>  struct multipath_data mpd[] = {
> Benjamin>  	{'n', "name",          0, snprint_name},
> Benjamin>  	{'w', "uuid",          0, snprint_multipath_uuid},
> Benjamin> @@ -712,6 +737,7 @@ struct multipath_data mpd[] = {
> Benjamin>  	{'p', "prod",          0, snprint_multipath_prod},
> Benjamin>  	{'e', "rev",           0, snprint_multipath_rev},
> Benjamin>  	{'G', "foreign",       0, snprint_multipath_foreign},
> Benjamin> +	{'g', "vpd page data", 0, snprint_multipath_vpd_data},
> Benjamin>  	{0, NULL, 0 , NULL}
> Benjamin>  };
>  
> Benjamin> @@ -737,6 +763,7 @@ struct path_data pd[] = {
> Benjamin>  	{'r', "target WWPN",   0, snprint_tgt_wwpn},
> Benjamin>  	{'a', "host adapter",  0, snprint_host_adapter},
> Benjamin>  	{'G', "foreign",       0, snprint_path_foreign},
> Benjamin> +	{'g', "vpd page data", 0, snprint_path_vpd_data},
> Benjamin>  	{'0', "failures",      0, snprint_path_failures},
> Benjamin>  	{'P', "protocol",      0, snprint_path_protocol},
> Benjamin>  	{0, NULL, 0 , NULL}
> Benjamin> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> Benjamin> index b5b5b89f..3c99f2d4 100644
> Benjamin> --- a/libmultipath/propsel.c
> Benjamin> +++ b/libmultipath/propsel.c
> Benjamin> @@ -1203,3 +1203,27 @@ out:
> Benjamin>  		origin);
> Benjamin>  	return 0;
> Benjamin>  }
> Benjamin> +
> Benjamin> +int select_vpd_vendor_pg (struct config *conf, struct path *pp)
> Benjamin> +{
> Benjamin> +	const char *origin;
> Benjamin> +
> Benjamin> +	pp_set_hwe(vpd_vendor_pg);
> Benjamin> +	pp_set_default(vpd_vendor_pg, 0);
> Benjamin> +out:
> Benjamin> +	condlog(3, "%s: vpd_vendor_pg = 0x%x %s", pp->dev, pp->vpd_vendor_pg,
> Benjamin> +		origin);
> Benjamin> +	return 0;
> Benjamin> +}
> Benjamin> +
> Benjamin> +int select_vpd_vendor_id (struct config *conf, struct path *pp)
> Benjamin> +{
> Benjamin> +	const char *origin;
> Benjamin> +
> Benjamin> +	pp_set_hwe(vpd_vendor_id);
> Benjamin> +	pp_set_default(vpd_vendor_id, 0);
> Benjamin> +out:
> Benjamin> +	condlog(3, "%s: vpd_vendor_id = 0x%x %s", pp->dev, pp->vpd_vendor_id,
> Benjamin> +		origin);
> Benjamin> +	return 0;
> Benjamin> +}
> Benjamin> diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
> Benjamin> index ddfd6262..3f6d319a 100644
> Benjamin> --- a/libmultipath/propsel.h
> Benjamin> +++ b/libmultipath/propsel.h
> Benjamin> @@ -37,3 +37,5 @@ void reconcile_features_with_options(const char *id, char **features,
> Benjamin>  				     int* no_path_retry,
> Benjamin>  				     int *retain_hwhandler);
> Benjamin>  int select_all_tg_pt (struct config *conf, struct multipath * mp);
> Benjamin> +int select_vpd_vendor_pg (struct config *conf, struct path *pp);
> Benjamin> +int select_vpd_vendor_id (struct config *conf, struct path *pp);
> Benjamin> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> Benjamin> index 1c32a799..1ad5f64a 100644
> Benjamin> --- a/libmultipath/structs.h
> Benjamin> +++ b/libmultipath/structs.h
> Benjamin> @@ -21,6 +21,7 @@
> Benjamin>  #define HOST_NAME_LEN		16
> Benjamin>  #define SLOT_NAME_SIZE		40
> Benjamin>  #define PRKEY_SIZE		19
> Benjamin> +#define VPD_DATA_SIZE		128
>  
> Benjamin>  #define SCSI_VENDOR_SIZE	9
> Benjamin>  #define SCSI_PRODUCT_SIZE	17
> Benjamin> @@ -243,6 +244,11 @@ struct hd_geometry {
> Benjamin>  };
> Benjamin>  #endif
>  
> Benjamin> +/*
> Benjamin> + * from sg_vpd_vendor.c
> Benjamin> + */
> Benjamin> +#define VPD_VP_HP3PAR 4
> Benjamin> +
> Benjamin>  struct path {
> Benjamin>  	char dev[FILE_NAME_SIZE];
> Benjamin>  	char dev_t[BLK_DEV_SIZE];
> Benjamin> @@ -255,6 +261,7 @@ struct path {
> Benjamin>  	char rev[PATH_REV_SIZE];
> Benjamin>  	char serial[SERIAL_SIZE];
> Benjamin>  	char tgt_node_name[NODE_NAME_SIZE];
> Benjamin> +	char vpd_data[VPD_DATA_SIZE];
> Benjamin>  	unsigned long long size;
> Benjamin>  	unsigned int checkint;
> Benjamin>  	unsigned int tick;
> Benjamin> @@ -287,6 +294,8 @@ struct path {
> Benjamin>  	int io_err_pathfail_starttime;
> Benjamin>  	int find_multipaths_timeout;
> Benjamin>  	int marginal;
> Benjamin> +	int vpd_vendor_pg;
> Benjamin> +	int vpd_vendor_id;
> Benjamin>  	/* configlet pointers */
> Benjamin>  	vector hwe;
> Benjamin>  	struct gen_path generic_path;
> Benjamin> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> Benjamin> index e866da23..dc103fd8 100644
> Benjamin> --- a/multipath/multipath.conf.5
> Benjamin> +++ b/multipath/multipath.conf.5
> Benjamin> @@ -1472,6 +1472,14 @@ the \fIproduct\fR attribute set to the value of \fIproduct_blacklist\fR.
> Benjamin>  The user_friendly_names prefix to use for this
> Benjamin>  device type, instead of the default "mpath".
> Benjamin>  .TP
> Benjamin> +.B vpd_vendor
> Benjamin> +The vendor specific vpd page information, using the vpd page abbreviation.
> Benjamin> +The vpd page abbreviation can be found by running \fIsg_vpd -e\fR. multipathd
> Benjamin> +will use this information to gather device specific information that can be
> Benjamin> +displayed with the \fI%g\fR wilcard for the \fImultipathd show maps format\fR
> Benjamin> +and \fImultipathd show paths format\fR commands. Currently only the
> Benjamin> +\fBhp3par\fR vpd page is supported.
> Benjamin> +.TP
> Benjamin>  .B hardware_handler
> Benjamin>  The hardware handler to use for this device type.
> Benjamin>  The following hardware handler are implemented:
> Benjamin> -- 
> Benjamin> 2.17.2
> 
> Benjamin> --
> Benjamin> dm-devel mailing list
> Benjamin> dm-devel@redhat.com
> Benjamin> https://www.redhat.com/mailman/listinfo/dm-devel
