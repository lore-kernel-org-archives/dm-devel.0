From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH multipath-tools-0.4.7.rhel5.13 1/1]
	multipathd excessive path checker logging
Date: Fri, 26 Jun 2009 15:50:57 -0500
Message-ID: <20090626205057.GL3172@ether.msp.redhat.com>
References: <Pine.LNX.4.64.0906251344350.4229@e-smith.charlieb.ott.istop.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906251344350.4229@e-smith.charlieb.ott.istop.com>
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

On Thu, Jun 25, 2009 at 01:50:51PM -0400, Charlie Brady wrote:
>
> multipathd logs a path checker message whenever state changes. But it also 
> logs every non-changed message when verbosity is >=4 and newstate is 
> PATH_UP or PATH_GHOST, and every non-changed message when verbosity is >= 2 
> and newstate is PATH_DOWN.
>
> I believe that the message should only be logged, once, when state changes.

I disagree.  If you look at the stuff that gets logged when verbosity >=
4, you'll see that it's a whole bunch of stuff that normal users would
never care about, but may be useful for debugging.  This clearly fits.

I also think that having a path down is something that shouldn't just
blip by once in the logs.  It's something that often requires the
sysadmin to intervene. I could see limitting it to, say, only happen
on every tenth pass through the checker loop, so that these messages
don't clog up the logs so bad. But since there is the option to set the
verbosity to 1 to avoid this, I think that printing the path down
messages repeatedly is useful.

-Ben

>
> Signed-off-by: Charlie Brady <charlieb@budge.apana.org.au>
>
> --- multipath-tools-0.4.7.rhel5.13/multipathd/main.c	2009-06-25 13:32:57.248455000 -0400
> +++ mezzanine_patched_multipath-tools-0.4.7.rhel5.13/multipathd/main.c	2009-06-25 13:32:12.968639000 -0400
> @@ -1041,7 +1041,6 @@
>  					enable_group(pp);
>  			}
>  			else if (newstate == PATH_UP || newstate == PATH_GHOST) {
> -				LOG_MSG(4, checker_message(&pp->checker));
>  				/*
>  				 * double the next check delay.
>  				 * max at conf->max_checkint
> @@ -1055,8 +1054,6 @@
>  				condlog(4, "%s: delay next check %is",
>  						pp->dev_t, pp->tick);
>  			}
> -			else if (newstate == PATH_DOWN)
> -				LOG_MSG(2, checker_message(&pp->checker));
>
>  			pp->state = newstate;
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
