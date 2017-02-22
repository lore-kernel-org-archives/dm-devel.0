From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCHv2] Fill NVMe specific path info
Date: Wed, 22 Feb 2017 02:00:19 +0100
Message-ID: <5aa304c3-9ce3-0acb-65f9-0898bcd37e11@gmail.com>
References: <1487715151-1179-1-git-send-email-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1487715151-1179-1-git-send-email-keith.busch@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 02/21/2017 11:12 PM, Keith Busch wrote:

multipath-tools project does not use Patchwork.
CC: Christophe Varoqui

> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
> v1->v2:
>   Removed explicitly setting the wwid path information. We get that with
>   through exported udev attributes.
> 
>   Added default retain_hwhandler to off for NVME devices. This has the
>   kernel not call into scsi specific APIs that don't exist for NVMe.
> 
>  libmultipath/discovery.c | 35 +++++++++++++++++++++++++++++++++++
>  libmultipath/hwtable.c   | 10 ++++++++++
>  libmultipath/structs.h   |  1 +
>  3 files changed, 46 insertions(+)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index d1aec31..39dd92a 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1187,6 +1187,36 @@ scsi_sysfs_pathinfo (struct path * pp, vector hwtable)
>  }
>  
>  static int
> +nvme_sysfs_pathinfo (struct path * pp, vector hwtable)
> +{
> +	struct udev_device *parent, *nvme = NULL;
> +
> +	parent = pp->udev;
> +	while (parent) {
> +		const char *subsys = udev_device_get_subsystem(parent);
> +
> +		if (subsys && !strncmp(subsys, "nvme", 4)) {
> +			nvme = parent;
> +			break;
> +		}
> +		parent = udev_device_get_parent(parent);
> +	}
> +	if (!nvme)
> +		return 1;
> +
> +	snprintf(pp->vendor_id, SCSI_VENDOR_SIZE, "NVME");
> +	snprintf(pp->product_id, SCSI_PRODUCT_SIZE, "%s", udev_device_get_sysattr_value(nvme, "model"));
> +	snprintf(pp->serial, SERIAL_SIZE, "%s", udev_device_get_sysattr_value(nvme, "serial"));
> +	snprintf(pp->rev, SCSI_REV_SIZE, "%s", udev_device_get_sysattr_value(nvme, "firmware_rev"));
> +
> +	condlog(3, "%s: vendor:%s product:%s serial:%s rev:%s", pp->dev,
> +		pp->vendor_id, pp->product_id, pp->serial, pp->rev);
> +	pp->hwe = find_hwe(hwtable, pp->vendor_id, pp->product_id, NULL);
> +
> +	return 0;
> +}
> +
> +static int
>  rbd_sysfs_pathinfo (struct path * pp, vector hwtable)
>  {
>  	sprintf(pp->vendor_id, "Ceph");
> @@ -1405,6 +1435,8 @@ sysfs_pathinfo(struct path * pp, vector hwtable)
>  		pp->bus = SYSFS_BUS_SCSI;
>  	if (!strncmp(pp->dev,"rbd", 3))
>  		pp->bus = SYSFS_BUS_RBD;
> +	if (!strncmp(pp->dev,"nvme", 4))
> +		pp->bus = SYSFS_BUS_NVME;
>  
>  	if (pp->bus == SYSFS_BUS_UNDEF)
>  		return 0;
> @@ -1420,6 +1452,9 @@ sysfs_pathinfo(struct path * pp, vector hwtable)
>  	} else if (pp->bus == SYSFS_BUS_RBD) {
>  		if (rbd_sysfs_pathinfo(pp, hwtable))
>  			return 1;
> +	} else if (pp->bus == SYSFS_BUS_NVME) {
> +		if (nvme_sysfs_pathinfo(pp, hwtable))
> +			return 1;
>  	}
>  	return 0;
>  }
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index f5a5f7b..8409261 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1073,6 +1073,16 @@ static struct hwentry default_hw[] = {
>  		.prio_name     = PRIO_ALUA,
>  		.no_path_retry = 30,
>  	},
> +	/*
> +	 * Generic NVMe devices
> +	 */
> +	{
> +		.vendor	       = "NVME",
> +		.product       = ".*",
> +		.uid_attribute = "ID_WWN",
> +		.checker_name  = DIRECTIO,
> +		.retain_hwhandler = RETAIN_HWHANDLER_OFF,
> +	},
>  #if 0
>  	/*
>  	 * Copy this TEMPLATE to add new hardware.
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 6edd927..dfd65ae 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -53,6 +53,7 @@ enum sysfs_buses {
>  	SYSFS_BUS_CCW,
>  	SYSFS_BUS_CCISS,
>  	SYSFS_BUS_RBD,
> +	SYSFS_BUS_NVME,
>  };
>  
>  enum pathstates {
> 
