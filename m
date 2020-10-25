Return-Path: <SRS0=ck8z=EA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A157C388F7
	for <dm-devel@archiver.kernel.org>; Sun, 25 Oct 2020 21:03:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 08D7E208B3
	for <dm-devel@archiver.kernel.org>; Sun, 25 Oct 2020 21:03:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08D7E208B3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-ZTt0mdrvMPGKwJle0cXLdA-1; Sun, 25 Oct 2020 17:03:02 -0400
X-MC-Unique: ZTt0mdrvMPGKwJle0cXLdA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 048EF1006C80;
	Sun, 25 Oct 2020 21:02:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 96F625D9CD;
	Sun, 25 Oct 2020 21:02:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2CDC2180B657;
	Sun, 25 Oct 2020 21:02:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09PL2lIQ012741 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 25 Oct 2020 17:02:48 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BF6692157F45; Sun, 25 Oct 2020 21:02:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BA4F02157F24
	for <dm-devel@redhat.com>; Sun, 25 Oct 2020 21:02:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C062280018B
	for <dm-devel@redhat.com>; Sun, 25 Oct 2020 21:02:44 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-452-B6yISfA7PTyQV0huE5AsvQ-1;
	Sun, 25 Oct 2020 17:02:41 -0400
X-MC-Unique: B6yISfA7PTyQV0huE5AsvQ-1
IronPort-SDR: SoKe0ojavJSmUBFSPg/CDfXB8Xzgz+eXhqhnszPmKhxO6HcG9+QYgGBFFnfCLOclwQF4LCcKh9
	6kCcisq33ZdA==
X-IronPort-AV: E=McAfee;i="6000,8403,9785"; a="185571790"
X-IronPort-AV: E=Sophos;i="5.77,417,1596524400"; d="scan'208";a="185571790"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
	by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	25 Oct 2020 14:02:33 -0700
IronPort-SDR: RN0XNxRcJyf0TLUz/a8ep2P0eTMVfKnRodcX9kVmwaEEVydHPg6tj23MZi3fhkPTwaIDL3ISj2
	2cDJNSnHtreA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,417,1596524400"; d="scan'208";a="303356462"
Received: from lkp-server01.sh.intel.com (HELO cda15bb6d7bd) ([10.239.97.150])
	by fmsmga007.fm.intel.com with ESMTP; 25 Oct 2020 14:02:31 -0700
Received: from kbuild by cda15bb6d7bd with local (Exim 4.92)
	(envelope-from <lkp@intel.com>)
	id 1kWn9r-000135-4O; Sun, 25 Oct 2020 21:02:31 +0000
Date: Mon, 26 Oct 2020 05:02:26 +0800
From: kernel test robot <lkp@intel.com>
To: Satya Tangirala <satyat@google.com>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com
Message-ID: <20201025210226.GA56371@c4e258c4beaa>
References: <20201015214632.41951-4-satyat@google.com>
MIME-Version: 1.0
In-Reply-To: <20201015214632.41951-4-satyat@google.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, kbuild-all@lists.01.org,
	Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>,
	Satya Tangirala <satyat@google.com>, Alasdair Kergon <agk@redhat.com>
Subject: [dm-devel] [PATCH] dm: fix err_cast.cocci warnings
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: kernel test robot <lkp@intel.com>

drivers/md/dm.c:2204:12-19: WARNING: ERR_CAST can be used with ksm


 Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...))

Generated by: scripts/coccinelle/api/err_cast.cocci

CC: Satya Tangirala <satyat@google.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---

url:    https://github.com/0day-ci/linux/commits/Satya-Tangirala/add-support-for-inline-encryption-to-device-mapper/20201016-054900
base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next

 dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2201,7 +2201,7 @@ static struct dm_table *__bind(struct ma
 
 	ksm = dm_init_inline_encryption(md, t);
 	if (IS_ERR(ksm)) {
-		old_map = ERR_PTR(PTR_ERR(ksm));
+		old_map = ERR_CAST(ksm);
 		goto out;
 	}
 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

