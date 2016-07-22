From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 2/3] multipath-tools: merge OPTFLAGS into
	CFLAGS
Date: Fri, 22 Jul 2016 11:43:39 +0200
Message-ID: <CABr-GndggX27px+4fczvw2+RGsFQ8RKpD=TELSxR7BYjdzE12Q@mail.gmail.com>
References: <1467995301-14226-1-git-send-email-xose.vazquez@gmail.com>
	<1467995301-14226-3-git-send-email-xose.vazquez@gmail.com>
	<2af5e805-8bfe-72dc-d476-1c0184b76720@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6753854398857782769=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2af5e805-8bfe-72dc-d476-1c0184b76720@suse.de>
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
Cc: Mathieu Trudel-Lapierre <mathieu.trudel-lapierre@canonical.com>, Dragan Stancevic <dragan.stancevic@canonical.com>, device-mapper development <dm-devel@redhat.com>, Ritesh Raj Sarraf <rrs@debian.org>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Louis Bouchard <louis.bouchard@canonical.com>
List-Id: dm-devel.ids

--===============6753854398857782769==
Content-Type: multipart/alternative; boundary=001a11410fecfeff68053836445d

--001a11410fecfeff68053836445d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Reverted.

On Fri, Jul 15, 2016 at 12:19 PM, Hannes Reinecke <hare@suse.de> wrote:

> On 07/08/2016 06:28 PM, Xose Vazquez Perez wrote:
> > OPTFLAGS is not used anywhere, but maybe it's intrusive for
> distributions.
> >
> > Cc: Mathieu Trudel-Lapierre <mathieu.trudel-lapierre@canonical.com>
> > Cc: Dragan Stancevic <dragan.stancevic@canonical.com>
> > Cc: Louis Bouchard <louis.bouchard@canonical.com>
> > Cc: Ritesh Raj Sarraf <rrs@debian.org>
> > Cc: Benjamin Marzinski <bmarzins@redhat.com>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > Cc: device-mapper development <dm-devel@redhat.com>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > ---
> >  Makefile.inc | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >
> > diff --git a/Makefile.inc b/Makefile.inc
> > index 01d743c..b7077fc 100644
> > --- a/Makefile.inc
> > +++ b/Makefile.inc
> > @@ -60,10 +60,9 @@ RM          =3D rm -f
> >  LN          =3D ln -sf
> >  INSTALL_PROGRAM =3D install
> >
> > -OPTFLAGS     =3D -Wunused -Wstrict-prototypes -O2 -g -pipe
> -Wformat-security -Wall \
> > -             -Wp,-D_FORTIFY_SOURCE=3D2 -fexceptions -fstack-protector
> --param=3Dssp-buffer-size=3D4
> > -
> > -CFLAGS            =3D $(OPTFLAGS) -fPIC -DLIB_STRING=3D\"${LIB}\"
> -DRUN_DIR=3D\"${RUN}\"
> > +CFLAGS      =3D -Wunused -Wstrict-prototypes -O2 -g -pipe
> -Wformat-security -Wall \
> > +             -Wp,-D_FORTIFY_SOURCE=3D2 -fexceptions -fstack-protector
> --param=3Dssp-buffer-size=3D4 \
> > +             -fPIC -DLIB_STRING=3D\"${LIB}\" -DRUN_DIR=3D\"${RUN}\"
> >  SHARED_FLAGS =3D -shared
> >
> >  %.o: %.c
> >
> Nope, doesn't work for us.
> Our buildsystem is using a distinct set of flags, which we need to use
> for the build process.
> At the same time we have no idea if there are other flags (like includes
> etc) which are required by the build itself.
>
> Please revert, this breaks our build.
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

--001a11410fecfeff68053836445d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Reverted.</div><div class=3D"gmail_extra"><br><div class=
=3D"gmail_quote">On Fri, Jul 15, 2016 at 12:19 PM, Hannes Reinecke <span di=
r=3D"ltr">&lt;<a href=3D"mailto:hare@suse.de" target=3D"_blank">hare@suse.d=
e</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margi=
n:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div class=3D"HOE=
nZb"><div class=3D"h5">On 07/08/2016 06:28 PM, Xose Vazquez Perez wrote:<br=
>
&gt; OPTFLAGS is not used anywhere, but maybe it&#39;s intrusive for distri=
butions.<br>
&gt;<br>
&gt; Cc: Mathieu Trudel-Lapierre &lt;<a href=3D"mailto:mathieu.trudel-lapie=
rre@canonical.com">mathieu.trudel-lapierre@canonical.com</a>&gt;<br>
&gt; Cc: Dragan Stancevic &lt;<a href=3D"mailto:dragan.stancevic@canonical.=
com">dragan.stancevic@canonical.com</a>&gt;<br>
&gt; Cc: Louis Bouchard &lt;<a href=3D"mailto:louis.bouchard@canonical.com"=
>louis.bouchard@canonical.com</a>&gt;<br>
&gt; Cc: Ritesh Raj Sarraf &lt;<a href=3D"mailto:rrs@debian.org">rrs@debian=
.org</a>&gt;<br>
&gt; Cc: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com">bmar=
zins@redhat.com</a>&gt;<br>
&gt; Cc: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.de">hare@suse.de</=
a>&gt;<br>
&gt; Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensv=
c.com">christophe.varoqui@opensvc.com</a>&gt;<br>
&gt; Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.co=
m">dm-devel@redhat.com</a>&gt;<br>
&gt; Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@g=
mail.com">xose.vazquez@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 Makefile.inc | 7 +++----<br>
&gt;=C2=A0 1 file changed, 3 insertions(+), 4 deletions(-)<br>
&gt;<br>
&gt; diff --git a/Makefile.inc b/Makefile.inc<br>
&gt; index 01d743c..b7077fc 100644<br>
&gt; --- a/Makefile.inc<br>
&gt; +++ b/Makefile.inc<br>
&gt; @@ -60,10 +60,9 @@ RM=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D rm -f<br>
&gt;=C2=A0 LN=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D ln -sf<br>
&gt;=C2=A0 INSTALL_PROGRAM =3D install<br>
&gt;<br>
&gt; -OPTFLAGS=C2=A0 =C2=A0 =C2=A0=3D -Wunused -Wstrict-prototypes -O2 -g -=
pipe -Wformat-security -Wall \<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-Wp,-D_FORTIFY_SOURCE=
=3D2 -fexceptions -fstack-protector --param=3Dssp-buffer-size=3D4<br>
&gt; -<br>
&gt; -CFLAGS=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D $(OPTFLAGS) -fPIC=
 -DLIB_STRING=3D\&quot;${LIB}\&quot; -DRUN_DIR=3D\&quot;${RUN}\&quot;<br>
&gt; +CFLAGS=C2=A0 =C2=A0 =C2=A0 =3D -Wunused -Wstrict-prototypes -O2 -g -p=
ipe -Wformat-security -Wall \<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-Wp,-D_FORTIFY_SOURCE=
=3D2 -fexceptions -fstack-protector --param=3Dssp-buffer-size=3D4 \<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-fPIC -DLIB_STRING=3D=
\&quot;${LIB}\&quot; -DRUN_DIR=3D\&quot;${RUN}\&quot;<br>
&gt;=C2=A0 SHARED_FLAGS =3D -shared<br>
&gt;<br>
&gt;=C2=A0 %.o: %.c<br>
&gt;<br>
</div></div>Nope, doesn&#39;t work for us.<br>
Our buildsystem is using a distinct set of flags, which we need to use<br>
for the build process.<br>
At the same time we have no idea if there are other flags (like includes<br=
>
etc) which are required by the build itself.<br>
<br>
Please revert, this breaks our build.<br>
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

--001a11410fecfeff68053836445d--


--===============6753854398857782769==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6753854398857782769==--
