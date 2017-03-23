From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: arrange compilation options
	for binaries
Date: Thu, 23 Mar 2017 10:09:42 +0100
Message-ID: <CABr-GnfmGzcnW0GcqMLWs0Zg30Txw0k+3Er6zyrRpRrmcN-gwQ@mail.gmail.com>
References: <20170317224002.8967-1-xose.vazquez@gmail.com>
	<CABr-GndoZc+maRDaerfgUupPw4TeSgzf+aF9gZh0VNtKsjfQCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4859215335678173944=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GndoZc+maRDaerfgUupPw4TeSgzf+aF9gZh0VNtKsjfQCA@mail.gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============4859215335678173944==
Content-Type: multipart/alternative; boundary=94eb2c0629b2cfef17054b623c5c

--94eb2c0629b2cfef17054b623c5c
Content-Type: text/plain; charset=UTF-8

And reverted:

From http://eli.thegreenplace.net/2013/07/09/library-order-in-static-linking
:

If object or library AA needs a symbol from library BB, then AA should come
*before* library BB in the command-line invocation of the linker.



On Thu, Mar 23, 2017 at 9:34 AM, Christophe Varoqui <
christophe.varoqui@opensvc.com> wrote:

> Merged,
> Thanks.
>
> On Fri, Mar 17, 2017 at 11:40 PM, Xose Vazquez Perez <
> xose.vazquez@gmail.com> wrote:
>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: device-mapper development <dm-devel@redhat.com>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> ---
>>  kpartx/Makefile       | 2 +-
>>  mpathpersist/Makefile | 2 +-
>>  multipath/Makefile    | 2 +-
>>  multipathd/Makefile   | 2 +-
>>  4 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/kpartx/Makefile b/kpartx/Makefile
>> index 9441a2b..2e81284 100644
>> --- a/kpartx/Makefile
>> +++ b/kpartx/Makefile
>> @@ -19,7 +19,7 @@ EXEC = kpartx
>>  all: $(EXEC)
>>
>>  $(EXEC): $(OBJS)
>> -       $(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $(LIBDEPS)
>> +       $(CC) $(CFLAGS) $(LDFLAGS) $(LIBDEPS) $(OBJS) -o $(EXEC)
>>         $(GZIP) $(EXEC).8 > $(EXEC).8.gz
>>
>>  install: $(EXEC) $(EXEC).8
>> diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
>> index 47043bb..27e921e 100644
>> --- a/mpathpersist/Makefile
>> +++ b/mpathpersist/Makefile
>> @@ -12,7 +12,7 @@ OBJS = main.o
>>  all: $(EXEC)
>>
>>  $(EXEC): $(OBJS)
>> -       $(CC) $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS) $(LIBDEPS)
>> +       $(CC) $(CFLAGS) $(LDFLAGS) $(LIBDEPS) $(OBJS) -o $(EXEC)
>>         $(GZIP) $(EXEC).8 > $(EXEC).8.gz
>>
>>  install:
>> diff --git a/multipath/Makefile b/multipath/Makefile
>> index cad34bf..421490c 100644
>> --- a/multipath/Makefile
>> +++ b/multipath/Makefile
>> @@ -15,7 +15,7 @@ OBJS = main.o
>>  all: $(EXEC)
>>
>>  $(EXEC): $(OBJS)
>> -       $(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $(LIBDEPS)
>> +       $(CC) $(CFLAGS) $(LDFLAGS) $(LIBDEPS) $(OBJS) -o $(EXEC)
>>         $(GZIP) $(EXEC).8 > $(EXEC).8.gz
>>         $(GZIP) $(EXEC).conf.5 > $(EXEC).conf.5.gz
>>
>> diff --git a/multipathd/Makefile b/multipathd/Makefile
>> index d57f6d5..a3fad61 100644
>> --- a/multipathd/Makefile
>> +++ b/multipathd/Makefile
>> @@ -29,7 +29,7 @@ EXEC = multipathd
>>  all : $(EXEC)
>>
>>  $(EXEC): $(OBJS)
>> -       $(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $(EXEC) $(LIBDEPS)
>> +       $(CC) $(CFLAGS) $(LDFLAGS) $(LIBDEPS) $(OBJS) -o $(EXEC)
>>         $(GZIP) $(EXEC).8 > $(EXEC).8.gz
>>
>>  install:
>> --
>> 2.12.0
>>
>>
>

--94eb2c0629b2cfef17054b623c5c
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">And reverted:<div><br></div><div>From <a href=3D"http://el=
i.thegreenplace.net/2013/07/09/library-order-in-static-linking">http://eli.=
thegreenplace.net/2013/07/09/library-order-in-static-linking</a>:<br></div>=
<div><br></div><div><div class=3D"gmail-section" id=3D"gmail-simple-example=
s" style=3D"box-sizing:border-box;color:rgb(51,51,51);font-family:&quot;dro=
id sans&quot;,sans-serif;font-size:16px"><blockquote style=3D"box-sizing:bo=
rder-box;padding:10px 20px;margin:0px 0px 20px;border-left:5px solid rgb(23=
8,238,238)">If object or library AA needs a symbol from library BB, then AA=
 should come=C2=A0<em style=3D"box-sizing:border-box">before</em>=C2=A0libr=
ary BB in the command-line invocation of the linker.</blockquote><div><br><=
/div></div><div class=3D"gmail-section" id=3D"gmail-circular-dependency" st=
yle=3D"box-sizing:border-box;color:rgb(51,51,51);font-family:&quot;droid sa=
ns&quot;,sans-serif;font-size:16px"></div></div></div><div class=3D"gmail_e=
xtra"><br><div class=3D"gmail_quote">On Thu, Mar 23, 2017 at 9:34 AM, Chris=
tophe Varoqui <span dir=3D"ltr">&lt;<a href=3D"mailto:christophe.varoqui@op=
ensvc.com" target=3D"_blank">christophe.varoqui@opensvc.com</a>&gt;</span> =
wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bord=
er-left:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr">Merged,<div>Thank=
s.</div></div><div class=3D"HOEnZb"><div class=3D"h5"><div class=3D"gmail_e=
xtra"><br><div class=3D"gmail_quote">On Fri, Mar 17, 2017 at 11:40 PM, Xose=
 Vazquez Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.c=
om" target=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><bloc=
kquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #cc=
c solid;padding-left:1ex">Cc: Christophe Varoqui &lt;<a href=3D"mailto:chri=
stophe.varoqui@opensvc.com" target=3D"_blank">christophe.varoqui@opensvc.co=
<wbr>m</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com" ta=
rget=3D"_blank">dm-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com" target=3D"_blank">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0kpartx/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0| 2 +-<br>
=C2=A0mpathpersist/Makefile | 2 +-<br>
=C2=A0multipath/Makefile=C2=A0 =C2=A0 | 2 +-<br>
=C2=A0multipathd/Makefile=C2=A0 =C2=A0| 2 +-<br>
=C2=A04 files changed, 4 insertions(+), 4 deletions(-)<br>
<br>
diff --git a/kpartx/Makefile b/kpartx/Makefile<br>
index 9441a2b..2e81284 100644<br>
--- a/kpartx/Makefile<br>
+++ b/kpartx/Makefile<br>
@@ -19,7 +19,7 @@ EXEC =3D kpartx<br>
=C2=A0all: $(EXEC)<br>
<br>
=C2=A0$(EXEC): $(OBJS)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $=
(LIBDEPS)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(CFLAGS) $(LDFLAGS) $(LIBDEPS) $(OBJS) -=
o $(EXEC)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(GZIP) $(EXEC).8 &gt; $(EXEC).8.gz<br>
<br>
=C2=A0install: $(EXEC) $(EXEC).8<br>
diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile<br>
index 47043bb..27e921e 100644<br>
--- a/mpathpersist/Makefile<br>
+++ b/mpathpersist/Makefile<br>
@@ -12,7 +12,7 @@ OBJS =3D main.o<br>
=C2=A0all: $(EXEC)<br>
<br>
=C2=A0$(EXEC): $(OBJS)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS) $=
(LIBDEPS)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(CFLAGS) $(LDFLAGS) $(LIBDEPS) $(OBJS) -=
o $(EXEC)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(GZIP) $(EXEC).8 &gt; $(EXEC).8.gz<br>
<br>
=C2=A0install:<br>
diff --git a/multipath/Makefile b/multipath/Makefile<br>
index cad34bf..421490c 100644<br>
--- a/multipath/Makefile<br>
+++ b/multipath/Makefile<br>
@@ -15,7 +15,7 @@ OBJS =3D main.o<br>
=C2=A0all: $(EXEC)<br>
<br>
=C2=A0$(EXEC): $(OBJS)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $=
(LIBDEPS)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(CFLAGS) $(LDFLAGS) $(LIBDEPS) $(OBJS) -=
o $(EXEC)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(GZIP) $(EXEC).8 &gt; $(EXEC).8.gz<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(GZIP) $(EXEC).conf.5 &gt; $(EXEC).conf.5.gz<b=
r>
<br>
diff --git a/multipathd/Makefile b/multipathd/Makefile<br>
index d57f6d5..a3fad61 100644<br>
--- a/multipathd/Makefile<br>
+++ b/multipathd/Makefile<br>
@@ -29,7 +29,7 @@ EXEC =3D multipathd<br>
=C2=A0all : $(EXEC)<br>
<br>
=C2=A0$(EXEC): $(OBJS)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $(EXEC) $=
(LIBDEPS)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(CFLAGS) $(LDFLAGS) $(LIBDEPS) $(OBJS) -=
o $(EXEC)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(GZIP) $(EXEC).8 &gt; $(EXEC).8.gz<br>
<br>
=C2=A0install:<br>
<span class=3D"m_-275185102971043105HOEnZb"><font color=3D"#888888">--<br>
2.12.0<br>
<br>
</font></span></blockquote></div><br></div>
</div></div></blockquote></div><br></div>

--94eb2c0629b2cfef17054b623c5c--


--===============4859215335678173944==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4859215335678173944==--
