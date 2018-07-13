From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 1/3] libmultipath: alua_rtpg: use condlog for
 error messages
Date: Fri, 13 Jul 2018 14:08:22 -0500
Message-ID: <20180713190822.GC31378@octiron.msp.redhat.com>
References: <20180703075707.834-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180703075707.834-1-mwilck@suse.com>
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

On Tue, Jul 03, 2018 at 09:57:05AM +0200, Martin Wilck wrote:
> Map the PRINT_DEBUG macro of the ALUA code to a condlog call, to
> be able to better debug SCSI error conditions.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/prioritizers/alua_rtpg.c | 34 +++++++++++----------------
>  1 file changed, 14 insertions(+), 20 deletions(-)
> 
> diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
> index e4315020..ce405b55 100644
> --- a/libmultipath/prioritizers/alua_rtpg.c
> +++ b/libmultipath/prioritizers/alua_rtpg.c
> @@ -27,20 +27,14 @@
>  #include "../prio.h"
>  #include "../discovery.h"
>  #include "../unaligned.h"
> +#include "../debug.h"
>  #include "alua_rtpg.h"
>  
>  #define SENSE_BUFF_LEN  32
>  #define SGIO_TIMEOUT     60000
>  
> -/*
> - * Macro used to print debug messaged.
> - */
> -#if DEBUG > 0
>  #define PRINT_DEBUG(f, a...) \
> -		fprintf(stderr, "DEBUG: " f, ##a)
> -#else
> -#define PRINT_DEBUG(f, a...)
> -#endif
> +	condlog(4, "alua: " f, ##a)
>  
>  /*
>   * Optionally print the commands sent and the data received a hex dump.
> @@ -144,12 +138,12 @@ do_inquiry(int fd, int evpd, unsigned int codepage,
>  	hdr.timeout		= get_prio_timeout(timeout, SGIO_TIMEOUT);
>  
>  	if (ioctl(fd, SG_IO, &hdr) < 0) {
> -		PRINT_DEBUG("do_inquiry: IOCTL failed!\n");
> +		PRINT_DEBUG("do_inquiry: IOCTL failed!");
>  		return -RTPG_INQUIRY_FAILED;
>  	}
>  
>  	if (scsi_error(&hdr)) {
> -		PRINT_DEBUG("do_inquiry: SCSI error!\n");
> +		PRINT_DEBUG("do_inquiry: SCSI error!");
>  		return -RTPG_INQUIRY_FAILED;
>  	}
>  	PRINT_HEX((unsigned char *) resp, resplen);
> @@ -189,7 +183,7 @@ get_sysfs_pg83(struct path *pp, unsigned char *buff, int buflen)
>  	}
>  
>  	if (!parent || sysfs_get_vpd(parent, 0x83, buff, buflen) <= 0) {
> -		PRINT_DEBUG("failed to read sysfs vpd pg83\n");
> +		PRINT_DEBUG("failed to read sysfs vpd pg83");
>  		return -1;
>  	}
>  	return 0;
> @@ -208,7 +202,7 @@ get_target_port_group(struct path * pp, unsigned int timeout)
>  	buf = (unsigned char *)malloc(buflen);
>  	if (!buf) {
>  		PRINT_DEBUG("malloc failed: could not allocate"
> -			     "%u bytes\n", buflen);
> +			     "%u bytes", buflen);
>  		return -RTPG_RTPG_FAILED;
>  	}
>  
> @@ -230,7 +224,7 @@ get_target_port_group(struct path * pp, unsigned int timeout)
>  			buf = (unsigned char *)malloc(scsi_buflen);
>  			if (!buf) {
>  				PRINT_DEBUG("malloc failed: could not allocate"
> -					    "%u bytes\n", scsi_buflen);
> +					    "%u bytes", scsi_buflen);
>  				return -RTPG_RTPG_FAILED;
>  			}
>  			buflen = scsi_buflen;
> @@ -248,7 +242,7 @@ get_target_port_group(struct path * pp, unsigned int timeout)
>  			struct vpd83_tpg_dscr *p;
>  			if (rc != -RTPG_NO_TPG_IDENTIFIER) {
>  				PRINT_DEBUG("get_target_port_group: more "
> -					    "than one TPG identifier found!\n");
> +					    "than one TPG identifier found!");
>  				continue;
>  			}
>  			p  = (struct vpd83_tpg_dscr *)dscr->data;
> @@ -258,7 +252,7 @@ get_target_port_group(struct path * pp, unsigned int timeout)
>  
>  	if (rc == -RTPG_NO_TPG_IDENTIFIER) {
>  		PRINT_DEBUG("get_target_port_group: "
> -			    "no TPG identifier found!\n");
> +			    "no TPG identifier found!");
>  	}
>  out:
>  	free(buf);
> @@ -293,7 +287,7 @@ do_rtpg(int fd, void* resp, long resplen, unsigned int timeout)
>  		return -RTPG_RTPG_FAILED;
>  
>  	if (scsi_error(&hdr)) {
> -		PRINT_DEBUG("do_rtpg: SCSI error!\n");
> +		PRINT_DEBUG("do_rtpg: SCSI error!");
>  		return -RTPG_RTPG_FAILED;
>  	}
>  	PRINT_HEX(resp, resplen);
> @@ -315,7 +309,7 @@ get_asymmetric_access_state(int fd, unsigned int tpg, unsigned int timeout)
>  	buf = (unsigned char *)malloc(buflen);
>  	if (!buf) {
>  		PRINT_DEBUG ("malloc failed: could not allocate"
> -			"%u bytes\n", buflen);
> +			"%u bytes", buflen);
>  		return -RTPG_RTPG_FAILED;
>  	}
>  	memset(buf, 0, buflen);
> @@ -330,7 +324,7 @@ get_asymmetric_access_state(int fd, unsigned int tpg, unsigned int timeout)
>  		buf = (unsigned char *)malloc(scsi_buflen);
>  		if (!buf) {
>  			PRINT_DEBUG ("malloc failed: could not allocate"
> -				"%u bytes\n", scsi_buflen);
> +				"%u bytes", scsi_buflen);
>  			return -RTPG_RTPG_FAILED;
>  		}
>  		buflen = scsi_buflen;
> @@ -347,9 +341,9 @@ get_asymmetric_access_state(int fd, unsigned int tpg, unsigned int timeout)
>  			if (rc != -RTPG_TPG_NOT_FOUND) {
>  				PRINT_DEBUG("get_asymmetric_access_state: "
>  					"more than one entry with same port "
> -					"group.\n");
> +					"group.");
>  			} else {
> -				PRINT_DEBUG("pref=%i\n", dscr->b0);
> +				condlog(5, "pref=%i", dscr->b0);
>  				rc = rtpg_tpg_dscr_get_aas(dscr);
>  			}
>  		}
> -- 
> 2.17.1
