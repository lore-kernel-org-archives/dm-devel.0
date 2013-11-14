From: Vladimir Smolensky <arizal@gmail.com>
Subject: Re: dm-cache mq policy warmup issue
Date: Thu, 14 Nov 2013 22:19:04 +0200
Message-ID: <CALwk7=z33epGRRd4j-kSdKzfcgVZsNWpGQ43hSD0kBsP7b7yBQ@mail.gmail.com>
References: <9BDA3ECEC2A5454BB4294114677019E131B6C2F9@SACEXCMBX02-PRD.hq.netapp.com>
	<33A0129EBFD46748804DE81B354CA1B21C031288@SACEXCMBX06-PRD.hq.netapp.com>
	<33A0129EBFD46748804DE81B354CA1B21C031CD6@SACEXCMBX06-PRD.hq.netapp.com>
	<20131114143716.GB17651@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5020109977174706919=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131114143716.GB17651@debian>
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

--===============5020109977174706919==
Content-Type: multipart/alternative; boundary=047d7b4175a30d38b004eb28cb5f

--047d7b4175a30d38b004eb28cb5f
Content-Type: text/plain; charset=ISO-8859-1

Okay, a little correction here. The problematic setup was with 2.3TB cache,
not 3TB. The mistake comes from the fact that at the time of the writing I
was dealing with another server which has 8x480GB ssd's in raid5, which is
little over 3TB. Obviously the number was floating in my head.





On Thu, Nov 14, 2013 at 4:37 PM, Joe Thornber <thornber@redhat.com> wrote:

> On Wed, Nov 13, 2013 at 04:13:43PM +0000, Mears, Morgan wrote:
> > On Mon, Nov 04, 2013 at 12:22:26PM -0500, Krishnasamy, Somasundaram
> wrote:
> > > Mike,
> > >
> > > I was doing some testing with latest dm-cache code (from 'for-next'
> branch). I
> > > am having difficulty in making the cache to warm-up. I used the below
> script
> > > to read range of blocks repeatedly to get them promoted. I assume after
> > > reading a block for mq->promote_threshold + 4 times, a block will be
> > > promoted. But it is not happening. I also tested the same with the
> > > sequential_threshold set to very high value.
> > >
> > > Cache warming-up was relatively easier in the previous dm-cache code.
> Is this
> > > something you have seen in your testing?. Is there anything different
> should I
> > > do?
> >
> > I'm also testing with the for-next branch of linux-dm.git and seeing the
> > same thing as Somu.  It's easy to reproduce; reading the same block on
> the
> > cached device over and over with dd does not result in that block being
> > promoted.
> >
> > I did notice that the "read miss" counter for the cached device
> increments
> > each time I execute dd, which I believe means this isn't a buffer cache
> > issue (I also used dd iflag=direct).  The migration_threshold value
> > shouldn't be an issue for this test, but I set it to a very high value
> > anyway; didn't make any difference.
> >
> > Are there any tests in device-mapper-test-suite that you would recommend
> > for testing whether promotions are occurring as expected?
> >
> > --Morgan
>
> Hi Morgan,
>
> I just added these tests, promotion is occuring, just not as much as I'd
> like:
>
>
> https://github.com/jthornber/device-mapper-test-suite/blob/master/lib/dmtest/tests/cache/promotion_tests.rb
>
> Ah, these tests all trigger promotion via a write, I'll do some that just
> read.
>
> - Joe
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--047d7b4175a30d38b004eb28cb5f
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Okay, a little correction here. The problematic setup was =
with 2.3TB cache, not 3TB. The mistake comes from the fact that at the time=
 of the writing I was dealing with another server which has 8x480GB ssd&#39=
;s in raid5, which is little over 3TB. Obviously the number was floating in=
 my head.<br>
<br><br><br></div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_qu=
ote">On Thu, Nov 14, 2013 at 4:37 PM, Joe Thornber <span dir=3D"ltr">&lt;<a=
 href=3D"mailto:thornber@redhat.com" target=3D"_blank">thornber@redhat.com<=
/a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On Wed, Nov 13, 2013 at 04=
:13:43PM +0000, Mears, Morgan wrote:<br>
&gt; On Mon, Nov 04, 2013 at 12:22:26PM -0500, Krishnasamy, Somasundaram wr=
ote:<br>
&gt; &gt; Mike,<br>
&gt; &gt;<br>
&gt; &gt; I was doing some testing with latest dm-cache code (from &#39;for=
-next&#39; branch). I<br>
&gt; &gt; am having difficulty in making the cache to warm-up. I used the b=
elow script<br>
&gt; &gt; to read range of blocks repeatedly to get them promoted. I assume=
 after<br>
&gt; &gt; reading a block for mq-&gt;promote_threshold + 4 times, a block w=
ill be<br>
&gt; &gt; promoted. But it is not happening. I also tested the same with th=
e<br>
&gt; &gt; sequential_threshold set to very high value.<br>
&gt; &gt;<br>
&gt; &gt; Cache warming-up was relatively easier in the previous dm-cache c=
ode. Is this<br>
&gt; &gt; something you have seen in your testing?. Is there anything diffe=
rent should I<br>
&gt; &gt; do?<br>
&gt;<br>
&gt; I&#39;m also testing with the for-next branch of linux-dm.git and seei=
ng the<br>
&gt; same thing as Somu. =A0It&#39;s easy to reproduce; reading the same bl=
ock on the<br>
&gt; cached device over and over with dd does not result in that block bein=
g<br>
&gt; promoted.<br>
&gt;<br>
&gt; I did notice that the &quot;read miss&quot; counter for the cached dev=
ice increments<br>
&gt; each time I execute dd, which I believe means this isn&#39;t a buffer =
cache<br>
&gt; issue (I also used dd iflag=3Ddirect). =A0The migration_threshold valu=
e<br>
&gt; shouldn&#39;t be an issue for this test, but I set it to a very high v=
alue<br>
&gt; anyway; didn&#39;t make any difference.<br>
&gt;<br>
&gt; Are there any tests in device-mapper-test-suite that you would recomme=
nd<br>
&gt; for testing whether promotions are occurring as expected?<br>
&gt;<br>
&gt; --Morgan<br>
<br>
</div>Hi Morgan,<br>
<br>
I just added these tests, promotion is occuring, just not as much as I&#39;=
d like:<br>
<br>
<a href=3D"https://github.com/jthornber/device-mapper-test-suite/blob/maste=
r/lib/dmtest/tests/cache/promotion_tests.rb" target=3D"_blank">https://gith=
ub.com/jthornber/device-mapper-test-suite/blob/master/lib/dmtest/tests/cach=
e/promotion_tests.rb</a><br>

<br>
Ah, these tests all trigger promotion via a write, I&#39;ll do some that ju=
st read.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
- Joe<br>
</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</div></div></blockquote></div><br></div>

--047d7b4175a30d38b004eb28cb5f--


--===============5020109977174706919==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5020109977174706919==--
