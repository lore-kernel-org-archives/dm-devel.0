Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE45D20400C
	for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 15:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731423768; cv=none; b=JwhLxEBFPLj6YEZRvU9ahxKCDjGyvQY1XRtPcRkZcYG9SgFtOF7UY0isjPrhMgS5GssJyNe2cokMcARRBWak9iUEt0G03x1LlGybUolCymCiH/skRMSuZ2US4wspiFjt1+3mSlmWmHhfzBb7ejefZwe6Cj+3Stw2Txe5iJxADJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731423768; c=relaxed/simple;
	bh=jZhlXLIIjczeO5uVuUYNXru1X5KD+14Qs+eRtR+CxQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMdPsbnPBoNxJq3ODx0zSIkvoYyJ63I5gp4UfHTLI5SQpRdHe3liLwe43gzL7gGNzjHz3obzSs/ixspiX3oTPSoQKOaMohOb+4/OsW+a+0xT3m7mVdJjUGCTrlfj1BfUD55ia7LMysHVJcCAKtPInMzM4leWrlQOoJOE23p5B9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ixj7bVN1; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ixj7bVN1"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3807dd08cfcso5444332f8f.1
        for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 07:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731423765; x=1732028565; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Khh8gG0tDxXfH/QuoNQfGXj6+n9tzzRy2t/P4Kgr4GQ=;
        b=Ixj7bVN1cVeQvQ0qvWiYEZV5bJ4FjGGYKjFSPr/I1ufQE2Wvgtgwmm4qevX4o5yJDk
         IIaHnPJHSNDp71U9P38qAw8gb6YYzdjvtsCa6a9GXuKRY+X7qzkJamU3TC0r6+BQ5Ilp
         vHn/OzuFr+CggZ7nMPscVRhT+MCgdJPwh6r7tqO/mirpHqjLaiHD9ABR45hLNo7AmXm9
         GbGFtFu+GNNYlCAz1nnZLQlTfJdmhaLIXAY9g1jq4U5nlpFeN0GLbcY0jjjUCzRq9nas
         +1NQEhJbnxclwEatwy8x4lB1UjkPeIy1PdpPiFx/L/Nrym/Rd1GPR3CqUFQa1p7uFvtN
         VY6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731423765; x=1732028565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Khh8gG0tDxXfH/QuoNQfGXj6+n9tzzRy2t/P4Kgr4GQ=;
        b=E22mTMBLfoJ5vHYiyutLbc0vNvMWK71Drf61JlTWh5kJPy3yOnLy51rXQ1xWr2ym4a
         1HMuNdXf8f4nwz72ZxN4IddDEUNkl8NGle+Ye79BEvyjwl9Zz1JkatD31SRNiaGx7WeI
         Y4LXB363t/Y428rQ67QB7pvhVchgkfUuaOwf44nGfTb7+UhD9kLtCdZnSkjnsO04D57J
         mB7dpNpZaXzmUXtiSI61yIJzUKvAwq3Y4ukvAh9nQB6uqAJKLFyhTFOo3ghgoCc5B4jX
         uCnTKkFjX5WqsbR1/oOS/12y9UJv0I1flFJ/kn3lzYEYKQ8Dp5ICql2qi8QndFO+eVO2
         xvgA==
X-Gm-Message-State: AOJu0YxPz6lkcr/5lDmuAnLsKKJAn18/NyL/c97Npcvc/wz8qiutxo/9
	mIZIH/dMKPaUQsxKkhsTj+Yx9XiIbCKClJQt9hGxSnXoKAM9l2sSWUHMFCnXtao=
X-Google-Smtp-Source: AGHT+IHy+LCoJ49rQ69m+UER3C57ek3qjvrL3o6LP01/QlesbnsG6r1jgUetAsGOx5YkxqKO6vFgTw==
X-Received: by 2002:a05:6000:460f:b0:37d:542a:7995 with SMTP id ffacd0b85a97d-381f1872cc6mr17302472f8f.34.1731423764388;
        Tue, 12 Nov 2024 07:02:44 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-381ed97cfefsm15511262f8f.26.2024.11.12.07.02.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 07:02:44 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 10/12] libmultipath: reduce log level of libmp_mapinfo() messages
Date: Tue, 12 Nov 2024 16:02:13 +0100
Message-ID: <20241112150215.90182-11-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112150215.90182-1-mwilck@suse.com>
References: <20241112150215.90182-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Unless  MAPINFO_CHECK_UUID was set and we know that we are
looking at a map with a multipath UUID, encountering non-multipath
maps is not an error. Don't log this at verbosity level 2.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 3502d05..9714270 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -740,20 +740,22 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
 	}
 
 	if (info.target || info.status || info.size || flags & MAPINFO_TGT_TYPE__) {
+		int lvl = MAPINFO_CHECK_UUID ? 2 : 4;
+
 		if (dm_get_next_target(dmt, NULL, &start, &length,
 				       &target_type, &params) != NULL) {
-			condlog(2, "%s: map %s has multiple targets", fname__, map_id);
+			condlog(lvl, "%s: map %s has multiple targets", fname__, map_id);
 			return DMP_NO_MATCH;
 		}
 		if (!params) {
-			condlog(2, "%s: map %s has no targets", fname__, map_id);
+			condlog(lvl, "%s: map %s has no targets", fname__, map_id);
 			return DMP_NOT_FOUND;
 		}
 		if (flags & MAPINFO_TGT_TYPE__) {
 			const char *tgt_type = flags & MAPINFO_MPATH_ONLY ? TGT_MPATH : TGT_PART;
 
 			if (strcmp(target_type, tgt_type)) {
-				condlog(3, "%s: target type mismatch: \"%s\" != \"%s\"",
+				condlog(lvl, "%s: target type mismatch: \"%s\" != \"%s\"",
 					fname__, tgt_type, target_type);
 				return DMP_NO_MATCH;
 			}
-- 
2.47.0

