From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH Debian] kpartx: increase retries was Re: Next
	release plans?
Date: Wed, 11 May 2016 19:36:29 +0200
Message-ID: <CABr-GnfZ0zA1Ld5bDo=AVE0gbmTLc0eJp6buiTDL3J298zDU7g@mail.gmail.com>
References: <561531AF.4080907@gmail.com> <570BDA57.7040606@gmail.com>
	<CABr-Gnfgz=upeMOUuMSPTXMqLojqOxEfub7GEd0rAjDZ1F3Z6w@mail.gmail.com>
	<7daddb85-3de7-9015-35fd-2e535f707f7a@gmail.com>
	<1461066476.4833.40.camel@debian.org>
	<05bfcd42-5a72-35c6-d4a7-8b44b130b63b@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5685512293345692891=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <05bfcd42-5a72-35c6-d4a7-8b44b130b63b@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Ricky Goldsmith <rrs@debian.org>, device-mapper development <dm-devel@redhat.com>, Mathieu Trudel-Lapierre <mathieu.tl@gmail.com>
List-Id: dm-devel.ids

--===============5685512293345692891==
Content-Type: multipart/alternative; boundary=001a113ec3fe52ee450532947bc3

--001a113ec3fe52ee450532947bc3
Content-Type: text/plain; charset=UTF-8

Merged, thanks.

On Tue, May 10, 2016 at 6:39 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> On 04/19/2016 01:47 PM, Ritesh Raj Sarraf wrote:
>
> > In Debian, we don't have much delta. The only minor (1 liner) patch I see
> > carrying is:
> >
> > rrs@learner:~/.rrs-home/Community/Packaging/multipath-tools (master)$
> cat
> > debian/patches/increase-kpartx-retries.patch
> > https://www.redhat.com/archives/dm-devel/2015-May/msg00087.html
> >
> > Many users have reported that increasing the retries solves the problem
> >
> > https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=785251
> > https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=734794
> > https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=608737
> > Index: multipath-tools/kpartx/lopart.c
> > ===================================================================
> > --- multipath-tools.orig/kpartx/lopart.c      2015-10-16
> 21:33:27.235438304
> > +0530
> > +++ multipath-tools/kpartx/lopart.c   2015-10-16 21:33:27.231438251 +0530
> > @@ -296,7 +296,7 @@
> >  extern int
> >  del_loop (const char *device)
> >  {
> > -     int retries = 3;
> > +     int retries = 5;
> >       int fd;
> >
> >       if ((fd = open (device, O_RDONLY)) < 0) {
> >
>
> This patch also was lost.
>

--001a113ec3fe52ee450532947bc3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged, thanks.</div><div class=3D"gmail_extra"><br><div c=
lass=3D"gmail_quote">On Tue, May 10, 2016 at 6:39 PM, Xose Vazquez Perez <s=
pan dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_bl=
ank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"g=
mail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-l=
eft:1ex">On 04/19/2016 01:47 PM, Ritesh Raj Sarraf wrote:<br>
<br>
&gt; In Debian, we don&#39;t have much delta. The only minor (1 liner) patc=
h I see<br>
&gt; carrying is:<br>
&gt;<br>
&gt; rrs@learner:~/.rrs-home/Community/Packaging/multipath-tools (master)$ =
cat<br>
&gt; debian/patches/increase-kpartx-retries.patch<br>
&gt; <a href=3D"https://www.redhat.com/archives/dm-devel/2015-May/msg00087.=
html" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.com/archives/=
dm-devel/2015-May/msg00087.html</a><br>
&gt;<br>
&gt; Many users have reported that increasing the retries solves the proble=
m<br>
&gt;<br>
&gt; <a href=3D"https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D785251"=
 rel=3D"noreferrer" target=3D"_blank">https://bugs.debian.org/cgi-bin/bugre=
port.cgi?bug=3D785251</a><br>
&gt; <a href=3D"https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D734794"=
 rel=3D"noreferrer" target=3D"_blank">https://bugs.debian.org/cgi-bin/bugre=
port.cgi?bug=3D734794</a><br>
&gt; <a href=3D"https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D608737"=
 rel=3D"noreferrer" target=3D"_blank">https://bugs.debian.org/cgi-bin/bugre=
port.cgi?bug=3D608737</a><br>
&gt; Index: multipath-tools/kpartx/lopart.c<br>
&gt; =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
&gt; --- multipath-tools.orig/kpartx/lopart.c=C2=A0 =C2=A0 =C2=A0 2015-10-1=
6 21:33:27.235438304<br>
&gt; +0530<br>
&gt; +++ multipath-tools/kpartx/lopart.c=C2=A0 =C2=A02015-10-16 21:33:27.23=
1438251 +0530<br>
&gt; @@ -296,7 +296,7 @@<br>
&gt;=C2=A0 extern int<br>
&gt;=C2=A0 del_loop (const char *device)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0int retries =3D 3;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int retries =3D 5;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int fd;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if ((fd =3D open (device, O_RDONLY)) &lt; 0)=
 {<br>
&gt;<br>
<br>
This patch also was lost.<br>
</blockquote></div><br></div>

--001a113ec3fe52ee450532947bc3--


--===============5685512293345692891==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5685512293345692891==--
