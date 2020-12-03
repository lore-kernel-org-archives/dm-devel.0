Return-Path: <SRS0=D9Ri=FI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18868C4361B
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 09:27:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8508422838
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 09:27:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8508422838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-cpdSG6O_MIqWOBxhK63e-A-1; Fri, 04 Dec 2020 04:27:42 -0500
X-MC-Unique: cpdSG6O_MIqWOBxhK63e-A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE48F107ACF6;
	Fri,  4 Dec 2020 09:27:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B87366085A;
	Fri,  4 Dec 2020 09:27:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 907891809CA0;
	Fri,  4 Dec 2020 09:27:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3MWVRh011128 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 17:32:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2FA52101F0C9; Thu,  3 Dec 2020 22:32:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B621101F0BD
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 22:32:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC55E85828C
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 22:32:28 +0000 (UTC)
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com
	[209.85.214.193]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-205-YVeBye10PnKv2KHlojD44Q-1; Thu, 03 Dec 2020 17:32:26 -0500
X-MC-Unique: YVeBye10PnKv2KHlojD44Q-1
Received: by mail-pl1-f193.google.com with SMTP id l11so1993779plt.1
	for <dm-devel@redhat.com>; Thu, 03 Dec 2020 14:32:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:date:message-id:mime-version
	:content-transfer-encoding:cc:from:to;
	bh=SPmFoB1my9jXoLv2dn26VSZIQKA7cIMRdqpuLUFB/zE=;
	b=W9MqVDBVOQPakPsyV7eMgAXmg5DUqyH18j8Je+xVQe4qBlp7VTiRZLDZYGo18R3PAL
	JzZULwEfad5257jclMI8Ad+CvxbzLA8jH2umJIvk9ZE/ojEh4y8mkbR0A9N7xrcQGtFM
	08bBRWz5+ayqUpYlrYBbo6NiYdIGOX2796gVh477R3o2JD6BwIaDkZ6jdRPNgUx9tr5+
	YGEgXieeIf5+IRsDMX9tb+KS5jkqHgYweH6OgJeoH1xTOnN91k620H0IFqTR0IfaApoj
	Os+jm/r3I3oBTP2jfAHCDup6pduEuTajSK1AOh/eyTrVMGbX8f1JJsGb+cFAHxat55y7
	sk5g==
X-Gm-Message-State: AOAM532VNSXE8bo8CiIqT9Y9qYt+V+5HmVzqof43/kOAxWZOrKQhBR+o
	wK6hRq+laCOblTryxsexsKvM3w==
X-Google-Smtp-Source: ABdhPJxhPr+P5fujnqKI96o2pvSvJ5MAQGdtq4scxTMGJtMVGb63v//A39PGQQlbMjp5MmCtDbhQGg==
X-Received: by 2002:a17:902:469:b029:da:17d0:e755 with SMTP id
	96-20020a1709020469b02900da17d0e755mr954487ple.53.1607034745298;
	Thu, 03 Dec 2020 14:32:25 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net.
	[76.210.143.223]) by smtp.gmail.com with ESMTPSA id
	x23sm2646437pfo.209.2020.12.03.14.32.24
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 03 Dec 2020 14:32:24 -0800 (PST)
Date: Thu,  3 Dec 2020 13:58:54 -0800
Message-Id: <20201203215859.2719888-1-palmer@dabbelt.com>
MIME-Version: 1.0
From: Palmer Dabbelt <palmer@dabbelt.com>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
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
X-Mailman-Approved-At: Fri, 04 Dec 2020 04:27:20 -0500
Cc: corbet@lwn.net, linux-doc@vger.kernel.org, kernel-team@android.com,
	Palmer Dabbelt <palmerdabbelt@google.com>,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	song@kernel.org, linux-kselftest@vger.kernel.org, shuah@kernel.org
Subject: [dm-devel] [PATCH v1 0/5] dm: dm-user: New target that proxies BIOs
	to userspace
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch set contains dm-user, a device mapper target that proxies incoming
BIOs to userspace via a misc device.  Essentially it's FUSE, but for block
devices.  There's more information in the documentation patch and as a handful
of commends, so I'm just going to avoid duplicating that here.  I don't really
think there's any fundamental functionality that dm-user enables, as one could
use something along the lines of nbd/iscsi, but dm-user does result in
extremely simple userspace daemons -- so simple that when I tried to write a
helper userspace library for dm-user I just ended up with nothing.

I talked about this a bit at Plumbers and was hoping to send patches a bit
earlier on in the process, but got tied up with a few things.  As a result this
is actually quite far along: it's at the point where we're starting to run this
on real devices as part of an updated Android OTA update flow, where we're
using this to provide an Android-specific compressed backing store for
dm-snap-persistent.  The bulk of that project is scattered throughout the
various Android trees, so there are kselftests and a (somewhat bare for now)
Documentation entry with the intent of making this a self-contained
contribution.  There's a lot to the Android userspace daemon, but it doesn't
interact with dm-user in a very complex manner.

This is still in a somewhat early stage, but it's at the point where things
largely function.  I'm certainly not ready to commit to the user ABI
implemented here and there are a bunch of FIXMEs scattered throughout the code,
but I do think that it's far along enough to begin a more concrete discussion
of where folks would like to go with something like this.  While I'd intending
on sorting that stuff out, I'd like to at least get a feel for whether this is
a path worth pursuing before spending a bunch more time on it.

I haven't done much in the way of performance analysis for dm-user.  Earlier on
I did some simple throughput tests and found that dm-user/ext4 was faster than
half the speed of tmpfs, which is way out of the realm of being an issue for
our use case (decompressing blocks out of a phone's storage).  The design of
dm-user does preclude an extremely high performance implementation, where I
assume one would want an explicit ring buffer and zero copy, but I feel like
users who want that degree of performance are probably better served writing a
proper kernel driver.  I wouldn't be opposed to pushing on performance (ideally
without a major design change), but for now I feel like time is better spent
fortifying the user ABI and fixing the various issues with the implementation.

The patches follow as usual, but in case it's easier I've published a tree as
well:

    git://git.kernel.org/pub/scm/linux/kernel/git/palmer/dm-user.git -b dm-user-v1


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

