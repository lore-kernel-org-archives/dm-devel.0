From: Amy Rupp <amymoseleyrupp@gmail.com>
Subject: Re: dm-cache with zero hit rate
Date: Fri, 2 Aug 2013 10:20:57 -0500
Message-ID: <CAC4stOsYbHzjDqmWERrwAFkCHkp8hk+QmznA-bPSwRJDDkzNsA@mail.gmail.com>
References: <20130731185017.GA13215@uio.no> <20130731202522.GD18513@redhat.com>
	<20130802084910.GA21756@uio.no> <20130802132344.GA20629@redhat.com>
	<20130802135828.GA12191@uio.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8901066602153965044=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130802135828.GA12191@uio.no>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>, ejt@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

--===============8901066602153965044==
Content-Type: multipart/alternative; boundary=bcaec53f35916403fd04e2f881b8

--bcaec53f35916403fd04e2f881b8
Content-Type: text/plain; charset=ISO-8859-1

Is it possible to use different input files (unique files, anyway) of the
same size, maybe even on different file systems if available?  The creation
of these could be scripted along with a dd - don't remove the file
immediately after the dd, though.  It might be even better if you could
issue multiple reads in parallel, though that will be hard to do if it's a
really small file.


On Fri, Aug 2, 2013 at 8:58 AM, Steinar H. Gunderson <sgunderson@bigfoot.com
> wrote:

> On Fri, Aug 02, 2013 at 09:23:44AM -0400, Mike Snitzer wrote:
> > Yes, it is surprising.  Curious to know if the promotions aren't
> > happening due to the IO scheduler somehow merging all your random small
> > IO.  We don't yet have a descrete counter to show the number of
> > migrations that were skipped due to sequential_threshold but that is
> > something we can add.
> >
> > But you can effectively disable the sequential_threshold by setting it
> > really high, e.g.:
> >
> > dmsetup message cache 0 sequential_threshold 16384
>
> I tried this, and it still doesn't appear to promote anything at all:
>
> cache: 0 23440891904 cache 913/8192 0 7021239 0 2049048 0 0 0 0 0 2
> migration_threshold 2048 4 random_threshold 8 sequential_threshold 16384
>
> It's only been running for a few minutes, though.
>
> FWIW, earlier I ran it on only one single partition, and then it worked.
> So it's not like my kernel is completely broken, at least.
>
> > Please write a file that is smaller than your specified
> > sequential_threshold, and then read it numerous times via direct IO,
> > e.g.:
> >
> > dd if=<your file> of=/dev/null iflag=direct bs=16K
>
> I did, with a 16 kB file (that should certainly be small enough, right?),
> executing the dd command 10000 times. Still nothing cached.
>
> /* Steinar */
> --
> Homepage: http://www.sesse.net/
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--bcaec53f35916403fd04e2f881b8
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Is it possible to use different input files (unique files,=
 anyway) of the same size, maybe even on different file systems if availabl=
e? =A0The creation of these could be scripted along with a dd - don&#39;t r=
emove the file immediately after the dd, though. =A0It might be even better=
 if you could issue multiple reads in parallel, though that will be hard to=
 do if it&#39;s a really small file.</div>
<div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Fri, Aug 2=
, 2013 at 8:58 AM, Steinar H. Gunderson <span dir=3D"ltr">&lt;<a href=3D"ma=
ilto:sgunderson@bigfoot.com" target=3D"_blank">sgunderson@bigfoot.com</a>&g=
t;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On Fri, Aug 02, 2013 at 09=
:23:44AM -0400, Mike Snitzer wrote:<br>
&gt; Yes, it is surprising. =A0Curious to know if the promotions aren&#39;t=
<br>
&gt; happening due to the IO scheduler somehow merging all your random smal=
l<br>
&gt; IO. =A0We don&#39;t yet have a descrete counter to show the number of<=
br>
&gt; migrations that were skipped due to sequential_threshold but that is<b=
r>
&gt; something we can add.<br>
&gt;<br>
&gt; But you can effectively disable the sequential_threshold by setting it=
<br>
&gt; really high, e.g.:<br>
&gt;<br>
&gt; dmsetup message cache 0 sequential_threshold 16384<br>
<br>
</div>I tried this, and it still doesn&#39;t appear to promote anything at =
all:<br>
<br>
cache: 0 23440891904 cache 913/8192 0 7021239 0 2049048 0 0 0 0 0 2 migrati=
on_threshold 2048 4 random_threshold 8 sequential_threshold 16384<br>
<br>
It&#39;s only been running for a few minutes, though.<br>
<br>
FWIW, earlier I ran it on only one single partition, and then it worked.<br=
>
So it&#39;s not like my kernel is completely broken, at least.<br>
<div class=3D"im"><br>
&gt; Please write a file that is smaller than your specified<br>
&gt; sequential_threshold, and then read it numerous times via direct IO,<b=
r>
&gt; e.g.:<br>
&gt;<br>
&gt; dd if=3D&lt;your file&gt; of=3D/dev/null iflag=3Ddirect bs=3D16K<br>
<br>
</div>I did, with a 16 kB file (that should certainly be small enough, righ=
t?),<br>
executing the dd command 10000 times. Still nothing cached.<br>
<div class=3D"im HOEnZb"><br>
/* Steinar */<br>
--<br>
Homepage: <a href=3D"http://www.sesse.net/" target=3D"_blank">http://www.se=
sse.net/</a><br>
<br>
</div><div class=3D"HOEnZb"><div class=3D"h5">--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</div></div></blockquote></div><br></div>

--bcaec53f35916403fd04e2f881b8--


--===============8901066602153965044==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8901066602153965044==--
