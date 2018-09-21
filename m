From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 3/5] libmultipath: pathinfo: skip hidden
	devices
Date: Fri, 21 Sep 2018 17:52:10 -0500
Message-ID: <20180921225210.GN3172@octiron.msp.redhat.com>
References: <20180914125103.1154-1-mwilck@suse.com>
	<20180914125103.1154-3-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180914125103.1154-3-mwilck@suse.com>
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

On Fri, Sep 14, 2018 at 02:51:01PM +0200, Martin Wilck wrote:

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Hidden block devices (in practice: members of nvme native multipath
> devices) can't be used by multipath anyway. Current multipath code
> (with default blacklisting) skips them, too, but emits a misleading
> "blacklisted: udev property missing" message.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/discovery.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 0b1855dd..11da64ba 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1858,9 +1858,18 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
>  	 * limited by DI_BLACKLIST and occurs before this debug
>  	 * message with the mask value.
>  	 */
> -	if (pp->udev && (is_claimed_by_foreign(pp->udev) ||
> -			 filter_property(conf, pp->udev) > 0))
> -		return PATHINFO_SKIPPED;
> +	if (pp->udev) {
> +		const char *hidden =
> +			udev_device_get_sysattr_value(pp->udev, "hidden");
> +
> +		if (hidden && !strcmp(hidden, "1")) {
> +			condlog(3, "%s: hidden", pp->dev);
> +			return PATHINFO_SKIPPED;
> +		}
> +		if (is_claimed_by_foreign(pp->udev) ||
> +			 filter_property(conf, pp->udev) > 0)
> +			return PATHINFO_SKIPPED;
> +	}
>  
>  	if (filter_devnode(conf->blist_devnode,
>  			   conf->elist_devnode,
> -- 
> 2.18.0
