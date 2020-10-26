Return-Path: <SRS0=TXmu=EC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E660C55179
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 08:43:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9FBE7207DE
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 08:43:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9FBE7207DE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=benyossef.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-5tp3j30mM0eJwr9OCcPsNA-1; Tue, 27 Oct 2020 04:43:22 -0400
X-MC-Unique: 5tp3j30mM0eJwr9OCcPsNA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 560C4107AFC6;
	Tue, 27 Oct 2020 08:43:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EF5A5C1BB;
	Tue, 27 Oct 2020 08:43:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 00ADF1832FBA;
	Tue, 27 Oct 2020 08:43:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09QDCJIE030597 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Oct 2020 09:12:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 41B6C2166B27; Mon, 26 Oct 2020 13:12:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BA262166B44
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 13:12:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7A6A185A7A2
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 13:12:14 +0000 (UTC)
Received: from foss.arm.com (foss.arm.com [217.140.110.172]) by
	relay.mimecast.com with ESMTP id us-mta-407-pJMYp5mgMNuVoMLYPFW6IQ-1;
	Mon, 26 Oct 2020 09:12:10 -0400
X-MC-Unique: pJMYp5mgMNuVoMLYPFW6IQ-1
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 57E461477;
	Mon, 26 Oct 2020 06:05:03 -0700 (PDT)
Received: from e110176-lin.arm.com (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD6DE3F68F;
	Mon, 26 Oct 2020 06:05:00 -0700 (PDT)
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, Song Liu <song@kernel.org>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com
Date: Mon, 26 Oct 2020 15:04:43 +0200
Message-Id: <20201026130450.6947-1-gilad@benyossef.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09QDCJIE030597
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 27 Oct 2020 04:42:30 -0400
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
Subject: [dm-devel] [PATCH 0/4] crypto: switch to crypto API for EBOIV
	generation
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This series creates an EBOIV template that produces a skcipher
transform which passes through all operations to the skcipher, while
using the same skcipher and key to encrypt the input IV, which is
assumed to be a sector offset, although this is not enforced.

This matches dm-crypt use of EBOIV to provide BitLocker support,
and so it is proposed as a replacement in patch #3.

Replacing the dm-crypt specific EBOIV implementation to a Crypto
API based one allows us to save a memory allocation per
each request, as well as opening the way for use of compatible
alternative transform providers, one of which, based on the
Arm TrustZone CryptoCell hardware, is proposed as patch #4.

Future potential work to allow encapsulating the handling of
multiple subsequent blocks by the Crypto API may also
benefit from this work.

The code has been tested on both x86_64 virtual machine
with the dm-crypt test suite and on an arm 32 bit board
with the CryptoCell hardware.

Since no offical source for eboiv test vectors is known,
the test vectors supplied as patch #2 are derived from
sectors which are part of the dm-crypt test suite.

Gilad Ben-Yossef (4):
  crypto: add eboiv as a crypto API template
  crypto: add eboiv(cbc(aes)) test vectors
  dm crypt: switch to EBOIV crypto API template
  crypto: ccree: re-introduce ccree eboiv support

 crypto/Kconfig                       |  21 ++
 crypto/Makefile                      |   1 +
 crypto/eboiv.c                       | 295 +++++++++++++++++++++++++++
 crypto/tcrypt.c                      |   9 +
 crypto/testmgr.c                     |   6 +
 crypto/testmgr.h                     | 279 +++++++++++++++++++++++++
 drivers/crypto/ccree/cc_cipher.c     | 130 ++++++++----
 drivers/crypto/ccree/cc_crypto_ctx.h |   1 +
 drivers/md/Kconfig                   |   1 +
 drivers/md/dm-crypt.c                |  61 ++----
 10 files changed, 725 insertions(+), 79 deletions(-)
 create mode 100644 crypto/eboiv.c

-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

