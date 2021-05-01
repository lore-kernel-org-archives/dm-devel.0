Return-Path: <SRS0=QF+r=J4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93387C433ED
	for <dm-devel@archiver.kernel.org>; Sat,  1 May 2021 18:39:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 29E9361490
	for <dm-devel@archiver.kernel.org>; Sat,  1 May 2021 18:39:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29E9361490
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-hRFzT5OfNfOB6AImqioTeg-1; Sat, 01 May 2021 14:39:05 -0400
X-MC-Unique: hRFzT5OfNfOB6AImqioTeg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C68E1008061;
	Sat,  1 May 2021 18:39:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 02DB15C1C4;
	Sat,  1 May 2021 18:38:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0EFAA55341;
	Sat,  1 May 2021 18:38:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 141Icm6E017826 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 1 May 2021 14:38:48 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7701F205FA89; Sat,  1 May 2021 18:38:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 72AC6205FA90
	for <dm-devel@redhat.com>; Sat,  1 May 2021 18:38:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 308F8858F0D
	for <dm-devel@redhat.com>; Sat,  1 May 2021 18:38:45 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-598-stfdgVa7M6SP9w2_ZBc-sA-1;
	Sat, 01 May 2021 14:38:43 -0400
X-MC-Unique: stfdgVa7M6SP9w2_ZBc-sA-1
Received: by mail.kernel.org (Postfix) with ESMTPS id 931EC61481;
	Sat,  1 May 2021 18:38:41 +0000 (UTC)
From: pr-tracker-bot@kernel.org
In-Reply-To: <20210430193237.GA7659@redhat.com>
References: <20210430193237.GA7659@redhat.com>
X-PR-Tracked-List-Id: device-mapper development <dm-devel.redhat.com>
X-PR-Tracked-Message-Id: <20210430193237.GA7659@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
	tags/for-5.13/dm-changes
X-PR-Tracked-Commit-Id: ca4a4e9a55beeb138bb06e3867f5e486da896d44
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7af81cd0c4306482b49a3adce0fb2f8655f57d0f
Message-Id: <161989432145.5572.1222837453215569840.pr-tracker-bot@kernel.org>
Date: Sat, 01 May 2021 18:38:41 +0000
To: Mike Snitzer <snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Bhaskar Chowdhury <unixbhaskar@gmail.com>, dm-devel@redhat.com,
	Heinz Mauelshagen <heinzm@redhat.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Matthew Ruffell <matthew.ruffell@canonical.com>,
	JeongHyeon Lee <jhs2.lee@samsung.com>,
	Julia Lawall <julia.lawall@inria.fr>,
	Joe Thornber <ejt@redhat.com>, linux-block@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>, Tian Tao <tiantao6@hisilicon.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Alasdair G Kergon <agk@redhat.com>, Xu Wang <vulab@iscas.ac.cn>
Subject: Re: [dm-devel] [git pull] device mapper changes for 5.13
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The pull request you sent on Fri, 30 Apr 2021 15:32:38 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.13/dm-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7af81cd0c4306482b49a3adce0fb2f8655f57d0f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

