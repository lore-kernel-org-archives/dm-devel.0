From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 2/2] multipath-tools: output more topology
	info for NVMe discovery
Date: Wed, 15 Nov 2017 23:40:39 +0100
Message-ID: <CABr-Gnd2O2X1h76k=cVmGEVxkzMPgTej01vwVULTkQjf7iQs=A@mail.gmail.com>
References: <1507793730-13400-1-git-send-email-yangjie65@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6723357661691228893=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1507793730-13400-1-git-send-email-yangjie65@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: y00378701 <yangjie65@huawei.com>
Cc: Guan Junxiong <guanjunxiong@huawei.com>, device-mapper development <dm-devel@redhat.com>, niuhaoxin@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

--===============6723357661691228893==
Content-Type: multipart/alternative; boundary="001a114a9b2e6486fa055e0d31d5"

--001a114a9b2e6486fa055e0d31d5
Content-Type: text/plain; charset="UTF-8"

Hi,

this patch seems to be orphaned from its patchset.
Do you maintain your request for inclusion ?

Thanks.

On Thu, Oct 12, 2017 at 9:35 AM, y00378701 <yangjie65@huawei.com> wrote:

> Assign sg_id.channel to controller id of the NVMe/NVMf target
> and assign sg_id.lun to namespace ID of the target.
>
> Signed-off-by: Jie Yang yangjie65@huawei.com
> Reviewed-by: Guan Junxiong guanjunxiong@huawei.com
> ---
>  libmultipath/discovery.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index efac824..f1d303e 100644
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
> 2.8.1.windows.1
>
>
>

--001a114a9b2e6486fa055e0d31d5
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>this patch seems to be orphaned fro=
m its patchset.</div><div>Do you maintain your request for inclusion ?</div=
><div><br></div><div>Thanks.</div></div><div class=3D"gmail_extra"><br><div=
 class=3D"gmail_quote">On Thu, Oct 12, 2017 at 9:35 AM, y00378701 <span dir=
=3D"ltr">&lt;<a href=3D"mailto:yangjie65@huawei.com" target=3D"_blank">yang=
jie65@huawei.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote"=
 style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">As=
sign sg_id.channel to controller id of the NVMe/NVMf target<br>
and assign sg_id.lun to namespace ID of the target.<br>
<br>
Signed-off-by: Jie Yang <a href=3D"mailto:yangjie65@huawei.com">yangjie65@h=
uawei.com</a><br>
Reviewed-by: Guan Junxiong <a href=3D"mailto:guanjunxiong@huawei.com">guanj=
unxiong@huawei.com</a><br>
---<br>
=C2=A0libmultipath/discovery.c | 4 +++-<br>
=C2=A01 file changed, 3 insertions(+), 1 deletion(-)<br>
<br>
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c<br>
index efac824..f1d303e 100644<br>
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
2.8.1.windows.1<br>
<br>
<br>
</font></span></blockquote></div><br></div>

--001a114a9b2e6486fa055e0d31d5--


--===============6723357661691228893==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6723357661691228893==--
