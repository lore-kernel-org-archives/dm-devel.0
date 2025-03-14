Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6238C1FE44E
	for <dm-devel@lists.linux.dev>; Fri, 14 Mar 2025 12:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741956705; cv=none; b=PIvyf2dFdmf+YXTaO8JVGI7GAinmvsDYehzxEuq54RS9n86mnAcN43Iq6fnh87Sk+czN5aFgyeAqDCs+UttLcfxLcvUt53E0O14zmdc8Wqz9n1GwKgKaLfwKjxEKAUM3vzXimitRhNo/9aWF/ABH2m6JNm9W11QRoz89/apZlqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741956705; c=relaxed/simple;
	bh=JqM/FPPd7dMUDWLOZJkRPiuDzkyWVoLMt5TKlNo765Y=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=NqcxQPcJCFeR9fl2fWJl7R1nLP2HkYurOn059hLYxfdcLs2lU2cF9zha2WvjBCjuvDmnolS/0nfvUXJbpG+/9wUjXyLlKvGZ+5VKWbda7tS9aIqYnF2jg1tqQpJVF/RL0UASkCPyr50hWp2BWcsKHWxQRA72y4WDyRIKuWv/5KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KHdQaHb1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KHdQaHb1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741956702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=Sw9PF8NAcnt/VEplfCnrouhbffYeH20ngMTIyxMUz8w=;
	b=KHdQaHb1TvO6fYJ7HXMoZozYZa2IksUhP+TUuXwfDoA1clshj2dpp0UWbDGOP+6x2RZHTT
	bSeg3ytAs2EqPMaaFcbZ4Vo4lbVljeBih/Rq78iv5lMUVB1R2+P/cQw6tll9SdI+FN0Cl5
	Ce6EWpBmLD2i5ew9UCJH5QADcUO/eqw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-633-GjPPRgCpMpyCkEM52h1Tbg-1; Fri,
 14 Mar 2025 08:51:39 -0400
X-MC-Unique: GjPPRgCpMpyCkEM52h1Tbg-1
X-Mimecast-MFC-AGG-ID: GjPPRgCpMpyCkEM52h1Tbg_1741956698
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 34B04180AB1C;
	Fri, 14 Mar 2025 12:51:38 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0E2BE1954B32;
	Fri, 14 Mar 2025 12:51:36 +0000 (UTC)
Date: Fri, 14 Mar 2025 13:51:32 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: dm-devel@lists.linux.dev
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH] dm: restrict dm device size to 2^63-512 bytes
Message-ID: <854e8253-ef2a-df98-e280-29db582f5ea2@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: R_hWw2MKcQNLcBlbhSBtfH_a74SD27BlcYhDeojDhLQ_1741956698
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The devices with size >= 2^63 bytes can't be used reliably by userspace
because the type off_t is a signed 64-bit integer.

Therefore, we limit the maximum size of a device mapper device to
2^63-512 bytes.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-table.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c	2025-02-24 12:41:49.000000000 +0100
+++ linux-2.6/drivers/md/dm-table.c	2025-03-14 13:42:13.000000000 +0100
@@ -697,6 +697,10 @@ int dm_table_add_target(struct dm_table
 		DMERR("%s: zero-length target", dm_device_name(t->md));
 		return -EINVAL;
 	}
+	if (start + len < start || start + len > LLONG_MAX >> SECTOR_SHIFT) {
+		DMERR("%s: too large device", dm_device_name(t->md));
+		return -EINVAL;
+	}
 
 	ti->type = dm_get_target_type(type);
 	if (!ti->type) {

