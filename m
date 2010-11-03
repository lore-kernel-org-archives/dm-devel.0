From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: RDAC path checker status change messages
Date: Wed, 3 Nov 2010 17:09:18 -0400
Message-ID: <20101103210918.GB26473@redhat.com>
References: <Pine.LNX.4.64.0906231548060.18687@e-smith.charlieb.ott.istop.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906231548060.18687@e-smith.charlieb.ott.istop.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

This patch still seems relevant to upstream multipath-tools and is
available in dm-devel's patchwork here:
https://patchwork.kernel.org/patch/32081/

On Tue, Jun 23 2009 at  3:50pm -0400,
Charlie Brady <charlieb-dm-devel@budge.apana.org.au> wrote:

> 
> It seems to me that this patch is required, to fix a problem with
> "path down" messages being logged when the path transitions to up
> (and presumably ghost).
> 
> --- libcheckers/rdac.c.orig     2009-06-23 15:38:05.371422000 -0400
> +++ libcheckers/rdac.c  2009-06-23 15:39:28.020843000 -0400
> @@ -105,5 +105,12 @@
>                 return PATH_DOWN;
>         }
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
>  }
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
