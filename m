From: Michael Fortson <mfortson@permabit.com>
Subject: Re: Performance Comparison among EnhanceIO,
	bcache and dm-cache.
Date: Tue, 18 Jun 2013 12:25:56 -0400
Message-ID: <CADLFSkeVzv=iFyqgzaO8s6-+sM1Wcp3zW=WEskQ+3MmuuhtA7Q@mail.gmail.com>
References: <D399C715A2AD7F4F891A75871FC3117507866B@MYMBX3.stec-inc.ad>
	<20130617102943.GA11121@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0068879263732087059=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130617102943.GA11121@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, OS Engineering <osengineering@stec-inc.com>, "koverstreet@google.com" <koverstreet@google.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Padmini Balasubramaniyan <padminib@stec-inc.com>, Amit Phansalkar <aphansalkar@stec-inc.com>
List-Id: dm-devel.ids

--===============0068879263732087059==
Content-Type: multipart/alternative; boundary=e89a8f642dfceaebf704df702a2a

--e89a8f642dfceaebf704df702a2a
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Jun 17, 2013 at 6:29 AM, Joe Thornber <thornber@redhat.com> wrote:

> On Tue, Jun 11, 2013 at 03:05:07PM +0000, OS Engineering wrote:
>
> ...
>
> > Dm-cache commits on-disk metadata every time a REQ_SYNC or REQ_FUA
> > bio is written. If no such requests are made then it commits
> > metadata once every second. If power is lost, it may lose some
> > recent writes.
>
> Not true (though it is true for thinp, which may be where you got this
> idea?).  For caching we have to commit whenever data is moved about,
> otherwise a crash could result in us reading data that is not just out
> of date (acceptable for some), but used to belong to a totally
> different part of the device (always unacceptable).
>
> - Joe
>


Hi Joe,

In Documentation/device-mapper/cache.txt, is this text out of date?

     On-disk metadata is committed every time a REQ_SYNC or REQ_FUA
     bio is written.  If no such requests are made then commits will
     occur every second.  This means the cache behaves like a physical
     disk that has a write cache (the same is true of the
     thin-provisioning target).  If power is lost you may lose some
     recent writes.  The metadata should always be consistent in spite
     of any crash.

You say that this is the case for thinp, however.  Does that mean that it's
not possible to get stable writes with dm-thin without using cache-control
commands?  I don't see any documentation to this effect.  If so, are there
any plans to change this behavior (or make it configurable)?

Thanks,
-Michael

--e89a8f642dfceaebf704df702a2a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">On Mon, Jun 17, 2013 at 6:29 AM, Joe Thornber <span dir=3D=
"ltr">&lt;<a href=3D"mailto:thornber@redhat.com" target=3D"_blank">thornber=
@redhat.com</a>&gt;</span> wrote:<br><div class=3D"gmail_extra"><div class=
=3D"gmail_quote">
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex">On Tue, Jun 11, 2013 at 03:05:07PM +0000, OS Engineering w=
rote:<br>

<br>
...<br>
<br>
&gt; Dm-cache commits on-disk metadata every time a REQ_SYNC or REQ_FUA<br>
&gt; bio is written. If no such requests are made then it commits<br>
&gt; metadata once every second. If power is lost, it may lose some<br>
&gt; recent writes.<br>
<br>
Not true (though it is true for thinp, which may be where you got this<br>
idea?). =A0For caching we have to commit whenever data is moved about,<br>
otherwise a crash could result in us reading data that is not just out<br>
of date (acceptable for some), but used to belong to a totally<br>
different part of the device (always unacceptable).<br>
<br>
- Joe<br></blockquote><div><br></div><div><br></div><div style>Hi Joe,</div=
><div style><br></div><div style>In Documentation/device-mapper/cache.txt, =
is this text out of date?</div><div style><br></div><div style>=A0 =A0 =A0O=
n-disk metadata is committed every time a REQ_SYNC or REQ_FUA<br>
</div><div>=A0 =A0 =A0bio is written. =A0If no such requests are made then =
commits will</div><div>=A0 =A0 =A0occur every second. =A0This means the cac=
he behaves like a physical</div><div>=A0 =A0 =A0disk that has a write cache=
 (the same is true of the</div>
<div>=A0 =A0 =A0thin-provisioning target). =A0If power is lost you may lose=
 some</div><div>=A0 =A0 =A0recent writes. =A0The metadata should always be =
consistent in spite</div><div>=A0 =A0 =A0of any crash.</div><div><br></div>=
<div style>You say that this is the case for thinp, however. =A0Does that m=
ean that it&#39;s not possible to get stable writes with dm-thin without us=
ing cache-control commands? =A0I don&#39;t see any documentation to this ef=
fect. =A0If so, are there any plans to change this behavior (or make it con=
figurable)?</div>
<div style><br></div><div style>Thanks,</div><div style>-Michael</div><div =
style><br></div></div></div></div>

--e89a8f642dfceaebf704df702a2a--


--===============0068879263732087059==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0068879263732087059==--
