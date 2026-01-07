Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557D0338585
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817126; cv=none; b=kkf1DU4ScsWZ6t3kWKPIfW9unf+odiX3eQrAu0iCfDw9JwrmkFJOcocThtYVY6CYoZ+sgBTSg8J1XkTP06HhPyOk4CJjoR4HkVs0bos33XRv/71RqYvxlmXaP0ujLx7AwW1nmjVZKcsyZhUu6nEuQHlMDgQ31iUz4BR3NaZmUwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817126; c=relaxed/simple;
	bh=CLN3yE6fOnt8I9K7wg2UbrJtK2U7Nkec/yorb9LlgN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5xNDxYZK9dRZyxWxc2AFQYqCfgjQMqv7AOiYO3+aDd8pePHY4n7/yzOKH1043GdXVMjUputVPqd0IkOJDL6loHr9pomPzITQs5/fLyT33Gf15lL7PkYHc2+aGONSsBC7QPT43hW8iEmHqj6H1V7ixOkens49ehbwY+KWwRSTFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YEYc6V4X; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YEYc6V4X"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b7a72874af1so465719066b.3
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817122; x=1768421922; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jxzWfCuZGPGEIkmHhlLNui+nr1vXjBhFCqjtzKiI298=;
        b=YEYc6V4XgTQXQTshtIEc0k/89zp8SXJVocU0grXQ+vWSwE8YzD6puchg5HSHmNWh2S
         tNYciLmk21mnmMDo9aFOhyYE42SFOweCidDY4PPde8Gz98WWpck2OAP5CcCNqBUdx284
         9m7GFZWTc8m58HPWxzvV2AoBFERLp/CLaEXJZkfRmF8uxOUwdwxwmCGt8fOG3TRs5sb5
         qjMlv1Z5blLIIgcGCaRYdVJyS/GXYMHxqGyMdZ+MOCtqpm9/lJhDmRpH44MYK9YROVmM
         m+kHZr6XOL1BS62pBX+neG3BQdWCKyY7/0yrBJYliFSdtUV4QVofvdVzsY8XsY4TqgI1
         9xJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817122; x=1768421922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jxzWfCuZGPGEIkmHhlLNui+nr1vXjBhFCqjtzKiI298=;
        b=SBtp+sy041CA6yPyyl31JYFM/N/jLgHKoVdCCqB/cwm8J3xYKvP0p/Ozr7fqMx6LPr
         ppRvRFLHNMSPSKiqhTbTuYD/3Gr7YbmA8mel7OOhS8hZlNtL0lYdki3AINPpl1mX1Zp0
         LJfNZminKYZcAwgWlAPKqN98iZR9gjNq8sqUZXfWerSs6/36iUmzwsEDhsVwmwkRGLhL
         KBfpvwhIJfxMtc/ptsfnQQelGydjkn7FFw+Fsje2jcSAh3EUZijdiqhSSsOKig3rMyv8
         3agL3PDOBXQ168myRaFfyk8+4hpnsHezMB0V3iVAdY3PgJxauskewdogR+UWAhnUPIuE
         9WcA==
X-Gm-Message-State: AOJu0YyPRJ/yMoKMGPNmwhfCKy/Y8pASFklKACCElMsrZaKNoOnH31t0
	JjpbcU3jz7cm/7nxN7PRxjEeUBL0c0Ru1tPoYEWo/EpO2xL2NMTXVByWHBe8dkNGd6s=
X-Gm-Gg: AY/fxX4IYn6cQWsKpFs2B9IzqX2kykJblsFpI+dEo0F9thf8MNiNmsbDdM+DYbDF/X4
	wLzseB5dpKteoyXnhmxauVMSdFfZKSZqOJhI7O7Q6WQwV64/6jiPJxSGVai+8adub+UkzGoVCLI
	Qr8tdXxtLASmuUmhzUV1LvHMqvsSzB24WrZgj8PFqMvJhSgUc/YeE0YgTREIFUkiYgapqe81pbp
	+aMR5qMb21DURghVZClngBJsGCCBPS/CauMsx+3p16rD9gLfKlPvNfl6bGACy7mLDTqzxjOz+4P
	3ifsd87ymhrl3ieNEFhNf0slvWMeLcXhNvQEY1cdm5j147JIR3UhQevQsAK2uMYhJAaNzN5NBTW
	/8ZsHBZFq0qF0Q0bB7K0Wz8Bl+LCveUvZXBkXP/nldlQsbD7s2eKrIJFJtrg9mmb+ungeYsaIFg
	wn2Dt3AMTkLrn+AAIJsIIIwxJITi7eOeKWsUnKZk/RTLMasO0iMmNmI4ld7DPs6iIWG6ANlyH9q
	Q==
X-Google-Smtp-Source: AGHT+IGjL64BPr/ZBdP6mSXyZXUCHtF2DZABkmTwzyN2vcTJeUj0z670i72gFQq1m22F2/3QyxiGAw==
X-Received: by 2002:a17:906:3199:b0:b76:f57a:b0a7 with SMTP id a640c23a62f3a-b8444f6f7eemr263249666b.31.1767817122362;
        Wed, 07 Jan 2026 12:18:42 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b842a5118eesm594626866b.52.2026.01.07.12.18.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:18:41 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 02/26] libmultipath: don't access path members in free_pgvec()
Date: Wed,  7 Jan 2026 21:18:02 +0100
Message-ID: <20260107201826.323977-3-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260107201826.323977-1-mwilck@suse.com>
References: <20260107201826.323977-1-mwilck@suse.com>
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

