Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80FF18F2FC
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130801; cv=none; b=umIW500DwT7c7PM+asdTs/sbssKRYN1hh9EOGYcJOZwVi1GGCk6/Qy9MpshoWlwBImh1Usxyn2pVXdIMaiiHpwrT61eZauJqtL9AFxO5iw1XojdK94/pOY19ZcIBXSnkGm5SvJHSNrJ+bEpWvjIldeR39tML++w1QfduRn8nsrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130801; c=relaxed/simple;
	bh=/ihWMef0SkxFAgSM3LCxgrSlFk7hwIRNdI4tGjaWkIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKEwoJmrj09YfQDm89IzT6+aQ1W/MvLYfRG3XhBhnkqIXB1u5AWM5qlda7nhYRV2w7K59RD5R6303l5yREi39cnP1808VwYzRGmagAibG72ysxEz2JW6+xOsZf2V5v3GAP1ajLqny3MQVNUOiXH+Akzl0YqiVAF2YH9jpEO/dPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DPKo7RJR; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DPKo7RJR"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a7ad02501c3so135725366b.2
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130798; x=1723735598; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W6nKzm1IQqQOnq247XwltMY3Rwyes2u/zt89jnzbWE4=;
        b=DPKo7RJRhr0ZeAIlcgqSJ20wQSTNpvP3tD+2ElYTyMGRvvIWf9iNXFSRxIYH9LgLHo
         O/lYOFbstIOuHN9knDFTshIJpHrYkrJtRh5usMlAtO5C1BKhv6JxwLD261qv55HU76Np
         wPq8whEVDzMT9eS4jQUUbNG94TAfumaAQSHFAQu2X5uSIc3a+D2Z0OY7N8BqvMp/M1gn
         ToBh88mhLR8M2BqbcY9MwzE6xzvg3Vx1zSI3eCZp4Vs7VzdrO1rWYtWqSlvDByfOAWRv
         xzpZNHpJGMUGeFiWVqLstFimCViXhFlSuqSITy9H74S1XaZRaJxRefT/bdAXdiclF+P/
         ttOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130798; x=1723735598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W6nKzm1IQqQOnq247XwltMY3Rwyes2u/zt89jnzbWE4=;
        b=vYXi4ndFOHhhxxt94tMT8XIEiHvUHPGordXh7UUuqU3FEUbGShhtxjheVrUvzMxFJ5
         BMvnI8A3+noLHWr6q6rtgQt9jVTdm3EtWuudJdCzGXsd/wGS/wnCg7zuRuvgQQGSLerD
         4064zoTrfZRG7PEbPw+bAoGr5Kd7uYhYYB5pYA88c9Ipr6HyswTFYKN9yJTb3fxh/+Nv
         H6px5sltnWjOaRz7hl8dJwXhrYB2Vhuw/ISKizJuQ+jsebLlYGTv202Aqnr/F6zAqTNR
         BpCknRAkt2t7WYKYNZlgUNBm2aRJ5+pTvnlGERb1k1nWiyJOLRitCsAmMBFwWsdBqF6+
         lOpQ==
X-Gm-Message-State: AOJu0Yxdjpvd8uqUuhrxsySehVDY9mi7O+jxv72o4oRoLum9x662DBh1
	F+0us6dEF0Ti75bFXmo27JfkZy+2ByhwAvuAbzfZBLk+1rBAmZm8Ffn98P3KWSE=
X-Google-Smtp-Source: AGHT+IFP/XoC7Hj6wxWImVdUv6iQqoIrB9tpn1s5gQ4f2t/VGk6/AZwA+BeMuZRCSRq/V2OAPgdpTw==
X-Received: by 2002:a17:907:97d1:b0:a7a:b070:92d1 with SMTP id a640c23a62f3a-a8090e632eemr160876266b.46.1723130797562;
        Thu, 08 Aug 2024 08:26:37 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9bcadbesm751341266b.21.2024.08.08.08.26.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:37 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 04/41] libmpathutil.version: remove strlcpy and strlcat, and LIBMULTIPATH section
Date: Thu,  8 Aug 2024 17:25:43 +0200
Message-ID: <20240808152620.93965-5-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808152620.93965-1-mwilck@suse.com>
References: <20240808152620.93965-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With the removal of strlcpy from the "symbols referenced by multipath
and multipathd" section, this part of the ABI (which is actually the
part of LIBMULTIPATH_16.0.0 which was moved to libmpathutil and exported
to multipath and/or multipathd) has now changed for the first time since
the split between libmpathutil and libmultipath.

It makes no sense to further track whether or not any symbols exported
by libmpathutil are used by multipath or multipathd. It turns out that
both executables were already using some symbols from the sections that
were supposedly used by libmultipath only.

Therefore, move all symbols to the new LIBMPATHUTIL_4.0 ABI.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/libmpathutil.version | 104 +++++++++++++-----------------
 1 file changed, 46 insertions(+), 58 deletions(-)

diff --git a/libmpathutil/libmpathutil.version b/libmpathutil/libmpathutil.version
index cb05231..8393b91 100644
--- a/libmpathutil/libmpathutil.version
+++ b/libmpathutil/libmpathutil.version
@@ -43,98 +43,86 @@ LIBMPATHCOMMON_1.0.0 {
 	put_multipath_config;
 };
 
-/* symbols referenced by multipath and multipathd */
-LIBMULTIPATH_16.0.0 {
+LIBMPATHUTIL_4.0 {
 global:
+	alloc_bitfield;
 	alloc_strvec;
+	__append_strbuf_str;
 	append_strbuf_str;
+	append_strbuf_quoted;
+	basenamecpy;
 	cleanup_charp;
+	cleanup_fclose;
+	cleanup_fd_ptr;
+	cleanup_free_ptr;
 	cleanup_mutex;
 	cleanup_ucharp;
+	cleanup_udev_device;
+	cleanup_vector;
+	cleanup_vector_free;
 	convert_dev;
 	dlog;
+	filepresent;
 	fill_strbuf;
+	find_keyword;
 	find_slot;
+	free_keywords;
 	free_scandir_result;
 	free_strvec;
+	get_linux_version_code;
 	get_monotonic_time;
+	__get_strbuf_buf;
 	get_next_string;
 	get_strbuf_len;
 	get_strbuf_str;
-	is_quote;
-	libmp_verbosity;
-	log_thread_reset;
-	log_thread_start;
-	log_thread_stop;
-	logsink;
-	normalize_timespec;
-	print_strbuf;
-	pthread_cond_init_mono;
-	recv_packet;
-	reset_strbuf;
-	send_packet;
-	set_max_fds;
-	setup_thread_attr;
-	strchop;
-	strlcpy;
-	timespeccmp;
-	timespecsub;
-	truncate_strbuf;
-	ux_socket_listen;
-	vector_alloc;
-	vector_alloc_slot;
-	vector_del_slot;
-	vector_free;
-	vector_reset;
-	vector_set_slot;
-
-local:
-	*;
-};
-
-/* symbols referenced internally by libmultipath */
-LIBMPATHUTIL_2.0 {
-	alloc_bitfield;
-	__append_strbuf_str;
-	append_strbuf_quoted;
-	basenamecpy;
-	cleanup_fd_ptr;
-	cleanup_free_ptr;
-	cleanup_vector_free;
-	cleanup_fclose;
-	filepresent;
-	find_keyword;
-	free_keywords;
-	get_linux_version_code;
-	__get_strbuf_buf;
 	get_word;
 	_install_keyword;
 	install_sublevel;
 	install_sublevel_end;
+	is_quote;
 	keyword_alloc;
 	_log_bitfield_overflow;
+	libmp_basename;
+	libmp_strlcat;
+	libmp_strlcpy;
+	libmp_verbosity;
 	log_safe;
+	log_thread_reset;
+	log_thread_start;
+	log_thread_stop;
+	logsink;
 	msort;
+	normalize_timespec;
 	parse_devt;
+	print_strbuf;
 	process_file;
+	pthread_cond_init_mono;
+	recv_packet;
+	reset_strbuf;
 	safe_write;
+	send_packet;
+	set_max_fds;
 	set_value;
+	setup_thread_attr;
+	strchop;
 	should_exit;
 	snprint_keyword;
 	steal_strbuf_str;
-	strlcat;
+	timespeccmp;
+	timespecsub;
+	truncate_strbuf;
 	validate_config_strvec;
+	ux_socket_listen;
+	vector_alloc;
+	vector_alloc_slot;
+	vector_del_slot;
 	vector_find_or_add_slot;
+	vector_free;
 	vector_insert_slot;
 	vector_move_up;
+	vector_reset;
+	vector_set_slot;
 	vector_sort;
-};
-
-LIBMPATHUTIL_2.1 {
-	libmp_basename;
-};
-
-LIBMPATHUTIL_2.2 {
-	cleanup_udev_device;
-	cleanup_vector;
+local:
+	*;
 };
-- 
2.46.0

