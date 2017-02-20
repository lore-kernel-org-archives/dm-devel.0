From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] Don't blacklist nvme
Date: Mon, 20 Feb 2017 09:14:29 -0500
Message-ID: <20170220141429.GA12172@redhat.com>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 14 2017 at  4:19pm -0500,
Keith Busch <keith.busch@intel.com> wrote:

> These devices are mulitpath capable, and have been able to stack with
> dm-mpath since kernel 4.2.
> 
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
>  libmultipath/blacklist.c   | 2 +-
>  multipath/multipath.conf.5 | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
> index 36af282..ee396e2 100644
> --- a/libmultipath/blacklist.c
> +++ b/libmultipath/blacklist.c
> @@ -169,7 +169,7 @@ setup_default_blist (struct config * conf)
>  	char * str;
>  	int i;
>  
> -	str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk|nvme)[0-9]");
> +	str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]");
>  	if (!str)
>  		return 1;
>  	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 7de8bc7..d6c6c52 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -943,7 +943,7 @@ The following keywords are recognized:
>  Regular expression of the device nodes to be excluded.
>  .RS
>  .TP
> -The default is: \fB^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk|nvme)[0-9]\fR and \fB^(td|hd|vd)[a-z]\fR
> +The default is: \fB^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]\fR and \fB^(td|hd|vd)[a-z]\fR
>  .RE
>  .TP
>  .B wwid

Christophe,

Please take this.  The original commit 5c412e47e589 ("dm-multipath:
blacklist NVMe devices") was completely unjustified.  Not sure how in
2014 this person had any basis for pushing that change.

Thanks,
Mike
