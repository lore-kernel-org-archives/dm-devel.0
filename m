From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] kpartx.rules: Fix syntax error in
	skip_kpartx code
Date: Thu, 3 Aug 2017 08:39:34 +0200
Message-ID: <CABr-GnceHYKXyFVMRVMU8_sPs73am_V3M=JKOTaRaERAKCD3iA@mail.gmail.com>
References: <20170623215740.27628-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4490460820951098014=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170623215740.27628-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============4490460820951098014==
Content-Type: multipart/alternative; boundary="001a113bcb38c85c820555d3a456"

--001a113bcb38c85c820555d3a456
Content-Type: text/plain; charset="UTF-8"

Merged.
Thanks.

On Fri, Jun 23, 2017 at 11:57 PM, Martin Wilck <mwilck@suse.com> wrote:

> Fixes: 22736419 "kpartx.rules: respect skip_kpartx flag"
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  kpartx/kpartx.rules | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
> index a9587917..64d550de 100644
> --- a/kpartx/kpartx.rules
> +++ b/kpartx/kpartx.rules
> @@ -37,7 +37,7 @@ ENV{ID_FS_USAGE}=="filesystem|other",
> ENV{ID_FS_LABEL_ENC}=="?*", \
>  # Create dm tables for partitions
>  ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", GOTO="kpartx_end"
>  ENV{DM_NR_VALID_PATHS}=="0", GOTO="kpartx_end"
> -ENV{ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!="1", IMPORT{db}="DM_SUBSYSTEM_UDEV_
> FLAG1"
> +ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!="1", IMPORT{db}="DM_SUBSYSTEM_UDEV_
> FLAG1"
>  ENV{DM_SUBSYSTEM_UDEV_FLAG1}=="1", GOTO="kpartx_end"
>  ENV{DM_STATE}!="SUSPENDED", ENV{DM_UUID}=="mpath-*", \
>         RUN+="/sbin/kpartx -un -p -part /dev/$name"
> --
> 2.13.1
>
>

--001a113bcb38c85c820555d3a456
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Fri, Jun 23, 2017 at 11:57 PM, Martin Wil=
ck <span dir=3D"ltr">&lt;<a href=3D"mailto:mwilck@suse.com" target=3D"_blan=
k">mwilck@suse.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quot=
e" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">=
Fixes: 22736419 &quot;kpartx.rules: respect skip_kpartx flag&quot;<br>
Signed-off-by: Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com">mwilck@s=
use.com</a>&gt;<br>
---<br>
=C2=A0kpartx/kpartx.rules | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules<br>
index a9587917..64d550de 100644<br>
--- a/kpartx/kpartx.rules<br>
+++ b/kpartx/kpartx.rules<br>
@@ -37,7 +37,7 @@ ENV{ID_FS_USAGE}=3D=3D&quot;filesystem|<wbr>other&quot;, =
ENV{ID_FS_LABEL_ENC}=3D=3D&quot;?*&quot;, \<br>
=C2=A0# Create dm tables for partitions<br>
=C2=A0ENV{DM_ACTION}=3D=3D&quot;PATH_FAILED|<wbr>PATH_REINSTATED&quot;, GOT=
O=3D&quot;kpartx_end&quot;<br>
=C2=A0ENV{DM_NR_VALID_PATHS}=3D=3D&quot;0&quot;, GOTO=3D&quot;kpartx_end&qu=
ot;<br>
-ENV{ENV{DM_UDEV_PRIMARY_<wbr>SOURCE_FLAG}!=3D&quot;1&quot;, IMPORT{db}=3D&=
quot;DM_SUBSYSTEM_UDEV_<wbr>FLAG1&quot;<br>
+ENV{DM_UDEV_PRIMARY_SOURCE_<wbr>FLAG}!=3D&quot;1&quot;, IMPORT{db}=3D&quot=
;DM_SUBSYSTEM_UDEV_<wbr>FLAG1&quot;<br>
=C2=A0ENV{DM_SUBSYSTEM_UDEV_FLAG1}=3D=3D<wbr>&quot;1&quot;, GOTO=3D&quot;kp=
artx_end&quot;<br>
=C2=A0ENV{DM_STATE}!=3D&quot;SUSPENDED&quot;, ENV{DM_UUID}=3D=3D&quot;mpath=
-*&quot;, \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 RUN+=3D&quot;/sbin/kpartx -un -p -part /dev/$na=
me&quot;<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.13.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a113bcb38c85c820555d3a456--


--===============4490460820951098014==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4490460820951098014==--
