Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C190418D
	for <dm-devel@lists.linux.dev>; Sat, 10 Aug 2024 02:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723257809; cv=none; b=As+Ag10SjRlBcDQZyQQBjKGfJ6/dAc+HaUls3tbPUFptyrYBzypHgYydEgPd40FGXBShaxN2L6o1frAVdviPlRsCkewV3OWDXZSI8Oydf4MkBmrwr7CTBy8yPeTwa2Eur/rAW0WAT8EQ70ewIFihmThSMwGR/pID92RCS+q0TRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723257809; c=relaxed/simple;
	bh=Nnklc57kgQVKL7OYZ9FYUZovUQHUW4fi5m9CECTwrY4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EcuKl0+sFqdakRP0iT/bSlhohAj2Hf9GyoUUQMV/wjtyd1dBMFCLYtCC+VA+dBK38KcjnYmgjllwDxxb3pSdpIAlcAuuWEkNmlANxqDm+w1k3RWIrJDSVjKT+SATCa1QqOfYqI718coHtBto8Db2dPre4NQFSISClxsBZLYNgT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SnH6WPcp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SnH6WPcp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723257804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RSrO/NKrsmJvmdaxwZHtZKIR9SDlRkqRKD3bv6f/JX0=;
	b=SnH6WPcp2m5gjJ7OAViV2pNw7+RvrTgPUvPJzfGEhWzZAKjjY6r9HHS87LczKIVayGpTrL
	b08JjLDlVEvlIHn/B/YYMKfuiBbweuym68Ti5H5ambSVQ3tNwxmd4gSkPFqzM4lMLKNb+b
	1pUiH/+Suw53LyCO6W3SgpS98Ke6VHE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-383-fmzAVDsJPYqowP82Q51ZTA-1; Fri,
 09 Aug 2024 22:43:22 -0400
X-MC-Unique: fmzAVDsJPYqowP82Q51ZTA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BAE641955BC1
	for <dm-devel@lists.linux.dev>; Sat, 10 Aug 2024 02:43:21 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F071F300018D;
	Sat, 10 Aug 2024 02:43:20 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 326A854756; Fri,  9 Aug 2024 22:43:20 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: don't refer to dedupe_context after releasing it
Date: Fri,  9 Aug 2024 22:43:20 -0400
Message-ID: <3363af9ad052e9158adbcf4bf73b77df32d8485c.1723248963.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Ken Raeburn <raeburn@redhat.com>

Clear the dedupe_context pointer in a data_vio whenever ownership of
the context is lost, so that vdo can't examine it accidentally.

Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/dedupe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 117266e1b3ae..28b41d5261f4 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -734,6 +734,7 @@ static void process_update_result(struct data_vio *agent)
 	    !change_context_state(context, DEDUPE_CONTEXT_COMPLETE, DEDUPE_CONTEXT_IDLE))
 		return;
 
+	agent->dedupe_context = NULL;
 	release_context(context);
 }
 
@@ -1653,6 +1654,7 @@ static void process_query_result(struct data_vio *agent)
 
 	if (change_context_state(context, DEDUPE_CONTEXT_COMPLETE, DEDUPE_CONTEXT_IDLE)) {
 		agent->is_duplicate = decode_uds_advice(context);
+		agent->dedupe_context = NULL;
 		release_context(context);
 	}
 }
@@ -2326,6 +2328,7 @@ static void timeout_index_operations_callback(struct vdo_completion *completion)
 		 * send its requestor on its way.
 		 */
 		list_del_init(&context->list_entry);
+		context->requestor->dedupe_context = NULL;
 		continue_data_vio(context->requestor);
 		timed_out++;
 	}
-- 
2.45.2

