From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: release lock on handler
	failure
Date: Mon, 17 Oct 2016 10:33:05 +0200
Message-ID: <CABr-GncJjpWCGcwqY8-wzf8VE6F3045OumUgypYrHpAPToQMxg@mail.gmail.com>
References: <a822c1be-b984-b47b-7418-48d5cf069801@profitbricks.com>
	<f8227018-ea94-19b4-4bd8-5eb9e38f90c2@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8930659427548845516=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f8227018-ea94-19b4-4bd8-5eb9e38f90c2@profitbricks.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Michael Wang <yun.wang@profitbricks.com>
Cc: device-mapper development <dm-devel@redhat.com>, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

--===============8930659427548845516==
Content-Type: multipart/alternative; boundary=001a11401702cd1b1d053f0b6c87

--001a11401702cd1b1d053f0b6c87
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.


On Mon, Oct 17, 2016 at 10:02 AM, Michael Wang <yun.wang@profitbricks.com>
wrote:

> Dear maintainer, is this patch looks fine to you?
>
> Regards,
> Michael Wang
>
> On 10/12/2016 10:54 AM, Michael Wang wrote:
> >
> > Inside parse_cmd() the pthread_cleanup_pop() rely on '!r' as the
> > indicator of locked or not, while this will be overwritten if the
> > handler return failed, and the unlock will be missing.
> >
> > This will lead into the situation that all the following operation
> > will trying to hold a lock which will never be released.
> >
> > This patch using a separate flag to record the status of locking to
> > make sure the unlock and lock are in pairs.
> >
> > Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
> > ---
> >  multipathd/cli.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/multipathd/cli.c b/multipathd/cli.c
> > index e8a9384..50161be 100644
> > --- a/multipathd/cli.c
> > +++ b/multipathd/cli.c
> > @@ -481,6 +481,7 @@ parse_cmd (char * cmd, char ** reply, int * len,
> void * data, int timeout )
> >                 tmo.tv_sec = 0;
> >         }
> >         if (h->locked) {
> > +               int locked = 0;
> >                 struct vectors * vecs = (struct vectors *)data;
> >
> >                 pthread_cleanup_push(cleanup_lock, &vecs->lock);
> > @@ -491,10 +492,11 @@ parse_cmd (char * cmd, char ** reply, int * len,
> void * data, int timeout )
> >                         r = 0;
> >                 }
> >                 if (r == 0) {
> > +                       locked = 1;
> >                         pthread_testcancel();
> >                         r = h->fn(cmdvec, reply, len, data);
> >                 }
> > -               pthread_cleanup_pop(!r);
> > +               pthread_cleanup_pop(locked);
> >         } else
> >                 r = h->fn(cmdvec, reply, len, data);
> >         free_keys(cmdvec);
> >
>

--001a11401702cd1b1d053f0b6c87
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div><div><br></div></div><div class=
=3D"gmail_extra"><br><div class=3D"gmail_quote">On Mon, Oct 17, 2016 at 10:=
02 AM, Michael Wang <span dir=3D"ltr">&lt;<a href=3D"mailto:yun.wang@profit=
bricks.com" target=3D"_blank">yun.wang@profitbricks.com</a>&gt;</span> wrot=
e:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-l=
eft:1px #ccc solid;padding-left:1ex">Dear maintainer, is this patch looks f=
ine to you?<br>
<br>
Regards,<br>
Michael Wang<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
On 10/12/2016 10:54 AM, Michael Wang wrote:<br>
&gt;<br>
&gt; Inside parse_cmd() the pthread_cleanup_pop() rely on &#39;!r&#39; as t=
he<br>
&gt; indicator of locked or not, while this will be overwritten if the<br>
&gt; handler return failed, and the unlock will be missing.<br>
&gt;<br>
&gt; This will lead into the situation that all the following operation<br>
&gt; will trying to hold a lock which will never be released.<br>
&gt;<br>
&gt; This patch using a separate flag to record the status of locking to<br=
>
&gt; make sure the unlock and lock are in pairs.<br>
&gt;<br>
&gt; Signed-off-by: Michael Wang &lt;<a href=3D"mailto:yun.wang@profitbrick=
s.com">yun.wang@profitbricks.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 multipathd/cli.c | 4 +++-<br>
&gt;=C2=A0 1 file changed, 3 insertions(+), 1 deletion(-)<br>
&gt;<br>
&gt; diff --git a/multipathd/cli.c b/multipathd/cli.c<br>
&gt; index e8a9384..50161be 100644<br>
&gt; --- a/multipathd/cli.c<br>
&gt; +++ b/multipathd/cli.c<br>
&gt; @@ -481,6 +481,7 @@ parse_cmd (char * cmd, char ** reply, int * len, v=
oid * data, int timeout )<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tmo.tv_se=
c =3D 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (h-&gt;locked) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int locked =3D=
 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ve=
ctors * vecs =3D (struct vectors *)data;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_c=
leanup_push(cleanup_<wbr>lock, &amp;vecs-&gt;lock);<br>
&gt; @@ -491,10 +492,11 @@ parse_cmd (char * cmd, char ** reply, int * len,=
 void * data, int timeout )<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0r =3D 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (r =3D=
=3D 0) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0locked =3D 1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0pthread_testcancel();<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0r =3D h-&gt;fn(cmdvec, reply, len, data);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_cleanu=
p_pop(!r);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_cleanu=
p_pop(locked);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D h-&=
gt;fn(cmdvec, reply, len, data);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0free_keys(cmdvec);<br>
&gt;<br>
</div></div></blockquote></div><br></div>

--001a11401702cd1b1d053f0b6c87--


--===============8930659427548845516==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8930659427548845516==--
