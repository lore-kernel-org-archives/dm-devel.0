Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5DB343D72;
	Fri,  6 Feb 2026 05:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354122; cv=none; b=I0MMCfeEBGiXH9A/lFOhifOehP6TbG3pvQ2YCkUmxP4v5tD77yqamdxTCkbVu6ZVeW2clMXMzdmiDdrVNMgb2Wo3Uy8lpppi71Q6g7EdKM6CLvMwqHxOR0UyI+VeUHrmbKmuLgLUrDqPPtZj27pUXU4dFmDD1IWS5MG9efYbexk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354122; c=relaxed/simple;
	bh=uhnDZGfNOyIrde+6rFo8e20IIuPqoNWAbX5cdfnOAzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDWkEl1JB235vh32KKm8GYkQ1YvkMfmF8vZvVhhzQOXe16I7DRfKW8kVn+/2u2W9IuH5UHhiHIAFOTZ1yD97xAUPOj6REh1RUen2ZsxgUr91iCTcN5kkcrm8IZwHO4vBdM47lAZ5D3D84StnEAhRZ79uGj6r9hoO6LqV8LDzdiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PHBXOY59; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PHBXOY59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF560C19422;
	Fri,  6 Feb 2026 05:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354122;
	bh=uhnDZGfNOyIrde+6rFo8e20IIuPqoNWAbX5cdfnOAzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHBXOY599q/peMFFzyk7cUOqE4jmqgfUre036O50Na5OKAXW2M5SEmQgTOFRkgi5J
	 7k2aMRDkK0ymHB5TZWrllwdjwXJ4Z8ZzK23Quwvru9hdKgbHxtTv77Yr4IuVSrX3AD
	 d93FeSBdkWjaZxWYwn74dwDHrhfN02tRguGZn6UnieS4dFNPcbyL/9t7JRb74G530s
	 xbkS4xIOHKZohIfQs7GKscyuJ9yTUnJjDCibzh1V3wJeJy0ytHFneFGUV097L3GyhA
	 GfZE3SiygL/oRoyIVB5vovzCZV4tdA8LjXXHWbaPyILenERSTXOAOKzsNQCH4AP5im
	 KgjvhrypRrabA==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 20/22] dm-verity-fec: make fec_decode_bufs() just return 0 or error
Date: Thu,  5 Feb 2026 20:59:39 -0800
Message-ID: <20260206045942.52965-21-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260206045942.52965-1-ebiggers@kernel.org>
References: <20260206045942.52965-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fec_decode_bufs() returns the number of errors corrected or a negative
errno value.  However, the caller just checks for an errno value and
doesn't do anything with the number of errors corrected.  Simplify the
code by just returning 0 instead of the number of errors corrected.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 37c4eb6a11dee..59ff3d58f49df 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -50,11 +50,11 @@ static inline u8 *fec_buffer_rs_message(struct dm_verity *v,
  */
 static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			   struct dm_verity_fec_io *fio, u64 index_in_region,
 			   int target_region, unsigned int out_pos, int neras)
 {
-	int r, corrected = 0, res;
+	int r = 0, corrected = 0, res;
 	struct dm_buffer *buf;
 	unsigned int n, i, j, parity_pos, to_copy;
 	uint16_t par_buf[DM_VERITY_FEC_MAX_ROOTS];
 	u8 *par, *msg_buf;
 	u64 parity_block;
@@ -116,30 +116,27 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 		/* Decode an RS codeword using the Reed-Solomon library. */
 		res = decode_rs8(fio->rs, msg_buf, par_buf, v->fec->rs_k,
 				 NULL, neras, fio->erasures, 0, NULL);
 		if (res < 0) {
 			r = res;
-			goto error;
+			goto done;
 		}
-
 		corrected += res;
 		fio->output[out_pos++] = msg_buf[target_region];
 
 		if (out_pos >= v->fec->block_size)
 			goto done;
 	}
 done:
-	r = corrected;
-error:
 	dm_bufio_release(buf);
 
 	if (r < 0 && neras)
 		DMERR_LIMIT("%s: FEC %llu: failed to correct: %d",
 			    v->data_dev->name, index_in_region, r);
-	else if (r > 0)
+	else if (r == 0 && corrected > 0)
 		DMWARN_LIMIT("%s: FEC %llu: corrected %d errors",
-			     v->data_dev->name, index_in_region, r);
+			     v->data_dev->name, index_in_region, corrected);
 
 	return r;
 }
 
 /*
-- 
2.52.0

