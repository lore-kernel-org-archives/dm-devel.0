Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB283033CB
	for <dm-devel@lists.linux.dev>; Thu,  9 Jul 2026 19:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783625519; cv=none; b=cDYTojIFwDvs/wzJA7fPDNnt7j4tRfydpWEmiZB6mgUl4U6VCNlZ3egRR1eLmVwBRKhTHuF1uTYS8fRlW7fiodKOkgpofM7EBVQ6CSF7DnMyA1m9u7w3zsvWjOK39tPF4S7KUSA42zB+VAqEcXBLYKQcRrvjcOntcX5VWAmMLY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783625519; c=relaxed/simple;
	bh=/Ovxm74OdCWo1d/MSP+kVfNqbROPbsM2Z6DbTSk1Zm4=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=cMMWixg1C3rH9XbamVCRlKwan+b3aK6soWkSCwuDOSznocWwBebe80GNpimpba739uWAF94sThV5GpVSJG2rfAsmz46B3cT10dw1CFTJDQMHDnAS90czp6XzzC1HPeXbiEq+0GZGOobCCwFsdV9t+CWfCtZWCSO7dRgIQ8ZICtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DG1VzFs1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DG1VzFs1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783625517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=8zmUv9jG5kgb+iPqwjNUw80v6IHJRO+Gwba+57V+ApQ=;
	b=DG1VzFs1SQfDW5eT6m9225dTQ1CeYWme1XuObiWIwQamCf39nzJM2Jzs/ppHQlUh4AZ2Tn
	9ZqxX0kWeWdGWUiMwDkxESNavi5AzCjJxQoM7BedBft0TdioM9DxGzzpcQ8dkBffcOAYzX
	QT+DoItaNxFbD/Q7kXYhQQIpc95//d4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-117-1NSj5qUbPB6Z9uUVRrL32Q-1; Thu,
 09 Jul 2026 15:31:53 -0400
X-MC-Unique: 1NSj5qUbPB6Z9uUVRrL32Q-1
X-Mimecast-MFC-AGG-ID: 1NSj5qUbPB6Z9uUVRrL32Q_1783625513
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E10E819560B2;
	Thu,  9 Jul 2026 19:31:52 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A25881956053;
	Thu,  9 Jul 2026 19:31:51 +0000 (UTC)
Date: Thu, 9 Jul 2026 21:31:47 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-ioctl: fix a possible overflow in list_version_get_info
Message-ID: <8d88b184-e28e-f1fd-ceea-05d6c2292a06@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vi8qahvUZJRn_rBQ3WbVhQLgn3VxE6cXH-lfJM2DZvs_1783625513
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

sizeof(tt->version) is 12 bytes, but the code writes 16 bytes into the
output buffer - info->vers->version[0], info->vers->version[1],
info->vers->version[2] and info->vers->next. This can cause buffer
overflow.

Fix this buffer overflow by replacing "sizeof(tt->version)" with
"sizeof(struct dm_target_versions)".

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Cc: stable@vger.kernel.org

---
 drivers/md/dm-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c	2026-06-23 13:02:40.000000000 +0200
+++ linux-2.6/drivers/md/dm-ioctl.c	2026-06-23 14:17:22.000000000 +0200
@@ -698,7 +698,7 @@ static void list_version_get_info(struct
 	struct vers_iter *info = param;
 
 	/* Check space - it might have changed since the first iteration */
-	if ((char *)info->vers + sizeof(tt->version) + strlen(tt->name) + 1 > info->end) {
+	if ((char *)info->vers + sizeof(struct dm_target_versions) + strlen(tt->name) + 1 > info->end) {
 		info->flags = DM_BUFFER_FULL_FLAG;
 		return;
 	}

