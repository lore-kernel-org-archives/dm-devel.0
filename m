From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipathd: fix waiter_attr resource leak
Date: Sat, 9 Jul 2016 09:46:30 +0200
Message-ID: <CABr-Gnd301a+7j5wmHWgyLUNG9aSdaje7Y8DWBNxJRDc5zsErw@mail.gmail.com>
References: <OF23BCA109.0BE2FFED-ON48257FE8.0023BAD2-48257FE8.002CA989@zte.com.cn>
	<CABr-GndMYzjsQrpvi8vNrD9AYUzLO7KmSFOkaOE-Mb4t+O-p5Q@mail.gmail.com>
	<20160708193314.GJ8095@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1993232794094195428=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160708193314.GJ8095@octiron.msp.redhat.com>
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
Cc: zhang.kai16@zte.com.cn, device-mapper development <dm-devel@redhat.com>, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

--===============1993232794094195428==
Content-Type: multipart/alternative; boundary=001a1142b63615363805372f1efa

--001a1142b63615363805372f1efa
Content-Type: text/plain; charset=UTF-8

Applied then.
Thanks.

On Fri, Jul 8, 2016 at 9:33 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Fri, Jul 08, 2016 at 09:59:18AM +0200, Christophe Varoqui wrote:
>
> ACK
>
> -Ben
>
>
> >    Ben, Hannes, I'd appreciate your ack on this patch.
> >    Thanks.
> >    On Wed, Jul 6, 2016 at 10:08 AM, <[1]zhang.kai16@zte.com.cn> wrote:
> >
> >      As a global variable waiter_attr of thread attribute was set up in
> the
> >      daemon,
> >      however,it hasn't been destroyed when the daemon exited.
> >      We need deinitialize waiter_attr.
> >
> >      ---
> >      multipathd/main.c | 3 +++
> >      1 file changed, 3 insertions(+)
> >
> >      diff --git a/multipathd/main.c b/multipathd/main.c
> >      index b86374f..09c5485 100644
> >      --- a/multipathd/main.c
> >      +++ b/multipathd/main.c
> >      @@ -2317,6 +2317,9 @@ child (void * param)
> >                       conf = NULL;
> >                       udev_unref(udev);
> >                       udev = NULL;
> >      +
> >      +                 pthread_attr_destroy(&waiter_attr);
> >      +
> >      #ifdef _DEBUG_
> >                       dbg_free_final(NULL);
> >      #endif
> >      --
> >      1.9.1
> >
> >  --------------------------------------------------------
> >  ZTE Information Security Notice: The information contained in this mail
> (and any attachment transmitted herewith) is privileged and confidential
> and is intended for the exclusive use of the addressee(s).  If you are not
> an intended recipient, any disclosure, reproduction, distribution or other
> dissemination or use of the information contained is strictly prohibited.
> If you have received this mail in error, please delete it and notify us
> immediately.
> >
> >
> >      --
> >      dm-devel mailing list
> >      [2]dm-devel@redhat.com
> >      [3]https://www.redhat.com/mailman/listinfo/dm-devel
> >
> > References
> >
> >    Visible links
> >    1. mailto:zhang.kai16@zte.com.cn
> >    2. mailto:dm-devel@redhat.com
> >    3. https://www.redhat.com/mailman/listinfo/dm-devel
>
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
>
>

--001a1142b63615363805372f1efa
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied then.<div>Thanks.</div></div><div class=3D"gmail_e=
xtra"><br><div class=3D"gmail_quote">On Fri, Jul 8, 2016 at 9:33 PM, Benjam=
in Marzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" t=
arget=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;=
padding-left:1ex">On Fri, Jul 08, 2016 at 09:59:18AM +0200, Christophe Varo=
qui wrote:<br>
<br>
ACK<br>
<br>
-Ben<br>
<span class=3D""><br>
<br>
&gt;=C2=A0 =C2=A0 Ben, Hannes, I&#39;d appreciate your ack on this patch.<b=
r>
&gt;=C2=A0 =C2=A0 Thanks.<br>
</span><div><div class=3D"h5">&gt;=C2=A0 =C2=A0 On Wed, Jul 6, 2016 at 10:0=
8 AM, &lt;[1]<a href=3D"mailto:zhang.kai16@zte.com.cn">zhang.kai16@zte.com.=
cn</a>&gt; wrote:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 As a global variable waiter_attr of thread attribu=
te was set up in the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 daemon,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 however,it hasn&#39;t been destroyed when the daem=
on exited.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 We need deinitialize waiter_attr.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 ---<br>
&gt;=C2=A0 =C2=A0 =C2=A0 multipathd/main.c | 3 +++<br>
&gt;=C2=A0 =C2=A0 =C2=A0 1 file changed, 3 insertions(+)<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 diff --git a/multipathd/main.c b/multipathd/main.c=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 index b86374f..09c5485 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0 --- a/multipathd/main.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +++ b/multipathd/main.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 @@ -2317,6 +2317,9 @@ child (void * param)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0conf =3D NULL;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0udev_unref(udev);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0udev =3D NULL;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 pthread_attr_destroy(&amp;waiter_attr);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 #ifdef _DEBUG_<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0dbg_free_final(NULL);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 #endif<br>
&gt;=C2=A0 =C2=A0 =C2=A0 --<br>
&gt;=C2=A0 =C2=A0 =C2=A0 1.9.1<br>
&gt;<br>
&gt;=C2=A0 --------------------------------------------------------<br>
&gt;=C2=A0 ZTE Information Security Notice: The information contained in th=
is mail (and any attachment transmitted herewith) is privileged and confide=
ntial and is intended for the exclusive use of the addressee(s).=C2=A0 If y=
ou are not an intended recipient, any disclosure, reproduction, distributio=
n or other dissemination or use of the information contained is strictly pr=
ohibited.=C2=A0 If you have received this mail in error, please delete it a=
nd notify us immediately.<br>
&gt;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 --<br>
&gt;=C2=A0 =C2=A0 =C2=A0 dm-devel mailing list<br>
</div></div>&gt;=C2=A0 =C2=A0 =C2=A0 [2]<a href=3D"mailto:dm-devel@redhat.c=
om">dm-devel@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 [3]<a href=3D"https://www.redhat.com/mailman/listi=
nfo/dm-devel" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.com/m=
ailman/listinfo/dm-devel</a><br>
&gt;<br>
&gt; References<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 Visible links<br>
&gt;=C2=A0 =C2=A0 1. mailto:<a href=3D"mailto:zhang.kai16@zte.com.cn">zhang=
.kai16@zte.com.cn</a><br>
&gt;=C2=A0 =C2=A0 2. mailto:<a href=3D"mailto:dm-devel@redhat.com">dm-devel=
@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 3. <a href=3D"https://www.redhat.com/mailman/listinfo/dm-=
devel" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.com/mailman/=
listinfo/dm-devel</a><br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; --<br>
&gt; dm-devel mailing list<br>
&gt; <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"no=
referrer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-deve=
l</a><br>
<br>
</div></div></blockquote></div><br></div>

--001a1142b63615363805372f1efa--


--===============1993232794094195428==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1993232794094195428==--
