Return-Path: <SRS0=f+1/=ER=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE0FCC4742C
	for <dm-devel@archiver.kernel.org>; Wed, 11 Nov 2020 18:40:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EC72C205CB
	for <dm-devel@archiver.kernel.org>; Wed, 11 Nov 2020 18:40:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC72C205CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-_-NLzKDSO1OHM6VsoS_uHQ-1; Wed, 11 Nov 2020 13:40:33 -0500
X-MC-Unique: _-NLzKDSO1OHM6VsoS_uHQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 697D0801FC4;
	Wed, 11 Nov 2020 18:40:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 44A195B4A8;
	Wed, 11 Nov 2020 18:40:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7FEA244A7B;
	Wed, 11 Nov 2020 18:40:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ABCtfJc001206 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 11 Nov 2020 07:55:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 64367C54B4; Wed, 11 Nov 2020 12:55:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5EF35C6128
	for <dm-devel@redhat.com>; Wed, 11 Nov 2020 12:55:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 229D7811E79
	for <dm-devel@redhat.com>; Wed, 11 Nov 2020 12:55:39 +0000 (UTC)
Received: from mx4.veeam.com (mx4.veeam.com [104.41.138.86]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-39-gHLt0eQnMlOItXlPr2zGeA-1;
	Wed, 11 Nov 2020 07:55:34 -0500
X-MC-Unique: gHLt0eQnMlOItXlPr2zGeA-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx4.veeam.com (Postfix) with ESMTPS id AFC0D8A762;
	Wed, 11 Nov 2020 15:55:33 +0300 (MSK)
Received: from prgdevlinuxpatch01.amust.local (172.24.14.5) by
	prgmbx01.amust.local (172.24.0.171) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.721.2; Wed, 11 Nov 2020 13:55:32 +0100
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>,
	<linux-kernel@vger.kernel.org>
Date: Wed, 11 Nov 2020 15:55:45 +0300
Message-ID: <1605099346-3199-1-git-send-email-sergei.shtepa@veeam.com>
MIME-Version: 1.0
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx01.amust.local (172.24.0.171) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29C604D26A617667
X-Veeam-MMEX: True
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 11 Nov 2020 13:39:49 -0500
Cc: Sergei Shtepa <sergei.shtepa@veeam.com>
Subject: [dm-devel] [PATCH 0/1] Bug with RCU locking in dm_blk_report_zones()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The dm_get_live_table() function makes RCU read lock and
dm_put_live_table() should call even when dm_table map was not found.

Sergei Shtepa (1):
  Fix bug with RCU locking in dm_blk_report_zones().

 drivers/md/dm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

-- 
2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

