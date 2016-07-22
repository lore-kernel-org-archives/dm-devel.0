From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/6] Delete attributes with default values
Date: Fri, 22 Jul 2016 11:52:40 +0200
Message-ID: <CABr-Gne+2HXVXGLQXv0_ECitYPnfSjnvbTKqGnVqjd-MirNiHg@mail.gmail.com>
References: <1468022328-5905-1-git-send-email-xose.vazquez@gmail.com>
	<CABr-GncP-rzeXogT1EFZTtFrre2UUSV6i-AJ27GZ3mTvcxx-7Q@mail.gmail.com>
	<20160713161734.GN8095@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1647383435421716797=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160713161734.GN8095@octiron.msp.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

--===============1647383435421716797==
Content-Type: multipart/alternative; boundary=001a11402e6439c5fc05383665a5

--001a11402e6439c5fc05383665a5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Ok.
All defaults settings tweaks and removal patches from Xos=C3=A9 are merged.

Thanks.


On Wed, Jul 13, 2016 at 6:17 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Sat, Jul 09, 2016 at 10:17:05AM +0200, Christophe Varoqui wrote:
> >    I'll wait for comments from distribution maintainers on this patchse=
t.
> >    Because, though we have already deleted the checker_name settings wh=
en
> >    equal to the default value, it should be clear that with this patchs=
et
> >    changing a default may cause re-certification for all impacted
> devices.
> >    This can be viewed as a problem for distributors.
> >    Hannes, Ben, do you ack this patchset ? If not, what do we do the
> >    checker_name settings, that I understood Hannes wanted to switch to
> TUR
> >    anyway.
>
> I'm fine with this.
>
> -Ben
>
> >    On Sat, Jul 9, 2016 at 1:58 AM, Xose Vazquez Perez
> >    <[1]xose.vazquez@gmail.com> wrote:
> >
> >      Xose Vazquez Perez (6):
> >        multipath-tools: delete attributes with DEFAULT_* values in
> hwtable.c
> >        multipath-tools: delete prio_args attribute when it is equal to
> >      default value
> >        multipath-tools: delete no_path_retry attribute when it is equal
> to
> >      default value
> >        multipath-tools: delete minio_rq attribute when it is equal to
> default
> >      value
> >        multipath-tools: delete fast_io_fail attribute when it is equal =
to
> >      default value
> >        multipath-tools: delete pgpolicy attribute when it is equal to
> default
> >      value
> >
> >       libmultipath/hwtable.c | 226
> >      -------------------------------------------------
> >       1 file changed, 226 deletions(-)
> >
> >      Cc: Christophe Varoqui <[2]christophe.varoqui@opensvc.com>
> >      Cc: device-mapper development <[3]dm-devel@redhat.com>
> >      Signed-off-by: Xose Vazquez Perez <[4]xose.vazquez@gmail.com>
> >
> >      --
> >      2.7.4
> >
> > References
> >
> >    Visible links
> >    1. mailto:xose.vazquez@gmail.com
> >    2. mailto:christophe.varoqui@opensvc.com
> >    3. mailto:dm-devel@redhat.com
> >    4. mailto:xose.vazquez@gmail.com
>
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
>
>

--001a11402e6439c5fc05383665a5
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Ok.<div>All defaults settings tweaks and removal patches f=
rom Xos=C3=A9 are merged.</div><div><br></div><div>Thanks.<br><div><br></di=
v></div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On =
Wed, Jul 13, 2016 at 6:17 PM, Benjamin Marzinski <span dir=3D"ltr">&lt;<a h=
ref=3D"mailto:bmarzins@redhat.com" target=3D"_blank">bmarzins@redhat.com</a=
>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 =
0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On S=
at, Jul 09, 2016 at 10:17:05AM +0200, Christophe Varoqui wrote:<br>
&gt;=C2=A0 =C2=A0 I&#39;ll wait for comments from distribution maintainers =
on this patchset.<br>
&gt;=C2=A0 =C2=A0 Because, though we have already deleted the checker_name =
settings when<br>
&gt;=C2=A0 =C2=A0 equal to the default value, it should be clear that with =
this patchset<br>
&gt;=C2=A0 =C2=A0 changing a default may cause re-certification for all imp=
acted devices.<br>
&gt;=C2=A0 =C2=A0 This can be viewed as a problem for distributors.<br>
&gt;=C2=A0 =C2=A0 Hannes, Ben, do you ack this patchset ? If not, what do w=
e do the<br>
&gt;=C2=A0 =C2=A0 checker_name settings, that I understood Hannes wanted to=
 switch to TUR<br>
&gt;=C2=A0 =C2=A0 anyway.<br>
<br>
</span>I&#39;m fine with this.<br>
<br>
-Ben<br>
<span class=3D""><br>
&gt;=C2=A0 =C2=A0 On Sat, Jul 9, 2016 at 1:58 AM, Xose Vazquez Perez<br>
</span><span class=3D"">&gt;=C2=A0 =C2=A0 &lt;[1]<a href=3D"mailto:xose.vaz=
quez@gmail.com">xose.vazquez@gmail.com</a>&gt; wrote:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 Xose Vazquez Perez (6):<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 multipath-tools: delete attributes with DEF=
AULT_* values in hwtable.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 multipath-tools: delete prio_args attribute=
 when it is equal to<br>
&gt;=C2=A0 =C2=A0 =C2=A0 default value<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 multipath-tools: delete no_path_retry attri=
bute when it is equal to<br>
&gt;=C2=A0 =C2=A0 =C2=A0 default value<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 multipath-tools: delete minio_rq attribute =
when it is equal to default<br>
&gt;=C2=A0 =C2=A0 =C2=A0 value<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 multipath-tools: delete fast_io_fail attrib=
ute when it is equal to<br>
&gt;=C2=A0 =C2=A0 =C2=A0 default value<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 multipath-tools: delete pgpolicy attribute =
when it is equal to default<br>
&gt;=C2=A0 =C2=A0 =C2=A0 value<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0libmultipath/hwtable.c | 226<br>
&gt;=C2=A0 =C2=A0 =C2=A0 -------------------------------------------------<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A01 file changed, 226 deletions(-)<br>
&gt;<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 Cc: Christophe Varoqui &lt;[2]<a href=3D"ma=
ilto:christophe.varoqui@opensvc.com">christophe.varoqui@opensvc.com</a>&gt;=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 Cc: device-mapper development &lt;[3]<a href=3D"ma=
ilto:dm-devel@redhat.com">dm-devel@redhat.com</a>&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 Signed-off-by: Xose Vazquez Perez &lt;[4]<a href=
=3D"mailto:xose.vazquez@gmail.com">xose.vazquez@gmail.com</a>&gt;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 --<br>
&gt;=C2=A0 =C2=A0 =C2=A0 2.7.4<br>
&gt;<br>
&gt; References<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 Visible links<br>
&gt;=C2=A0 =C2=A0 1. mailto:<a href=3D"mailto:xose.vazquez@gmail.com">xose.=
vazquez@gmail.com</a><br>
&gt;=C2=A0 =C2=A0 2. mailto:<a href=3D"mailto:christophe.varoqui@opensvc.co=
m">christophe.varoqui@opensvc.com</a><br>
&gt;=C2=A0 =C2=A0 3. mailto:<a href=3D"mailto:dm-devel@redhat.com">dm-devel=
@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 4. mailto:<a href=3D"mailto:xose.vazquez@gmail.com">xose.=
vazquez@gmail.com</a><br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; --<br>
&gt; dm-devel mailing list<br>
&gt; <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"no=
referrer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-deve=
l</a><br>
<br>
</div></div></blockquote></div><br></div>

--001a11402e6439c5fc05383665a5--


--===============1647383435421716797==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1647383435421716797==--
