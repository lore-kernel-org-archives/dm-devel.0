From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] multipath: fix setting sysfs fc timeout
	parameters
Date: Tue, 21 Aug 2012 19:40:34 +0200
Message-ID: <1345570834.21991.1.camel@lapoo.opensvc.com>
References: <20120820222646.GY5299@ether.msp.redhat.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120820222646.GY5299@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On lun., 2012-08-20 at 17:26 -0500, Benjamin Marzinski wrote:
> Multipath was accidentally trying to write to the directory where
> dev_loss_tmo and fast_io_fail_tmo were located instead to the files
> themselves. Also, if dev_loss_tmo was unset, it was trying to set it
> to 0. Finally, it wasn't correctly checking for errors in setting
> the files.  This patch fixes these issues.
> 
Applied.

Thanks.

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/discovery.c |    7 ++++---
>  libmultipath/sysfs.c     |    7 ++++---
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> Index: multipath-tools-120727/libmultipath/discovery.c
> ===================================================================
> --- multipath-tools-120727.orig/libmultipath/discovery.c
> +++ multipath-tools-120727/libmultipath/discovery.c
> @@ -281,7 +281,8 @@ sysfs_set_rport_tmo(struct multipath *mp
>  		pp->sg_id.channel, pp->sg_id.scsi_id, rport_id);
>  
>  	snprintf(value, 11, "%u", mpp->dev_loss);
> -	if (sysfs_attr_set_value(rport_dev, "dev_loss_tmo", value, 11) < 0) {
> +	if (mpp->dev_loss &&
> +	    sysfs_attr_set_value(rport_dev, "dev_loss_tmo", value, 11) <= 0) {
>  		if ((!mpp->fast_io_fail ||
>  		     mpp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
>  		    && mpp->dev_loss > 600) {
> @@ -289,7 +290,7 @@ sysfs_set_rport_tmo(struct multipath *mp
>  				"fast_io_fail is not set", mpp->alias);
>  			snprintf(value, 11, "%u", 600);
>  			if (sysfs_attr_set_value(rport_dev, "dev_loss_tmo",
> -						 value, 11) < 0)
> +						 value, 11) <= 0)
>  				condlog(0, "%s failed to set dev_loss_tmo",
>  					mpp->alias);
>  			goto out;
> @@ -303,7 +304,7 @@ sysfs_set_rport_tmo(struct multipath *mp
>  		else
>  			snprintf(value, 11, "%u", mpp->fast_io_fail);
>  		if (sysfs_attr_set_value(rport_dev, "fast_io_fail_tmo",
> -					 value, 11) < 0) {
> +					 value, 11) <= 0) {
>  			condlog(0, "%s failed to set fast_io_fail_tmo",
>  				mpp->alias);
>  		}
> Index: multipath-tools-120727/libmultipath/sysfs.c
> ===================================================================
> --- multipath-tools-120727.orig/libmultipath/sysfs.c
> +++ multipath-tools-120727/libmultipath/sysfs.c
> @@ -41,7 +41,7 @@
>  ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
>  			     char * value, size_t value_len)
>  {
> -	const char *devpath;
> +	char devpath[PATH_SIZE];
>  	struct stat statbuf;
>  	int fd;
>  	ssize_t size = -1;
> @@ -49,8 +49,9 @@ ssize_t sysfs_attr_set_value(struct udev
>  	if (!dev || !attr_name || !value)
>  		return 0;
>  
> -	devpath = udev_device_get_syspath(dev);
> -	condlog(4, "open '%s'/'%s'", devpath, attr_name);
> +	snprintf(devpath, PATH_SIZE, "%s/%s", udev_device_get_syspath(dev),
> +		 attr_name);
> +	condlog(4, "open '%s'", devpath);
>  	if (stat(devpath, &statbuf) != 0) {
>  		condlog(4, "stat '%s' failed: %s", devpath, strerror(errno));
>  		return 0;
