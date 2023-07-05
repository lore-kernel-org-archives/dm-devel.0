Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17B42EB64D9
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971682;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wetnkyCxhusiEbrqDQEXP+mNR/xuEOxVAKft4uS51JA=;
	b=eMXv048BiJuUdED8gzZ9sIRNh5jm9w37gLN103EjdCEop74P95/wFrQqT5BlU9TV2nsdjm
	L1KQvwqkjxAD8FBjaraZOLGJwjo9B47H5r8P+ylvqjgH2kQnqo4VZl9fA8PgmPmV4sqL+J
	OfPfLcFMTACY1iYcqArBf/9gNI1RlQQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-39-ONvuKrfRPuOspR0b1Ayfiw-1; Mon, 10 Jul 2023 02:47:10 -0400
X-MC-Unique: ONvuKrfRPuOspR0b1Ayfiw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F27B87323F;
	Mon, 10 Jul 2023 06:46:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 78F0D4CD0D5;
	Mon, 10 Jul 2023 06:46:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 564AF1949749;
	Mon, 10 Jul 2023 06:46:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 71F3B1946588
 for <dm-devel@listman.corp.redhat.com>; Wed,  5 Jul 2023 16:41:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 52F004CD0C8; Wed,  5 Jul 2023 16:41:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B3FD492C13
 for <dm-devel@redhat.com>; Wed,  5 Jul 2023 16:41:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D64F88D542
 for <dm-devel@redhat.com>; Wed,  5 Jul 2023 16:41:41 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-ROTbjrT3OYqzxlNIcUOWpg-1; Wed, 05 Jul 2023 12:41:39 -0400
X-MC-Unique: ROTbjrT3OYqzxlNIcUOWpg-1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="362258285"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; d="scan'208";a="362258285"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
 by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 05 Jul 2023 09:40:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="893241766"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; d="scan'208";a="893241766"
Received: from silpixa00400314.ir.intel.com (HELO
 silpixa00400314.ger.corp.intel.com) ([10.237.222.216])
 by orsmga005.jf.intel.com with ESMTP; 05 Jul 2023 09:40:32 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au,
	agk@redhat.com,
	snitzer@kernel.org
Date: Wed,  5 Jul 2023 17:40:08 +0100
Message-Id: <20230705164009.58351-3-giovanni.cabiddu@intel.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: [dm-devel] [PATCH 2/3] crypto: api - adjust meaning of
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
 Eric Biggers <ebiggers@google.com>, qat-linux@intel.com,
 linux-kernel@vger.kernel.org, ebiggers@kernel.org, iuliana.prodan@nxp.com,
 dm-devel@redhat.com, meenakshi.aggarwal@nxp.com, linux-crypto@vger.kernel.org,
 davem@davemloft.net, V.Sethi@nxp.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The CRYPTO_ALG_ALLOCATES_MEMORY flag doesn't allow to distinguish
between implementations which don't allocate memory for scatterlists
with 4 or less entries (the typical case for dm-crypt) and those that
do.
The flag's meaning is adjusted based on the ML discussion below.

This patch removes the need to set the flag if the implementation can
handle scatterlists up to 4 entries without allocating memory.
The documentation is updated accordingly, with an extra clarification
regarding sleeping.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Suggested-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/linux-crypto/20200722072932.GA27544@gondor.apana.org.au/
Link: https://lore.kernel.org/linux-crypto/20230523165503.GA864814@google.com/
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 include/linux/crypto.h | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 31f6fee0c36c..15884790a3d0 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -87,8 +87,13 @@
 
 /*
  * The algorithm may allocate memory during request processing, i.e. during
- * encryption, decryption, or hashing.  Users can request an algorithm with this
- * flag unset if they can't handle memory allocation failures.
+ * encryption, decryption, or hashing. Algorithms that do not set this flag will
+ * guarantee that memory is not allocated during request processing, except in
+ * the avoidable exception cases described below.
+ *
+ * Users can request an algorithm with this flag unset if they can't handle
+ * memory allocation failures or sleeping during request processing. They should
+ * also follow the constraints below.
  *
  * This flag is currently only implemented for algorithms of type "skcipher",
  * "aead", "ahash", "shash", and "cipher".  Algorithms of other types might not
@@ -102,6 +107,9 @@
  *	- If the data were to be divided into chunks of size
  *	  crypto_skcipher_walksize() (with any remainder going at the end), no
  *	  chunk can cross a page boundary or a scatterlist element boundary.
+ *	- The input and output scatterlists must have no more than 4 entries.
+ *	  If the scatterlists contain more than 4 entries, the algorithm may
+ *	  allocate memory.
  *    aead:
  *	- The IV buffer and all scatterlist elements must be aligned to the
  *	  algorithm's alignmask.
@@ -110,10 +118,16 @@
  *	- If the plaintext/ciphertext were to be divided into chunks of size
  *	  crypto_aead_walksize() (with the remainder going at the end), no chunk
  *	  can cross a page boundary or a scatterlist element boundary.
+ *	- The input and output scatterlists must have no more than 4 entries.
+ *	  If the scatterlists contain more than 4 entries, the algorithm may
+ *	  allocate memory.
  *    ahash:
  *	- The result buffer must be aligned to the algorithm's alignmask.
  *	- crypto_ahash_finup() must not be used unless the algorithm implements
  *	  ->finup() natively.
+ *	- The input and output scatterlists must have no more than 4 entries.
+ *	  If the scatterlists contain more than 4 entries, the algorithm may
+ *	  allocate memory.
  */
 #define CRYPTO_ALG_ALLOCATES_MEMORY	0x00010000
 
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

