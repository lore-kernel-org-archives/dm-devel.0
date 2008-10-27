From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: [patch]: [multipath-tool] Add check for removed
	device in rdac checker
Date: Mon, 27 Oct 2008 13:01:13 -0400
Message-ID: <20081027170113.GA6167@mars.virtualiron.com>
References: <00FE57DD11E3A94893D5BD54C3358BE884BFA6@AUSX3MPC128.aus.amer.dell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <00FE57DD11E3A94893D5BD54C3358BE884BFA6@AUSX3MPC128.aus.amer.dell.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Oct 27, 2008 at 10:11:28AM -0500, Yanqing_Liu@Dell.com wrote:
> Hi,
> 
> This patch adds a check for removed device in rdac checker. After volume
> access inquiry returns, the checker will check the peripheral qualifier
> field to see if the device is deleted/unmapped. If so, mark path as
> failed.

How does multipathd behaves when this fix is not in? Does
it still mark the path down? I would presume so, but it would take
longer (the default SCSI timeout value?)

> 
> Signed off by: Yanqing Liu <Yanqing_Liu@Dell.com>
> 
> ---
> 
> --- libcheckers/rdac.c.orig	2008-10-22 02:52:33.000000000 -0400
> +++ libcheckers/rdac.c	2008-10-17 03:43:13.000000000 -0400
> @@ -27,6 +27,7 @@
>  #define MSG_RDAC_UP    "rdac checker reports path is up"
>  #define MSG_RDAC_DOWN  "rdac checker reports path is down"
>  #define MSG_RDAC_GHOST "rdac checker reports path is ghost"
> +#define MSG_RDAC_DELETED "rdac checker reports path deleted"
>  
>  struct rdac_checker_context {
>  	void * dummy;
> @@ -90,7 +91,8 @@
>  
>  struct volume_access_inq
>  {
> -	char dontcare0[8];
> +	char qualifier;
> +	char dontcare0[7];
>  	char avtcvp;
>  	char dontcare1[39];
>  };
> @@ -104,6 +106,12 @@
>  		MSG(c, MSG_RDAC_DOWN);
>  		return PATH_DOWN;
>  	}
> +	
> +	if (0 != inq.qualifier) {
> +		MSG(c, MSG_RDAC_DELETED);
> +		return PATH_DOWN;
> +	}
> +		
>  
>  	return ((inq.avtcvp & 0x1) ? PATH_UP : PATH_GHOST);  }
> 
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
