Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06656C0015E
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971622;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hISBtFcLpkV7fCiwDCRHxMhsTAHaMr5vJyiKgCYMkWI=;
	b=GXqJsuYH+2PbWgaGZ4IPccT6DFPKoyR0LpN16PvNDuHMQJ9HGaAolCDss9kxC8EbDnELGP
	EBheC5Ys69qtlHomVzQsyzcKJdOfjztSm7Cu+HrtLXNHff7fHeynwbikYuR9NnDjWkO+jg
	oKKAklAZ46JsYmf4Jn0pBeyKQBJrfPc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-A7oll9viMTej47cVt4mcVw-1; Mon, 10 Jul 2023 02:46:58 -0400
X-MC-Unique: A7oll9viMTej47cVt4mcVw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 223CC3C11A0F;
	Mon, 10 Jul 2023 06:46:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0E107F5CED;
	Mon, 10 Jul 2023 06:46:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2664119452D1;
	Mon, 10 Jul 2023 06:46:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1F1E31946588
 for <dm-devel@listman.corp.redhat.com>; Wed,  5 Jul 2023 16:41:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0019EC478DE; Wed,  5 Jul 2023 16:41:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ECC06C478DD
 for <dm-devel@redhat.com>; Wed,  5 Jul 2023 16:41:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CDED1800B35
 for <dm-devel@redhat.com>; Wed,  5 Jul 2023 16:41:39 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-s_hUJOSQO7axERtTaVPlRA-1; Wed, 05 Jul 2023 12:41:36 -0400
X-MC-Unique: s_hUJOSQO7axERtTaVPlRA-1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="362258233"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; d="scan'208";a="362258233"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
 by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 05 Jul 2023 09:40:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="893241756"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; d="scan'208";a="893241756"
Received: from silpixa00400314.ir.intel.com (HELO
 silpixa00400314.ger.corp.intel.com) ([10.237.222.216])
 by orsmga005.jf.intel.com with ESMTP; 05 Jul 2023 09:40:24 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au,
	agk@redhat.com,
	snitzer@kernel.org
Date: Wed,  5 Jul 2023 17:40:06 +0100
Message-Id: <20230705164009.58351-1-giovanni.cabiddu@intel.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: [dm-devel] [PATCH 0/3] crypto: adjust meaning of
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
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>, horia.geanta@nxp.com,
 pankaj.gupta@nxp.com, gaurav.jain@nxp.com, heinzm@redhat.com,
 qat-linux@intel.com, linux-kernel@vger.kernel.org, ebiggers@kernel.org,
 iuliana.prodan@nxp.com, dm-devel@redhat.com, meenakshi.aggarwal@nxp.com,
 linux-crypto@vger.kernel.org, davem@davemloft.net, V.Sethi@nxp.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Commit fbb6cda44190 introduced the flag CRYPTO_ALG_ALLOCATES_MEMORY.
This allows to mark algorithms that allocate memory during the datapath
so they are not used for disk encryption.
Following that, cd74693870fb limited dm-crypt to use only
implementations that don't set that flag.

After discussions in the crypto mailing list [1][2][3] about how we
could re-enable algorithms to be used by dm-crypt, we came to the
conclusion that we can change slightly the meaning of the flag
!CRYPTO_ALG_ALLOCATES_MEMORY. If an algorithm does not allocate
memory for requests with a scatterlist of 4 or less entries
(the typical case for dm-crypt), then it can avoid marking the
implementation with the flag CRYPTO_ALG_ALLOCATES_MEMORY.

This set adjusts the meaning of CRYPTO_ALG_ALLOCATES_MEMORY in the
documentation, removes the filtering for algorithms that do not
allocate memory in dm-integrity and removes the
CRYPTO_ALG_ALLOCATES_MEMORY from the algorithms registered in the QAT
driver as this is not allocating memory in the datapath for requests
with 4 or less entries in the source and destination scatterlists.

[1] https://lore.kernel.org/linux-crypto/20200722072932.GA27544@gondor.apana.org.au/
[2] https://lore.kernel.org/linux-crypto/20230523165503.GA864814@google.com/
[3] https://lore.kernel.org/linux-crypto/Ysw9E2Az2oK4jfCf@lucas-Virtual-Machine/

Giovanni Cabiddu (3):
  dm integrity: do not filter algos with CRYPTO_ALG_ALLOCATES_MEMORY
  crypto: api - adjust meaning of CRYPTO_ALG_ALLOCATES_MEMORY
  crypto: qat - remove CRYPTO_ALG_ALLOCATES_MEMORY flag

 drivers/crypto/intel/qat/qat_common/qat_algs.c | 13 ++++++-------
 .../intel/qat/qat_common/qat_comp_algs.c       |  2 +-
 drivers/md/dm-integrity.c                      |  2 +-
 include/linux/crypto.h                         | 18 ++++++++++++++++--
 4 files changed, 24 insertions(+), 11 deletions(-)

-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

