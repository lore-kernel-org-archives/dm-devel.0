From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH]multipath: Wrong sysfs attribute used for
	iSCSI settings.
Date: Thu, 24 Jul 2014 10:33:19 +0200
Message-ID: <CABr-GnfVoxLHuV5asA0DKAoC1U2i2sHPtDo4k-VSioCB1Kfutw@mail.gmail.com>
References: <47bff49ac3c742fc86a11b013a76e985@hioexcmbx01-prd.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7020649132671012686=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <47bff49ac3c742fc86a11b013a76e985@hioexcmbx01-prd.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============7020649132671012686==
Content-Type: multipart/alternative; boundary=e89a8fb1ea681b52ac04feec4f59

--e89a8fb1ea681b52ac04feec4f59
Content-Type: text/plain; charset=UTF-8

Applied,
Thanks.


On Sat, Jun 21, 2014 at 12:33 AM, Merla, ShivaKrishna <
ShivaKrishna.Merla@netapp.com> wrote:

> Wrong sysfs parameter used to configure iSCSI settings.
>
> /sys/class/iscsi_session/session<n>/tgtname
> It's always
> /sys/class/iscsi_session/session<n>/targetname
>
> This is the reason recovery_tmo was not getting set to
> fast_io_fail_tmo value for iscsi sessions.
>
> Signed-off-by: Shiva Krishna Merla<shivakrishna.merla@netapp.com>
> ---
>  libmultipath/discovery.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 786e1de..7bb0a33 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -289,7 +289,7 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)
>                 if (tgtdev) {
>                         const char *value;
>
> -                       value = udev_device_get_sysattr_value(tgtdev,
> "tgtname");
> +                       value = udev_device_get_sysattr_value(tgtdev,
> "targetname");
>                         if (value) {
>                                 pp->sg_id.proto_id = SCSI_PROTOCOL_ISCSI;
>                                 pp->sg_id.transport_id = tgtid;
> --
>

--e89a8fb1ea681b52ac04feec4f59
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied,<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><br><div class=3D"gmail_quote">On Sat, Jun 21, 2014 at 12:33 AM, Merla=
, ShivaKrishna <span dir=3D"ltr">&lt;<a href=3D"mailto:ShivaKrishna.Merla@n=
etapp.com" target=3D"_blank">ShivaKrishna.Merla@netapp.com</a>&gt;</span> w=
rote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Wrong sysfs parameter used to configure iSCS=
I settings.<br>
<br>
/sys/class/iscsi_session/session&lt;n&gt;/tgtname<br>
It&#39;s always<br>
/sys/class/iscsi_session/session&lt;n&gt;/targetname<br>
<br>
This is the reason recovery_tmo was not getting set to<br>
fast_io_fail_tmo value for iscsi sessions.<br>
<br>
Signed-off-by: Shiva Krishna Merla&lt;<a href=3D"mailto:shivakrishna.merla@=
netapp.com">shivakrishna.merla@netapp.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/discovery.c | =C2=A0 =C2=A02 +-<br>
=C2=A01 files changed, 1 insertions(+), 1 deletions(-)<br>
<br>
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c<br>
index 786e1de..7bb0a33 100644<br>
--- a/libmultipath/discovery.c<br>
+++ b/libmultipath/discovery.c<br>
@@ -289,7 +289,7 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (tgtdev) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 const char *value;<br>
<br>
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 value =3D udev_device_get_sysattr_value(tgtdev, &quot;tgtname&quot;);<b=
r>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 value =3D udev_device_get_sysattr_value(tgtdev, &quot;targetname&quot;)=
;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (value) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;sg_id.proto_id =3D SCSI_PROTO=
COL_ISCSI;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;sg_id.transport_id =3D tgtid;=
<br>
--<br>
</blockquote></div><br></div>

--e89a8fb1ea681b52ac04feec4f59--


--===============7020649132671012686==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7020649132671012686==--
