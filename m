Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DAF2749EB
	for <dm-devel@lists.linux.dev>; Mon, 30 Jun 2025 13:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751289873; cv=none; b=sVHDzuyE8dkUKiw9dHExClg1NHWHQmcYpfBeL1psOUmdDzFqp69xja1sL8Z8vPoHybGsl7fVyHAl48s989mQoKiknT9gkJdHMEyN7VYBCbHbNNQzHTdJdjFrp3hlqdONIW9DnF/BgEWAhEG9npZEitqUiIHO8EwMw0pbQ5S0jq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751289873; c=relaxed/simple;
	bh=dZN89L/e6+4tOMpVRmkPF6ZEaU2uLKLsk1mtkblfkS4=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=VNZ28GbEvzM/CK2AerrholO3MYZWzxPH5EFpMMpcNdfcaRhXxdi38oTaafAkd+4rvRijpgtYrIlqkcM55VtYgkSQ6tlRL0k/8NSz6vdNusjpFKbfNLxsLdI6KC9sIcBs0xJHYWw12WTXv1aQRsJWZywHdFK0j1RlxjDTivfjrcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EN7PA+1R; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EN7PA+1R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751289870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=MnLCh2mvNGtS+98yTsotxoOlCqzk92Hh/4U+z8+AeVk=;
	b=EN7PA+1RNbYpsgeVqT4Vdp6NJHgOK5DAOyL1Z6Om2tgX+J4ZN/55FINhxt2sabbYdSKwly
	X698pgzM9ZYmbHMOMbPacpfFN3ieqyXPm37gPswdjk4cxNmFVRisYy4x66ONDvEGe1rWQI
	BBbeOQqyQMMRAbmPcv4vJ+8HK4LhvNM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-owYbA4jQPKGS9qDdu4wJ6A-1; Mon,
 30 Jun 2025 09:24:28 -0400
X-MC-Unique: owYbA4jQPKGS9qDdu4wJ6A-1
X-Mimecast-MFC-AGG-ID: owYbA4jQPKGS9qDdu4wJ6A_1751289868
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EC31B193F069;
	Mon, 30 Jun 2025 13:24:27 +0000 (UTC)
Received: from [10.22.80.10] (unknown [10.22.80.10])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 557F9195609D;
	Mon, 30 Jun 2025 13:24:26 +0000 (UTC)
Date: Mon, 30 Jun 2025 15:24:22 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH 2/2] dm-mpath: don't print the "loaded" message if registering
 fails
Message-ID: <b5c123af-f7d4-14b6-5d2f-40fa9d970eb9@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RIgmVa917g-3tmtzqo9kijEsqUgm1Ml-n4oiS0_D9VU_1751289868
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

If dm_register_path_selector, don't print the "version X loaded" message.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ps-historical-service-time.c |    4 +++-
 drivers/md/dm-ps-queue-length.c            |    4 +++-
 drivers/md/dm-ps-round-robin.c             |    4 +++-
 drivers/md/dm-ps-service-time.c            |    4 +++-
 4 files changed, 12 insertions(+), 4 deletions(-)

Index: linux-dm/drivers/md/dm-ps-queue-length.c
===================================================================
--- linux-dm.orig/drivers/md/dm-ps-queue-length.c
+++ linux-dm/drivers/md/dm-ps-queue-length.c
@@ -260,8 +260,10 @@ static int __init dm_ql_init(void)
 {
 	int r = dm_register_path_selector(&ql_ps);
 
-	if (r < 0)
+	if (r < 0) {
 		DMERR("register failed %d", r);
+		return r;
+	}
 
 	DMINFO("version " QL_VERSION " loaded");
 
Index: linux-dm/drivers/md/dm-ps-round-robin.c
===================================================================
--- linux-dm.orig/drivers/md/dm-ps-round-robin.c
+++ linux-dm/drivers/md/dm-ps-round-robin.c
@@ -220,8 +220,10 @@ static int __init dm_rr_init(void)
 {
 	int r = dm_register_path_selector(&rr_ps);
 
-	if (r < 0)
+	if (r < 0) {
 		DMERR("register failed %d", r);
+		return r;
+	}
 
 	DMINFO("version " RR_VERSION " loaded");
 
Index: linux-dm/drivers/md/dm-ps-historical-service-time.c
===================================================================
--- linux-dm.orig/drivers/md/dm-ps-historical-service-time.c
+++ linux-dm/drivers/md/dm-ps-historical-service-time.c
@@ -541,8 +541,10 @@ static int __init dm_hst_init(void)
 {
 	int r = dm_register_path_selector(&hst_ps);
 
-	if (r < 0)
+	if (r < 0) {
 		DMERR("register failed %d", r);
+		return r;
+	}
 
 	DMINFO("version " HST_VERSION " loaded");
 
Index: linux-dm/drivers/md/dm-ps-service-time.c
===================================================================
--- linux-dm.orig/drivers/md/dm-ps-service-time.c
+++ linux-dm/drivers/md/dm-ps-service-time.c
@@ -341,8 +341,10 @@ static int __init dm_st_init(void)
 {
 	int r = dm_register_path_selector(&st_ps);
 
-	if (r < 0)
+	if (r < 0) {
 		DMERR("register failed %d", r);
+		return r;
+	}
 
 	DMINFO("version " ST_VERSION " loaded");
 

