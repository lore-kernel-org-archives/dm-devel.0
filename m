Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CDA3C7EE25
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 15:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686152334;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=//RHmJTCYi2N5oWfQOV0GssYFmR2X06hER6neUOCjiw=;
	b=D+VIhrOb5TBkOkMy5wnQfodzCqUh4KnDbNjXjEOqITVWCw9Wx+CNC00JTiOQOZvPnMb0pW
	fOpp/JzUvkqPniOVQC1HrdJHDCNT2g0JFJ1xuozU1URf4DbmdHdiz5m+mS6mEpdXAHLTOD
	YF8E1j32NDKfyU2QdubWaiRScKpXDag=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-X7LG1tAUP5WLYbdgtJdwRQ-1; Wed, 07 Jun 2023 11:38:50 -0400
X-MC-Unique: X7LG1tAUP5WLYbdgtJdwRQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00F96185A791;
	Wed,  7 Jun 2023 15:38:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 580302166B26;
	Wed,  7 Jun 2023 15:38:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 08C0C19451C0;
	Wed,  7 Jun 2023 15:38:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E615719465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 15:14:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C6BC8C1603B; Wed,  7 Jun 2023 15:14:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BE2DBC0004B
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 15:14:55 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF73F1C01EBF
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 15:14:17 +0000 (UTC)
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-400-zfrwn0AMMj-KGlbX1yuI4Q-1; Wed,
 07 Jun 2023 11:12:23 -0400
X-MC-Unique: zfrwn0AMMj-KGlbX1yuI4Q-1
Received: from authenticated user by stravinsky.debian.org with esmtpsa
 (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
 (Exim 4.94.2) (envelope-from <zeha@debian.org>)
 id 1q6upf-004Siu-Sx; Wed, 07 Jun 2023 15:12:20 +0000
Date: Wed, 7 Jun 2023 17:12:10 +0200
From: Chris Hofstaedtler <zeha@debian.org>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <zy7caef43nvpfetodg6sc7bhp5aj3scvkcg2p5jabnzhtetkq3@4aco3dd4kwrh>
References: <a674434b-d365-1f07-2c6f-6a4ffa07578f@gmail.com>
 <946fc11571491dd39971288b48095b6480f7914f.camel@suse.com>
 <bjgxqic4umo4rk2srj4mqdgvvxntosb2xxo63fmymirulir7st@jduzswoyhupe>
 <1f452452d8f0952d3fa704f6ad9861392c5b45f7.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <1f452452d8f0952d3fa704f6ad9861392c5b45f7.camel@suse.com>
X-Debian-User: zeha
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] multipath-tools: Debian patches
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
 dm-devel mailing list <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: debian.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

* Martin Wilck <mwilck@suse.com> [230606 21:40]:
> On Tue, 2023-06-06 at 18:48 +0200, Chris Hofstaedtler wrote:
[..]
> > > If Chris has followed the upstream discussion, he is probably aware
> > > that we do care about the ABI. We don't keep the libmultipath ABI
> > > stable, but track it using ABI versioning.
> > 
> > I was only vaguely aware of the changes in the <lib>.version files,
> > and that all .so files are ".so.0".
> > From a quick glance it looks like libmultipath.so.0 from 0.9.4
> > exports a lot of symbols versioned @LIBMULTIPATH_17.0.0, but f.e.
> > none versioned @LIBMULTIPATH_15.0.0, but the soname didn't change.
> 
> Maybe Debian enforces additional policies I'm unaware of, but
> technically, the soname, or filename based library versioning, doesn't
> matter if symbol versioning is used [1]. Symbol versioning can be used
> in different ways. For libmultipath, we don't attempt to provide
> multiple backward-compatible ABIs. We just want to avoid undefined
> behavior which would result from an executable calling a library
> routine with a different version of the ABI, and this is what our
> library versioning scheme achieves. The idea is similar to the kernel's
> symvers mechanism, which avoids loading binary-incompatible modules.
> 
> > So - I'm not sure if, for a Debian library package, it is okay to do
> > essentially drop symbols without a new soname.
> 
> I can't tell for Debian, but other distributions haven't complained so
> far. I don't think that multipath-tools is the only project that uses
> symbol versioning this way.
> 

[..]

> On rpm-based distributions,package management will be able to figure
> out this kind of (in)compatibility, albeit in a more coarse-grained way
> (e.g. the multipathd package requires
> libmpathpersist.so.0(LIBMPATHPERSIST_2.1.0)(64bit), which must match
> the provided features of the library package). I suppose something
> similar exists in the Debian realm, too.

Do you also rename the package that ships libpathmpersist.so.0 in
this case?

I.e. how do you make this example work:

old libmpathpersist.so.0 provides ABI 1
new libmpathpersist.so.0(?) provides ABI 2

multipathd was linked against the new libmpathpersist.so.0 (ABI 2)
qemu was linked against the old libmpathpersist.so.0 (ABI 1)

I don't see how these can be co-installable if libmpathpersist.so.0
is never renamed?

Maybe other distributions do not need coinstallability, but Debian
needs this, because a) on actual installs we support partial upgrades,
and b) we do not rebuild all reverse-dependencies of a library the
moment a new version of that lib is uploaded.


I also wonder you get from symbol versioning if the old symbols just
disappear. ISTM you could get the same effect - cannot by accident
load the wrong library version - just by bumping the soname, and
ignoring manual symbol versioning?


I asked around a bit and got "this seems very unusual" as feedback.


Thanks,
Chris

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

