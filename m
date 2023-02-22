Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E9CCC61DA4
	for <dm-devel@archiver.kernel.org>; Wed, 22 Feb 2023 21:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677103048;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eJfQBsbETEMeiiRcOOaIj+V107qtC++6cNnHBTeLv/4=;
	b=YNdTn5sl2TtW5Fh0Xxj2bK8+VQ8BR8SVtueB0zJoKLXNGSzMEqgfJl7APfxGB8+BE2GltV
	WKA8PEJhTs3Im9Q+UVEuftSuSAO4KuUUDIxPnJoGLsNsB1+ZMnyzWSDrXaUw4YshT9h6jt
	E33TMPiPpOfazFCGOVPcX5ezGx2ksQE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-67-cRFUL5ikOFWapwPL29arkg-1; Wed, 22 Feb 2023 16:57:24 -0500
X-MC-Unique: cRFUL5ikOFWapwPL29arkg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5F0680D0F2;
	Wed, 22 Feb 2023 21:57:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 708B6492B04;
	Wed, 22 Feb 2023 21:57:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4546719465A0;
	Wed, 22 Feb 2023 21:57:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E1113194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 22 Feb 2023 21:57:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CEFFD440DD; Wed, 22 Feb 2023 21:57:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C719718EC1
 for <dm-devel@redhat.com>; Wed, 22 Feb 2023 21:57:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6984101AA63
 for <dm-devel@redhat.com>; Wed, 22 Feb 2023 21:57:20 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-cvZpE5yZO0aSb81eF886Kw-1; Wed, 22 Feb 2023 16:57:15 -0500
X-MC-Unique: cvZpE5yZO0aSb81eF886Kw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id C0904616D3;
 Wed, 22 Feb 2023 21:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2A6F7C433D2;
 Wed, 22 Feb 2023 21:48:52 +0000 (UTC)
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org
 (localhost.localdomain [127.0.0.1])
 by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id
 18593C43157; Wed, 22 Feb 2023 21:48:52 +0000 (UTC)
From: pr-tracker-bot@kernel.org
In-Reply-To: <Y/OueIbrfUBZRw5J@redhat.com>
References: <Y/OueIbrfUBZRw5J@redhat.com>
X-PR-Tracked-List-Id: <linux-block.vger.kernel.org>
X-PR-Tracked-Message-Id: <Y/OueIbrfUBZRw5J@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
 tags/for-6.3/dm-changes
X-PR-Tracked-Commit-Id: d695e44157c8da8d298295d1905428fb2495bc8b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f0b2769a0185ccf84842a795b5587afc37274c3d
Message-Id: <167710253208.31368.7847865305114307104.pr-tracker-bot@kernel.org>
Date: Wed, 22 Feb 2023 21:48:52 +0000
To: Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [git pull] device mapper changes for 6.3
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
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
 Sergey Shtylyov <s.shtylyov@omp.ru>, Pingfan Liu <piliu@redhat.com>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Heinz Mauelshagen <heinzm@redhat.com>,
 Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
 Joe Thornber <ejt@redhat.com>, Nathan Huckleberry <nhuck@google.com>,
 linux-block@vger.kernel.org, Yu Zhe <yuzhe@nfschina.com>, dm-devel@redhat.com,
 XU pengfei <xupengfei@nfschina.com>,
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 Hou Tao <houtao1@huawei.com>, Mikulas Patocka <mpatocka@redhat.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Alasdair G Kergon <agk@redhat.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The pull request you sent on Mon, 20 Feb 2023 12:31:36 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.3/dm-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f0b2769a0185ccf84842a795b5587afc37274c3d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

