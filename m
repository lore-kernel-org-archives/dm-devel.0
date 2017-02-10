From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 5/5] multipath-tools: Perform socket client
 uid check on IPC commands.
Date: Fri, 10 Feb 2017 12:37:23 +0100
Message-ID: <CABr-Gnd4cG_1FJPrtpdeEfOSa3X-N_r9Yd0eYEeWHz6cqEKwsw@mail.gmail.com>
References: <1484919542-11087-1-git-send-email-fge@redhat.com>
	<1484919542-11087-6-git-send-email-fge@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2327190356306446509=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1484919542-11087-6-git-send-email-fge@redhat.com>
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

--===============2327190356306446509==
Content-Type: multipart/alternative; boundary=001a11425b587c88ac05482b850b

--001a11425b587c88ac05482b850b
Content-Type: text/plain; charset=UTF-8

Applied.

On Fri, Jan 20, 2017 at 2:39 PM, Gris Ge <fge@redhat.com> wrote:

> Problem:
>     A non-root user could send and execute 'shutdown' IPC command to
>     multipathd.
>
> Fix:
>     Use getsockopt() to find out socket client uid, only query (list or
>     show) command are allowed for non-root(uid != 0) socket connection.
>     An error message "permission deny: need to be root" will be sent
>     otherwise.
>
> Signed-off-by: Gris Ge <fge@redhat.com>
> ---
>  multipathd/main.c   | 12 +++++++++++-
>  multipathd/uxlsnr.c | 19 +++++++++++++++++++
>  multipathd/uxlsnr.h |  4 +++-
>  3 files changed, 33 insertions(+), 2 deletions(-)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index adc3258..1e64afc 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -23,6 +23,7 @@
>  #endif
>  #include <semaphore.h>
>  #include <time.h>
> +#include <stdbool.h>
>
>  /*
>   * libmultipath
> @@ -1048,7 +1049,8 @@ map_discovery (struct vectors * vecs)
>  }
>
>  int
> -uxsock_trigger (char * str, char ** reply, int * len, void * trigger_data)
> +uxsock_trigger (char * str, char ** reply, int * len, bool is_root,
> +               void * trigger_data)
>  {
>         struct vectors * vecs;
>         int r;
> @@ -1057,6 +1059,14 @@ uxsock_trigger (char * str, char ** reply, int *
> len, void * trigger_data)
>         *len = 0;
>         vecs = (struct vectors *)trigger_data;
>
> +       if ((str != NULL) && (is_root == false) &&
> +           (strncmp(str, "list", strlen("list")) != 0) &&
> +           (strncmp(str, "show", strlen("show")) != 0)) {
> +               *reply = STRDUP("permission deny: need to be root");
> +               *len = strlen(*reply) + 1;
> +               return 1;
> +       }
> +
>         r = parse_cmd(str, reply, len, vecs, uxsock_timeout / 1000);
>
>         if (r > 0) {
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index 6ca62af..98ac25a 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -22,6 +22,7 @@
>  #include <poll.h>
>  #include <sys/time.h>
>  #include <signal.h>
> +#include <stdbool.h>
>  #include "checkers.h"
>  #include "memory.h"
>  #include "debug.h"
> @@ -51,6 +52,23 @@ LIST_HEAD(clients);
>  pthread_mutex_t client_lock = PTHREAD_MUTEX_INITIALIZER;
>  struct pollfd *polls;
>
> +static bool _socket_client_is_root(int fd);
> +
> +static bool _socket_client_is_root(int fd)
> +{
> +       socklen_t len = 0;
> +       struct ucred uc;
> +
> +       len = sizeof(struct ucred);
> +       if ((fd >= 0) &&
> +           (getsockopt(fd, SOL_SOCKET, SO_PEERCRED, &uc, &len) == 0) &&
> +           (uc.uid == 0))
> +                       return true;
> +
> +       /* Treat error as not root client */
> +       return false;
> +}
> +
>  /*
>   * handle a new client joining
>   */
> @@ -255,6 +273,7 @@ void * uxsock_listen(uxsock_trigger_fn
> uxsock_trigger, void * trigger_data)
>                                 condlog(4, "cli[%d]: Got request [%s]",
>                                         i, inbuf);
>                                 uxsock_trigger(inbuf, &reply, &rlen,
> +
> _socket_client_is_root(c->fd),
>                                                trigger_data);
>                                 if (reply) {
>                                         if (send_packet(c->fd,
> diff --git a/multipathd/uxlsnr.h b/multipathd/uxlsnr.h
> index 4ef47d5..d51a8f9 100644
> --- a/multipathd/uxlsnr.h
> +++ b/multipathd/uxlsnr.h
> @@ -1,7 +1,9 @@
>  #ifndef _UXLSNR_H
>  #define _UXLSNR_H
>
> -typedef int (uxsock_trigger_fn)(char *, char **, int *, void *);
> +#include <stdbool.h>
> +
> +typedef int (uxsock_trigger_fn)(char *, char **, int *, bool, void *);
>
>  void * uxsock_listen(uxsock_trigger_fn uxsock_trigger,
>                      void * trigger_data);
> --
> 1.8.3.1
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a11425b587c88ac05482b850b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.</div><div class=3D"gmail_extra"><br><div class=3D=
"gmail_quote">On Fri, Jan 20, 2017 at 2:39 PM, Gris Ge <span dir=3D"ltr">&l=
t;<a href=3D"mailto:fge@redhat.com" target=3D"_blank">fge@redhat.com</a>&gt=
;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex">Problem:<br>
=C2=A0 =C2=A0 A non-root user could send and execute &#39;shutdown&#39; IPC=
 command to<br>
=C2=A0 =C2=A0 multipathd.<br>
<br>
Fix:<br>
=C2=A0 =C2=A0 Use getsockopt() to find out socket client uid, only query (l=
ist or<br>
=C2=A0 =C2=A0 show) command are allowed for non-root(uid !=3D 0) socket con=
nection.<br>
=C2=A0 =C2=A0 An error message &quot;permission deny: need to be root&quot;=
 will be sent<br>
=C2=A0 =C2=A0 otherwise.<br>
<br>
Signed-off-by: Gris Ge &lt;<a href=3D"mailto:fge@redhat.com">fge@redhat.com=
</a>&gt;<br>
---<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0| 12 +++++++++++-<br>
=C2=A0multipathd/uxlsnr.c | 19 +++++++++++++++++++<br>
=C2=A0multipathd/uxlsnr.h |=C2=A0 4 +++-<br>
=C2=A03 files changed, 33 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index adc3258..1e64afc 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -23,6 +23,7 @@<br>
=C2=A0#endif<br>
=C2=A0#include &lt;semaphore.h&gt;<br>
=C2=A0#include &lt;time.h&gt;<br>
+#include &lt;stdbool.h&gt;<br>
<br>
=C2=A0/*<br>
=C2=A0 * libmultipath<br>
@@ -1048,7 +1049,8 @@ map_discovery (struct vectors * vecs)<br>
=C2=A0}<br>
<br>
=C2=A0int<br>
-uxsock_trigger (char * str, char ** reply, int * len, void * trigger_data)=
<br>
+uxsock_trigger (char * str, char ** reply, int * len, bool is_root,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0void * trigger_data=
)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct vectors * vecs;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r;<br>
@@ -1057,6 +1059,14 @@ uxsock_trigger (char * str, char ** reply, int * len=
, void * trigger_data)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 *len =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 vecs =3D (struct vectors *)trigger_data;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if ((str !=3D NULL) &amp;&amp; (is_root =3D=3D =
false) &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(strncmp(str, &quot;list&quot;, s=
trlen(&quot;list&quot;)) !=3D 0) &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(strncmp(str, &quot;show&quot;, s=
trlen(&quot;show&quot;)) !=3D 0)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*reply =3D STRDUP(&=
quot;permission deny: need to be root&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*len =3D strlen(*re=
ply) + 1;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D parse_cmd(str, reply, len, vecs, uxsock_t=
imeout / 1000);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (r &gt; 0) {<br>
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c<br>
index 6ca62af..98ac25a 100644<br>
--- a/multipathd/uxlsnr.c<br>
+++ b/multipathd/uxlsnr.c<br>
@@ -22,6 +22,7 @@<br>
=C2=A0#include &lt;poll.h&gt;<br>
=C2=A0#include &lt;sys/time.h&gt;<br>
=C2=A0#include &lt;signal.h&gt;<br>
+#include &lt;stdbool.h&gt;<br>
=C2=A0#include &quot;checkers.h&quot;<br>
=C2=A0#include &quot;memory.h&quot;<br>
=C2=A0#include &quot;debug.h&quot;<br>
@@ -51,6 +52,23 @@ LIST_HEAD(clients);<br>
=C2=A0pthread_mutex_t client_lock =3D PTHREAD_MUTEX_INITIALIZER;<br>
=C2=A0struct pollfd *polls;<br>
<br>
+static bool _socket_client_is_root(int fd);<br>
+<br>
+static bool _socket_client_is_root(int fd)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0socklen_t len =3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct ucred uc;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0len =3D sizeof(struct ucred);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if ((fd &gt;=3D 0) &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(getsockopt(fd, SOL_SOCKET, SO_PE=
ERCRED, &amp;uc, &amp;len) =3D=3D 0) &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(uc.uid =3D=3D 0))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return true;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Treat error as not root client */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
+}<br>
+<br>
=C2=A0/*<br>
=C2=A0 * handle a new client joining<br>
=C2=A0 */<br>
@@ -255,6 +273,7 @@ void * uxsock_listen(uxsock_trigger_<wbr>fn uxsock_trig=
ger, void * trigger_data)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(4, &quot;cli[%d]: Got reques=
t [%s]&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i, inbuf=
);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 uxsock_trigger(inbuf, &amp;reply, &a=
mp;rlen,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 _socket_client_is_root(c-&gt;fd),<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0trigger_data);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (reply) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (send=
_packet(c-&gt;fd,<br>
diff --git a/multipathd/uxlsnr.h b/multipathd/uxlsnr.h<br>
index 4ef47d5..d51a8f9 100644<br>
--- a/multipathd/uxlsnr.h<br>
+++ b/multipathd/uxlsnr.h<br>
@@ -1,7 +1,9 @@<br>
=C2=A0#ifndef _UXLSNR_H<br>
=C2=A0#define _UXLSNR_H<br>
<br>
-typedef int (uxsock_trigger_fn)(char *, char **, int *, void *);<br>
+#include &lt;stdbool.h&gt;<br>
+<br>
+typedef int (uxsock_trigger_fn)(char *, char **, int *, bool, void *);<br>
<br>
=C2=A0void * uxsock_listen(uxsock_trigger_<wbr>fn uxsock_trigger,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0void * trigger_data);<br>
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

--001a11425b587c88ac05482b850b--


--===============2327190356306446509==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2327190356306446509==--
