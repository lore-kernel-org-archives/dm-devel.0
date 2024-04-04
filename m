Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EF313C3D9
	for <dm-devel@lists.linux.dev>; Thu,  4 Apr 2024 22:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712268754; cv=none; b=D++xkBGpYs5DIIhXLSQZWdlmUzSD+fQuDydCBcwXYOcoIcT68zGd0k1CuN8SE3cBLix5/whqQRPj3KlCIJt2BwbSPcInsxU55n2PUT8Yec0HJuzp945+z+9cT4BrlpAzK206kuMzW8Jq8oKw69nEhfjd8xy4CjzRUEp+JSRYUG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712268754; c=relaxed/simple;
	bh=DmGWog9moWgTabzlEmTKBjQRQ6o+D0HkAVcYwcW2KzY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uhfxqMVq0cMiVv4hTIkCOI6k+bydiNuIn6BZ2mc8+S2nYcRftdZbmCDzRD84icRSNAAtUSkSAiir7LgFSmrKveWJoHEWO/KPBFXTVBZKslPU4ZIaaJFUfdeZu0YQ/rwQokPNfyDiFPxLLVd1puXtpAtGbEWTN7MzZEmmyWLTLVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ei5Z1lV9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ei5Z1lV9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712268751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=a4TEh+0197uxXLuyrLy/CwyIqFufC2LbA/9gD9XB1Z0=;
	b=ei5Z1lV9P+xxbZRs8b4AC/kpF2jOPo2scbKdpzVIrFFxMjrYc1wd2V5HEX5T+RydGYJsej
	Oatk9bokmOYfvt8M8JhpGarh7YnNIk78sQ62lIiaboeIvyawBhVcUZy+kllQaMEMB+i3Mf
	RgnkBUyd1vkPvFM09jAOHGGceKvVcjk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-i27W4O2UNPGppex-o8RKzg-1; Thu, 04 Apr 2024 18:12:29 -0400
X-MC-Unique: i27W4O2UNPGppex-o8RKzg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CD5780C764
	for <dm-devel@lists.linux.dev>; Thu,  4 Apr 2024 22:12:29 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 45813492BCD;
	Thu,  4 Apr 2024 22:12:29 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 34B7DA49EF; Thu,  4 Apr 2024 18:12:29 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo murmurhash: remove unneeded semicolon
Date: Thu,  4 Apr 2024 18:12:29 -0400
Message-ID: <6c91d60e89daec6d49eb321868341637b396fc8c.1712268441.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202404050327.4ebVLBD3-lkp@intel.com/
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/murmurhash3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/murmurhash3.c b/drivers/md/dm-vdo/murmurhash3.c
index 01d2743444ec..3a989efae142 100644
--- a/drivers/md/dm-vdo/murmurhash3.c
+++ b/drivers/md/dm-vdo/murmurhash3.c
@@ -137,7 +137,7 @@ void murmurhash3_128(const void *key, const int len, const u32 seed, void *out)
 			break;
 		default:
 			break;
-		};
+		}
 	}
 	/* finalization */
 
-- 
2.42.0

