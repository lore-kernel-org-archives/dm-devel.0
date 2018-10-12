From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 3/8] libmultipath: cciss_ioctl_pathinfo
	doesn't fail
Date: Fri, 12 Oct 2018 16:47:09 -0500
Message-ID: <20181012214709.GF29125@octiron.msp.redhat.com>
References: <20181010200506.15796-1-mwilck@suse.com>
	<20181010200506.15796-4-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181010200506.15796-4-mwilck@suse.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Oct 10, 2018 at 10:05:01PM +0200, Martin Wilck wrote:
> Make it a void function and move the DI_SERIAL test to pathinfo().
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/discovery.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 8381d982..873035e5 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1538,14 +1538,11 @@ scsi_ioctl_pathinfo (struct path * pp, struct config *conf, int mask)
>  	return;
>  }
>  
> -static int
> -cciss_ioctl_pathinfo (struct path * pp, int mask)
> +static void
> +cciss_ioctl_pathinfo(struct path *pp)
>  {
> -	if (mask & DI_SERIAL) {
> -		get_serial(pp->serial, SERIAL_SIZE, pp->fd);
> -		condlog(3, "%s: serial = %s", pp->dev, pp->serial);
> -	}
> -	return 0;
> +	get_serial(pp->serial, SERIAL_SIZE, pp->fd);
> +	condlog(3, "%s: serial = %s", pp->dev, pp->serial);
>  }
>  
>  int
> @@ -1940,9 +1937,8 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
>  	if (path_state == PATH_UP && pp->bus == SYSFS_BUS_SCSI)
>  		scsi_ioctl_pathinfo(pp, conf, mask);
>  
> -	if (pp->bus == SYSFS_BUS_CCISS &&
> -	    cciss_ioctl_pathinfo(pp, mask))
> -		goto blank;
> +	if (pp->bus == SYSFS_BUS_CCISS && mask & DI_SERIAL)
> +		cciss_ioctl_pathinfo(pp);
>  
>  	if (mask & DI_CHECKER) {
>  		if (path_state == PATH_UP) {
> -- 
> 2.19.0
