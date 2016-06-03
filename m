From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipathd: update defaults
Date: Fri, 3 Jun 2016 09:27:22 +0200
Message-ID: <CABr-GnfvyPvp-TtcZtvdL2LN6WvrFEQgUtqryDECecJtquVSGA@mail.gmail.com>
References: <1464938072-2885-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5603333194270591284=="
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============5603333194270591284==
Content-Type: multipart/alternative; boundary=001a114125585cef7d05345aa711

--001a114125585cef7d05345aa711
Content-Type: text/plain; charset=UTF-8

Agreed.
Waiting for Ben's ack before merging.

On Fri, Jun 3, 2016 at 9:14 AM, Hannes Reinecke <hare@suse.de> wrote:

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
>  #define ASYNC_TIMEOUT_SEC      30
>
> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> index 96f5a2c..4948271 100644
> --- a/libmultipath/defaults.h
> +++ b/libmultipath/defaults.h
> @@ -16,8 +16,8 @@
>  #define DEFAULT_FIND_MULTIPATHS        0
>  #define DEFAULT_FAST_IO_FAIL   5
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
> @@ -295,7 +295,7 @@ Check the path state for LSI/Engenio/NetApp E-Series
> RDAC storage controller.
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
>

--001a114125585cef7d05345aa711
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Agreed.<div>Waiting for Ben&#39;s ack before merging.</div=
></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Fri, Ju=
n 3, 2016 at 9:14 AM, Hannes Reinecke <span dir=3D"ltr">&lt;<a href=3D"mail=
to:hare@suse.de" target=3D"_blank">hare@suse.de</a>&gt;</span> wrote:<br><b=
lockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px =
#ccc solid;padding-left:1ex">For years I&#39;ve been telling our customers =
to use the &#39;tur&#39; checker<br>
as the current default &#39;directio&#39; will cause spurious path failures=
<br>
under high load.<br>
<br>
And for several versions (years, even) the linux kernel has the ability<br>
to correctly detect the device handler, so we should be making<br>
&#39;retain_hw_handler&#39; the default.<br>
And if we do this we also want to enable &#39;detect_prio&#39;, to ensure<b=
r>
we pick the correct prioritizer.<br>
<br>
So this patch updates the default setting to always enable<br>
&#39;retain_hw_handler&#39; and &#39;detect_prio&#39; and switch to &#39;tu=
r&#39;<br>
as the default path checker.<br>
<br>
Signed-off-by: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.de">hare@sus=
e.de</a>&gt;<br>
---<br>
=C2=A0libmultipath/checkers.h=C2=A0 =C2=A0 | 2 +-<br>
=C2=A0libmultipath/defaults.h=C2=A0 =C2=A0 | 4 ++--<br>
=C2=A0multipath/multipath.conf.5 | 4 ++--<br>
=C2=A03 files changed, 5 insertions(+), 5 deletions(-)<br>
<br>
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h<br>
index a935b3f..374c826 100644<br>
--- a/libmultipath/checkers.h<br>
+++ b/libmultipath/checkers.h<br>
@@ -85,7 +85,7 @@ enum path_check_state {<br>
=C2=A0#define READSECTOR0=C2=A0 &quot;readsector0&quot;<br>
=C2=A0#define CCISS_TUR=C2=A0 =C2=A0 &quot;cciss_tur&quot;<br>
<br>
-#define DEFAULT_CHECKER DIRECTIO<br>
+#define DEFAULT_CHECKER TUR<br>
<br>
=C2=A0#define ASYNC_TIMEOUT_SEC=C2=A0 =C2=A0 =C2=A0 30<br>
<br>
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h<br>
index 96f5a2c..4948271 100644<br>
--- a/libmultipath/defaults.h<br>
+++ b/libmultipath/defaults.h<br>
@@ -16,8 +16,8 @@<br>
=C2=A0#define DEFAULT_FIND_MULTIPATHS=C2=A0 =C2=A0 =C2=A0 =C2=A0 0<br>
=C2=A0#define DEFAULT_FAST_IO_FAIL=C2=A0 =C2=A05<br>
=C2=A0#define DEFAULT_DEV_LOSS_TMO=C2=A0 =C2=A0600<br>
-#define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_OFF<br>
-#define DEFAULT_DETECT_PRIO DETECT_PRIO_OFF<br>
+#define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_ON<br>
+#define DEFAULT_DETECT_PRIO DETECT_PRIO_ON<br>
=C2=A0#define DEFAULT_DEFERRED_REMOVE DEFERRED_REMOVE_OFF<br>
=C2=A0#define DEFAULT_DELAY_CHECKS DELAY_CHECKS_OFF<br>
=C2=A0#define DEFAULT_UEVENT_STACKSIZE 256<br>
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5<br>
index aaaa01b..20a2304 100644<br>
--- a/multipath/multipath.conf.5<br>
+++ b/multipath/multipath.conf.5<br>
@@ -295,7 +295,7 @@ Check the path state for LSI/Engenio/NetApp E-Series RD=
AC storage controller.<br>
=C2=A0.B directio<br>
=C2=A0Read the first sector with direct I/O.<br>
=C2=A0.TP<br>
-Default value is \fIdirectio\fR.<br>
+Default value is \fItur\fR.<br>
=C2=A0.RE<br>
=C2=A0.TP<br>
=C2=A0.B failback<br>
@@ -463,7 +463,7 @@ are supported, or the<br>
=C2=A0prioritizer if not. If set to<br>
=C2=A0.I no<br>
=C2=A0, the prioritizer will be selected as usual. Default is<br>
-.I no<br>
+.I yes<br>
=C2=A0.TP<br>
=C2=A0.B force_sync<br>
=C2=A0If set to<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.6.6<br>
<br>
</font></span></blockquote></div><br></div>

--001a114125585cef7d05345aa711--


--===============5603333194270591284==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5603333194270591284==--
