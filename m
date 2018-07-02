From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipathd: fix mpp->hwe handling on path
	removal
Date: Mon, 2 Jul 2018 12:05:52 +0200
Message-ID: <CABr-GndXjnbDqp8AYFEoPZf8ckkFe-R2SPL4QBrCR+ujUKaj3g@mail.gmail.com>
References: <20180625151020.31927-1-mwilck@suse.com>
	<4ccf2557dd0cc5a84d6f009b8afbbd345b58ff15.camel@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7785029190490291146=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4ccf2557dd0cc5a84d6f009b8afbbd345b58ff15.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============7785029190490291146==
Content-Type: multipart/alternative; boundary="000000000000761c040570015843"

--000000000000761c040570015843
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Right, done.
The leftover from your previous v3 patchset is merged too.
Thanks,
Christophe.

On Mon, Jul 2, 2018 at 11:33 AM Martin Wilck <mwilck@suse.com> wrote:

> Christophe,
>
> without this patch, current upstream multipath _crashes_ on path
> removal. Please apply it. If reviewers disagree with this fix, I can
> post updates later.
>
> Martin
>
> On Mon, 2018-06-25 at 17:10 +0200, Martin Wilck wrote:
> > In my previous patch f0462f0c8338, I overlooked that during path
> > removal,
> > the path that mpp->hwe references may be removed and and thus mpp-
> > >hwe
> > may become stale. Fix it.
> >
> > Fixes: f0462f0c8338 "libmultipath: use vector for for pp->hwe and mp-
> > >hwe"
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  multipathd/main.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 72f06b56..cc493c18 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -1076,6 +1076,14 @@ ev_remove_path (struct path *pp, struct
> > vectors * vecs, int need_do_map)
> >                               mpp->alias);
> >                       goto fail;
> >               }
> > +
> > +             /*
> > +              * Make sure mpp->hwe doesn't point to freed memory
> > +              * We call extract_hwe_from_path() below to restore
> > mpp->hwe
> > +              */
> > +             if (mpp->hwe =3D=3D pp->hwe)
> > +                     mpp->hwe =3D NULL;
> > +
> >               if ((i =3D find_slot(mpp->paths, (void *)pp)) !=3D -1)
> >                       vector_del_slot(mpp->paths, i);
> >
> > @@ -1109,6 +1117,9 @@ ev_remove_path (struct path *pp, struct vectors
> > * vecs, int need_do_map)
> >                        */
> >               }
> >
> > +             if (mpp->hwe =3D=3D NULL)
> > +                     extract_hwe_from_path(mpp);
> > +
> >               if (setup_map(mpp, params, PARAMS_SIZE, vecs)) {
> >                       condlog(0, "%s: failed to setup map for"
> >                               " removal of path %s", mpp->alias,
> > pp->dev);
>
> --
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=C3=BCrnberg)
>
>

--000000000000761c040570015843
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Right, done.<div>The leftover from your previous v3 patchs=
et is merged too.</div><div>Thanks,</div><div>Christophe.</div></div><br><d=
iv class=3D"gmail_quote"><div dir=3D"ltr">On Mon, Jul 2, 2018 at 11:33 AM M=
artin Wilck &lt;<a href=3D"mailto:mwilck@suse.com">mwilck@suse.com</a>&gt; =
wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8e=
x;border-left:1px #ccc solid;padding-left:1ex">Christophe,<br>
<br>
without this patch, current upstream multipath _crashes_ on path<br>
removal. Please apply it. If reviewers disagree with this fix, I can<br>
post updates later.<br>
<br>
Martin<br>
<br>
On Mon, 2018-06-25 at 17:10 +0200, Martin Wilck wrote:<br>
&gt; In my previous patch f0462f0c8338, I overlooked that during path<br>
&gt; removal,<br>
&gt; the path that mpp-&gt;hwe references may be removed and and thus mpp-<=
br>
&gt; &gt;hwe<br>
&gt; may become stale. Fix it.<br>
&gt; <br>
&gt; Fixes: f0462f0c8338 &quot;libmultipath: use vector for for pp-&gt;hwe =
and mp-<br>
&gt; &gt;hwe&quot;<br>
&gt; Signed-off-by: Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com" tar=
get=3D"_blank">mwilck@suse.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 multipathd/main.c | 11 +++++++++++<br>
&gt;=C2=A0 1 file changed, 11 insertions(+)<br>
&gt; <br>
&gt; diff --git a/multipathd/main.c b/multipathd/main.c<br>
&gt; index 72f06b56..cc493c18 100644<br>
&gt; --- a/multipathd/main.c<br>
&gt; +++ b/multipathd/main.c<br>
&gt; @@ -1076,6 +1076,14 @@ ev_remove_path (struct path *pp, struct<br>
&gt; vectors * vecs, int need_do_map)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mpp-&gt;alias);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0goto fail;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Make sure mpp-&gt;=
hwe doesn&#39;t point to freed memory<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * We call extract_hw=
e_from_path() below to restore<br>
&gt; mpp-&gt;hwe<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mpp-&gt;hwe =3D=
=3D pp-&gt;hwe)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0mpp-&gt;hwe =3D NULL;<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((i =3D find_=
slot(mpp-&gt;paths, (void *)pp)) !=3D -1)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0vector_del_slot(mpp-&gt;paths, i);<br>
&gt;=C2=A0 <br>
&gt; @@ -1109,6 +1117,9 @@ ev_remove_path (struct path *pp, struct vectors<=
br>
&gt; * vecs, int need_do_map)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 <br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mpp-&gt;hwe =3D=
=3D NULL)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0extract_hwe_from_path(mpp);<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (setup_map(mp=
p, params, PARAMS_SIZE, vecs)) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0condlog(0, &quot;%s: failed to setup map for&quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot; removal of path %s&quot;, m=
pp-&gt;alias,<br>
&gt; pp-&gt;dev);<br>
<br>
-- <br>
Dr. Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com" target=3D"_blank">m=
wilck@suse.com</a>&gt;, Tel. +49 (0)911 74053 2107<br>
SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton<b=
r>
HRB 21284 (AG N=C3=BCrnberg)<br>
<br>
</blockquote></div>

--000000000000761c040570015843--


--===============7785029190490291146==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7785029190490291146==--
