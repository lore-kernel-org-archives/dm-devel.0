From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 68/78] libmultipath: unset 'uid_attribute' on
	failure
Date: Thu, 26 Mar 2015 23:10:37 -0500
Message-ID: <20150327041037.GS29132@octiron.msp.redhat.com>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
	<1426509425-15978-69-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1426509425-15978-69-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 16, 2015 at 01:36:55PM +0100, Hannes Reinecke wrote:
> Due to a race condition within udev the 'uid_attribute'
> might not always be set. So we should be zeroing the
> 'uid_attribute' when retrieving the uid by other means,
> otherwise the discovery process will blacklist the device.

Possibly I'm just missing obvious here, but I don't get the point of
zeroing out the uid_attribute.  Won't it just get reset on the next call
to get_uid?

-Ben

> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  libmultipath/discovery.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index d5dda2c..8e6b228 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1497,13 +1497,17 @@ get_uid (struct path * pp)
>  		}
>  		if (len <= 0) {
>  			len = get_vpd_uid(pp);
> -			if (len > 0)
> +			if (len > 0) {
>  				origin = "sysfs";
> +				pp->uid_attribute = NULL;
> +			}
>  		}
>  		if (len <= 0) {
>  			len = get_udev_uid(pp, DEFAULT_UID_ATTRIBUTE);
> -			if (len > 0)
> -				origin = "udev";
> +			if (len > 0) {
> +				origin = "default";
> +				pp->uid_attribute = DEFAULT_UID_ATTRIBUTE;
> +			}
>  		}
>  	}
>  	if ( len < 0 ) {
> -- 
> 1.8.4.5
