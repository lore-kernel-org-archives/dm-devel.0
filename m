From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: Replace multipath
	configuration output
Date: Wed, 21 Jun 2017 12:33:08 +0200
Message-ID: <CABr-GnceAUBh5U1MYwCdDvnQkfOACVqeWanZfrdXOpWJad6wDw@mail.gmail.com>
References: <20170418000756.13970-1-xose.vazquez@gmail.com>
	<1a35a769-0d7d-7ed7-17b8-1d8c5093059a@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1481861977396785200=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1a35a769-0d7d-7ed7-17b8-1d8c5093059a@gmail.com>
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

--===============1481861977396785200==
Content-Type: multipart/alternative; boundary="001a1137db7ce800c9055275e4cc"

--001a1137db7ce800c9055275e4cc
Content-Type: text/plain; charset="UTF-8"

Merged,
Thanks.

On Thu, May 18, 2017 at 2:06 AM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> On 04/18/2017 02:07 AM, Xose Vazquez Perez wrote:
>
> > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > Cc: device-mapper development <dm-devel@redhat.com>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>
> This is missing.
>
> > ---
> >  libmultipath/propsel.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> > index 09fe728..782f039 100644
> > --- a/libmultipath/propsel.c
> > +++ b/libmultipath/propsel.c
> > @@ -286,11 +286,11 @@ out:
> >               if (mp->no_path_retry == NO_PATH_RETRY_UNDEF)
> >                       mp->no_path_retry = NO_PATH_RETRY_QUEUE;
> >               else if (mp->no_path_retry == NO_PATH_RETRY_FAIL) {
> > -                     condlog(1, "%s: config error, overriding
> 'no_path_retry' value",
> > +                     condlog(1, "%s: config ERROR (setting: overriding
> 'no_path_retry' value)",
> >                               mp->alias);
> >                       mp->no_path_retry = NO_PATH_RETRY_QUEUE;
> >               } else if (mp->no_path_retry != NO_PATH_RETRY_QUEUE)
> > -                     condlog(1, "%s: config error, ignoring
> 'queue_if_no_path' because no_path_retry=%d",
> > +                     condlog(1, "%s: config ERROR (setting: ignoring
> 'queue_if_no_path' because no_path_retry = %d)",
> >                               mp->alias, mp->no_path_retry);
> >       }
> >       return 0;
> > @@ -470,7 +470,7 @@ out:
> >               condlog(3, "%s: no_path_retry = %s %s", mp->alias, buff,
> >                       origin);
> >       else if (mp->no_path_retry != NO_PATH_RETRY_UNDEF)
> > -             condlog(3, "%s: no_path_retry = %s (inherited setting)",
> > +             condlog(3, "%s: no_path_retry = %s (setting: inherited
> value)",
> >                       mp->alias, buff);
> >       else
> >               condlog(3, "%s: no_path_retry = undef (setting: multipath
> internal)",
> >
>
>

--001a1137db7ce800c9055275e4cc
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged,<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Thu, May 18, 2017 at 2:06 AM, Xose Vazque=
z Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" tar=
get=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex"><span class=3D"">On 04/18/2017 02:07 AM, Xose Vazquez Pe=
rez wrote:<br>
<br>
&gt; Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensv=
c.com">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
&gt; Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.co=
m">dm-devel@redhat.com</a>&gt;<br>
&gt; Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@g=
mail.com">xose.vazquez@gmail.com</a>&gt;<br>
<br>
</span>This is missing.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; ---<br>
&gt;=C2=A0 libmultipath/propsel.c | 6 +++---<br>
&gt;=C2=A0 1 file changed, 3 insertions(+), 3 deletions(-)<br>
&gt;<br>
&gt; diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c<br>
&gt; index 09fe728..782f039 100644<br>
&gt; --- a/libmultipath/propsel.c<br>
&gt; +++ b/libmultipath/propsel.c<br>
&gt; @@ -286,11 +286,11 @@ out:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mp-&gt;no_pa=
th_retry =3D=3D NO_PATH_RETRY_UNDEF)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0mp-&gt;no_path_retry =3D NO_PATH_RETRY_QUEUE;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else if (mp-&gt;=
no_path_retry =3D=3D NO_PATH_RETRY_FAIL) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0condlog(1, &quot;%s: config error, overriding &#39;no_path_retry&#39=
; value&quot;,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0condlog(1, &quot;%s: config ERROR (setting: overriding &#39;no_path_=
retry&#39; value)&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mp-&gt;alias);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0mp-&gt;no_path_retry =3D NO_PATH_RETRY_QUEUE;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (mp-&g=
t;no_path_retry !=3D NO_PATH_RETRY_QUEUE)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0condlog(1, &quot;%s: config error, ignoring &#39;queue_if_no_path&#3=
9; because no_path_retry=3D%d&quot;,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0condlog(1, &quot;%s: config ERROR (setting: ignoring &#39;queue_if_n=
o_path&#39; because no_path_retry =3D %d)&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mp-&gt;alias, mp-&gt;no_path_retry=
);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; @@ -470,7 +470,7 @@ out:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot=
;%s: no_path_retry =3D %s %s&quot;, mp-&gt;alias, buff,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0origin);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0else if (mp-&gt;no_path_retry !=3D NO_PATH_R=
ETRY_UNDEF)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s: =
no_path_retry =3D %s (inherited setting)&quot;,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s: =
no_path_retry =3D %s (setting: inherited value)&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0mp-&gt;alias, buff);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0else<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot=
;%s: no_path_retry =3D undef (setting: multipath internal)&quot;,<br>
&gt;<br>
<br>
</div></div></blockquote></div><br></div>

--001a1137db7ce800c9055275e4cc--


--===============1481861977396785200==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1481861977396785200==--
