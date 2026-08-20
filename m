Received: from mta1.migadu.com (out-25.mta1.migadu.com [95.215.58.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF15488DA6
	for <dm-devel@lists.linux.dev>; Thu, 20 Aug 2026 21:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787262364; cv=none; b=r82sArK+hN1NybSnIiCp8Z+1umU93mKkVE0/9kJPcOHKVbP69iBDw0cfoCRY9IWryWG8HCI2OZX2Hi4iiND5V4GKP0N/dkNKtqp/k5POXF5faHPTr3SW1FPosr5I3zf/wVwrRN0LzNIJukk5jpWgFj6bs8ZgBsY+bfNckgmlmSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787262364; c=relaxed/simple;
	bh=RSZ1ThSZgOWxnWB2KV4RYcYDFdabNu3Qx7dkm8ktJss=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Zw4AVfjLCT8k8xCo35cbkvHFH8sTvMUDiqFNJVOMokywVeUaV3S4Xg5a/qlg2Bh1aDrexkX9zOqATiVcbabN3XhQjCmMeYDLovLgTDA5pEbAONIGIBhTM2wSIl6va0I+BnZtSLzAxMm1JRu/CTHt3CTIYkB7V6QmUFLNf/wf+8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cressey.dev; spf=pass smtp.mailfrom=cressey.dev; dkim=pass (2048-bit key) header.d=cressey.dev header.i=@cressey.dev header.b=EXvvNUO1; arc=none smtp.client-ip=95.215.58.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cressey.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cressey.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cressey.dev header.i=@cressey.dev header.b="EXvvNUO1"
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=RSZ1ThSZgOWxnWB2KV4RYcYDFdabNu3Qx7dkm8ktJss=;
 c=simple/simple; d=cressey.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787262360; v=1; x=1787867160;
 b=EXvvNUO1IpmIzqkV6Lf8eXKNVn/chbaQjilWS3Bie0UspksuP3pBRQBIIAi/XgR92RXklE4j
 mmp3fq811Yfk/bz+uqF5AsYI4qapIHQeY0MhzADAnRpQcBQIEajkw0YJaZolQffjwblhQlEJf7e
 Q3gLFSkgwaKticZti/LdzTGNQn1lSzPngwUdyh2o81Cb1w5qPNmY6M/xJY+7Aluc7uj1zrXxAoC
 BPxI42Fu+3QPnAPMmqseL+T3HULzJtYahokZK2rKMHDhNHO4Dg0ZzBv+v8e3lYDwLQLxBB5JHBK
 FuCY7prrUswF1csM8eaxYZP9UztsHUfzq6uufzPJkt36w==
X-Envelope-To: dm-devel@lists.linux.dev
Received: from coder-bcressey-whiskers-0.coder-bcressey-whiskers.remote-dev.svc.cluster.local (35.83.186.167)
	by smtp.migadu.com with ESMTPS id a1f09cbef526edeb;
	Thu, 20 Aug 2026 21:46:00 +0000
X-Mizu-Trace-ID: a1f09cbef526edeb
X-Migadu-Flow: FLOW_OUT
From: Ben Cressey <ben@cressey.dev>
Date: Thu, 20 Aug 2026 21:44:58 +0000
Subject: [PATCH 2/2] dm-integrity: fix infinite loop on discard with large
 tag size
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-dm-integrity-discard-v1-2-196d3618d09a@cressey.dev>
References: <20260820-dm-integrity-discard-v1-0-196d3618d09a@cressey.dev>
In-Reply-To: <20260820-dm-integrity-discard-v1-0-196d3618d09a@cressey.dev>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, Shukai Ni <shukai.ni@kuleuven.be>, 
 Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org, 
 "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>, 
 Ben Cressey <ben@cressey.dev>
X-Mailer: b4 0.15.2

When integrity_metadata handles a discard, it fills a buffer with
DISCARD_FILLER and writes it over the tags, max_blocks blocks at a
time. If the kmalloc fails, the buffer is the on-stack array
checksums_onstack and max_size is set to HASH_MAX_DIGESTSIZE. So if the
tag size is larger than HASH_MAX_DIGESTSIZE, max_blocks is zero, bi_size
is never decremented and the loop never terminates.

Fix this by using sizeof(checksums_onstack) as max_size. The array has
MAX_TAG_SIZE bytes since commit b93b6643e9b5 ("dm integrity: fix a
crash with unusually large tag size"), so max_blocks is at least 1.

Fixes: 84597a44a9d8 ("dm integrity: add optional discard support")
Cc: stable@vger.kernel.org
Reviewed-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Signed-off-by: Ben Cressey <ben@cressey.dev>
Assisted-by: Claude:unspecified
---
The natural trigger needs the kmalloc to fail, so this was tested with
the fallback forced (a test-only hunk that frees the buffer for
discards): J mode, internal_hash:sha256, tag_size 100, allow_discards,
BLKDISCARD of 16 MiB. Without the fix the discard never completes and a
dm-integrity-offload kworker spins in integrity_metadata ->
dm_integrity_rw_tag (soft lockup with preempt=none); with the fix it
completes immediately. This goes after 1/2; on its own it would let the
keyed-discard fallback overflow checksums_onstack for tag sizes below
the digest size.

For stable: 1/2 is not stable material and it changes the context line
right above this hunk, so this patch will not apply verbatim to released
trees. The backport is the same one-line change; I will send it in
reply to the failed-to-apply notice.
---
 drivers/md/dm-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 73c1db7e55d5c..48eca96ca6d8c 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1979,7 +1979,7 @@ static void integrity_metadata(struct work_struct *w)
 
 		if (unlikely(dio->op == REQ_OP_DISCARD)) {
 			unsigned int bi_size = dio->bio_details.bi_iter.bi_size;
-			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
+			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : sizeof(checksums_onstack);
 			unsigned int max_blocks = (max_size - extra_space) / ic->tag_size;
 			sector_t sector = dio->range.logical_sector;
 

-- 
2.53.0

