From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipathd/main.c: delete redundant judgment
	before LOG_MSG()
Date: Wed, 19 Oct 2016 08:00:10 +0200
Message-ID: <CABr-GndQRFYt2R1gpWQikAyWFYTgBoNHVJC4w3y=ALw3qEczVA@mail.gmail.com>
References: <1476781905-8584-1-git-send-email-li.minghui7@zte.com.cn>
	<20161018170238.GN1972@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8823389769063150794=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161018170238.GN1972@octiron.msp.redhat.com>
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
Cc: zhang.kai16@zte.com.cn, device-mapper development <dm-devel@redhat.com>, li.minghui7@zte.com.cn
List-Id: dm-devel.ids

--===============8823389769063150794==
Content-Type: multipart/alternative; boundary=001a113f188696bb3d053f318524

--001a113f188696bb3d053f318524
Content-Type: text/plain; charset=UTF-8

Merged.

On Tue, Oct 18, 2016 at 7:02 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Tue, Oct 18, 2016 at 05:11:45PM +0800, li.minghui7@zte.com.cn wrote:
> > From: "li.minghui" <li.minghui7@zte.com.cn>
> >
> > Problem:the LOG_MSG() doesn't note the path info "path offline" when the
> > path is in offline with the pp->offline = 1.
> >
> > Reasons:There is no need to judge the strlen(b) again before calling
> > LOG_MSG(a, b) because there exists the judgmnet of strlen(b) in
> > defination of LOG_MSG(a,b).
>
> ACK
>
> -Ben
>
> > ---
> >  multipathd/main.c | 9 +++------
> >  1 file changed, 3 insertions(+), 6 deletions(-)
> >
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index b6eb696..b147ca5 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -1454,8 +1454,7 @@ void repair_path(struct path * pp)
> >               return;
> >
> >       checker_repair(&pp->checker);
> > -     if (strlen(checker_message(&pp->checker)))
> > -             LOG_MSG(1, checker_message(&pp->checker));
> > +     LOG_MSG(1, checker_message(&pp->checker));
> >  }
> >
> >  /*
> > @@ -1590,8 +1589,7 @@ check_path (struct vectors * vecs, struct path *
> pp, int ticks)
> >               int oldstate = pp->state;
> >               pp->state = newstate;
> >
> > -             if (strlen(checker_message(&pp->checker)))
> > -                     LOG_MSG(1, checker_message(&pp->checker));
> > +             LOG_MSG(1, checker_message(&pp->checker));
> >
> >               /*
> >                * upon state change, reset the checkint
> > @@ -1703,8 +1701,7 @@ check_path (struct vectors * vecs, struct path *
> pp, int ticks)
> >                       pp->tick = pp->checkint;
> >               }
> >       }
> > -     else if (newstate == PATH_DOWN &&
> > -              strlen(checker_message(&pp->checker))) {
> > +     else if (newstate == PATH_DOWN) {
> >               int log_checker_err;
> >
> >               conf = get_multipath_config();
> > --
> > 2.8.1.windows.1
>

--001a113f188696bb3d053f318524
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.</div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Tue, Oct 18, 2016 at 7:02 PM, Benjamin Marzinski <span dir=
=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=3D"_blank">bmarz=
ins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><spa=
n class=3D"">On Tue, Oct 18, 2016 at 05:11:45PM +0800, <a href=3D"mailto:li=
.minghui7@zte.com.cn">li.minghui7@zte.com.cn</a> wrote:<br>
&gt; From: &quot;li.minghui&quot; &lt;<a href=3D"mailto:li.minghui7@zte.com=
.cn">li.minghui7@zte.com.cn</a>&gt;<br>
&gt;<br>
&gt; Problem:the LOG_MSG() doesn&#39;t note the path info &quot;path offlin=
e&quot; when the<br>
&gt; path is in offline with the pp-&gt;offline =3D 1.<br>
&gt;<br>
&gt; Reasons:There is no need to judge the strlen(b) again before calling<b=
r>
&gt; LOG_MSG(a, b) because there exists the judgmnet of strlen(b) in<br>
&gt; defination of LOG_MSG(a,b).<br>
<br>
</span>ACK<br>
<br>
-Ben<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; ---<br>
&gt;=C2=A0 multipathd/main.c | 9 +++------<br>
&gt;=C2=A0 1 file changed, 3 insertions(+), 6 deletions(-)<br>
&gt;<br>
&gt; diff --git a/multipathd/main.c b/multipathd/main.c<br>
&gt; index b6eb696..b147ca5 100644<br>
&gt; --- a/multipathd/main.c<br>
&gt; +++ b/multipathd/main.c<br>
&gt; @@ -1454,8 +1454,7 @@ void repair_path(struct path * pp)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0checker_repair(&amp;pp-&gt;checker);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (strlen(checker_message(&amp;pp-&gt;<wbr>check=
er)))<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LOG_MSG(1, checker_me=
ssage(&amp;pp-&gt;checker))<wbr>;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0LOG_MSG(1, checker_message(&amp;pp-&gt;checker))<=
wbr>;<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 /*<br>
&gt; @@ -1590,8 +1589,7 @@ check_path (struct vectors * vecs, struct path *=
 pp, int ticks)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int oldstate =3D=
 pp-&gt;state;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp-&gt;state =3D=
 newstate;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (strlen(checker_me=
ssage(&amp;pp-&gt;<wbr>checker)))<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0LOG_MSG(1, checker_message(&amp;pp-&gt;checker))<wbr>;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LOG_MSG(1, checker_me=
ssage(&amp;pp-&gt;checker))<wbr>;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * upon state ch=
ange, reset the checkint<br>
&gt; @@ -1703,8 +1701,7 @@ check_path (struct vectors * vecs, struct path *=
 pp, int ticks)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0pp-&gt;tick =3D pp-&gt;checkint;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; -=C2=A0 =C2=A0 =C2=A0else if (newstate =3D=3D PATH_DOWN &amp;&amp;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 strlen(checker_messa=
ge(&amp;pp-&gt;<wbr>checker))) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0else if (newstate =3D=3D PATH_DOWN) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int log_checker_=
err;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0conf =3D get_mul=
tipath_config();<br>
&gt; --<br>
&gt; 2.8.1.windows.1<br>
</div></div></blockquote></div><br></div>

--001a113f188696bb3d053f318524--


--===============8823389769063150794==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8823389769063150794==--
