Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F5E239079
	for <dm-devel@lists.linux.dev>; Mon, 10 Feb 2025 15:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739199887; cv=none; b=HyUuzj3boGJC+Bw6E/AfQHwbYF7ygX9VrhlSm5hslwMyebxZ/arUsS2DUOPKPAodZGRxwFrgJHI/t/VcyVxMy/j0BarGsRaRYEKDq89EHZ66HhDvISkkkF88+MvkewUVrqP9AopjH9wsFuq+tra6BQpNF7SFMo9KEk3QeOyoueo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739199887; c=relaxed/simple;
	bh=QsrTRkT1y+pbMOXg18klEA3YLoEIC2hm1YD/vCDsves=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=hnkuX4Ub+om4fN3ii7q9qHrb4jHBiHhkhcLBLRM7wz67Ia/qEPBgghkbLTDhuIeidad/IWEjzPfOsj3vaLDIt2fAVXGG4Wg+AEEUzglFDQtbCjSZ5BnDU6zDS9ygDK0JyeshehtJIOylzgMzJ5XXQb/ecLQsl2QZo+6uGee5HX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A0gMn0qF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A0gMn0qF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739199883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=lq1UT1Qq63yfXt3/5/6ooPAW8WNnDD3R4ckVOvp9WH4=;
	b=A0gMn0qFhMR8fz0k4frf4viBEDxKxW/T9xcwY94j5zeuQWOQcLrxAtCZjeuqBnGBqKqkDX
	fk/m0TYBH/B+WN0qIrOwwKC11b1mxzatDmflxC7X0Q7otrP11cmmLb07GuJ46HBLJDTchg
	VY6MyEWCCPa6fMEoD7XwUD/nnohRi6c=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-269-RePXVRK2MhqlpYybJHe3cw-1; Mon,
 10 Feb 2025 10:04:38 -0500
X-MC-Unique: RePXVRK2MhqlpYybJHe3cw-1
X-Mimecast-MFC-AGG-ID: RePXVRK2MhqlpYybJHe3cw
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 947D21800876;
	Mon, 10 Feb 2025 15:04:36 +0000 (UTC)
Received: from [10.45.225.131] (unknown [10.45.225.131])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C7C1B1800352;
	Mon, 10 Feb 2025 15:04:33 +0000 (UTC)
Date: Mon, 10 Feb 2025 16:04:28 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Akilesh Kailash <akailash@google.com>
cc: Sami Tolvanen <samitolvanen@google.com>, akailash@google.com, 
    kernel-team@android.com, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, Milan Broz <gmazyland@gmail.com>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH] dm-verity: do forward error correction on metadata I/O
 errors
Message-ID: <629167c1-9be0-6128-8605-eb02391e821d@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Do forward error correction if metadata I/O fails.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-verity-target.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-verity-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-target.c	2025-02-04 13:52:45.000000000 +0100
+++ linux-2.6/drivers/md/dm-verity-target.c	2025-02-10 15:55:42.000000000 +0100
@@ -324,8 +324,22 @@ static int verity_verify_level(struct dm
 						&buf, bio->bi_ioprio);
 	}
 
-	if (IS_ERR(data))
-		return PTR_ERR(data);
+	if (IS_ERR(data)) {
+		r = PTR_ERR(data);
+		data = dm_bufio_new(v->bufio, hash_block, &buf);
+		if (IS_ERR(data))
+			return r;
+		if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_METADATA,
+				      hash_block, data) == 0) {
+			aux = dm_bufio_get_aux_data(buf);
+			aux->hash_verified = 1;
+			goto release_ok;
+		} else {
+			dm_bufio_release(buf);
+			dm_bufio_forget(v->bufio, hash_block);
+			return r;
+		}
+	}
 
 	aux = dm_bufio_get_aux_data(buf);
 
@@ -366,6 +380,7 @@ static int verity_verify_level(struct dm
 		}
 	}
 
+release_ok:
 	data += offset;
 	memcpy(want_digest, data, v->digest_size);
 	r = 0;

