From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2 2/4] libmpathpersist:
 format_transportids(): avoid PROUT overflow
Date: Tue, 17 Mar 2020 14:28:39 -0500
Message-ID: <20200317192838.GW30153@octiron.msp.redhat.com>
References: <20200315210521.12109-1-mwilck@suse.com>
	<20200315210521.12109-3-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200315210521.12109-3-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: mwilck@suse.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Mar 15, 2020 at 10:05:19PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> This limits the PERSISTENT RESERVE OUT data size to max. 8192 bytes.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathpersist/mpath_pr_ioctl.c | 31 +++++++++++++++++++++++++++++--
>  1 file changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
> index 1a28cba7..c78e8000 100644
> --- a/libmpathpersist/mpath_pr_ioctl.c
> +++ b/libmpathpersist/mpath_pr_ioctl.c
> @@ -1,5 +1,6 @@
>  #include <stdio.h>
>  #include <stdlib.h>
> +#include <stddef.h>
>  
>  #include <sys/types.h>
>  #include <sys/stat.h>
> @@ -138,38 +139,64 @@ retry :
>  	return status;
>  }
>  
> +/*
> + * Helper macro to avoid overflow of prout_param_descriptor in
> + * format_transportids(). Data must not be written past
> + * MPATH_MAX_PARAM_LEN bytes from struct prout_param_descriptor.
> + */
> +#define check_overflow(ofs, n, start, label)				\
> +	do {								\
> +		if ((ofs) + (n) +					\
> +		    offsetof(struct prout_param_descriptor, private_buffer) \
> +		    > MPATH_MAX_PARAM_LEN)				\
> +		{							\
> +			(ofs) = (start);				\
> +			goto label;					\
> +		}							\
> +	} while(0)
> +
>  uint32_t  format_transportids(struct prout_param_descriptor *paramp)
>  {
>  	unsigned int i = 0, len;
>  	uint32_t buff_offset = 4;
> -	memset(paramp->private_buffer, 0, MPATH_MAX_PARAM_LEN);
> +	memset(paramp->private_buffer, 0, sizeof(paramp->private_buffer));
>  	for (i=0; i < paramp->num_transportid; i++ )
>  	{
> +		uint32_t start_offset = buff_offset;
> +
> +		check_overflow(buff_offset, 1, start_offset, end_loop);
>  		paramp->private_buffer[buff_offset] = (uint8_t)((paramp->trnptid_list[i]->format_code & 0xff)|
>  							(paramp->trnptid_list[i]->protocol_id & 0xff));
>  		buff_offset += 1;
>  		switch(paramp->trnptid_list[i]->protocol_id)
>  		{
>  			case MPATH_PROTOCOL_ID_FC:
> +				check_overflow(buff_offset, 7 + 8 + 8,
> +					       start_offset, end_loop);
>  				buff_offset += 7;
>  				memcpy(&paramp->private_buffer[buff_offset], &paramp->trnptid_list[i]->n_port_name, 8);
>  				buff_offset +=8 ;
>  				buff_offset +=8 ;
>  				break;
>  			case MPATH_PROTOCOL_ID_SAS:
> +				check_overflow(buff_offset, 3 + 12,
> +					       start_offset, end_loop);
>  				buff_offset += 3;
>  				memcpy(&paramp->private_buffer[buff_offset], &paramp->trnptid_list[i]->sas_address, 8);
>  				buff_offset += 12;
>  				break;
>  			case MPATH_PROTOCOL_ID_ISCSI:
> -				buff_offset += 1;
>  				len = (paramp->trnptid_list[i]->iscsi_name[1] & 0xff)+2;
> +				check_overflow(buff_offset, 1 + len,
> +					       start_offset, end_loop);
> +				buff_offset += 1;
>  				memcpy(&paramp->private_buffer[buff_offset], &paramp->trnptid_list[i]->iscsi_name,len);
>  				buff_offset += len ;
>  				break;
>  		}
>  
>  	}
> +end_loop:
>  	buff_offset -= 4;
>  	paramp->private_buffer[0] = (unsigned char)((buff_offset >> 24) & 0xff);
>  	paramp->private_buffer[1] = (unsigned char)((buff_offset >> 16) & 0xff);
> -- 
> 2.25.1
