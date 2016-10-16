From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: use internal drd.h file
Date: Sun, 16 Oct 2016 17:54:12 +0200
Message-ID: <CABr-Gndo+TkTLqxdCLiz7HCNiOpLuRoHJess5e6if9hVSKiYCg@mail.gmail.com>
References: <20161008202212.11963-1-xose.vazquez@gmail.com>
	<9e801117-cb59-b3a7-de85-b724326d2b34@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1262091075069596633=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9e801117-cb59-b3a7-de85-b724326d2b34@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1262091075069596633==
Content-Type: multipart/alternative; boundary=94eb2c0c8ea27ec884053efd7863

--94eb2c0c8ea27ec884053efd7863
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Sun, Oct 16, 2016 at 12:26 PM, Xose Vazquez Perez <xose.vazquez@gmail.com
> wrote:

> On 10/08/2016 10:22 PM, Xose Vazquez Perez wrote:
>
> > Cc: Bart Van Assche <bart.vanassche@sandisk.com>
> > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > Cc: device-mapper development <dm-devel@redhat.com>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > ---
> >  libmultipath/debug.c | 2 +-
> >  multipathd/main.c    | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
>
> This patch is missing.
> Thank you.
>
>
> > diff --git a/libmultipath/debug.c b/libmultipath/debug.c
> > index 295136c..fbe171a 100644
> > --- a/libmultipath/debug.c
> > +++ b/libmultipath/debug.c
> > @@ -8,7 +8,7 @@
> >  #include "log_pthread.h"
> >  #include <sys/types.h>
> >  #include <time.h>
> > -#include <../third-party/valgrind/drd.h>
> > +#include "../third-party/valgrind/drd.h"
> >  #include "vector.h"
> >  #include "config.h"
> >
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index cdfafe8..0998085 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -23,7 +23,6 @@
> >  #endif
> >  #include <semaphore.h>
> >  #include <time.h>
> > -#include <valgrind/drd.h>
> >
> >  /*
> >   * libmultipath
> > @@ -85,6 +84,7 @@ int uxsock_timeout;
> >  #include "lock.h"
> >  #include "waiter.h"
> >  #include "wwids.h"
> > +#include "../third-party/valgrind/drd.h"
> >
> >  #define FILE_NAME_SIZE 256
> >  #define CMDSIZE 160
> >
>
>

--94eb2c0c8ea27ec884053efd7863
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Sun, Oct 16, 2016 at 12:26 PM, Xose Vazqu=
ez Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" ta=
rget=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex"><span class=3D"">On 10/08/2016 10:22 PM, Xose Vazquez P=
erez wrote:<br>
<br>
&gt; Cc: Bart Van Assche &lt;<a href=3D"mailto:bart.vanassche@sandisk.com">=
bart.vanassche@sandisk.com</a>&gt;<br>
&gt; Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensv=
c.com">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
&gt; Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.co=
m">dm-devel@redhat.com</a>&gt;<br>
&gt; Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@g=
mail.com">xose.vazquez@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 libmultipath/debug.c | 2 +-<br>
&gt;=C2=A0 multipathd/main.c=C2=A0 =C2=A0 | 2 +-<br>
&gt;=C2=A0 2 files changed, 2 insertions(+), 2 deletions(-)<br>
<br>
</span>This patch is missing.<br>
Thank you.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
<br>
&gt; diff --git a/libmultipath/debug.c b/libmultipath/debug.c<br>
&gt; index 295136c..fbe171a 100644<br>
&gt; --- a/libmultipath/debug.c<br>
&gt; +++ b/libmultipath/debug.c<br>
&gt; @@ -8,7 +8,7 @@<br>
&gt;=C2=A0 #include &quot;log_pthread.h&quot;<br>
&gt;=C2=A0 #include &lt;sys/types.h&gt;<br>
&gt;=C2=A0 #include &lt;time.h&gt;<br>
&gt; -#include &lt;../third-party/valgrind/drd.<wbr>h&gt;<br>
&gt; +#include &quot;../third-party/valgrind/drd.<wbr>h&quot;<br>
&gt;=C2=A0 #include &quot;vector.h&quot;<br>
&gt;=C2=A0 #include &quot;config.h&quot;<br>
&gt;<br>
&gt; diff --git a/multipathd/main.c b/multipathd/main.c<br>
&gt; index cdfafe8..0998085 100644<br>
&gt; --- a/multipathd/main.c<br>
&gt; +++ b/multipathd/main.c<br>
&gt; @@ -23,7 +23,6 @@<br>
&gt;=C2=A0 #endif<br>
&gt;=C2=A0 #include &lt;semaphore.h&gt;<br>
&gt;=C2=A0 #include &lt;time.h&gt;<br>
&gt; -#include &lt;valgrind/drd.h&gt;<br>
&gt;<br>
&gt;=C2=A0 /*<br>
&gt;=C2=A0 =C2=A0* libmultipath<br>
&gt; @@ -85,6 +84,7 @@ int uxsock_timeout;<br>
&gt;=C2=A0 #include &quot;lock.h&quot;<br>
&gt;=C2=A0 #include &quot;waiter.h&quot;<br>
&gt;=C2=A0 #include &quot;wwids.h&quot;<br>
&gt; +#include &quot;../third-party/valgrind/drd.<wbr>h&quot;<br>
&gt;<br>
&gt;=C2=A0 #define FILE_NAME_SIZE 256<br>
&gt;=C2=A0 #define CMDSIZE 160<br>
&gt;<br>
<br>
</div></div></blockquote></div><br></div>

--94eb2c0c8ea27ec884053efd7863--


--===============1262091075069596633==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1262091075069596633==--
