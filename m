From: Baruch Even <baruch@ev-en.org>
Subject: Re: [PATCH 1/1] kpartx: Use __kernel_daddr_t for
	solaris_x86_slice.s_start
Date: Sat, 12 Oct 2019 12:01:28 +0300
Message-ID: <CAC9+an+8SgNnR7Sr=Q8MKEN9ykPwL2q4LvSTE3C9OisDrN=pKg@mail.gmail.com>
References: <20190708213551.26349-1-petr.vorel@gmail.com>
	<20190709024742.GA22293@infradead.org>
	<20190709080204.GA12875@dell5510> <20190709133436.GA2231@infradead.org>
	<20191002060508.GA16684@x230> <20191007165732.GA4805@infradead.org>
	<20191008081831.GA29132@dell5510>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7664436705670947077=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191008081831.GA29132@dell5510>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Petr Vorel <petr.vorel@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============7664436705670947077==
Content-Type: multipart/alternative; boundary="000000000000b6e5590594b2e3c3"

--000000000000b6e5590594b2e3c3
Content-Type: text/plain; charset="UTF-8"

Hi,

The patch looks good to me, as for gpart, I needed it so I've taken the
bits and pieces that floated around and merged them all into one place from
all distributions that I could find.   As for users, in Debian the number
of users is around 250 so it's a very low usage program but I guess that
would always be unless very many people lost their partitions every day :-)

https://qa.debian.org/popcon-graph.php?packages=gpart

Cheers,
Baruch

P.S. While I'm sort of maintaining the program, it's only maintenance, no
active development is going on with it and very rarely do I get a patch or
an issue reported.

On Tue, Oct 8, 2019 at 11:18 AM Petr Vorel <petr.vorel@gmail.com> wrote:

> Hi Christoph,
>
> > On Wed, Oct 02, 2019 at 08:05:09AM +0200, Petr Vorel wrote:
> > > I tried to search in [1], with not much success, I don't know the
> original name
> > > of the struct and struct members are quite similar. Do you have a tip,
> where it
> > > could be or would you dare to search?
>
> > No, I don't know Solaris very well.
>
> > > Christophe already merged my patch as
> > > 129e6fe6 ("kpartx: Use __kernel_daddr_t for solaris_x86_slice.s_start")
>
> > > But, according to your comments it looks to me better to use the exact
> structure
> > > kernel uses. So, if we don't find anything, I'd be for using kernel
> struct.
>
> > Thanks, that would be great.
> I've sent a patch, as RFC, Cc also Baruch Even, the gpart maintainer.
> I wonder, if there is anybody actually using this code nowadays.
>
> Kind regards,
> Petr
>

--000000000000b6e5590594b2e3c3
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi,</div><div><br></div><div>The patch looks good to =
me, as for gpart, I needed it so I&#39;ve taken the bits and pieces that fl=
oated around and merged them all into one place from all distributions that=
 I could find.=C2=A0=C2=A0 As for users, in Debian the number of users is a=
round 250 so it&#39;s a very low usage program but I guess that would alway=
s be unless very many people lost their partitions every day :-)</div><div>=
<br></div><div><a href=3D"https://qa.debian.org/popcon-graph.php?packages=
=3Dgpart">https://qa.debian.org/popcon-graph.php?packages=3Dgpart</a></div>=
<div><br></div><div>Cheers,</div><div>Baruch<br></div><div><br></div><div>P=
.S. While I&#39;m sort of maintaining the program, it&#39;s only maintenanc=
e, no active development is going on with it and very rarely do I get a pat=
ch or an issue reported.<br></div></div><br><div class=3D"gmail_quote"><div=
 dir=3D"ltr" class=3D"gmail_attr">On Tue, Oct 8, 2019 at 11:18 AM Petr Vore=
l &lt;<a href=3D"mailto:petr.vorel@gmail.com">petr.vorel@gmail.com</a>&gt; =
wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0=
px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">Hi Christ=
oph,<br>
<br>
&gt; On Wed, Oct 02, 2019 at 08:05:09AM +0200, Petr Vorel wrote:<br>
&gt; &gt; I tried to search in [1], with not much success, I don&#39;t know=
 the original name<br>
&gt; &gt; of the struct and struct members are quite similar. Do you have a=
 tip, where it<br>
&gt; &gt; could be or would you dare to search?<br>
<br>
&gt; No, I don&#39;t know Solaris very well.<br>
<br>
&gt; &gt; Christophe already merged my patch as<br>
&gt; &gt; 129e6fe6 (&quot;kpartx: Use __kernel_daddr_t for solaris_x86_slic=
e.s_start&quot;)<br>
<br>
&gt; &gt; But, according to your comments it looks to me better to use the =
exact structure<br>
&gt; &gt; kernel uses. So, if we don&#39;t find anything, I&#39;d be for us=
ing kernel struct.<br>
<br>
&gt; Thanks, that would be great.<br>
I&#39;ve sent a patch, as RFC, Cc also Baruch Even, the gpart maintainer.<b=
r>
I wonder, if there is anybody actually using this code nowadays.<br>
<br>
Kind regards,<br>
Petr<br>
</blockquote></div>

--000000000000b6e5590594b2e3c3--


--===============7664436705670947077==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7664436705670947077==--
