From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] multipath: another manpage update
Date: Sat, 11 Feb 2012 09:43:55 +0100
Message-ID: <1328949835.2617.7.camel@lapoo.opensvc.com>
References: <20120210181838.GR1241@ether.msp.redhat.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120210181838.GR1241@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On ven., 2012-02-10 at 12:18 -0600, Benjamin Marzinski wrote:
> Missed an option with my last manpage update.
> 
This 6 parts patchset is merged.

Thanks.
 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/multipath.conf.5 |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: multipath-tools-120123/multipath/multipath.conf.5
> ===================================================================
> --- multipath-tools-120123.orig/multipath/multipath.conf.5
> +++ multipath-tools-120123/multipath/multipath.conf.5
> @@ -333,7 +333,9 @@ will disable the timeout.
>  .TP
>  .B dev_loss_tmo
>  Specify the number of seconds the scsi layer will wait after a problem has
> -been detected on a FC remote port before removing it from the system.
> +been detected on a FC remote port before removing it from the system. This
> +can be set to "infinity" which sets it to the max value of 2147483647
> +seconds, or 68 years.
>  .TP
>  .B queue_without_daemon
>  If set to
