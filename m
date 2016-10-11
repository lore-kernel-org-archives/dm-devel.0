From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: remove hwhandler when it's
	alua
Date: Tue, 11 Oct 2016 08:43:54 +0200
Message-ID: <CABr-GnfVSt3A_sGpJMwmQ4nJi879bNuQmkHtS_9L_UCYzaO6pw@mail.gmail.com>
References: <20161006185021.3625-1-xose.vazquez@gmail.com>
	<CABr-GnfHUoWn_q4LfvhDeF6w_vPcMg8VRjEN98quZ6+oes1Ryw@mail.gmail.com>
	<1d46912b-0cad-89e4-2bd6-2b4c9e3fe67f@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2658944274282494110=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1d46912b-0cad-89e4-2bd6-2b4c9e3fe67f@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

--===============2658944274282494110==
Content-Type: multipart/alternative; boundary=94eb2c0c8ea24b9071053e913363

--94eb2c0c8ea24b9071053e913363
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Right,

so Xos=C3=A9, can you confirm the last introduced hwtable entries don't nee=
d the
alua hwhandler :
- nexsan
- tegile
- nimble
- nfinidat

Thanks.

On Tue, Oct 11, 2016 at 8:22 AM, Hannes Reinecke <hare@suse.de> wrote:

> On 10/11/2016 08:02 AM, Christophe Varoqui wrote:
> > I'm not comfortable with this patch that induces a less predictable
> > behaviour.
> > We have that retain hardware handler switch that users can activate to
> > achieve the purpose.
> >
> > Hannes, Ben, would you support that patch ?
> >
> > Best Regards,
> > Christophe
> >
> Please don't apply this.
> Autodetection will only work if the hardware handler is loaded.
> If the handler is _not_ loaded autodetection won't work, either.
> And if we add this patch multipath will never load the modules, neither.
>
> So we need this functionality as a fallback if autodetect does not work.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Teamlead Storage & Networking
> hare@suse.de                                   +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=C3=BCrnberg)
>

--94eb2c0c8ea24b9071053e913363
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Right,<div><br></div><div>so Xos=C3=A9, can you confirm th=
e last introduced hwtable entries don&#39;t need the alua hwhandler :</div>=
<div>- nexsan</div><div>- tegile</div><div>- nimble</div><div>- nfinidat</d=
iv><div><br></div><div>Thanks.</div></div><div class=3D"gmail_extra"><br><d=
iv class=3D"gmail_quote">On Tue, Oct 11, 2016 at 8:22 AM, Hannes Reinecke <=
span dir=3D"ltr">&lt;<a href=3D"mailto:hare@suse.de" target=3D"_blank">hare=
@suse.de</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span cl=
ass=3D"">On 10/11/2016 08:02 AM, Christophe Varoqui wrote:<br>
&gt; I&#39;m not comfortable with this patch that induces a less predictabl=
e<br>
&gt; behaviour.<br>
&gt; We have that retain hardware handler switch that users can activate to=
<br>
&gt; achieve the purpose.<br>
&gt;<br>
&gt; Hannes, Ben, would you support that patch ?<br>
&gt;<br>
&gt; Best Regards,<br>
&gt; Christophe<br>
&gt;<br>
</span>Please don&#39;t apply this.<br>
Autodetection will only work if the hardware handler is loaded.<br>
If the handler is _not_ loaded autodetection won&#39;t work, either.<br>
And if we add this patch multipath will never load the modules, neither.<br=
>
<br>
So we need this functionality as a fallback if autodetect does not work.<br=
>
<br>
Cheers,<br>
<br>
Hannes<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dr. Hannes Reinecke=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
Teamlead Storage &amp; Networking<br>
<a href=3D"mailto:hare@suse.de">hare@suse.de</a>=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0<a href=3D"tel:%2B49%20911%2074053%20688" value=3D"=
+4991174053688">+49 911 74053 688</a><br>
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg<br>
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton<br>
HRB 21284 (AG N=C3=BCrnberg)<br>
</font></span></blockquote></div><br></div>

--94eb2c0c8ea24b9071053e913363--


--===============2658944274282494110==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2658944274282494110==--
