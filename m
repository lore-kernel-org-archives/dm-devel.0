Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E42F2C64EC4
	for <dm-devel@archiver.kernel.org>; Mon,  6 Mar 2023 19:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678129450;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cpuTtdKFEOYTSe9KCS8waQgoLJUBYca8sJ+aBF5f18E=;
	b=MDdJI/pswdzpjsGbP/88ig3wzINg9KlvetpQXlEQYlYzFWi2bxyz35X/UQ+vJtth/Y8Gbf
	zQTOzhJUHmtgDUO8pAWtP7I/tkYLkNOgdpev5EO+120mQO3/0jFJHjjCLzbyYDqOfRkyyq
	sYwTA9zgC/dJ2Wvq1JvKMw7Yvv5Fi84=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-ego3KC7TNg-qq8Gh7zrEUQ-1; Mon, 06 Mar 2023 14:04:07 -0500
X-MC-Unique: ego3KC7TNg-qq8Gh7zrEUQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 834CE100F916;
	Mon,  6 Mar 2023 19:04:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C29E72166B26;
	Mon,  6 Mar 2023 19:04:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 82395194658C;
	Mon,  6 Mar 2023 19:03:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A0C421946589
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Mar 2023 19:03:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7C69C112132E; Mon,  6 Mar 2023 19:03:52 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 688A51121314;
 Mon,  6 Mar 2023 19:03:52 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 326J3qq2005608; Mon, 6 Mar 2023 14:03:52 -0500
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 326J3qEe005604; Mon, 6 Mar 2023 14:03:52 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 6 Mar 2023 14:03:52 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ee7a7a6a-ef46-f487-e78d-a828a4042393@acm.org>
Message-ID: <alpine.LRH.2.21.2303061402020.3482@file01.intranet.prod.int.rdu2.redhat.com>
References: <20230223031947.3717433-1-yangerkun@huaweicloud.com>
 <b7020147-2382-71f6-5237-8501562f8011@acm.org>
 <e69ec125-3636-ab20-ce63-f4b89ac55ffb@huaweicloud.com>
 <Y/zueUWERryoIGA8@redhat.com> <Y/zwVCNDrdAbzC7a@redhat.com>
 <Y/zxI4wK8trtuJgV@redhat.com>
 <3e31584c-b0f3-fc9a-3657-935fc51db74e@huaweicloud.com>
 <alpine.LRH.2.21.2303061240200.31427@file01.intranet.prod.int.rdu2.redhat.com>
 <ee7a7a6a-ef46-f487-e78d-a828a4042393@acm.org>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] dm-crypt: fix softlockup in dmcrypt_write
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
Cc: yangerkun@huawei.com, agk@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, yangerkun <yangerkun@huaweicloud.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Mon, 6 Mar 2023, Bart Van Assche wrote:

> On 3/6/23 10:02, Mikulas Patocka wrote:
> > On Tue, 28 Feb 2023, yangerkun wrote:
> > > It's ok to fix the softlockup, but for async write encrypt,
> > > kcryptd_crypt_write_io_submit will add bio to write_tree, and once we
> > > call cond_resched before every kcryptd_io_write, the write performance
> > > may be poor while we meet a high cpu usage scene.
> > 
> > Hi
> > 
> > To fix this problem, find the PID of the process "dmcrypt_write" and
> > change its priority to -20, for example "renice -n -20 -p 34748".
> > 
> > This is the proper way how to fix it; locking up the process for one
> > second is not.
> > 
> > We used to have high-priority workqueues by default, but it caused audio
> > playback skipping, so we had to revert it - see
> > f612b2132db529feac4f965f28a1b9258ea7c22b.
> > 
> > Perhaps we should add an option to have high-priority kernel threads?
> 
> Would calling cond_resched() every n iterations instead of every iteration
> help? From mm/swapfile.c:
> 
> 			if (unlikely(--latency_ration < 0)) {
> 				cond_resched();
> 				latency_ration = LATENCY_LIMIT;
> 			}
> 
> Thanks,
> 
> Bart.

I think that if this helps, it is really a bug in the scheduler... It 
shouldn't switch tasks so often.

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

