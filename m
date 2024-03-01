Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D101550267
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267938; cv=none; b=DXMHrKv1sNukeLRWb5MBVGAte6S+Wjy3tMG19MwEdG+fUyLn0nd96pXulGoUV1Luoqr4iTVF5ePItGjw7rQp93JSkDSD6NEmm1wn5vQLP4Lig9o52WOkgSIvNI2uGsegxpt9Wh/jJ/TOtX0+CxI7lgYmwutgYL3nt63jLu6Uc5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267938; c=relaxed/simple;
	bh=gdpXyCqIZejhVKAtE4DNljZywHC7sU6KxI9IWRsKOkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sDIWCQcqLyKUUz+oUcxcMVMuyVgzOy/54GIAvqm/Oyq/hf1DUEyHyZya+00b1lJzpeJLrTL+oDVPzEoMa4YoNGAc3RJy0c0PPlb1s/GTP//5VS29OmPQCmMYE7LWrkyANNap2qnu/KrtlnyMuQ4/6nhx8qbG2tnRz0ng28GFrD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fiZ8BaGG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fiZ8BaGG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l1aGNI3Atv9hThApNrdQjmS4S9QibvEdBJGbPjck1xs=;
	b=fiZ8BaGGlpxvYg4SW7ZZssiByzIkRMp2C+FKlgiAcSYz4uYDXwI00W5BtAbFFS1r8NojXb
	9Z4pFpnH4wfaQURSIemGbEHnoWyGI53rtNEMd5zRo5quVks2WU8OHAbICvWIi+na7iX6gV
	Yh6bU0TX+w7bhsx1rLclpu0h0mPVyaE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-tWt5l-MMOPm3kx1_BTmvGw-1; Thu, 29 Feb 2024 23:38:54 -0500
X-MC-Unique: tWt5l-MMOPm3kx1_BTmvGw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8C011024D03;
	Fri,  1 Mar 2024 04:38:53 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E3436492BC6;
	Fri,  1 Mar 2024 04:38:53 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id E0C8CA162E; Thu, 29 Feb 2024 23:38:53 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 10/10] dm vdo target: eliminate inappropriate uses of UDS_SUCCESS
Date: Thu, 29 Feb 2024 23:38:53 -0500
Message-ID: <0c9af9a15a122f7e2035a0dd7693b7f593dfa693.1709267598.git.msakai@redhat.com>
In-Reply-To: <cover.1709267597.git.msakai@redhat.com>
References: <cover.1709267597.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Most should be VDO_SUCCESS.  But comparing the return from
kstrtouint() with UDS_SUCCESS (happens to be 0) makes no sense.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/dm-vdo-target.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index e493b2fec90b..5f607dbb16e9 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -318,7 +318,7 @@ static int split_string(const char *string, char separator, char ***substring_ar
 	current_substring++;
 	/* substrings[current_substring] is NULL already */
 	*substring_array_ptr = substrings;
-	return UDS_SUCCESS;
+	return VDO_SUCCESS;
 }
 
 /*
@@ -356,7 +356,7 @@ static int join_strings(char **substring_array, size_t array_length, char separa
 		*(current_position - 1) = '\0';
 
 	*string_ptr = output;
-	return UDS_SUCCESS;
+	return VDO_SUCCESS;
 }
 
 /**
@@ -484,7 +484,7 @@ static int parse_one_thread_config_spec(const char *spec,
 	int result;
 
 	result = split_string(spec, '=', &fields);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	if ((fields[0] == NULL) || (fields[1] == NULL) || (fields[2] != NULL)) {
@@ -495,7 +495,7 @@ static int parse_one_thread_config_spec(const char *spec,
 	}
 
 	result = kstrtouint(fields[1], 10, &count);
-	if (result != UDS_SUCCESS) {
+	if (result) {
 		uds_log_error("thread config string error: integer value needed, found \"%s\"",
 			      fields[1]);
 		free_string_array(fields);
@@ -537,7 +537,7 @@ static int parse_thread_config_string(const char *string,
 		unsigned int i;
 
 		result = split_string(string, ',', &specs);
-		if (result != UDS_SUCCESS)
+		if (result != VDO_SUCCESS)
 			return result;
 
 		for (i = 0; specs[i] != NULL; i++) {
@@ -607,7 +607,7 @@ static int parse_one_key_value_pair(const char *key, const char *value,
 
 	/* The remaining arguments must have integral values. */
 	result = kstrtouint(value, 10, &count);
-	if (result != UDS_SUCCESS) {
+	if (result) {
 		uds_log_error("optional config string error: integer value needed, found \"%s\"",
 			      value);
 		return result;
@@ -2913,7 +2913,7 @@ static int __init vdo_init(void)
 
 	/* Add VDO errors to the set of errors registered by the indexer. */
 	result = vdo_register_status_codes();
-	if (result != UDS_SUCCESS) {
+	if (result != VDO_SUCCESS) {
 		uds_log_error("vdo_register_status_codes failed %d", result);
 		vdo_module_destroy();
 		return result;
-- 
2.42.0

