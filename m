From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] kpartx: recognize DASD on loop devices again
Date: Mon, 8 Jul 2019 17:00:59 +0200
Message-ID: <CABr-GneBCSpOFSiUbLLgasDaCYtQbyxCyAYc1VkHr7qbi+=iBw@mail.gmail.com>
References: <20190628192911.18192-1-martin.wilck@suse.com>
	<20190708142636.GP3251@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1977894634206848060=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190708142636.GP3251@octiron.msp.redhat.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

--===============1977894634206848060==
Content-Type: multipart/alternative; boundary="000000000000f27b22058d2cb611"

--000000000000f27b22058d2cb611
Content-Type: text/plain; charset="UTF-8"

Thanks for the review.

Martin, can you post a rebased version of this patch ?

Thanks,
Christophe

On Mon, Jul 8, 2019 at 4:27 PM Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Fri, Jun 28, 2019 at 07:29:41PM +0000, Martin Wilck wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >
> > Since 4d57b868, DASD partition tables are only recognized on
> > DASD hardware. This turns out to break certain software that works
> > e.g. with DASD partition tables on loop devices. The problem that
> > 4d57b868 attempted to fix was that "unlabeled disk" format has
> > no signature at all and is detected on any volume, including
> > empty ones.
> >
> > With this patch, DASD partition table formats other than "unlabeled
> > disk" are detected on non-DASD devices again.
> >
> > Fixes: 4d57b868 "kpartx: only recognize dasd part table on DASD"
>
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
>
> > ---
> >  kpartx/dasd.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/kpartx/dasd.c b/kpartx/dasd.c
> > index 61b609a5..3fcef6ad 100644
> > --- a/kpartx/dasd.c
> > +++ b/kpartx/dasd.c
> > @@ -133,9 +133,6 @@ read_dasd_pt(int fd, struct slice all, struct slice
> *sp, int ns)
> >                       /* Couldn't open the device */
> >                       return -1;
> >               }
> > -     } else if ((unsigned int)major(sbuf.st_rdev) != 94) {
> > -                     /* Not a DASD */
> > -                     return -1;
> >       } else {
> >               fd_dasd = dup(fd);
> >       }
> > @@ -277,6 +274,10 @@ read_dasd_pt(int fd, struct slice all, struct slice
> *sp, int ns)
> >                       size = disksize;
> >                       if (fmt_size < size)
> >                               size = fmt_size;
> > +             } else if ((unsigned int)major(sbuf.st_rdev) != 94) {
> > +                     /* Not a DASD */
> > +                     retval = -1;
> > +                     goto out;
> >               } else
> >                       size = disksize;
> >
> > --
> > 2.21.0
> >
>

--000000000000f27b22058d2cb611
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Thanks for the review.</div><div><br></div>Martin, ca=
n you post a rebased version of this patch ?<div><br></div><div>Thanks,</di=
v><div>Christophe</div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr=
" class=3D"gmail_attr">On Mon, Jul 8, 2019 at 4:27 PM Benjamin Marzinski &l=
t;<a href=3D"mailto:bmarzins@redhat.com">bmarzins@redhat.com</a>&gt; wrote:=
<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8=
ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">On Fri, Jun 28,=
 2019 at 07:29:41PM +0000, Martin Wilck wrote:<br>
&gt; From: Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com" target=3D"_b=
lank">mwilck@suse.com</a>&gt;<br>
&gt; <br>
&gt; Since 4d57b868, DASD partition tables are only recognized on<br>
&gt; DASD hardware. This turns out to break certain software that works<br>
&gt; e.g. with DASD partition tables on loop devices. The problem that<br>
&gt; 4d57b868 attempted to fix was that &quot;unlabeled disk&quot; format h=
as<br>
&gt; no signature at all and is detected on any volume, including<br>
&gt; empty ones.<br>
&gt; <br>
&gt; With this patch, DASD partition table formats other than &quot;unlabel=
ed<br>
&gt; disk&quot; are detected on non-DASD devices again.<br>
&gt; <br>
&gt; Fixes: 4d57b868 &quot;kpartx: only recognize dasd part table on DASD&q=
uot;<br>
<br>
Reviewed-by: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com" =
target=3D"_blank">bmarzins@redhat.com</a>&gt;<br>
<br>
&gt; ---<br>
&gt;=C2=A0 kpartx/dasd.c | 7 ++++---<br>
&gt;=C2=A0 1 file changed, 4 insertions(+), 3 deletions(-)<br>
&gt; <br>
&gt; diff --git a/kpartx/dasd.c b/kpartx/dasd.c<br>
&gt; index 61b609a5..3fcef6ad 100644<br>
&gt; --- a/kpartx/dasd.c<br>
&gt; +++ b/kpartx/dasd.c<br>
&gt; @@ -133,9 +133,6 @@ read_dasd_pt(int fd, struct slice all, struct slic=
e *sp, int ns)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0/* Couldn&#39;t open the device */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return -1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; -=C2=A0 =C2=A0 =C2=A0} else if ((unsigned int)major(sbuf.st_rdev) !=3D=
 94) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0/* Not a DASD */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0return -1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fd_dasd =3D dup(=
fd);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; @@ -277,6 +274,10 @@ read_dasd_pt(int fd, struct slice all, struct sli=
ce *sp, int ns)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0size =3D disksize;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0if (fmt_size &lt; size)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0size =3D fmt_size;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else if ((unsigned =
int)major(sbuf.st_rdev) !=3D 94) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0/* Not a DASD */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0retval =3D -1;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0goto out;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0size =3D disksize;<br>
&gt;=C2=A0 <br>
&gt; -- <br>
&gt; 2.21.0<br>
&gt; <br>
</blockquote></div>

--000000000000f27b22058d2cb611--


--===============1977894634206848060==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1977894634206848060==--
