From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] dm-multipath: blacklist NVMe devices
Date: Thu, 27 Feb 2014 09:13:40 +0100
Message-ID: <CABr-GncP7ftWa2e7ujJUWQWdQ7jF777zZQJt44XmKt5Eou+W-w@mail.gmail.com>
References: <1393470859-9271-1-git-send-email-vaughan.cao@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1393470859-9271-1-git-send-email-vaughan.cao@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Applied.

Thanks.

On Thu, Feb 27, 2014 at 4:14 AM, Vaughan Cao <vaughan.cao@oracle.com> wrote:
> Multipath works at the request level and NVMe bypasses the request layer. So
> multipath is not going to be supported for NVMe devices. Add NVMe to default
> blacklist.
>
> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
> ---
>  libmultipath/blacklist.c | 6 ++++++
>  multipath.conf.defaults  | 1 +
>  2 files changed, 7 insertions(+)
>
> diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
> index 79ddcde..651bd7e 100644
> --- a/libmultipath/blacklist.c
> +++ b/libmultipath/blacklist.c
> @@ -176,6 +176,12 @@ setup_default_blist (struct config * conf)
>         if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
>                 return 1;
>
> +       str = STRDUP("^nvme.*");
> +       if (!str)
> +               return 1;
> +       if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
> +               return 1;
> +
>         str = STRDUP("(ID_SCSI_VPD|ID_WWN)");
>         if (!str)
>                 return 1;
> diff --git a/multipath.conf.defaults b/multipath.conf.defaults
> index e761902..12fb3f0 100644
> --- a/multipath.conf.defaults
> +++ b/multipath.conf.defaults
> @@ -31,6 +31,7 @@
>  #      devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
>  #      devnode "^hd[a-z]"
>  #      devnode "^dcssblk[0-9]*"
> +#      devnode "^nvme.*"
>  #      device {
>  #              vendor "DGC"
>  #              product "LUNZ"
> --
> 1.8.3.1
>
