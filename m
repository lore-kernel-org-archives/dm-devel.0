From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 18/23] libmultipath: pathinfo: call into
 foreign library
Date: Wed, 7 Mar 2018 13:10:11 -0600
Message-ID: <20180307191011.GU14513@octiron.msp.redhat.com>
References: <20180305231507.10386-1-mwilck@suse.com>
	<20180305231507.10386-19-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180305231507.10386-19-mwilck@suse.com>
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

On Tue, Mar 06, 2018 at 12:15:02AM +0100, Martin Wilck wrote:
> This actually enables the use of foreign paths.
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/discovery.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 645224c1029c..45a4d8378893 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -31,6 +31,7 @@
>  #include "prio.h"
>  #include "defaults.h"
>  #include "prioritizers/alua_rtpg.h"
> +#include "foreign.h"
>  
>  int
>  alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
> @@ -1909,7 +1910,8 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
>  	 * limited by DI_BLACKLIST and occurs before this debug
>  	 * message with the mask value.
>  	 */
> -	if (pp->udev && filter_property(conf, pp->udev) > 0)
> +	if (pp->udev && (is_claimed_by_foreign(pp->udev) ||
> +			 filter_property(conf, pp->udev) > 0))
>  		return PATHINFO_SKIPPED;
>  
>  	if (filter_devnode(conf->blist_devnode,
> -- 
> 2.16.1
