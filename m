Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E087C3ACA7C
	for <dm-devel@lists.linux.dev>; Thu,  9 Jul 2026 19:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783624980; cv=none; b=t51+9kG1Q+JhFpBk1pMmJux7kqUc1Ts3FcDdp2SexuS5yTwdu8lzeQH0VdaVzj9PbqK+u3UTqW/ENIEdoATeYm3dss2JI6qdhKcnLux0DQm5pu+gduSzuchV4z0apec7kCr8jrOl9gd79bSZhTbnYFYvh3jnqFUDuVmhwr/Lpew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783624980; c=relaxed/simple;
	bh=SasBQ+UOYAbdbi+AttVYQPQVxYlvGClZkgMYoD+xZME=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=qCQ7sq7XsKhUimmH+H9XkVfcMOp8bxGb5mlTpL/Kw00BiYFBAgiKfaKUzX1DW6oAKddA1PpQ0jf2RAieQncqr3mmITQfmsznrQrYGTmx+uQQZyPfnpj62svqISbHMSzG8GtSBrDlxgcG/dD2cHmajziO8bkc+XMLhwfDjGDIxj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZiA7chF/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZiA7chF/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783624977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=20JpKVx3A26c8qUuH47lnNbtz8WxaPKDbaC41xWF4Is=;
	b=ZiA7chF/03ZE6pHWoDS7SrRxEbI7+ThYXJtBW9PhN1NHhb8FZ7RgoOQZDuKQDDp1rnTfeC
	rLQfzJLHWJVCQFh8fAw6USQzAPSFlS7CBCgZUu2xN8ulURicu2Zq0DYxyvHo71/oaQfLHA
	/lE8j5VObNRHlX8/zTigom19mPq5P2I=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-247-GDvyskktMOizFYc1OqDVDw-1; Thu,
 09 Jul 2026 15:22:56 -0400
X-MC-Unique: GDvyskktMOizFYc1OqDVDw-1
X-Mimecast-MFC-AGG-ID: GDvyskktMOizFYc1OqDVDw_1783624975
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F2A71800594;
	Thu,  9 Jul 2026 19:22:55 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D1110195608A;
	Thu,  9 Jul 2026 19:22:53 +0000 (UTC)
Date: Thu, 9 Jul 2026 21:22:47 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-integrity: fix leaking uninitialized kernel memory
Message-ID: <916c00f0-7aa2-2f8f-eb5c-f7e19f7f6107@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: O5DaqI61VRJht3TWyywBNKSHsvc_0oI5CgDhMfnxbEI_1783624975
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

If hash size is less than device's tuple size, dm-integrity is supposed
to zero the remaining space. There was a bug in the code that zeroing
didn't work. This commit fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: fb0987682c62 ("dm-integrity: introduce the Inline mode")
Cc: stable@vger.kernel.org

---
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2026-04-27 19:06:34.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2026-06-22 16:33:32.000000000 +0200
@@ -2606,7 +2606,7 @@ skip_spinlock:
 			struct bio_vec bv = bio_iter_iovec(bio, dio->bio_details.bi_iter);
 			const char *mem = integrity_kmap(ic, bv.bv_page);
 			if (ic->tag_size < ic->tuple_size)
-				memset(dio->integrity_payload + pos + ic->tag_size, 0, ic->tuple_size - ic->tuple_size);
+				memset(dio->integrity_payload + pos + ic->tag_size, 0, ic->tuple_size - ic->tag_size);
 			integrity_sector_checksum(ic, &dio->ahash_req, dio->bio_details.bi_iter.bi_sector, mem, bv.bv_offset, dio->integrity_payload + pos);
 			integrity_kunmap(ic, mem);
 			pos += ic->tuple_size;

