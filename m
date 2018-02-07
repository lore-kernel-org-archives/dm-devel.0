From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] libmultipath: increase path product_id/rev
 field size for NVMe
Date: Wed, 7 Feb 2018 13:36:24 -0600
Message-ID: <20180207193624.GP14513@octiron.msp.redhat.com>
References: <20180119115535.4771-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180119115535.4771-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

On Fri, Jan 19, 2018 at 12:55:35PM +0100, Martin Wilck wrote:
> NVMe allows longer strings for the model (product) and firmware rev
> than SCSI.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/config.c    |  2 +-
>  libmultipath/discovery.c | 12 ++++++------
>  libmultipath/structs.h   | 10 ++++++++--
>  3 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 1461a17cddbe..2592990ecccd 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -319,7 +319,7 @@ set_param_str(char * str)
>  static int
>  merge_hwe (struct hwentry * dst, struct hwentry * src)
>  {
> -	char id[SCSI_VENDOR_SIZE+SCSI_PRODUCT_SIZE];
> +	char id[SCSI_VENDOR_SIZE+PATH_PRODUCT_SIZE];
>  	merge_str(vendor);
>  	merge_str(product);
>  	merge_str(revision);
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 88fc8d732258..88e9f3b61510 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1158,12 +1158,12 @@ scsi_sysfs_pathinfo (struct path * pp, vector hwtable)
>  
>  	condlog(3, "%s: vendor = %s", pp->dev, pp->vendor_id);
>  
> -	if (sysfs_get_model(parent, pp->product_id, SCSI_PRODUCT_SIZE) <= 0)
> +	if (sysfs_get_model(parent, pp->product_id, PATH_PRODUCT_SIZE) <= 0)
>  		return 1;
>  
>  	condlog(3, "%s: product = %s", pp->dev, pp->product_id);
>  
> -	if (sysfs_get_rev(parent, pp->rev, SCSI_REV_SIZE) < 0)
> +	if (sysfs_get_rev(parent, pp->rev, PATH_REV_SIZE) < 0)
>  		return 1;
>  
>  	condlog(3, "%s: rev = %s", pp->dev, pp->rev);
> @@ -1223,11 +1223,11 @@ nvme_sysfs_pathinfo (struct path * pp, vector hwtable)
>  	pp->sg_id.channel = attr ? atoi(attr) : 0;
>  
>  	snprintf(pp->vendor_id, SCSI_VENDOR_SIZE, "NVME");
> -	snprintf(pp->product_id, SCSI_PRODUCT_SIZE, "%s",
> +	snprintf(pp->product_id, PATH_PRODUCT_SIZE, "%s",
>  		 udev_device_get_sysattr_value(parent, "model"));
>  	snprintf(pp->serial, SERIAL_SIZE, "%s",
>  		 udev_device_get_sysattr_value(parent, "serial"));
> -	snprintf(pp->rev, SCSI_REV_SIZE, "%s",
> +	snprintf(pp->rev, PATH_REV_SIZE, "%s",
>  		 udev_device_get_sysattr_value(parent, "firmware_rev"));
>  
>  	condlog(3, "%s: vendor = %s", pp->dev, pp->vendor_id);
> @@ -1342,12 +1342,12 @@ cciss_sysfs_pathinfo (struct path * pp, vector hwtable)
>  
>  	condlog(3, "%s: vendor = %s", pp->dev, pp->vendor_id);
>  
> -	if (sysfs_get_model(parent, pp->product_id, SCSI_PRODUCT_SIZE) <= 0)
> +	if (sysfs_get_model(parent, pp->product_id, PATH_PRODUCT_SIZE) <= 0)
>  		return 1;
>  
>  	condlog(3, "%s: product = %s", pp->dev, pp->product_id);
>  
> -	if (sysfs_get_rev(parent, pp->rev, SCSI_REV_SIZE) <= 0)
> +	if (sysfs_get_rev(parent, pp->rev, PATH_REV_SIZE) <= 0)
>  		return 1;
>  
>  	condlog(3, "%s: rev = %s", pp->dev, pp->rev);
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index d132dfcebce4..b951c7b0e157 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -25,6 +25,12 @@
>  #define SCSI_PRODUCT_SIZE	17
>  #define SCSI_REV_SIZE		5
>  #define SCSI_STATE_SIZE		19
> +#define NVME_MODEL_SIZE         41
> +#define NVME_REV_SIZE           9
> +
> +/* This must be the maximum of SCSI and NVME sizes */
> +#define PATH_PRODUCT_SIZE NVME_MODEL_SIZE
> +#define PATH_REV_SIZE NVME_REV_SIZE
>  
>  #define NO_PATH_RETRY_UNDEF	0
>  #define NO_PATH_RETRY_FAIL	-1
> @@ -214,8 +220,8 @@ struct path {
>  	struct hd_geometry geom;
>  	char wwid[WWID_SIZE];
>  	char vendor_id[SCSI_VENDOR_SIZE];
> -	char product_id[SCSI_PRODUCT_SIZE];
> -	char rev[SCSI_REV_SIZE];
> +	char product_id[PATH_PRODUCT_SIZE];
> +	char rev[PATH_REV_SIZE];
>  	char serial[SERIAL_SIZE];
>  	char tgt_node_name[NODE_NAME_SIZE];
>  	unsigned long long size;
> -- 
> 2.15.1
