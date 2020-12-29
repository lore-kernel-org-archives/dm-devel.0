Return-Path: <SRS0=56Wl=GB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MIME_HTML_MOSTLY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C8D4C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 29 Dec 2020 12:53:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A4FCC20727
	for <dm-devel@archiver.kernel.org>; Tue, 29 Dec 2020 12:53:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4FCC20727
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-UWIAtQU6OqCjiSkcfi8XEw-1; Tue, 29 Dec 2020 07:53:07 -0500
X-MC-Unique: UWIAtQU6OqCjiSkcfi8XEw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33B10100558A;
	Tue, 29 Dec 2020 12:53:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1382D1002391;
	Tue, 29 Dec 2020 12:53:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4325F1809C9F;
	Tue, 29 Dec 2020 12:52:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BTCqkGM030744 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 29 Dec 2020 07:52:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 660F21112874; Tue, 29 Dec 2020 12:52:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 61A781112871
	for <dm-devel@redhat.com>; Tue, 29 Dec 2020 12:52:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ADBC1101042B
	for <dm-devel@redhat.com>; Tue, 29 Dec 2020 12:52:41 +0000 (UTC)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com
	[209.85.167.49]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-244-lCCp-BwZOFykuuGIF-JCPQ-1; Tue, 29 Dec 2020 07:52:38 -0500
X-MC-Unique: lCCp-BwZOFykuuGIF-JCPQ-1
Received: by mail-lf1-f49.google.com with SMTP id s26so30540485lfc.8;
	Tue, 29 Dec 2020 04:52:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=xQSaAXxgKD2XwSUIQ+s3AtSVCGvy6PyWQOKwOhBSvMs=;
	b=N2cBS8+AEwCi4Pm8N/N0QaX6RgQH5uBOGiF7G3wg+NIZfX5hHbjcX/vJiF7Z8CgMGr
	K7Sj4CnqPJ04PJ9b+tufRFcbX/r6fILchq04rP/uWYhzI0YfOXXsGBaNyALRAETGFMKF
	HaK2VeCw7gl9DKPugsTr1KRQop0FBP3/ybpZpxA7qEXLXfYHWkPJCsZmu4pmYOIH5Q4O
	qcZC3cJuGnbmLAiKseOKMu3nEDiZ2a4sw6gtWNNyXJZiR4B2/9/lTBsKgbm/8FoN9tCR
	V6BYnFWDjOI8N06L2el7UECp2zU7E3GNZeiKX8H/WNecXgYD7mYEGYs+IVfQBmy/KUqB
	UDCA==
X-Gm-Message-State: AOAM5321SZYIkFA0PG71sqfsEYhIzvGjeMJNPfV5AegkR2RmRqw4a3tL
	Wpeo2U2dxR64LbrZUaZvVT5GYYKa50uaDVg7kiY=
X-Google-Smtp-Source: ABdhPJyqHA3vFNb0GIbhspXn7Yeo1WustrNwTaYrn2q85D+aYvRaYy+LfixCBn9drsJlxYpZTf9VpAG2ZQ96Kl+P6Lo=
X-Received: by 2002:a19:c858:: with SMTP id y85mr20355323lff.99.1609246356295; 
	Tue, 29 Dec 2020 04:52:36 -0800 (PST)
MIME-Version: 1.0
References: <CABmKtjfdDS-iO+jLkwt7x-oDHt9V1p-cpYHjL5EV2NKwHxqN1Q@mail.gmail.com>
	<mhng-cc7f1629-3ff7-4efe-8dc6-806b4d8e28c5@palmerdabbelt-glaptop>
In-Reply-To: <mhng-cc7f1629-3ff7-4efe-8dc6-806b4d8e28c5@palmerdabbelt-glaptop>
From: Akira Hayakawa <ruby.wktk@gmail.com>
Date: Tue, 29 Dec 2020 21:52:24 +0900
Message-ID: <CABmKtjdLRsv-bK+QFLbxn47j7KT6apO=nKz=gc5Qrtd2xODGnQ@mail.gmail.com>
To: Palmer Dabbelt <palmer@dabbelt.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, bvanassche@acm.org,
	Mike Snitzer <snitzer@redhat.com>, linux-doc@vger.kernel.org,
	kernel-team@android.com, corbet@lwn.net,
	Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, song@kernel.org, dm-devel@redhat.com,
	Alasdair G Kergon <agk@redhat.com>,
	linux-kselftest@vger.kernel.org, shuah@kernel.org,
	michael.christie@oracle.com
Subject: Re: [dm-devel] [PATCH v1 0/5] dm: dm-user: New target that proxies
 BIOs to userspace
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============4450201806320439830=="

--===============4450201806320439830==
Content-Type: multipart/alternative; boundary="0000000000006c5ea105b799dd8a"

--0000000000006c5ea105b799dd8a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Since this is an interesting topic to me. As a holiday project, I started
my new kernel module.

There was a similar project named ABUSE, back in 2009. Unfortunately, it
was rejected.
https://lwn.net/Articles/343514/

The kernel module=E2=80=99s mechanism is very simple:
1. When client code sends a request to /dev/abuseX it is pushed to the
internal queue.
2. When some requests are queued, the userland storage engine is woken up
(usually it waits by epoll or some variant) it pulls one request from the
queue via ioctl (ABUSE_GET_REQ).
3. After processing, it pushes back a completion via ioctl (ABUSE_PUT_REQ).

The original code is bio-based but naota modified it to request-based in
2015.
https://github.com/naota/abuse-kmod

This is my starting point.

The problem I see is, the 2015 version copies bvec pages across the
user-kernel space boundary. I think this is no good because we need to copy
2x the amount of the IO buffers.

The solution I am trying to do is mmap the bvec pages in kernel-space from
the userland. Instead of copying the bvec pages, the kernel passes only the
physical page address to the userland and then the userland engine mmap the
page to some address space in user space. I know mmap has some overhead
because it is system call but the rationale behind this is =E2=80=9Cmmap is=
 better
than copy=E2=80=9D. Since it is not able to access kernel address space dir=
ectly
from the userland, unlike Vitaly above mentions zero-copy I believe some
trick like mmaping is inevitable. Yes, if there is some non-overhead way to
access bvec pages from userland, I want to know that.

Here is the kernel code. Userland-side is written in Rust. It=E2=80=99s alr=
eady
passed a test by badblocks.
https://github.com/akiradeveloper/userland-io/blob/20201229/abuse-kmod/src/=
abuse.c

- Akira

On Thu, Dec 17, 2020 at 5:35 AM Palmer Dabbelt <palmer@dabbelt.com> wrote:

> On Tue, 15 Dec 2020 22:17:06 PST (-0800), ruby.wktk@gmail.com wrote:
> > Hi my name is Akira Hayakawa. I am maintaining an out-of-tree DM target
> > named dm-writeboost.
> >
> > Sorry to step in. But this is a very interesting topic at least to me.
> >
> > I have been looking for something like dm-user because I believe we
> should
> > be able to implement virtual block devices in Rust language.
> >
> > I know proxying IO requests to userland always causes some overhead but
> for
> > some type of device that performance doesn't matter or some research
> > prototyping or pseudo device for testing, this way should be developed.
> Of
> > course, implementation in Rust will give us opportunities to develop mo=
re
> > complicated software in high quality.
> >
> > I noticed this thread few days ago then I started to prototype this
> library
> > https://github.com/akiradeveloper/userland-io
> >
> > It is what I want but the transport is still NBD which I don't like so
> > much. If dm-user is available, I will implement a transport using
> dm-user.
>
> Great, I'm glad to hear that.  Obviously this is still in the early days
> and
> we're talking about high-level ABI design here, so things are almost
> certainly
> going to change, but it's always good to have people pushing on stuff.
>
> Just be warned: we've only had two people write userspaces for this (one =
of
> which was me, and all that is test code) so I'd be shocked if you manage =
to
> avoid running into bugs.
>
> >
> > - Akira
> >
> > On Tue, Dec 15, 2020 at 7:00 PM Palmer Dabbelt <palmer@dabbelt.com>
> wrote:
> >
> >> On Thu, 10 Dec 2020 09:03:21 PST (-0800), josef@toxicpanda.com wrote:
> >> > On 12/9/20 10:38 PM, Bart Van Assche wrote:
> >> >> On 12/7/20 10:55 AM, Palmer Dabbelt wrote:
> >> >>> All in all, I've found it a bit hard to figure out what sort of
> >> interest
> >> >>> people
> >> >>> have in dm-user: when I bring this up I seem to run into people
> who've
> >> done
> >> >>> similar things before and are vaguely interested, but certainly
> nobody
> >> is
> >> >>> chomping at the bit.  I'm sending it out in this early state to tr=
y
> and
> >> >>> figure
> >> >>> out if it's interesting enough to keep going.
> >> >>
> >> >> Cc-ing Josef and Mike since their nbd contributions make me wonder
> >> >> whether this new driver could be useful to their use cases?
> >> >>
> >> >
> >> > Sorry gmail+imap sucks and I can't get my email client to get at the
> >> original
> >> > thread.  However here is my take.
> >>
> >> and I guess I then have to apoligize for missing your email ;).
> Hopefully
> >> that
> >> was the problem, but who knows.
> >>
> >> > 1) The advantages of using dm-user of NBD that you listed aren't
> actually
> >> > problems for NBD.  We have NBD working in production where you can
> hand
> >> off the
> >> > sockets for the server without ending in timeouts, it was actually t=
he
> >> main
> >> > reason we wrote our own server so we could use the FD transfer stuff
> to
> >> restart
> >> > the server without impacting any clients that had the device in use.
> >>
> >> OK.  So you just send the FD around using one of the standard
> mechanisms to
> >> orchestrate the handoff?  I guess that might work for our use case,
> >> assuming
> >> whatever the security side of things was doing was OK with the old FD.
> >> TBH I'm
> >> not sure how all that works and while we thought about doing that sort
> of
> >> transfer scheme we decided to just open it again -- not sure how far w=
e
> >> were
> >> down the dm-user rabbit hole at that point, though, as this sort of
> arose
> >> out
> >> of some other ideas.
> >>
> >> > 2) The extra copy is a big deal, in fact we already have too many
> copies
> >> in our
> >> > existing NBD setup and are actively looking for ways to avoid those.
> >> >
> >> > Don't take this as I don't think dm-user is a good idea, but I think
> at
> >> the very
> >> > least it should start with the very best we have to offer, starting
> with
> >> as few
> >> > copies as possible.
> >>
> >> I was really experting someone to say that.  It does seem kind of sill=
y
> to
> >> build
> >> out the new interface, but not go all the way to a ring buffer.  We ju=
st
> >> didn't
> >> really have any way to justify the extra complexity as our use cases
> aren't
> >> that high performance.   I kind of like to have benchmarks for this
> sort of
> >> thing, though, and I didn't have anyone who had bothered avoiding the
> last
> >> copy
> >> to compare against.
> >>
> >> > If you are using it currently in production then cool, there's
> clearly a
> >> usecase
> >> > for it.  Personally as I get older and grouchier I want less things =
in
> >> the
> >> > kernel, so if this enables us to eventually do everything NBD relate=
d
> in
> >> > userspace with no performance drop then I'd be down.  I don't think
> you
> >> need to
> >> > make that your primary goal, but at least polishing this up so it
> could
> >> > potentially be abused in the future would make it more compelling fo=
r
> >> merging.
> >> > Thanks,
> >>
> >> Ya, it's in Android already and we'll be shipping it as part of the ne=
w
> OTA
> >> flow for the next release.  The rules on deprecation are a bit differe=
nt
> >> over
> >> there, though, so it's not like we're wed to it.  The whole point of
> >> bringing
> >> this up here was to try and get something usable by everyone, and whil=
e
> I'd
> >> eventually like to get whatever's in Android into the kernel proper we=
'd
> >> really
> >> planned on supporting an extra Android-only ABI for a cycle at least.
> >>
> >> I'm kind of inclined to take a crack at the extra copy, to at least se=
e
> if
> >> building something that eliminates it is viable.  I'm not really sure =
if
> >> it is
> >> (or at least, if it'll net us a meaningful amount of performance), but
> >> it'd at
> >> least be interesting to try.
> >>
> >> It'd be nice to have some benchmark target, though, as otherwise this
> stuff
> >> hangs on forever.  My workloads are in selftests later on in the patch
> >> set, but
> >> I'm essentially using tmpfs as a baseline to compare against
> ext4+dm-user
> >> with
> >> some FIO examples as workloads.  Our early benchmark numbers indicated
> >> this was
> >> way faster than we needed, so I didn't even bother putting together a
> >> proper
> >> system to run on so I don't really have any meaningful numbers there.
> Is
> >> there
> >> an NBD server that's fast that I should be comparing against?
> >>
> >> I haven't gotten a whole lot of feedback, so I'm inclined to at least
> have
> >> some
> >> reasonable performance numbers before bothering with a v2.
> >>
> >> --
> >> dm-devel mailing list
> >> dm-devel@redhat.com
> >> https://www.redhat.com/mailman/listinfo/dm-devel
>


--=20
Akira Hayakawa

--0000000000006c5ea105b799dd8a
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">

<span></span><div><br></div><div>Since this is an interesting topic to me. =
As a holiday project, I started my new kernel module.
</div><div><br></div><div>There was a similar project named ABUSE, back in =
2009. Unfortunately, it was rejected.
</div><div><a href=3D"https://lwn.net/Articles/343514/">https://lwn.net/Art=
icles/343514/</a></div><div><br></div><div>The kernel module=E2=80=99s mech=
anism is very simple:</div><div>1. When client code sends a request to /dev=
/abuseX it is pushed to the internal queue.</div><div>2. When some requests=
 are queued, the userland storage engine is woken up (usually it waits by e=
poll or some variant) it pulls one request from the queue via ioctl (ABUSE_=
GET_REQ).</div><div>3. After processing, it pushes back a completion via io=
ctl (ABUSE_PUT_REQ).
</div><div><br></div><div>The original code is bio-based but naota modified=
 it to request-based in 2015.
</div><div><a href=3D"https://github.com/naota/abuse-kmod">https://github.c=
om/naota/abuse-kmod</a></div><div><br></div><div>This is my starting point.
</div><div><br></div><div>The problem I see is, the 2015 version copies bve=
c pages across the user-kernel space boundary. I think this is no good beca=
use we need to copy 2x the amount of the IO buffers.
</div><div><br></div><div>The solution I am trying to do is mmap the bvec p=
ages in kernel-space from the userland. Instead of copying the bvec pages, =
the kernel passes only the physical page address to the userland and then t=
he userland engine mmap the page to some address space in user space. I kno=
w mmap has some overhead because it is system call but the rationale behind=
 this is =E2=80=9Cmmap is better than copy=E2=80=9D. Since it is not able t=
o access kernel address space directly from the userland, unlike Vitaly abo=
ve mentions zero-copy I believe some trick like mmaping is inevitable. Yes,=
 if there is some non-overhead way to access bvec pages from userland, I wa=
nt to know that.
</div><div><br></div><div>Here is the kernel code. Userland-side is written=
 in Rust. It=E2=80=99s already passed a test by badblocks.
</div><div><a href=3D"https://github.com/akiradeveloper/userland-io/blob/20=
201229/abuse-kmod/src/abuse.c">https://github.com/akiradeveloper/userland-i=
o/blob/20201229/abuse-kmod/src/abuse.c</a></div><div><br></div><div>- Akira=
<br></div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gm=
ail_attr">On Thu, Dec 17, 2020 at 5:35 AM Palmer Dabbelt &lt;<a href=3D"mai=
lto:palmer@dabbelt.com">palmer@dabbelt.com</a>&gt; wrote:<br></div><blockqu=
ote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px=
 solid rgb(204,204,204);padding-left:1ex">On Tue, 15 Dec 2020 22:17:06 PST =
(-0800), <a href=3D"mailto:ruby.wktk@gmail.com" target=3D"_blank">ruby.wktk=
@gmail.com</a> wrote:<br>
&gt; Hi my name is Akira Hayakawa. I am maintaining an out-of-tree DM targe=
t<br>
&gt; named dm-writeboost.<br>
&gt;<br>
&gt; Sorry to step in. But this is a very interesting topic at least to me.=
<br>
&gt;<br>
&gt; I have been looking for something like dm-user because I believe we sh=
ould<br>
&gt; be able to implement virtual block devices in Rust language.<br>
&gt;<br>
&gt; I know proxying IO requests to userland always causes some overhead bu=
t for<br>
&gt; some type of device that performance doesn&#39;t matter or some resear=
ch<br>
&gt; prototyping or pseudo device for testing, this way should be developed=
. Of<br>
&gt; course, implementation in Rust will give us opportunities to develop m=
ore<br>
&gt; complicated software in high quality.<br>
&gt;<br>
&gt; I noticed this thread few days ago then I started to prototype this li=
brary<br>
&gt; <a href=3D"https://github.com/akiradeveloper/userland-io" rel=3D"noref=
errer" target=3D"_blank">https://github.com/akiradeveloper/userland-io</a><=
br>
&gt;<br>
&gt; It is what I want but the transport is still NBD which I don&#39;t lik=
e so<br>
&gt; much. If dm-user is available, I will implement a transport using dm-u=
ser.<br>
<br>
Great, I&#39;m glad to hear that.=C2=A0 Obviously this is still in the earl=
y days and<br>
we&#39;re talking about high-level ABI design here, so things are almost ce=
rtainly<br>
going to change, but it&#39;s always good to have people pushing on stuff.<=
br>
<br>
Just be warned: we&#39;ve only had two people write userspaces for this (on=
e of<br>
which was me, and all that is test code) so I&#39;d be shocked if you manag=
e to<br>
avoid running into bugs.<br>
<br>
&gt;<br>
&gt; - Akira<br>
&gt;<br>
&gt; On Tue, Dec 15, 2020 at 7:00 PM Palmer Dabbelt &lt;<a href=3D"mailto:p=
almer@dabbelt.com" target=3D"_blank">palmer@dabbelt.com</a>&gt; wrote:<br>
&gt;<br>
&gt;&gt; On Thu, 10 Dec 2020 09:03:21 PST (-0800), <a href=3D"mailto:josef@=
toxicpanda.com" target=3D"_blank">josef@toxicpanda.com</a> wrote:<br>
&gt;&gt; &gt; On 12/9/20 10:38 PM, Bart Van Assche wrote:<br>
&gt;&gt; &gt;&gt; On 12/7/20 10:55 AM, Palmer Dabbelt wrote:<br>
&gt;&gt; &gt;&gt;&gt; All in all, I&#39;ve found it a bit hard to figure ou=
t what sort of<br>
&gt;&gt; interest<br>
&gt;&gt; &gt;&gt;&gt; people<br>
&gt;&gt; &gt;&gt;&gt; have in dm-user: when I bring this up I seem to run i=
nto people who&#39;ve<br>
&gt;&gt; done<br>
&gt;&gt; &gt;&gt;&gt; similar things before and are vaguely interested, but=
 certainly nobody<br>
&gt;&gt; is<br>
&gt;&gt; &gt;&gt;&gt; chomping at the bit.=C2=A0 I&#39;m sending it out in =
this early state to try and<br>
&gt;&gt; &gt;&gt;&gt; figure<br>
&gt;&gt; &gt;&gt;&gt; out if it&#39;s interesting enough to keep going.<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;&gt; Cc-ing Josef and Mike since their nbd contributions make =
me wonder<br>
&gt;&gt; &gt;&gt; whether this new driver could be useful to their use case=
s?<br>
&gt;&gt; &gt;&gt;<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; Sorry gmail+imap sucks and I can&#39;t get my email client to=
 get at the<br>
&gt;&gt; original<br>
&gt;&gt; &gt; thread.=C2=A0 However here is my take.<br>
&gt;&gt;<br>
&gt;&gt; and I guess I then have to apoligize for missing your email ;).=C2=
=A0 Hopefully<br>
&gt;&gt; that<br>
&gt;&gt; was the problem, but who knows.<br>
&gt;&gt;<br>
&gt;&gt; &gt; 1) The advantages of using dm-user of NBD that you listed are=
n&#39;t actually<br>
&gt;&gt; &gt; problems for NBD.=C2=A0 We have NBD working in production whe=
re you can hand<br>
&gt;&gt; off the<br>
&gt;&gt; &gt; sockets for the server without ending in timeouts, it was act=
ually the<br>
&gt;&gt; main<br>
&gt;&gt; &gt; reason we wrote our own server so we could use the FD transfe=
r stuff to<br>
&gt;&gt; restart<br>
&gt;&gt; &gt; the server without impacting any clients that had the device =
in use.<br>
&gt;&gt;<br>
&gt;&gt; OK.=C2=A0 So you just send the FD around using one of the standard=
 mechanisms to<br>
&gt;&gt; orchestrate the handoff?=C2=A0 I guess that might work for our use=
 case,<br>
&gt;&gt; assuming<br>
&gt;&gt; whatever the security side of things was doing was OK with the old=
 FD.<br>
&gt;&gt; TBH I&#39;m<br>
&gt;&gt; not sure how all that works and while we thought about doing that =
sort of<br>
&gt;&gt; transfer scheme we decided to just open it again -- not sure how f=
ar we<br>
&gt;&gt; were<br>
&gt;&gt; down the dm-user rabbit hole at that point, though, as this sort o=
f arose<br>
&gt;&gt; out<br>
&gt;&gt; of some other ideas.<br>
&gt;&gt;<br>
&gt;&gt; &gt; 2) The extra copy is a big deal, in fact we already have too =
many copies<br>
&gt;&gt; in our<br>
&gt;&gt; &gt; existing NBD setup and are actively looking for ways to avoid=
 those.<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; Don&#39;t take this as I don&#39;t think dm-user is a good id=
ea, but I think at<br>
&gt;&gt; the very<br>
&gt;&gt; &gt; least it should start with the very best we have to offer, st=
arting with<br>
&gt;&gt; as few<br>
&gt;&gt; &gt; copies as possible.<br>
&gt;&gt;<br>
&gt;&gt; I was really experting someone to say that.=C2=A0 It does seem kin=
d of silly to<br>
&gt;&gt; build<br>
&gt;&gt; out the new interface, but not go all the way to a ring buffer.=C2=
=A0 We just<br>
&gt;&gt; didn&#39;t<br>
&gt;&gt; really have any way to justify the extra complexity as our use cas=
es aren&#39;t<br>
&gt;&gt; that high performance.=C2=A0 =C2=A0I kind of like to have benchmar=
ks for this sort of<br>
&gt;&gt; thing, though, and I didn&#39;t have anyone who had bothered avoid=
ing the last<br>
&gt;&gt; copy<br>
&gt;&gt; to compare against.<br>
&gt;&gt;<br>
&gt;&gt; &gt; If you are using it currently in production then cool, there&=
#39;s clearly a<br>
&gt;&gt; usecase<br>
&gt;&gt; &gt; for it.=C2=A0 Personally as I get older and grouchier I want =
less things in<br>
&gt;&gt; the<br>
&gt;&gt; &gt; kernel, so if this enables us to eventually do everything NBD=
 related in<br>
&gt;&gt; &gt; userspace with no performance drop then I&#39;d be down.=C2=
=A0 I don&#39;t think you<br>
&gt;&gt; need to<br>
&gt;&gt; &gt; make that your primary goal, but at least polishing this up s=
o it could<br>
&gt;&gt; &gt; potentially be abused in the future would make it more compel=
ling for<br>
&gt;&gt; merging.<br>
&gt;&gt; &gt; Thanks,<br>
&gt;&gt;<br>
&gt;&gt; Ya, it&#39;s in Android already and we&#39;ll be shipping it as pa=
rt of the new OTA<br>
&gt;&gt; flow for the next release.=C2=A0 The rules on deprecation are a bi=
t different<br>
&gt;&gt; over<br>
&gt;&gt; there, though, so it&#39;s not like we&#39;re wed to it.=C2=A0 The=
 whole point of<br>
&gt;&gt; bringing<br>
&gt;&gt; this up here was to try and get something usable by everyone, and =
while I&#39;d<br>
&gt;&gt; eventually like to get whatever&#39;s in Android into the kernel p=
roper we&#39;d<br>
&gt;&gt; really<br>
&gt;&gt; planned on supporting an extra Android-only ABI for a cycle at lea=
st.<br>
&gt;&gt;<br>
&gt;&gt; I&#39;m kind of inclined to take a crack at the extra copy, to at =
least see if<br>
&gt;&gt; building something that eliminates it is viable.=C2=A0 I&#39;m not=
 really sure if<br>
&gt;&gt; it is<br>
&gt;&gt; (or at least, if it&#39;ll net us a meaningful amount of performan=
ce), but<br>
&gt;&gt; it&#39;d at<br>
&gt;&gt; least be interesting to try.<br>
&gt;&gt;<br>
&gt;&gt; It&#39;d be nice to have some benchmark target, though, as otherwi=
se this stuff<br>
&gt;&gt; hangs on forever.=C2=A0 My workloads are in selftests later on in =
the patch<br>
&gt;&gt; set, but<br>
&gt;&gt; I&#39;m essentially using tmpfs as a baseline to compare against e=
xt4+dm-user<br>
&gt;&gt; with<br>
&gt;&gt; some FIO examples as workloads.=C2=A0 Our early benchmark numbers =
indicated<br>
&gt;&gt; this was<br>
&gt;&gt; way faster than we needed, so I didn&#39;t even bother putting tog=
ether a<br>
&gt;&gt; proper<br>
&gt;&gt; system to run on so I don&#39;t really have any meaningful numbers=
 there.=C2=A0 Is<br>
&gt;&gt; there<br>
&gt;&gt; an NBD server that&#39;s fast that I should be comparing against?<=
br>
&gt;&gt;<br>
&gt;&gt; I haven&#39;t gotten a whole lot of feedback, so I&#39;m inclined =
to at least have<br>
&gt;&gt; some<br>
&gt;&gt; reasonable performance numbers before bothering with a v2.<br>
&gt;&gt;<br>
&gt;&gt; --<br>
&gt;&gt; dm-devel mailing list<br>
&gt;&gt; <a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@=
redhat.com</a><br>
&gt;&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=
=3D"noreferrer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/d=
m-devel</a><br>
</blockquote></div><br clear=3D"all"><br>-- <br><div dir=3D"ltr" class=3D"g=
mail_signature">Akira Hayakawa</div>

--0000000000006c5ea105b799dd8a--

--===============4450201806320439830==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============4450201806320439830==--

