From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] mpathpersist.8: add missing documentation
 for -K, -C, -l
Date: Wed, 21 Jun 2017 12:25:12 +0200
Message-ID: <CABr-GnfvFYdE2wz6voO_c6B3uUUJgn=AALRxS7jSw+-AphUKbA@mail.gmail.com>
References: <20170522221643.18826-1-mwilck@suse.com>
	<20170620224306.GL2940@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0699835743880574443=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170620224306.GL2940@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

--===============0699835743880574443==
Content-Type: multipart/alternative; boundary="001a1137db7c8cfae5055275c82f"

--001a1137db7c8cfae5055275c82f
Content-Type: text/plain; charset="UTF-8"

Merged,
Thanks.

On Wed, Jun 21, 2017 at 12:43 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Tue, May 23, 2017 at 12:16:43AM +0200, Martin Wilck wrote:
>
> ACK
>
> -Ben
>
> > Furthermore, add a reference to the sg_persist man page.
> > ---
> >  mpathpersist/mpathpersist.8 | 21 ++++++++++++++++++++-
> >  1 file changed, 20 insertions(+), 1 deletion(-)
> >
> > diff --git a/mpathpersist/mpathpersist.8 b/mpathpersist/mpathpersist.8
> > index 4b15666f..a8982e65 100644
> > --- a/mpathpersist/mpathpersist.8
> > +++ b/mpathpersist/mpathpersist.8
> > @@ -34,6 +34,12 @@ attribute must be defined in the
> \fI/etc/multipath.conf\fR file. Otherwise the
> >  \fBmultipathd\fR daemon will not check for persistent reservation for
> newly
> >  discovered paths or reinstated paths.
> >  .
> > +.LP
> > +\fBmpathpersist\fR supports the same command-line options as the
> > +\fBsg_persist\fR utility.
> > +.
> > +Consult the \fBsg_persist (8)\fR manual page for an in-depth discussion
> of the
> > +various options.
> >  .
> >  .\" ------------------------------------------------------------
> ----------------
> >  .SH OPTIONS
> > @@ -89,6 +95,10 @@ PR Out parameter 'APTPL'.
> >  PR In: Read Keys.
> >  .
> >  .TP
> > +.BI \--param-rk=\fIRK\fB|\-K " RK"
> > +PR Out parameter reservation key (RK is in hex, up to 8 bytes).
> > +.
> > +.TP
> >  .BI \--param-sark=\fISARK\fB|\-S " SARK"
> >  PR Out parameter service action reservation key (SARK is in hex).
> >  .
> > @@ -97,6 +107,10 @@ PR Out parameter service action reservation key
> (SARK is in hex).
> >  PR Out: Preempt.
> >  .
> >  .TP
> > +.B \--clear|\-C
> > +PR Out: Clear registrations.
> > +.
> > +.TP
> >  .B \--preempt-abort|\-A
> >  PR Out: Preempt and Abort.
> >  .
> > @@ -140,6 +154,10 @@ PR Out: Reserve.
> >  .BI \--transport-id=\fITIDS\fB|\-X " TIDS"
> >  TransportIDs can be mentioned in several forms.
> >  .
> > +.TP
> > +.BI \--alloc-length=\fILEN\fB|\-l " LEN"
> > +PR In: maximum allocation length. LEN is a decimal number between 0 and
> 8192.
> > +.
> >  .
> >  .\" ------------------------------------------------------------
> ----------------
> >  .SH EXAMPLE
> > @@ -164,7 +182,8 @@ Read the reservation status of the
> /dev/mapper/mpath9 device:
> >  .\" ------------------------------------------------------------
> ----------------
> >  .
> >  .BR multipath (8),
> > -.BR multipathd (8).
> > +.BR multipathd (8),
> > +.BR sg_persist (8).
> >  .
> >  .
> >  .\" ------------------------------------------------------------
> ----------------
> > --
> > 2.12.2
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a1137db7c8cfae5055275c82f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged,<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Wed, Jun 21, 2017 at 12:43 AM, Benjamin M=
arzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" targe=
t=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">On Tue, May 23, 2017 at 12:16:43AM +0200, Martin Wilck wrote:=
<br>
<br>
ACK<br>
<br>
-Ben<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; Furthermore, add a reference to the sg_persist man page.<br>
&gt; ---<br>
&gt;=C2=A0 mpathpersist/mpathpersist.8 | 21 ++++++++++++++++++++-<br>
&gt;=C2=A0 1 file changed, 20 insertions(+), 1 deletion(-)<br>
&gt;<br>
&gt; diff --git a/mpathpersist/mpathpersist.8 b/mpathpersist/mpathpersist.8=
<br>
&gt; index 4b15666f..a8982e65 100644<br>
&gt; --- a/mpathpersist/mpathpersist.8<br>
&gt; +++ b/mpathpersist/mpathpersist.8<br>
&gt; @@ -34,6 +34,12 @@ attribute must be defined in the \fI/etc/multipath.=
conf\fR file. Otherwise the<br>
&gt;=C2=A0 \fBmultipathd\fR daemon will not check for persistent reservatio=
n for newly<br>
&gt;=C2=A0 discovered paths or reinstated paths.<br>
&gt;=C2=A0 .<br>
&gt; +.LP<br>
&gt; +\fBmpathpersist\fR supports the same command-line options as the<br>
&gt; +\fBsg_persist\fR utility.<br>
&gt; +.<br>
&gt; +Consult the \fBsg_persist (8)\fR manual page for an in-depth discussi=
on of the<br>
&gt; +various options.<br>
&gt;=C2=A0 .<br>
&gt;=C2=A0 .\&quot; ------------------------------<wbr>--------------------=
----------<wbr>----------------<br>
&gt;=C2=A0 .SH OPTIONS<br>
&gt; @@ -89,6 +95,10 @@ PR Out parameter &#39;APTPL&#39;.<br>
&gt;=C2=A0 PR In: Read Keys.<br>
&gt;=C2=A0 .<br>
&gt;=C2=A0 .TP<br>
&gt; +.BI \--param-rk=3D\fIRK\fB|\-K &quot; RK&quot;<br>
&gt; +PR Out parameter reservation key (RK is in hex, up to 8 bytes).<br>
&gt; +.<br>
&gt; +.TP<br>
&gt;=C2=A0 .BI \--param-sark=3D\fISARK\fB|\-S &quot; SARK&quot;<br>
&gt;=C2=A0 PR Out parameter service action reservation key (SARK is in hex)=
.<br>
&gt;=C2=A0 .<br>
&gt; @@ -97,6 +107,10 @@ PR Out parameter service action reservation key (S=
ARK is in hex).<br>
&gt;=C2=A0 PR Out: Preempt.<br>
&gt;=C2=A0 .<br>
&gt;=C2=A0 .TP<br>
&gt; +.B \--clear|\-C<br>
&gt; +PR Out: Clear registrations.<br>
&gt; +.<br>
&gt; +.TP<br>
&gt;=C2=A0 .B \--preempt-abort|\-A<br>
&gt;=C2=A0 PR Out: Preempt and Abort.<br>
&gt;=C2=A0 .<br>
&gt; @@ -140,6 +154,10 @@ PR Out: Reserve.<br>
&gt;=C2=A0 .BI \--transport-id=3D\fITIDS\fB|\-X &quot; TIDS&quot;<br>
&gt;=C2=A0 TransportIDs can be mentioned in several forms.<br>
&gt;=C2=A0 .<br>
&gt; +.TP<br>
&gt; +.BI \--alloc-length=3D\fILEN\fB|\-l &quot; LEN&quot;<br>
&gt; +PR In: maximum allocation length. LEN is a decimal number between 0 a=
nd 8192.<br>
&gt; +.<br>
&gt;=C2=A0 .<br>
&gt;=C2=A0 .\&quot; ------------------------------<wbr>--------------------=
----------<wbr>----------------<br>
&gt;=C2=A0 .SH EXAMPLE<br>
&gt; @@ -164,7 +182,8 @@ Read the reservation status of the /dev/mapper/mpa=
th9 device:<br>
&gt;=C2=A0 .\&quot; ------------------------------<wbr>--------------------=
----------<wbr>----------------<br>
&gt;=C2=A0 .<br>
&gt;=C2=A0 .BR multipath (8),<br>
&gt; -.BR multipathd (8).<br>
&gt; +.BR multipathd (8),<br>
&gt; +.BR sg_persist (8).<br>
&gt;=C2=A0 .<br>
&gt;=C2=A0 .<br>
&gt;=C2=A0 .\&quot; ------------------------------<wbr>--------------------=
----------<wbr>----------------<br>
&gt; --<br>
&gt; 2.12.2<br>
&gt;<br>
</div></div><span class=3D"HOEnZb"><font color=3D"#888888">&gt; --<br>
&gt; dm-devel mailing list<br>
&gt; <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"no=
referrer" target=3D"_blank">https://www.redhat.com/<wbr>mailman/listinfo/dm=
-devel</a><br>
</font></span></blockquote></div><br></div>

--001a1137db7c8cfae5055275c82f--


--===============0699835743880574443==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0699835743880574443==--
