From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 1/1] multipath-tools: fix dm- device filtering
Date: Fri, 8 Jul 2016 09:42:43 +0200
Message-ID: <CABr-Gnd2iwXPm_eXo0WPhQCKiEbkndqGDeB97XSKoyB4RAmz4A@mail.gmail.com>
References: <CAAZtj81O6sRAG7j9DQdbPtTpnAsygPa55FU0_dZJgfyiwHmBEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1006945931976454083=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAZtj81O6sRAG7j9DQdbPtTpnAsygPa55FU0_dZJgfyiwHmBEw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dragan Stancevic <dragan.stancevic@canonical.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1006945931976454083==
Content-Type: multipart/alternative; boundary=001a113fc0a8b9edb805371af23b

--001a113fc0a8b9edb805371af23b
Content-Type: text/plain; charset=UTF-8

Rebased and merged.
Thanks.

On Tue, Jul 5, 2016 at 10:46 PM, Dragan Stancevic <
dragan.stancevic@canonical.com> wrote:

> During "service multipath-tools start" /sbin/multipath is
> called on dm- devices that are filtered but due to a condition
> conf->dev_type == DEV_DEVNODE in filtering code multipath
> binary wasn't dropping out when hitting a dm- device. This
> was due to the fact that in this case conf->dev_type is
> set to DEV_UEVENT.
>
> This is causing the logs to be filled with following
> messages:
>
> multipath: dm-6: failed to get udev uid: Invalid argument
> multipath: dm-6: failed to get sysfs uid: Invalid argument
> multipath: dm-6: failed to get sgio uid: No such file or directory
>
> This change alows the filtering to happen.
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
>
> Signed-off-by: Dragan Stancevic <dragan.stancevic@canonical.com>
> ---
>  multipath/main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/multipath/main.c b/multipath/main.c
> index aadebec..d89298b 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -267,7 +267,8 @@ configure (void)
>         /*
>          * if we have a blacklisted device parameter, exit early
>          */
> -       if (dev && conf->dev_type == DEV_DEVNODE &&
> +       if (dev && (conf->dev_type == DEV_DEVNODE ||
> +                   conf->dev_type == DEV_UEVENT) &&
>             conf->cmd != CMD_REMOVE_WWID &&
>             (filter_devnode(conf->blist_devnode,
>                             conf->elist_devnode, dev) > 0)) {
> --
> 2.1.0
>
>

--001a113fc0a8b9edb805371af23b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Rebased and merged.<div>Thanks.</div></div><div class=3D"g=
mail_extra"><br><div class=3D"gmail_quote">On Tue, Jul 5, 2016 at 10:46 PM,=
 Dragan Stancevic <span dir=3D"ltr">&lt;<a href=3D"mailto:dragan.stancevic@=
canonical.com" target=3D"_blank">dragan.stancevic@canonical.com</a>&gt;</sp=
an> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;=
border-left:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div>During &=
quot;service multipath-tools start&quot; /sbin/multipath is</div><div>calle=
d on dm- devices that are filtered but due to a condition</div><div>conf-&g=
t;dev_type =3D=3D DEV_DEVNODE in filtering code multipath</div><div>binary =
wasn&#39;t dropping out when hitting a dm- device. This</div><div>was due t=
o the fact that in this case conf-&gt;dev_type is</div><div>set to DEV_UEVE=
NT.</div><div><br></div><div>This is causing the logs to be filled with fol=
lowing</div><div>messages:</div><div><br></div><div>multipath: dm-6: failed=
 to get udev uid: Invalid argument</div><div>multipath: dm-6: failed to get=
 sysfs uid: Invalid argument</div><div>multipath: dm-6: failed to get sgio =
uid: No such file or directory</div><div><br></div><div>This change alows t=
he filtering to happen.</div><div><br></div><div>Cc: Christophe Varoqui &lt=
;<a href=3D"mailto:christophe.varoqui@opensvc.com" target=3D"_blank">christ=
ophe.varoqui@opensvc.com</a>&gt;</div><div>Cc: device-mapper development &l=
t;<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.=
com</a>&gt;</div><div><br></div><div>Signed-off-by: Dragan Stancevic &lt;<a=
 href=3D"mailto:dragan.stancevic@canonical.com" target=3D"_blank">dragan.st=
ancevic@canonical.com</a>&gt;</div><div>---</div><div>=C2=A0multipath/main.=
c | 3 ++-=C2=A0</div><div>=C2=A01 file changed, 2 insertions(+), 1 deletion=
(-)</div><div><br></div><div>diff --git a/multipath/main.c b/multipath/main=
.c</div><div>index aadebec..d89298b 100644</div><div>--- a/multipath/main.c=
</div><div>+++ b/multipath/main.c</div><div>@@ -267,7 +267,8 @@ configure (=
void)</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*</div><div>=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0* if we have a blacklisted device parameter, exit early</d=
iv><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/</div><div>- =C2=A0 =C2=A0 =C2=
=A0 if (dev &amp;&amp; conf-&gt;dev_type =3D=3D DEV_DEVNODE &amp;&amp;</div=
><div>+ =C2=A0 =C2=A0 =C2=A0 if (dev &amp;&amp; (conf-&gt;dev_type =3D=3D D=
EV_DEVNODE ||</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 conf-&gt;dev_type =3D=3D DEV_UEVENT) &amp;&amp;</div><div>=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;cmd !=3D CMD_REMOVE_WWID &a=
mp;&amp;</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (filter_devnod=
e(conf-&gt;blist_devnode,</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;elist_=
devnode, dev) &gt; 0)) {</div><span class=3D"HOEnZb"><font color=3D"#888888=
"><div>--=C2=A0</div><div>2.1.0</div><div><br></div></font></span></div>
</blockquote></div><br></div>

--001a113fc0a8b9edb805371af23b--


--===============1006945931976454083==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1006945931976454083==--
