Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43D32E06F0;
	Wed, 25 Jun 2025 09:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750844134; cv=none; b=IysAB2UaJdxeeQptokcf0BwimBZsCIYqm7xYLHKdiXYx3uzMs6DuDQXy4JPgZrwoHy4U3GBLnFCXJ+Fc8OTAtYw0ux9JaOl4oZnAiyzg/MQ4fnj2gA5ynRBQQNOF2+WhOJrPQrGhXRbuJrBP2LmiGtu8rJYVCM0zItq/3cAIFkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750844134; c=relaxed/simple;
	bh=EnwIyLLdwDFUIEjsmBgNSKCi6mztyp9WpsKk62Mxfjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtjCx8Wzsvc8MS0/bs1kEN3D1JcUMm1DyGOpGuEoNXZxxELT/5nihvrTAFnE9vxLLecb6JO7MT2NN95j3fExMwf+BDRX3nWkUS8u1JjebBu+ysUWKelh1T59dGu1rovnnN+bgzaONg9Q1BU+Xwvwa2YRNAtpJSPRzPrnj7igh/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZKvrrUM+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZKvrrUM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF781C4CEEE;
	Wed, 25 Jun 2025 09:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750844133;
	bh=EnwIyLLdwDFUIEjsmBgNSKCi6mztyp9WpsKk62Mxfjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZKvrrUM+ze4gS0vHGeuwSb5eNS6gbjnRmEK1KEAaTSqm8XZllJw7oEWfZsiBJXZ+c
	 0T9vKecKdjBHUXuQU/sd1OjklyXVieDbDMGsUQpbSHTveQ8RmRnphYGQhKXM5+Tm4i
	 o9V9BmX9RzIA/W6JpqAF0PENureal88LnfbXjaZr7X8U4pIqNgRDKdgdJ5W/rwUGlq
	 I0vwAqsEaSzJuZ/O951GsL45omj2o27P5PB2nRWiio/uLwW6C96nZmVnTY2YWXr9Up
	 3w5uzzGxAlLNqCyeeFVusjdJdVjZsWGyL+6BVGtOWZIy64m2zog8zYc46jtthfJAdx
	 8M2wUY/M1Pk+Q==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 1/5] block: Make REQ_OP_ZONE_FINISH a write operation
Date: Wed, 25 Jun 2025 18:33:23 +0900
Message-ID: <20250625093327.548866-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250625093327.548866-1-dlemoal@kernel.org>
References: <20250625093327.548866-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

REQ_OP_ZONE_FINISH is defined as "12", which makes
op_is_write(REQ_OP_ZONE_FINISH) return false, despite the fact that a
zone finish operation is an operation that modifies a zone (transition
it to full) and so should be considered as a write operation (albeit
one that does not transfer any data to the device).

Fix this by redefining REQ_OP_ZONE_FINISH to be an odd number (13), and
redefine REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL using sequential
odd numbers from that new value.

Fixes: 6c1b1da58f8c ("block: add zone open, close and finish operations")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 include/linux/blk_types.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 3d1577f07c1c..930daff207df 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -350,11 +350,11 @@ enum req_op {
 	/* Close a zone */
 	REQ_OP_ZONE_CLOSE	= (__force blk_opf_t)11,
 	/* Transition a zone to full */
-	REQ_OP_ZONE_FINISH	= (__force blk_opf_t)12,
+	REQ_OP_ZONE_FINISH	= (__force blk_opf_t)13,
 	/* reset a zone write pointer */
-	REQ_OP_ZONE_RESET	= (__force blk_opf_t)13,
+	REQ_OP_ZONE_RESET	= (__force blk_opf_t)15,
 	/* reset all the zone present on the device */
-	REQ_OP_ZONE_RESET_ALL	= (__force blk_opf_t)15,
+	REQ_OP_ZONE_RESET_ALL	= (__force blk_opf_t)17,
 
 	/* Driver private requests */
 	REQ_OP_DRV_IN		= (__force blk_opf_t)34,
-- 
2.49.0

