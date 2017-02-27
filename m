From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] Avoid that reloading a map sporadically
 triggers I/O errors
Date: Mon, 27 Feb 2017 22:06:31 +0100
Message-ID: <CABr-GncajX5CaazYUaWWzRZTUMfed5ViFqoEUA7swSbr9nV_ww@mail.gmail.com>
References: <85315cb2-6908-70c6-78b7-06b6c1071f6b@sandisk.com>
	<d044817b-ea55-f42f-3895-5c539260ed80@sandisk.com>
	<20170104195643.GK2732@octiron.msp.redhat.com>
	<f95d0a86-5165-2c92-e824-449212bad9eb@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1084102170794511700=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f95d0a86-5165-2c92-e824-449212bad9eb@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1084102170794511700==
Content-Type: multipart/alternative; boundary=001a113534422c01b105498974d5

--001a113534422c01b105498974d5
Content-Type: text/plain; charset=UTF-8

Oh yes, sorry, this patch slipped past my cursor.

This patch highlights the lack of consistency in function prototypes in
devmapper.c : some using "no_flush", others using "flush".

Anyway, your patch is now applied.
Thanks.

On Mon, Feb 27, 2017 at 4:18 PM, Bart Van Assche <bart.vanassche@sandisk.com
> wrote:

> Hello Christophe,
>
> The patch below was posted more than three months ago but has not yet
> received any feedback from you. Had I sent this patch to the right person?
> Do you perhaps want me to repost it?
>
> Bart.
>
>
> On 01/04/17 11:56, Benjamin Marzinski wrote:
>
>> On Wed, Dec 07, 2016 at 03:37:44PM -0800, Bart Van Assche wrote:
>>
>> ACK
>>
>> -Ben
>>
>> Christophe and Hannes, do you want to comment on this patch?
>>>
>>> Thanks,
>>>
>>> Bart.
>>>
>>> On 11/18/2016 01:33 PM, Bart Van Assche wrote:
>>>
>>>> Avoid that reloading a map while there are no paths triggers a flush
>>>> and hence unwanted I/O errors if 'queue_if_no_path' is enabled.
>>>>
>>>> Fixes: commit d569988e7528 ("libmultipath: Fixup 'DM_DEVICE_RELOAD'
>>>> handling")
>>>> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
>>>> Cc: Hannes Reinecke <hare@suse.de>
>>>> ---
>>>> libmultipath/devmapper.c | 2 +-
>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
>>>> index f92ebce..31f1962 100644
>>>> --- a/libmultipath/devmapper.c
>>>> +++ b/libmultipath/devmapper.c
>>>> @@ -390,7 +390,7 @@ int dm_addmap_reload(struct multipath *mpp, char
>>>> *params, int flush)
>>>>                               params, ADDMAP_RO, SKIP_KPARTX_OFF);
>>>>         }
>>>>         if (r)
>>>> -               r = dm_simplecmd(DM_DEVICE_RESUME, mpp->alias, flush,
>>>> +               r = dm_simplecmd(DM_DEVICE_RESUME, mpp->alias, !flush,
>>>>                                  1, udev_flags, 0);
>>>>         return r;
>>>> }
>>>>
>>>
>

--001a113534422c01b105498974d5
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Oh yes, sorry, this patch slipped past my cursor.<div><br>=
</div><div>This patch highlights the lack of consistency in function protot=
ypes in devmapper.c : some using &quot;no_flush&quot;, others using &quot;f=
lush&quot;.</div><div><br></div><div>Anyway, your patch is now applied.</di=
v><div>Thanks.</div></div><div class=3D"gmail_extra"><br><div class=3D"gmai=
l_quote">On Mon, Feb 27, 2017 at 4:18 PM, Bart Van Assche <span dir=3D"ltr"=
>&lt;<a href=3D"mailto:bart.vanassche@sandisk.com" target=3D"_blank">bart.v=
anassche@sandisk.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">Hello Christophe,<br>
<br>
The patch below was posted more than three months ago but has not yet recei=
ved any feedback from you. Had I sent this patch to the right person? Do yo=
u perhaps want me to repost it?<span class=3D"HOEnZb"><font color=3D"#88888=
8"><br>
<br>
Bart.</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
<br>
On 01/04/17 11:56, Benjamin Marzinski wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
On Wed, Dec 07, 2016 at 03:37:44PM -0800, Bart Van Assche wrote:<br>
<br>
ACK<br>
<br>
-Ben<br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Christophe and Hannes, do you want to comment on this patch?<br>
<br>
Thanks,<br>
<br>
Bart.<br>
<br>
On 11/18/2016 01:33 PM, Bart Van Assche wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Avoid that reloading a map while there are no paths triggers a flush<br>
and hence unwanted I/O errors if &#39;queue_if_no_path&#39; is enabled.<br>
<br>
Fixes: commit d569988e7528 (&quot;libmultipath: Fixup &#39;DM_DEVICE_RELOAD=
&#39; handling&quot;)<br>
Signed-off-by: Bart Van Assche &lt;<a href=3D"mailto:bart.vanassche@sandisk=
.com" target=3D"_blank">bart.vanassche@sandisk.com</a>&gt;<br>
Cc: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.de" target=3D"_blank">h=
are@suse.de</a>&gt;<br>
---<br>
libmultipath/devmapper.c | 2 +-<br>
1 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c<br>
index f92ebce..31f1962 100644<br>
--- a/libmultipath/devmapper.c<br>
+++ b/libmultipath/devmapper.c<br>
@@ -390,7 +390,7 @@ int dm_addmap_reload(struct multipath *mpp, char *param=
s, int flush)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 params, ADDMAP_RO, SKIP_KPARTX_OFF);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (r)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D dm_simplecmd(=
DM_DEVICE_RESUME, mpp-&gt;alias, flush,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D dm_simplecmd(=
DM_DEVICE_RESUME, mpp-&gt;alias, !flush,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01, udev_flags, 0);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;<br>
}<br>
</blockquote></blockquote></blockquote>
<br>
</div></div></blockquote></div><br></div>

--001a113534422c01b105498974d5--


--===============1084102170794511700==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1084102170794511700==--
