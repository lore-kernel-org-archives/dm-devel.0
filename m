From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath,
	multipathd: Rework SIGPIPE handling
Date: Mon, 29 Aug 2016 09:21:53 +0200
Message-ID: <CABr-GndFxSv60VDqMEX=T6=Pv1GqhoOgetkB0bz4jfms6oUPJw@mail.gmail.com>
References: <10ceb0f0-3009-6a5c-073a-78f4c0ab61db@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3333117694428953247=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <10ceb0f0-3009-6a5c-073a-78f4c0ab61db@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Gris Ge <fge@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============3333117694428953247==
Content-Type: multipart/alternative; boundary=94eb2c07a47ef17641053b30b7ce

--94eb2c07a47ef17641053b30b7ce
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Tue, Aug 16, 2016 at 10:08 PM, Bart Van Assche <
bart.vanassche@sandisk.com> wrote:

> The behavior we want is as follows:
> * If stdout or stderr is closed then SIGPIPE causes termination.
> * Sending data to a socket that has been closed by the receiver
>   does not cause multipathd to stop.
>
> Hence unblock SIGPIPE and use MSG_NOSIGNAL when sending data over
> a socket.
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Gris Ge <fge@redhat.com>
> ---
>  libmpathcmd/mpath_cmd.c |  4 ++--
>  libmultipath/uxsock.c   | 17 ++---------------
>  multipathd/main.c       |  8 +-------
>  3 files changed, 5 insertions(+), 24 deletions(-)
>
> diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
> index c058479..667a2dc 100644
> --- a/libmpathcmd/mpath_cmd.c
> +++ b/libmpathcmd/mpath_cmd.c
> @@ -33,7 +33,7 @@ static ssize_t read_all(int fd, void *buf, size_t len,
> unsigned int timeout)
>                         return -1;
>                 } else if (!pfd.revents & POLLIN)
>                         continue;
> -               n = read(fd, buf, len);
> +               n = recv(fd, buf, len, 0);
>                 if (n < 0) {
>                         if ((errno == EINTR) || (errno == EAGAIN))
>                                 continue;
> @@ -56,7 +56,7 @@ static size_t write_all(int fd, const void *buf, size_t
> len)
>         size_t total = 0;
>
>         while (len) {
> -               ssize_t n = write(fd, buf, len);
> +               ssize_t n = send(fd, buf, len, MSG_NOSIGNAL);
>                 if (n < 0) {
>                         if ((errno == EINTR) || (errno == EAGAIN))
>                                 continue;
> diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
> index 775e278..880257f 100644
> --- a/libmultipath/uxsock.c
> +++ b/libmultipath/uxsock.c
> @@ -81,7 +81,7 @@ size_t write_all(int fd, const void *buf, size_t len)
>         size_t total = 0;
>
>         while (len) {
> -               ssize_t n = write(fd, buf, len);
> +               ssize_t n = send(fd, buf, len, MSG_NOSIGNAL);
>                 if (n < 0) {
>                         if ((errno == EINTR) || (errno == EAGAIN))
>                                 continue;
> @@ -138,20 +138,7 @@ ssize_t read_all(int fd, void *buf, size_t len,
> unsigned int timeout)
>   */
>  int send_packet(int fd, const char *buf)
>  {
> -       int ret = 0;
> -       sigset_t set, old;
> -
> -       /* Block SIGPIPE */
> -       sigemptyset(&set);
> -       sigaddset(&set, SIGPIPE);
> -       pthread_sigmask(SIG_BLOCK, &set, &old);
> -
> -       ret = mpath_send_cmd(fd, buf);
> -
> -       /* And unblock it again */
> -       pthread_sigmask(SIG_SETMASK, &old, NULL);
> -
> -       return ret;
> +       return mpath_send_cmd(fd, buf);
>  }
>
>  /*
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 54abfef..2be6cb2 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2125,18 +2125,12 @@ sigusr2 (int sig)
>  static void
>  signal_init(void)
>  {
> -       sigset_t set;
> -
> -       sigemptyset(&set);
> -       sigaddset(&set, SIGPIPE);
> -       pthread_sigmask(SIG_SETMASK, &set, NULL);
> -
>         signal_set(SIGHUP, sighup);
>         signal_set(SIGUSR1, sigusr1);
>         signal_set(SIGUSR2, sigusr2);
>         signal_set(SIGINT, sigend);
>         signal_set(SIGTERM, sigend);
> -       signal(SIGPIPE, SIG_IGN);
> +       signal_set(SIGPIPE, sigend);
>  }
>
>  static void
> --
> 2.9.2
>
>
>

--94eb2c07a47ef17641053b30b7ce
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Tue, Aug 16, 2016 at 10:08 PM, Bart Van A=
ssche <span dir=3D"ltr">&lt;<a href=3D"mailto:bart.vanassche@sandisk.com" t=
arget=3D"_blank">bart.vanassche@sandisk.com</a>&gt;</span> wrote:<br><block=
quote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc=
 solid;padding-left:1ex">The behavior we want is as follows:<br>
* If stdout or stderr is closed then SIGPIPE causes termination.<br>
* Sending data to a socket that has been closed by the receiver<br>
=C2=A0 does not cause multipathd to stop.<br>
<br>
Hence unblock SIGPIPE and use MSG_NOSIGNAL when sending data over<br>
a socket.<br>
<br>
Signed-off-by: Bart Van Assche &lt;<a href=3D"mailto:bart.vanassche@sandisk=
.com">bart.vanassche@sandisk.com</a>&gt;<br>
Cc: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com">bmarzins@=
redhat.com</a>&gt;<br>
Cc: Gris Ge &lt;<a href=3D"mailto:fge@redhat.com">fge@redhat.com</a>&gt;<br=
>
---<br>
=C2=A0libmpathcmd/mpath_cmd.c |=C2=A0 4 ++--<br>
=C2=A0libmultipath/uxsock.c=C2=A0 =C2=A0| 17 ++---------------<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 8 +-------<br>
=C2=A03 files changed, 5 insertions(+), 24 deletions(-)<br>
<br>
diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c<br>
index c058479..667a2dc 100644<br>
--- a/libmpathcmd/mpath_cmd.c<br>
+++ b/libmpathcmd/mpath_cmd.c<br>
@@ -33,7 +33,7 @@ static ssize_t read_all(int fd, void *buf, size_t len, un=
signed int timeout)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return -1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (!pfd.rev=
ents &amp; POLLIN)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 continue;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0n =3D read(fd, buf,=
 len);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0n =3D recv(fd, buf,=
 len, 0);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (n &lt; 0) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if ((errno =3D=3D EINTR) || (errno =3D=3D EAGAIN))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;<br>
@@ -56,7 +56,7 @@ static size_t write_all(int fd, const void *buf, size_t l=
en)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 size_t total =3D 0;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 while (len) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t n =3D write=
(fd, buf, len);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t n =3D send(=
fd, buf, len, MSG_NOSIGNAL);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (n &lt; 0) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if ((errno =3D=3D EINTR) || (errno =3D=3D EAGAIN))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;<br>
diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c<br>
index 775e278..880257f 100644<br>
--- a/libmultipath/uxsock.c<br>
+++ b/libmultipath/uxsock.c<br>
@@ -81,7 +81,7 @@ size_t write_all(int fd, const void *buf, size_t len)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 size_t total =3D 0;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 while (len) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t n =3D write=
(fd, buf, len);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t n =3D send(=
fd, buf, len, MSG_NOSIGNAL);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (n &lt; 0) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if ((errno =3D=3D EINTR) || (errno =3D=3D EAGAIN))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;<br>
@@ -138,20 +138,7 @@ ssize_t read_all(int fd, void *buf, size_t len, unsign=
ed int timeout)<br>
=C2=A0 */<br>
=C2=A0int send_packet(int fd, const char *buf)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0int ret =3D 0;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0sigset_t set, old;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Block SIGPIPE */<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0sigemptyset(&amp;set);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0sigaddset(&amp;set, SIGPIPE);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_sigmask(SIG_BLOCK, &amp;set, &amp;old);=
<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D mpath_send_cmd(fd, buf);<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0/* And unblock it again */<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_sigmask(SIG_SETMASK, &amp;old, NULL);<b=
r>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return mpath_send_cmd(fd, buf);<br>
=C2=A0}<br>
<br>
=C2=A0/*<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index 54abfef..2be6cb2 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -2125,18 +2125,12 @@ sigusr2 (int sig)<br>
=C2=A0static void<br>
=C2=A0signal_init(void)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0sigset_t set;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0sigemptyset(&amp;set);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0sigaddset(&amp;set, SIGPIPE);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_sigmask(SIG_SETMASK, &amp;set, NULL);<b=
r>
-<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 signal_set(SIGHUP, sighup);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 signal_set(SIGUSR1, sigusr1);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 signal_set(SIGUSR2, sigusr2);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 signal_set(SIGINT, sigend);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 signal_set(SIGTERM, sigend);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0signal(SIGPIPE, SIG_IGN);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0signal_set(SIGPIPE, sigend);<br>
=C2=A0}<br>
<br>
=C2=A0static void<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.9.2<br>
<br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c07a47ef17641053b30b7ce--


--===============3333117694428953247==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3333117694428953247==--
