From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH]multipath-tools: Implementation for hex
 output (-H) for mpathpersist
Date: Wed, 07 Mar 2012 22:32:43 +0100
Message-ID: <1331155963.19673.25.camel@lapoo.opensvc.com>
References: <F200AD42A082BC4088B232D13A916A8901C8CD@SACEXCMBX02-PRD.hq.netapp.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <F200AD42A082BC4088B232D13A916A8901C8CD@SACEXCMBX02-PRD.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On mar., 2012-03-06 at 15:10 +0000, Chauhan, Vijay wrote:
> Adding missing implementation for hex output(-H).
> 
Applied.

> Signed-off-by: Vijay Chauhan <vijay.chauhan@netapp.com>
> 
> ---
> diff -uprN multipath-tools.orig/mpathpersist/main.c multipath-tools/mpathpersist/main.c
> --- multipath-tools.orig/mpathpersist/main.c	2012-03-04 02:16:55.000000000 -0500
> +++ multipath-tools/mpathpersist/main.c	2012-03-05 01:23:07.000000000 -0500
> @@ -260,7 +260,7 @@ int main (int argc, char * argv[])
>  	}
>  
>  	/* set verbosity */
> -	noisy = (loglevel >= 3) ? 1: 0;
> +	noisy = (loglevel >= 3) ? 1 : hex;
>  	verbose	= (loglevel >= 3)? 3: loglevel;
>  
>  	if ((prout_flag + prin_flag) == 0)
> --
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
