Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7DA324700
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155283; cv=none; b=RiFQsrZs6lFdnN8sp6oKbB7sYjlJkVBgyiSrnI1HLrD7WRmj0ysarh7u7wWPF8juizFf6yK1bJUgD/gcsWw4yrtLMQUHOdDXBOwPi8xlZdIo7GZnYqLcN2tbTuhJ7PWyinAWYEf59j7iwMg+lEl+UV2wW857ODYWmDjK9/4jYic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155283; c=relaxed/simple;
	bh=CLN3yE6fOnt8I9K7wg2UbrJtK2U7Nkec/yorb9LlgN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebuRSIuwmKtbAjRXycCpUAaZa4aOMlhTRnAbXkzXTtPCXHLUu/Nh17OWlpeIMo0SQGXxUKFDnAtii3V+JYFqlgylJSiKdiqMyaRMF1IfWtV6KnBTtuypn66BNgjw0BPl3L9xVe761SmMtW9eCdUMUtQqrWr7UjZBNh5C+89mkwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EdQ8Zce4; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EdQ8Zce4"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b79d6a70fc8so317068166b.0
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155279; x=1766760079; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jxzWfCuZGPGEIkmHhlLNui+nr1vXjBhFCqjtzKiI298=;
        b=EdQ8Zce4T6mLOlN7X/MrF0cY3V5YqFi8DI4Uywz5bfrHLD3XZmVa6xNdgydy7wURyL
         x02GR0RTyfEv6rrInI+PBSU27wR6gZjK1SjPdtJVeyq0PK/UrBzA8bygDgzfHcHJg3at
         SlyGwUt8vlObpmIvAdWNTqReic1S+JjxPkCc7thIGAg7Hf+6psWTsHxbo0Wno8B8859K
         nt9xDyBCYN2Ft21Q0KBbXeGYu3HlN3+EWq3wB46muW/FHhP4ySLRVMdDo2XfDUXokrJ3
         4JYR3iZ7Jq5lDiL+aivTkQbEAg5FORNtti/rDcHHnF8gqNu5rzxVsDWRyILXe4I2wJsE
         cqTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155279; x=1766760079;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jxzWfCuZGPGEIkmHhlLNui+nr1vXjBhFCqjtzKiI298=;
        b=ieEEX6lATqXvLCLNmBmbmB0iuassenDQF3co0SnOfWtS3Qk2quL3bksNdR7ckm0O0y
         JGwzWRrJr6W5rwgw/e2/SJOjKnckdvIGa9YwZODIOF5aPTTDPxvVirAINwILxdWkownE
         KRGz1rr7bRihI1waNTHrYeNkqDX1sM+lgE9n7fTDdR1cpCIgcX4M7rME4E7FkZ+fYApQ
         X+IGUJbVc59jLxBaxXEJjCO1KtX/coBuVvmz0L2TGrHLrhrQxxM/k3lOTarFIH9ylJWg
         LexoI1yu4bcjQCM1CR/KHNrh5QyOnh/O2hbFxrRpDrELUEFhqpmP84QITPXGolA1BTtQ
         athg==
X-Gm-Message-State: AOJu0YzGF8feidFPcqQhlzETfK556nmWCApiDFPpM5VCifKdiTyCR96s
	PhmLc/BPH9JZ2BMIpGDktrw1aEbG1obbBfmBGblvnonWYJtI/pXrs+fS0RsjHiZ+1ISlSXSvIew
	2qaTF
X-Gm-Gg: AY/fxX4Xy4zlb3LL4hW/bQeLkXbQd6qYLy5pChjBbXsaDYo9nbbnGfEbT8wL3odBTbB
	jWXbWtkw4jPm1YRP8jOnGchZn7qOBz5R8l+2g6Zmbwtqc23y3R37Mkza/xVFuo1+remqlskICSd
	Xd0I+n1UElG6zWTs5K2hrWGfbWuwxUC6aQs/koS4v7ekJHySJ3yIHOMDIJ/TUD/5Bd7t0B/pNDV
	cIBapoXauBNeWuJID0YeZBDyc3qNPOWMm1/NqgdW96ztYz3V+4WHx/aLraVXl14tLFi34rsyjDo
	xs7FYwfl/QNzFIcvgGnKOoHZLaKWx/DW7yuelLTZXGXuj/jDvymeDXcodJvxmeQj65XUhR2VrAe
	Wy9AQFuxh5g0/zsP1XRISHR/WEYZ2AE/OpkcsE1Qp5+96Cfe99DRpjfa4z/WcC1HPiN58EjUgSP
	NueIAEaqMUXGsU4RRCjZPjJfCQ5jahWOuNSrqZTFZfkx4Sl1qmZ60DrNrHbULo4z2FaUWIv0iHq
	A==
X-Google-Smtp-Source: AGHT+IHkUiCuADPxrsVOHj/QAM20fQTwsVbwMvhWfubhFAhQon/OsKQhwLysfs0FeukGoyrW2tYIRw==
X-Received: by 2002:a17:907:1c0a:b0:b7a:1bdc:aab8 with SMTP id a640c23a62f3a-b80372301femr306334166b.65.1766155278928;
        Fri, 19 Dec 2025 06:41:18 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b8037f512e3sm246188166b.67.2025.12.19.06.41.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:18 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 02/26] libmultipath: don't access path members in free_pgvec()
Date: Fri, 19 Dec 2025 15:40:44 +0100
Message-ID: <20251219144108.237928-3-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219144108.237928-1-mwilck@suse.com>
References: <20251219144108.237928-1-mwilck@suse.com>
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
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 1cbbea8..cde5991 100644
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
+	vector_foreach_slot (pgvec, pgp, i)
 		free_pathgroup(pgp, free_paths);
-	}
 
 	vector_free(pgvec);
 }
-- 
2.52.0

