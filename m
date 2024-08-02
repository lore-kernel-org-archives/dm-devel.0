Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE05F136327
	for <dm-devel@lists.linux.dev>; Fri,  2 Aug 2024 17:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722619626; cv=none; b=E60FgUoyK1ubvFNVKPNGxqoOX/voCY7bAaBJWlwKQisAKi9NWIFRPOyRBDo9FIFO6xmiBF/v7VJFG1GWcYPsVGGo1F/Eob9Twx0xfEWjYqKWsJ7oBMJbmnkrPy0ozyThXPJZgxMZSHNet9HrrAaLlBS1cIFd72ENtbNZGg2qY44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722619626; c=relaxed/simple;
	bh=jKWrvZ4r301vjNZKQRQSQZR2LdfQUyugiQkkYULJ6Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iPblZqbFpNsB3ns7o5EiZo45KEcsfhAd1tXkcJlPTpGfPoZVpgXPl/JFHbqMlilPj17mQKGmsEdRwU9oeULvBEtaKx4zRsXIiG8oLfTPj3GKsxcduFYfGtG+PlIVJQu/+TmGAP3zBAQIn4rTJPumHOb5W9H/pYgMxuRdM5XmNTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DT0m1DLV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DT0m1DLV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722619623;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Yj/1k0gpQ3sMgWyMtXhMfq+juUdwE4ZtgvWc5Gq3qig=;
	b=DT0m1DLVeER9wPsAtcZuWcE6nf1e12Coh6hwM4TddR6FgzGnEILJMPMJR7ReAQbsZAuVBs
	Hq4QTgD0id1IhbYzmmrsw1wN9FRhvPGnNuZxD3db7ZWZxTS7p7/ONa+rVziSMhX8TYnlaC
	ESuNJAQHkFD6bKdG+mEDSqJ76n3hOAk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-75-umJQDMd7MQSyuoUKgUtN6Q-1; Fri,
 02 Aug 2024 13:27:00 -0400
X-MC-Unique: umJQDMd7MQSyuoUKgUtN6Q-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 169A218B6680;
	Fri,  2 Aug 2024 17:26:57 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 22F931955EAB;
	Fri,  2 Aug 2024 17:26:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 472HQpD13063025
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 2 Aug 2024 13:26:51 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 472HQo6Q3063024;
	Fri, 2 Aug 2024 13:26:50 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] libmultipath: fix ontap prioritizer snprintf limits
Date: Fri,  2 Aug 2024 13:26:50 -0400
Message-ID: <20240802172650.3063016-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

The ontap prioritizer functions dump_cdb() and process_sg_error() both
incorrectly set the snprintf() limits larger than the available space.
Instead of multiplying the number of elements to print by the size of an
element to calculate the limit, they multiplied the number of elements
to print by the maximum number of elements that the buffer could hold.

Fix this, and also make sure that the number of elements to print is
less than or equal to the maximum number that the buffer can hold.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/prioritizers/ontap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/prioritizers/ontap.c b/libmultipath/prioritizers/ontap.c
index 117886ea..28e663ac 100644
--- a/libmultipath/prioritizers/ontap.c
+++ b/libmultipath/prioritizers/ontap.c
@@ -39,8 +39,8 @@ static void dump_cdb(unsigned char *cdb, int size)
 	char * p = &buf[0];
 
 	condlog(0, "- SCSI CDB: ");
-	for (i=0; i<size; i++) {
-		p += snprintf(p, 10*(size-i), "0x%02x ", cdb[i]);
+	for (i = 0; i < size && i < 10; i++) {
+		p += snprintf(p, 5*(size-i), "0x%02x ", cdb[i]);
 	}
 	condlog(0, "%s", buf);
 }
@@ -56,8 +56,8 @@ static void process_sg_error(struct sg_io_hdr *io_hdr)
 		io_hdr->host_status, io_hdr->driver_status);
 	if (io_hdr->sb_len_wr > 0) {
 		condlog(0, "- SCSI sense data: ");
-		for (i=0; i<io_hdr->sb_len_wr; i++) {
-			p += snprintf(p, 128*(io_hdr->sb_len_wr-i), "0x%02x ",
+		for (i = 0; i < io_hdr->sb_len_wr && i < 128; i++) {
+			p += snprintf(p, 5*(io_hdr->sb_len_wr-i), "0x%02x ",
 				      io_hdr->sbp[i]);
 		}
 		condlog(0, "%s", buf);
-- 
2.45.0

