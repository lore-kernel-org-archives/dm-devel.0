From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH for multipath-tools] Handle SCSI device
 states "quiesce" and "transport-offline" properly
Date: Thu, 14 Feb 2013 10:03:15 -0600
Message-ID: <511D0AC3.6090409@cs.wisc.edu>
References: <511CF1F8.4040100@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids

Patch looks ok to me. When I added transport-offline to scsi-ml, I
forgot to modify userspace apps. Thanks for fixing.

For the second part, I think it makes sense to handle quiesce like
blocked since drivers use that state like how fc/iscsi use blocked.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>


On 02/14/2013 08:17 AM, Bart Van Assche wrote:
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
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
> 
