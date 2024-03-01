Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7034450A65
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267939; cv=none; b=oIgYPyX1lXisMyOixhojTw6XAzSHIpapvdBcJPQWCiI5ZCpdvQtByfr4P0drBKqhyuEuvAv1rXIidVUfzhmTOpqFUnvXCnh1PBwyAEx2S1Wxgonszit+s/l/P66B4rApFmZNDtKX+OExkugz2VPJbf8mjfbO7/PsCWQTPiNiM6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267939; c=relaxed/simple;
	bh=xcB25sWy+L+B5E5QwqkjiQlDno1+TNAD630Q4ba8YQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gmyWiBoL+15FvdrUm2l99kkmKROxd9yHx8HBai7NDF6UDKHs8qe8LRdTxU4ckMs3HK7F4raFuegOYO8GjSGEeZh28Az/yUs8LJ5ZJP5yDN+1SIIdsaf4YAneekN1QQWIuvLh/yKS1AZxRIixuU9xbkboNQQKoxZAvaU7wTIVfgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LPE0LwTO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LPE0LwTO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ORwmwPNPb6J7sqONtX0zVWsVuK8gUpv0boCUbY+phNM=;
	b=LPE0LwTOKTlOkrmBnoKBZBGP4FCp4AvLFRa/o2toQlNePbCX8at+2Mi4clX7D+wu+t9oED
	Xv13tzUjqZ1xyiHhOp725Fmv3YZJF4ZLyN0sqaIPxzSuNzF2DWzVnsf+PNVNxCKdLyVvRO
	oBus9KP+epC/yceVCpitwx/EKHpqogk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-48PgtrifM5m8fdiO1kHVNA-1; Thu, 29 Feb 2024 23:38:54 -0500
X-MC-Unique: 48PgtrifM5m8fdiO1kHVNA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE1F083B8E6;
	Fri,  1 Mar 2024 04:38:53 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D838B200F829;
	Fri,  1 Mar 2024 04:38:53 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id D5945A162A; Thu, 29 Feb 2024 23:38:53 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 08/10] dm vdo encodings: update some stale comments
Date: Thu, 29 Feb 2024 23:38:51 -0500
Message-ID: <91132d19ad852107a04b72237fde5d43d68fe9c6.1709267597.git.msakai@redhat.com>
In-Reply-To: <cover.1709267597.git.msakai@redhat.com>
References: <cover.1709267597.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/encodings.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index e24c31bc3524..ebb0a4edd109 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -544,8 +544,6 @@ const char *vdo_get_journal_operation_name(enum journal_operation operation)
 
 /**
  * encode_slab_depot_state_2_0() - Encode the state of a slab depot into a buffer.
- *
- * Return: UDS_SUCCESS or an error.
  */
 static void encode_slab_depot_state_2_0(u8 *buffer, size_t *offset,
 					struct slab_depot_state_2_0 state)
@@ -573,7 +571,7 @@ static void encode_slab_depot_state_2_0(u8 *buffer, size_t *offset,
 /**
  * decode_slab_depot_state_2_0() - Decode slab depot component state version 2.0 from a buffer.
  *
- * Return: UDS_SUCCESS or an error code.
+ * Return: VDO_SUCCESS or an error code.
  */
 static int decode_slab_depot_state_2_0(u8 *buffer, size_t *offset,
 				       struct slab_depot_state_2_0 *state)
-- 
2.42.0

