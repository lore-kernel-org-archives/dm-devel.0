From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: new ONTAP maintainer
Date: Fri, 8 Jul 2016 08:53:06 +0200
Message-ID: <CABr-Gnd531MgMt1+_qy9DyQXb-+XMYpzerWU7CMf4XePJ6DwOg@mail.gmail.com>
References: <1466694400-7044-1-git-send-email-xose.vazquez@gmail.com>
	<576D7251.4090909@netapp.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3904774737301953105=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <576D7251.4090909@netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin George <marting@netapp.com>
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

--===============3904774737301953105==
Content-Type: multipart/alternative; boundary=001a114b157445ca1e05371a41d5

--001a114b157445ca1e05371a41d5
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Fri, Jun 24, 2016 at 7:48 PM, Martin George <marting@netapp.com> wrote:

> Looks good.
>
> Acked-by: Martin George <marting@netapp.com>
>
>
> On 6/23/2016 8:36 PM, Xose Vazquez Perez wrote:
>
>> Martin George is in charge of the ONTAP family.
>>
>> Cc: Martin George <marting@netapp.com>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: device-mapper development <dm-devel@redhat.com>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> ---
>>   libmultipath/hwtable.c | 9 +++++----
>>   1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
>> index 38487c1..c845547 100644
>> --- a/libmultipath/hwtable.c
>> +++ b/libmultipath/hwtable.c
>> @@ -783,7 +783,10 @@ static struct hwentry default_hw[] = {
>>                 .prio_args     = NULL,
>>         },
>>         /*
>> -        * NETAPP
>> +        * NETAPP ONTAP family
>> +        *
>> +        * Maintainer : Martin George
>> +        * Mail : marting@netapp.com
>>          */
>>         {
>>                 .vendor        = "NETAPP",
>> @@ -803,10 +806,8 @@ static struct hwentry default_hw[] = {
>>                 .retain_hwhandler = RETAIN_HWHANDLER_ON,
>>                 .detect_prio   = DETECT_PRIO_ON,
>>         },
>> -       /*
>> -        * IBM NSeries (NETAPP)
>> -        */
>>         {
>> +               /* IBM NSeries */
>>                 .vendor        = "IBM",
>>                 .product       = "Nseries.*",
>>                 .features      = "1 queue_if_no_path",
>>
>>

--001a114b157445ca1e05371a41d5
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Fri, Jun 24, 2016 at 7:48 PM, Martin Geor=
ge <span dir=3D"ltr">&lt;<a href=3D"mailto:marting@netapp.com" target=3D"_b=
lank">marting@netapp.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmai=
l_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left=
:1ex">Looks good.<br>
<br>
Acked-by: Martin George &lt;<a href=3D"mailto:marting@netapp.com" target=3D=
"_blank">marting@netapp.com</a>&gt;<div class=3D"HOEnZb"><div class=3D"h5">=
<br>
<br>
On 6/23/2016 8:36 PM, Xose Vazquez Perez wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Martin George is in charge of the ONTAP family.<br>
<br>
Cc: Martin George &lt;<a href=3D"mailto:marting@netapp.com" target=3D"_blan=
k">marting@netapp.com</a>&gt;<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
" target=3D"_blank">christophe.varoqui@opensvc.com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com" ta=
rget=3D"_blank">dm-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com" target=3D"_blank">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0 libmultipath/hwtable.c | 9 +++++----<br>
=C2=A0 1 file changed, 5 insertions(+), 4 deletions(-)<br>
<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index 38487c1..c845547 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -783,7 +783,10 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .prio_args=C2=A0 =
=C2=A0 =C2=A0=3D NULL,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 * NETAPP<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * NETAPP ONTAP family<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 *<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * Maintainer : Martin George<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * Mail : <a href=3D"mailto:marting@netapp.com"=
 target=3D"_blank">marting@netapp.com</a><br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;NETAPP&quot;,<br>
@@ -803,10 +806,8 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .retain_hwhandler =
=3D RETAIN_HWHANDLER_ON,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .detect_prio=C2=A0 =
=C2=A0=3D DETECT_PRIO_ON,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 * IBM NSeries (NETAPP)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* IBM NSeries */<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;IBM&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;Nseries.*&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .features=C2=A0 =C2=
=A0 =C2=A0 =3D &quot;1 queue_if_no_path&quot;,<br>
<br>
</blockquote>
</div></div></blockquote></div><br></div>

--001a114b157445ca1e05371a41d5--


--===============3904774737301953105==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3904774737301953105==--
