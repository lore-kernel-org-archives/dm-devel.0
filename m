Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB77F3BED1B
	for <dm-devel@lists.linux.dev>; Thu,  9 Apr 2026 15:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775749827; cv=none; b=aQe+vZo9q/83tBmZlKvUmSUHUgJ3RpkR9KJtx2PzDrE0YIb89b1U9Lxq0YQYIxbosr8dxOz5vCtPvxEFd3JTmpgsB8WLtKW/tKQOSOA6D87aiJTY8oDmMKRVvQodsLTjw9M6vAYfKWaUkQFqxvhygv2bXmaWB5DFn1GhSFlNTXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775749827; c=relaxed/simple;
	bh=7DzSVYuBZozDGpdCyIkrfke4qRawGMxCzE/OHph8dAU=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=rWFXsvtZLjPYFdTCsQ4AsDHEpUtqMqvGKDX5Tz3hJTUl2ZVOEyNmIdupSnm6iTMQpKJ+hLKxi/Z5ZwJTmshKQejz++bWAtfqTtkqal9TfWo31K7MxTCkteNt07rQwNZDJo8SLs42TUUBESwbfo69TIn8gcdrB9aDetaYimbNYIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cmQ8bK/Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cmQ8bK/Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775749823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=VOjP675PGPAPFABh1KZrk1YOfyQVLwsuZv48txfP01g=;
	b=cmQ8bK/Yq01k6694z23Gqr+nIvhCNtge2UcDa3BHD4UNQ/ebaLm+k+9QTQYCTbDDgeVn39
	+ApTUm5mLp1u5UvjGc8VyhlvsvsjMkOG+jU8Yd684Q7Kz3yhuc/q0sp3WWQkIT2MSKbmDz
	TRYE0Sd+SwShh56p9s+8yoOdw0E+azc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-647-OAuV8k9QOLScGUJCxa9Eew-1; Thu,
 09 Apr 2026 11:50:21 -0400
X-MC-Unique: OAuV8k9QOLScGUJCxa9Eew-1
X-Mimecast-MFC-AGG-ID: OAuV8k9QOLScGUJCxa9Eew_1775749821
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0C7FB180AC48
	for <dm-devel@lists.linux.dev>; Thu,  9 Apr 2026 15:50:05 +0000 (UTC)
Received: from [10.44.48.54] (unknown [10.44.48.54])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1E9CA195608E;
	Thu,  9 Apr 2026 15:50:01 +0000 (UTC)
Date: Thu, 9 Apr 2026 17:49:58 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: dm-devel@lists.linux.dev
cc: Tony Asleson <tasleson@redhat.com>, Alasdair Kergon <agk@redhat.com>, 
    Zdenek Kabelac <zkabelac@redhat.com>, "Bryn M. Reeves" <bmr@redhat.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] dm: fix a buffer overflow in ioctl processing
Message-ID: <510b5754-3944-6b4e-03b8-f3a7dc137944@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HAPyXQFWc5Ow438SjPqFytGd3Bt0feKLSNvRBWfgLhY_1775749821
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Tony Asleson (using Claude) found a buffer overflow in dm-ioctl in the
function retrieve_status:

1. The code in retrieve_status checks that the output string fits into
   the output buffer and writes the output string there
2. Then, the code aligns the "outptr" variable to the next 8-byte
   boundary:
	outptr = align_ptr(outptr);
3. The alignment doesn't check overflow, so outptr could point past the
   buffer end
4. The "for" loop is iterated again, it executes:
	remaining = len - (outptr - outbuf);
5. If "outptr" points past "outbuf + len", the arithmetics wraps around
   and the variable "remaining" contains unusually high number
6. With "remaining" being high, the code writes more data past the end of
   the buffer

Luckily, this bug has no security implications because:
1. Only root can issue device mapper ioctls
2. The commonly used libraries that communicate with device mapper
   (libdevmapper and devicemapper-rs) use buffer size that is aligned to
   8 bytes - thus, "outptr = align_ptr(outptr)" can't overshoot the input
   buffer and the bug can't happen accidentally

Reported-by: Tony Asleson <tasleson@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-ioctl.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-dm/drivers/md/dm-ioctl.c
===================================================================
--- linux-dm.orig/drivers/md/dm-ioctl.c	2026-04-08 16:14:34.000000000 +0200
+++ linux-dm/drivers/md/dm-ioctl.c	2026-04-08 21:11:11.000000000 +0200
@@ -1356,6 +1356,10 @@ static void retrieve_status(struct dm_ta
 		used = param->data_start + (outptr - outbuf);
 
 		outptr = align_ptr(outptr);
+		if (!outptr || outptr > outbuf + len) {
+			param->flags |= DM_BUFFER_FULL_FLAG;
+			break;
+		}
 		spec->next = outptr - outbuf;
 	}
 

