From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 08/11] Reset timezone information on
	reconfigure
Date: Fri, 13 Dec 2013 23:22:24 +0100
Message-ID: <CABr-GncpPvTPJW0-HzSDkSxfh70WwwDGeoDTN_w5vUz+X15FFQ@mail.gmail.com>
References: <1386936854-8399-1-git-send-email-hare@suse.de>
	<1386936854-8399-9-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6695346919807515822=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386936854-8399-9-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============6695346919807515822==
Content-Type: multipart/alternative; boundary=20cf30363fa182711104ed71e500

--20cf30363fa182711104ed71e500
Content-Type: text/plain; charset=ISO-8859-1

Hannes,

FYI, related to your latest patchset,

commit dd205886ed2d41bb8e2602cb9771be403a99cd27
Author: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date:   Fri Dec 13 23:20:40 2013 +0100

    Add missing includes to support tzget() usage

diff --git a/libmultipath/log.c b/libmultipath/log.c
index 74702d8..ab92e2a 100644
--- a/libmultipath/log.c
+++ b/libmultipath/log.c
@@ -8,6 +8,7 @@
 #include <stdarg.h>
 #include <string.h>
 #include <syslog.h>
+#include <time.h>

 #include "memory.h"
 #include "log.h"
diff --git a/multipathd/main.c b/multipathd/main.c
index 37a9bc2..fd70b70 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -22,6 +22,7 @@
 #endif
 #include <semaphore.h>
 #include <mpath_persist.h>
+#include <time.h>

 /*
  * libcheckers


Best regards,
Christophe Varoqui


On Fri, Dec 13, 2013 at 1:14 PM, Hannes Reinecke <hare@suse.de> wrote:

> Whenever 'reconfigure' is called we need to re-initialize the
> timezone information as it might have been changed in the
> meantime.
>
> References: bnc#830511
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  libmultipath/log.c | 1 +
>  multipathd/main.c  | 3 +++
>  2 files changed, 4 insertions(+)
>
> diff --git a/libmultipath/log.c b/libmultipath/log.c
> index 37c7cd7..74702d8 100644
> --- a/libmultipath/log.c
> +++ b/libmultipath/log.c
> @@ -99,6 +99,7 @@ void log_close (void)
>  void log_reset (char *program_name)
>  {
>         closelog();
> +       tzset();
>         openlog(program_name, 0, LOG_DAEMON);
>  }
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 96564f8..1a1aa2d 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1416,6 +1416,9 @@ reconfigure (struct vectors * vecs)
>         vecs->pathvec = NULL;
>         conf = NULL;
>
> +       /* Re-read any timezone changes */
> +       tzset();
> +
>         if (!load_config(DEFAULT_CONFIGFILE, udev)) {
>                 conf->verbosity = old->verbosity;
>                 conf->daemon = 1;
> --
> 1.8.1.4
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--20cf30363fa182711104ed71e500
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hannes,</div><div><br></div>FYI, related to your late=
st patchset,<div><br></div><div><div>commit dd205886ed2d41bb8e2602cb9771be4=
03a99cd27</div><div>Author: Christophe Varoqui &lt;<a href=3D"mailto:christ=
ophe.varoqui@opensvc.com">christophe.varoqui@opensvc.com</a>&gt;</div>
<div>Date: =A0 Fri Dec 13 23:20:40 2013 +0100</div><div><br></div><div>=A0 =
=A0 Add missing includes to support tzget() usage</div><div><br></div><div>=
diff --git a/libmultipath/log.c b/libmultipath/log.c</div><div>index 74702d=
8..ab92e2a 100644</div>
<div>--- a/libmultipath/log.c</div><div>+++ b/libmultipath/log.c</div><div>=
@@ -8,6 +8,7 @@</div><div>=A0#include &lt;stdarg.h&gt;</div><div>=A0#includ=
e &lt;string.h&gt;</div><div>=A0#include &lt;syslog.h&gt;</div><div>+#inclu=
de &lt;time.h&gt;</div>
<div>=A0</div><div>=A0#include &quot;memory.h&quot;</div><div>=A0#include &=
quot;log.h&quot;</div><div>diff --git a/multipathd/main.c b/multipathd/main=
.c</div><div>index 37a9bc2..fd70b70 100644</div><div>--- a/multipathd/main.=
c</div>
<div>+++ b/multipathd/main.c</div><div>@@ -22,6 +22,7 @@</div><div>=A0#endi=
f</div><div>=A0#include &lt;semaphore.h&gt;</div><div>=A0#include &lt;mpath=
_persist.h&gt;</div><div>+#include &lt;time.h&gt;</div><div>=A0</div><div>=
=A0/*</div>
<div>=A0 * libcheckers</div></div><div><br></div><div><br></div><div>Best r=
egards,</div><div>Christophe Varoqui</div></div><div class=3D"gmail_extra">=
<br><br><div class=3D"gmail_quote">On Fri, Dec 13, 2013 at 1:14 PM, Hannes =
Reinecke <span dir=3D"ltr">&lt;<a href=3D"mailto:hare@suse.de" target=3D"_b=
lank">hare@suse.de</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">When=
ever &#39;reconfigure&#39; is called we need to re-initialize the<br>
timezone information as it might have been changed in the<br>
meantime.<br>
<br>
References: bnc#830511<br>
<br>
Signed-off-by: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.de">hare@sus=
e.de</a>&gt;<br>
---<br>
=A0libmultipath/log.c | 1 +<br>
=A0multipathd/main.c =A0| 3 +++<br>
=A02 files changed, 4 insertions(+)<br>
<br>
diff --git a/libmultipath/log.c b/libmultipath/log.c<br>
index 37c7cd7..74702d8 100644<br>
--- a/libmultipath/log.c<br>
+++ b/libmultipath/log.c<br>
@@ -99,6 +99,7 @@ void log_close (void)<br>
=A0void log_reset (char *program_name)<br>
=A0{<br>
=A0 =A0 =A0 =A0 closelog();<br>
+ =A0 =A0 =A0 tzset();<br>
=A0 =A0 =A0 =A0 openlog(program_name, 0, LOG_DAEMON);<br>
=A0}<br>
<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index 96564f8..1a1aa2d 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -1416,6 +1416,9 @@ reconfigure (struct vectors * vecs)<br>
=A0 =A0 =A0 =A0 vecs-&gt;pathvec =3D NULL;<br>
=A0 =A0 =A0 =A0 conf =3D NULL;<br>
<br>
+ =A0 =A0 =A0 /* Re-read any timezone changes */<br>
+ =A0 =A0 =A0 tzset();<br>
+<br>
=A0 =A0 =A0 =A0 if (!load_config(DEFAULT_CONFIGFILE, udev)) {<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 conf-&gt;verbosity =3D old-&gt;verbosity;<b=
r>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 conf-&gt;daemon =3D 1;<br>
--<br>
1.8.1.4<br>
<br>
</div></div>--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</blockquote></div><br></div>

--20cf30363fa182711104ed71e500--


--===============6695346919807515822==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6695346919807515822==--
