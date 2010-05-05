From: Rodrigo Nascimento <nascimento.rp@gmail.com>
Subject: Re: Question about WWID
Date: Wed, 5 May 2010 01:03:00 -0300
Message-ID: <x2taf7b4eb21005042103mddd51b48mcee9844c646b1bc3@mail.gmail.com>
References: <o2zaf7b4eb21004301216s726e4e82x8de50d0fa21469d@mail.gmail.com>
	<4BDEAFB0.8000609@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3458434403732627749=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BDEAFB0.8000609@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============3458434403732627749==
Content-Type: multipart/alternative; boundary=0016e6464126eb66450485d0e6e1

--0016e6464126eb66450485d0e6e1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi All,

Thanks Dr. Hannes Reinecke.

After read some docs, I found out this information about the WWID:

- Its origin is the VPD Pages;
- It's a NAA (Network Address Authority) identifier;
- As a NAA identifier it is unique because its format is:
      3 + 6(from NAA 6) + IEEE Company_id + Vendor Specific Identifier +
Vendor Specific Identifier Extension

+ =3D=3D concatenated

Please, if it is not correct tell me.

Thanks and Regards,

Nascimento

On Mon, May 3, 2010 at 8:12 AM, Hannes Reinecke <hare@suse.de> wrote:

> Rodrigo Nascimento wrote:
> > Hi All,
> >
> > How the WWID from dm-mp is generated? I can image that it use serial
> > number of the disk, but how it is really generated?
> >
> It is using the SCSI Inquiry VPD pages; page 0x83 or, failing that, path
> 0x80.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                   zSeries & Storage
> hare@suse.de                          +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>



--=20
Rodrigo Nascimento
Storage System Engineer
(13) 8805-5892

http://stortech.wordpress.com

--0016e6464126eb66450485d0e6e1
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi All,<br><br>Thanks Dr. Hannes Reinecke.<br><br>After read some docs, I f=
ound out this information about the WWID:<br><br>- Its origin is the VPD Pa=
ges;<br>- It&#39;s a NAA (Network Address Authority) identifier;<br>- As a =
NAA identifier it is unique because its format is:<br>
=A0=A0=A0=A0=A0 3 + 6(from NAA 6) + IEEE Company_id + Vendor Specific Ident=
ifier + Vendor Specific Identifier Extension<br><br>+ =3D=3D concatenated<b=
r><br>Please, if it is not correct tell me.<br><br>Thanks and Regards,<br><=
br>Nascimento<br>
<br><div class=3D"gmail_quote">On Mon, May 3, 2010 at 8:12 AM, Hannes Reine=
cke <span dir=3D"ltr">&lt;<a href=3D"mailto:hare@suse.de">hare@suse.de</a>&=
gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin: 0pt=
 0pt 0pt 0.8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1e=
x;">
<div class=3D"im">Rodrigo Nascimento wrote:<br>
&gt; Hi All,<br>
&gt;<br>
&gt; How the WWID from dm-mp is generated? I can image that it use serial<b=
r>
&gt; number of the disk, but how it is really generated?<br>
&gt;<br>
</div>It is using the SCSI Inquiry VPD pages; page 0x83 or, failing that, p=
ath 0x80.<br>
<br>
Cheers,<br>
<br>
Hannes<br>
--<br>
Dr. Hannes Reinecke =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zSeries &amp; Stora=
ge<br>
<a href=3D"mailto:hare@suse.de">hare@suse.de</a> =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0+49 911 74053 688<br>
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg<br>
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)<br>
<font color=3D"#888888"><br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</font></blockquote></div><br><br clear=3D"all"><br>-- <br>Rodrigo Nascimen=
to<br>Storage System Engineer<br>(13) 8805-5892<br><br><a href=3D"http://st=
ortech.wordpress.com">http://stortech.wordpress.com</a><br>

--0016e6464126eb66450485d0e6e1--


--===============3458434403732627749==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3458434403732627749==--
