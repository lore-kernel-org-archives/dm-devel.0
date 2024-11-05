Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376C88F45
	for <dm-devel@lists.linux.dev>; Tue,  5 Nov 2024 00:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730765978; cv=none; b=U2xR4tJvIZrVY257fD9tyrEPc6+eHEHZnf5i7V6SwSRvS3CB/kcczfrW+lrB71AxGq3M4S9dt5Z7ahuMy8HwQPAWRE2m/ELA+Sz7EVFMa+sh9ASAJb5V6ghsltjqgA2pSf04Hlienp1eynOiTLJdXELQC4s0RgmXYImgSHTjvUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730765978; c=relaxed/simple;
	bh=27IDacH0oaKgBeEP8BdjIUZ4y3m9EDnLdSrP/ECsjqk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=C3uhmObscMTEiA1Uf/xvZ+b+/3KJQsGyyPKwlbhuhqhfqMIZhY6daBFzJ/YYhFGAO7u2V1YtkurHCuq723K5Pl6hQ4m7opoOKPpWhQq2ogDzQMoOgKC34eWTOGSA84mRrMQliHcC0r7cpOPW8e87QrzHHQWZ9W3syeLyzdXYaGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mj6Upudm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mj6Upudm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730765975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8YUYn7gMv1xSEdsGG+iGU4O/CX7zDj9skEJdvSwxeWQ=;
	b=Mj6UpudmC3e+SClILFi/nea+OYqiO4h6ot4jTWpszoOwyT6URJABBsvTqHjD3U9wWykp50
	tKz3bZHlLpEFXn/P7x9rGuhP9r3rDbZWg5aO05PbM3LfLpH/k8yUAGYGqNClpufnhAUVwU
	jg2H+tMy8mV2S2BZo5RhTPg/YummfqU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-424-r8DN5b86ObiFEd5oNZDgBw-1; Mon,
 04 Nov 2024 19:19:33 -0500
X-MC-Unique: r8DN5b86ObiFEd5oNZDgBw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0FF2C19560A5
	for <dm-devel@lists.linux.dev>; Tue,  5 Nov 2024 00:19:33 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E04E91956086;
	Tue,  5 Nov 2024 00:19:32 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 4167359E65; Mon,  4 Nov 2024 19:19:32 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Susan LeGendre-McGhee <slegendr@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm-vdo: reset bi_ioprio to the default value when the bio is reset
Date: Mon,  4 Nov 2024 19:19:32 -0500
Message-ID: <20241105001932.866132-1-msakai@redhat.com>
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

From: Susan LeGendre-McGhee <slegendr@redhat.com>

Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/vio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-vdo/vio.c b/drivers/md/dm-vdo/vio.c
index b291578f726f..e710f3c5a972 100644
--- a/drivers/md/dm-vdo/vio.c
+++ b/drivers/md/dm-vdo/vio.c
@@ -202,6 +202,7 @@ int vio_reset_bio(struct vio *vio, char *data, bio_end_io_t callback,
 	if (data == NULL)
 		return VDO_SUCCESS;
 
+	bio->bi_ioprio = 0;
 	bio->bi_io_vec = bio->bi_inline_vecs;
 	bio->bi_max_vecs = vio->block_count + 1;
 	len = VDO_BLOCK_SIZE * vio->block_count;
-- 
2.45.2

