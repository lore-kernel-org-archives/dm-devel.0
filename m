Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32D6278E53
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 10:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751884785; cv=none; b=uPZtoc30hyPFrwdiXpJY8gpgS+SlKkiEzaX18JYAEF5XMVsI4HAqF5IQ8Aw/XYIHiix0Sh2jbi+hIEi+/5yAR5WslEc3MKE30oJUxIJ3ks3dd8G/AHfwt2Wfua1jJdH5KJnbSpatyaukq9+KJyHEzcQfY0Hi7cIAGKZ2+0nJfHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751884785; c=relaxed/simple;
	bh=tuAt3tDWtsjVSif/nx0iSrwTvZo5JJ16vFkMgClO/+M=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=sC6c41yJ7z4OMtzt3OniEl/vrZWMbFveWpGt5oiplzIooa0EPGyywswOYtdI9xyiPJ7uGRkUZLapYJaL1tR8TiaK2lnTd1Y+hdwbDEtKt5ws/BLaRe8xUHYYZKdf41i35orrzvIX9LCtbY/lU/XRZaJs+1IcqViiRPR97p+2hCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SIVlEMFk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SIVlEMFk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751884782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=zOWjjRu0dexYCZ7KIh0t4ftUtsU2RIYcwuhsZQWajzc=;
	b=SIVlEMFksq4T/uy4xmjmLnr0WLH/nv5iwV+t1gptOrBmU7z0Sx3kUQz6pqLI8CUbOPY9u9
	IuSNQQmr0bjpXFyboKYoEaNd46vN9xzf1LXCNfc4y/WpPPFCIICg+C9Oadf34j56eVhGlh
	Xl5AV3pDpzP8uQpTyC7KbUW9JegCRNU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-245-1MuEybXpPpq75NCJIs_agA-1; Mon,
 07 Jul 2025 06:39:39 -0400
X-MC-Unique: 1MuEybXpPpq75NCJIs_agA-1
X-Mimecast-MFC-AGG-ID: 1MuEybXpPpq75NCJIs_agA_1751884778
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E8001809C84;
	Mon,  7 Jul 2025 10:39:38 +0000 (UTC)
Received: from [10.22.80.10] (unknown [10.22.80.10])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD0483000218;
	Mon,  7 Jul 2025 10:39:36 +0000 (UTC)
Date: Mon, 7 Jul 2025 12:39:29 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    John Garry <john.g.garry@oracle.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-stripe: fix a possible integer overflow
Message-ID: <0f1d0d2d-8840-a256-d628-39e074f021c1@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: i7MJDATtT--2wzs_krxffSmlHfn5bz_NDkRAk9S6haY_1751884778
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

There's a possible integer overflow in stripe_io_hints if we have too
large chunk size. Test if the overflow happened, and if it did, don't set
limits->io_min and limits->io_opt;

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-stripe.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-stripe.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-stripe.c	2025-07-06 15:02:23.000000000 +0200
+++ linux-2.6/drivers/md/dm-stripe.c	2025-07-07 12:32:49.000000000 +0200
@@ -456,10 +456,14 @@ static void stripe_io_hints(struct dm_ta
 			    struct queue_limits *limits)
 {
 	struct stripe_c *sc = ti->private;
-	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
+	unsigned int io_min = sc->chunk_size << SECTOR_SHIFT;
+	unsigned int io_opt = io_min * sc->stripes;
 
-	limits->io_min = chunk_size;
-	limits->io_opt = chunk_size * sc->stripes;
+	if (io_min >> SECTOR_SHIFT == sc->chunk_size &&
+	    io_opt / sc->stripes == io_min) {
+		limits->io_min = io_min;
+		limits->io_opt = io_opt;
+	}
 }
 
 static struct target_type stripe_target = {

