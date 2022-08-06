Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70D30C19F2D
	for <dm-devel@archiver.kernel.org>; Sat,  6 Aug 2022 18:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659810569;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Rb5b1/EHfIc9enBRqX/CZwTctyssbc8w7J8olbSefYU=;
	b=fMckudIKsiJwAwDDz800YY18NpfZhyvfcW6H3j3jE4oc7L1RU3CZcf2xx45ooxrMRZRnj/
	NpjlKHPVSHGEMpOu599nhtLfG1C+QZsbYXkmj+4+BdbCSVS/zBo05x6qAi7g5WRFBfMPw7
	K07LyXmJp6XMIqltWAQf4xfBAuBG7is=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-VKm3BBGWMDK-Uw9lBiRPdw-1; Sat, 06 Aug 2022 14:29:26 -0400
X-MC-Unique: VKm3BBGWMDK-Uw9lBiRPdw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DA8B3C02190;
	Sat,  6 Aug 2022 18:29:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DBDB22026D07;
	Sat,  6 Aug 2022 18:29:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7B52D1946A54;
	Sat,  6 Aug 2022 18:29:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2A5601946A45
 for <dm-devel@listman.corp.redhat.com>; Sat,  6 Aug 2022 18:29:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EC003C27D95; Sat,  6 Aug 2022 18:29:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E85CAC23DBF
 for <dm-devel@redhat.com>; Sat,  6 Aug 2022 18:29:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D09B7185A79C
 for <dm-devel@redhat.com>; Sat,  6 Aug 2022 18:29:21 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-494-gGvh4uD8M96cwvVjoAxU9w-1; Sat, 06 Aug 2022 14:29:20 -0400
X-MC-Unique: gGvh4uD8M96cwvVjoAxU9w-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id E8AD5B80837;
 Sat,  6 Aug 2022 18:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB6FAC43470;
 Sat,  6 Aug 2022 18:19:40 +0000 (UTC)
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org
 (localhost.localdomain [127.0.0.1])
 by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id
 97028C43142; Sat,  6 Aug 2022 18:19:40 +0000 (UTC)
From: pr-tracker-bot@kernel.org
In-Reply-To: <Yu1rOopN++GWylUi@redhat.com>
References: <YugiaQ1TO+vT1FQ5@redhat.com> <Yu1rOopN++GWylUi@redhat.com>
X-PR-Tracked-List-Id: device-mapper development <dm-devel.redhat.com>
X-PR-Tracked-Message-Id: <Yu1rOopN++GWylUi@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
 tags/for-6.0/dm-changes-2
X-PR-Tracked-Commit-Id: 12907efde6ad984f2d76cc1a7dbaae132384d8a5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 20cf903a0c407cef19300e5c85a03c82593bde36
Message-Id: <165980998061.27284.17220964359709259877.pr-tracker-bot@kernel.org>
Date: Sat, 06 Aug 2022 18:19:40 +0000
To: Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [git pull] Additional device mapper changes for 6.0
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
Cc: linux-block@vger.kernel.org, Nathan Huckleberry <nhuck@google.com>,
 Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 Sami Tolvanen <samitolvanen@google.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The pull request you sent on Fri, 5 Aug 2022 15:10:50 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.0/dm-changes-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/20cf903a0c407cef19300e5c85a03c82593bde36

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

