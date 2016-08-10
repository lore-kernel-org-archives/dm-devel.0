From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipathd: fix memory allocation logic
 error for polls in uxsock_listen()
Date: Wed, 10 Aug 2016 11:49:16 +0200
Message-ID: <CABr-GneMM1FwYXLiF9wJWzgpei4WT0oafs=+exR+=5uw3m_ZJw@mail.gmail.com>
References: <1470821560-10864-1-git-send-email-tang.junhui@zte.com.cn>
	<2bcb58e4-9264-9dbf-7527-ec1c620f292e@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4535080767386155153=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2bcb58e4-9264-9dbf-7527-ec1c620f292e@suse.de>
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
Cc: zhang.kai16@zte.com.cn, device-mapper development <dm-devel@redhat.com>, christophe varoqui <christophe.varoqui@free.fr>, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

--===============4535080767386155153==
Content-Type: multipart/alternative; boundary=001a114109ce09ea080539b490ef

--001a114109ce09ea080539b490ef
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Merged.
Thanks.

On Wed, Aug 10, 2016 at 11:42 AM, Hannes Reinecke <hare@suse.de> wrote:

> On 08/10/2016 11:32 AM, tang.junhui@zte.com.cn wrote:
> > From: "tang.junhui" <tang.junhui@zte.com.cn>
> >
> > logic error exists in memory allocation for polls in uxsock_listen(),
> even if the allocated memory size meet the needs, it is still to realloc
> memory, which is not up to expectations.
> >
> > Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> > ---
> >  multipathd/uxlsnr.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> > index f114e59..fa29b2a 100644
> > --- a/multipathd/uxlsnr.c
> > +++ b/multipathd/uxlsnr.c
> > @@ -145,7 +145,7 @@ void * uxsock_listen(uxsock_trigger_fn
> uxsock_trigger, void * trigger_data)
> >       pthread_cleanup_push(uxsock_cleanup, NULL);
> >
> >       condlog(3, "uxsock: startup listener");
> > -     polls =3D (struct pollfd *)MALLOC(MIN_POLLS + 1);
> > +     polls =3D (struct pollfd *)MALLOC((MIN_POLLS + 1) * sizeof(struct
> pollfd));
> >       if (!polls) {
> >               condlog(0, "uxsock: failed to allocate poll fds");
> >               return NULL;
> > @@ -167,9 +167,11 @@ void * uxsock_listen(uxsock_trigger_fn
> uxsock_trigger, void * trigger_data)
> >               }
> >               if (num_clients !=3D old_clients) {
> >                       struct pollfd *new;
> > -                     if (num_clients < MIN_POLLS) {
> > +                     if (num_clients <=3D MIN_POLLS && old_clients >
> MIN_POLLS) {
> >                               new =3D REALLOC(polls, (1 + MIN_POLLS) *
> >                                               sizeof(struct pollfd));
> > +                     } else if (num_clients <=3D MIN_POLLS && old_clie=
nts
> <=3D MIN_POLLS) {
> > +                             new =3D polls;
> >                       } else {
> >                               new =3D REALLOC(polls, (1+num_clients) *
> >                                               sizeof(struct pollfd));
> > @@ -181,7 +183,7 @@ void * uxsock_listen(uxsock_trigger_fn
> uxsock_trigger, void * trigger_data)
> >                               pthread_yield();
> >                               continue;
> >                       }
> > -                     num_clients =3D old_clients;
> > +                     old_clients =3D num_clients;
> >                       polls =3D new;
> >               }
> >               polls[0].fd =3D ux_sock;
> >
> Thanks for catching this.
>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
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
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a114109ce09ea080539b490ef
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Wed, Aug 10, 2016 at 11:42 AM, Hannes Rei=
necke <span dir=3D"ltr">&lt;<a href=3D"mailto:hare@suse.de" target=3D"_blan=
k">hare@suse.de</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" =
style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><di=
v class=3D"HOEnZb"><div class=3D"h5">On 08/10/2016 11:32 AM, <a href=3D"mai=
lto:tang.junhui@zte.com.cn">tang.junhui@zte.com.cn</a> wrote:<br>
&gt; From: &quot;tang.junhui&quot; &lt;<a href=3D"mailto:tang.junhui@zte.co=
m.cn">tang.junhui@zte.com.cn</a>&gt;<br>
&gt;<br>
&gt; logic error exists in memory allocation for polls in uxsock_listen(), =
even if the allocated memory size meet the needs, it is still to realloc me=
mory, which is not up to expectations.<br>
&gt;<br>
&gt; Signed-off-by: tang.junhui &lt;<a href=3D"mailto:tang.junhui@zte.com.c=
n">tang.junhui@zte.com.cn</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 multipathd/uxlsnr.c | 8 +++++---<br>
&gt;=C2=A0 1 file changed, 5 insertions(+), 3 deletions(-)<br>
&gt;<br>
&gt; diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c<br>
&gt; index f114e59..fa29b2a 100644<br>
&gt; --- a/multipathd/uxlsnr.c<br>
&gt; +++ b/multipathd/uxlsnr.c<br>
&gt; @@ -145,7 +145,7 @@ void * uxsock_listen(uxsock_trigger_<wbr>fn uxsock=
_trigger, void * trigger_data)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_cleanup_push(uxsock_<wbr>cleanup, NU=
LL);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;uxsock: startup listener&qu=
ot;);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0polls =3D (struct pollfd *)MALLOC(MIN_POLLS + 1);=
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0polls =3D (struct pollfd *)MALLOC((MIN_POLLS + 1)=
 * sizeof(struct pollfd));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!polls) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(0, &quot=
;uxsock: failed to allocate poll fds&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
&gt; @@ -167,9 +167,11 @@ void * uxsock_listen(uxsock_trigger_<wbr>fn uxsoc=
k_trigger, void * trigger_data)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (num_clients =
!=3D old_clients) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0struct pollfd *new;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0if (num_clients &lt; MIN_POLLS) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0if (num_clients &lt;=3D MIN_POLLS &amp;&amp; old_clients &gt; MIN_PO=
LLS) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0new =3D REALLOC(polls, (1 + MIN_PO=
LLS) *<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0sizeof(struct pollfd));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0} else if (num_clients &lt;=3D MIN_POLLS &amp;&amp; old_clients &lt;=
=3D MIN_POLLS) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0new =3D polls;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0} else {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0new =3D REALLOC(polls, (1+num_clie=
nts) *<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0sizeof(struct pollfd));<br>
&gt; @@ -181,7 +183,7 @@ void * uxsock_listen(uxsock_trigger_<wbr>fn uxsock=
_trigger, void * trigger_data)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_yield();<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0continue;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0}<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0num_clients =3D old_clients;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0old_clients =3D num_clients;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0polls =3D new;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0polls[0].fd =3D =
ux_sock;<br>
&gt;<br>
</div></div>Thanks for catching this.<br>
<br>
Reviewed-by: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.com">hare@suse=
.com</a>&gt;<br>
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
</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/<wbr>mailman/listinfo/dm-deve=
l</a><br>
</div></div></blockquote></div><br></div>

--001a114109ce09ea080539b490ef--


--===============4535080767386155153==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4535080767386155153==--
