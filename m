Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EBC50241
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267937; cv=none; b=FlTWZIEC6Pl0EEgVS+gECsybkRYVbEZVBYI1LcyGQxFw25cVYaXYskU6mzCw86FiCdKE40C00sT5szve0Fzf9bqdLPgzhp4kn1ZTXhmqpbwiTbcQ/q27/IwZXzJFxHM6DZqgRDFjSEQT65iTmW93zYg3EuuC544TqQVkgmJiles=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267937; c=relaxed/simple;
	bh=rnR3/38I9YTx8CuIPb2i5NiLuIVBJd2wYOJc5ZMiOMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M1QMDRoTC4F/QKcz880PHqCDC+hJuiu4C1sspgMKG4YyrnfJTqg36iP38M8mH6FB5DqHPnZG1szUxaw0GVrmcPQU9C8X0KhC9+8C5WpXSfCNtv8pDOMUTsQ32skObyPJOin3aIU79HBEzH1eVkOsCQ4001Xmrl+BmBFJkZBjwac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lw9Yb7J0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lw9Yb7J0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y75cSizFVNQPtk55oIktHs+j39YJlAwspT63tgQZQuA=;
	b=Lw9Yb7J0FEf5rm1exKA3MtRuuI4nxoOuYmYjOo9xgRZEIvTKuLRq8rmKN+zLIwHhe/zpT3
	POUOdbURc9DoxRcwOE3+UJ4c8I/7v1dJ1aIU5ukCdvgzoFEnv5JlPWtY9jgJXrKArvv8zO
	Hd7A4XiUtFr0FaFhGHLZzWvoAvK68Ps=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-w0rGRkB6ONeFwHZ7khXQUA-1; Thu, 29 Feb 2024 23:38:54 -0500
X-MC-Unique: w0rGRkB6ONeFwHZ7khXQUA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CFB9C185A781;
	Fri,  1 Mar 2024 04:38:53 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CAF90112132A;
	Fri,  1 Mar 2024 04:38:53 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id C8A1EA1626; Thu, 29 Feb 2024 23:38:53 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 06/10] dm-vdo funnel-workqueue: return VDO_SUCCESS from make_simple_work_queue
Date: Thu, 29 Feb 2024 23:38:49 -0500
Message-ID: <24d79921a860066337c6c307654c141d6bb1c849.1709267597.git.msakai@redhat.com>
In-Reply-To: <cover.1709267597.git.msakai@redhat.com>
References: <cover.1709267597.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/funnel-workqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/funnel-workqueue.c b/drivers/md/dm-vdo/funnel-workqueue.c
index a88f5c93eae5..a923432f0a37 100644
--- a/drivers/md/dm-vdo/funnel-workqueue.c
+++ b/drivers/md/dm-vdo/funnel-workqueue.c
@@ -367,7 +367,7 @@ static int make_simple_work_queue(const char *thread_name_prefix, const char *na
 	wait_for_completion(&started);
 
 	*queue_ptr = queue;
-	return UDS_SUCCESS;
+	return VDO_SUCCESS;
 }
 
 /**
-- 
2.42.0

