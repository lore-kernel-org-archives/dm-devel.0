From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 2/2] libmultipath: don't update path queueing
	on reload
Date: Sat, 13 Jan 2018 10:18:42 +0100
Message-ID: <CABr-Gnfnp3tiuBE4hAN7ciC9+x_sLrYV1kK_CZyXhS8R9OQ3Bg@mail.gmail.com>
References: <1513188487-31852-1-git-send-email-bmarzins@redhat.com>
	<1513188487-31852-2-git-send-email-bmarzins@redhat.com>
	<1513604950.22953.24.camel@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3922785515317552485=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1513604950.22953.24.camel@suse.com>
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

--===============3922785515317552485==
Content-Type: multipart/alternative; boundary="001a1147bba01280c10562a4de7e"

--001a1147bba01280c10562a4de7e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied.
Thanks

On Mon, Dec 18, 2017 at 2:49 PM, Martin Wilck <mwilck@suse.com> wrote:

> On Wed, 2017-12-13 at 12:08 -0600, Benjamin Marzinski wrote:
> > With the fix to the features handling code, the multipath device
> > should
> > already be reloaded with the correct value for queue_if_no_path, so
> > there's no need to go reset it immediately afterwards.
> >
> > Cc: Martin Wilck <mwilck@suse.com>
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/configure.c | 6 ------
> >  1 file changed, 6 deletions(-)
> >
> > diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> > index bfa5048..6f28f45 100644
> > --- a/libmultipath/configure.c
> > +++ b/libmultipath/configure.c
> > @@ -1351,12 +1351,6 @@ int reload_map(struct vectors *vecs, struct
> > multipath *mpp, int refresh,
> >                       "for reload map", mpp->alias, r);
> >               return 1;
> >       }
> > -     if (mpp->no_path_retry !=3D NO_PATH_RETRY_UNDEF) {
> > -             if (mpp->no_path_retry =3D=3D NO_PATH_RETRY_FAIL)
> > -                     dm_queue_if_no_path(mpp->alias, 0);
> > -             else
> > -                     dm_queue_if_no_path(mpp->alias, 1);
> > -     }
> >
> >       return 0;
> >  }
> ACK
>
> --
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=C3=BCrnberg)
>
>

--001a1147bba01280c10562a4de7e
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<div>Thanks</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Mon, Dec 18, 2017 at 2:49 PM, Martin Wilc=
k <span dir=3D"ltr">&lt;<a href=3D"mailto:mwilck@suse.com" target=3D"_blank=
">mwilck@suse.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote=
" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><=
div class=3D"HOEnZb"><div class=3D"h5">On Wed, 2017-12-13 at 12:08 -0600, B=
enjamin Marzinski wrote:<br>
&gt; With the fix to the features handling code, the multipath device<br>
&gt; should<br>
&gt; already be reloaded with the correct value for queue_if_no_path, so<br=
>
&gt; there&#39;s no need to go reset it immediately afterwards.<br>
&gt;<br>
&gt; Cc: Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com">mwilck@suse.co=
m</a>&gt;<br>
&gt; Signed-off-by: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redha=
t.com">bmarzins@redhat.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 libmultipath/configure.c | 6 ------<br>
&gt;=C2=A0 1 file changed, 6 deletions(-)<br>
&gt;<br>
&gt; diff --git a/libmultipath/configure.c b/libmultipath/configure.c<br>
&gt; index bfa5048..6f28f45 100644<br>
&gt; --- a/libmultipath/configure.c<br>
&gt; +++ b/libmultipath/configure.c<br>
&gt; @@ -1351,12 +1351,6 @@ int reload_map(struct vectors *vecs, struct<br>
&gt; multipath *mpp, int refresh,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0&quot;for reload map&quot;, mpp-&gt;alias, r);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (mpp-&gt;no_path_retry !=3D NO_PATH_RETRY_UNDE=
F) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mpp-&gt;no_path_r=
etry =3D=3D NO_PATH_RETRY_FAIL)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0dm_queue_if_no_path(mpp-&gt;<wbr>alias, 0);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0dm_queue_if_no_path(mpp-&gt;<wbr>alias, 1);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt;=C2=A0 }<br>
</div></div>ACK<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
Dr. Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com">mwilck@suse.com</a>=
&gt;, Tel. <a href=3D"tel:%2B49%20%280%29911%2074053%202107" value=3D"+4991=
1740532107">+49 (0)911 74053 2107</a><br>
SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton<b=
r>
HRB 21284 (AG N=C3=BCrnberg)<br>
<br>
</font></span></blockquote></div><br></div>

--001a1147bba01280c10562a4de7e--


--===============3922785515317552485==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3922785515317552485==--
