From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH] libmultipath,
	rbd: Fix spelling in a source code comment
Date: Wed, 17 Aug 2016 11:36:31 -0500
Message-ID: <334a74af-e596-8e3a-fdf8-c4c62640d1ac@redhat.com>
References: <0d6eda99-c8ef-1614-7a10-960b163e761b@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0d6eda99-c8ef-1614-7a10-960b163e761b@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 08/16/2016 03:02 PM, Bart Van Assche wrote:
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> ---
>  libmultipath/checkers/rbd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmultipath/checkers/rbd.c b/libmultipath/checkers/rbd.c
> index 6f1b53a..7f540ad 100644
> --- a/libmultipath/checkers/rbd.c
> +++ b/libmultipath/checkers/rbd.c
> @@ -355,7 +355,7 @@ static int sysfs_write_rbd_bus(const char *which, const char *buf,
>  	int fd;
>  	int r;
>  
> -	/* we require newer kernels so single_major should alwayws be there */
> +	/* we require newer kernels so single_major should always be there */
>  	snprintf(sysfs_path, sizeof(sysfs_path),
>  		 "/sys/bus/rbd/%s_single_major", which);
>  	fd = open(sysfs_path, O_WRONLY);
> 

Thanks.

Reviewed-by: Mike Christie <mchristi@redhat.com>
