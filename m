From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 2/3] libmultipath: alua: retry RTPG for
 NOT_READY and UNIT_ATTENTION
Date: Fri, 13 Jul 2018 14:08:42 -0500
Message-ID: <20180713190842.GD31378@octiron.msp.redhat.com>
References: <20180703075707.834-1-mwilck@suse.com>
	<20180703075707.834-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180703075707.834-2-mwilck@suse.com>
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

On Tue, Jul 03, 2018 at 09:57:06AM +0200, Martin Wilck wrote:
> Use similar logic as the kernel for retrying ALUA commands to
> avoid misinterpreting temporary failures as fatal errors.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/prioritizers/alua_rtpg.c | 59 +++++++++++++++++++++++----
>  1 file changed, 50 insertions(+), 9 deletions(-)
> 
> diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
> index ce405b55..34b5f3ce 100644
> --- a/libmultipath/prioritizers/alua_rtpg.c
> +++ b/libmultipath/prioritizers/alua_rtpg.c
> @@ -69,10 +69,20 @@ print_hex(unsigned char *p, unsigned long len)
>  #define SCSI_COMMAND_TERMINATED 0x22
>  #define SG_ERR_DRIVER_SENSE     0x08
>  #define RECOVERED_ERROR 0x01
> +#define NOT_READY 0x2
> +#define UNIT_ATTENTION 0x6
> +
> +enum scsi_disposition {
> +	SCSI_GOOD = 0,
> +	SCSI_ERROR,
> +	SCSI_RETRY,
> +};
>  
>  static int
> -scsi_error(struct sg_io_hdr *hdr)
> +scsi_error(struct sg_io_hdr *hdr, int opcode)
>  {
> +	int sense_key, asc, ascq;
> +
>  	/* Treat SG_ERR here to get rid of sg_err.[ch] */
>  	hdr->status &= 0x7e;
>  
> @@ -81,29 +91,44 @@ scsi_error(struct sg_io_hdr *hdr)
>  		(hdr->host_status == 0)   &&
>  		(hdr->driver_status == 0)
>  	) {
> -		return 0;
> +		return SCSI_GOOD;
>  	}
>  
> +	sense_key = asc = ascq = -1;
>  	if (
>  		(hdr->status == SCSI_CHECK_CONDITION)    ||
>  		(hdr->status == SCSI_COMMAND_TERMINATED) ||
>  		((hdr->driver_status & 0xf) == SG_ERR_DRIVER_SENSE)
>  	) {
>  		if (hdr->sbp && (hdr->sb_len_wr > 2)) {
> -			int		sense_key;
>  			unsigned char *	sense_buffer = hdr->sbp;
>  
> -			if (sense_buffer[0] & 0x2)
> +			if (sense_buffer[0] & 0x2) {
>  				sense_key = sense_buffer[1] & 0xf;
> -			else
> +				if (hdr->sb_len_wr > 3)
> +					asc = sense_buffer[2];
> +				if (hdr->sb_len_wr > 4)
> +					ascq = sense_buffer[3];
> +			} else {
>  				sense_key = sense_buffer[2] & 0xf;
> +				if (hdr->sb_len_wr > 13)
> +					asc = sense_buffer[12];
> +				if (hdr->sb_len_wr > 14)
> +					ascq = sense_buffer[13];
> +			}
>  
>  			if (sense_key == RECOVERED_ERROR)
> -				return 0;
> +				return SCSI_GOOD;
>  		}
>  	}
>  
> -	return 1;
> +	PRINT_DEBUG("alua: SCSI error for command %02x: status %02x, sense %02x/%02x/%02x",
> +		    opcode, hdr->status, sense_key, asc, ascq);
> +
> +	if (sense_key == UNIT_ATTENTION || sense_key == NOT_READY)
> +		return SCSI_RETRY;
> +	else
> +		return SCSI_ERROR;
>  }
>  
>  /*
> @@ -116,7 +141,9 @@ do_inquiry(int fd, int evpd, unsigned int codepage,
>  	struct inquiry_command	cmd;
>  	struct sg_io_hdr	hdr;
>  	unsigned char		sense[SENSE_BUFF_LEN];
> +	int rc, retry_count = 3;
>  
> +retry:
>  	memset(&cmd, 0, sizeof(cmd));
>  	cmd.op = OPERATION_CODE_INQUIRY;
>  	if (evpd) {
> @@ -142,9 +169,15 @@ do_inquiry(int fd, int evpd, unsigned int codepage,
>  		return -RTPG_INQUIRY_FAILED;
>  	}
>  
> -	if (scsi_error(&hdr)) {
> +	rc = scsi_error(&hdr, OPERATION_CODE_INQUIRY);
> +	if (rc == SCSI_ERROR) {
>  		PRINT_DEBUG("do_inquiry: SCSI error!");
>  		return -RTPG_INQUIRY_FAILED;
> +	} else if (rc == SCSI_RETRY) {
> +		if (--retry_count >= 0)
> +			goto retry;
> +		PRINT_DEBUG("do_inquiry: retries exhausted!");
> +		return -RTPG_INQUIRY_FAILED;
>  	}
>  	PRINT_HEX((unsigned char *) resp, resplen);
>  
> @@ -265,7 +298,9 @@ do_rtpg(int fd, void* resp, long resplen, unsigned int timeout)
>  	struct rtpg_command	cmd;
>  	struct sg_io_hdr	hdr;
>  	unsigned char		sense[SENSE_BUFF_LEN];
> +	int retry_count = 3, rc;
>  
> +retry:
>  	memset(&cmd, 0, sizeof(cmd));
>  	cmd.op			= OPERATION_CODE_RTPG;
>  	rtpg_command_set_service_action(&cmd);
> @@ -286,9 +321,15 @@ do_rtpg(int fd, void* resp, long resplen, unsigned int timeout)
>  	if (ioctl(fd, SG_IO, &hdr) < 0)
>  		return -RTPG_RTPG_FAILED;
>  
> -	if (scsi_error(&hdr)) {
> +	rc = scsi_error(&hdr, OPERATION_CODE_RTPG);
> +	if (rc == SCSI_ERROR) {
>  		PRINT_DEBUG("do_rtpg: SCSI error!");
>  		return -RTPG_RTPG_FAILED;
> +	} else if (rc == SCSI_RETRY) {
> +		if (--retry_count >= 0)
> +			goto retry;
> +		PRINT_DEBUG("do_rtpg: retries exhausted!");
> +		return -RTPG_RTPG_FAILED;
>  	}
>  	PRINT_HEX(resp, resplen);
>  
> -- 
> 2.17.1
