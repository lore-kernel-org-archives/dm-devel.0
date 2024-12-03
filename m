Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0841FC0E0
	for <dm-devel@lists.linux.dev>; Tue,  3 Dec 2024 17:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733248244; cv=none; b=nQ0Jx8fZ5oRl60F7Wd3tvf/uKuDZWQAvCOqJMBNwUnX+pTMNMXjdHnee0pyNiaMBbBZ0ubOZwz2EMwDiF7XJflBCZF2maPeNj2rONFLQsqiS3GmFBSVbHm8d5DlV2cAPHMyizJM6PN2FdeY6LFtWGDpBYghvL7lmkFR6M4Ko1/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733248244; c=relaxed/simple;
	bh=zIUHK65kTEHSdpveWrss+ErYIWT+4juOjNkAEt3H8pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=UogAGxmrgHTSA7xwwXatkMX2RbV43FqA3dyVyG/5G3msftciNIopic5atswnucK3cOCzLwmQJB/uJqlul3vzWnxL80RlBVKZ0mIfYRZ2gAbwPUSPpwSSiPUaOWUsrKCNwiJO2Jl1IonmPolwu9NjFlEDFWBtvW8lmH9kOI4lQj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LIWUKB2L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LIWUKB2L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733248241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HULijjWGV1+G9zVOYPCMw+7nNRhQ0FBn9s6ocOTMmuQ=;
	b=LIWUKB2Lw7eVB1A2o0LryeT+Kp41ORe0D4FYDRFkjIEFwgEZXJOQaAzlzqPx6vHPMpWvfF
	HlS+TelJDtKOAvIZaQ/wu9ktH91OVrhqk1D5I7gE/yEeucEYytS/2vCEITSgbfTVUFhxfZ
	3O9xKatv/wCLM1ELdoQCvObOSAN+2gc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-388-d0TVMtRXNjGZ16s6wdHT0w-1; Tue,
 03 Dec 2024 12:50:40 -0500
X-MC-Unique: d0TVMtRXNjGZ16s6wdHT0w-1
X-Mimecast-MFC-AGG-ID: d0TVMtRXNjGZ16s6wdHT0w
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8EB041955EB3;
	Tue,  3 Dec 2024 17:50:39 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.67.24.41])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1AD4F1955F2D;
	Tue,  3 Dec 2024 17:50:35 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH 3/3] dm array: fix cursor index when skipping across block boundaries
Date: Wed,  4 Dec 2024 01:50:29 +0800
Message-ID: <20241203175029.1259542-1-mtsai@redhat.com>
In-Reply-To: <20241203173756.1257967-1-mtsai@redhat.com>
References: <20241203173756.1257967-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HVmu_dsFYEqv2-QE8QhoK-2Yo1VwP1cDD5OwV7p43_Y_1733248239
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

dm_array_cursor_skip() seeks to the target position by loading array
blocks iteratively until the specified number of entries to skip is
reached. When seeking across block boundaries, it uses
dm_array_cursor_next() to step into the next block.
dm_array_cursor_skip() must first move the cursor index to the end
of the current block; otherwise, the cursor position could incorrectly
remain in the same block, causing the actual number of skipped entries
to be much smaller than expected.

This bug affects cache resizing in v2 metadata and could lead to data
loss if the fast device is shrunk during the first-time resume. For
example:

1. create a cache metadata consists of 32768 blocks, with a dirty block
   assigned to the second bitmap block. cache_restore v1.0 is required.

cat <<EOF >> cmeta.xml
<superblock uuid="" block_size="64" nr_cache_blocks="32768" \
policy="smq" hint_width="4">
  <mappings>
    <mapping cache_block="32767" origin_block="0" dirty="true"/>
  </mappings>
</superblock>
EOF
dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
cache_restore -i cmeta.xml -o /dev/mapper/cmeta --metadata-version=2

2. bring up the cache while attempt to discard all the blocks belonging
   to the second bitmap block (block# 32576 to 32767). The last command
   is expected to fail, but it actually succeeds.

dmsetup create cdata --table "0 2084864 linear /dev/sdc 8192"
dmsetup create corig --table "0 65536 linear /dev/sdc 2105344"
dmsetup create cache --table "0 65536 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 64 2 metadata2 writeback smq \
2 migration_threshold 0"

Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Fixes: 9b696229aa7d ("dm persistent data: add cursor skip functions to the cursor APIs")
---
 drivers/md/persistent-data/dm-array.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persistent-data/dm-array.c
index 1c3af717ee4f..b293da766fb1 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -1004,6 +1004,7 @@ int dm_array_cursor_skip(struct dm_array_cursor *c, uint32_t count)
 		}
 
 		count -= remaining;
+		c->index += (remaining - 1);
 		r = dm_array_cursor_next(c);
 
 	} while (!r);
-- 
2.47.0

