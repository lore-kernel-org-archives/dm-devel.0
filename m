From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 12/12] Add multipath.conf force_sync option
Date: Thu, 24 Jul 2014 10:51:22 +0200
Message-ID: <CABr-Gne0Ksghou4q31oCJ572F9RhLSdd2zkbxhR2QSYOnTt79w@mail.gmail.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
	<1404105243-5071-13-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2696598894879086734=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1404105243-5071-13-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============2696598894879086734==
Content-Type: multipart/alternative; boundary=089e0149d2c0a9fb1c04feec8fc1

--089e0149d2c0a9fb1c04feec8fc1
Content-Type: text/plain; charset=UTF-8

Applied,
Thanks.


On Mon, Jun 30, 2014 at 7:14 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> Normally multipathd runs the path checkers asynchronously. However if there
> are a lot of paths, this can cause large CPU spikes (for instance, in
> cases where they are all competing for the Big Kernel Lock). In these
> situations, overall machine performance is better if multipath doesn't have
> hundreds or even thousands of path checkers running at the same time. This
> patch lets users turn off the asynchronous mode of these checks if they
> see this problem.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/config.c      |  1 +
>  libmultipath/config.h      |  1 +
>  libmultipath/dict.c        | 33 +++++++++++++++++++++++++++++++++
>  libmultipath/discovery.c   |  8 ++++++--
>  multipath.conf.annotated   | 11 +++++++++++
>  multipath/multipath.conf.5 |  9 +++++++++
>  6 files changed, 61 insertions(+), 2 deletions(-)
>
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index e13c307..39963b4 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -561,6 +561,7 @@ load_config (char * file, struct udev *udev)
>         conf->fast_io_fail = DEFAULT_FAST_IO_FAIL;
>         conf->retain_hwhandler = DEFAULT_RETAIN_HWHANDLER;
>         conf->detect_prio = DEFAULT_DETECT_PRIO;
> +       conf->force_sync = 0;
>
>         /*
>          * preload default hwtable
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index ac7c58e..1a23e4b 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -124,6 +124,7 @@ struct config {
>         int reassign_maps;
>         int retain_hwhandler;
>         int detect_prio;
> +       int force_sync;
>         unsigned int version[3];
>
>         char * dev;
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 91d9b83..7de7a67 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -685,6 +685,29 @@ def_detect_prio_handler(vector strvec)
>         return 0;
>  }
>
> +static int
> +def_force_sync_handler(vector strvec)
> +{
> +       char * buff;
> +
> +       buff = set_value(strvec);
> +
> +       if (!buff)
> +               return 1;
> +
> +       if ((strlen(buff) == 2 && !strcmp(buff, "no")) ||
> +           (strlen(buff) == 1 && !strcmp(buff, "0")))
> +               conf->force_sync = 0;
> +       else if ((strlen(buff) == 3 && !strcmp(buff, "yes")) ||
> +                (strlen(buff) == 1 && !strcmp(buff, "1")))
> +               conf->force_sync = 1;
> +       else
> +               conf->force_sync = 0;
> +
> +       FREE(buff);
> +       return 0;
> +}
> +
>  /*
>   * blacklist block handlers
>   */
> @@ -2783,6 +2806,15 @@ snprint_def_detect_prio(char * buff, int len, void
> * data)
>  }
>
>  static int
> +snprint_def_force_sync(char * buff, int len, void * data)
> +{
> +       if (conf->force_sync)
> +               return snprintf(buff, len, "yes");
> +       else
> +               return snprintf(buff, len, "no");
> +}
> +
> +static int
>  snprint_ble_simple (char * buff, int len, void * data)
>  {
>         struct blentry * ble = (struct blentry *)data;
> @@ -2849,6 +2881,7 @@ init_keywords(void)
>         install_keyword("reservation_key", &def_reservation_key_handler,
> &snprint_def_reservation_key);
>         install_keyword("retain_attached_hw_handler",
> &def_retain_hwhandler_handler, &snprint_def_retain_hwhandler_handler);
>         install_keyword("detect_prio", &def_detect_prio_handler,
> &snprint_def_detect_prio);
> +       install_keyword("force_sync", &def_force_sync_handler,
> &snprint_def_force_sync);
>         __deprecated install_keyword("default_selector",
> &def_selector_handler, NULL);
>         __deprecated install_keyword("default_path_grouping_policy",
> &def_pgpolicy_handler, NULL);
>         __deprecated install_keyword("default_uid_attribute",
> &def_uid_attribute_handler, NULL);
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index b62a59c..a5f5a20 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1053,8 +1053,12 @@ get_state (struct path * pp, int daemon)
>                 }
>         }
>         checker_clear_message(c);
> -       if (daemon)
> -               checker_set_async(c);
> +       if (daemon) {
> +               if (conf->force_sync == 0)
> +                       checker_set_async(c);
> +               else
> +                       checker_set_sync(c);
> +       }
>         if (!conf->checker_timeout &&
>             sysfs_get_timeout(pp, &(c->timeout)) <= 0)
>                 c->timeout = DEF_TIMEOUT;
> diff --git a/multipath.conf.annotated b/multipath.conf.annotated
> index f158746..0af1d4c 100644
> --- a/multipath.conf.annotated
> +++ b/multipath.conf.annotated
> @@ -270,6 +270,7 @@
>  #      # default : determined by the OS
>  #      dev_loss_tmo 600
>  #
> +#      #
>  #      # name    : bindings_file
>  #      # scope   : multipath
>  #      # desc    : The location of the bindings file that is used with
> @@ -278,6 +279,7 @@
>  #      # default : "/var/lib/multipath/bindings"
>  #      bindings_file "/etc/multipath/bindings"
>  #
> +#      #
>  #      # name    : wwids_file
>  #      # scope   : multipath
>  #      # desc    : The location of the wwids file multipath uses to
> @@ -286,6 +288,7 @@
>  #      # default : "/var/lib/multipath/wwids"
>  #      wwids_file "/etc/multipath/wwids"
>  #
> +#      #
>  #      # name    : reservation_key
>  #      # scope   : multipath
>  #      # desc    : Service action reservation key used by mpathpersist.
> @@ -293,6 +296,14 @@
>  #      # default : (null)
>  #      reservation_key "mpathkey"
>  #
> +#      #
> +#      # name    : force_sync
> +#      # scope   : multipathd
> +#      # desc    : If set to yes, multipath will run all of the checkers
> in
> +#      #           sync mode, even if the checker has an async mode.
> +#      # values  : yes|no
> +#      # default : no
> +#      force_sync yes
>  #}
>  #
>  ##
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 195e663..cadb34d 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -409,6 +409,15 @@ will automatically use the
>  .I alua
>  prioritizer. If not, the prioritizer will be selected as usual. Default is
>  .I no
> +.TP
> +.B force_sync
> +If set to
> +.I yes
> +, multipathd will call the path checkers in sync mode only.  This means
> that
> +only one checker will run at a time.  This is useful in the case where
> many
> +multipathd checkers running in parallel causes significant CPU pressure.
> The
> +Default is
> +.I no
>  .
>  .SH "blacklist section"
>  The
> --
> 1.8.3.1
>
>

--089e0149d2c0a9fb1c04feec8fc1
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied,<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><br><div class=3D"gmail_quote">On Mon, Jun 30, 2014 at 7:14 AM, Benjam=
in Marzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" t=
arget=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Normally multipathd runs the path checkers a=
synchronously. However if there<br>
are a lot of paths, this can cause large CPU spikes (for instance, in<br>
cases where they are all competing for the Big Kernel Lock). In these<br>
situations, overall machine performance is better if multipath doesn&#39;t =
have<br>
hundreds or even thousands of path checkers running at the same time. This<=
br>
patch lets users turn off the asynchronous mode of these checks if they<br>
see this problem.<br>
<br>
Signed-off-by: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com=
">bmarzins@redhat.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/config.c =C2=A0 =C2=A0 =C2=A0| =C2=A01 +<br>
=C2=A0libmultipath/config.h =C2=A0 =C2=A0 =C2=A0| =C2=A01 +<br>
=C2=A0libmultipath/dict.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| 33 +++++++++++++++++=
++++++++++++++++<br>
=C2=A0libmultipath/discovery.c =C2=A0 | =C2=A08 ++++++--<br>
=C2=A0multipath.conf.annotated =C2=A0 | 11 +++++++++++<br>
=C2=A0multipath/multipath.conf.5 | =C2=A09 +++++++++<br>
=C2=A06 files changed, 61 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/libmultipath/config.c b/libmultipath/config.c<br>
index e13c307..39963b4 100644<br>
--- a/libmultipath/config.c<br>
+++ b/libmultipath/config.c<br>
@@ -561,6 +561,7 @@ load_config (char * file, struct udev *udev)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;fast_io_fail =3D DEFAULT_FAST_IO_FAIL;=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;retain_hwhandler =3D DEFAULT_RETAIN_HW=
HANDLER;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;detect_prio =3D DEFAULT_DETECT_PRIO;<b=
r>
+ =C2=A0 =C2=A0 =C2=A0 conf-&gt;force_sync =3D 0;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* preload default hwtable<br>
diff --git a/libmultipath/config.h b/libmultipath/config.h<br>
index ac7c58e..1a23e4b 100644<br>
--- a/libmultipath/config.h<br>
+++ b/libmultipath/config.h<br>
@@ -124,6 +124,7 @@ struct config {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int reassign_maps;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int retain_hwhandler;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int detect_prio;<br>
+ =C2=A0 =C2=A0 =C2=A0 int force_sync;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int version[3];<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * dev;<br>
diff --git a/libmultipath/dict.c b/libmultipath/dict.c<br>
index 91d9b83..7de7a67 100644<br>
--- a/libmultipath/dict.c<br>
+++ b/libmultipath/dict.c<br>
@@ -685,6 +685,29 @@ def_detect_prio_handler(vector strvec)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
+static int<br>
+def_force_sync_handler(vector strvec)<br>
+{<br>
+ =C2=A0 =C2=A0 =C2=A0 char * buff;<br>
+<br>
+ =C2=A0 =C2=A0 =C2=A0 buff =3D set_value(strvec);<br>
+<br>
+ =C2=A0 =C2=A0 =C2=A0 if (!buff)<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
+<br>
+ =C2=A0 =C2=A0 =C2=A0 if ((strlen(buff) =3D=3D 2 &amp;&amp; !strcmp(buff, =
&quot;no&quot;)) ||<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (strlen(buff) =3D=3D 1 &amp;&amp; !str=
cmp(buff, &quot;0&quot;)))<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;force_sync =3D =
0;<br>
+ =C2=A0 =C2=A0 =C2=A0 else if ((strlen(buff) =3D=3D 3 &amp;&amp; !strcmp(b=
uff, &quot;yes&quot;)) ||<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(strlen(buff) =3D=
=3D 1 &amp;&amp; !strcmp(buff, &quot;1&quot;)))<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;force_sync =3D =
1;<br>
+ =C2=A0 =C2=A0 =C2=A0 else<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;force_sync =3D =
0;<br>
+<br>
+ =C2=A0 =C2=A0 =C2=A0 FREE(buff);<br>
+ =C2=A0 =C2=A0 =C2=A0 return 0;<br>
+}<br>
+<br>
=C2=A0/*<br>
=C2=A0 * blacklist block handlers<br>
=C2=A0 */<br>
@@ -2783,6 +2806,15 @@ snprint_def_detect_prio(char * buff, int len, void *=
 data)<br>
=C2=A0}<br>
<br>
=C2=A0static int<br>
+snprint_def_force_sync(char * buff, int len, void * data)<br>
+{<br>
+ =C2=A0 =C2=A0 =C2=A0 if (conf-&gt;force_sync)<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return snprintf(buff, le=
n, &quot;yes&quot;);<br>
+ =C2=A0 =C2=A0 =C2=A0 else<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return snprintf(buff, le=
n, &quot;no&quot;);<br>
+}<br>
+<br>
+static int<br>
=C2=A0snprint_ble_simple (char * buff, int len, void * data)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct blentry * ble =3D (struct blentry *)data=
;<br>
@@ -2849,6 +2881,7 @@ init_keywords(void)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;reservation_key&quot;, &a=
mp;def_reservation_key_handler, &amp;snprint_def_reservation_key);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;retain_attached_hw_handle=
r&quot;, &amp;def_retain_hwhandler_handler, &amp;snprint_def_retain_hwhandl=
er_handler);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;detect_prio&quot;, &amp;d=
ef_detect_prio_handler, &amp;snprint_def_detect_prio);<br>
+ =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;force_sync&quot;, &amp;def_for=
ce_sync_handler, &amp;snprint_def_force_sync);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 __deprecated install_keyword(&quot;default_sele=
ctor&quot;, &amp;def_selector_handler, NULL);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 __deprecated install_keyword(&quot;default_path=
_grouping_policy&quot;, &amp;def_pgpolicy_handler, NULL);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 __deprecated install_keyword(&quot;default_uid_=
attribute&quot;, &amp;def_uid_attribute_handler, NULL);<br>
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c<br>
index b62a59c..a5f5a20 100644<br>
--- a/libmultipath/discovery.c<br>
+++ b/libmultipath/discovery.c<br>
@@ -1053,8 +1053,12 @@ get_state (struct path * pp, int daemon)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 checker_clear_message(c);<br>
- =C2=A0 =C2=A0 =C2=A0 if (daemon)<br>
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 checker_set_async(c);<br=
>
+ =C2=A0 =C2=A0 =C2=A0 if (daemon) {<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (conf-&gt;force_sync =
=3D=3D 0)<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 checker_set_async(c);<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 checker_set_sync(c);<br>
+ =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!conf-&gt;checker_timeout &amp;&amp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sysfs_get_timeout(pp, &amp;(c-&gt=
;timeout)) &lt;=3D 0)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 c-&gt;timeout =3D D=
EF_TIMEOUT;<br>
diff --git a/multipath.conf.annotated b/multipath.conf.annotated<br>
index f158746..0af1d4c 100644<br>
--- a/multipath.conf.annotated<br>
+++ b/multipath.conf.annotated<br>
@@ -270,6 +270,7 @@<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0# default : determined by the OS<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0dev_loss_tmo 600<br>
=C2=A0#<br>
+# =C2=A0 =C2=A0 =C2=A0#<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0# name =C2=A0 =C2=A0: bindings_file<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0# scope =C2=A0 : multipath<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0# desc =C2=A0 =C2=A0: The location of the bindi=
ngs file that is used with<br>
@@ -278,6 +279,7 @@<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0# default : &quot;/var/lib/multipath/bindings&q=
uot;<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0bindings_file &quot;/etc/multipath/bindings&quo=
t;<br>
=C2=A0#<br>
+# =C2=A0 =C2=A0 =C2=A0#<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0# name =C2=A0 =C2=A0: wwids_file<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0# scope =C2=A0 : multipath<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0# desc =C2=A0 =C2=A0: The location of the wwids=
 file multipath uses to<br>
@@ -286,6 +288,7 @@<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0# default : &quot;/var/lib/multipath/wwids&quot=
;<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0wwids_file &quot;/etc/multipath/wwids&quot;<br>
=C2=A0#<br>
+# =C2=A0 =C2=A0 =C2=A0#<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0# name =C2=A0 =C2=A0: reservation_key<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0# scope =C2=A0 : multipath<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0# desc =C2=A0 =C2=A0: Service action reservatio=
n key used by mpathpersist.<br>
@@ -293,6 +296,14 @@<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0# default : (null)<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0reservation_key &quot;mpathkey&quot;<br>
=C2=A0#<br>
+# =C2=A0 =C2=A0 =C2=A0#<br>
+# =C2=A0 =C2=A0 =C2=A0# name =C2=A0 =C2=A0: force_sync<br>
+# =C2=A0 =C2=A0 =C2=A0# scope =C2=A0 : multipathd<br>
+# =C2=A0 =C2=A0 =C2=A0# desc =C2=A0 =C2=A0: If set to yes, multipath will =
run all of the checkers in<br>
+# =C2=A0 =C2=A0 =C2=A0# =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sync mode, even=
 if the checker has an async mode.<br>
+# =C2=A0 =C2=A0 =C2=A0# values =C2=A0: yes|no<br>
+# =C2=A0 =C2=A0 =C2=A0# default : no<br>
+# =C2=A0 =C2=A0 =C2=A0force_sync yes<br>
=C2=A0#}<br>
=C2=A0#<br>
=C2=A0##<br>
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5<br>
index 195e663..cadb34d 100644<br>
--- a/multipath/multipath.conf.5<br>
+++ b/multipath/multipath.conf.5<br>
@@ -409,6 +409,15 @@ will automatically use the<br>
=C2=A0.I alua<br>
=C2=A0prioritizer. If not, the prioritizer will be selected as usual. Defau=
lt is<br>
=C2=A0.I no<br>
+.TP<br>
+.B force_sync<br>
+If set to<br>
+.I yes<br>
+, multipathd will call the path checkers in sync mode only. =C2=A0This mea=
ns that<br>
+only one checker will run at a time. =C2=A0This is useful in the case wher=
e many<br>
+multipathd checkers running in parallel causes significant CPU pressure. T=
he<br>
+Default is<br>
+.I no<br>
=C2=A0.<br>
=C2=A0.SH &quot;blacklist section&quot;<br>
=C2=A0The<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--089e0149d2c0a9fb1c04feec8fc1--


--===============2696598894879086734==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2696598894879086734==--
