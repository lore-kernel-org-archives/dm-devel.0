Return-Path: <SRS0=g9U1=FU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50BA6C4361B
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 06:17:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9DD9123356
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 06:17:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DD9123356
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-Lhh0LKXQOWqzV4RWJTX3OQ-1; Wed, 16 Dec 2020 01:17:39 -0500
X-MC-Unique: Lhh0LKXQOWqzV4RWJTX3OQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 222ED800D62;
	Wed, 16 Dec 2020 06:17:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1069C5C67A;
	Wed, 16 Dec 2020 06:17:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9ADAE4BB7B;
	Wed, 16 Dec 2020 06:17:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BG6HT0G021378 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 01:17:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 58CFE2166B27; Wed, 16 Dec 2020 06:17:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 507492166B2E
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 06:17:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8404E185A7BC
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 06:17:25 +0000 (UTC)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com
	[209.85.167.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-140-IIWUiQtxO8-LKfBNFeKggg-1; Wed, 16 Dec 2020 01:17:20 -0500
X-MC-Unique: IIWUiQtxO8-LKfBNFeKggg-1
Received: by mail-lf1-f46.google.com with SMTP id l11so45538242lfg.0;
	Tue, 15 Dec 2020 22:17:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=c4c5Uqnx/ZYLg8U+sxy43UFKzr5WMUZLqiMO6kX7uAk=;
	b=IQHwEXG1yIUVAavJBonKJ1ngbO+PplgpK+TQTzrGN8H16czOrWuLgbLvaIy6165AK8
	Z1wJ4TPfG53h0V+7nuQG4H8NgEDXTz8BZ4e4K8qcDPMD1Q9siza0e7tPfgmFYs3tnwuk
	M07PfiI83KjT2u7shfWJeyMKVLWhhd31/jfPW9zCyXpLOp/9vY9YGU8Qvdx6OR+CGJ/5
	qVT7h9eEMnDXeFsQJQ+xdzi9VN0wyTqXEqJmUzmQeS1HIoxQNAUD8AzoH/H5Rhm2u4uX
	zk3s1C6larLBA18Qx3RSuqst3NjOYDYvKyE/JTXTr1MN3Z/3S+/+2Det3+CwLQmxrL0f
	uS1A==
X-Gm-Message-State: AOAM530B0S24TYAgNJIJgaYTRag92F0wwJ3HvBXWrbLnffWnychWJ6QE
	QFKIcHRrquDCgemJ4w3fF83qGV+3r1AkIl9TaAc=
X-Google-Smtp-Source: ABdhPJxDR11m2Sgt69z38YiTJB8E3ncaJq80639ZEZP690NCvNPizvbEDlG3B6zSClqJdf3b/t7ze7R4zCcbgh14Gbw=
X-Received: by 2002:a2e:9084:: with SMTP id l4mr13334296ljg.375.1608099438138; 
	Tue, 15 Dec 2020 22:17:18 -0800 (PST)
MIME-Version: 1.0
References: <30d39293-80a4-9ef5-92bb-6b6dec464be3@toxicpanda.com>
	<mhng-2da5b1a2-20f9-4b0e-9ffd-7f60a161ebf0@palmerdabbelt-glaptop>
In-Reply-To: <mhng-2da5b1a2-20f9-4b0e-9ffd-7f60a161ebf0@palmerdabbelt-glaptop>
From: Akira Hayakawa <ruby.wktk@gmail.com>
Date: Wed, 16 Dec 2020 15:17:06 +0900
Message-ID: <CABmKtjfdDS-iO+jLkwt7x-oDHt9V1p-cpYHjL5EV2NKwHxqN1Q@mail.gmail.com>
To: Palmer Dabbelt <palmer@dabbelt.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, bvanassche@acm.org,
	Mike Snitzer <snitzer@redhat.com>, linux-doc@vger.kernel.org,
	kernel-team@android.com, corbet@lwn.net, josef@toxicpanda.com,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	song@kernel.org, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============8571211547438565926=="

--===============8571211547438565926==
Content-Type: multipart/alternative; boundary="000000000000c61a2c05b68ed3b6"

--000000000000c61a2c05b68ed3b6
Content-Type: text/plain; charset="UTF-8"

Hi my name is Akira Hayakawa. I am maintaining an out-of-tree DM target
named dm-writeboost.

Sorry to step in. But this is a very interesting topic at least to me.

I have been looking for something like dm-user because I believe we should
be able to implement virtual block devices in Rust language.

I know proxying IO requests to userland always causes some overhead but for
some type of device that performance doesn't matter or some research
prototyping or pseudo device for testing, this way should be developed. Of
course, implementation in Rust will give us opportunities to develop more
complicated software in high quality.

I noticed this thread few days ago then I started to prototype this library
https://github.com/akiradeveloper/userland-io

It is what I want but the transport is still NBD which I don't like so
much. If dm-user is available, I will implement a transport using dm-user.

- Akira

On Tue, Dec 15, 2020 at 7:00 PM Palmer Dabbelt <palmer@dabbelt.com> wrote:

> On Thu, 10 Dec 2020 09:03:21 PST (-0800), josef@toxicpanda.com wrote:
> > On 12/9/20 10:38 PM, Bart Van Assche wrote:
> >> On 12/7/20 10:55 AM, Palmer Dabbelt wrote:
> >>> All in all, I've found it a bit hard to figure out what sort of
> interest
> >>> people
> >>> have in dm-user: when I bring this up I seem to run into people who've
> done
> >>> similar things before and are vaguely interested, but certainly nobody
> is
> >>> chomping at the bit.  I'm sending it out in this early state to try and
> >>> figure
> >>> out if it's interesting enough to keep going.
> >>
> >> Cc-ing Josef and Mike since their nbd contributions make me wonder
> >> whether this new driver could be useful to their use cases?
> >>
> >
> > Sorry gmail+imap sucks and I can't get my email client to get at the
> original
> > thread.  However here is my take.
>
> and I guess I then have to apoligize for missing your email ;).  Hopefully
> that
> was the problem, but who knows.
>
> > 1) The advantages of using dm-user of NBD that you listed aren't actually
> > problems for NBD.  We have NBD working in production where you can hand
> off the
> > sockets for the server without ending in timeouts, it was actually the
> main
> > reason we wrote our own server so we could use the FD transfer stuff to
> restart
> > the server without impacting any clients that had the device in use.
>
> OK.  So you just send the FD around using one of the standard mechanisms to
> orchestrate the handoff?  I guess that might work for our use case,
> assuming
> whatever the security side of things was doing was OK with the old FD.
> TBH I'm
> not sure how all that works and while we thought about doing that sort of
> transfer scheme we decided to just open it again -- not sure how far we
> were
> down the dm-user rabbit hole at that point, though, as this sort of arose
> out
> of some other ideas.
>
> > 2) The extra copy is a big deal, in fact we already have too many copies
> in our
> > existing NBD setup and are actively looking for ways to avoid those.
> >
> > Don't take this as I don't think dm-user is a good idea, but I think at
> the very
> > least it should start with the very best we have to offer, starting with
> as few
> > copies as possible.
>
> I was really experting someone to say that.  It does seem kind of silly to
> build
> out the new interface, but not go all the way to a ring buffer.  We just
> didn't
> really have any way to justify the extra complexity as our use cases aren't
> that high performance.   I kind of like to have benchmarks for this sort of
> thing, though, and I didn't have anyone who had bothered avoiding the last
> copy
> to compare against.
>
> > If you are using it currently in production then cool, there's clearly a
> usecase
> > for it.  Personally as I get older and grouchier I want less things in
> the
> > kernel, so if this enables us to eventually do everything NBD related in
> > userspace with no performance drop then I'd be down.  I don't think you
> need to
> > make that your primary goal, but at least polishing this up so it could
> > potentially be abused in the future would make it more compelling for
> merging.
> > Thanks,
>
> Ya, it's in Android already and we'll be shipping it as part of the new OTA
> flow for the next release.  The rules on deprecation are a bit different
> over
> there, though, so it's not like we're wed to it.  The whole point of
> bringing
> this up here was to try and get something usable by everyone, and while I'd
> eventually like to get whatever's in Android into the kernel proper we'd
> really
> planned on supporting an extra Android-only ABI for a cycle at least.
>
> I'm kind of inclined to take a crack at the extra copy, to at least see if
> building something that eliminates it is viable.  I'm not really sure if
> it is
> (or at least, if it'll net us a meaningful amount of performance), but
> it'd at
> least be interesting to try.
>
> It'd be nice to have some benchmark target, though, as otherwise this stuff
> hangs on forever.  My workloads are in selftests later on in the patch
> set, but
> I'm essentially using tmpfs as a baseline to compare against ext4+dm-user
> with
> some FIO examples as workloads.  Our early benchmark numbers indicated
> this was
> way faster than we needed, so I didn't even bother putting together a
> proper
> system to run on so I don't really have any meaningful numbers there.  Is
> there
> an NBD server that's fast that I should be comparing against?
>
> I haven't gotten a whole lot of feedback, so I'm inclined to at least have
> some
> reasonable performance numbers before bothering with a v2.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel



-- 
Akira Hayakawa

--000000000000c61a2c05b68ed3b6
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi my name is Akira Hayakawa. I am maintaining an out=
-of-tree DM target named dm-writeboost.</div><div><br></div><div>Sorry to s=
tep in. But this is a very interesting topic at least to me.</div><div><br>=
</div><div>I have been looking for something like dm-user because I believe=
 we should be able to implement virtual block devices in Rust language.</di=
v><div><br></div><div>I
 know proxying IO requests to userland always causes some overhead but=20
for some type of device that performance doesn&#39;t matter or some=20
research prototyping or pseudo device for testing, this way should be=20
developed. Of course, implementation in Rust will give us opportunities=20
to develop more complicated software in high quality.<br></div><div><br></d=
iv><div>I noticed this thread few days ago then I started to prototype this=
 library <a href=3D"https://github.com/akiradeveloper/userland-io" target=
=3D"_blank">https://github.com/akiradeveloper/userland-io</a><br></div><div=
><br></div><div>It is what I want but the transport is still NBD which I do=
n&#39;t like so much. If dm-user is available, I will implement a transport=
 using dm-use<font color=3D"#888888"><font color=3D"#000000">r.<br></font><=
/font></div><div><font color=3D"#888888"><font color=3D"#000000"><br></font=
></font></div><div><font color=3D"#888888"><font color=3D"#000000">- Akira<=
/font><br></font></div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr=
" class=3D"gmail_attr">On Tue, Dec 15, 2020 at 7:00 PM Palmer Dabbelt &lt;<=
a href=3D"mailto:palmer@dabbelt.com">palmer@dabbelt.com</a>&gt; wrote:<br><=
/div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bo=
rder-left:1px solid rgb(204,204,204);padding-left:1ex">On Thu, 10 Dec 2020 =
09:03:21 PST (-0800), <a href=3D"mailto:josef@toxicpanda.com" target=3D"_bl=
ank">josef@toxicpanda.com</a> wrote:<br>
&gt; On 12/9/20 10:38 PM, Bart Van Assche wrote:<br>
&gt;&gt; On 12/7/20 10:55 AM, Palmer Dabbelt wrote:<br>
&gt;&gt;&gt; All in all, I&#39;ve found it a bit hard to figure out what so=
rt of interest<br>
&gt;&gt;&gt; people<br>
&gt;&gt;&gt; have in dm-user: when I bring this up I seem to run into peopl=
e who&#39;ve done<br>
&gt;&gt;&gt; similar things before and are vaguely interested, but certainl=
y nobody is<br>
&gt;&gt;&gt; chomping at the bit.=C2=A0 I&#39;m sending it out in this earl=
y state to try and<br>
&gt;&gt;&gt; figure<br>
&gt;&gt;&gt; out if it&#39;s interesting enough to keep going.<br>
&gt;&gt;<br>
&gt;&gt; Cc-ing Josef and Mike since their nbd contributions make me wonder=
<br>
&gt;&gt; whether this new driver could be useful to their use cases?<br>
&gt;&gt;<br>
&gt;<br>
&gt; Sorry gmail+imap sucks and I can&#39;t get my email client to get at t=
he original<br>
&gt; thread.=C2=A0 However here is my take.<br>
<br>
and I guess I then have to apoligize for missing your email ;).=C2=A0 Hopef=
ully that<br>
was the problem, but who knows.<br>
<br>
&gt; 1) The advantages of using dm-user of NBD that you listed aren&#39;t a=
ctually<br>
&gt; problems for NBD.=C2=A0 We have NBD working in production where you ca=
n hand off the<br>
&gt; sockets for the server without ending in timeouts, it was actually the=
 main<br>
&gt; reason we wrote our own server so we could use the FD transfer stuff t=
o restart<br>
&gt; the server without impacting any clients that had the device in use.<b=
r>
<br>
OK.=C2=A0 So you just send the FD around using one of the standard mechanis=
ms to<br>
orchestrate the handoff?=C2=A0 I guess that might work for our use case, as=
suming<br>
whatever the security side of things was doing was OK with the old FD.=C2=
=A0 TBH I&#39;m<br>
not sure how all that works and while we thought about doing that sort of<b=
r>
transfer scheme we decided to just open it again -- not sure how far we wer=
e<br>
down the dm-user rabbit hole at that point, though, as this sort of arose o=
ut<br>
of some other ideas.<br>
<br>
&gt; 2) The extra copy is a big deal, in fact we already have too many copi=
es in our<br>
&gt; existing NBD setup and are actively looking for ways to avoid those.<b=
r>
&gt;<br>
&gt; Don&#39;t take this as I don&#39;t think dm-user is a good idea, but I=
 think at the very<br>
&gt; least it should start with the very best we have to offer, starting wi=
th as few<br>
&gt; copies as possible.<br>
<br>
I was really experting someone to say that.=C2=A0 It does seem kind of sill=
y to build<br>
out the new interface, but not go all the way to a ring buffer.=C2=A0 We ju=
st didn&#39;t<br>
really have any way to justify the extra complexity as our use cases aren&#=
39;t<br>
that high performance.=C2=A0 =C2=A0I kind of like to have benchmarks for th=
is sort of<br>
thing, though, and I didn&#39;t have anyone who had bothered avoiding the l=
ast copy<br>
to compare against.<br>
<br>
&gt; If you are using it currently in production then cool, there&#39;s cle=
arly a usecase<br>
&gt; for it.=C2=A0 Personally as I get older and grouchier I want less thin=
gs in the<br>
&gt; kernel, so if this enables us to eventually do everything NBD related =
in<br>
&gt; userspace with no performance drop then I&#39;d be down.=C2=A0 I don&#=
39;t think you need to<br>
&gt; make that your primary goal, but at least polishing this up so it coul=
d<br>
&gt; potentially be abused in the future would make it more compelling for =
merging.<br>
&gt; Thanks,<br>
<br>
Ya, it&#39;s in Android already and we&#39;ll be shipping it as part of the=
 new OTA<br>
flow for the next release.=C2=A0 The rules on deprecation are a bit differe=
nt over<br>
there, though, so it&#39;s not like we&#39;re wed to it.=C2=A0 The whole po=
int of bringing<br>
this up here was to try and get something usable by everyone, and while I&#=
39;d<br>
eventually like to get whatever&#39;s in Android into the kernel proper we&=
#39;d really<br>
planned on supporting an extra Android-only ABI for a cycle at least.=C2=A0=
 <br>
<br>
I&#39;m kind of inclined to take a crack at the extra copy, to at least see=
 if<br>
building something that eliminates it is viable.=C2=A0 I&#39;m not really s=
ure if it is<br>
(or at least, if it&#39;ll net us a meaningful amount of performance), but =
it&#39;d at<br>
least be interesting to try.<br>
<br>
It&#39;d be nice to have some benchmark target, though, as otherwise this s=
tuff<br>
hangs on forever.=C2=A0 My workloads are in selftests later on in the patch=
 set, but<br>
I&#39;m essentially using tmpfs as a baseline to compare against ext4+dm-us=
er with<br>
some FIO examples as workloads.=C2=A0 Our early benchmark numbers indicated=
 this was<br>
way faster than we needed, so I didn&#39;t even bother putting together a p=
roper<br>
system to run on so I don&#39;t really have any meaningful numbers there.=
=C2=A0 Is there<br>
an NBD server that&#39;s fast that I should be comparing against?<br>
<br>
I haven&#39;t gotten a whole lot of feedback, so I&#39;m inclined to at lea=
st have some<br>
reasonable performance numbers before bothering with a v2.<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
</blockquote></div><br clear=3D"all"><br>-- <br><div dir=3D"ltr" class=3D"g=
mail_signature">Akira Hayakawa</div>

--000000000000c61a2c05b68ed3b6--

--===============8571211547438565926==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============8571211547438565926==--

