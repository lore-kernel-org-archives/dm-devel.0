Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0DA239085
	for <dm-devel@lists.linux.dev>; Mon, 12 Jan 2026 20:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768248937; cv=none; b=W174UwqHldLorrq/G/YhcJAccB2sw/nJogQyfJS3cK4Wx5oPlsEp5xaQ87yPLfHi8b6LensrMenQGsAhOuodVZ1JuDSoobEdp7i9UhPhTG4Ko/N4HvEfFfCuQW4hPT+e0BuAS1IvQVOK9duBA9fHjWxxrLoEgmN2/rTHkFZwO3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768248937; c=relaxed/simple;
	bh=hQvdtOqV2olEA88BkmOQMHVxqL4hSrcAeidYULvesJQ=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=TFFQ5fyZ87IyrbQEE0rZv5bCdROTfSneNWNNJAievh+xLc7ee7nMH9P+Jwu7O7Z819X+VrqqqQ8tbhK2J5+neAcuAMbIjAm8p7MyBdYhUvuUk0ixgKdldXjf3RzMpu1Y4q2lIIzEOvE8Og6cIYVDIJj3qUTH8qB7ojkTalxpa7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DgFoprCe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DgFoprCe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768248935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=30sZlRJnj8gCLR5OlLljur0B79KDzhMZ4eACr0FgnZ0=;
	b=DgFoprCe2OCoiOVlLZh5j6G6AXJSQyfGcccOoL9EEjvNsNpyE7POEXHimPG0hIvBtLo6z2
	KdlEmG9OPbkufItkacG98kzKKvdVgtdCHIEXkTQ7YsshrMom8vyp17c4qeliS0xID6OGKg
	0Y1VGMbq/JO8odxMATJHiHMtjIUisnA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-317-cKu6yVBrPYOoxbQniXQWZw-1; Mon,
 12 Jan 2026 15:15:33 -0500
X-MC-Unique: cKu6yVBrPYOoxbQniXQWZw-1
X-Mimecast-MFC-AGG-ID: cKu6yVBrPYOoxbQniXQWZw_1768248932
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 69A4618005B4;
	Mon, 12 Jan 2026 20:15:32 +0000 (UTC)
Received: from [10.44.33.27] (unknown [10.44.33.27])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D24C1180049F;
	Mon, 12 Jan 2026 20:15:30 +0000 (UTC)
Date: Mon, 12 Jan 2026 21:15:27 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Guangwu Zhang <guazhang@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-integrity: fix a typo in the code for write/discard
 race
Message-ID: <d381ea89-060d-cbed-1acf-c960904db2d8@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hfUE6jkKoafVX7RrJtByRuUrZ5UrgYyXhiM8TFb1l3s_1768248932
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

If we send a write followed by a discard, it may be possible that the 
discarded data end up being overwritten by the previous write from the 
journal. The code tries to prevent that, but there was a typo in this 
logic that made it not being activated as it should be.

Note that if we end up here the second time (when discard_retried is 
true), it means that the write bio is actually racing with the discard 
bio, and in this situation it is not specified which of them should win.

Cc: stable@vger.kernel.org
Fixes: 31843edab7cb ("dm integrity: improve discard in journal mode")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2026-01-12 20:46:39.000000000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2026-01-12 20:59:59.000000000 +0100
@@ -2411,7 +2411,7 @@ offload_to_thread:
 
 		new_pos = find_journal_node(ic, dio->range.logical_sector, &next_sector);
 		if (unlikely(new_pos != NOT_FOUND) ||
-		    unlikely(next_sector < dio->range.logical_sector - dio->range.n_sectors)) {
+		    unlikely(next_sector < dio->range.logical_sector + dio->range.n_sectors)) {
 			remove_range_unlocked(ic, &dio->range);
 			spin_unlock_irq(&ic->endio_wait.lock);
 			queue_work(ic->commit_wq, &ic->commit_work);

