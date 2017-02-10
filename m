From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 3/5] multipath-tools: New way to limit the
 IPC command length.
Date: Fri, 10 Feb 2017 12:36:04 +0100
Message-ID: <CABr-GndX-Ag3eyVmLC9XhqsmKL+H4mNNeK3tANR0O5U=XB-yOg@mail.gmail.com>
References: <1484919542-11087-1-git-send-email-fge@redhat.com>
	<1484919542-11087-4-git-send-email-fge@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1352867845661418604=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1484919542-11087-4-git-send-email-fge@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gris Ge <fge@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1352867845661418604==
Content-Type: multipart/alternative; boundary=001a113efb9ac26c3c05482b80bc

--001a113efb9ac26c3c05482b80bc
Content-Type: text/plain; charset=UTF-8

Applied.

On Fri, Jan 20, 2017 at 2:39 PM, Gris Ge <fge@redhat.com> wrote:

> Problem:
>
>     mpath_recv_reply() from libmpathcmd return -EINVAL on command 'show
>     maps json' with 2k paths.  No error will be triggered for command
>     `multipathd -k'show maps json` as multipathd is using their own
>     implementation on recv_packet() which does not have size limitation.
>
> Root cause:
>
>     Commit 174e717d351789a3cb29e1417f8e910baabcdb16 introduced the
>     limitation on max bytes(65535) of reply string from multipathd.
>     With 2k paths(1k mpaths) simulated by scsi_debug, the 'show maps json'
>     requires 2066784 bytes which trigged the EINVAL error.
>
> Fix:
>     * Remove the limitation of MAX_REPLY_LEN in libmpathcmd.
>
>     * New functions `recv_packet_from_client()` in uxsock.h of libmultipath
>       which enforce the limitation of buffer size to 512(_MAX_CMD_LEN).
>
>     * Change multipathd socket listener to use
>       `recv_packet_from_client()`.
>
> Signed-off-by: Gris Ge <fge@redhat.com>
> ---
>  libmpathcmd/mpath_cmd.c |  2 --
>  libmultipath/uxsock.c   | 39 ++++++++++++++++++++++++++++++---------
>  libmultipath/uxsock.h   |  9 +++++++++
>  multipathd/uxlsnr.c     |  8 +++++---
>  4 files changed, 44 insertions(+), 14 deletions(-)
>
> diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
> index d9c5790..7fc9e98 100644
> --- a/libmpathcmd/mpath_cmd.c
> +++ b/libmpathcmd/mpath_cmd.c
> @@ -142,8 +142,6 @@ int mpath_recv_reply(int fd, char **reply, unsigned
> int timeout)
>         len = mpath_recv_reply_len(fd, timeout);
>         if (len <= 0)
>                 return len;
> -       if (len > MAX_REPLY_LEN)
> -               return -EINVAL;
>         *reply = malloc(len);
>         if (!*reply)
>                 return -1;
> diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
> index 0ca9e50..492f4b9 100644
> --- a/libmultipath/uxsock.c
> +++ b/libmultipath/uxsock.c
> @@ -24,6 +24,16 @@
>  #include "memory.h"
>  #include "uxsock.h"
>  #include "debug.h"
> +
> +/*
> + * Code is similar with mpath_recv_reply() with data size limitation
> + * and debug-able malloc.
> + * When limit == 0, it means no limit on data size, used for socket client
> + * to receiving data from multipathd.
> + */
> +static int _recv_packet(int fd, char **buf, unsigned int timeout,
> +                       ssize_t limit);
> +
>  /*
>   * create a unix domain socket and start listening on it
>   * return a file descriptor open on the socket
> @@ -81,26 +91,37 @@ int send_packet(int fd, const char *buf)
>         return mpath_send_cmd(fd, buf);
>  }
>
> -/*
> - * receive a packet in length prefix format
> - */
> -int recv_packet(int fd, char **buf, unsigned int timeout)
> +static int _recv_packet(int fd, char **buf, unsigned int timeout, ssize_t
> limit)
>  {
> -       int err;
> -       ssize_t len;
> +       int err = 0;
> +       ssize_t len = 0;
>
>         *buf = NULL;
>         len = mpath_recv_reply_len(fd, timeout);
>         if (len <= 0)
>                 return len;
> +       if ((limit > 0) && (len > limit))
> +               return -EINVAL;
>         (*buf) = MALLOC(len);
>         if (!*buf)
>                 return -ENOMEM;
>         err = mpath_recv_reply_data(fd, *buf, len, timeout);
> -       if (err) {
> +       if (err != 0) {
>                 FREE(*buf);
>                 (*buf) = NULL;
> -               return err;
>         }
> -       return 0;
> +       return err;
> +}
> +
> +/*
> + * receive a packet in length prefix format
> + */
> +int recv_packet(int fd, char **buf, unsigned int timeout)
> +{
> +       return _recv_packet(fd, buf, timeout, 0 /* no limit */);
> +}
> +
> +int recv_packet_from_client(int fd, char **buf, unsigned int timeout)
> +{
> +       return _recv_packet(fd, buf, timeout, _MAX_CMD_LEN);
>  }
> diff --git a/libmultipath/uxsock.h b/libmultipath/uxsock.h
> index 442b564..8e7401d 100644
> --- a/libmultipath/uxsock.h
> +++ b/libmultipath/uxsock.h
> @@ -2,3 +2,12 @@
>  int ux_socket_listen(const char *name);
>  int send_packet(int fd, const char *buf);
>  int recv_packet(int fd, char **buf, unsigned int timeout);
> +
> +#define _MAX_CMD_LEN           512
> +
> +/*
> + * Used for receiving socket command from untrusted socket client where
> data
> + * size is restricted to 512(_MAX_CMD_LEN) at most.
> + * Return -EINVAL if data length requested by client exceeded the
> _MAX_CMD_LEN.
> + */
> +int recv_packet_from_client(int fd, char **buf, unsigned int timeout);
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index dfef03e..6ca62af 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -241,13 +241,15 @@ void * uxsock_listen(uxsock_trigger_fn
> uxsock_trigger, void * trigger_data)
>                                 if (clock_gettime(CLOCK_MONOTONIC,
> &start_time)
>                                     != 0)
>                                         start_time.tv_sec = 0;
> -                               if (recv_packet(c->fd, &inbuf,
> -                                               uxsock_timeout) != 0) {
> +                               if (recv_packet_from_client(c->fd, &inbuf,
> +                                                           uxsock_timeout)
> +                                   != 0) {
>                                         dead_client(c);
>                                         continue;
>                                 }
>                                 if (!inbuf) {
> -                                       condlog(4, "recv_packet get null
> request");
> +                                       condlog(4,
> "recv_packet_from_client "
> +                                               "get null request");
>                                         continue;
>                                 }
>                                 condlog(4, "cli[%d]: Got request [%s]",
> --
> 1.8.3.1
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a113efb9ac26c3c05482b80bc
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.</div><div class=3D"gmail_extra"><br><div class=3D=
"gmail_quote">On Fri, Jan 20, 2017 at 2:39 PM, Gris Ge <span dir=3D"ltr">&l=
t;<a href=3D"mailto:fge@redhat.com" target=3D"_blank">fge@redhat.com</a>&gt=
;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex">Problem:<br>
<br>
=C2=A0 =C2=A0 mpath_recv_reply() from libmpathcmd return -EINVAL on command=
 &#39;show<br>
=C2=A0 =C2=A0 maps json&#39; with 2k paths.=C2=A0 No error will be triggere=
d for command<br>
=C2=A0 =C2=A0 `multipathd -k&#39;show maps json` as multipathd is using the=
ir own<br>
=C2=A0 =C2=A0 implementation on recv_packet() which does not have size limi=
tation.<br>
<br>
Root cause:<br>
<br>
=C2=A0 =C2=A0 Commit 174e717d351789a3cb29e1417f8e91<wbr>0baabcdb16 introduc=
ed the<br>
=C2=A0 =C2=A0 limitation on max bytes(65535) of reply string from multipath=
d.<br>
=C2=A0 =C2=A0 With 2k paths(1k mpaths) simulated by scsi_debug, the &#39;sh=
ow maps json&#39;<br>
=C2=A0 =C2=A0 requires 2066784 bytes which trigged the EINVAL error.<br>
<br>
Fix:<br>
=C2=A0 =C2=A0 * Remove the limitation of MAX_REPLY_LEN in libmpathcmd.<br>
<br>
=C2=A0 =C2=A0 * New functions `recv_packet_from_client()` in uxsock.h of li=
bmultipath<br>
=C2=A0 =C2=A0 =C2=A0 which enforce the limitation of buffer size to 512(_MA=
X_CMD_LEN).<br>
<br>
=C2=A0 =C2=A0 * Change multipathd socket listener to use<br>
=C2=A0 =C2=A0 =C2=A0 `recv_packet_from_client()`.<br>
<br>
Signed-off-by: Gris Ge &lt;<a href=3D"mailto:fge@redhat.com">fge@redhat.com=
</a>&gt;<br>
---<br>
=C2=A0libmpathcmd/mpath_cmd.c |=C2=A0 2 --<br>
=C2=A0libmultipath/uxsock.c=C2=A0 =C2=A0| 39 ++++++++++++++++++++++++++++++=
<wbr>---------<br>
=C2=A0libmultipath/uxsock.h=C2=A0 =C2=A0|=C2=A0 9 +++++++++<br>
=C2=A0multipathd/uxlsnr.c=C2=A0 =C2=A0 =C2=A0|=C2=A0 8 +++++---<br>
=C2=A04 files changed, 44 insertions(+), 14 deletions(-)<br>
<br>
diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c<br>
index d9c5790..7fc9e98 100644<br>
--- a/libmpathcmd/mpath_cmd.c<br>
+++ b/libmpathcmd/mpath_cmd.c<br>
@@ -142,8 +142,6 @@ int mpath_recv_reply(int fd, char **reply, unsigned int=
 timeout)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 len =3D mpath_recv_reply_len(fd, timeout);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (len &lt;=3D 0)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return len;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (len &gt; MAX_REPLY_LEN)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINVAL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 *reply =3D malloc(len);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!*reply)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;<br>
diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c<br>
index 0ca9e50..492f4b9 100644<br>
--- a/libmultipath/uxsock.c<br>
+++ b/libmultipath/uxsock.c<br>
@@ -24,6 +24,16 @@<br>
=C2=A0#include &quot;memory.h&quot;<br>
=C2=A0#include &quot;uxsock.h&quot;<br>
=C2=A0#include &quot;debug.h&quot;<br>
+<br>
+/*<br>
+ * Code is similar with mpath_recv_reply() with data size limitation<br>
+ * and debug-able malloc.<br>
+ * When limit =3D=3D 0, it means no limit on data size, used for socket cl=
ient<br>
+ * to receiving data from multipathd.<br>
+ */<br>
+static int _recv_packet(int fd, char **buf, unsigned int timeout,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ssize_t limit);<br>
+<br>
=C2=A0/*<br>
=C2=A0 * create a unix domain socket and start listening on it<br>
=C2=A0 * return a file descriptor open on the socket<br>
@@ -81,26 +91,37 @@ int send_packet(int fd, const char *buf)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return mpath_send_cmd(fd, buf);<br>
=C2=A0}<br>
<br>
-/*<br>
- * receive a packet in length prefix format<br>
- */<br>
-int recv_packet(int fd, char **buf, unsigned int timeout)<br>
+static int _recv_packet(int fd, char **buf, unsigned int timeout, ssize_t =
limit)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0int err;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t len;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int err =3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t len =3D 0;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 *buf =3D NULL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 len =3D mpath_recv_reply_len(fd, timeout);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (len &lt;=3D 0)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return len;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if ((limit &gt; 0) &amp;&amp; (len &gt; limit))=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINVAL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 (*buf) =3D MALLOC(len);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!*buf)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOMEM;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D mpath_recv_reply_data(fd, *buf, len, ti=
meout);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (err) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (err !=3D 0) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FREE(*buf);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (*buf) =3D NULL;<br=
>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return err;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return err;<br>
+}<br>
+<br>
+/*<br>
+ * receive a packet in length prefix format<br>
+ */<br>
+int recv_packet(int fd, char **buf, unsigned int timeout)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return _recv_packet(fd, buf, timeout, 0 /* no l=
imit */);<br>
+}<br>
+<br>
+int recv_packet_from_client(int fd, char **buf, unsigned int timeout)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return _recv_packet(fd, buf, timeout, _MAX_CMD_=
LEN);<br>
=C2=A0}<br>
diff --git a/libmultipath/uxsock.h b/libmultipath/uxsock.h<br>
index 442b564..8e7401d 100644<br>
--- a/libmultipath/uxsock.h<br>
+++ b/libmultipath/uxsock.h<br>
@@ -2,3 +2,12 @@<br>
=C2=A0int ux_socket_listen(const char *name);<br>
=C2=A0int send_packet(int fd, const char *buf);<br>
=C2=A0int recv_packet(int fd, char **buf, unsigned int timeout);<br>
+<br>
+#define _MAX_CMD_LEN=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0512<br>
+<br>
+/*<br>
+ * Used for receiving socket command from untrusted socket client where da=
ta<br>
+ * size is restricted to 512(_MAX_CMD_LEN) at most.<br>
+ * Return -EINVAL if data length requested by client exceeded the _MAX_CMD=
_LEN.<br>
+ */<br>
+int recv_packet_from_client(int fd, char **buf, unsigned int timeout);<br>
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c<br>
index dfef03e..6ca62af 100644<br>
--- a/multipathd/uxlsnr.c<br>
+++ b/multipathd/uxlsnr.c<br>
@@ -241,13 +241,15 @@ void * uxsock_listen(uxsock_trigger_<wbr>fn uxsock_tr=
igger, void * trigger_data)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (clock_gettime(CLOCK_<wbr>MONOTON=
IC, &amp;start_time)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 !=3D 0)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 start_ti=
me.tv_sec =3D 0;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (recv_packet(c-&gt;fd, &amp;inbuf,=
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0uxsock_timeout) !=3D 0) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (recv_packet_from_client(c-&gt;<wb=
r>fd, &amp;inbuf,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0uxsock_timeou=
t)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!=3D 0) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dead_cli=
ent(c);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue=
;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!inbuf) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(4=
, &quot;recv_packet get null request&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(4=
, &quot;recv_packet_from_client &quot;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0&quot;get null request&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue=
;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(4, &quot;cli[%d]: Got reques=
t [%s]&quot;,<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.8.3.1<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/<wbr>mailman/listinfo/dm-deve=
l</a><br>
</font></span></blockquote></div><br></div>

--001a113efb9ac26c3c05482b80bc--


--===============1352867845661418604==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1352867845661418604==--
