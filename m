From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: RDAC path checker status change messages
Date: Wed, 24 Jun 2009 11:15:21 -0700
Message-ID: <1245867321.26915.13.camel@chandra-ubuntu>
References: <Pine.LNX.4.64.0906231548060.18687@e-smith.charlieb.ott.istop.com>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0906231548060.18687@e-smith.charlieb.ott.istop.com>
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

Hi Charlie,

We do not want to print these messages as they will be flooding
your /var/log/messages even when everything is good.

We want to print these messages only to get User's attention.

If your concern is that the last message is "down", then we should be
having a static variable and print up or ghost message only once (when
we toggle from down to up/ghost).

chandra
On Tue, 2009-06-23 at 15:50 -0400, Charlie Brady wrote:
> It seems to me that this patch is required, to fix a problem with "path 
> down" messages being logged when the path transitions to up (and 
> presumably ghost).
> 
> --- libcheckers/rdac.c.orig     2009-06-23 15:38:05.371422000 -0400
> +++ libcheckers/rdac.c  2009-06-23 15:39:28.020843000 -0400
> @@ -105,5 +105,12 @@
>                  return PATH_DOWN;
>          }
> 
> -       return ((inq.avtcvp & 0x1) ? PATH_UP : PATH_GHOST);
> +       if (inq.avtcvp & 0x1) {
> +               MSG(c, MSG_RDAC_UP);
> +               return PATH_UP;
> +       }
> +       else {
> +               MSG(c, MSG_RDAC_GHOST);
> +               return PATH_GHOST;
> +       }
>   }
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
