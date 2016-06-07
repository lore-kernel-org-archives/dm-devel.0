From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] multipathd: update defaults
Date: Tue, 7 Jun 2016 15:48:22 -0500
Message-ID: <20160607204822.GA8095@octiron.msp.redhat.com>
References: <1464938072-2885-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1464938072-2885-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Fri, Jun 03, 2016 at 09:14:32AM +0200, Hannes Reinecke wrote:
> For years I've been telling our customers to use the 'tur' checker
> as the current default 'directio' will cause spurious path failures
> under high load.
> 
> And for several versions (years, even) the linux kernel has the ability
> to correctly detect the device handler, so we should be making
> 'retain_hw_handler' the default.
> And if we do this we also want to enable 'detect_prio', to ensure
> we pick the correct prioritizer.
> 
> So this patch updates the default setting to always enable
> 'retain_hw_handler' and 'detect_prio' and switch to 'tur'
> as the default path checker.

ACK

-Ben

> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  libmultipath/checkers.h    | 2 +-
>  libmultipath/defaults.h    | 4 ++--
>  multipath/multipath.conf.5 | 4 ++--
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
> index a935b3f..374c826 100644
> --- a/libmultipath/checkers.h
> +++ b/libmultipath/checkers.h
> @@ -85,7 +85,7 @@ enum path_check_state {
>  #define READSECTOR0  "readsector0"
>  #define CCISS_TUR    "cciss_tur"
>  
> -#define DEFAULT_CHECKER DIRECTIO
> +#define DEFAULT_CHECKER TUR
>  
>  #define ASYNC_TIMEOUT_SEC	30
>  
> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> index 96f5a2c..4948271 100644
> --- a/libmultipath/defaults.h
> +++ b/libmultipath/defaults.h
> @@ -16,8 +16,8 @@
>  #define DEFAULT_FIND_MULTIPATHS	0
>  #define DEFAULT_FAST_IO_FAIL	5
>  #define DEFAULT_DEV_LOSS_TMO   600
> -#define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_OFF
> -#define DEFAULT_DETECT_PRIO DETECT_PRIO_OFF
> +#define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_ON
> +#define DEFAULT_DETECT_PRIO DETECT_PRIO_ON
>  #define DEFAULT_DEFERRED_REMOVE DEFERRED_REMOVE_OFF
>  #define DEFAULT_DELAY_CHECKS DELAY_CHECKS_OFF
>  #define DEFAULT_UEVENT_STACKSIZE 256
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index aaaa01b..20a2304 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -295,7 +295,7 @@ Check the path state for LSI/Engenio/NetApp E-Series RDAC storage controller.
>  .B directio
>  Read the first sector with direct I/O.
>  .TP
> -Default value is \fIdirectio\fR.
> +Default value is \fItur\fR.
>  .RE
>  .TP
>  .B failback
> @@ -463,7 +463,7 @@ are supported, or the
>  prioritizer if not. If set to
>  .I no
>  , the prioritizer will be selected as usual. Default is
> -.I no
> +.I yes
>  .TP
>  .B force_sync
>  If set to
> -- 
> 2.6.6
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
