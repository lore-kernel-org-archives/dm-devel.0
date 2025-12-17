Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4D62494FE
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 21:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006487; cv=none; b=SrsMvhGSCg7VUj8TXM6cpdqv/Twl6mKDALd0pzT8NEEpgP+dBWxdPehNv8fojdxt5Ii3HsefJXIE34xVcxF21IJaPHHiaZMuld5SPB5Fd0yRebc99LsutHDiDaAU+tUGpbngkflZDsu/O/OvK7pFwSuZz+iuAenpemz9hobTZ7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006487; c=relaxed/simple;
	bh=E/Hu+GZfF5APGLk7DnZXuXwUDsUn/8urvoLMv3iVD08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kyu6NIk1UFQXz5iTvO36jXOWdIpE5fl/LU9EkYBR74jFHDfc1ijmarfI1VIHQ8lsccx8x2gJWhF0xtsGyoNAJiRYQzUfXdnepQCNqmG5OIDGTfoOQ9FYy8Vz1jHMLdwLTW+53b+wJQR7mZVbfGKKKj+0ETAwtkC7Kyzt6jLnJhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Po4NNRyF; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Po4NNRyF"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b79ea617f55so668945466b.3
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 13:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766006483; x=1766611283; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JASIeaJYSaFzogNqwkfkwY1m3hvQ6leSsdGQ78b06CE=;
        b=Po4NNRyFCVInfIsEenQTdaEo1IKeHO2uD0lMfDogATqPLnLqCTq9oJ+CWvy8KW9CDl
         kM/VlJILCcpH8DVik2gUrNKiZ6TKSZCh5TSb1KZUFSarkHVneHnGB7DB8zI4zwfyqKLk
         M4RffBQgjKHUJuNtt4mjrvAqRz3PbAcIZzqhVVTgTohM6NnUc61QIc1a2ZoB/vRIdRXR
         Wau+Bx+rYdfih+GhOQ4Z0n3z5cfvzR1LvpKqYTGHDrzTusHDAUUfQtEszRLI+nAoBJl3
         qZAISb3foEqN7fWSQaPTIV8MKkQvNPjW3OATH7McRtJPLcxQ+Jwu4Hg4QQM/Hcr4PYb/
         7/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006483; x=1766611283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JASIeaJYSaFzogNqwkfkwY1m3hvQ6leSsdGQ78b06CE=;
        b=gUfhE/T3Rtc4KQ6FTsdgZdgBvH6rHofuArXOst06gZ7RLzuHxCFkiW9LmbTFBJ9T42
         yKGRR5n+9FU5CWIcJN+MXLGLUqX5ZWRTvDQc/CoGmBEMpmXmLUB3Sm0CMGVDkvHO0tIr
         0sSauBMvkOPNtAsn+IQS3mCZXqpLXeYJdIhMyqCeIajYJK+PRNbm54YThBBGCRDWlsjo
         PhvM0w8DolkNn5hs/18vqTK8Ppxtja07TXlVKtVwcR1xdEPoLEJ7H2I+nDG9fM2CygG6
         bhvOMQxGKdYSjQCoCVXb+nutF4avbJr0pDGc5X7ke58//RfmveKEEz8uJRl8H6hDfZwS
         WwiQ==
X-Gm-Message-State: AOJu0YwjdTlXQTlVHu2zvIgnTBZrsOY1oYFMDBDNZWudgks7ONPrTjbC
	4Eq/fQb8qzNBFY3T/B9pzT1kodPpEaZk3TguwSAIJKoy0SCVlujFDtYoOTpqU5wQBgs=
X-Gm-Gg: AY/fxX5l34BbBBT+vbQNcxjCfzRD9t2eez7Cv2nnZf/iHEn/Y/LhODqppXBUmAp7itv
	L9/5zch1+RKo9/LCdOfQTLYU2bbDK2OSy7QuobSBCLiP0j735i4WQgI5jXixYmU3wp+1MA4oL6P
	VlVGfYr6eY13iUIJeRCnRInBc6rWPD1hVpjgotIUpP3c8h6barKlRTAyQls2Bz5lIiL/L/vyesr
	FOKLqO73BQ8F4XhECI4+hcAU55kVqSQLa3Mg2BkMDrl0mxd9TqUAy3B21LkuqN1EPdBkAfdcg8t
	BteZsQF+nFu3QfvgYk1fotamFtu2FwJJRc7l+YK/72P04yWwHqDp0i7tdJLrtIwCzVJFF5k8+4r
	neSEPup7dAk4jYX9EYkjmG1bxELxjTZr9JKKXdNj0M04Y+oYpSfb17Offs5v794JLNw9dieWcaF
	epDcm5XLoi6GTOxdB5x+YmupMsd6+OzyebDLRsftO9wGTt2icL4c45MtMLPLLogGra/5xjjVk3C
	w==
X-Google-Smtp-Source: AGHT+IH6/417tvcnJyE6SKzDJjTt5K/XIMtdeuX/83q+QZeDyFU+DF4SoH/IHk5C7CpDM3WWSi5Rnw==
X-Received: by 2002:a17:907:7e97:b0:b72:56ad:c9c0 with SMTP id a640c23a62f3a-b7d236b7b77mr1881242066b.17.1766006482966;
        Wed, 17 Dec 2025 13:21:22 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b802351a58dsm27477966b.69.2025.12.17.13.21.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 13:21:22 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 02/21] libmultipath: don't access path members in free_pgvec()
Date: Wed, 17 Dec 2025 22:20:54 +0100
Message-ID: <20251217212113.234959-3-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217212113.234959-1-mwilck@suse.com>
References: <20251217212113.234959-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It can happen that a path group contains references to paths that are
already freed. If we access pp->pgindex in such a case, a use-after-free
occurs. In particular, this occurs if we call remove_map() from configure()
-> coalesce_paths(), and some paths are freed in orphan_paths() because
they are in INIT_PARTIAL or INIT_REMOVED state. The paths of the removed
map may still be referenced by maps in the "old" mpvec in configure(). The
UAF occurs when configure() calls remove_maps(vecs).

This code has been introduced in cd912cf ("libmultipath: fix handling of
pp->pgindex"). The commit message stated: "The hunk in group_paths is
mostly redundant with the hunk in free_pgvec(), but because we're looping
over pg->paths in the former and over pg->pgp in the latter, I think it's
better too play safe". It turns out that it would have been better not
to "play safe" here. No caller of free_pgvec() requires the pgindex to
be reset. For the functions in pgpolicies.c, the reset of pgindex is
redundant, as remarked in cd912cf. disassemble_map() will set the pgindex
later anyway, and update_multipath_strings() will call disassemble_map().
The other callers remove the struct multipath, in which case the paths
will eventually be orphaned or freed (except for the special case of
coalesce_paths() mentioned above).

Fixes: cd912cf ("libmultipath: fix handling of pp->pgindex")

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 1cbbea8..e6e673f 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -239,18 +239,8 @@ free_pgvec (vector pgvec, enum free_path_mode free_paths)
 	if (!pgvec)
 		return;
 
-	vector_foreach_slot(pgvec, pgp, i) {
-
-		/* paths are going to be re-grouped, reset pgindex */
-		if (free_paths != FREE_PATHS) {
-			struct path *pp;
-			int j;
-
-			vector_foreach_slot(pgp->paths, pp, j)
-				pp->pgindex = 0;
-		}
+	vector_foreach_slot(pgvec, pgp, i)
 		free_pathgroup(pgp, free_paths);
-	}
 
 	vector_free(pgvec);
 }
-- 
2.52.0

