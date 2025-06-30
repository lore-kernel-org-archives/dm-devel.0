Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A44C1DFCB
	for <dm-devel@lists.linux.dev>; Mon, 30 Jun 2025 13:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751289799; cv=none; b=ALMO+LV1gbFRRNwVxNoQRpv4Lkmn0bB9dnwNuClJ7k76c/CXAfiQ8KZPe7OuxZUeDgZHXZGfY+uiwfeeFa2e+Y8Jv8giYTG3SDHvz2CX84Y5eem4UYeV9V6lkExNuBe+xtBQIY/tCyRno3H6ce8fYwmn6/nAn/yhgnLpOsKheUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751289799; c=relaxed/simple;
	bh=WCOjmVd86jrIKj4zIM+g9WafjLdxZ/HWzsysE2e9xAU=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=Km9ggOMdmMN3N265MHchVCoUhgdmNaLvDRM+Pr1dGMuZDqH2zop+dKbpnq8dJ7BWFby+2K/CMvwED90DlJFTDZC1fa5xtwUeWj7JQ2VmzGeuRh3MqCwmE2f5LHeVcO12YALfPO8jJxSu00pi0vCYU/7VEINVg60jOzKl/krz/pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hxcxvuMW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hxcxvuMW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751289794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=kLMXXd3JykuMEjm+8jzMK71qBQHhPUTJPKb7oN8puFk=;
	b=hxcxvuMWwgQRDDkxLMtrK5CawLDZt3fZkk9CKh4pzLI/q/N/04tDd75bTN0a7HRks0Obdc
	bkgOcV3o58SpoiNkA0hoTOsJulQSqNnrfRs9jTCNkkbgYpULJ9aSKWGXETJk7toipO1gYc
	bWnR/JD+iLudVQsSVWcdrp6Uca/PQ50=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-671-8tPREvfMNJyhLJG-VQICMw-1; Mon,
 30 Jun 2025 09:23:12 -0400
X-MC-Unique: 8tPREvfMNJyhLJG-VQICMw-1
X-Mimecast-MFC-AGG-ID: 8tPREvfMNJyhLJG-VQICMw_1751289788
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B5C851809C97;
	Mon, 30 Jun 2025 13:23:08 +0000 (UTC)
Received: from [10.22.80.10] (unknown [10.22.80.10])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A9C018003FC;
	Mon, 30 Jun 2025 13:23:06 +0000 (UTC)
Date: Mon, 30 Jun 2025 15:23:03 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH 1/2] dm-mpath: make dm_unregister_path_selector return void
Message-ID: <7cd0f0b3-42ba-6b88-d7b6-cb1453cd77ad@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6TaI9xlxuda_qjqjYG1ddg45SNwZ2LznVf5w-_o2cwM_1751289788
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

dm_unregister_path_selector may only return error if there's a bug in the
code - so we make it return void and print a warning if the user abuses
this function to unregister a target that was not registered.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-path-selector.c              |    8 +++-----
 drivers/md/dm-path-selector.h              |    2 +-
 drivers/md/dm-ps-historical-service-time.c |    5 +----
 drivers/md/dm-ps-io-affinity.c             |    5 +----
 drivers/md/dm-ps-queue-length.c            |    5 +----
 drivers/md/dm-ps-round-robin.c             |    5 +----
 drivers/md/dm-ps-service-time.c            |    5 +----
 7 files changed, 9 insertions(+), 26 deletions(-)

Index: linux-dm/drivers/md/dm-path-selector.c
===================================================================
--- linux-dm.orig/drivers/md/dm-path-selector.c
+++ linux-dm/drivers/md/dm-path-selector.c
@@ -117,16 +117,16 @@ int dm_register_path_selector(struct pat
 }
 EXPORT_SYMBOL_GPL(dm_register_path_selector);
 
-int dm_unregister_path_selector(struct path_selector_type *pst)
+void dm_unregister_path_selector(struct path_selector_type *pst)
 {
 	struct ps_internal *psi;
 
 	down_write(&_ps_lock);
 
 	psi = __find_path_selector_type(pst->name);
-	if (!psi) {
+	if (WARN_ON(!psi)) {
 		up_write(&_ps_lock);
-		return -EINVAL;
+		return;
 	}
 
 	list_del(&psi->list);
@@ -134,7 +134,5 @@ int dm_unregister_path_selector(struct p
 	up_write(&_ps_lock);
 
 	kfree(psi);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(dm_unregister_path_selector);
Index: linux-dm/drivers/md/dm-path-selector.h
===================================================================
--- linux-dm.orig/drivers/md/dm-path-selector.h
+++ linux-dm/drivers/md/dm-path-selector.h
@@ -96,7 +96,7 @@ struct path_selector_type {
 int dm_register_path_selector(struct path_selector_type *type);
 
 /* Unregister a path selector */
-int dm_unregister_path_selector(struct path_selector_type *type);
+void dm_unregister_path_selector(struct path_selector_type *type);
 
 /* Returns a registered path selector type */
 struct path_selector_type *dm_get_path_selector(const char *name);
Index: linux-dm/drivers/md/dm-ps-historical-service-time.c
===================================================================
--- linux-dm.orig/drivers/md/dm-ps-historical-service-time.c
+++ linux-dm/drivers/md/dm-ps-historical-service-time.c
@@ -551,10 +551,7 @@ static int __init dm_hst_init(void)
 
 static void __exit dm_hst_exit(void)
 {
-	int r = dm_unregister_path_selector(&hst_ps);
-
-	if (r < 0)
-		DMERR("unregister failed %d", r);
+	dm_unregister_path_selector(&hst_ps);
 }
 
 module_init(dm_hst_init);
Index: linux-dm/drivers/md/dm-ps-io-affinity.c
===================================================================
--- linux-dm.orig/drivers/md/dm-ps-io-affinity.c
+++ linux-dm/drivers/md/dm-ps-io-affinity.c
@@ -260,10 +260,7 @@ static int __init dm_ioa_init(void)
 
 static void __exit dm_ioa_exit(void)
 {
-	int ret = dm_unregister_path_selector(&ioa_ps);
-
-	if (ret < 0)
-		DMERR("unregister failed %d", ret);
+	dm_unregister_path_selector(&ioa_ps);
 }
 
 module_init(dm_ioa_init);
Index: linux-dm/drivers/md/dm-ps-queue-length.c
===================================================================
--- linux-dm.orig/drivers/md/dm-ps-queue-length.c
+++ linux-dm/drivers/md/dm-ps-queue-length.c
@@ -270,10 +270,7 @@ static int __init dm_ql_init(void)
 
 static void __exit dm_ql_exit(void)
 {
-	int r = dm_unregister_path_selector(&ql_ps);
-
-	if (r < 0)
-		DMERR("unregister failed %d", r);
+	dm_unregister_path_selector(&ql_ps);
 }
 
 module_init(dm_ql_init);
Index: linux-dm/drivers/md/dm-ps-round-robin.c
===================================================================
--- linux-dm.orig/drivers/md/dm-ps-round-robin.c
+++ linux-dm/drivers/md/dm-ps-round-robin.c
@@ -230,10 +230,7 @@ static int __init dm_rr_init(void)
 
 static void __exit dm_rr_exit(void)
 {
-	int r = dm_unregister_path_selector(&rr_ps);
-
-	if (r < 0)
-		DMERR("unregister failed %d", r);
+	dm_unregister_path_selector(&rr_ps);
 }
 
 module_init(dm_rr_init);
Index: linux-dm/drivers/md/dm-ps-service-time.c
===================================================================
--- linux-dm.orig/drivers/md/dm-ps-service-time.c
+++ linux-dm/drivers/md/dm-ps-service-time.c
@@ -351,10 +351,7 @@ static int __init dm_st_init(void)
 
 static void __exit dm_st_exit(void)
 {
-	int r = dm_unregister_path_selector(&st_ps);
-
-	if (r < 0)
-		DMERR("unregister failed %d", r);
+	dm_unregister_path_selector(&st_ps);
 }
 
 module_init(dm_st_init);

