From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: Re: [PATCH] multipath-tools: service mode changes for
	RDACstorage
Date: Thu, 11 Aug 2011 01:19:17 -0400
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD90F0E000D@RTPMVEXC1-PRD.hq.netapp.com>
References: <47D23AD8469A2B448F33C24BD7A39BD90EC1660B@RTPMVEXC1-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <47D23AD8469A2B448F33C24BD7A39BD90EC1660B@RTPMVEXC1-PRD.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Christophe,
  Do you have any comments on this? If not can you please merge this..
Thanks
Babu

> -----Original Message-----
> From: Moger, Babu
> Sent: Monday, July 25, 2011 7:05 AM
> To: device-mapper development
> Cc: Kumar, Vijay; Dachepalli, Sudhir; Krishnasamy, Somasundaram; Qi,
> Yanling; Stankey, Robert
> Subject: [dm-devel] [PATCH] multipath-tools: service mode changes for
> RDACstorage
> 
> This patch handles the recent changes in NetApp RDAC storage firmware to
> report service mode. Firmware changed the inquiry page 0xc9 to report
> service mode. Purpose this change is to avoid DMMP going into infinite
> loop of switching back and forth between controllers when a controller
> is placed in service mode. This fixes the problem and reports the path
> as failed if the controller is placed in service mode.
> 
> Signed-off-by: Babu Moger <babu.moger@netapp.com>
> Reviewed-by: Yanling Qi <yanling.qi@netapp.com>
> Reviewed-by: Somasundaram Krishnasamy
> <Somasundaram.Krishnasamy@netapp.com>
> 
> ---
> --- multipath-tools-0.4.8/libmultipath/checkers/rdac.c.orig	2011-07-06
> 16:37:43.000000000 -0500
> +++ multipath-tools-0.4.8/libmultipath/checkers/rdac.c	2011-07-25
> 06:38:03.000000000 -0500
> @@ -198,7 +198,10 @@ struct volume_access_inq
>  	char PQ_PDT;
>  	char dontcare0[7];
>  	char avtcvp;
> -	char dontcare1[39];
> +	char dontcare1;
> +	char asym_access_state_cur;
> +	char vendor_specific_cur;
> +	char dontcare2[36];
>  };
> 
>  extern int
> @@ -216,6 +219,14 @@ libcheck_check (struct checker * c)
>  		ret = PATH_DOWN;
>  		goto done;
>  	}
> +
> +	/* check if controller is in service mode */
> +	if ((inq.avtcvp & 0x10) &&
> +	    ((inq.asym_access_state_cur & 0x0F) == 0x3) &&
> +	    (inq.vendor_specific_cur == 0x7)) {
> +		ret = PATH_DOWN;
> +		goto done;
> +	}
> 
>  	/* If owner set or ioship mode is enabled return PATH_UP always */
>  	if ((inq.avtcvp & 0x1) || ((inq.avtcvp >> 5) & 0x1))
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
