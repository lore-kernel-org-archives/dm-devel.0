Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AC837B41B
	for <dm-devel@lists.linux.dev>; Thu,  9 Jul 2026 19:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783625771; cv=none; b=Lc3Yfbl2qErTP559z6TKlhDC2JmCaqCiIHglEIpESlkNtb81HoTsAbYzcDYCb9cafHtTkY30ycRwhOyrNKnPWep3dBXoJBVn3P0r5F6TS7bI0HhurChb6vaRH47feoiAz8D5pVrPmDIHLPOVspfOvPKo6/POUfXhVS2i3zMhYfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783625771; c=relaxed/simple;
	bh=aj+FYEqoTgN2fMLjrcrhL11t/3xoY0EUaN10TNlk8JU=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=NuEEtIqr8whPzHSuXQfLfNbGx+BU1t1kdGh7udM+Bac6CxSM+U+ZPr+xxZPj9YXLoJjfkKnIVMebp/HzkMsJ+wPNUarSn76st1czC0VZFpbw6aKnsKNXHH5wgXqqt83Ouwu2X/8DMHLA7gPgBymIfS9p1b7hUSsXE2xU78DXhpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hOrxNQ+r; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hOrxNQ+r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783625769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=W9DUw6KuLtDFzqgpOun/Rk5in2xXJdvQkWBrR/G+b2Y=;
	b=hOrxNQ+rwYkLTsfax3nYwUnpisxU85Rp8dQnRIdDweWbWzpwNJlnikxihfl0C5l05qhV1Z
	f10kjY5DkeUc59J+mbr8VtYy++tGwMaGT/qHEnAAHeNMpc2k5QZdJj62f6tfBk9vjmZzwL
	yh1B/m7dysltkmeHwjWODtvyDBsT0DU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-108-uLNLeFoZPYiZdXdhVHprHA-1; Thu,
 09 Jul 2026 15:36:06 -0400
X-MC-Unique: uLNLeFoZPYiZdXdhVHprHA-1
X-Mimecast-MFC-AGG-ID: uLNLeFoZPYiZdXdhVHprHA_1783625765
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 666AB1800847;
	Thu,  9 Jul 2026 19:36:05 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2740E1956053;
	Thu,  9 Jul 2026 19:36:03 +0000 (UTC)
Date: Thu, 9 Jul 2026 21:36:01 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-verity: increase sprintf buffer size
Message-ID: <8f91310b-f7c9-a87f-6076-a21513cc03ec@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mLWBJjWBOeCaeFS7QBOsLiIaZ2RJrJfEfD5CMfCHlsE_1783625765
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The prefix "DM_VERITY_ERR_BLOCK_NR" is 22 chars. Add '=', one digit for
type, ',', up to 20 digits for a u64 block number, and a NUL terminator:
that's 46 bytes. The buffer is 42 bytes. For block numbers >= 16 decimal
digits (devices larger than ~16 EB with 4K blocks), snprintf silently
truncates the uevent environment variable.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: 65ff5b7ddf05 ("dm verity: add error handling modes for corrupted blocks")
Cc: stable@vger.kernel.org

---
 drivers/md/dm-verity-target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-verity-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-target.c	2026-07-01 13:31:00.000000000 +0200
+++ linux-2.6/drivers/md/dm-verity-target.c	2026-07-01 18:16:12.000000000 +0200
@@ -26,7 +26,7 @@
 
 #define DM_MSG_PREFIX			"verity"
 
-#define DM_VERITY_ENV_LENGTH		42
+#define DM_VERITY_ENV_LENGTH		46
 #define DM_VERITY_ENV_VAR_NAME		"DM_VERITY_ERR_BLOCK_NR"
 
 #define DM_VERITY_DEFAULT_PREFETCH_SIZE	262144

