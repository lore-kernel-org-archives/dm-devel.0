Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747B91F8AD2
	for <dm-devel@lists.linux.dev>; Tue,  3 Dec 2024 17:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733247548; cv=none; b=LxSOYmnssBuoz18iEErEUzFA62Xz9cKsLwqLB6EyhYP/wWzU661ZFrTuKvG60nxFtrEgIV3j8QOkMGguIHmpCsmTJ6hC4G06LX7+KNhM8OCPgQE/v8Z5TwjdfTnMQE3wxXQeN1m6CczMoN8+NITxqIM03s02lQ7hk68SdXWpH98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733247548; c=relaxed/simple;
	bh=cnf4vNSINpKH8eXM2kpr7r2gin3qLFoBtzgS2hpkGoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=FwRIWB5UIzsT5xrXIEzfmTuv8sQdSYzP82xgPFbCp2MjokQiWOkyjFInybKJe5KZJLEPW143PgM4pv7PppHFHNifoz6YEJZLW6dysXuHazlIDULr2xgucJ7EJOtVszq8EK/0JsPOOxbXKVNkNB129y/veHKJJt+NGlM78YlFqEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RyXY6swt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RyXY6swt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733247545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PVZwHTojO+ZL0SimvTlVGTrW6hfMS7wtkNK0d6n7hvg=;
	b=RyXY6swtMckJQiH7mYjQSWiTt0aRT7DElZmqs4ikk+MRuMxmp2xyrRrtKk53k8sk1Kd1nP
	XhAbmn9IFg1pDBLaLejHF1pioAASysRvGrjyyt8YwW1fmvaxzdo+SUXGf6d/TlDWr6Yevv
	loYRnfFqvmdT23eiadXbBRfjag53SVw=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-8Mn_iC-qOVac0haezrmTpQ-1; Tue,
 03 Dec 2024 12:39:03 -0500
X-MC-Unique: 8Mn_iC-qOVac0haezrmTpQ-1
X-Mimecast-MFC-AGG-ID: 8Mn_iC-qOVac0haezrmTpQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0988619560A2;
	Tue,  3 Dec 2024 17:39:03 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.67.24.41])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 708671956054;
	Tue,  3 Dec 2024 17:38:59 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH 1/3] dm array: fix releasing a faulty array block twice in dm_array_cursor_end
Date: Wed,  4 Dec 2024 01:38:49 +0800
Message-ID: <20241203173849.1258066-1-mtsai@redhat.com>
In-Reply-To: <20241203173658.1257887-1-mtsai@redhat.com>
References: <20241203173658.1257887-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5qACcumsKOxSc5ke4nrZUJ89Orpb_SSCpmfW433WVPc_1733247543
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When dm_bm_read_lock() fails due to locking or checksum errors, it
releases the faulty block implicitly while leaving an invalid output
pointer behind. The caller of dm_bm_read_lock() should not operate on
this invalid dm_block pointer, or it will lead to undefined result.
For example, the dm_array_cursor incorrectly caches the invalid pointer
on reading a faulty array block, causing a double release in
dm_array_cursor_end(), then hitting the BUG_ON in dm-bufio cache_put().

Reproduce steps:

1. initialize a cache device

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 65536 linear /dev/sdc 8192"
dmsetup create corig --table "0 524288 linear /dev/sdc $262144"
dd if=/dev/zero of=/dev/mapper/cmeta bs=4k count=1
dmsetup create cache --table "0 524288 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"

2. wipe the second array block offline

dmsteup remove cache cmeta cdata corig
mapping_root=$(dd if=/dev/sdc bs=1c count=8 skip=192 \
2>/dev/null | hexdump -e '1/8 "%u\n"')
ablock=$(dd if=/dev/sdc bs=1c count=8 skip=$((4096*mapping_root+2056)) \
2>/dev/null | hexdump -e '1/8 "%u\n"')
dd if=/dev/zero of=/dev/sdc bs=4k count=1 seek=$ablock

3. try reopen the cache device

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 65536 linear /dev/sdc 8192"
dmsetup create corig --table "0 524288 linear /dev/sdc $262144"
dmsetup create cache --table "0 524288 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"

Kernel logs:

(snip)
device-mapper: array: array_block_check failed: blocknr 0 != wanted 10
device-mapper: block manager: array validator check failed for block 10
device-mapper: array: get_ablock failed
device-mapper: cache metadata: dm_array_cursor_next for mapping failed
------------[ cut here ]------------
kernel BUG at drivers/md/dm-bufio.c:638!

Fix by setting the cached block pointer to NULL on errors.

Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Fixes: fdd1315aa5f0 ("dm array: introduce cursor api")
---
 drivers/md/persistent-data/dm-array.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persistent-data/dm-array.c
index 157c9bd2fed7..c46a374f7459 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -917,23 +917,28 @@ static int load_ablock(struct dm_array_cursor *c)
 	if (c->block)
 		unlock_ablock(c->info, c->block);
 
-	c->block = NULL;
-	c->ab = NULL;
 	c->index = 0;
 
 	r = dm_btree_cursor_get_value(&c->cursor, &key, &value_le);
 	if (r) {
 		DMERR("dm_btree_cursor_get_value failed");
 		dm_btree_cursor_end(&c->cursor);
+		goto out;
 
 	} else {
 		r = get_ablock(c->info, le64_to_cpu(value_le), &c->block, &c->ab);
 		if (r) {
 			DMERR("get_ablock failed");
 			dm_btree_cursor_end(&c->cursor);
+			goto out;
 		}
 	}
 
+	return 0;
+
+out:
+	c->block = NULL;
+	c->ab = NULL;
 	return r;
 }
 
-- 
2.47.0

