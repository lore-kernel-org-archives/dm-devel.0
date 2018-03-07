From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: add info about how to get a
 release directly from gitweb
Date: Wed, 7 Mar 2018 15:26:42 +0100
Message-ID: <CABr-GneBYksBfgLOZ7Ce3UuL=73FDM8FTLVggPFDifooy8H3QA@mail.gmail.com>
References: <20180112165641.4130-1-xose.vazquez@gmail.com>
	<0250db8d-05af-903a-7e5e-b7cb7113b359@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0258370448930597864=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0250db8d-05af-903a-7e5e-b7cb7113b359@gmail.com>
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

--===============0258370448930597864==
Content-Type: multipart/alternative; boundary="94eb2c05baaa2a33750566d359f7"

--94eb2c05baaa2a33750566d359f7
Content-Type: text/plain; charset="UTF-8"

Thanks, applied.

On Wed, Mar 7, 2018 at 2:28 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> On 01/12/2018 05:56 PM, Xose Vazquez Perez wrote:
>
> > gitweb is able to extract and serve a release right away.
>
> This one is missing.
>
> > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > Cc: device-mapper development <dm-devel@redhat.com>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > ---
> >  README | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/README b/README
> > index 570224d..89bab74 100644
> > --- a/README
> > +++ b/README
> > @@ -20,7 +20,8 @@ git archive --format=tar.gz
> --prefix=multipath-tools-X.Y.Z/ X.Y.Z > ../multipath
> >
> >  Alternatively it may be obtained from gitweb, go to:
> >  https://git.opensvc.com/?p=multipath-tools/.git;a=tags
> > -select a release-tag and then click on "snapshot".
> > +select a release-tag and then click on "snapshot". Or get it with
> > +wget "https://git.opensvc.com/?p=multipath-tools/.git;a=
> snapshot;sf=tgz;h=refs/tags/X.Y.Z" -O multipath-tools-X.Y.Z.tar.gz
> >
> >
> >  Source code
> >
>
>

--94eb2c05baaa2a33750566d359f7
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks, applied.</div><div class=3D"gmail_extra"><br><div =
class=3D"gmail_quote">On Wed, Mar 7, 2018 at 2:28 PM, Xose Vazquez Perez <s=
pan dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_bl=
ank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"g=
mail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-l=
eft:1ex"><span class=3D"">On 01/12/2018 05:56 PM, Xose Vazquez Perez wrote:=
<br>
<br>
&gt; gitweb is able to extract and serve a release right away.<br>
<br>
</span>This one is missing.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensv=
c.com">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
&gt; Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.co=
m">dm-devel@redhat.com</a>&gt;<br>
&gt; Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@g=
mail.com">xose.vazquez@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 README | 3 ++-<br>
&gt;=C2=A0 1 file changed, 2 insertions(+), 1 deletion(-)<br>
&gt;<br>
&gt; diff --git a/README b/README<br>
&gt; index 570224d..89bab74 100644<br>
&gt; --- a/README<br>
&gt; +++ b/README<br>
&gt; @@ -20,7 +20,8 @@ git archive --format=3Dtar.gz --prefix=3Dmultipath-t=
ools-X.Y.<wbr>Z/ X.Y.Z &gt; ../multipath<br>
&gt;<br>
&gt;=C2=A0 Alternatively it may be obtained from gitweb, go to:<br>
&gt;=C2=A0 <a href=3D"https://git.opensvc.com/?p=3Dmultipath-tools/.git;a=
=3Dtags" rel=3D"noreferrer" target=3D"_blank">https://git.opensvc.com/?p=3D=
<wbr>multipath-tools/.git;a=3Dtags</a><br>
&gt; -select a release-tag and then click on &quot;snapshot&quot;.<br>
&gt; +select a release-tag and then click on &quot;snapshot&quot;. Or get i=
t with<br>
&gt; +wget &quot;<a href=3D"https://git.opensvc.com/?p=3Dmultipath-tools/.g=
it;a=3Dsnapshot;sf=3Dtgz;h=3Drefs/tags/X.Y.Z" rel=3D"noreferrer" target=3D"=
_blank">https://git.opensvc.com/?p=3D<wbr>multipath-tools/.git;a=3D<wbr>sna=
pshot;sf=3Dtgz;h=3Drefs/tags/X.<wbr>Y.Z</a>&quot; -O multipath-tools-X.Y.Z.=
tar.gz<br>
&gt;<br>
&gt;<br>
&gt;=C2=A0 Source code<br>
&gt;<br>
<br>
</div></div></blockquote></div><br></div>

--94eb2c05baaa2a33750566d359f7--


--===============0258370448930597864==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0258370448930597864==--
