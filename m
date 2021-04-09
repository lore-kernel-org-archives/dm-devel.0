Return-Path: <SRS0=WBCP=JG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6956C433ED
	for <dm-devel@archiver.kernel.org>; Fri,  9 Apr 2021 17:04:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6E316610F7
	for <dm-devel@archiver.kernel.org>; Fri,  9 Apr 2021 17:04:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E316610F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-xZZSqkm1MxiU3LGA7TkP_g-1; Fri, 09 Apr 2021 13:04:27 -0400
X-MC-Unique: xZZSqkm1MxiU3LGA7TkP_g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3EE12802B56;
	Fri,  9 Apr 2021 17:04:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 86A5B18A50;
	Fri,  9 Apr 2021 17:04:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 02DF755345;
	Fri,  9 Apr 2021 17:04:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 139H4HTY008020 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 9 Apr 2021 13:04:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6848521C861B; Fri,  9 Apr 2021 17:04:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 62F722102FB5
	for <dm-devel@redhat.com>; Fri,  9 Apr 2021 17:04:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDC7780A0B0
	for <dm-devel@redhat.com>; Fri,  9 Apr 2021 17:04:13 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-5-d18qqRd2NGekMbXOSNV9IQ-1; Fri, 09 Apr 2021 13:04:11 -0400
X-MC-Unique: d18qqRd2NGekMbXOSNV9IQ-1
IronPort-SDR: 46sm19iLAvQ5QnRJ7iOX9zvke474PLSqQElxTwRUpaZZ0W2bNEe1ZwKK5xu5lNeOr2YhnWFQtB
	6G2VjkxHe6IA==
X-IronPort-AV: E=McAfee;i="6000,8403,9949"; a="193916955"
X-IronPort-AV: E=Sophos;i="5.82,209,1613462400"; d="scan'208";a="193916955"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
	by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	09 Apr 2021 10:04:09 -0700
IronPort-SDR: dnbxdqsiG77/wixzH5lWqnkRiWMQI07zEGBf32N5e8CWUR4MoeLD8bYXSM7kIDDrsUtxceCl4G
	leaS+eu3V8HA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,209,1613462400"; d="scan'208";a="459297461"
Received: from lkp-server01.sh.intel.com (HELO 69d8fcc516b7) ([10.239.97.150])
	by orsmga001.jf.intel.com with ESMTP; 09 Apr 2021 10:04:05 -0700
Received: from kbuild by 69d8fcc516b7 with local (Exim 4.92)
	(envelope-from <lkp@intel.com>)
	id 1lUuY9-000H6a-5K; Fri, 09 Apr 2021 17:04:05 +0000
Date: Sat, 10 Apr 2021 01:03:41 +0800
From: kernel test robot <lkp@intel.com>
To: Sergei Shtepa <sergei.shtepa@veeam.com>,
	Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, 
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, 
	dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20210409170341.GA6890@00727235a09e>
References: <1617968884-15149-4-git-send-email-sergei.shtepa@veeam.com>
MIME-Version: 1.0
In-Reply-To: <1617968884-15149-4-git-send-email-sergei.shtepa@veeam.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
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
Cc: kbuild-all@lists.01.org
Subject: [dm-devel] [RFC PATCH] __dm_attach_interposer() can be static
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 dm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 04142454c4eed..2a584c2103f3a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2679,7 +2679,7 @@ static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
 	return r;
 }
 
-int __dm_attach_interposer(struct mapped_device *md)
+static int __dm_attach_interposer(struct mapped_device *md)
 {
 	int r;
 	struct dm_table *map;
@@ -2721,7 +2721,7 @@ int __dm_attach_interposer(struct mapped_device *md)
 	return r;
 }
 
-int __dm_detach_interposer(struct mapped_device *md)
+static int __dm_detach_interposer(struct mapped_device *md)
 {
 	struct dm_table *map = NULL;
 	struct block_device *original_bdev;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

