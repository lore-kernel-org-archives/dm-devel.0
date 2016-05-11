From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: libmultipath: use poll() in uevent_listen()
Date: Wed, 11 May 2016 19:37:02 +0200
Message-ID: <CABr-GnfDTSJUTxzuzzF-AhObTMs=iR=YA56cV52Z_KchSWcN7w@mail.gmail.com>
References: <1462962953-9492-1-git-send-email-hare@suse.de>
	<20160511171907.GD26117@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3118272784868125384=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160511171907.GD26117@octiron.msp.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

--===============3118272784868125384==
Content-Type: multipart/alternative; boundary=001a11c243304e08000532947d18

--001a11c243304e08000532947d18
Content-Type: text/plain; charset=UTF-8

Merged

On Wed, May 11, 2016 at 7:19 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Wed, May 11, 2016 at 12:35:53PM +0200, Hannes Reinecke wrote:
> > As we're not modifying the signal mask anymore we can switch
> > back to normal 'poll' instead of 'ppoll'.
>
>
> ACK
>
> -Ben
>
> >
> > Signed-off-by: Hannes Reinecke <hare@suse.com>
> > ---
> >  libmultipath/uevent.c | 9 +++------
> >  1 file changed, 3 insertions(+), 6 deletions(-)
> >
> > diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
> > index fbe9c44..454b819 100644
> > --- a/libmultipath/uevent.c
> > +++ b/libmultipath/uevent.c
> > @@ -477,7 +477,6 @@ int uevent_listen(struct udev *udev)
> >       int fd, fd_ep = -1, socket_flags, events;
> >       int need_failback = 1;
> >       int timeout = 30;
> > -     sigset_t mask;
> >       LIST_HEAD(uevlisten_tmp);
> >
> >       /*
> > @@ -528,22 +527,20 @@ int uevent_listen(struct udev *udev)
> >               goto out;
> >       }
> >
> > -     pthread_sigmask(SIG_SETMASK, NULL, &mask);
> >       events = 0;
> >       while (1) {
> >               struct uevent *uev;
> >               struct udev_device *dev;
> >               struct pollfd ev_poll;
> > -             struct timespec poll_timeout;
> > +             int poll_timeout;
> >               int fdcount;
> >
> >               memset(&ev_poll, 0, sizeof(struct pollfd));
> >               ev_poll.fd = fd;
> >               ev_poll.events = POLLIN;
> > -             memset(&poll_timeout, 0, sizeof(struct timespec));
> > -             poll_timeout.tv_sec = timeout;
> > +             poll_timeout = timeout * 1000;
> >               errno = 0;
> > -             fdcount = ppoll(&ev_poll, 1, &poll_timeout, &mask);
> > +             fdcount = poll(&ev_poll, 1, poll_timeout);
> >               if (fdcount && ev_poll.revents & POLLIN) {
> >                       timeout = 0;
> >                       dev = udev_monitor_receive_device(monitor);
> > --
> > 2.6.6
>

--001a11c243304e08000532947d18
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged</div><div class=3D"gmail_extra"><br><div class=3D"g=
mail_quote">On Wed, May 11, 2016 at 7:19 PM, Benjamin Marzinski <span dir=
=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=3D"_blank">bmarz=
ins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><spa=
n class=3D"">On Wed, May 11, 2016 at 12:35:53PM +0200, Hannes Reinecke wrot=
e:<br>
&gt; As we&#39;re not modifying the signal mask anymore we can switch<br>
&gt; back to normal &#39;poll&#39; instead of &#39;ppoll&#39;.<br>
<br>
<br>
</span>ACK<br>
<br>
-Ben<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt;<br>
&gt; Signed-off-by: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.com">ha=
re@suse.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 libmultipath/uevent.c | 9 +++------<br>
&gt;=C2=A0 1 file changed, 3 insertions(+), 6 deletions(-)<br>
&gt;<br>
&gt; diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c<br>
&gt; index fbe9c44..454b819 100644<br>
&gt; --- a/libmultipath/uevent.c<br>
&gt; +++ b/libmultipath/uevent.c<br>
&gt; @@ -477,7 +477,6 @@ int uevent_listen(struct udev *udev)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int fd, fd_ep =3D -1, socket_flags, events;<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int need_failback =3D 1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int timeout =3D 30;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0sigset_t mask;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0LIST_HEAD(uevlisten_tmp);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt; @@ -528,22 +527,20 @@ int uevent_listen(struct udev *udev)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0pthread_sigmask(SIG_SETMASK, NULL, &amp;mask);<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0events =3D 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0while (1) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct uevent *u=
ev;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct udev_devi=
ce *dev;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pollfd ev=
_poll;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct timespec poll_=
timeout;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int poll_timeout;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int fdcount;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(&amp;ev_p=
oll, 0, sizeof(struct pollfd));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ev_poll.fd =3D f=
d;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ev_poll.events =
=3D POLLIN;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(&amp;poll_time=
out, 0, sizeof(struct timespec));<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0poll_timeout.tv_sec =
=3D timeout;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0poll_timeout =3D time=
out * 1000;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0errno =3D 0;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fdcount =3D ppoll(&am=
p;ev_poll, 1, &amp;poll_timeout, &amp;mask);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fdcount =3D poll(&amp=
;ev_poll, 1, poll_timeout);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (fdcount &amp=
;&amp; ev_poll.revents &amp; POLLIN) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0timeout =3D 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0dev =3D udev_monitor_receive_device(monitor);<br>
&gt; --<br>
&gt; 2.6.6<br>
</div></div></blockquote></div><br></div>

--001a11c243304e08000532947d18--


--===============3118272784868125384==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3118272784868125384==--
