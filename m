From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 02/10] kpartx: avoid ioctl error for loop
	devices
Date: Mon, 8 May 2017 15:46:11 -0500
Message-ID: <20170508204611.GE22856@octiron.msp.redhat.com>
References: <20170505220559.7248-1-mwilck@suse.com>
	<20170505220559.7248-3-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170505220559.7248-3-mwilck@suse.com>
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

dm_no_partitions() checks if features includes "no_partitions", but the
upstream kernel doesn't allow that feature.  The patch to add it got
NAKed when Hannes posted it, IIRC. That's why I went the route of using
udev flags to avoid running kpartx.  Unless SUSE (or some other distro)
is using the "no_partitions" patch in their kernel, we can pull the
dm_no_partitions code completely.

If you're still using it, I'm fine with this patch.
-Ben

On Sat, May 06, 2017 at 12:05:51AM +0200, Martin Wilck wrote:
> Commit 3d709241 causes kpartx to attempt a dm ioctl on a loop
> device. This causes an error message
> "device-mapper: table ioctl on loop4 failed: No such device or address".
> 
> Fixes: 3d709241 "kpartx: sanitize delete partitions"
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  kpartx/kpartx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index 58e60ffe..e9b09492 100644
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> @@ -362,7 +362,7 @@ main(int argc, char **argv){
>  
>  	if (!mapname)
>  		mapname = device + off;
> -	if (!force_devmap &&
> +	else if (!force_devmap &&
>  		 dm_no_partitions(mapname)) {
>  		/* Feature 'no_partitions' is set, return */
>  		return 0;
> -- 
> 2.12.2
