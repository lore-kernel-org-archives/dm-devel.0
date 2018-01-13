From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v2] multipath-tools: output more topology
	info for NVMe discovery
Date: Sat, 13 Jan 2018 10:09:46 +0100
Message-ID: <CABr-Gndz3jkGfYwckC_j4sRiT7Y1O2eUvENfsAixN=cRvT2AWg@mail.gmail.com>
References: <1512393237-18356-1-git-send-email-guanjunxiong@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3880933536459193801=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1512393237-18356-1-git-send-email-guanjunxiong@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Guan Junxiong <guanjunxiong@huawei.com>
Cc: device-mapper development <dm-devel@redhat.com>, niuhaoxin@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

--===============3880933536459193801==
Content-Type: multipart/alternative; boundary="001a1147bba013adfb0562a4be67"

--001a1147bba013adfb0562a4be67
Content-Type: text/plain; charset="UTF-8"

Merged.
Thanks.

On Mon, Dec 4, 2017 at 2:13 PM, Guan Junxiong <guanjunxiong@huawei.com>
wrote:

> From: Jie Yang <yangjie65@huawei.com>
>
> Assign sg_id.channel to controller id of the NVMe/NVMf target
> and assign sg_id.lun to namespace ID of the target.
>
> Signed-off-by: Jie Yang <yangjie65@huawei.com>
> Reviewed-by: Guan Junxiong <guanjunxiong@huawei.com>
> ---
>
>
> change since V1:
>   patch 2/2 --> path V2 becuase this is an independent patch
>
>
>  libmultipath/discovery.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index cadf461..4b31dde 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1206,12 +1206,14 @@ nvme_sysfs_pathinfo (struct path * pp, vector
> hwtable)
>                    &pp->sg_id.scsi_id) != 2)
>                 return 1;
>         pp->sg_id.channel = 0;
> -       pp->sg_id.lun = 0;
> +       pp->sg_id.lun = atoi(udev_device_get_sysattr_value(pp->udev,
> "nsid"));
>
>         parent = udev_device_get_parent(pp->udev);
>         if (!parent)
>                 return 1;
>
> +       pp->sg_id.channel = atoi(udev_device_get_sysattr_value(parent,
> "cntlid"));
> +
>         snprintf(pp->vendor_id, SCSI_VENDOR_SIZE, "NVME");
>         snprintf(pp->product_id, SCSI_PRODUCT_SIZE, "%s",
>                  udev_device_get_sysattr_value(parent, "model"));
> --
> 2.6.4.windows.1
>
>
>

--001a1147bba013adfb0562a4be67
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Mon, Dec 4, 2017 at 2:13 PM, Guan Junxion=
g <span dir=3D"ltr">&lt;<a href=3D"mailto:guanjunxiong@huawei.com" target=
=3D"_blank">guanjunxiong@huawei.com</a>&gt;</span> wrote:<br><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;p=
adding-left:1ex">From: Jie Yang &lt;<a href=3D"mailto:yangjie65@huawei.com"=
>yangjie65@huawei.com</a>&gt;<br>
<br>
Assign sg_id.channel to controller id of the NVMe/NVMf target<br>
and assign sg_id.lun to namespace ID of the target.<br>
<br>
Signed-off-by: Jie Yang &lt;<a href=3D"mailto:yangjie65@huawei.com">yangjie=
65@huawei.com</a>&gt;<br>
Reviewed-by: Guan Junxiong &lt;<a href=3D"mailto:guanjunxiong@huawei.com">g=
uanjunxiong@huawei.com</a>&gt;<br>
---<br>
<br>
<br>
change since V1:<br>
=C2=A0 patch 2/2 --&gt; path V2 becuase this is an independent patch<br>
<br>
<br>
=C2=A0libmultipath/discovery.c | 4 +++-<br>
=C2=A01 file changed, 3 insertions(+), 1 deletion(-)<br>
<br>
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c<br>
index cadf461..4b31dde 100644<br>
--- a/libmultipath/discovery.c<br>
+++ b/libmultipath/discovery.c<br>
@@ -1206,12 +1206,14 @@ nvme_sysfs_pathinfo (struct path * pp, vector hwtab=
le)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp;p=
p-&gt;sg_id.scsi_id) !=3D 2)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;sg_id.channel =3D 0;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0pp-&gt;sg_id.lun =3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pp-&gt;sg_id.lun =3D atoi(udev_device_get_sysat=
tr_<wbr>value(pp-&gt;udev, &quot;nsid&quot;));<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 parent =3D udev_device_get_parent(pp-&gt;<wbr>u=
dev);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!parent)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pp-&gt;sg_id.channel =3D atoi(udev_device_get_s=
ysattr_<wbr>value(parent, &quot;cntlid&quot;));<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 snprintf(pp-&gt;vendor_id, SCSI_VENDOR_SIZE, &q=
uot;NVME&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 snprintf(pp-&gt;product_id, SCSI_PRODUCT_SIZE, =
&quot;%s&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0udev_device_g=
et_sysattr_value(<wbr>parent, &quot;model&quot;));<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.6.4.windows.1<br>
<br>
<br>
</font></span></blockquote></div><br></div>

--001a1147bba013adfb0562a4be67--


--===============3880933536459193801==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3880933536459193801==--
