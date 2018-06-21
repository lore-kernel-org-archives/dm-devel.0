From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: fix help for hds prio
Date: Thu, 21 Jun 2018 11:01:12 +0200
Message-ID: <CABr-GnenUmE-vBO_Ys2S1y6tAJiB9a4VkGC7d7y6Zf28JpOBOA@mail.gmail.com>
References: <20180521200355.27364-1-xose.vazquez@gmail.com>
	<2cc1bd1b-5f70-f5d1-46bb-17afebd105b1@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9163776093527552387=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2cc1bd1b-5f70-f5d1-46bb-17afebd105b1@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============9163776093527552387==
Content-Type: multipart/alternative; boundary="000000000000e54575056f232837"

--000000000000e54575056f232837
Content-Type: text/plain; charset="UTF-8"

Done, thanks.

On Thu, Jun 21, 2018 at 10:59 AM Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Hi Christophe,
>
> This one is missing.
>
> Thank you.
>
> On 05/21/2018 10:03 PM, Xose Vazquez Perez wrote:
> > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > Cc: DM-DEV ML <dm-devel@redhat.com>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > ---
> >  multipath/multipath.conf.5 | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> > index f689795..af5e109 100644
> > --- a/multipath/multipath.conf.5
> > +++ b/multipath/multipath.conf.5
> > @@ -8,7 +8,7 @@
> >  .\"
> >  .\"
> ----------------------------------------------------------------------------
> >  .
> > -.TH MULTIPATH.CONF 5 2017-08-18 Linux
> > +.TH MULTIPATH.CONF 5 2018-05-21 Linux
> >  .
> >  .
> >  .\"
> ----------------------------------------------------------------------------
> > @@ -309,7 +309,7 @@ Active/Standby mode exclusively.
> >  .TP
> >  .I hds
> >  (Hardware-dependent)
> > -Generate the path priority for Hitachi AMS 2000 and HUS 100 families of
> arrays.
> > +Generate the path priority for Hitachi AMS families of arrays other
> than AMS 2000.
> >  .TP
> >  .I random
> >  Generate a random priority between 1 and 10.
> >
>
>

--000000000000e54575056f232837
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Done, thanks.</div><br><div class=3D"gmail_quote"><div dir=
=3D"ltr">On Thu, Jun 21, 2018 at 10:59 AM Xose Vazquez Perez &lt;<a href=3D=
"mailto:xose.vazquez@gmail.com">xose.vazquez@gmail.com</a>&gt; wrote:<br></=
div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-lef=
t:1px #ccc solid;padding-left:1ex">Hi Christophe,<br>
<br>
This one is missing.<br>
<br>
Thank you.<br>
<br>
On 05/21/2018 10:03 PM, Xose Vazquez Perez wrote:<br>
&gt; Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensv=
c.com" target=3D"_blank">christophe.varoqui@opensvc.com</a>&gt;<br>
&gt; Cc: DM-DEV ML &lt;<a href=3D"mailto:dm-devel@redhat.com" target=3D"_bl=
ank">dm-devel@redhat.com</a>&gt;<br>
&gt; Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@g=
mail.com" target=3D"_blank">xose.vazquez@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 multipath/multipath.conf.5 | 4 ++--<br>
&gt;=C2=A0 1 file changed, 2 insertions(+), 2 deletions(-)<br>
&gt; <br>
&gt; diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5<b=
r>
&gt; index f689795..af5e109 100644<br>
&gt; --- a/multipath/multipath.conf.5<br>
&gt; +++ b/multipath/multipath.conf.5<br>
&gt; @@ -8,7 +8,7 @@<br>
&gt;=C2=A0 .\&quot;<br>
&gt;=C2=A0 .\&quot; -------------------------------------------------------=
---------------------<br>
&gt;=C2=A0 .<br>
&gt; -.TH MULTIPATH.CONF 5 2017-08-18 Linux<br>
&gt; +.TH MULTIPATH.CONF 5 2018-05-21 Linux<br>
&gt;=C2=A0 .<br>
&gt;=C2=A0 .<br>
&gt;=C2=A0 .\&quot; -------------------------------------------------------=
---------------------<br>
&gt; @@ -309,7 +309,7 @@ Active/Standby mode exclusively.<br>
&gt;=C2=A0 .TP<br>
&gt;=C2=A0 .I hds<br>
&gt;=C2=A0 (Hardware-dependent)<br>
&gt; -Generate the path priority for Hitachi AMS 2000 and HUS 100 families =
of arrays.<br>
&gt; +Generate the path priority for Hitachi AMS families of arrays other t=
han AMS 2000.<br>
&gt;=C2=A0 .TP<br>
&gt;=C2=A0 .I random<br>
&gt;=C2=A0 Generate a random priority between 1 and 10.<br>
&gt; <br>
<br>
</blockquote></div>

--000000000000e54575056f232837--


--===============9163776093527552387==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============9163776093527552387==--
