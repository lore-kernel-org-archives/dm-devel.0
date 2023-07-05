Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 006B7EB64DA
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971638;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SfdTdaWG9kLVnEZtQ9v/EKS61z36tgxAysGiFg1pv7o=;
	b=HHE+I5kfIEjobN9YW9iXBTqZYEPA+VOUCvTD+MCNApyflcejJS3Cu6ZfEKoa6RSvRJ4h2d
	LKKq0tTRGaQPJrYkb8CrWSYkT0ivH59wxeYc4dGHLV8qmKpa8xVdgwMv3cT34dPBZxEqQl
	zqjVJS8Ny62LrUoyIIarwVp/oBbVZaw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-456-IS3NzkICP1SVyNnje0yVeA-1; Mon, 10 Jul 2023 02:47:15 -0400
X-MC-Unique: IS3NzkICP1SVyNnje0yVeA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 107C03815F77;
	Mon, 10 Jul 2023 06:47:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EDAD44087C79;
	Mon, 10 Jul 2023 06:47:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8DF3F19451EC;
	Mon, 10 Jul 2023 06:46:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 480C31946588
 for <dm-devel@listman.corp.redhat.com>; Wed,  5 Jul 2023 16:41:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2BC811121315; Wed,  5 Jul 2023 16:41:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2465D1121314
 for <dm-devel@redhat.com>; Wed,  5 Jul 2023 16:41:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0569038294A8
 for <dm-devel@redhat.com>; Wed,  5 Jul 2023 16:41:39 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-EwBjSpWrMZyBY0VxxNJ60g-1; Wed, 05 Jul 2023 12:41:37 -0400
X-MC-Unique: EwBjSpWrMZyBY0VxxNJ60g-1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="362258257"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; d="scan'208";a="362258257"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
 by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 05 Jul 2023 09:40:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="893241761"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; d="scan'208";a="893241761"
Received: from silpixa00400314.ir.intel.com (HELO
 silpixa00400314.ger.corp.intel.com) ([10.237.222.216])
 by orsmga005.jf.intel.com with ESMTP; 05 Jul 2023 09:40:28 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au,
	agk@redhat.com,
	snitzer@kernel.org
Date: Wed,  5 Jul 2023 17:40:07 +0100
Message-Id: <20230705164009.58351-2-giovanni.cabiddu@intel.com>
In-Reply-To: <20230705164009.58351-1-giovanni.cabiddu@intel.com>
References: <20230705164009.58351-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: [dm-devel] [PATCH 1/3] dm integrity: do not filter algos with
 CRYPTO_ALG_ALLOCATES_MEMORY
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
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Fiona Trahe <fiona.trahe@intel.com>, horia.geanta@nxp.com,
 pankaj.gupta@nxp.com, gaurav.jain@nxp.com, heinzm@redhat.com,
 qat-linux@intel.com, linux-kernel@vger.kernel.org, ebiggers@kernel.org,
 iuliana.prodan@nxp.com, dm-devel@redhat.com, meenakshi.aggarwal@nxp.com,
 linux-crypto@vger.kernel.org, davem@davemloft.net, V.Sethi@nxp.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The flag CRYPTO_ALG_ALLOCATES_MEMORY indicates that an algorithm might
allocate memory in the datapath and therefore sleep.
Dm-integrity is filtering out implementations of skcipher algorithms
that have this flag set. However, in the same function it does
allocations with GFP_KERNEL.
As dm-integrity is re-entrant and capable of handling sleeps that could
occur during allocations with GFP_KERNEL, then it is also capable of
using skcipher algorithm implementations that have
CRYPTO_ALG_ALLOCATES_MEMORY set.

Remove the filtering of skcipher implementations with the flag
CRYPTO_ALG_ALLOCATES_MEMORY set.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Link: https://lore.kernel.org/linux-crypto/ZILvtASXQKLG43y9@gondor.apana.org.au/
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/md/dm-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 31838b13ea54..a1013eff01b4 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3785,7 +3785,7 @@ static int create_journal(struct dm_integrity_c *ic, char **error)
 		struct journal_completion comp;
 
 		comp.ic = ic;
-		ic->journal_crypt = crypto_alloc_skcipher(ic->journal_crypt_alg.alg_string, 0, CRYPTO_ALG_ALLOCATES_MEMORY);
+		ic->journal_crypt = crypto_alloc_skcipher(ic->journal_crypt_alg.alg_string, 0, 0);
 		if (IS_ERR(ic->journal_crypt)) {
 			*error = "Invalid journal cipher";
 			r = PTR_ERR(ic->journal_crypt);
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

