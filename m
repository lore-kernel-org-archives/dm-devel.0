From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v2] multipath-tools: add README.alua with
 instructions to enable ALUA
Date: Sat, 13 Jan 2018 09:53:30 +0100
Message-ID: <CABr-GneAdBgA5LRNiMhtdeBRj1s6nxJHb8xVAPWmfkNOaPJD5Q@mail.gmail.com>
References: <20171121185213.3737-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1870251631194220299=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171121185213.3737-1-xose.vazquez@gmail.com>
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
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1870251631194220299==
Content-Type: multipart/alternative; boundary="94eb2c05dc5eeaffd60562a48317"

--94eb2c05dc5eeaffd60562a48317
Content-Type: text/plain; charset="UTF-8"

Applied,
Thanks.

On Tue, Nov 21, 2017 at 7:52 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> ALUA is supported in some storage devices, but usually it's disabled by
> default.
>
> Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> v2      add rdac info
> ---
>  README.alua | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>  create mode 100644 README.alua
>
> diff --git a/README.alua b/README.alua
> new file mode 100644
> index 0000000..e39debd
> --- /dev/null
> +++ b/README.alua
> @@ -0,0 +1,17 @@
> +This is a rough guide, consult your storage device manufacturer
> documentation.
> +
> +ALUA is supported in some devices, but usually it's disabled by default.
> +To enable ALUA, the following options should be changed:
> +
> +- EMC CLARiiON/VNX:
> +   "Failover Mode" should be changed to "4".
> +
> +- HPE 3PAR:
> +   "Host:" should be changed to "Generic-ALUA Persona 2 (UARepLun,
> SESLun, ALUA)".
> +
> +- Promise VTrak/Vess:
> +   "LUN Affinity" and "ALUA" should be changed to "Enable", "Redundancy
> Type"
> +   must be "Active-Active".
> +
> +- LSI/Engenio/NetApp RDAC class, as NetApp SANtricity E/EF Series and OEM
> arrays:
> +   "Select operating system:" should be changed to "Linux DM-MP (Kernel
> 3.10 or later)".
> --
> 2.14.3
>
>

--94eb2c05dc5eeaffd60562a48317
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied,<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Tue, Nov 21, 2017 at 7:52 PM, Xose Vazqu=
ez Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" ta=
rget=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex"><span class=3D"">ALUA is supported in some storage devi=
ces, but usually it&#39;s disabled by default.<br>
<br>
</span>Cc: NetApp RDAC team &lt;<a href=3D"mailto:ng-eseries-upstream-maint=
ainers@netapp.com">ng-eseries-upstream-<wbr>maintainers@netapp.com</a>&gt;<=
br>
<span class=3D"">Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.va=
roqui@opensvc.com">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
</span>v2=C2=A0 =C2=A0 =C2=A0 add rdac info<br>
---<br>
=C2=A0README.alua | 17 +++++++++++++++++<br>
=C2=A01 file changed, 17 insertions(+)<br>
<span class=3D"">=C2=A0create mode 100644 README.alua<br>
<br>
diff --git a/README.alua b/README.alua<br>
new file mode 100644<br>
</span>index 0000000..e39debd<br>
--- /dev/null<br>
+++ b/README.alua<br>
@@ -0,0 +1,17 @@<br>
<span class=3D"">+This is a rough guide, consult your storage device manufa=
cturer documentation.<br>
+<br>
+ALUA is supported in some devices, but usually it&#39;s disabled by defaul=
t.<br>
+To enable ALUA, the following options should be changed:<br>
+<br>
+- EMC CLARiiON/VNX:<br>
+=C2=A0 =C2=A0&quot;Failover Mode&quot; should be changed to &quot;4&quot;.=
<br>
+<br>
+- HPE 3PAR:<br>
+=C2=A0 =C2=A0&quot;Host:&quot; should be changed to &quot;Generic-ALUA Per=
sona 2 (UARepLun, SESLun, ALUA)&quot;.<br>
+<br>
+- Promise VTrak/Vess:<br>
+=C2=A0 =C2=A0&quot;LUN Affinity&quot; and &quot;ALUA&quot; should be chang=
ed to &quot;Enable&quot;, &quot;Redundancy Type&quot;<br>
+=C2=A0 =C2=A0must be &quot;Active-Active&quot;.<br>
</span>+<br>
+- LSI/Engenio/NetApp RDAC class, as NetApp SANtricity E/EF Series and OEM =
arrays:<br>
+=C2=A0 =C2=A0&quot;Select operating system:&quot; should be changed to &qu=
ot;Linux DM-MP (Kernel 3.10 or later)&quot;.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.14.3<br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c05dc5eeaffd60562a48317--


--===============1870251631194220299==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1870251631194220299==--
