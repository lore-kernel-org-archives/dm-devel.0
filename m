Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE948EEAA66
	for <dm-devel@archiver.kernel.org>; Thu, 14 Sep 2023 19:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694719059;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=laiqlsQzfjh0aMDXHWuMU2f+FDUBiv1gaRnvBjX0Xjk=;
	b=Yanm2QNtddFuPwsEdVKFHr/bCyur6NmCjxyGL7ZvuEg/YFCvSwDaS6NnZP14G9irN0ObkB
	wvBxhnAkVdfq7+ZKH/hAI1NO4kKxVBkvBgmc/gayK3ZXd3DhKM193SI7LfUY6iwTJ0X2yx
	tDOTsO6pL2muzK8XgyR6VpCybOXYhkg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-BlduBiTUPOyse2vPfHDotA-1; Thu, 14 Sep 2023 15:17:36 -0400
X-MC-Unique: BlduBiTUPOyse2vPfHDotA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19EBD8279AA;
	Thu, 14 Sep 2023 19:17:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0185321CAC76;
	Thu, 14 Sep 2023 19:17:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EAB111946A70;
	Thu, 14 Sep 2023 19:17:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6CAF31946A50
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Sep 2023 19:16:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5ADD51678B; Thu, 14 Sep 2023 19:16:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 52D4E9A
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:16:58 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1837680523C
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:16:58 +0000 (UTC)
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com
 [209.85.217.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-5m66bVlmNPOM5HKynucwMw-1; Thu, 14 Sep 2023 15:16:56 -0400
X-MC-Unique: 5m66bVlmNPOM5HKynucwMw-1
Received: by mail-vs1-f42.google.com with SMTP id
 ada2fe7eead31-44d3e4ad403so717546137.0
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 12:16:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694719015; x=1695323815;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=dplNHtAzBZCWAcYeHYrzbxV169LKHR8neqyh1wH475Q=;
 b=iqJenr0BlQqCk9wybNY5GQou8LFk2dxfdoocbdeJfcpW3PhTKBAtPzvcKuVhuzerRv
 jWNEoY5H7qOAukgCb0AzXM3mH2RoqcodyJBzqL2uXFkmXMhVoVXdGyOS24AXXEbw2rEq
 ISXJWVKn255aR9ZNMFgfvw90hLOxfLYBWmX9Lpoeoh4fYIoxgGV+gs7fbfcNCClwn3L0
 /3OvGW3bcy06poU1v+D3oQwTlxjktCa2wEPQuL/IuxYksXi4iOWHXieC0K196DfIAoOw
 fI2KSL7mxoePexRhF4xzioDjcHzmieY4oOK3tVEXzdPtRKHyfUeisbceoIpxUOAb+ymk
 IRUw==
X-Gm-Message-State: AOJu0YwNCrWtWhRvh5Pv3L7+uG/lThfEGKDBBds1bRtCYuQUb6c46LFh
 cTGkR120mBNpeUfttJ81swrj7OBgJrZjFc1dMhqI3c84oK9XbpcW8bLnJSUxPwA4tFFDoHtJKJg
 lyG+hAtYyTPmfgAEQKrDpf2kRVnWWacthbRk4+sSrkCCIupJ6sAO5bQkagGd1X2Tr3GwSQ3+A
X-Google-Smtp-Source: AGHT+IEFSVLk4qzRFpzYXHNTM6z6QE9MarAZLUYb3sqhXRft72nYXEbs1zCSJTj3dDXjTH31JNPl+A==
X-Received: by 2002:a67:f883:0:b0:44d:5a92:ec43 with SMTP id
 h3-20020a67f883000000b0044d5a92ec43mr6169485vso.24.1694719014803; 
 Thu, 14 Sep 2023 12:16:54 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net.
 [68.160.141.91]) by smtp.gmail.com with ESMTPSA id
 p17-20020a0ce191000000b0064f4d3bc78csm663446qvl.61.2023.09.14.12.16.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Sep 2023 12:16:54 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Thu, 14 Sep 2023 15:16:05 -0400
Message-Id: <20230914191635.39805-10-snitzer@kernel.org>
In-Reply-To: <20230914191635.39805-1-snitzer@kernel.org>
References: <20230914191635.39805-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH v3 09/39] dm vdo: add deduplication configuration
 structures
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Matthew Sakai <msakai@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Matthew Sakai <msakai@redhat.com>

Add structures which record the configuration of various deduplication
index parameters. This also includes facilities for saving and loading
the configuration and validating its integrity.

Co-developed-by: J. corwin Coburn <corwin@hurlbutnet.net>
Signed-off-by: J. corwin Coburn <corwin@hurlbutnet.net>
Co-developed-by: Michael Sclafani <vdo-devel@redhat.com>
Signed-off-by: Michael Sclafani <vdo-devel@redhat.com>
Co-developed-by: Thomas Jaskiewicz <tom@jaskiewicz.us>
Signed-off-by: Thomas Jaskiewicz <tom@jaskiewicz.us>
Co-developed-by: John Wiele <jwiele@redhat.com>
Signed-off-by: John Wiele <jwiele@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-vdo/config.c   | 389 +++++++++++++++++++++++++++++++++++
 drivers/md/dm-vdo/config.h   | 125 +++++++++++
 drivers/md/dm-vdo/geometry.c | 205 ++++++++++++++++++
 drivers/md/dm-vdo/geometry.h | 137 ++++++++++++
 4 files changed, 856 insertions(+)
 create mode 100644 drivers/md/dm-vdo/config.c
 create mode 100644 drivers/md/dm-vdo/config.h
 create mode 100644 drivers/md/dm-vdo/geometry.c
 create mode 100644 drivers/md/dm-vdo/geometry.h

diff --git a/drivers/md/dm-vdo/config.c b/drivers/md/dm-vdo/config.c
new file mode 100644
index 000000000000..18ec44faf0b0
--- /dev/null
+++ b/drivers/md/dm-vdo/config.c
@@ -0,0 +1,389 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2023 Red Hat
+ */
+
+#include "config.h"
+
+#include "logger.h"
+#include "memory-alloc.h"
+#include "numeric.h"
+#include "string-utils.h"
+#include "uds-threads.h"
+
+static const u8 INDEX_CONFIG_MAGIC[] = "ALBIC";
+static const u8 INDEX_CONFIG_VERSION_6_02[] = "06.02";
+static const u8 INDEX_CONFIG_VERSION_8_02[] = "08.02";
+
+enum {
+	DEFAULT_VOLUME_READ_THREADS = 2,
+	MAX_VOLUME_READ_THREADS = 16,
+	INDEX_CONFIG_MAGIC_LENGTH = sizeof(INDEX_CONFIG_MAGIC) - 1,
+	INDEX_CONFIG_VERSION_LENGTH = sizeof(INDEX_CONFIG_VERSION_6_02) - 1,
+};
+
+static bool is_version(const u8 *version, u8 *buffer)
+{
+	return memcmp(version, buffer, INDEX_CONFIG_VERSION_LENGTH) == 0;
+}
+
+static bool are_matching_configurations(struct configuration *saved_config,
+					struct geometry *saved_geometry,
+					struct configuration *user)
+{
+	struct geometry *geometry = user->geometry;
+	bool result = true;
+
+	if (saved_geometry->record_pages_per_chapter != geometry->record_pages_per_chapter) {
+		uds_log_error("Record pages per chapter (%u) does not match (%u)",
+			      saved_geometry->record_pages_per_chapter,
+			      geometry->record_pages_per_chapter);
+		result = false;
+	}
+
+	if (saved_geometry->chapters_per_volume != geometry->chapters_per_volume) {
+		uds_log_error("Chapter count (%u) does not match (%u)",
+			      saved_geometry->chapters_per_volume,
+			      geometry->chapters_per_volume);
+		result = false;
+	}
+
+	if (saved_geometry->sparse_chapters_per_volume != geometry->sparse_chapters_per_volume) {
+		uds_log_error("Sparse chapter count (%u) does not match (%u)",
+			      saved_geometry->sparse_chapters_per_volume,
+			      geometry->sparse_chapters_per_volume);
+		result = false;
+	}
+
+	if (saved_config->cache_chapters != user->cache_chapters) {
+		uds_log_error("Cache size (%u) does not match (%u)",
+			      saved_config->cache_chapters,
+			      user->cache_chapters);
+		result = false;
+	}
+
+	if (saved_config->volume_index_mean_delta != user->volume_index_mean_delta) {
+		uds_log_error("Volume index mean delta (%u) does not match (%u)",
+			      saved_config->volume_index_mean_delta,
+			      user->volume_index_mean_delta);
+		result = false;
+	}
+
+	if (saved_geometry->bytes_per_page != geometry->bytes_per_page) {
+		uds_log_error("Bytes per page value (%zu) does not match (%zu)",
+			      saved_geometry->bytes_per_page,
+			      geometry->bytes_per_page);
+		result = false;
+	}
+
+	if (saved_config->sparse_sample_rate != user->sparse_sample_rate) {
+		uds_log_error("Sparse sample rate (%u) does not match (%u)",
+			      saved_config->sparse_sample_rate,
+			      user->sparse_sample_rate);
+		result = false;
+	}
+
+	if (saved_config->nonce != user->nonce) {
+		uds_log_error("Nonce (%llu) does not match (%llu)",
+			      (unsigned long long) saved_config->nonce,
+			      (unsigned long long) user->nonce);
+		result = false;
+	}
+
+	return result;
+}
+
+/* Read the configuration and validate it against the provided one. */
+int uds_validate_config_contents(struct buffered_reader *reader, struct configuration *user_config)
+{
+	int result;
+	struct configuration config;
+	struct geometry geometry;
+	u8 version_buffer[INDEX_CONFIG_VERSION_LENGTH];
+	u32 bytes_per_page;
+	u8 buffer[sizeof(struct uds_configuration_6_02)];
+	size_t offset = 0;
+
+	result = uds_verify_buffered_data(reader, INDEX_CONFIG_MAGIC, INDEX_CONFIG_MAGIC_LENGTH);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = uds_read_from_buffered_reader(reader,
+					       version_buffer,
+					       INDEX_CONFIG_VERSION_LENGTH);
+	if (result != UDS_SUCCESS)
+		return uds_log_error_strerror(result, "cannot read index config version");
+
+	if (!is_version(INDEX_CONFIG_VERSION_6_02, version_buffer) &&
+	    !is_version(INDEX_CONFIG_VERSION_8_02, version_buffer)) {
+		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+					      "unsupported configuration version: '%.*s'",
+					      INDEX_CONFIG_VERSION_LENGTH,
+					      version_buffer);
+	}
+
+	result = uds_read_from_buffered_reader(reader, buffer, sizeof(buffer));
+	if (result != UDS_SUCCESS)
+		return uds_log_error_strerror(result, "cannot read config data");
+
+	decode_u32_le(buffer, &offset, &geometry.record_pages_per_chapter);
+	decode_u32_le(buffer, &offset, &geometry.chapters_per_volume);
+	decode_u32_le(buffer, &offset, &geometry.sparse_chapters_per_volume);
+	decode_u32_le(buffer, &offset, &config.cache_chapters);
+	offset += sizeof(u32);
+	decode_u32_le(buffer, &offset, &config.volume_index_mean_delta);
+	decode_u32_le(buffer, &offset, &bytes_per_page);
+	geometry.bytes_per_page = bytes_per_page;
+	decode_u32_le(buffer, &offset, &config.sparse_sample_rate);
+	decode_u64_le(buffer, &offset, &config.nonce);
+
+	result = ASSERT(offset == sizeof(struct uds_configuration_6_02),
+			"%zu bytes read but not decoded",
+			sizeof(struct uds_configuration_6_02) - offset);
+	if (result != UDS_SUCCESS)
+		return UDS_CORRUPT_DATA;
+
+	if (is_version(INDEX_CONFIG_VERSION_6_02, version_buffer)) {
+		user_config->geometry->remapped_virtual = 0;
+		user_config->geometry->remapped_physical = 0;
+	} else {
+		u8 remapping[sizeof(u64) + sizeof(u64)];
+
+		result = uds_read_from_buffered_reader(reader, remapping, sizeof(remapping));
+		if (result != UDS_SUCCESS)
+			return uds_log_error_strerror(result, "cannot read converted config");
+
+		offset = 0;
+		decode_u64_le(remapping, &offset, &user_config->geometry->remapped_virtual);
+		decode_u64_le(remapping, &offset, &user_config->geometry->remapped_physical);
+	}
+
+	if (!are_matching_configurations(&config, &geometry, user_config)) {
+		uds_log_warning("Supplied configuration does not match save");
+		return UDS_NO_INDEX;
+	}
+
+	return UDS_SUCCESS;
+}
+
+/*
+ * Write the configuration to stable storage. If the superblock version is < 4, write the 6.02
+ * version; otherwise write the 8.02 version, indicating the configuration is for an index that has
+ * been reduced by one chapter.
+ */
+int uds_write_config_contents(struct buffered_writer *writer,
+			      struct configuration *config,
+			      u32 version)
+{
+	int result;
+	struct geometry *geometry = config->geometry;
+	u8 buffer[sizeof(struct uds_configuration_8_02)];
+	size_t offset = 0;
+
+	result = uds_write_to_buffered_writer(writer,
+					      INDEX_CONFIG_MAGIC,
+					      INDEX_CONFIG_MAGIC_LENGTH);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	/*
+	 * If version is < 4, the index has not been reduced by a chapter so it must be written out
+	 * as version 6.02 so that it is still compatible with older versions of UDS.
+	 */
+	if (version >= 4) {
+		result = uds_write_to_buffered_writer(writer,
+						      INDEX_CONFIG_VERSION_8_02,
+						      INDEX_CONFIG_VERSION_LENGTH);
+		if (result != UDS_SUCCESS)
+			return result;
+	} else {
+		result = uds_write_to_buffered_writer(writer,
+						      INDEX_CONFIG_VERSION_6_02,
+						      INDEX_CONFIG_VERSION_LENGTH);
+		if (result != UDS_SUCCESS)
+			return result;
+	}
+
+	encode_u32_le(buffer, &offset, geometry->record_pages_per_chapter);
+	encode_u32_le(buffer, &offset, geometry->chapters_per_volume);
+	encode_u32_le(buffer, &offset, geometry->sparse_chapters_per_volume);
+	encode_u32_le(buffer, &offset, config->cache_chapters);
+	encode_u32_le(buffer, &offset, 0);
+	encode_u32_le(buffer, &offset, config->volume_index_mean_delta);
+	encode_u32_le(buffer, &offset, geometry->bytes_per_page);
+	encode_u32_le(buffer, &offset, config->sparse_sample_rate);
+	encode_u64_le(buffer, &offset, config->nonce);
+
+	result = ASSERT(offset == sizeof(struct uds_configuration_6_02),
+			"%zu bytes encoded, of %zu expected",
+			offset,
+			sizeof(struct uds_configuration_6_02));
+	if (result != UDS_SUCCESS)
+		return result;
+
+	if (version >= 4) {
+		encode_u64_le(buffer, &offset, geometry->remapped_virtual);
+		encode_u64_le(buffer, &offset, geometry->remapped_physical);
+	}
+
+	return uds_write_to_buffered_writer(writer, buffer, offset);
+}
+
+/* Compute configuration parameters that depend on memory size. */
+static int compute_memory_sizes(uds_memory_config_size_t mem_gb,
+				bool sparse,
+				u32 *chapters_per_volume,
+				u32 *record_pages_per_chapter,
+				u32 *sparse_chapters_per_volume)
+{
+	u32 reduced_chapters = 0;
+	u32 base_chapters;
+
+	if (mem_gb == UDS_MEMORY_CONFIG_256MB) {
+		base_chapters = DEFAULT_CHAPTERS_PER_VOLUME;
+		*record_pages_per_chapter = SMALL_RECORD_PAGES_PER_CHAPTER;
+	} else if (mem_gb == UDS_MEMORY_CONFIG_512MB) {
+		base_chapters = DEFAULT_CHAPTERS_PER_VOLUME;
+		*record_pages_per_chapter = 2 * SMALL_RECORD_PAGES_PER_CHAPTER;
+	} else if (mem_gb == UDS_MEMORY_CONFIG_768MB) {
+		base_chapters = DEFAULT_CHAPTERS_PER_VOLUME;
+		*record_pages_per_chapter = 3 * SMALL_RECORD_PAGES_PER_CHAPTER;
+	} else if ((mem_gb >= 1) && (mem_gb <= UDS_MEMORY_CONFIG_MAX)) {
+		base_chapters = mem_gb * DEFAULT_CHAPTERS_PER_VOLUME;
+		*record_pages_per_chapter = DEFAULT_RECORD_PAGES_PER_CHAPTER;
+	} else if (mem_gb == UDS_MEMORY_CONFIG_REDUCED_256MB) {
+		reduced_chapters = 1;
+		base_chapters = DEFAULT_CHAPTERS_PER_VOLUME;
+		*record_pages_per_chapter = SMALL_RECORD_PAGES_PER_CHAPTER;
+	} else if (mem_gb == UDS_MEMORY_CONFIG_REDUCED_512MB) {
+		reduced_chapters = 1;
+		base_chapters = DEFAULT_CHAPTERS_PER_VOLUME;
+		*record_pages_per_chapter = 2 * SMALL_RECORD_PAGES_PER_CHAPTER;
+	} else if (mem_gb == UDS_MEMORY_CONFIG_REDUCED_768MB) {
+		reduced_chapters = 1;
+		base_chapters = DEFAULT_CHAPTERS_PER_VOLUME;
+		*record_pages_per_chapter = 3 * SMALL_RECORD_PAGES_PER_CHAPTER;
+	} else if ((mem_gb >= 1 + UDS_MEMORY_CONFIG_REDUCED) &&
+		   (mem_gb <= UDS_MEMORY_CONFIG_REDUCED_MAX)) {
+		reduced_chapters = 1;
+		base_chapters = ((mem_gb - UDS_MEMORY_CONFIG_REDUCED) *
+				 DEFAULT_CHAPTERS_PER_VOLUME);
+		*record_pages_per_chapter = DEFAULT_RECORD_PAGES_PER_CHAPTER;
+	} else {
+		uds_log_error("received invalid memory size");
+		return -EINVAL;
+	}
+
+	if (sparse) {
+		/* Make 95% of chapters sparse, allowing 10x more records. */
+		*sparse_chapters_per_volume = (19 * base_chapters) / 2;
+		base_chapters *= 10;
+	} else {
+		*sparse_chapters_per_volume = 0;
+	}
+
+	*chapters_per_volume = base_chapters - reduced_chapters;
+	return UDS_SUCCESS;
+}
+
+static unsigned int __must_check normalize_zone_count(unsigned int requested)
+{
+	unsigned int zone_count = requested;
+
+	if (zone_count == 0)
+		zone_count = num_online_cpus() / 2;
+
+	if (zone_count < 1)
+		zone_count = 1;
+
+	if (zone_count > MAX_ZONES)
+		zone_count = MAX_ZONES;
+
+	uds_log_info("Using %u indexing zone%s for concurrency.",
+		     zone_count,
+		     zone_count == 1 ? "" : "s");
+	return zone_count;
+}
+
+static unsigned int __must_check normalize_read_threads(unsigned int requested)
+{
+	unsigned int read_threads = requested;
+
+	if (read_threads < 1)
+		read_threads = DEFAULT_VOLUME_READ_THREADS;
+
+	if (read_threads > MAX_VOLUME_READ_THREADS)
+		read_threads = MAX_VOLUME_READ_THREADS;
+
+	return read_threads;
+}
+
+int uds_make_configuration(const struct uds_parameters *params, struct configuration **config_ptr)
+{
+	struct configuration *config;
+	u32 chapters_per_volume = 0;
+	u32 record_pages_per_chapter = 0;
+	u32 sparse_chapters_per_volume = 0;
+	int result;
+
+	result = compute_memory_sizes(params->memory_size,
+				      params->sparse,
+				      &chapters_per_volume,
+				      &record_pages_per_chapter,
+				      &sparse_chapters_per_volume);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = UDS_ALLOCATE(1, struct configuration, __func__, &config);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = uds_make_geometry(DEFAULT_BYTES_PER_PAGE,
+				   record_pages_per_chapter,
+				   chapters_per_volume,
+				   sparse_chapters_per_volume,
+				   0,
+				   0,
+				   &config->geometry);
+	if (result != UDS_SUCCESS) {
+		uds_free_configuration(config);
+		return result;
+	}
+
+	config->zone_count = normalize_zone_count(params->zone_count);
+	config->read_threads = normalize_read_threads(params->read_threads);
+
+	config->cache_chapters = DEFAULT_CACHE_CHAPTERS;
+	config->volume_index_mean_delta = DEFAULT_VOLUME_INDEX_MEAN_DELTA;
+	config->sparse_sample_rate = (params->sparse ? DEFAULT_SPARSE_SAMPLE_RATE : 0);
+	config->nonce = params->nonce;
+	config->name = params->name;
+	config->offset = params->offset;
+	config->size = params->size;
+
+	*config_ptr = config;
+	return UDS_SUCCESS;
+}
+
+void uds_free_configuration(struct configuration *config)
+{
+	if (config != NULL) {
+		uds_free_geometry(config->geometry);
+		UDS_FREE(config);
+	}
+}
+
+void uds_log_configuration(struct configuration *config)
+{
+	struct geometry *geometry = config->geometry;
+
+	uds_log_debug("Configuration:");
+	uds_log_debug("  Record pages per chapter:   %10u", geometry->record_pages_per_chapter);
+	uds_log_debug("  Chapters per volume:        %10u", geometry->chapters_per_volume);
+	uds_log_debug("  Sparse chapters per volume: %10u", geometry->sparse_chapters_per_volume);
+	uds_log_debug("  Cache size (chapters):      %10u", config->cache_chapters);
+	uds_log_debug("  Volume index mean delta:    %10u", config->volume_index_mean_delta);
+	uds_log_debug("  Bytes per page:             %10zu", geometry->bytes_per_page);
+	uds_log_debug("  Sparse sample rate:         %10u", config->sparse_sample_rate);
+	uds_log_debug("  Nonce:                      %llu", (unsigned long long) config->nonce);
+}
diff --git a/drivers/md/dm-vdo/config.h b/drivers/md/dm-vdo/config.h
new file mode 100644
index 000000000000..d5120412b885
--- /dev/null
+++ b/drivers/md/dm-vdo/config.h
@@ -0,0 +1,125 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2023 Red Hat
+ */
+
+#ifndef UDS_CONFIG_H
+#define UDS_CONFIG_H
+
+#include "geometry.h"
+#include "io-factory.h"
+#include "uds.h"
+
+/*
+ * The configuration records a variety of parameters used to configure a new UDS index. Some
+ * parameters are provided by the client, while others are fixed or derived from user-supplied
+ * values. It is created when an index is created, and it is recorded in the index metadata.
+ */
+
+enum {
+	DEFAULT_VOLUME_INDEX_MEAN_DELTA = 4096,
+	DEFAULT_CACHE_CHAPTERS = 7,
+	DEFAULT_SPARSE_SAMPLE_RATE = 32,
+	MAX_ZONES = 16,
+};
+
+/* A set of configuration parameters for the indexer. */
+struct configuration {
+	/* String describing the storage device */
+	const char *name;
+
+	/* The maximum allowable size of the index */
+	size_t size;
+
+	/* The offset where the index should start */
+	off_t offset;
+
+	/* Parameters for the volume */
+
+	/* The volume layout */
+	struct geometry *geometry;
+
+	/* Index owner's nonce */
+	u64 nonce;
+
+	/* The number of threads used to process index requests */
+	unsigned int zone_count;
+
+	/* The number of threads used to read volume pages */
+	unsigned int read_threads;
+
+	/* Size of the page cache and sparse chapter index cache in chapters */
+	u32 cache_chapters;
+
+	/* Parameters for the volume index */
+
+	/* The mean delta for the volume index */
+	u32 volume_index_mean_delta;
+
+	/* Sampling rate for sparse indexing */
+	u32 sparse_sample_rate;
+};
+
+/* On-disk structure of data for a version 8.02 index. */
+struct uds_configuration_8_02 {
+	/* Smaller (16), Small (64) or large (256) indices */
+	u32 record_pages_per_chapter;
+	/* Total number of chapters per volume */
+	u32 chapters_per_volume;
+	/* Number of sparse chapters per volume */
+	u32 sparse_chapters_per_volume;
+	/* Size of the page cache, in chapters */
+	u32 cache_chapters;
+	/* Unused field */
+	u32 unused;
+	/* The volume index mean delta to use */
+	u32 volume_index_mean_delta;
+	/* Size of a page, used for both record pages and index pages */
+	u32 bytes_per_page;
+	/* Sampling rate for sparse indexing */
+	u32 sparse_sample_rate;
+	/* Index owner's nonce */
+	u64 nonce;
+	/* Virtual chapter remapped from physical chapter 0 */
+	u64 remapped_virtual;
+	/* New physical chapter which remapped chapter was moved to */
+	u64 remapped_physical;
+} __packed;
+
+/* On-disk structure of data for a version 6.02 index. */
+struct uds_configuration_6_02 {
+	/* Smaller (16), Small (64) or large (256) indices */
+	u32 record_pages_per_chapter;
+	/* Total number of chapters per volume */
+	u32 chapters_per_volume;
+	/* Number of sparse chapters per volume */
+	u32 sparse_chapters_per_volume;
+	/* Size of the page cache, in chapters */
+	u32 cache_chapters;
+	/* Unused field */
+	u32 unused;
+	/* The volume index mean delta to use */
+	u32 volume_index_mean_delta;
+	/* Size of a page, used for both record pages and index pages */
+	u32 bytes_per_page;
+	/* Sampling rate for sparse indexing */
+	u32 sparse_sample_rate;
+	/* Index owner's nonce */
+	u64 nonce;
+} __packed;
+
+int __must_check
+uds_make_configuration(const struct uds_parameters *params, struct configuration **config_ptr);
+
+void uds_free_configuration(struct configuration *config);
+
+int __must_check
+uds_validate_config_contents(struct buffered_reader *reader, struct configuration *config);
+
+int __must_check uds_write_config_contents(struct buffered_writer *writer,
+					   struct configuration *config,
+					   u32 version);
+
+void uds_log_configuration(struct configuration *config);
+
+#endif /* UDS_CONFIG_H */
diff --git a/drivers/md/dm-vdo/geometry.c b/drivers/md/dm-vdo/geometry.c
new file mode 100644
index 000000000000..f4a4bcee5b73
--- /dev/null
+++ b/drivers/md/dm-vdo/geometry.c
@@ -0,0 +1,205 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2023 Red Hat
+ */
+
+#include "geometry.h"
+
+#include <linux/compiler.h>
+#include <linux/log2.h>
+
+#include "delta-index.h"
+#include "errors.h"
+#include "logger.h"
+#include "memory-alloc.h"
+#include "permassert.h"
+#include "uds.h"
+
+/*
+ * An index volume is divided into a fixed number of fixed-size chapters, each consisting of a
+ * fixed number of fixed-size pages. The volume layout is defined by two constants and four
+ * parameters. The constants are that index records are 32 bytes long (16-byte block name plus
+ * 16-byte metadata) and that open chapter index hash slots are one byte long. The four parameters
+ * are the number of bytes in a page, the number of record pages in a chapter, the number of
+ * chapters in a volume, and the number of chapters that are sparse. From these parameters, we can
+ * derive the rest of the layout and other index properties.
+ *
+ * The index volume is sized by its maximum memory footprint. For a dense index, the persistent
+ * storage is about 10 times the size of the memory footprint. For a sparse index, the persistent
+ * storage is about 100 times the size of the memory footprint.
+ *
+ * For a small index with a memory footprint less than 1GB, there are three possible memory
+ * configurations: 0.25GB, 0.5GB and 0.75GB. The default geometry for each is 1024 index records
+ * per 32 KB page, 1024 chapters per volume, and either 64, 128, or 192 record pages per chapter
+ * (resulting in 6, 13, or 20 index pages per chapter) depending on the memory configuration. For
+ * the VDO default of a 0.25 GB index, this yields a deduplication window of 256 GB using about 2.5
+ * GB for the persistent storage and 256 MB of RAM.
+ *
+ * For a larger index with a memory footprint that is a multiple of 1 GB, the geometry is 1024
+ * index records per 32 KB page, 256 record pages per chapter, 26 index pages per chapter, and 1024
+ * chapters for every GB of memory footprint. For a 1 GB volume, this yields a deduplication window
+ * of 1 TB using about 9GB of persistent storage and 1 GB of RAM.
+ *
+ * The above numbers hold for volumes which have no sparse chapters. A sparse volume has 10 times
+ * as many chapters as the corresponding non-sparse volume, which provides 10 times the
+ * deduplication window while using 10 times as much persistent storage as the equivalent
+ * non-sparse volume with the same memory footprint.
+ *
+ * If the volume has been converted from a non-lvm format to an lvm volume, the number of chapters
+ * per volume will have been reduced by one by eliminating physical chapter 0, and the virtual
+ * chapter that formerly mapped to physical chapter 0 may be remapped to another physical chapter.
+ * This remapping is expressed by storing which virtual chapter was remapped, and which physical
+ * chapter it was moved to.
+ */
+
+int uds_make_geometry(size_t bytes_per_page,
+		      u32 record_pages_per_chapter,
+		      u32 chapters_per_volume,
+		      u32 sparse_chapters_per_volume,
+		      u64 remapped_virtual,
+		      u64 remapped_physical,
+		      struct geometry **geometry_ptr)
+{
+	int result;
+	struct geometry *geometry;
+
+	result = UDS_ALLOCATE(1, struct geometry, "geometry", &geometry);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	geometry->bytes_per_page = bytes_per_page;
+	geometry->record_pages_per_chapter = record_pages_per_chapter;
+	geometry->chapters_per_volume = chapters_per_volume;
+	geometry->sparse_chapters_per_volume = sparse_chapters_per_volume;
+	geometry->dense_chapters_per_volume = chapters_per_volume - sparse_chapters_per_volume;
+	geometry->remapped_virtual = remapped_virtual;
+	geometry->remapped_physical = remapped_physical;
+
+	geometry->records_per_page = bytes_per_page / BYTES_PER_RECORD;
+	geometry->records_per_chapter = geometry->records_per_page * record_pages_per_chapter;
+	geometry->records_per_volume = (u64) geometry->records_per_chapter * chapters_per_volume;
+
+	geometry->chapter_mean_delta = 1 << DEFAULT_CHAPTER_MEAN_DELTA_BITS;
+	geometry->chapter_payload_bits = bits_per(record_pages_per_chapter - 1);
+	/*
+	 * We want 1 delta list for every 64 records in the chapter.
+	 * The "| 077" ensures that the chapter_delta_list_bits computation
+	 * does not underflow.
+	 */
+	geometry->chapter_delta_list_bits =
+		bits_per((geometry->records_per_chapter - 1) | 077) - 6;
+	geometry->delta_lists_per_chapter = 1 << geometry->chapter_delta_list_bits;
+	/* We need enough address bits to achieve the desired mean delta. */
+	geometry->chapter_address_bits =
+		(DEFAULT_CHAPTER_MEAN_DELTA_BITS -
+		 geometry->chapter_delta_list_bits +
+		 bits_per(geometry->records_per_chapter - 1));
+	geometry->index_pages_per_chapter =
+		uds_get_delta_index_page_count(geometry->records_per_chapter,
+					       geometry->delta_lists_per_chapter,
+					       geometry->chapter_mean_delta,
+					       geometry->chapter_payload_bits,
+					       bytes_per_page);
+
+	geometry->pages_per_chapter = geometry->index_pages_per_chapter + record_pages_per_chapter;
+	geometry->pages_per_volume = geometry->pages_per_chapter * chapters_per_volume;
+	geometry->bytes_per_volume =
+		bytes_per_page * (geometry->pages_per_volume + HEADER_PAGES_PER_VOLUME);
+
+	*geometry_ptr = geometry;
+	return UDS_SUCCESS;
+}
+
+int uds_copy_geometry(struct geometry *source, struct geometry **geometry_ptr)
+{
+	return uds_make_geometry(source->bytes_per_page,
+				 source->record_pages_per_chapter,
+				 source->chapters_per_volume,
+				 source->sparse_chapters_per_volume,
+				 source->remapped_virtual,
+				 source->remapped_physical,
+				 geometry_ptr);
+}
+
+void uds_free_geometry(struct geometry *geometry)
+{
+	UDS_FREE(geometry);
+}
+
+u32 __must_check uds_map_to_physical_chapter(const struct geometry *geometry, u64 virtual_chapter)
+{
+	u64 delta;
+
+	if (!uds_is_reduced_geometry(geometry))
+		return virtual_chapter % geometry->chapters_per_volume;
+
+	if (likely(virtual_chapter > geometry->remapped_virtual)) {
+		delta = virtual_chapter - geometry->remapped_virtual;
+		if (likely(delta > geometry->remapped_physical))
+			return delta % geometry->chapters_per_volume;
+		else
+			return delta - 1;
+	}
+
+	if (virtual_chapter == geometry->remapped_virtual)
+		return geometry->remapped_physical;
+
+	delta = geometry->remapped_virtual - virtual_chapter;
+	if (delta < geometry->chapters_per_volume)
+		return geometry->chapters_per_volume - delta;
+
+	/* This chapter is so old the answer doesn't matter. */
+	return 0;
+}
+
+/* Check whether any sparse chapters are in use. */
+bool uds_has_sparse_chapters(const struct geometry *geometry,
+			     u64 oldest_virtual_chapter,
+			     u64 newest_virtual_chapter)
+{
+	return uds_is_sparse_geometry(geometry) &&
+	       ((newest_virtual_chapter - oldest_virtual_chapter + 1) >
+		geometry->dense_chapters_per_volume);
+}
+
+bool uds_is_chapter_sparse(const struct geometry *geometry,
+			   u64 oldest_virtual_chapter,
+			   u64 newest_virtual_chapter,
+			   u64 virtual_chapter_number)
+{
+	return uds_has_sparse_chapters(geometry,
+				       oldest_virtual_chapter,
+				       newest_virtual_chapter) &&
+	       ((virtual_chapter_number + geometry->dense_chapters_per_volume) <=
+		newest_virtual_chapter);
+}
+
+/* Calculate how many chapters to expire after opening the newest chapter. */
+u32 uds_chapters_to_expire(const struct geometry *geometry, u64 newest_chapter)
+{
+	/* If the index isn't full yet, don't expire anything. */
+	if (newest_chapter < geometry->chapters_per_volume)
+		return 0;
+
+	/* If a chapter is out of order... */
+	if (geometry->remapped_physical > 0) {
+		u64 oldest_chapter = newest_chapter - geometry->chapters_per_volume;
+
+		/*
+		 * ... expire an extra chapter when expiring the moved chapter to free physical
+		 * space for the new chapter ...
+		 */
+		if (oldest_chapter == geometry->remapped_virtual)
+			return 2;
+
+		/*
+		 * ... but don't expire anything when the new chapter will use the physical chapter
+		 * freed by expiring the moved chapter.
+		 */
+		if (oldest_chapter == (geometry->remapped_virtual + geometry->remapped_physical))
+			return 0;
+	}
+
+	/* Normally, just expire one. */
+	return 1;
+}
diff --git a/drivers/md/dm-vdo/geometry.h b/drivers/md/dm-vdo/geometry.h
new file mode 100644
index 000000000000..963dc7629c92
--- /dev/null
+++ b/drivers/md/dm-vdo/geometry.h
@@ -0,0 +1,137 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2023 Red Hat
+ */
+
+#ifndef UDS_GEOMETRY_H
+#define UDS_GEOMETRY_H
+
+#include "uds.h"
+
+/*
+ * The geometry records parameters that define the layout of a UDS index volume, and the size and
+ * shape of various index structures. It is created when the index is created, and is referenced by
+ * many index sub-components.
+ */
+
+struct geometry {
+	/* Size of a chapter page, in bytes */
+	size_t bytes_per_page;
+	/* Number of record pages in a chapter */
+	u32 record_pages_per_chapter;
+	/* Total number of chapters in a volume */
+	u32 chapters_per_volume;
+	/* Number of sparsely-indexed chapters in a volume */
+	u32 sparse_chapters_per_volume;
+	/* Number of bits used to determine delta list numbers */
+	u8 chapter_delta_list_bits;
+	/* Virtual chapter remapped from physical chapter 0 */
+	u64 remapped_virtual;
+	/* New physical chapter where the remapped chapter can be found */
+	u64 remapped_physical;
+
+	/*
+	 * The following properties are derived from the ones above, but they are computed and
+	 * recorded as fields for convenience.
+	 */
+	/* Total number of pages in a volume, excluding the header */
+	u32 pages_per_volume;
+	/* Total number of bytes in a volume, including the header */
+	size_t bytes_per_volume;
+	/* Number of pages in a chapter */
+	u32 pages_per_chapter;
+	/* Number of index pages in a chapter index */
+	u32 index_pages_per_chapter;
+	/* Number of records that fit on a page */
+	u32 records_per_page;
+	/* Number of records that fit in a chapter */
+	u32 records_per_chapter;
+	/* Number of records that fit in a volume */
+	u64 records_per_volume;
+	/* Number of delta lists per chapter index */
+	u32 delta_lists_per_chapter;
+	/* Mean delta for chapter indexes */
+	u32 chapter_mean_delta;
+	/* Number of bits needed for record page numbers */
+	u8 chapter_payload_bits;
+	/* Number of bits used to compute addresses for chapter delta lists */
+	u8 chapter_address_bits;
+	/* Number of densely-indexed chapters in a volume */
+	u32 dense_chapters_per_volume;
+};
+
+enum {
+	/* The number of bytes in a record (name + metadata) */
+	BYTES_PER_RECORD = (UDS_RECORD_NAME_SIZE + UDS_RECORD_DATA_SIZE),
+
+	/* The default length of a page in a chapter, in bytes */
+	DEFAULT_BYTES_PER_PAGE = 1024 * BYTES_PER_RECORD,
+
+	/* The default maximum number of records per page */
+	DEFAULT_RECORDS_PER_PAGE = DEFAULT_BYTES_PER_PAGE / BYTES_PER_RECORD,
+
+	/* The default number of record pages in a chapter */
+	DEFAULT_RECORD_PAGES_PER_CHAPTER = 256,
+
+	/* The default number of record pages in a chapter for a small index */
+	SMALL_RECORD_PAGES_PER_CHAPTER = 64,
+
+	/* The default number of chapters in a volume */
+	DEFAULT_CHAPTERS_PER_VOLUME = 1024,
+
+	/* The default number of sparsely-indexed chapters in a volume */
+	DEFAULT_SPARSE_CHAPTERS_PER_VOLUME = 0,
+
+	/* The log2 of the default mean delta */
+	DEFAULT_CHAPTER_MEAN_DELTA_BITS = 16,
+
+	/* The log2 of the number of delta lists in a large chapter */
+	DEFAULT_CHAPTER_DELTA_LIST_BITS = 12,
+
+	/* The log2 of the number of delta lists in a small chapter */
+	SMALL_CHAPTER_DELTA_LIST_BITS = 10,
+
+	/* The number of header pages per volume */
+	HEADER_PAGES_PER_VOLUME = 1,
+};
+
+int __must_check uds_make_geometry(size_t bytes_per_page,
+				   u32 record_pages_per_chapter,
+				   u32 chapters_per_volume,
+				   u32 sparse_chapters_per_volume,
+				   u64 remapped_virtual,
+				   u64 remapped_physical,
+				   struct geometry **geometry_ptr);
+
+int __must_check uds_copy_geometry(struct geometry *source, struct geometry **geometry_ptr);
+
+void uds_free_geometry(struct geometry *geometry);
+
+u32 __must_check uds_map_to_physical_chapter(const struct geometry *geometry, u64 virtual_chapter);
+
+/*
+ * Check whether this geometry is reduced by a chapter. This will only be true if the volume was
+ * converted from a non-lvm volume to an lvm volume.
+ */
+static inline bool __must_check uds_is_reduced_geometry(const struct geometry *geometry)
+{
+	return !!(geometry->chapters_per_volume & 1);
+}
+
+static inline bool __must_check uds_is_sparse_geometry(const struct geometry *geometry)
+{
+	return geometry->sparse_chapters_per_volume > 0;
+}
+
+bool __must_check uds_has_sparse_chapters(const struct geometry *geometry,
+					  u64 oldest_virtual_chapter,
+					  u64 newest_virtual_chapter);
+
+bool __must_check uds_is_chapter_sparse(const struct geometry *geometry,
+					u64 oldest_virtual_chapter,
+					u64 newest_virtual_chapter,
+					u64 virtual_chapter_number);
+
+u32 __must_check uds_chapters_to_expire(const struct geometry *geometry, u64 newest_chapter);
+
+#endif /* UDS_GEOMETRY_H */
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

