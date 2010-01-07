From: =?GB2312?B?1cXT7g==?= <chaimvy@gmail.com>
Subject: Re: Shared snapshots
Date: Thu, 7 Jan 2010 18:08:27 +0800
Message-ID: <b8091bb41001070208h6f6240e5o4da469789ccea343@mail.gmail.com>
References: <Pine.LNX.4.64.1001060927120.28095@hs20-bc2-1.build.redhat.com>
	<20100107084255.GP25902@reaktio.net>
	<70f06bad1001070105u3e459695r462ebed9a0c88153@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0672360268711012688=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <70f06bad1001070105u3e459695r462ebed9a0c88153@mail.gmail.com>
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

--===============0672360268711012688==
Content-Type: multipart/alternative; boundary=001636e0b60193147d047c9040d6

--001636e0b60193147d047c9040d6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

both of the origin device and the snapshot device can't be resized
dynamically?

2010/1/7 haad <haaaad@gmail.com>

>  On Thu, Jan 7, 2010 at 9:42 AM, Pasi K=E4rkk=E4inen <pasik@iki.fi> wrote=
:
> > On Wed, Jan 06, 2010 at 09:38:00AM -0500, Mikulas Patocka wrote:
> >> Hi
> >>
> >> I uploaded new code for shared snapshots at
> >> http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/devel/
> >>
> >> Changes:
> >> - two queues, one for reads and one for writes, to improve read latenc=
y
> >> when the device is write-congested
> >> - limit number of reallocations in flight (VM subsystem sends all writ=
es
> >> at once and without limit it creates big lags).
> >> - fixed one place where it didn't handle on-disk errors
> >> - simplified bitmap creation, removed some unneeded code
> >> - new macro for error reporting, as suggested by Zdenek
> >> - some comments added
> >> - DM_ prefix added to some macros
> >>
> >> Userspace for lvm 2.02.53 is at
> >>
> http://people.redhat.com/mpatocka/patches/userspace/new-snapshots/lvm-2.0=
2.54/
> >>
> >> Please, someone, do offensive testing with this --- i.e. apply the
> >> patches, try it, and try all possible lvm commands with it, try to
> stress
> >> and crash it in various ways, etc. If we wait with testing until
> Alasdair
> >> reads the code, it won't get much testing...
> >>
> >
> > Sorry for a stupid question, but what does "shared" mean? Support for
> CLVM?
>
> No all snapshots share one, common exception store I think.
>
>
>
> --
>
>
> Regards.
>
> Adam
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001636e0b60193147d047c9040d6
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

both of the origin device and the snapshot device can&#39;t be resized dyna=
mically?<br><br>
<div class=3D"gmail_quote">2010/1/7 haad <span dir=3D"ltr">&lt;<a href=3D"m=
ailto:haaaad@gmail.com">haaaad@gmail.com</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">
<div>
<div></div>
<div class=3D"h5">On Thu, Jan 7, 2010 at 9:42 AM, Pasi K=E4rkk=E4inen &lt;<=
a href=3D"mailto:pasik@iki.fi">pasik@iki.fi</a>&gt; wrote:<br>&gt; On Wed, =
Jan 06, 2010 at 09:38:00AM -0500, Mikulas Patocka wrote:<br>&gt;&gt; Hi<br>=
&gt;&gt;<br>
&gt;&gt; I uploaded new code for shared snapshots at<br>&gt;&gt; <a href=3D=
"http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/devel/" tar=
get=3D"_blank">http://people.redhat.com/mpatocka/patches/kernel/new-snapsho=
ts/devel/</a><br>
&gt;&gt;<br>&gt;&gt; Changes:<br>&gt;&gt; - two queues, one for reads and o=
ne for writes, to improve read latency<br>&gt;&gt; when the device is write=
-congested<br>&gt;&gt; - limit number of reallocations in flight (VM subsys=
tem sends all writes<br>
&gt;&gt; at once and without limit it creates big lags).<br>&gt;&gt; - fixe=
d one place where it didn&#39;t handle on-disk errors<br>&gt;&gt; - simplif=
ied bitmap creation, removed some unneeded code<br>&gt;&gt; - new macro for=
 error reporting, as suggested by Zdenek<br>
&gt;&gt; - some comments added<br>&gt;&gt; - DM_ prefix added to some macro=
s<br>&gt;&gt;<br>&gt;&gt; Userspace for lvm 2.02.53 is at<br>&gt;&gt; <a hr=
ef=3D"http://people.redhat.com/mpatocka/patches/userspace/new-snapshots/lvm=
-2.02.54/" target=3D"_blank">http://people.redhat.com/mpatocka/patches/user=
space/new-snapshots/lvm-2.02.54/</a><br>
&gt;&gt;<br>&gt;&gt; Please, someone, do offensive testing with this --- i.=
e. apply the<br>&gt;&gt; patches, try it, and try all possible lvm commands=
 with it, try to stress<br>&gt;&gt; and crash it in various ways, etc. If w=
e wait with testing until Alasdair<br>
&gt;&gt; reads the code, it won&#39;t get much testing...<br>&gt;&gt;<br>&g=
t;<br>&gt; Sorry for a stupid question, but what does &quot;shared&quot; me=
an? Support for CLVM?<br><br></div></div>No all snapshots share one, common=
 exception store I think.<br>
<font color=3D"#888888"><br><br><br>--<br><br><br>Regards.<br><br>Adam<br><=
/font>
<div>
<div></div>
<div class=3D"h5"><br>--<br>dm-devel mailing list<br><a href=3D"mailto:dm-d=
evel@redhat.com">dm-devel@redhat.com</a><br><a href=3D"https://www.redhat.c=
om/mailman/listinfo/dm-devel" target=3D"_blank">https://www.redhat.com/mail=
man/listinfo/dm-devel</a></div>
</div></blockquote></div><br>

--001636e0b60193147d047c9040d6--


--===============0672360268711012688==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0672360268711012688==--
