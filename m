Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC3F49253D
	for <dm-devel@lists.linux.dev>; Wed,  1 Jul 2026 16:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782922444; cv=none; b=jqNpQdUBQxIsaK5sFGdQHCpLHfa+jlU1YPF1WXf6KWz6gKQ2KMHLV4RrDldCQuzUB3bwUVVauR6wSwsY353oQxMM7nUvmo5kynb+HZxy5IYTfThGe+L5yYhkPd4plSvHajZVlPkkBzFexHmplGD2OxmTEIKy/jRCMzcYHArBCqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782922444; c=relaxed/simple;
	bh=vVTffM0dmRax+lHrc9XaDizuwKM3mLoUNwQ/GEHRkVo=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=FIpDVGBUTzbiJEV4WP7btcJ5R8gj5dJTSH41LnZgxLvVkrqOqyyXQWZ5sAA4HzxlxZ0Dt0M6qnR4aDi8vkl/eGmv4lS3IMrx8HknAy3QG8ttguLXnJUNOP9l3FUqpQesQlm2/nlnCj2m1be4Jn2O6YGJCUjqYeCe7JsjCkegnJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cc0wL8UF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cc0wL8UF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782922441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=zQinUF4nRw9suvYV0QcC+4HwU6YJpeOvuznpk/sVBR0=;
	b=cc0wL8UFwcE/M4Qaw8ajDRUDIjxyQoY52L+QhmH44aBmowrxghGMcceaCx2qQbOz9/5tZX
	1OBL/raZC0csBZtHHHV4HlfFOAsXYSqVEa9gHT43NycC8SIPbrDHBTu2o9zK8Ov90l/pM/
	8cOFhQhxEKjvA5AvLyOmCUATO5dIRx0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-0n58DUEPMjOY9fsSD-Zq7A-1; Wed,
 01 Jul 2026 12:14:00 -0400
X-MC-Unique: 0n58DUEPMjOY9fsSD-Zq7A-1
X-Mimecast-MFC-AGG-ID: 0n58DUEPMjOY9fsSD-Zq7A_1782922439
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 43C1C195C246;
	Wed,  1 Jul 2026 16:13:59 +0000 (UTC)
Received: from [10.44.32.26] (unknown [10.44.32.26])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3D48F180056E;
	Wed,  1 Jul 2026 16:13:58 +0000 (UTC)
Date: Wed, 1 Jul 2026 18:13:50 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Sami Tolvanen <samitolvanen@google.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-verity: fix buffer overflow in FEC calculation
Message-ID: <40e88304-8e8c-4bb9-12ac-e7a67b130af1@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6_6abPLO_tRK0RQSo1h_5JakQwRehq-pg7iYknN4KYM_1782922439
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463811712-804060629-1782922438=:695192"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-804060629-1782922438=:695192
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Hi Sami

I used Claude to search for bugs in dm-verity and it found this. The bug 
is real, the buffer "lambda" in lib/reed_solomon/decode_rs.c can overflow. 
Claude proposed this fix. I'd like to ask you (as you wrote the dm-verity 
FEC code) to review this patch.

It seems that we can also redice the size of fio->erasures to 
DM_VERITY_FEC_MAX_ROOTS entries.

Mikulas




if (neras && *neras <= v->fec->roots)
	fio->erasures[(*neras)++] = i;

This allows *neras to reach roots + 1 (the post-increment pushes it past roots). This
value is then passed as no_eras to decode_rs8(). Inside the RS decoder
(lib/reed_solomon/decode_rs.c:113-121), the erasure locator polynomial loop writes
lambda[j] where j can reach nroots + 1 — one element past the end of lambda[] (which
is sized nroots + 1, valid indices 0..nroots). The out-of-bounds write lands on
syn[0], corrupting the syndrome buffer.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Cc: stable@vger.kernel.org
Fixes: a739ff3f543a ("dm verity: add support for forward error correction")

---
 drivers/md/dm-verity-fec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-verity-fec.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-fec.c	2026-07-01 13:38:45.000000000 +0200
+++ linux-2.6/drivers/md/dm-verity-fec.c	2026-07-01 13:52:19.000000000 +0200
@@ -220,7 +220,7 @@ static int fec_read_bufs(struct dm_verit
 				     PTR_ERR(bbuf));
 
 			/* assume the block is corrupted */
-			if (neras && *neras <= v->fec->roots)
+			if (neras && *neras < v->fec->roots)
 				fio->erasures[(*neras)++] = i;
 
 			continue;
@@ -238,7 +238,7 @@ static int fec_read_bufs(struct dm_verit
 			 * skip if we have already found the theoretical
 			 * maximum number (i.e. fec->roots) of erasures
 			 */
-			if (neras && *neras <= v->fec->roots &&
+			if (neras && *neras < v->fec->roots &&
 			    fec_is_erasure(v, io, want_digest, bbuf))
 				fio->erasures[(*neras)++] = i;
 		}

---1463811712-804060629-1782922438=:695192--

