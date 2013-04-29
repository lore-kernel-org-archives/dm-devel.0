From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH 1/2] [multipath-tools] Fix failback parameter
 parsing in conf
Date: Mon, 29 Apr 2013 22:51:35 +0200
Message-ID: <1367268695.4377.4.camel@lapoo.opensvc.com>
References: <8255ED565A0EAA4A960625E27D49DBF21FFB6B71@SACEXCMBX04-PRD.hq.netapp.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8255ED565A0EAA4A960625E27D49DBF21FFB6B71@SACEXCMBX04-PRD.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Stewart, Sean" <Sean.Stewart@netapp.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On mar., 2013-04-23 at 21:21 +0000, Stewart, Sean wrote:
> This patch fixes a problem introduced in this commit: http://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=commitdiff;h=cef43b6f910f740c0e2d38761f58c5ebedfb7585;hp=41b85341ca514a50d18c592996a2ecb43a81fa90
> Currently, the string handler for failback on hw entries expects strings like "manual" to be quoted.  The buffer always strips quotes.
> As a result, the keywords manual, immediate, and followover cannot be used to change a failback parameter through multipath.conf
> 
I applied this sequence,

though I had to use 'git am --ignore-whitespace' and fix the introduced
8-whitespace tabs in a follow-up patch. May be you should check your
development environment for the cause.

Thanks anyway,
Christophe Varoqui
www.opensvc.com


> Signed-off-by: Sean Stewart <Sean.Stewart@netapp.com>
> 
> ---
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index a54dda9..5154cdd 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -1108,11 +1108,11 @@ hw_failback_handler(vector strvec)
> 
>         buff = set_value(strvec);
> 
> -       if (strlen(buff) == 6 && !strcmp(buff, "\"manual\""))
> +       if (strlen(buff) == 6 && !strcmp(buff, "manual"))
>                 hwe->pgfailback = -FAILBACK_MANUAL;
> -       else if (strlen(buff) == 9 && !strcmp(buff, "\"immediate\""))
> +       else if (strlen(buff) == 9 && !strcmp(buff, "immediate"))
>                 hwe->pgfailback = -FAILBACK_IMMEDIATE;
> -       else if (strlen(buff) == 10 && !strcmp(buff, "\"followover\""))
> +       else if (strlen(buff) == 10 && !strcmp(buff, "followover"))
>                 hwe->pgfailback = -FAILBACK_FOLLOWOVER;
>         else
>                 hwe->pgfailback = atoi(buff);
> --
