Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6B1224D7
	for <dm-devel@lists.linux.dev>; Tue, 24 Sep 2024 13:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727183923; cv=none; b=mJzOcmfOV8v289b6u4mjsO8KFJO7JXYLVdJXknDVt4/jRtQ0+/xevD74KI2nqLFm+QuNcZVTEl0sNgKeolWi1uLNoorB13yUZdBBqsphZFKoGAUVfXIRXjhBS05dUPB7MwbgCYchFwQ3kPJZUkW7meJ4mP//n/WscooGccXm5E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727183923; c=relaxed/simple;
	bh=rfo+Iyl9dTnPfoGm/eo79IFlrWW8r5A7Cp18qk33+NQ=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=Vb6Cn0u8ZHbHFjfWqfAgTncz9Z7oyrrWG9ucyoAwCp6Ve4cB11URlBJziDCeefDJoLBtvDef4i5eDSdeqo20Fe4apZJjqyw1m+X66kj78pf2R7bgeXHtUKB+8OxLEmVt/rP/l73hnPtqXRs2MzpItX+vC1KW09sJapoTZvGPZdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cft8sz8x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cft8sz8x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727183920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=E53CkJAoSS6hzYSnMtWN7NqdKaBn5j7jh4QkuATrodk=;
	b=cft8sz8xMDEUuYtZAR5djEXu7HXaxmb8ojgUjgpCW9pJ5Fd64gOhMfYrAJGVzV5L5BZVVq
	NnYZCBxeGizDBSaQq9gukmCJfWqsBlRuVzoHkaNxLpRhFBnU5LhELTwb5ytwoRXcY1EfZ6
	kT3CC+JgwvCGybMXpsrZcslF89aVT/w=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-88-oQARatjfPfmMIUJaePb3IQ-1; Tue,
 24 Sep 2024 09:18:37 -0400
X-MC-Unique: oQARatjfPfmMIUJaePb3IQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1129618EA96B;
	Tue, 24 Sep 2024 13:18:36 +0000 (UTC)
Received: from [10.45.226.79] (unknown [10.45.226.79])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E881B1956053;
	Tue, 24 Sep 2024 13:18:33 +0000 (UTC)
Date: Tue, 24 Sep 2024 15:18:29 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Maxim Suhanov <dfirblog@gmail.com>
cc: Alasdair G Kergon <agk@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, 
    Mike Snitzer <snitzer@kernel.org>, security@kernel.org, 
    dm-devel@lists.linux.dev
Subject: [PATCH] dm-verity: restart or panic on an I/O error
Message-ID: <cad3f86f-09bf-bc5f-c086-fc623ad223f4@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Maxim Suhanov reported that dm-verity doesn't crash if an I/O error 
happens. In theory, this could be used to subvert security, because an 
attacker can create sectors that return error with the Write Uncorrectable 
command. Some programs may misbehave if they have to deal with EIO.

This commit fixes dm-verity, so that if "panic_on_corruption" or
"restart_on_corruption" was specified and an I/O error happens, the
machine will panic or restart.

This commit also changes kernel_restart to emergency_restart -
kernel_restart calls reboot notifiers and these reboot notifiers may wait
for the bio that failed. emergency_restart doesn't call the notifiers.

Reported-by: Maxim Suhanov <dfirblog@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-verity-target.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-verity-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-target.c	2024-09-23 17:48:08.000000000 +0200
+++ linux-2.6/drivers/md/dm-verity-target.c	2024-09-24 11:34:08.000000000 +0200
@@ -273,7 +273,7 @@ out:
 		return 0;
 
 	if (v->mode == DM_VERITY_MODE_RESTART)
-		kernel_restart("dm-verity device corrupted");
+		emergency_restart();
 
 	if (v->mode == DM_VERITY_MODE_PANIC)
 		panic("dm-verity device corrupted");
@@ -596,6 +596,19 @@ static void verity_finish_io(struct dm_v
 	if (!static_branch_unlikely(&use_bh_wq_enabled) || !io->in_bh)
 		verity_fec_finish_io(io);
 
+	if (unlikely(status != BLK_STS_OK) && unlikely(!(bio->bi_opf & REQ_RAHEAD))) {
+		if (v->mode == DM_VERITY_MODE_RESTART ||
+		    v->mode == DM_VERITY_MODE_PANIC)
+			DMERR_LIMIT("%s has error: %s", v->data_dev->name,
+					blk_status_to_str(status));
+
+		if (v->mode == DM_VERITY_MODE_RESTART)
+			emergency_restart();
+
+		if (v->mode == DM_VERITY_MODE_PANIC)
+			panic("dm-verity device has I/O error");
+	}
+
 	bio_endio(bio);
 }
 

