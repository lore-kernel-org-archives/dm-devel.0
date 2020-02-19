From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 1/5] multipath: fix issues found by compiling
	with gcc 10
Date: Wed, 19 Feb 2020 10:28:31 +0100
Message-ID: <d947b08c9f137b08f8f22fa0831cb77ccd9299c4.camel@suse.com>
References: <1582095273-10279-1-git-send-email-bmarzins@redhat.com>
	<1582095273-10279-2-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1582095273-10279-2-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2020-02-19 at 00:54 -0600, Benjamin Marzinski wrote:
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  kpartx/dasd.c        | 6 +++---
>  libmultipath/print.c | 3 ++-
>  multipath/main.c     | 2 +-
>  3 files changed, 6 insertions(+), 5 deletions(-)

I don't recall having raised issues about this, actually I haven't
tested with gcc10 so far. But never mind :-)

> diff --git a/kpartx/dasd.c b/kpartx/dasd.c
> index 1486ccaa..57305825 100644
> --- a/kpartx/dasd.c
> +++ b/kpartx/dasd.c
> @@ -186,7 +186,7 @@ read_dasd_pt(int fd, __attribute__((unused))
> struct slice all,
>  		goto out;
>  	}
>  
> -	if ((!info.FBA_layout) && (!strcmp(info.type, "ECKD")))
> +	if ((!info.FBA_layout) && (!strncmp(info.type, "ECKD", 4)))
>  		memcpy (&vlabel, data, sizeof(vlabel));

It looks to me as if this should actually be memcmp(), as info.type is
not NUL-terminated.

>  	else {
>  		bzero(&vlabel,4);
> @@ -216,7 +216,7 @@ read_dasd_pt(int fd, __attribute__((unused))
> struct slice all,
>  		sp[0].size  = size - sp[0].start;
>  		retval = 1;
>  	} else if ((strncmp(type, "VOL1", 4) == 0) &&
> -		(!info.FBA_layout) && (!strcmp(info.type, "ECKD"))) {
> +		(!info.FBA_layout) && (!strncmp(info.type, "ECKD",4)))
> {
>  		/*
>  		 * New style VOL1 labeled disk
>  		 */
> @@ -265,7 +265,7 @@ read_dasd_pt(int fd, __attribute__((unused))
> struct slice all,
>  			if (vlabel.ldl_version == 0xf2) {
>  				fmt_size =
> sectors512(vlabel.formatted_blocks,
>  						      blocksize);
> -			} else if (!strcmp(info.type, "ECKD")) {
> +			} else if (!strncmp(info.type, "ECKD",4)) {
>  				/* formatted w/o large volume support
> */
>  				fmt_size = geo.cylinders * geo.heads
>  					* geo.sectors * (blocksize >>
> 9);
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 1858d8ea..55b19195 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -29,6 +29,7 @@
>  #include "uevent.h"
>  #include "debug.h"
>  #include "discovery.h"
> +#include "util.h"
>  
>  #define MAX(x,y) (((x) > (y)) ? (x) : (y))
>  #define MIN(x,y) (((x) > (y)) ? (y) : (x))
> @@ -2056,7 +2057,7 @@ int snprint_devices(struct config *conf, char *
> buff, int len,
>  
>  		devptr = devpath + 11;
>  		*devptr = '\0';
> -		strncat(devptr, blkdev->d_name, PATH_MAX-12);
> +		strlcpy(devptr, blkdev->d_name, PATH_MAX-11);
>  		if (stat(devpath, &statbuf) < 0)
>  			continue;

If you use strlcpy(), you can delete the "*devptr = '\0'" statement (we
can be certain that (PATH_MAX-11 > 0), thus strlcpy() is guaranteed to
write a NUL byte).

Moreover, while you're at that, copying "/sys/block/" to devpath before
the loop is an ugly pseudo-optimization (not your fault). Readability
would be improved by ditching that and simply writing

     if (safe_snprintf(devpath, sizeof(devpath), 
                       "/sys/block/%s", devptr))
             continue;

inside the loop.

Martin
