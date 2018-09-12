From: Tommy Cumberland <tcumberland77@gmail.com>
Subject: Re: dm-devel Digest, Vol 175, Issue 9
Date: Wed, 12 Sep 2018 17:03:16 -0400
Message-ID: <CAEsKJHeKq0O2jYSBwo9hikj9HOtKqBAgYTvg0mqFFHP3F3Fovg@mail.gmail.com>
References: <mailman.73.1536768018.8296.dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3908718231989255213=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <mailman.73.1536768018.8296.dm-devel@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============3908718231989255213==
Content-Type: multipart/alternative; boundary="0000000000000405650575b2ec95"

--0000000000000405650575b2ec95
Content-Type: text/plain; charset="UTF-8"

Hi I am very new to this and am trying to learn because I'm very interested
in this. Is there anyway someone would help someone like me. Thank you

On Wed, Sep 12, 2018, 12:01 PM <dm-devel-request@redhat.com> wrote:

> Send dm-devel mailing list submissions to
>         dm-devel@redhat.com
>
> To subscribe or unsubscribe via the World Wide Web, visit
>         https://www.redhat.com/mailman/listinfo/dm-devel
> or, via email, send a message with subject or body 'help' to
>         dm-devel-request@redhat.com
>
> You can reach the person managing the list at
>         dm-devel-owner@redhat.com
>
> When replying, please edit your Subject line so it is more specific
> than "Re: Contents of dm-devel digest..."
>
>
> Today's Topics:
>
>    1. Re: [PATCH] libmultipath: Increase SERIAL_SIZE to 256 bytes
>       (Martin Wilck)
>
>
> ----------------------------------------------------------------------
>
> Message: 1
> Date: Wed, 12 Sep 2018 15:36:02 +0200
> From: Martin Wilck <mwilck@suse.com>
> To: KyleMahlkuch <kmahlkuc@linux.vnet.ibm.com>, dm-devel@redhat.com
> Subject: Re: [dm-devel] [PATCH] libmultipath: Increase SERIAL_SIZE to
>         256 bytes
> Message-ID: <f9c5e7fbc2136573a098b8aed475ce4eb7c0bf2a.camel@suse.com>
> Content-Type: text/plain; charset="UTF-8"
>
> On Tue, 2018-08-28 at 16:34 -0500, KyleMahlkuch wrote:
> > Certain IBM FlashSystem LUNs can return up to 85 bytes of serial
> > number in the Unit Serial Number VPD page, which is larger than
> > the current SERIAL_SIZE definition of 65 bytes. Since the max
> > size of this field does not appear to be defined in SPC, increasing
> > to 256 bytes should hopefully prevent us from hitting this
> > in future.
> >
>
> I'm not against it, but would 128 be enough, too? That's what we use
> for WWID.
>
> > This is an example of a serial number from a FlashSystem:
> > Unit serial number VPD page:
> > Unit serial number:
> > 3321360050764008101AB300000000000012204214503IBMfcp
>
> $ echo 3321360050764008101AB300000000000012204214503IBMfcp | wc -c
> 52
>
> It looks as if 65 bytes would be sufficient for _this_ serial number.
> Is there excessive space padding at the end, maybe? Run
>
> sg_vpd -p sn -r $DEV | hexdump -C
>
> >
> > Before this patch multipath returns the error:
> > Jul 17 11:24:58 | vpd pg80 overflow, 85/65 bytes required
> >
> > After the patch is applied the error no longer occur.
> >
> > Signed-off-by: Kyle Mahlkuch <kmahlkuc@linux.vnet.ibm.com>
> > ---
> >  libmultipath/structs.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Thanks,
> Martin
>
> --
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend?rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N?rnberg)
>
>
>
>
> ------------------------------
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
> End of dm-devel Digest, Vol 175, Issue 9
> ****************************************
>

--0000000000000405650575b2ec95
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Hi I am very new to this and am trying to learn because I=
&#39;m very interested in this. Is there anyway someone would help someone =
like me. Thank you</div><br><div class=3D"gmail_quote"><div dir=3D"ltr">On =
Wed, Sep 12, 2018, 12:01 PM  &lt;<a href=3D"mailto:dm-devel-request@redhat.=
com">dm-devel-request@redhat.com</a>&gt; wrote:<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">Send dm-devel mailing list submissions to<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 <a href=3D"mailto:dm-devel@redhat.com" target=
=3D"_blank" rel=3D"noreferrer">dm-devel@redhat.com</a><br>
<br>
To subscribe or unsubscribe via the World Wide Web, visit<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 <a href=3D"https://www.redhat.com/mailman/listi=
nfo/dm-devel" rel=3D"noreferrer noreferrer" target=3D"_blank">https://www.r=
edhat.com/mailman/listinfo/dm-devel</a><br>
or, via email, send a message with subject or body &#39;help&#39; to<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 <a href=3D"mailto:dm-devel-request@redhat.com" =
target=3D"_blank" rel=3D"noreferrer">dm-devel-request@redhat.com</a><br>
<br>
You can reach the person managing the list at<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 <a href=3D"mailto:dm-devel-owner@redhat.com" ta=
rget=3D"_blank" rel=3D"noreferrer">dm-devel-owner@redhat.com</a><br>
<br>
When replying, please edit your Subject line so it is more specific<br>
than &quot;Re: Contents of dm-devel digest...&quot;<br>
<br>
<br>
Today&#39;s Topics:<br>
<br>
=C2=A0 =C2=A01. Re: [PATCH] libmultipath: Increase SERIAL_SIZE to 256 bytes=
<br>
=C2=A0 =C2=A0 =C2=A0 (Martin Wilck)<br>
<br>
<br>
----------------------------------------------------------------------<br>
<br>
Message: 1<br>
Date: Wed, 12 Sep 2018 15:36:02 +0200<br>
From: Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com" target=3D"_blank"=
 rel=3D"noreferrer">mwilck@suse.com</a>&gt;<br>
To: KyleMahlkuch &lt;<a href=3D"mailto:kmahlkuc@linux.vnet.ibm.com" target=
=3D"_blank" rel=3D"noreferrer">kmahlkuc@linux.vnet.ibm.com</a>&gt;, <a href=
=3D"mailto:dm-devel@redhat.com" target=3D"_blank" rel=3D"noreferrer">dm-dev=
el@redhat.com</a><br>
Subject: Re: [dm-devel] [PATCH] libmultipath: Increase SERIAL_SIZE to<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 256 bytes<br>
Message-ID: &lt;<a href=3D"mailto:f9c5e7fbc2136573a098b8aed475ce4eb7c0bf2a.=
camel@suse.com" target=3D"_blank" rel=3D"noreferrer">f9c5e7fbc2136573a098b8=
aed475ce4eb7c0bf2a.camel@suse.com</a>&gt;<br>
Content-Type: text/plain; charset=3D&quot;UTF-8&quot;<br>
<br>
On Tue, 2018-08-28 at 16:34 -0500, KyleMahlkuch wrote:<br>
&gt; Certain IBM FlashSystem LUNs can return up to 85 bytes of serial<br>
&gt; number in the Unit Serial Number VPD page, which is larger than<br>
&gt; the current SERIAL_SIZE definition of 65 bytes. Since the max<br>
&gt; size of this field does not appear to be defined in SPC, increasing<br=
>
&gt; to 256 bytes should hopefully prevent us from hitting this<br>
&gt; in future.<br>
&gt; <br>
<br>
I&#39;m not against it, but would 128 be enough, too? That&#39;s what we us=
e<br>
for WWID.<br>
<br>
&gt; This is an example of a serial number from a FlashSystem:<br>
&gt; Unit serial number VPD page:<br>
&gt; Unit serial number:<br>
&gt; 3321360050764008101AB300000000000012204214503IBMfcp<br>
<br>
$ echo 3321360050764008101AB300000000000012204214503IBMfcp | wc -c<br>
52<br>
<br>
It looks as if 65 bytes would be sufficient for _this_ serial number.<br>
Is there excessive space padding at the end, maybe? Run<br>
<br>
sg_vpd -p sn -r $DEV | hexdump -C <br>
<br>
&gt; <br>
&gt; Before this patch multipath returns the error:<br>
&gt; Jul 17 11:24:58 | vpd pg80 overflow, 85/65 bytes required<br>
&gt; <br>
&gt; After the patch is applied the error no longer occur.<br>
&gt; <br>
&gt; Signed-off-by: Kyle Mahlkuch &lt;<a href=3D"mailto:kmahlkuc@linux.vnet=
.ibm.com" target=3D"_blank" rel=3D"noreferrer">kmahlkuc@linux.vnet.ibm.com<=
/a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 libmultipath/structs.h | 2 +-<br>
&gt;=C2=A0 1 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
Thanks,<br>
Martin=C2=A0 <br>
<br>
-- <br>
Dr. Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com" target=3D"_blank" r=
el=3D"noreferrer">mwilck@suse.com</a>&gt;, Tel. +49 (0)911 74053 2107<br>
SUSE Linux GmbH, GF: Felix Imend?rffer, Jane Smithard, Graham Norton<br>
HRB 21284 (AG N?rnberg)<br>
<br>
<br>
<br>
<br>
------------------------------<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank" rel=3D"noreferrer"=
>dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer noreferrer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/d=
m-devel</a><br>
<br>
End of dm-devel Digest, Vol 175, Issue 9<br>
****************************************<br>
</blockquote></div>

--0000000000000405650575b2ec95--


--===============3908718231989255213==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3908718231989255213==--
