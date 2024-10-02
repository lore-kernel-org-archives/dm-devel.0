Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23CC1D0DF4
	for <dm-devel@lists.linux.dev>; Wed,  2 Oct 2024 13:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877395; cv=none; b=VCZIjotHvpHID5FKk6g/5E8544zsJ5udLVjCaIo7sUUj5ayLyEAIEuU1DHdU0cX6RIxOKv7b13c7OFZVH0mNjEpC4lq90mw+KU88y68PVpDMiWEyTGNy09j14bnHW/sIThG8kG1FPAV8H0m6CM4/EFWPppi2ZebSb1By8cO+ZY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877395; c=relaxed/simple;
	bh=p9QDWfFM/arOFQukKAKYjJ+JQPzoITFygWlqf6kyM5k=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=JyliE+OU7ZlWx+/1R6Injm9faGsCIu4tqh5oyONg3ZRvrnGPySyCvj/gMzNnckARg46iFvW0ZJO9jD8bcUGIa/dF5P8zElKTDnIOsyEkadPft/jwT+1c5Za+T+XAb0ZFS6PmNLZdKoyuKTLOxHcLwXoD9YFcW1SB2dVonLbdB9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=URtEwEG4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="URtEwEG4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727877392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=R58KhJbVzBQ2H8vytAKSM/gULX5O9ZaEjURs09gwjls=;
	b=URtEwEG46cD0X3NjSL7ZMP61vITuV/wGBUrIfthd/lgOvCtSjodrYiHHUZgeTBiRX8OyF4
	7F40cox028VHibUTxe5CM2/OFfsyTW8UQAlZnXP+LixWfsFICSH9ZZMNzTmT48wuxMORlh
	2xplQwF1amcvvJ7wP66fRvCkcUkXP9w=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-141-aDDa65rlOYeqACuowoCllQ-1; Wed,
 02 Oct 2024 09:56:28 -0400
X-MC-Unique: aDDa65rlOYeqACuowoCllQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B7B201955D64;
	Wed,  2 Oct 2024 13:56:25 +0000 (UTC)
Received: from [10.45.225.58] (unknown [10.45.225.58])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A2B7D19560A3;
	Wed,  2 Oct 2024 13:56:22 +0000 (UTC)
Date: Wed, 2 Oct 2024 15:56:18 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: dm-devel@lists.linux.dev
cc: Will Drewry <wad@chromium.org>, Sami Tolvanen <samitolvanen@google.com>, 
    Maxim Suhanov <dfirblog@gmail.com>, Milan Broz <gmazyland@gmail.com>, 
    Akilesh Kailash <akailash@google.com>, Alasdair G Kergon <agk@redhat.com>, 
    Greg KH <gregkh@linuxfoundation.org>, Mike Snitzer <snitzer@kernel.org>, 
    security@kernel.org, Eric Biggers <ebiggers@google.com>
Subject: [PATCH 1/2] Revert: "dm-verity: restart or panic on an I/O error"
Message-ID: <6414ad63-a9d2-b6bb-2995-54f9a6299c3c@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

This reverts commit e6a3531dd542cb127c8de32ab1e54a48ae19962b.

The problem that the commit e6a3531dd542cb127c8de32ab1e54a48ae19962b
fixes was reported as a security bug, but Google engineers working on
Android and ChromeOS didn't want to change the default behavior, they
want to get -EIO rather than restarting the system, so I am reverting
that commit.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Fixes: e6a3531dd542 ("dm-verity: restart or panic on an I/O error")

---
 drivers/md/dm-verity-target.c |   23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

Index: linux-2.6/drivers/md/dm-verity-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-target.c	2024-10-02 12:40:18.000000000 +0200
+++ linux-2.6/drivers/md/dm-verity-target.c	2024-10-02 12:40:18.000000000 +0200
@@ -273,10 +273,8 @@ out:
 	if (v->mode == DM_VERITY_MODE_LOGGING)
 		return 0;
 
-	if (v->mode == DM_VERITY_MODE_RESTART) {
-		pr_emerg("dm-verity device corrupted\n");
-		emergency_restart();
-	}
+	if (v->mode == DM_VERITY_MODE_RESTART)
+		kernel_restart("dm-verity device corrupted");
 
 	if (v->mode == DM_VERITY_MODE_PANIC)
 		panic("dm-verity device corrupted");
@@ -599,23 +597,6 @@ static void verity_finish_io(struct dm_v
 	if (!static_branch_unlikely(&use_bh_wq_enabled) || !io->in_bh)
 		verity_fec_finish_io(io);
 
-	if (unlikely(status != BLK_STS_OK) &&
-	    unlikely(!(bio->bi_opf & REQ_RAHEAD)) &&
-	    !verity_is_system_shutting_down()) {
-		if (v->mode == DM_VERITY_MODE_RESTART ||
-		    v->mode == DM_VERITY_MODE_PANIC)
-			DMERR_LIMIT("%s has error: %s", v->data_dev->name,
-					blk_status_to_str(status));
-
-		if (v->mode == DM_VERITY_MODE_RESTART) {
-			pr_emerg("dm-verity device corrupted\n");
-			emergency_restart();
-		}
-
-		if (v->mode == DM_VERITY_MODE_PANIC)
-			panic("dm-verity device corrupted");
-	}
-
 	bio_endio(bio);
 }
 

