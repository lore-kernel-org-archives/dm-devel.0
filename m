Return-Path: <SRS0=0A1B=P4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0600FC4332F
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 19:31:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9779B6162E
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 19:31:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9779B6162E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-w-eOBE7CO_6Lyy-3gpvD8A-1; Tue, 09 Nov 2021 14:31:51 -0500
X-MC-Unique: w-eOBE7CO_6Lyy-3gpvD8A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34D1987D545;
	Tue,  9 Nov 2021 19:31:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C509B19C59;
	Tue,  9 Nov 2021 19:31:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 52AD84A703;
	Tue,  9 Nov 2021 19:31:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A9JVgH6014634 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Nov 2021 14:31:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4F9BB2166B25; Tue,  9 Nov 2021 19:31:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 49B302166B26
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 19:31:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DB3F185A7B4
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 19:31:39 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-69-qfC8wL8SPWukqmq_wMidUw-1; 
	Tue, 09 Nov 2021 14:31:35 -0500
X-MC-Unique: qfC8wL8SPWukqmq_wMidUw-1
Received: by mail.kernel.org (Postfix) with ESMTPS id 42ADE6134F;
	Tue,  9 Nov 2021 19:31:34 +0000 (UTC)
From: pr-tracker-bot@kernel.org
In-Reply-To: <YYmVyArwFwN/FdfA@redhat.com>
References: <YYmVyArwFwN/FdfA@redhat.com>
X-PR-Tracked-List-Id: device-mapper development <dm-devel.redhat.com>
X-PR-Tracked-Message-Id: <YYmVyArwFwN/FdfA@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
	tags/for-5.16/dm-changes
X-PR-Tracked-Commit-Id: 7552750d0494fdd12f71acd8a432f51334a4462d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c183e1707aba2c707837569b473d1e9fd48110c4
Message-Id: <163648629413.13393.2993481418181438712.pr-tracker-bot@kernel.org>
Date: Tue, 09 Nov 2021 19:31:34 +0000
To: Mike Snitzer <snitzer@redhat.com>
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
Cc: Michael =?iso-8859-1?Q?Wei=DF?= <michael.weiss@aisec.fraunhofer.de>,
	dm-devel@redhat.com,
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
	linux-block@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Cai Huoqing <caihuoqing@baidu.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [git pull] device mapper changes for 5.16
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The pull request you sent on Mon, 8 Nov 2021 16:25:28 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.16/dm-changes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c183e1707aba2c707837569b473d1e9fd48110c4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

