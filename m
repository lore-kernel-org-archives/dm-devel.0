Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93709DF59
	for <dm-devel@lists.linux.dev>; Tue, 15 Apr 2025 04:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744690645; cv=none; b=PnQ+3ri4B7Lr14OBFZ8M04GFI4QiJkdHWs+nSG4x4c7cxF+jGHeFf3JkEufy+/bvxfimgyceDzWN4/nrWNPq4qPEljJGJ13GITVyI2n1OfGQ991qssUiyrCy2WTYlZQ8E4LiH2emn1eqA/BRBp6HcVM0AhDWfxVsIdXut84WNq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744690645; c=relaxed/simple;
	bh=t7tlte9XR1yGo+ZXLD+kNYnOlGsgrwvJu1EfrhC1kJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=tEH6nIAdVHqVNTeTDtQEPcbZLcDGHT3rujVmg/Nspc0l8NzgLUxrediidsorHDlT5Va9MtRFG9ae3zqO1/aLrw4X+WtHsNGIwZPIOZaZasVOq4zF+KptgQcPkPpht69wf00MqRkfJouekXP8uAYoMEFxa5DUPoW4wfZqk0aac/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iZ/RZ7es; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iZ/RZ7es"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744690642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iRwe0SpqMPkreJ5BbYExewRYfqz5fdJQXffXbTWlAso=;
	b=iZ/RZ7esTBGXmiug3x8WVtPaC2VgAo4zDtq7/7z9qiNpIe59O2Be+97fEV8S5d0fc5PasW
	5sbRkM6M8h4kGuA1TPB8bjOPGUQWBW82ruAWaEvHn6Hn9KuMrv85NQvLJFlRIahhW/8H6n
	fCwfuLIiEIe1VhGEV2dUKjxFWy3E1jM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-668-RTJyX3L3MkSSTfMovyQyHQ-1; Tue,
 15 Apr 2025 00:17:20 -0400
X-MC-Unique: RTJyX3L3MkSSTfMovyQyHQ-1
X-Mimecast-MFC-AGG-ID: RTJyX3L3MkSSTfMovyQyHQ_1744690640
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C25B91808985
	for <dm-devel@lists.linux.dev>; Tue, 15 Apr 2025 04:17:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1BBF11956094;
	Tue, 15 Apr 2025 04:17:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53F4HHY5657027
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Apr 2025 00:17:17 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53F4HHVh657026;
	Tue, 15 Apr 2025 00:17:17 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 2/2] dm: always update the array size in realloc_argv on success
Date: Tue, 15 Apr 2025 00:17:16 -0400
Message-ID: <20250415041716.657008-3-bmarzins@redhat.com>
In-Reply-To: <20250415041716.657008-1-bmarzins@redhat.com>
References: <20250415041716.657008-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FMjxEp80hjMksrsP6li4jA0lJbxt9BMmy_hQO6t--Oc_1744690640
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

realloc_argv() was only updating the array size if it was called with
old_argv already allocated. The first time it was called to create an
argv array, it would allocate the array but return the array size as
zero. dm_split_args() would think that it couldn't store any arguments
in the array and would call realloc_argv() again, causing it to
reallocate the initial slots (this time using GPF_KERNEL) and finally
return a size. Aside from being wasteful, this could cause deadlocks on
targets that need to process messages without starting new IO. Instead,
realloc_argv should always update the allocated array size on success.

Fixes: a0651926553c ("dm table: don't copy from a NULL pointer in realloc_argv()")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-table.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 31e2f9071ca8..46b0e4813a73 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -522,9 +522,10 @@ static char **realloc_argv(unsigned int *size, char **old_argv)
 		gfp = GFP_NOIO;
 	}
 	argv = kmalloc_array(new_size, sizeof(*argv), gfp);
-	if (argv && old_argv) {
-		memcpy(argv, old_argv, *size * sizeof(*argv));
+	if (argv) {
 		*size = new_size;
+		if (old_argv)
+			memcpy(argv, old_argv, *size * sizeof(*argv));
 	}
 
 	kfree(old_argv);
-- 
2.48.1

