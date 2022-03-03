Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBA91C433FE
	for <dm-devel@archiver.kernel.org>; Fri,  4 Mar 2022 06:19:16 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-fVT8GpaaPP-I8Tlc4WJ3EQ-1; Fri, 04 Mar 2022 01:19:12 -0500
X-MC-Unique: fVT8GpaaPP-I8Tlc4WJ3EQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87FDF805EE5;
	Fri,  4 Mar 2022 06:19:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EDFCF5DBA9;
	Fri,  4 Mar 2022 06:19:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2FC431809C98;
	Fri,  4 Mar 2022 06:19:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 223LP3BW029743 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Mar 2022 16:25:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 84D3C20268FE; Thu,  3 Mar 2022 21:25:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F04F2026D65
	for <dm-devel@redhat.com>; Thu,  3 Mar 2022 21:24:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F8508002BF
	for <dm-devel@redhat.com>; Thu,  3 Mar 2022 21:24:54 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-329-5ZPmWEFZPxKpjqpwN9xpBg-1; Thu, 03 Mar 2022 16:24:52 -0500
X-MC-Unique: 5ZPmWEFZPxKpjqpwN9xpBg-1
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="251393912"
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; d="scan'208";a="251393912"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
	by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	03 Mar 2022 13:24:51 -0800
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; d="scan'208";a="536016037"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314)
	([10.237.222.76]) by orsmga007-auth.jf.intel.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 13:24:48 -0800
Date: Thu, 3 Mar 2022 21:24:42 +0000
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Eric Biggers <ebiggers@kernel.org>
Message-ID: <YiEyGoHacN80FcOL@silpixa00400314>
References: <CAHk-=wi+xewHz=BH7LcZAxrj9JXi66s9rp+kBqRchVG3a-b2BA@mail.gmail.com>
	<Yh2c4Vwu61s51d6N@gondor.apana.org.au> <Yh9G7FyCLtsm2mFA@kroah.com>
	<Yh9ZvLHuztwQCu0d@silpixa00400314> <Yh+FpKuoyj3G16lK@kroah.com>
	<Yh/vY4t3xnuoCW3Q@gondor.apana.org.au>
	<Yh/yr6oB5yeOUErL@silpixa00400314>
	<Yh/znCnZzWaL49+o@gondor.apana.org.au>
	<YiDHT31ujlGdQEe/@silpixa00400314> <YiEVPc2cd38AnLZB@gmail.com>
MIME-Version: 1.0
In-Reply-To: <YiEVPc2cd38AnLZB@gmail.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
	Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 04 Mar 2022 01:18:24 -0500
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Greg KH <gregkh@linuxfoundation.org>,
	Dave Chinner <david@fromorbit.com>, qat-linux@intel.com,
	Linux-Kernal <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Kyle Sanderson <kyle.leet@gmail.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [dm-devel] Intel QAT on A2SDi-8C-HLN4F causes massive data
 corruption with dm-crypt + xfs
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

On Thu, Mar 03, 2022 at 07:21:33PM +0000, Eric Biggers wrote:
> If these algorithms have critical bugs, which it appears they do, then IMO it
> would be better to disable them (either stop registering them, or disable the
> whole driver) than to leave them available with low cra_priority.  Low
> cra_priority doesn't guarantee that they aren't used.
Thanks for your feedback Eric.

Here is a patch that disables the registration of the algorithms in the
QAT driver by setting, a config time, the number of HW queues (aka
instances) to zero.

---8<---
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - disable registration of algorithms
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland

The implementations of aead and skcipher in the QAT driver do not
support properly requests with the CRYPTO_TFM_REQ_MAY_BACKLOG flag set.
If the HW queue is full, the driver returns -EBUSY but does not enqueue
the request.
This can result in applications like dm-crypt waiting indefinitely for a
completion of a request that was never submitted to the hardware.

To avoid this problem, disable the registration of all skcipher and aead
implementations in the QAT driver by setting the number of crypto
instances to 0 at configuration time.

This patch deviates from the original upstream solution, that prevents
dm-crypt to use drivers registered with the flag
CRYPTO_ALG_ALLOCATES_MEMORY, since a backport of that set to stable
kernels may have a too wide effect.

commit 7bcb2c99f8ed032cfb3f5596b4dccac6b1f501df upstream
commit 2eb27c11937ee9984c04b75d213a737291c5f58c upstream
commit fbb6cda44190d72aa5199d728797aabc6d2ed816 upstream
commit b8aa7dc5c7535f9abfca4bceb0ade9ee10cf5f54 upstream
commit cd74693870fb748d812867ba49af733d689a3604 upstream

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_crypto.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 3852d31ce0a4..611d214d5198 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -159,9 +159,7 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
  */
 int qat_crypto_dev_config(struct adf_accel_dev *accel_dev)
 {
-	int cpus = num_online_cpus();
-	int banks = GET_MAX_BANKS(accel_dev);
-	int instances = min(cpus, banks);
+	int instances = 0;
 	char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
 	int i;
 	unsigned long val;

base-commit: 866ae42cf4788c8b18de6bda0a522362702861d7
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

