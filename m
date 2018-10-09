From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 1/1] kpartx: Use absolute paths to create
 mappings
Date: Tue, 9 Oct 2018 18:21:19 -0500
Message-ID: <20181009232119.GK3172@octiron.msp.redhat.com>
References: <20181006073856.15246-1-stefw@redhat.com>
	<20181006073856.15246-2-stefw@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181006073856.15246-2-stefw@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Stef Walter <stefw@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, Oct 06, 2018 at 09:38:56AM +0200, Stef Walter wrote:
> kpartx -d now uses absolute paths to delete mappings, since the
> commit 9bdfa3eb8e24b668e6c2bb882cddb0ccfe23ed5b. We should use
> those same absolute paths to create the mappings.
> 
> Without this patch, the following workflow (as seen in the
> manual page for kpartx) fails to actually remove the devices:
> 
>     # kpartx -av disk.img
>     ...
>     # kpartx -d disk.img

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  kpartx/kpartx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index 442b6bd9..d4fb53be 100644
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> @@ -341,7 +341,7 @@ main(int argc, char **argv){
>  		if (!loopdev) {
>  			loopdev = find_unused_loop_device();
>  
> -			if (set_loop(loopdev, device, 0, &ro)) {
> +			if (set_loop(loopdev, rpath, 0, &ro)) {
>  				fprintf(stderr, "can't set up loop\n");
>  				exit (1);
>  			}
> -- 
> 2.17.1
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
