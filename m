From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: dm-integrity: integrity protection device-mapper
	target
Date: Sat, 19 Jan 2013 01:58:46 +0200
Message-ID: <CALLzPKZS6WgBxPcXJ1Eoe09QD_-T98E4x29qUo-fNAAt1ajTrw@mail.gmail.com>
References: <Pine.LNX.4.64.1301151955280.7468@file.rdu.redhat.com>
	<CALLzPKZVo3ng=Hz4cg0qrw0nDYsPjKy5AR=AJtMg+3PU=epz1w@mail.gmail.com>
	<20130118231633.GM27585@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5235124383664004677=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130118231633.GM27585@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: alan.cox@intel.com, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

--===============5235124383664004677==
Content-Type: multipart/alternative; boundary=14dae9cfcea455b0cb04d398e416

--14dae9cfcea455b0cb04d398e416
Content-Type: text/plain; charset=UTF-8

On Jan 19, 2013 1:16 AM, "Alasdair G Kergon" <agk@redhat.com> wrote:
>
> On Fri, Jan 18, 2013 at 11:43:34PM +0200, Kasatkin, Dmitry wrote:
> > This patch I sent out has one missing feature what I have not pushed
yet.
> > In the case of non-matching blocks, it just zeros blocks and returns
> > no error (zero-on-mismatch).
> > Writing to the block replaces the hmac.
> > It works quite nicely. mkfs and fsck is able to read and write/fix the
> > filesystem.
> > In normal environment, if fsck crashes, it might corrupt file system
> > in the same way.
> > zero-on-mismatch makes block device still accessible/fixable for fsck.
>
> I'm afraid I don't buy that.
>
> We can hardly call this "integrity" if it's designed to lose some of
> your data when the machine crashes - and worse - it doesn't tell you
> what you lost, but just gives you blocks of zeroes instead!
>
> I think a redesign is needed before this goes upstream.
>
> Alasdair
>

Do not look to it as integrity from reliability point of view. This might
be wrong name for the target.
The purpose is to provide integrity from security point of view. So
modified blocks are not available. To prevent attacker to put arbitrary
content.
This is not to provide reliability.
Default is to return error. But zero might be desirable. It works as needed
for the purpose and data=journal works for this if reliability is required.

- Dmitry

--14dae9cfcea455b0cb04d398e416
Content-Type: text/html; charset=UTF-8

<p dir="ltr"><br>
On Jan 19, 2013 1:16 AM, &quot;Alasdair G Kergon&quot; &lt;<a href="mailto:agk@redhat.com">agk@redhat.com</a>&gt; wrote:<br>
&gt;<br>
&gt; On Fri, Jan 18, 2013 at 11:43:34PM +0200, Kasatkin, Dmitry wrote:<br>
&gt; &gt; This patch I sent out has one missing feature what I have not pushed yet.<br>
&gt; &gt; In the case of non-matching blocks, it just zeros blocks and returns<br>
&gt; &gt; no error (zero-on-mismatch).<br>
&gt; &gt; Writing to the block replaces the hmac.<br>
&gt; &gt; It works quite nicely. mkfs and fsck is able to read and write/fix the<br>
&gt; &gt; filesystem.<br>
&gt; &gt; In normal environment, if fsck crashes, it might corrupt file system<br>
&gt; &gt; in the same way.<br>
&gt; &gt; zero-on-mismatch makes block device still accessible/fixable for fsck.<br>
&gt;<br>
&gt; I&#39;m afraid I don&#39;t buy that.<br>
&gt;<br>
&gt; We can hardly call this &quot;integrity&quot; if it&#39;s designed to lose some of<br>
&gt; your data when the machine crashes - and worse - it doesn&#39;t tell you<br>
&gt; what you lost, but just gives you blocks of zeroes instead!<br>
&gt;<br>
&gt; I think a redesign is needed before this goes upstream.<br>
&gt;<br>
&gt; Alasdair<br>
&gt;</p>
<p dir="ltr">Do not look to it as integrity from reliability point of view. This might be wrong name for the target.<br>
The purpose is to provide integrity from security point of view. So modified blocks are not available. To prevent attacker to put arbitrary content.<br>
This is not to provide reliability.<br>
Default is to return error. But zero might be desirable. It works as needed for the purpose and data=journal works for this if reliability is required. </p>
<p dir="ltr">- Dmitry<br><br><br><br></p>

--14dae9cfcea455b0cb04d398e416--


--===============5235124383664004677==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5235124383664004677==--
