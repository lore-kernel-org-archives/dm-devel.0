From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] libmultipath: ensure dev_loss_tmo will be
 update to MAX_DEV_LOSS_TMO if no_path_retry set to queue
Date: Mon, 28 Nov 2016 18:16:39 -0600
Message-ID: <20161129001639.GG1972@octiron.msp.redhat.com>
References: <1480055764-11124-1-git-send-email-peng.liang5@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1480055764-11124-1-git-send-email-peng.liang5@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: peng.liang5@zte.com.cn
Cc: dm-devel@redhat.com, zhang.kai16@zte.com.cn
List-Id: dm-devel.ids

On Fri, Nov 25, 2016 at 02:36:04PM +0800, peng.liang5@zte.com.cn wrote:
> From: PengLiang <peng.liang5@zte.com.cn>
> 
> If no_path_retry set to queue, we should make sure dev_loss_tmo update to MAX_DEV_LOSS_TMO.
> But, it will be limit to 600 if fast_io_fail_tmo set to off or 0 meanwhile.

Doesn't the system still limit dev_loss_tmo to 600 if fast_io_fail_tmo isn't set. Multipath
was using this limit, since the underlying system uses it.

-Ben

> 
> Signed-off-by: PengLiang <peng.liang5@zte.com.cn>
> ---
>  libmultipath/discovery.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index aaa915c..05b0842 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -608,7 +608,8 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
>  				goto out;
>  			}
>  		}
> -	} else if (mpp->dev_loss > DEFAULT_DEV_LOSS_TMO) {
> +	} else if (mpp->dev_loss > DEFAULT_DEV_LOSS_TMO &&
> +		mpp->no_path_retry != NO_PATH_RETRY_QUEUE) {
>  		condlog(3, "%s: limiting dev_loss_tmo to %d, since "
>  			"fast_io_fail is not set",
>  			rport_id, DEFAULT_DEV_LOSS_TMO);
> -- 
> 2.8.1.windows.1
