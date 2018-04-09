From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 1/2] multipath-tools: move COPYING to
	COPYING.LESSER
Date: Mon, 9 Apr 2018 22:38:58 +0200
Message-ID: <CABr-GneDAcFMVJKfrLJX6fBe5F-e-G_Sh_f1XvSwFH-0umM1Ew@mail.gmail.com>
References: <20180327182819.20163-1-xose.vazquez@gmail.com>
	<1523289440.3525.27.camel@suse.com>
	<9ad33b55-17fc-9ed9-ca11-2be0e11a7b1f@gmail.com>
	<1523300890.3525.55.camel@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0730156583121522645=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1523300890.3525.55.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

--===============0730156583121522645==
Content-Type: multipart/alternative; boundary="001a114a15ae3ca778056970658b"

--001a114a15ae3ca778056970658b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Martin is right, the LGPL COPYING was added Sun May 1 15:05:22 2005.
Every file added to the tree since then and up to Xose patch switching
COPYING to GPL, and not explicitely licensed otherwise can be assumed to be
covered by the LGPL.
It was not intended to relicense any files, nor switch to GPL as the
default license for new files without explicit licensing.

Hope it clears the history part of the mess, and helps identify a solution.

I see FSF recommends the COPYING+COPYING.LESSER file names, as Xose
implemented. What if we just add a LICENSE file stating that files with no
explicit copying* reference fall under the COPYING.LESSER ?


On Mon, Apr 9, 2018 at 9:08 PM, Martin Wilck <mwilck@suse.com> wrote:

> On Mon, 2018-04-09 at 19:29 +0200, Xose Vazquez Perez wrote:
> > On 04/09/2018 05:57 PM, Martin Wilck wrote:
> >
> > > There are >130 files in the multipath-tools source code which don't
> > > have a license header. So far my *assumption* was that these files
> > > were
> > > covered by COPYING, which used to be LGPLv2.0.
> >
> > They are under their _original_ licence. Nothing was changed inside
> > the files.
>
> Would you care to enlighten me what this "original license" might be?
> The files themselves contain no information about it.
>
> > > By changing COPYING to
> > > GPLv2.0, you effectively changed the license of all these files
> > > from
> > > LPGLv2.0 to GPLv2.0
> >
> > There is no evidence of that in any place. All references to the
> > COPYING file are
> > external files/code, with GPL licence.
>
> This is not about the files you refer to. The reference in those files
> was obiously wrong until your patch was merged. (I admit that's a +1
> for your patch).
>
> This is about the files that have *no license header*. We *must* assume
> that they are covered by a central license file in the top directory.
> If we don't do that, it'd be questionable if said files are
> distributable at all. Legally, they'd probably not be considered FLOSS.
> Files without explicit copyright are be covered by regular copyright
> law, meaning that copying and redistribution are _not_ allowed under
> most legislations.
>
> I hope that makes it clear why we need to be firm that these files are
> covered by the top license file. That central license file used to be
> COPYING. The point of my post was that we have *two* such files now,
> and without resorting to history it's impossible to tell which file is
> covered by which license (and even with history it's hard, but that's
> another posting).
>
> Historically, these files were added to the tree by Christophe, and
> he'd copied the LGPLv2.0 text into COPYING, thus it seems likely that
> he meant them to be under LGPLv2.0.
>
> Martin
>
> --
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=C3=BCrnberg)
>
>

--001a114a15ae3ca778056970658b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Martin is right, the LGPL COPYING was added=C2=A0Sun May 1=
 15:05:22 2005.<div>Every file added to the tree since then and up to Xose =
patch switching COPYING to GPL, and not explicitely licensed otherwise can =
be assumed to be covered by the LGPL.</div><div>It was not intended to reli=
cense any files, nor switch to GPL as the default license for new files wit=
hout explicit licensing.</div><div><br></div><div>Hope it clears the histor=
y part of the mess, and helps identify a solution.</div><div><br></div><div=
>I see FSF recommends the COPYING+COPYING.LESSER file names, as Xose implem=
ented. What if we just add a LICENSE file stating that files with no explic=
it copying* reference fall under the=C2=A0<span style=3D"color:rgb(34,34,34=
);font-family:arial,sans-serif;font-size:small;font-style:normal;font-varia=
nt-ligatures:normal;font-variant-caps:normal;font-weight:400;letter-spacing=
:normal;text-align:start;text-indent:0px;text-transform:none;white-space:no=
rmal;word-spacing:0px;background-color:rgb(255,255,255);text-decoration-sty=
le:initial;text-decoration-color:initial;float:none;display:inline">COPYING=
.LESSER ?</span></div><div><br></div></div><div class=3D"gmail_extra"><br><=
div class=3D"gmail_quote">On Mon, Apr 9, 2018 at 9:08 PM, Martin Wilck <spa=
n dir=3D"ltr">&lt;<a href=3D"mailto:mwilck@suse.com" target=3D"_blank">mwil=
ck@suse.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span c=
lass=3D"">On Mon, 2018-04-09 at 19:29 +0200, Xose Vazquez Perez wrote:<br>
&gt; On 04/09/2018 05:57 PM, Martin Wilck wrote:<br>
&gt;<br>
&gt; &gt; There are &gt;130 files in the multipath-tools source code which =
don&#39;t<br>
&gt; &gt; have a license header. So far my *assumption* was that these file=
s<br>
&gt; &gt; were<br>
&gt; &gt; covered by COPYING, which used to be LGPLv2.0.<br>
&gt;<br>
&gt; They are under their _original_ licence. Nothing was changed inside<br=
>
&gt; the files.<br>
<br>
</span>Would you care to enlighten me what this &quot;original license&quot=
; might be?<br>
The files themselves contain no information about it.<br>
<span class=3D""><br>
&gt; &gt; By changing COPYING to<br>
&gt; &gt; GPLv2.0, you effectively changed the license of all these files<b=
r>
&gt; &gt; from<br>
&gt; &gt; LPGLv2.0 to GPLv2.0<br>
&gt;<br>
&gt; There is no evidence of that in any place. All references to the<br>
&gt; COPYING file are<br>
&gt; external files/code, with GPL licence.<br>
<br>
</span>This is not about the files you refer to. The reference in those fil=
es<br>
was obiously wrong until your patch was merged. (I admit that&#39;s a +1<br=
>
for your patch).<br>
<br>
This is about the files that have *no license header*. We *must* assume<br>
that they are covered by a central license file in the top directory.<br>
If we don&#39;t do that, it&#39;d be questionable if said files are<br>
distributable at all. Legally, they&#39;d probably not be considered FLOSS.=
<br>
Files without explicit copyright are be covered by regular copyright<br>
law, meaning that copying and redistribution are _not_ allowed under<br>
most legislations.<br>
<br>
I hope that makes it clear why we need to be firm that these files are<br>
covered by the top license file. That central license file used to be<br>
COPYING. The point of my post was that we have *two* such files now,<br>
and without resorting to history it&#39;s impossible to tell which file is<=
br>
covered by which license (and even with history it&#39;s hard, but that&#39=
;s<br>
another posting).<br>
<br>
Historically, these files were added to the tree by Christophe, and<br>
he&#39;d copied the LGPLv2.0 text into COPYING, thus it seems likely that<b=
r>
he meant them to be under LGPLv2.0.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Martin<br>
</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
--<br>
Dr. Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com">mwilck@suse.com</a>=
&gt;, Tel. +49 (0)911 74053 2107<br>
SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton<b=
r>
HRB 21284 (AG N=C3=BCrnberg)<br>
<br>
</div></div></blockquote></div><br></div>

--001a114a15ae3ca778056970658b--


--===============0730156583121522645==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0730156583121522645==--
