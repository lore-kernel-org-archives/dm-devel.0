From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 5/6] correctly set partition delimiter on
	rename
Date: Thu, 8 Jan 2015 23:51:49 +0100
Message-ID: <CABr-GndLRU38hanR2KqBR1sYTTY-gOXuU0JvYT03hFvW4Eu2FA@mail.gmail.com>
References: <1416377859-15073-1-git-send-email-bmarzins@redhat.com>
	<1416377859-15073-6-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8476669311875775775=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1416377859-15073-6-git-send-email-bmarzins@redhat.com>
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

--===============8476669311875775775==
Content-Type: multipart/alternative; boundary=089e013d100ea46b94050c2be220

--089e013d100ea46b94050c2be220
Content-Type: text/plain; charset=UTF-8

Ben,

I'm willing to apply this one.
Care to rebase it.

Best regards,
Christophe

On Wed, Nov 19, 2014 at 7:17 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> When multipath renames a device and the name switches from ending in a
> number to ending in a letter or vice versa, it currently just keeps any
> existing delimiter between the device name and partition number.
> However the default behaviour in kpartx is to only use the 'p' delimiter
> when the name ends in a number. Unfortunately, without adding a
> kpartx.conf that kpartx uses to set the delimiter behavior, there's no
> way for multipath to know how kpartx was run for certain device names
> (ones ending in a number with a 'p' delimiter).
>
> The patch adds a new multipath.conf defaults parameter,
> "partition_delimiter". If this value is not set, when multipath renames
> a device, it will act just like the kpartx default does, only adding a
> 'p' to names ending in a number.  If this parameter is set, multipath
> will act like kpartx does with the -p option is used, and always add
> delimiter.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/config.c    |  3 +++
>  libmultipath/config.h    |  1 +
>  libmultipath/devmapper.c | 14 ++++++++++++--
>  libmultipath/dict.c      |  4 ++++
>  4 files changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 3c72b59..701e177 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -502,6 +502,8 @@ free_config (struct config * conf)
>
>         if (conf->alias_prefix)
>                 FREE(conf->alias_prefix);
> +       if (conf->partition_delim)
> +               FREE(conf->partition_delim);
>
>         if (conf->prio_args)
>                 FREE(conf->prio_args);
> @@ -564,6 +566,7 @@ load_config (char * file, struct udev *udev)
>         conf->detect_prio = DEFAULT_DETECT_PRIO;
>         conf->force_sync = 0;
>         conf->find_multipaths = DEFAULT_FIND_MULTIPATHS;
> +       conf->partition_delim = NULL;
>
>         /*
>          * preload default hwtable
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index 801387c..a6205ee 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -141,6 +141,7 @@ struct config {
>         char * prio_args;
>         char * checker_name;
>         char * alias_prefix;
> +       char * partition_delim;
>         unsigned char * reservation_key;
>
>         vector keywords;
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 3d4c111..9e585f9 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -1142,6 +1142,8 @@ dm_rename_partmaps (char * old, char * new)
>         unsigned long long size;
>         char dev_t[32];
>         int r = 1;
> +       int offset;
> +       char *delim;
>
>         if (!(dmt = dm_task_create(DM_DEVICE_LIST)))
>                 return 1;
> @@ -1162,6 +1164,13 @@ dm_rename_partmaps (char * old, char * new)
>         if (dm_dev_t(old, &dev_t[0], 32))
>                 goto out;
>
> +       if (conf->partition_delim)
> +               delim = conf->partition_delim;
> +       if (isdigit(new[strlen(new)-1]))
> +               delim = "p";
> +       else
> +               delim = "";
> +
>         do {
>                 if (
>                     /*
> @@ -1189,8 +1198,9 @@ dm_rename_partmaps (char * old, char * new)
>                                  * then it's a kpartx generated partition.
>                                  * Rename it.
>                                  */
> -                               snprintf(buff, PARAMS_SIZE, "%s%s",
> -                                        new, names->name + strlen(old));
> +                               for (offset = strlen(old);
> names->name[offset] && !(isdigit(names->name[offset])); offset++); /* do
> nothing */
> +                               snprintf(buff, PARAMS_SIZE, "%s%s%s",
> +                                        new, delim, names->name + offset);
>                                 dm_rename(names->name, buff);
>                                 condlog(4, "partition map %s renamed",
>                                         names->name);
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index d1e2e96..f95f30c 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -233,6 +233,9 @@ declare_def_snprint(multipath_dir, print_str)
>  declare_def_handler(find_multipaths, set_yes_no)
>  declare_def_snprint(find_multipaths, print_yes_no)
>
> +declare_def_handler(partition_delim, set_str)
> +declare_def_snprint(partition_delim, print_str)
> +
>  declare_def_handler(selector, set_str)
>  declare_def_snprint_defstr(selector, print_str, DEFAULT_SELECTOR)
>  declare_hw_handler(selector, set_str)
> @@ -1246,6 +1249,7 @@ init_keywords(void)
>         install_keyword("detect_prio", &def_detect_prio_handler,
> &snprint_def_detect_prio);
>         install_keyword("force_sync", &def_force_sync_handler,
> &snprint_def_force_sync);
>         install_keyword("find_multipaths", &def_find_multipaths_handler,
> &snprint_def_find_multipaths);
> +       install_keyword("partition_delimiter",
> &def_partition_delim_handler, &snprint_def_partition_delim);
>         __deprecated install_keyword("default_selector",
> &def_selector_handler, NULL);
>         __deprecated install_keyword("default_path_grouping_policy",
> &def_pgpolicy_handler, NULL);
>         __deprecated install_keyword("default_uid_attribute",
> &def_uid_attribute_handler, NULL);
> --
> 1.8.3.1
>
>

--089e013d100ea46b94050c2be220
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Ben,</div><div><br></div>I&#39;m willing to apply thi=
s one.<div>Care to rebase it.</div><div><br></div><div>Best regards,</div><=
div>Christophe</div></div><div class=3D"gmail_extra"><br><div class=3D"gmai=
l_quote">On Wed, Nov 19, 2014 at 7:17 AM, Benjamin Marzinski <span dir=3D"l=
tr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=3D"_blank">bmarzins@r=
edhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">When mul=
tipath renames a device and the name switches from ending in a<br>
number to ending in a letter or vice versa, it currently just keeps any<br>
existing delimiter between the device name and partition number.<br>
However the default behaviour in kpartx is to only use the &#39;p&#39; deli=
miter<br>
when the name ends in a number. Unfortunately, without adding a<br>
kpartx.conf that kpartx uses to set the delimiter behavior, there&#39;s no<=
br>
way for multipath to know how kpartx was run for certain device names<br>
(ones ending in a number with a &#39;p&#39; delimiter).<br>
<br>
The patch adds a new multipath.conf defaults parameter,<br>
&quot;partition_delimiter&quot;. If this value is not set, when multipath r=
enames<br>
a device, it will act just like the kpartx default does, only adding a<br>
&#39;p&#39; to names ending in a number.=C2=A0 If this parameter is set, mu=
ltipath<br>
will act like kpartx does with the -p option is used, and always add<br>
delimiter.<br>
<br>
Signed-off-by: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com=
">bmarzins@redhat.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/config.c=C2=A0 =C2=A0 |=C2=A0 3 +++<br>
=C2=A0libmultipath/config.h=C2=A0 =C2=A0 |=C2=A0 1 +<br>
=C2=A0libmultipath/devmapper.c | 14 ++++++++++++--<br>
=C2=A0libmultipath/dict.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 4 ++++<br>
=C2=A04 files changed, 20 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/libmultipath/config.c b/libmultipath/config.c<br>
index 3c72b59..701e177 100644<br>
--- a/libmultipath/config.c<br>
+++ b/libmultipath/config.c<br>
@@ -502,6 +502,8 @@ free_config (struct config * conf)<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (conf-&gt;alias_prefix)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FREE(conf-&gt;alias=
_prefix);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (conf-&gt;partition_delim)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FREE(conf-&gt;parti=
tion_delim);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (conf-&gt;prio_args)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FREE(conf-&gt;prio_=
args);<br>
@@ -564,6 +566,7 @@ load_config (char * file, struct udev *udev)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;detect_prio =3D DEFAULT_DETECT_PRIO;<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;force_sync =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;find_multipaths =3D DEFAULT_FIND_MULTI=
PATHS;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0conf-&gt;partition_delim =3D NULL;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* preload default hwtable<br>
diff --git a/libmultipath/config.h b/libmultipath/config.h<br>
index 801387c..a6205ee 100644<br>
--- a/libmultipath/config.h<br>
+++ b/libmultipath/config.h<br>
@@ -141,6 +141,7 @@ struct config {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * prio_args;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * checker_name;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * alias_prefix;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0char * partition_delim;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned char * reservation_key;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 vector keywords;<br>
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c<br>
index 3d4c111..9e585f9 100644<br>
--- a/libmultipath/devmapper.c<br>
+++ b/libmultipath/devmapper.c<br>
@@ -1142,6 +1142,8 @@ dm_rename_partmaps (char * old, char * new)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned long long size;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char dev_t[32];<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D 1;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int offset;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0char *delim;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!(dmt =3D dm_task_create(DM_DEVICE_LIST)))<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
@@ -1162,6 +1164,13 @@ dm_rename_partmaps (char * old, char * new)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (dm_dev_t(old, &amp;dev_t[0], 32))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (conf-&gt;partition_delim)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0delim =3D conf-&gt;=
partition_delim;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (isdigit(new[strlen(new)-1]))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0delim =3D &quot;p&q=
uot;;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0else<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0delim =3D &quot;&qu=
ot;;<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 do {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br=
>
@@ -1189,8 +1198,9 @@ dm_rename_partmaps (char * old, char * new)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* then it&#39;s a kpartx gener=
ated partition.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Rename it.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0snprintf(buff, PARAMS_SIZE, &quot;%s%=
s&quot;,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 new, nam=
es-&gt;name + strlen(old));<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (offset =3D strlen(old); names-&g=
t;name[offset] &amp;&amp; !(isdigit(names-&gt;name[offset])); offset++); /*=
 do nothing */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0snprintf(buff, PARAMS_SIZE, &quot;%s%=
s%s&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 new, del=
im, names-&gt;name + offset);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dm_rename(names-&gt;name, buff);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(4, &quot;partition map %s re=
named&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 names-&g=
t;name);<br>
diff --git a/libmultipath/dict.c b/libmultipath/dict.c<br>
index d1e2e96..f95f30c 100644<br>
--- a/libmultipath/dict.c<br>
+++ b/libmultipath/dict.c<br>
@@ -233,6 +233,9 @@ declare_def_snprint(multipath_dir, print_str)<br>
=C2=A0declare_def_handler(find_multipaths, set_yes_no)<br>
=C2=A0declare_def_snprint(find_multipaths, print_yes_no)<br>
<br>
+declare_def_handler(partition_delim, set_str)<br>
+declare_def_snprint(partition_delim, print_str)<br>
+<br>
=C2=A0declare_def_handler(selector, set_str)<br>
=C2=A0declare_def_snprint_defstr(selector, print_str, DEFAULT_SELECTOR)<br>
=C2=A0declare_hw_handler(selector, set_str)<br>
@@ -1246,6 +1249,7 @@ init_keywords(void)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;detect_prio&quot;, &amp;d=
ef_detect_prio_handler, &amp;snprint_def_detect_prio);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;force_sync&quot;, &amp;de=
f_force_sync_handler, &amp;snprint_def_force_sync);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;find_multipaths&quot;, &a=
mp;def_find_multipaths_handler, &amp;snprint_def_find_multipaths);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;partition_delimiter&quot;=
, &amp;def_partition_delim_handler, &amp;snprint_def_partition_delim);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 __deprecated install_keyword(&quot;default_sele=
ctor&quot;, &amp;def_selector_handler, NULL);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 __deprecated install_keyword(&quot;default_path=
_grouping_policy&quot;, &amp;def_pgpolicy_handler, NULL);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 __deprecated install_keyword(&quot;default_uid_=
attribute&quot;, &amp;def_uid_attribute_handler, NULL);<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--089e013d100ea46b94050c2be220--


--===============8476669311875775775==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8476669311875775775==--
