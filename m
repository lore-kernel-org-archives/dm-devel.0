Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D94DC19F29
	for <dm-devel@archiver.kernel.org>; Tue,  2 Aug 2022 21:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659475826;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mb/Rs3Lwwe1jpnIdEeiTTYCSlHryfiA0tdTDOy7hQ2c=;
	b=IKo5SeGo0exyf7CkEDYkbb1JlHamtJIOcVJiSwS/5ftedfcpR8p9k31taRITOMAGrOU/AK
	APMhXoHlIjYumAlWoFXr/8agUh3qgF8dSDkVKSHAKh+Y3mO0uJ4dXVj3ZpvPL67ppLA6WX
	z3/E+fbB2zZyK67Q9ROkFRjYb7jhdAE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-2Y7DpS4oMxeuM3LpCvrqsg-1; Tue, 02 Aug 2022 17:30:23 -0400
X-MC-Unique: 2Y7DpS4oMxeuM3LpCvrqsg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 334CA101A54E;
	Tue,  2 Aug 2022 21:30:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2D4A640CFD0A;
	Tue,  2 Aug 2022 21:30:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EEF801946A57;
	Tue,  2 Aug 2022 21:30:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F20501946A4E
 for <dm-devel@listman.corp.redhat.com>; Tue,  2 Aug 2022 21:30:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C9164492CA4; Tue,  2 Aug 2022 21:30:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C53A6492C3B
 for <dm-devel@redhat.com>; Tue,  2 Aug 2022 21:30:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE294280407E
 for <dm-devel@redhat.com>; Tue,  2 Aug 2022 21:30:17 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-378-enUssJuFObSp4i-tchz8-A-1; Tue, 02 Aug 2022 17:30:16 -0400
X-MC-Unique: enUssJuFObSp4i-tchz8-A-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 3BFC361550;
 Tue,  2 Aug 2022 21:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 955ECC4347C;
 Tue,  2 Aug 2022 21:30:14 +0000 (UTC)
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org
 (localhost.localdomain [127.0.0.1])
 by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id
 8129EC43142; Tue,  2 Aug 2022 21:30:14 +0000 (UTC)
From: pr-tracker-bot@kernel.org
In-Reply-To: <YugiaQ1TO+vT1FQ5@redhat.com>
References: <YugiaQ1TO+vT1FQ5@redhat.com>
X-PR-Tracked-List-Id: <linux-block.vger.kernel.org>
X-PR-Tracked-Message-Id: <YugiaQ1TO+vT1FQ5@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
 tags/for-6.0/dm-changes
X-PR-Tracked-Commit-Id: 9dd1cd3220eca534f2d47afad7ce85f4c40118d8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8374cfe647a1f360be3228b949dd6d753c55c19c
Message-Id: <165947581452.30731.17701893502534317271.pr-tracker-bot@kernel.org>
Date: Tue, 02 Aug 2022 21:30:14 +0000
To: Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [git pull] device mapper changes for 6.0
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
Cc: JeongHyeon Lee <jhs2.lee@samsung.com>, Steven Lung <1030steven@gmail.com>,
 Zhang Jiaming <jiaming@nfschina.com>, Jiang Jian <jiangjian@cdjrlc.com>,
 Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Mike Christie <michael.christie@oracle.com>,
 Bagas Sanjaya <bagasdotme@gmail.com>, Luo Meng <luomeng12@huawei.com>,
 Mauro Carvalho Chehab <mchehab@kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
 Alasdair G Kergon <agk@redhat.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The pull request you sent on Mon, 1 Aug 2022 14:58:49 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.0/dm-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8374cfe647a1f360be3228b949dd6d753c55c19c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

