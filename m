Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F1EAEB64DA
	for <dm-devel@archiver.kernel.org>; Fri, 30 Jun 2023 19:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688155005;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=S3KkkPC0vSK89f45Xp57iKpss8iiSQBZvNMVTNlwkh4=;
	b=Gwo6bX0hprJey9fn/SxZBYBfMUM4aqBiJ/ETceA65IYaaJ4G2JxDPglkvBwMQefsv2VNgK
	7vMx2bHguuOMZ+Cm93Sn6u5P069ydLgSIJ0tu5MJRzkUF9E7sOfZikS4iLQ80Rk8S0Bmpf
	1E3x2GhP/to39AXpUmIfnihwCrmW244=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-BHlnTIRlOrG2hlJhIuxnTw-1; Fri, 30 Jun 2023 15:56:42 -0400
X-MC-Unique: BHlnTIRlOrG2hlJhIuxnTw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5063A2999B2A;
	Fri, 30 Jun 2023 19:56:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E4A7FF5CE5;
	Fri, 30 Jun 2023 19:56:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D66BA19465B6;
	Fri, 30 Jun 2023 19:56:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 928B319465B3
 for <dm-devel@listman.corp.redhat.com>; Fri, 30 Jun 2023 19:28:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 38A8840C206F; Fri, 30 Jun 2023 19:28:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3140F40C2063
 for <dm-devel@redhat.com>; Fri, 30 Jun 2023 19:28:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0DE7185A78B
 for <dm-devel@redhat.com>; Fri, 30 Jun 2023 19:28:22 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-EuaBPHvfNoSayNqt-_Mrew-1; Fri, 30 Jun 2023 15:28:19 -0400
X-MC-Unique: EuaBPHvfNoSayNqt-_Mrew-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 895B0617F1;
 Fri, 30 Jun 2023 19:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D687CC433C8;
 Fri, 30 Jun 2023 19:28:17 +0000 (UTC)
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org
 (localhost.localdomain [127.0.0.1])
 by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id
 C55CEC43158; Fri, 30 Jun 2023 19:28:17 +0000 (UTC)
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZJ3vBCypvTQ7w9pN@redhat.com>
References: <ZJ3vBCypvTQ7w9pN@redhat.com>
X-PR-Tracked-List-Id: device-mapper development <dm-devel.redhat.com>
X-PR-Tracked-Message-Id: <ZJ3vBCypvTQ7w9pN@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
 tags/for-6.5/dm-changes
X-PR-Tracked-Commit-Id: e2c789cab60a493a72b42cb53eb5fbf96d5f1ae3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6cdbb0907a3c562723455e351c940037bdec9b7a
Message-Id: <168815329779.22437.16514933042185962447.pr-tracker-bot@kernel.org>
Date: Fri, 30 Jun 2023 19:28:17 +0000
To: Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [git pull] device mapper changes for 6.5
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
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 Alasdair G Kergon <agk@redhat.com>,
 Demi Marie Obenour <demi@invisiblethingslab.com>,
 Russell Harmon <eatnumber1@gmail.com>, Li Lingfeng <lilingfeng3@huawei.com>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, Li Nan <linan122@huawei.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The pull request you sent on Thu, 29 Jun 2023 16:52:20 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.5/dm-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6cdbb0907a3c562723455e351c940037bdec9b7a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

