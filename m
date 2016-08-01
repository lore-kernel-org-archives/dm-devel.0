From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [RFC] [PATCH] add serial keyword to the weightedpath
	prioritizer
Date: Mon, 1 Aug 2016 18:11:35 +0200
Message-ID: <CABr-GnfV9SLd3-qeR07yu_Dwx2zNWE6gxa9Sm792qhGx28cvDA@mail.gmail.com>
References: <CABr-Gndh4LLgd=T00GdtwNVrFgL7Te91BwjZ0Dh4uYyDi3c9bA@mail.gmail.com>
	<577b156f-4b6f-ae00-10ba-d5b65fbe2ae7@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2321081846834766190=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <577b156f-4b6f-ae00-10ba-d5b65fbe2ae7@sandisk.com>
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

--===============2321081846834766190==
Content-Type: multipart/alternative; boundary=001a11412e42c0b5ac053904daae

--001a11412e42c0b5ac053904daae
Content-Type: text/plain; charset=UTF-8

Oops no !
Thanks for noting.

An incremental fix is now merged.

You are right about the spelling fix that accidentaly was wrapped into this
patch, but the patch has already been pushed online as-is so I don't see
how I can improve that now.

Regards,
Christophe

On Mon, Aug 1, 2016 at 6:02 PM, Bart Van Assche <bart.vanassche@sandisk.com>
wrote:

> On 07/31/2016 12:26 PM, Christophe Varoqui wrote:
>
>> Can you review this patch, adding a new 'serial' keyword to the
>> weightedpath prioritizer.
>>
>
> Is the following part of the patch intended?
>
>         } else if (!strcmp(regex, WWN)) {
> -               if (build_wwn_path(pp, path, FILE_NAME_SIZE) != 0) {
> +               if (build_serial_path(pp, path, FILE_NAME_SIZE) != 0) {
>
> Additionally, have you considered to apply the mulitpathd -> multipathd
> spelling fix in this patch as a separate patch?
>
> Thanks,
>
> Bart.
>

--001a11412e42c0b5ac053904daae
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Oops no !<div>Thanks for noting.</div><div><br></div><div>=
An incremental fix is now merged.</div><div><br></div><div>You are right ab=
out the spelling fix that accidentaly was wrapped into this patch, but the =
patch has already been pushed online as-is so I don&#39;t see how I can imp=
rove that now.</div><div><br></div><div>Regards,</div><div>Christophe</div>=
</div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Mon, Aug=
 1, 2016 at 6:02 PM, Bart Van Assche <span dir=3D"ltr">&lt;<a href=3D"mailt=
o:bart.vanassche@sandisk.com" target=3D"_blank">bart.vanassche@sandisk.com<=
/a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:=
0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On=
 07/31/2016 12:26 PM, Christophe Varoqui wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Can you review this patch, adding a new &#39;serial&#39; keyword to the<br>
weightedpath prioritizer.<br>
</blockquote>
<br></span>
Is the following part of the patch intended?<span class=3D""><br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (!strcmp(regex, WWN)) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (build_wwn_path(=
pp, path, FILE_NAME_SIZE) !=3D 0) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (build_serial_pa=
th(pp, path, FILE_NAME_SIZE) !=3D 0) {<br>
<br></span>
Additionally, have you considered to apply the mulitpathd -&gt; multipathd =
spelling fix in this patch as a separate patch?<br>
<br>
Thanks,<br>
<br>
Bart.<br>
</blockquote></div><br></div>

--001a11412e42c0b5ac053904daae--


--===============2321081846834766190==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2321081846834766190==--
