From: Mike Christie <mchristi@redhat.com>
Subject: Re: Patch to lsi rda  device handler
Date: Thu, 17 Jul 2008 16:46:54 -0500
Message-ID: <487FBDCE.4080407@redhat.com>
References: <00FE57DD11E3A94893D5BD54C3358BE884BE1F@AUSX3MPC128.aus.amer.dell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <00FE57DD11E3A94893D5BD54C3358BE884BE1F@AUSX3MPC128.aus.amer.dell.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Yanqing_Liu@Dell.com
Cc: Ahmad_Ali@Dell.com, Shyam_Iyer@Dell.com, dm-devel@redhat.com, Charles_Rose@Dell.com, Jacob_Cherian@Dell.com
List-Id: dm-devel.ids

Yanqing_Liu@Dell.com wrote:
> Hello,
> 
> Here is the lsi rdac device handler code that was posted:
> 
> https://www.redhat.com/archives/dm-devel/2008-May/msg00003.html
> 
> The following patch is to address a NULL pointer problem in lsi rdac
> device handler.
> 
> In function get_rdac_req, after a request is successfully allocated, the
> area that the cmd pointer points to should be zeroed out. However, the
> function zeros out the command pointer itself, along with some other
> adjacent area. This results in NULL pointer dereference when submitting
> inquiry commands when checking virtual disk ownership during device
> discovery time. The kernel trace is attached at the end of the message.
> 
> The change is to zero out the area that the cmd pointer points to,
> instead of the pointer itself in the allocated request structure.
> 
> --- scsi_dh_rdac.c.orig	2008-07-17 01:53:10.000000000 -0400
> +++ scsi_dh_rdac.c	2008-07-17 01:45:28.000000000 -0400
> @@ -214,7 +214,7 @@
>  		return NULL;
>  	}
>  
> -	memset(&rq->cmd, 0, BLK_MAX_CDB);
> +	memset(rq->cmd, 0, BLK_MAX_CDB);
>  	rq->sense = h->sense;
>  	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
>  	rq->sense_len = 0;

Nice catch. Thanks. I guess we need to buy a book on programming in C :) 
Not sure how scsi_dh_hp_sw did it right, but the others goofed and we 
did not catch it.

You should send your writeup and patch to the linux-scsi list, so that 
it can be included in the next batch of patches for 2.6.27. You should 
also fix up scsi_dh_emc.c. Send it all in one big patch.
