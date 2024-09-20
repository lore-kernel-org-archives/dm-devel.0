Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCA8605BA
	for <dm-devel@lists.linux.dev>; Fri, 20 Sep 2024 22:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726870654; cv=none; b=BOnTfoVPVn2xwMSA4hOz+h5sy8F1GKYPfhamShWVLqyiLuSjoYKZrhRBx585SgUxOKG6WnW3qp42GHG37UzYmCtFiiVRoVM6vZuMqgmTFVKMqGtr3oEa/3/D6LLywJSuhhNX8i56sMP4SSI8tOTwBrDiX0GWvRvx8W00zzEmr14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726870654; c=relaxed/simple;
	bh=/ugUuj3RCj7Yd6GkflH1ycW4iEaA5vAyGTszn11Sc3s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lA8/ZjbCLOPpFiWV4K86Nr/x0arFLy0yYwRvu+WNjzfvQGXmOGDITncsM24VGpBacC9IVHzjISr/lsxroZ+zU9xqr9rC9VKIzHr1A1lGHD58Bn2V+Wf4IetB9z+/7iSLYuQutlfYujA4pFYGN4fHbzkOOo0Pbm/OsXVE+yC9hMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fc6xBU9G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fc6xBU9G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726870652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MZO2dRFhI/rWcnvBm0+DN89YfSPrO7N4vc1GGTgs1Es=;
	b=fc6xBU9GxpkVfpAmQIUfzrrn/v6TT27z16jEOK60+/gIGZ4Y2CxlekoYJNj1QirbOByXL/
	D760FWgFomLUZ67GrYhr3DMMwGVEbiw+KhKg4JEkJInQ+/ufLyukAh5u4z3aYLKEwXMGdj
	cRZAktCOphgtlha5Vvxe4R0m1o8Ok8g=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-590-QIdhVkldMUOJtmeZlWGyQw-1; Fri,
 20 Sep 2024 18:17:30 -0400
X-MC-Unique: QIdhVkldMUOJtmeZlWGyQw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D01791979202;
	Fri, 20 Sep 2024 22:17:29 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4EDEF1956086;
	Fri, 20 Sep 2024 22:17:29 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id D76B357111; Fri, 20 Sep 2024 18:17:28 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Shen Lichuan <shenlichuan@vivo.com>,
	Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo indexer: convert comma to semicolon
Date: Fri, 20 Sep 2024 18:17:00 -0400
Message-ID: <107371783910d44c3d9774f892cb58d80b30191f.1726870078.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Shen Lichuan <shenlichuan@vivo.com>

To ensure code clarity and prevent potential errors, it's advisable
to employ the ';' as a statement separator, except when ',' are
intentionally used for specific purposes.

Signed-off-by: Shen Lichuan <shenlichuan@vivo.com>
Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/indexer/chapter-index.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/indexer/chapter-index.c b/drivers/md/dm-vdo/indexer/chapter-index.c
index 7e32a25d3f2f..fb1db41c794b 100644
--- a/drivers/md/dm-vdo/indexer/chapter-index.c
+++ b/drivers/md/dm-vdo/indexer/chapter-index.c
@@ -177,7 +177,7 @@ int uds_pack_open_chapter_index_page(struct open_chapter_index *chapter_index,
 			if (list_number < 0)
 				return UDS_OVERFLOW;
 
-			next_list = first_list + list_number--,
+			next_list = first_list + list_number--;
 			result = uds_start_delta_index_search(delta_index, next_list, 0,
 							      &entry);
 			if (result != UDS_SUCCESS)
-- 
2.45.2

