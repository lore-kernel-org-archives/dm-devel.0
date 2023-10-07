Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFA07E95A69
	for <dm-devel@archiver.kernel.org>; Sat,  7 Oct 2023 18:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696702368;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=69udHkGFl47NqMSahl+W9mMnLt/xCGOhg18WwoDd6W4=;
	b=hMXY2+ftdKcAupuQQOm/EdtrrsZC1pKYLexrJcfXW6Mfr5EB6JTdlP/4AJhz124mtP9phA
	GI76KCUeVc827cYCfZCGM20xsMGj4HQwsG5zJgfuSdV5hpfaBKRbFbwmaJFgvXhwq7MaOf
	kMqhjyxryDHepk+Am8k7/MeRtiVBzrY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-688-xrKCWbm_NVK0GzI58tXGFw-1; Sat, 07 Oct 2023 14:12:45 -0400
X-MC-Unique: xrKCWbm_NVK0GzI58tXGFw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69C9E8007A4;
	Sat,  7 Oct 2023 18:12:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E0BC42156711;
	Sat,  7 Oct 2023 18:12:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 806D1194658C;
	Sat,  7 Oct 2023 18:12:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 792DD1946587
 for <dm-devel@listman.corp.redhat.com>; Sat,  7 Oct 2023 18:12:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EFC592156711; Sat,  7 Oct 2023 18:12:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E87BB215670B
 for <dm-devel@redhat.com>; Sat,  7 Oct 2023 18:12:36 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB24C185A78E
 for <dm-devel@redhat.com>; Sat,  7 Oct 2023 18:12:36 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-EqWsYsi4M5Op2b2m-rGjFg-1; Sat, 07 Oct 2023 14:12:34 -0400
X-MC-Unique: EqWsYsi4M5Op2b2m-rGjFg-1
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
 by dfw.source.kernel.org (Postfix) with ESMTP id 2125B60ADC;
 Sat,  7 Oct 2023 18:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2416C433C8;
 Sat,  7 Oct 2023 18:12:32 +0000 (UTC)
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org
 (localhost.localdomain [127.0.0.1])
 by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id
 942F3C41671; Sat,  7 Oct 2023 18:12:32 +0000 (UTC)
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZSCVUa3D4BAKGsLL@redhat.com>
References: <ZSCVUa3D4BAKGsLL@redhat.com>
X-PR-Tracked-List-Id: device-mapper development <dm-devel.redhat.com>
X-PR-Tracked-Message-Id: <ZSCVUa3D4BAKGsLL@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
 tags/for-6.6/dm-fixes-2
X-PR-Tracked-Commit-Id: 3da5d2de92387a8322965c7fb1365f7cae690e5a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4aef108a4d60bb52bf4e8e2ed9444afe2cdfe6a9
Message-Id: <169670235249.17141.917993586452703729.pr-tracker-bot@kernel.org>
Date: Sat, 07 Oct 2023 18:12:32 +0000
To: Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [git pull] device mapper fixes for 6.6-rc5
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Fedor Pchelkin <pchelkin@ispras.ru>, Alasdair G Kergon <agk@redhat.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The pull request you sent on Fri, 6 Oct 2023 19:16:33 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.6/dm-fixes-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4aef108a4d60bb52bf4e8e2ed9444afe2cdfe6a9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

