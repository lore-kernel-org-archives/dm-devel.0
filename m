From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: use internal drd.h file
Date: Sun, 16 Oct 2016 19:34:46 +0200
Message-ID: <CABr-GndgxrsHVtJJQg1TBwSU-v1WRo+TKhPVc+S-NjqTt63q2w@mail.gmail.com>
References: <20161008202212.11963-1-xose.vazquez@gmail.com>
	<9e801117-cb59-b3a7-de85-b724326d2b34@gmail.com>
	<ea6f0aac-4ca5-e3dd-da71-5a4a1361de64@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4246499624600082918=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ea6f0aac-4ca5-e3dd-da71-5a4a1361de64@suse.de>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============4246499624600082918==
Content-Type: multipart/alternative; boundary=001a114017022d0ce0053efee0be

--001a114017022d0ce0053efee0be
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

That's why we included a copy of the required valgrind header.
Does this solution eleviate your complain ?

On Sun, Oct 16, 2016 at 6:59 PM, Hannes Reinecke <hare@suse.de> wrote:

> On 10/16/2016 12:26 PM, Xose Vazquez Perez wrote:
>
>> On 10/08/2016 10:22 PM, Xose Vazquez Perez wrote:
>>
>> Cc: Bart Van Assche <bart.vanassche@sandisk.com>
>>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>>> Cc: device-mapper development <dm-devel@redhat.com>
>>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>>> ---
>>>  libmultipath/debug.c | 2 +-
>>>  multipathd/main.c    | 2 +-
>>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>
>> This patch is missing.
>> Thank you.
>>
>>
>> diff --git a/libmultipath/debug.c b/libmultipath/debug.c
>>> index 295136c..fbe171a 100644
>>> --- a/libmultipath/debug.c
>>> +++ b/libmultipath/debug.c
>>> @@ -8,7 +8,7 @@
>>>  #include "log_pthread.h"
>>>  #include <sys/types.h>
>>>  #include <time.h>
>>> -#include <../third-party/valgrind/drd.h>
>>> +#include "../third-party/valgrind/drd.h"
>>>  #include "vector.h"
>>>  #include "config.h"
>>>
>>> diff --git a/multipathd/main.c b/multipathd/main.c
>>> index cdfafe8..0998085 100644
>>> --- a/multipathd/main.c
>>> +++ b/multipathd/main.c
>>> @@ -23,7 +23,6 @@
>>>  #endif
>>>  #include <semaphore.h>
>>>  #include <time.h>
>>> -#include <valgrind/drd.h>
>>>
>>>  /*
>>>   * libmultipath
>>> @@ -85,6 +84,7 @@ int uxsock_timeout;
>>>  #include "lock.h"
>>>  #include "waiter.h"
>>>  #include "wwids.h"
>>> +#include "../third-party/valgrind/drd.h"
>>>
>>>  #define FILE_NAME_SIZE 256
>>>  #define CMDSIZE 160
>>>
>>>
>> Please don't.
> We're trying to keep dependencies to each package as small as possible.
> And requiring valgrind by default is not going to help here.
> Please make this a compile-time option.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                   zSeries & Storage
> hare@suse.de                          +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg)
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a114017022d0ce0053efee0be
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">That&#39;s why we included a copy of the required valgrind=
 header.<div>Does this solution eleviate your complain ?</div></div><div cl=
ass=3D"gmail_extra"><br><div class=3D"gmail_quote">On Sun, Oct 16, 2016 at =
6:59 PM, Hannes Reinecke <span dir=3D"ltr">&lt;<a href=3D"mailto:hare@suse.=
de" target=3D"_blank">hare@suse.de</a>&gt;</span> wrote:<br><blockquote cla=
ss=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;pa=
dding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On 10/16/2016 12:26=
 PM, Xose Vazquez Perez wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
On 10/08/2016 10:22 PM, Xose Vazquez Perez wrote:<br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Cc: Bart Van Assche &lt;<a href=3D"mailto:bart.vanassche@sandisk.com" targe=
t=3D"_blank">bart.vanassche@sandisk.com</a>&gt;<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
" target=3D"_blank">christophe.varoqui@opensvc.co<wbr>m</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com" ta=
rget=3D"_blank">dm-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com" target=3D"_blank">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/debug.c | 2 +-<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 | 2 +-<br>
=C2=A02 files changed, 2 insertions(+), 2 deletions(-)<br>
</blockquote>
<br>
This patch is missing.<br>
Thank you.<br>
<br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
diff --git a/libmultipath/debug.c b/libmultipath/debug.c<br>
index 295136c..fbe171a 100644<br>
--- a/libmultipath/debug.c<br>
+++ b/libmultipath/debug.c<br>
@@ -8,7 +8,7 @@<br>
=C2=A0#include &quot;log_pthread.h&quot;<br>
=C2=A0#include &lt;sys/types.h&gt;<br>
=C2=A0#include &lt;time.h&gt;<br>
-#include &lt;../third-party/valgrind/drd.h<wbr>&gt;<br>
+#include &quot;../third-party/valgrind/drd.h<wbr>&quot;<br>
=C2=A0#include &quot;vector.h&quot;<br>
=C2=A0#include &quot;config.h&quot;<br>
<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index cdfafe8..0998085 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -23,7 +23,6 @@<br>
=C2=A0#endif<br>
=C2=A0#include &lt;semaphore.h&gt;<br>
=C2=A0#include &lt;time.h&gt;<br>
-#include &lt;valgrind/drd.h&gt;<br>
<br>
=C2=A0/*<br>
=C2=A0 * libmultipath<br>
@@ -85,6 +84,7 @@ int uxsock_timeout;<br>
=C2=A0#include &quot;lock.h&quot;<br>
=C2=A0#include &quot;waiter.h&quot;<br>
=C2=A0#include &quot;wwids.h&quot;<br>
+#include &quot;../third-party/valgrind/drd.h<wbr>&quot;<br>
<br>
=C2=A0#define FILE_NAME_SIZE 256<br>
=C2=A0#define CMDSIZE 160<br>
<br>
</blockquote>
<br>
</blockquote></div></div>
Please don&#39;t.<br>
We&#39;re trying to keep dependencies to each package as small as possible.=
<br>
And requiring valgrind by default is not going to help here.<br>
Please make this a compile-time option.<br>
<br>
Cheers,<br>
<br>
Hannes<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-- <br>
Dr. Hannes Reinecke=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0zSeries &amp; Storage<br>
<a href=3D"mailto:hare@suse.de" target=3D"_blank">hare@suse.de</a>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 <a href=3D"tel:%2B49%20911%2074053%20688" value=3D"+499117405368=
8" target=3D"_blank">+49 911 74053 688</a><br>
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg<br>
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg)</f=
ont></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman<wbr>/listinfo/dm-deve=
l</a><br>
</div></div></blockquote></div><br></div>

--001a114017022d0ce0053efee0be--


--===============4246499624600082918==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4246499624600082918==--
