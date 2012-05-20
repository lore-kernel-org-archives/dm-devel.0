From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] multipath: fix select_no_path_retry for
 flushing devices.
Date: Sun, 20 May 2012 12:33:34 +0200
Message-ID: <1337510014.27070.4.camel@lapoo.opensvc.com>
References: <20120518223326.GI3343@ether.msp.redhat.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120518223326.GI3343@ether.msp.redhat.com>
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

On ven., 2012-05-18 at 17:33 -0500, Benjamin Marzinski wrote:
> The select_no_path_retry code was falling through if a flush was
> in progress, and so it wasn't honoring flush_on_last_del.
> 
Applied.

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/propsel.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: multipath-tools-120403/libmultipath/propsel.c
> ===================================================================
> --- multipath-tools-120403.orig/libmultipath/propsel.c
> +++ multipath-tools-120403/libmultipath/propsel.c
> @@ -415,6 +415,7 @@ select_no_path_retry(struct multipath *m
>  	if (mp->flush_on_last_del == FLUSH_IN_PROGRESS) {
>  		condlog(0, "flush_on_last_del in progress");
>  		mp->no_path_retry = NO_PATH_RETRY_FAIL;
> +		return 0;
>  	}
>  	if (mp->mpe && mp->mpe->no_path_retry != NO_PATH_RETRY_UNDEF) {
>  		mp->no_path_retry = mp->mpe->no_path_retry;
