From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: Remove trailing whitespaces
Date: Thu, 23 Mar 2017 09:31:29 +0100
Message-ID: <CABr-Gne1hX44eHds0Cw3z2EQ+sqcNqxkz0qX7uHn8HWvJ9uSkA@mail.gmail.com>
References: <20170317003503.4166-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6426420703098135253=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170317003503.4166-1-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============6426420703098135253==
Content-Type: multipart/alternative; boundary=001a113ccece212dd3054b61b44c

--001a113ccece212dd3054b61b44c
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Fri, Mar 17, 2017 at 1:35 AM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libdmmp/docs/kernel-doc    |  2 +-
>  libmultipath/uevent.c      | 12 ++++++------
>  multipath/multipath.conf.5 |  2 +-
>  3 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/libdmmp/docs/kernel-doc b/libdmmp/docs/kernel-doc
> index 030fc63..8f5b546 100644
> --- a/libdmmp/docs/kernel-doc
> +++ b/libdmmp/docs/kernel-doc
> @@ -414,7 +414,7 @@ my $doc_com = '\s*\*\s*';
>  my $doc_com_body = '\s*\* ?';
>  my $doc_decl = $doc_com . '(\w+)';
>  # @params and a strictly limited set of supported section names
> -my $doc_sect = $doc_com .
> +my $doc_sect = $doc_com .
>      '\s*(\@[.\w]+|\@\.\.\.|description|context|returns?|
> notes?|examples?)\s*:(.*)';
>  my $doc_content = $doc_com_body . '(.*)';
>  my $doc_block = $doc_com . 'DOC:\s*(.*)?';
> diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
> index 367e129..4fbd1df 100644
> --- a/libmultipath/uevent.c
> +++ b/libmultipath/uevent.c
> @@ -113,7 +113,7 @@ uevent_get_wwid(struct uevent *uev)
>
>         conf = get_multipath_config();
>         uid_attribute = parse_uid_attribute_by_attrs(conf->uid_attrs,
> uev->kernel);
> -       put_multipath_config(conf);
> +       put_multipath_config(conf);
>
>         if (!uid_attribute)
>                 return;
> @@ -138,7 +138,7 @@ uevent_need_merge(void)
>         conf = get_multipath_config();
>         if (conf->uid_attrs)
>                 need_merge = true;
> -       put_multipath_config(conf);
> +       put_multipath_config(conf);
>
>         return need_merge;
>  }
> @@ -173,12 +173,12 @@ uevent_can_discard(struct uevent *uev)
>         if (uevent_can_discard_by_devpath(uev->devpath))
>                 return true;
>
> -       /*
> +       /*
>          * do not filter dm devices by devnode
>          */
>         if (!strncmp(uev->kernel, "dm-", 3))
>                 return false;
> -       /*
> +       /*
>          * filter paths devices by devnode
>          */
>         conf = get_multipath_config();
> @@ -309,12 +309,12 @@ uevent_filter(struct uevent *later, struct list_head
> *tmpq)
>
>         list_for_some_entry_reverse_safe(earlier, tmp, &later->node,
> tmpq, node) {
>                 /*
> -                * filter unnessary earlier uevents
> +                * filter unnessary earlier uevents
>                  * by the later uevent
>                  */
>                 if (uevent_can_filter(earlier, later)) {
>                         condlog(2, "uevent: %s-%s has filtered by uevent:
> %s-%s",
> -                               earlier->kernel, earlier->action,
> +                               earlier->kernel, earlier->action,
>                                 later->kernel, later->action);
>
>                         list_del_init(&earlier->node);
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index efeead5..24decf7 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -208,7 +208,7 @@ The default is: \fBfailover\fR
>  .
>  .TP
>  .B uid_attrs
> -The udev attribute providing a unique path identifier for corresponding
> +The udev attribute providing a unique path identifier for corresponding
>  type of path devices. If this field is configured and matched with type
>  of device, it would override any other methods providing for device
>  unique identifier in config file, and it would activate merging uevents
> --
> 2.12.0
>
>

--001a113ccece212dd3054b61b44c
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Fri, Mar 17, 2017 at 1:35 AM, Xose Vazque=
z Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" tar=
get=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex">Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.=
varoqui@opensvc.com">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libdmmp/docs/kernel-doc=C2=A0 =C2=A0 |=C2=A0 2 +-<br>
=C2=A0libmultipath/uevent.c=C2=A0 =C2=A0 =C2=A0 | 12 ++++++------<br>
=C2=A0multipath/multipath.conf.5 |=C2=A0 2 +-<br>
=C2=A03 files changed, 8 insertions(+), 8 deletions(-)<br>
<br>
diff --git a/libdmmp/docs/kernel-doc b/libdmmp/docs/kernel-doc<br>
index 030fc63..8f5b546 100644<br>
--- a/libdmmp/docs/kernel-doc<br>
+++ b/libdmmp/docs/kernel-doc<br>
@@ -414,7 +414,7 @@ my $doc_com =3D &#39;\s*\*\s*&#39;;<br>
=C2=A0my $doc_com_body =3D &#39;\s*\* ?&#39;;<br>
=C2=A0my $doc_decl =3D $doc_com . &#39;(\w+)&#39;;<br>
=C2=A0# @params and a strictly limited set of supported section names<br>
-my $doc_sect =3D $doc_com .<br>
+my $doc_sect =3D $doc_com .<br>
=C2=A0 =C2=A0 =C2=A0&#39;\s*(\@[.\w]+|\@\.\.\.|<wbr>description|context|ret=
urns?|<wbr>notes?|examples?)\s*:(.*)&#39;;<br>
=C2=A0my $doc_content =3D $doc_com_body . &#39;(.*)&#39;;<br>
=C2=A0my $doc_block =3D $doc_com . &#39;DOC:\s*(.*)?&#39;;<br>
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c<br>
index 367e129..4fbd1df 100644<br>
--- a/libmultipath/uevent.c<br>
+++ b/libmultipath/uevent.c<br>
@@ -113,7 +113,7 @@ uevent_get_wwid(struct uevent *uev)<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf =3D get_multipath_config();<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 uid_attribute =3D parse_uid_attribute_by_attrs(=
<wbr>conf-&gt;uid_attrs, uev-&gt;kernel);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0put_multipath_config(conf);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0put_multipath_config(conf);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!uid_attribute)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;<br>
@@ -138,7 +138,7 @@ uevent_need_merge(void)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf =3D get_multipath_config();<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (conf-&gt;uid_attrs)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 need_merge =3D true=
;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0put_multipath_config(conf);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0put_multipath_config(conf);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return need_merge;<br>
=C2=A0}<br>
@@ -173,12 +173,12 @@ uevent_can_discard(struct uevent *uev)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (uevent_can_discard_by_<wbr>devpath(uev-&gt;=
devpath))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return true;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* do not filter dm devices by devnode<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!strncmp(uev-&gt;kernel, &quot;dm-&quot;, 3=
))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* filter paths devices by devnode<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf =3D get_multipath_config();<br>
@@ -309,12 +309,12 @@ uevent_filter(struct uevent *later, struct list_head =
*tmpq)<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 list_for_some_entry_reverse_<wbr>safe(earlier, =
tmp, &amp;later-&gt;node, tmpq, node) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * filter unnessary=
 earlier uevents<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * filter unnessary=
 earlier uevents<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* by the late=
r uevent<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (uevent_can_filt=
er(earlier, later)) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 condlog(2, &quot;uevent: %s-%s has filtered by uevent: %s-%s&quo=
t;,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0earlier-&gt;kernel, earlier-&gt;actio=
n,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0earlier-&gt;kernel, earlier-&gt;actio=
n,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 later-&gt;kernel, later-&gt;action);=
<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 list_del_init(&amp;earlier-&gt;node);<br>
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5<br>
index efeead5..24decf7 100644<br>
--- a/multipath/multipath.conf.5<br>
+++ b/multipath/multipath.conf.5<br>
@@ -208,7 +208,7 @@ The default is: \fBfailover\fR<br>
=C2=A0.<br>
=C2=A0.TP<br>
=C2=A0.B uid_attrs<br>
-The udev attribute providing a unique path identifier for corresponding<br=
>
+The udev attribute providing a unique path identifier for corresponding<br=
>
=C2=A0type of path devices. If this field is configured and matched with ty=
pe<br>
=C2=A0of device, it would override any other methods providing for device<b=
r>
=C2=A0unique identifier in config file, and it would activate merging ueven=
ts<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.12.0<br>
<br>
</font></span></blockquote></div><br></div>

--001a113ccece212dd3054b61b44c--


--===============6426420703098135253==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6426420703098135253==--
