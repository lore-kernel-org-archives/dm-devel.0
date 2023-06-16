Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A441EB64D7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Jun 2023 04:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686889488;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=c+TNmwZ9dNHe1hVY6Cqhl5QXUgbdVMxi1swwJBooV7U=;
	b=PtAVMmqXjvwDM5+oH5rHB2FBQqHc3hQ3ygZW4XYBq7pecm++Z3PIecykmR3s8w7xz2vnLf
	iupJNpZN4B/+jKehBT/gwvg+Yuuo/S0c+EOCC8y+HJSxi47NN7ra6Dn3egBuDaQXXFskY/
	/RieygRjLgpHHMs7bJ/7/ZvDahPBiLo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-HrAKoiVcOsq2bIWOvZbCbQ-1; Fri, 16 Jun 2023 00:24:47 -0400
X-MC-Unique: HrAKoiVcOsq2bIWOvZbCbQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AA7A101AA46;
	Fri, 16 Jun 2023 04:24:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9917440CF8F6;
	Fri, 16 Jun 2023 04:24:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6AAC81946594;
	Fri, 16 Jun 2023 04:24:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EF34C1946589
 for <dm-devel@listman.corp.redhat.com>; Fri, 16 Jun 2023 04:24:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D076940CF8F7; Fri, 16 Jun 2023 04:24:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C88E540CF8F6
 for <dm-devel@redhat.com>; Fri, 16 Jun 2023 04:24:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A67A880120F
 for <dm-devel@redhat.com>; Fri, 16 Jun 2023 04:24:40 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-O-4G5PO3M_m-E1S0z-Nmrg-1; Fri, 16 Jun 2023 00:24:39 -0400
X-MC-Unique: O-4G5PO3M_m-E1S0z-Nmrg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id C9B3261AAF;
 Fri, 16 Jun 2023 04:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0E590C433C0;
 Fri, 16 Jun 2023 04:16:39 +0000 (UTC)
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org
 (localhost.localdomain [127.0.0.1])
 by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id
 EFE17C3274B; Fri, 16 Jun 2023 04:16:38 +0000 (UTC)
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZItQzl4ommfR82jP@redhat.com>
References: <ZItQzl4ommfR82jP@redhat.com>
X-PR-Tracked-List-Id: <linux-block.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZItQzl4ommfR82jP@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
 tags/for-6.4/dm-fixes
X-PR-Tracked-Commit-Id: be04c14a1bd262a49e5764e5cf864259b7e740fd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0e306952d7151afdaa16e9acf280a739d1fe7b29
Message-Id: <168688899897.32380.1290343559572704575.pr-tracker-bot@kernel.org>
Date: Fri, 16 Jun 2023 04:16:38 +0000
To: Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [git pull] device mapper fixes for 6.4-rc7
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
Cc: Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Li Lingfeng <lilingfeng3@huawei.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Alasdair G Kergon <agk@redhat.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The pull request you sent on Thu, 15 Jun 2023 13:56:30 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.4/dm-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0e306952d7151afdaa16e9acf280a739d1fe7b29

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

