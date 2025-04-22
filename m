Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF5721ADCC
	for <dm-devel@lists.linux.dev>; Tue, 22 Apr 2025 23:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745365665; cv=none; b=XRuWju/+HAal+6nrqKGuGspLPq/XJDi96lJlJVVJchJzOda+vXdHxs5phhdTzBqCgrPxq7e5u+7190ykjM2xQPk2OhV1IASQzwOKekGND5u60qypsI+iNG3Ltu/omqIR5U28Hya/Fz/UJhZIWTiHimEzS1sHwbk07yyLSFjjw1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745365665; c=relaxed/simple;
	bh=BP0Zp8XxoekMkZw8XaUu7AhfH8P/uSiu6SXidsQmBok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=OV3x/tUgH3XLJ/lm64Fs0ePjUyAy66HBAWK/t0gkHCUBic/owt+ZWWMTyzmJjKY+rD/7SSLJDSE3p0MJFouAHGpr7s3upwg9lBnNxYHo+JNmFtbu0vehCRJaU1Gklpv0qDyXK9TAwRtDgHfaqY3htiqtbWVpTf6jy8c+Lme+R+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M+OaDwhh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M+OaDwhh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745365662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r8kgoafE4QhDL8g+lhTEyoR8SNghlcfglOt6/eD2Wk4=;
	b=M+OaDwhhNwOJWvlisJrXcWrJRjLjF9oLsOKstdQrmO47o33xejxT3oUA9yHlk4jXLSlh2n
	NJ3WBRlAnVPg1YpEUhexRHDQZFDml8vEx+dGW2NqzswMrGL+l8iZuAAGxLDUov0W2lk5nZ
	8N4XIJeI/KEXHo/T1npHfvsj/YRuOeQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-195-Z4HjX-8-MeSLI8lFYHAsfw-1; Tue,
 22 Apr 2025 19:47:41 -0400
X-MC-Unique: Z4HjX-8-MeSLI8lFYHAsfw-1
X-Mimecast-MFC-AGG-ID: Z4HjX-8-MeSLI8lFYHAsfw_1745365660
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9ED8B1955DC5;
	Tue, 22 Apr 2025 23:47:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CBB07180087B;
	Tue, 22 Apr 2025 23:47:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53MNlc0E1654069
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 22 Apr 2025 19:47:38 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53MNlc2W1654068;
	Tue, 22 Apr 2025 19:47:38 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/4] dm-flakey: Clean up parsing messages
Date: Tue, 22 Apr 2025 19:47:35 -0400
Message-ID: <20250422234738.1654052-2-bmarzins@redhat.com>
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
X-Mimecast-MFC-PROC-ID: 3IPpj3cIQP_ZCtZooSFaO-XX_W6H1JlEEbbjrRAZMfA_1745365660
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

There were a number of cases where the error message for an invalid
table line did not match the actual problem. Fix these. Additionally,
error out when duplicate corrupt_bio_byte, random_read_corrupt, or
random_write_corrupt features are present. Also, error_reads is
incompatible with random_read_corrupt and corrupt_bio_byte with the READ
flag set, so disallow that.

Reported-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-flakey.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index b690905ab89f..f5f8d25d1b2d 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -128,8 +128,11 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 		 * corrupt_bio_byte <Nth_byte> <direction> <value> <bio_flags>
 		 */
 		if (!strcasecmp(arg_name, "corrupt_bio_byte")) {
-			if (!argc) {
-				ti->error = "Feature corrupt_bio_byte requires parameters";
+			if (fc->corrupt_bio_byte) {
+				ti->error = "Feature corrupt_bio_byte duplicated";
+				return -EINVAL;
+			} else if (argc < 4) {
+				ti->error = "Feature corrupt_bio_byte requires 4 parameters";
 				return -EINVAL;
 			}
 
@@ -176,7 +179,10 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 		}
 
 		if (!strcasecmp(arg_name, "random_read_corrupt")) {
-			if (!argc) {
+			if (fc->random_read_corrupt) {
+				ti->error = "Feature random_read_corrupt duplicated";
+				return -EINVAL;
+			} else if (!argc) {
 				ti->error = "Feature random_read_corrupt requires a parameter";
 				return -EINVAL;
 			}
@@ -189,7 +195,10 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 		}
 
 		if (!strcasecmp(arg_name, "random_write_corrupt")) {
-			if (!argc) {
+			if (fc->random_write_corrupt) {
+				ti->error = "Feature random_write_corrupt duplicated";
+				return -EINVAL;
+			} else if (!argc) {
 				ti->error = "Feature random_write_corrupt requires a parameter";
 				return -EINVAL;
 			}
@@ -205,12 +214,18 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 		return -EINVAL;
 	}
 
-	if (test_bit(DROP_WRITES, &fc->flags) && (fc->corrupt_bio_rw == WRITE)) {
-		ti->error = "drop_writes is incompatible with corrupt_bio_byte with the WRITE flag set";
+	if (test_bit(DROP_WRITES, &fc->flags) &&
+	    (fc->corrupt_bio_rw == WRITE || fc->random_write_corrupt)) {
+		ti->error = "drop_writes is incompatible with random_write_corrupt or corrupt_bio_byte with the WRITE flag set";
 		return -EINVAL;
 
-	} else if (test_bit(ERROR_WRITES, &fc->flags) && (fc->corrupt_bio_rw == WRITE)) {
-		ti->error = "error_writes is incompatible with corrupt_bio_byte with the WRITE flag set";
+	} else if (test_bit(ERROR_WRITES, &fc->flags) &&
+		   (fc->corrupt_bio_rw == WRITE || fc->random_write_corrupt)) {
+		ti->error = "error_writes is incompatible with random_write_corrupt or corrupt_bio_byte with the WRITE flag set";
+		return -EINVAL;
+	} else if (test_bit(ERROR_READS, &fc->flags) &&
+		   (fc->corrupt_bio_rw == READ || fc->random_read_corrupt)) {
+		ti->error = "error_reads is incompatible with random_read_corrupt or corrupt_bio_byte with the READ flag set";
 		return -EINVAL;
 	}
 
@@ -278,7 +293,7 @@ static int flakey_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (r)
 		goto bad;
 
-	r = dm_read_arg(_args, &as, &fc->down_interval, &ti->error);
+	r = dm_read_arg(_args + 1, &as, &fc->down_interval, &ti->error);
 	if (r)
 		goto bad;
 
-- 
2.48.1

