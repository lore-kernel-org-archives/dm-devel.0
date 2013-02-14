From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH for multipath-tools] Handle SCSI device
 states "quiesce" and "transport-offline" properly
Date: Thu, 14 Feb 2013 19:02:49 +0100
Message-ID: <1360864969.4660.0.camel@lapoo.opensvc.com>
References: <511CF1F8.4040100@acm.org>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <511CF1F8.4040100@acm.org>
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
List-Id: dm-devel.ids

On jeu., 2013-02-14 at 15:17 +0100, Bart Van Assche wrote:
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---

Applied.

Thanks,
Christophe Varoqui
www.opensvc.com

>  libmultipath/discovery.c |    5 +++--
>  libmultipath/structs.h   |    2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 3fbc181..0b5fd1d 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -797,12 +797,13 @@ path_offline (struct path * pp)
>  
>  	condlog(3, "%s: path state = %s", pp->dev, buff);
>  
> -	if (!strncmp(buff, "offline", 7)) {
> +	if (!strncmp(buff, "offline", 7) ||
> +	    !strncmp(buff, "transport-offline", 17)) {
>  		pp->offline = 1;
>  		return PATH_DOWN;
>  	}
>  	pp->offline = 0;
> -	if (!strncmp(buff, "blocked", 7))
> +	if (!strncmp(buff, "blocked", 7) || !strncmp(buff, "quiesce", 7))
>  		return PATH_PENDING;
>  	else if (!strncmp(buff, "running", 7))
>  		return PATH_UP;
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index ab05a78..b9ace36 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -20,7 +20,7 @@
>  #define SCSI_VENDOR_SIZE	9
>  #define SCSI_PRODUCT_SIZE	17
>  #define SCSI_REV_SIZE		5
> -#define SCSI_STATE_SIZE		9
> +#define SCSI_STATE_SIZE		19
>  
>  #define NO_PATH_RETRY_UNDEF	0
>  #define NO_PATH_RETRY_FAIL	-1
