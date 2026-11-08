Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170874;
	b=NgJ8Gl5he9wALxV1BS1ovmnVfPmnMgQhzfYk80Z7snKa2FpeZhUiMX54os1kbpF7AZXH
	 Bx0n2EDmgGmq97jIDLLYskeP7BI1Y3aMoWSv3Ol4qxjdWEgTA2WLJRiKuVSCLtLjhXfHE
	 nDsU394XyT89gDMgfJRBx+/1lz9+/BvJ2ieMchHhm+INQSuD2zbe1z7tl6F3CyKf3nosv
	 U39DHZX16ivD6exWGUxuDtJK32oLsE+68/UQOeu2kLsE5z06Xh/XgGWzrMCqOlxjfCEa9
	 D9Xtb/my5GM2mjJ6jsqWYEg6OCXj3R2FdjjjyUI8uoaApL+K7Fl/KFkKnZhxEd4NrEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170874;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=aNzkqDCBVXwmi5oj0PGy5yPAAg5hMAVbnirK2n7hgX4=;
	b=yl8Az+d7zls5YE5GR+cbR36nOB2jxTVYbWYMyIB9ow1S2+nrMsMwkryLjl25lxfcyPDL
	 FTz1F/dZvy+X8BPqNeMm9AzqX4QzSaP7gg4ZTKBdkBWfQU7aeajo+VTZ6/g1GGuBvTusY
	 j/HqBjCnFHVxDik4ysElheg2vr+Yi3qskNu8I/JBYmzg0/TGTITtNzXpVmUsmPgOKtb1o
	 q6XlaMof1duUFzu8ZxKNHPlGjY+7blnavBhARDbAD1ZlaLviGsMs4gOqOr7ysCBaFjBil
	 4AUEd1Bqq4JfWaepk9lDQW3WNCx8z4gNtE0Lxuf3iXWMi/YvTeN0Up8yyVQIHriZLIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZxUl3w55;
	arc=none smtp.remote-ip=95.215.58.16
Received: from mta1.migadu.com (out-16.mta1.migadu.com [95.215.58.16])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0826E606A321
	for <dm-devel@lists.linux.dev>; Sun,  8 Nov 2026 20:47:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0826E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZxUl3w55
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Q+2pKZ+L2WOBU15nwp1Wi0VRAz2LduR8/HNqLcSY8YQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170871; v=1; x=1794775671;
 b=ZxUl3w55KgPzPTNm5iVSijHlrMf5EXOAc4m1hAD7uDigKoIkbGzkoR3F/w27tYnp0cUCgkDY
 jK32uHrQaZwhtAexWa3xHyxIzZ9KGtmb2oVirH4kziEd+Bu9Vgg4kRfNFBNR9zLv92S8QGS+hhb
 3A5SytfUjnbyNVvjGRaIe9LQ=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by mta10.migadu.com with ESMTPS id 3ae26450b5a369b2;
	Sun, 08 Nov 2026 20:47:51 +0000
X-Mizu-Trace-ID: 3ae26450b5a369b2
X-Migadu-Flow: FLOW_OUT
From: John Garry <john.garry@linux.dev>
To: james.bottomley@hansenpartnership.com,
	mkp@kernel.org
Cc: hare@suse.com,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	snitzer@kernel.org,
	jmeneghi@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	hch@lst.de,
	michael.christie@oracle.com,
	John Garry <john.garry@linux.dev>
Subject: [PATCH v9 01/29] scsi: core: Clear cmd->flags for terminal queuing error
Date: Sun,  8 Nov 2026 20:47:05 +0000
Message-ID: <20261108204733.557995-2-john.garry@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261108204733.557995-1-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a request can't be queued in scsi_queue_rq(), then we error out with
a blk_status_t code. Such a scenario may be the scsi_device has its
transport offline.

For BLK_STS_RESOURCE or BLK_STS_AGAIN, the request will be requeued in the
block layer. For other errors, the block layer ends the request and so
we won't see it again (until recycled).

Normally when a request completes scmd->flags is cleared in
scsi_end_request().

However for the error scenario mentioned above, scsi_end_request() is
not called and so scmd->flags is not cleared. As such, when the request
is recycled we see the old value in scmd->flags.

Fix this issue by clearing scmd->flags in the error scenario mentioned by
calling scsi_cleanup_rq().

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b52b4c5daa42..36bc995e4e25 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1994,8 +1994,8 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 		 * we hit an error, as we will never see this command
 		 * again.
 		 */
-		if (req->rq_flags & RQF_DONTPREP)
-			scsi_mq_uninit_cmd(cmd);
+		scsi_cleanup_rq(req);
+
 		scsi_run_queue_async(sdev);
 		break;
 	}
-- 
2.43.0

