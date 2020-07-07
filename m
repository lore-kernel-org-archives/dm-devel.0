From: Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: Re: [PATCH] multipath-tools: add info to man page for
	the historical-service-time path selector
Date: Tue, 07 Jul 2020 17:44:01 -0400
Message-ID: <877dvfm25a.fsf@collabora.com>
References: <20200707211758.12528-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200707211758.12528-1-xose.vazquez@gmail.com> (Xose Vazquez
	Perez's message of "Tue, 7 Jul 2020 23:17:58 +0200")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>, Khazhismel Kumykov <khazhy@google.com>
List-Id: dm-devel.ids

Xose Vazquez Perez <xose.vazquez@gmail.com> writes:

> Cc: Khazhismel Kumykov <khazhy@google.com>
> Cc: Gabriel Krisman Bertazi <krisman@collabora.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  multipath/multipath.conf.5 | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 05a5e8ff..6e637769 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -205,6 +205,10 @@ of outstanding I/O to the path.
>  (Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on the amount
>  of outstanding I/O to the path and its relative throughput.
>  .TP
> +.I "historical-service-time 0"
> +(Since 5.8 kernel) Choose the path for the next bunch of I/O based on the shortest
> +time by comparing estimated service time (based on historical service
> time).
Hi,

Thanks for doing this.

What about:

Choose the path for the next bunch of IOs through an estimation of
future service time based on the history of previous I/O submitted to
each path, in an attempt to maximize throughput.  A path's service-time
is loosely defined as the time between an IO start and its completion
and is updated through an exponential moving average (EMA) of the
historical service time of each path.

> +.TP
>  The default is: \fBservice-time 0\fR

It supports some parameters, shouldn't they be documented here?  Some
explanation for the parameters exists in hst_create() in the kernel

 /*
  * Arguments: [<base_weight> [<threshold_multiplier>]]
  *   <base_weight>: Base weight for ema [0, 1024) 10-bit fixed point. A
  *                  value of 0 will completely ignore any history.
  *                  If not given, default (HST_FIXED_95) is used.
  *   <threshold_multiplier>: Minimum threshold multiplier for paths to
  *                  be considered different. That is, a path is
  *                  considered different iff (p1 > N * p2) where p1
  *                  is the path with higher service time. A threshold
  *                  of 1 or 0 has no effect. Defaults to 0.
  */


>  .RE
>  .

-- 
Gabriel Krisman Bertazi
