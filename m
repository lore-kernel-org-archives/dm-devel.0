Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1960921B9C5
	for <dm-devel@lists.linux.dev>; Tue, 22 Apr 2025 23:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745365668; cv=none; b=gKhSvogSF7yYl14I4fNV0Ar2JgSfhISH52LoIXHkQaRB+631lwbIJ2RwsJF8mbcMeP/b1xtkmN+Y2uUS4Tags8gHJUt29oORmjZX8WBegDQKmNaqygKIXeFf+ANocaqbc6oxPKGuppzQLUo91ttpVPx4LjHTdcTSy9cPmb5O8rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745365668; c=relaxed/simple;
	bh=hj10iYKmLrSaD3ONGuEwTNQmK3oq+s2w3aH/wi+b+nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=uMwfN2L7YVjBvNyhgQV5N/B1RdxSO0zdFt8zRpL0e4Br9AARYvD3m4d/IVOqr1PRtqne7Q+jOOAWIAppoGhSZ9Qo6x4g3y8QlJc9vh29BT9pGKouanG4Yt0kW6RUvgxd866Jdk+J0RK4L6P8SZld7RBLK93yyjue1gV1K3icNJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e4L2l6yn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e4L2l6yn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745365664;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZyEMYs3FBbU4DkHB3YK2wiC01QdFQ/VWRgHFTaSgVgc=;
	b=e4L2l6yn1RC0Oci5KcpDqYZ5TGN2McMt9+EQU1lZ/zfXDTcLU0WA39M1Vi+VF6bdHaHQbP
	GolURY3Rdg7A4aLMiY+fwRGdRVkjTMRxayjhby9hj0tsFuannoNHQY5ExrOBW5cEdoWiq+
	Ae0xgWedZc4VpjsCOJsDavrR4k1z3eE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-66-oxNu3prmOyWaYAOhhD93eQ-1; Tue,
 22 Apr 2025 19:47:41 -0400
X-MC-Unique: oxNu3prmOyWaYAOhhD93eQ-1
X-Mimecast-MFC-AGG-ID: oxNu3prmOyWaYAOhhD93eQ_1745365660
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F9CD19560BB;
	Tue, 22 Apr 2025 23:47:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D8D18180087C;
	Tue, 22 Apr 2025 23:47:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53MNlcuA1654073
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 22 Apr 2025 19:47:38 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53MNlcQU1654072;
	Tue, 22 Apr 2025 19:47:38 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/4] dm-flakey: error all IOs when num_features is absent
Date: Tue, 22 Apr 2025 19:47:36 -0400
Message-ID: <20250422234738.1654052-3-bmarzins@redhat.com>
In-Reply-To: <20250422234738.1654052-1-bmarzins@redhat.com>
References: <20250422234738.1654052-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -9VQl0v-B6ruXcQUWYtVWixpGIgCggTeNiYo7BNfUi0_1745365660
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

dm-flakey would error all IOs if num_features was 0, but if it was
absent, dm-flakey would never error any IO. Fix this so that no
num_features works the same as num_features set to 0.

Fixes: aa7d7bc99fed7 ("dm flakey: add an "error_reads" option")
Reported-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-flakey.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index f5f8d25d1b2d..35f1708b62e8 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -53,8 +53,8 @@ struct per_bio_data {
 static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 			  struct dm_target *ti)
 {
-	int r;
-	unsigned int argc;
+	int r = 0;
+	unsigned int argc = 0;
 	const char *arg_name;
 
 	static const struct dm_arg _args[] = {
@@ -65,14 +65,13 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 		{0, PROBABILITY_BASE, "Invalid random corrupt argument"},
 	};
 
-	/* No feature arguments supplied. */
-	if (!as->argc)
-		return 0;
-
-	r = dm_read_arg_group(_args, as, &argc, &ti->error);
-	if (r)
+	if (as->argc && (r = dm_read_arg_group(_args, as, &argc, &ti->error)))
 		return r;
 
+	/* No feature arguments supplied. */
+	if (!argc)
+		goto error_all_io;
+
 	while (argc) {
 		arg_name = dm_shift_arg(as);
 		argc--;
@@ -232,6 +231,7 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 	if (!fc->corrupt_bio_byte && !test_bit(ERROR_READS, &fc->flags) &&
 	    !test_bit(DROP_WRITES, &fc->flags) && !test_bit(ERROR_WRITES, &fc->flags) &&
 	    !fc->random_read_corrupt && !fc->random_write_corrupt) {
+error_all_io:
 		set_bit(ERROR_WRITES, &fc->flags);
 		set_bit(ERROR_READS, &fc->flags);
 	}
-- 
2.48.1

