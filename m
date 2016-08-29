From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipathd: Suppress uninteresting data race
	reports
Date: Mon, 29 Aug 2016 09:19:35 +0200
Message-ID: <CABr-Gnc6OQRhUeXtkHn-_CVYcSvYco78i1euggauTcjVNSrv5A@mail.gmail.com>
References: <01747bb5-c10e-a3b6-e440-d9443837a6f7@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0114436332960455422=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <01747bb5-c10e-a3b6-e440-d9443837a6f7@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0114436332960455422==
Content-Type: multipart/alternative; boundary=001a11419434c16823053b30af60

--001a11419434c16823053b30af60
Content-Type: text/plain; charset=UTF-8

Hi,

I think it would be fair to detect the valgrind headers presence in the
Makefile and ifdef the include (else define dummy ANNOTATE_* macros).

Would you care to prepare that ?

Thanks.


On Tue, Aug 16, 2016 at 10:00 PM, Bart Van Assche <
bart.vanassche@sandisk.com> wrote:

> The global variable multipath_conf is modified through RCU. Hence
> avoid that the data race detection tools Helgrind and DRD report
> data races for this variable.
>
> The global variable running_state is read without holding the mutex
> that protects changes of this variable. Suppress complaints about
> these reads.
>
> The global variable uxsock_timeout is not protected by any mutex.
> Suppress complaints about using this variable.
>
> This patch introduces a new build-time requirement, namely that
> the valgrind-devel package has been installed.
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> ---
>  multipathd/main.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 1d73b4c..54abfef 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -23,6 +23,7 @@
>  #endif
>  #include <semaphore.h>
>  #include <time.h>
> +#include <valgrind/helgrind.h>
>
>  /*
>   * libcheckers
> @@ -2520,6 +2521,13 @@ main (int argc, char *argv[])
>         int foreground = 0;
>         struct config *conf;
>
> +       ANNOTATE_BENIGN_RACE_SIZED(&multipath_conf,
> sizeof(multipath_conf),
> +                                  "Manipulated through RCU");
> +       ANNOTATE_BENIGN_RACE_SIZED(&running_state, sizeof(running_state),
> +               "Suppress complaints about unprotected running_state
> reads");
> +       ANNOTATE_BENIGN_RACE_SIZED(&uxsock_timeout,
> sizeof(uxsock_timeout),
> +               "Suppress complaints about this scalar variable");
> +
>         logsink = 1;
>
>         if (getuid() != 0) {
> --
> 2.9.2
>
>

--001a11419434c16823053b30af60
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>I think it would be fair to detect =
the valgrind headers presence in the Makefile and ifdef the include (else d=
efine dummy ANNOTATE_* macros).</div><div><br></div><div>Would you care to =
prepare that ?</div><div><br></div><div>Thanks.</div><div><br></div></div><=
div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Tue, Aug 16, 20=
16 at 10:00 PM, Bart Van Assche <span dir=3D"ltr">&lt;<a href=3D"mailto:bar=
t.vanassche@sandisk.com" target=3D"_blank">bart.vanassche@sandisk.com</a>&g=
t;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0=
 .8ex;border-left:1px #ccc solid;padding-left:1ex">The global variable mult=
ipath_conf is modified through RCU. Hence<br>
avoid that the data race detection tools Helgrind and DRD report<br>
data races for this variable.<br>
<br>
The global variable running_state is read without holding the mutex<br>
that protects changes of this variable. Suppress complaints about<br>
these reads.<br>
<br>
The global variable uxsock_timeout is not protected by any mutex.<br>
Suppress complaints about using this variable.<br>
<br>
This patch introduces a new build-time requirement, namely that<br>
the valgrind-devel package has been installed.<br>
<br>
Signed-off-by: Bart Van Assche &lt;<a href=3D"mailto:bart.vanassche@sandisk=
.com">bart.vanassche@sandisk.com</a>&gt;<br>
---<br>
=C2=A0multipathd/main.c | 8 ++++++++<br>
=C2=A01 file changed, 8 insertions(+)<br>
<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index 1d73b4c..54abfef 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -23,6 +23,7 @@<br>
=C2=A0#endif<br>
=C2=A0#include &lt;semaphore.h&gt;<br>
=C2=A0#include &lt;time.h&gt;<br>
+#include &lt;valgrind/helgrind.h&gt;<br>
<br>
=C2=A0/*<br>
=C2=A0 * libcheckers<br>
@@ -2520,6 +2521,13 @@ main (int argc, char *argv[])<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int foreground =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct config *conf;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0ANNOTATE_BENIGN_RACE_SIZED(&amp;<wbr>multipath_=
conf, sizeof(multipath_conf),<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;Manipulated through RCU=
&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0ANNOTATE_BENIGN_RACE_SIZED(&amp;<wbr>running_st=
ate, sizeof(running_state),<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;Suppress comp=
laints about unprotected running_state reads&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0ANNOTATE_BENIGN_RACE_SIZED(&amp;<wbr>uxsock_tim=
eout, sizeof(uxsock_timeout),<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;Suppress comp=
laints about this scalar variable&quot;);<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 logsink =3D 1;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (getuid() !=3D 0) {<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.9.2<br>
<br>
</font></span></blockquote></div><br></div>

--001a11419434c16823053b30af60--


--===============0114436332960455422==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0114436332960455422==--
