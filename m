From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipathd: update defaults
Date: Sun, 5 Jun 2016 20:24:17 +0200
Message-ID: <a230b117-9f8c-b43e-465c-1ea58d4c883a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>, Sebastian Herbszt <herbszt@gmx.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper development <dm-devel@redhat.com>
Cc: matthias.rudolph@hds.com, sramani@pillardata.com, jim.lester@compellent.com, yacine@alyseo.com, g.shyamsundar@yahoo.co.in, sean.stewart@netapp.com, davidw@netapp.com, brking@linux.vnet.ibm.com, bartb@pivot3.com, egoggin@emc.com
List-Id: dm-devel.ids

Hannes Reinecke wrote:

> For years I've been telling our customers to use the 'tur' checker
> as the current default 'directio' will cause spurious path failures
> under high load.

If directio is unreliable, it must be _fixed_ or *removed* .
And this text in multipath.conf.5 needs to be replaced:
"readsector0 (Deprecated) Read the first sector of the device.
This checker is being deprecated, please use directio instead"

There are 11 devices with path_checker=directio as default option,
what to do with them ?

> And for several versions (years, even) the linux kernel has the ability
> to correctly detect the device handler, so we should be making
> 'retain_hw_handler' the default.
> And if we do this we also want to enable 'detect_prio', to ensure
> we pick the correct prioritizer.

I do really like both features, it makes the multipath setup almost
a completely unattended task. And neat for live_cd, installers of
distributions, rescue environments and anywhere with a ro /etc.

There are a handful of devices with prio=alua as default option,
and they should be revoked to their "original" configuration.

> So this patch updates the default setting to always enable
> 'retain_hw_handler' and 'detect_prio' and switch to 'tur'
> as the default path checker.

The patch should be split in two: directio->tur and autodetect_alua.

CCed: All controllers maintainers, let's see what they think.

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
