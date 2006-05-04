From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH] pp_aula/spc.h
Date: Thu, 4 May 2006 16:56:45 +0200
Message-ID: <20060504145645.GA2379@pundit>
References: <4457DDE2.6050607@us.xyratex.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4457DDE2.6050607@us.xyratex.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: stefan.bader@de.ibm.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, May 02, 2006 at 03:32:02PM -0700, Tom Kalus wrote:
> path_priority/pp_aula/spc.h
> 
> Isn't the inquiry_data.product_identifier 16 bytes long? or do I need a 
> later draft of SPC3... 21d - Feb 2005
> Bug doesn't effect existing code, but it's still a bug.
> Rest looks ok, so far as I can tell.
> 
> See attached patch.
> 
> 

> diff --git a/path_priority/pp_alua/spc3.h b/path_priority/pp_alua/spc3.h
> index 11f5dbd..bddbbdd 100644
> --- a/path_priority/pp_alua/spc3.h
> +++ b/path_priority/pp_alua/spc3.h
> @@ -148,10 +148,10 @@ struct inquiry_data {
>  					/* ......x. = command queue support  */
>  					/* .......x = vs2                    */
>  	unsigned char	vendor_identification[8];
> -	unsigned char	product_identification[8];
> +	unsigned char	product_identification[16];
>  	unsigned char	product_revision[4];
>  	unsigned char	vendor_specific[20];
> -	unsigned char	b48;		/* xxxx.... = reserved               */
> +	unsigned char	b56;		/* xxxx.... = reserved               */
>  					/* ....xx.. = clocking               */
>  					/* ......x. = qas                    */
>  					/* .......x = ius                    */

Stefan,

Can you you ack this one ?

Regards,
cvaroqui
