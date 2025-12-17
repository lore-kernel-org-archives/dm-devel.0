Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393F118AE3
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 21:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006488; cv=none; b=CkRtSE3qAyG9SkmxWtRnj5PtskGWXQNLevD7d7JX5gFTg7epeoHGN/hMoZHhVkKDOIj6UonVVh1rqxJRsVSDTeHthEqiptsnr7B5/k7UVHe433BAyQRFEt23o11jywLRg/GPZwg9G3bvP/1jXQez1ar7PHXDCFma/SSPS8knQ+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006488; c=relaxed/simple;
	bh=Pw+5vQyVWqzXUrDhvEWRp0E1HctMVuL6/2ovv7rgTD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEy+1I8Iik74o348GtBOpGB7dMt8UdVM4Sb8a87S5JsOyC2NAa1LODh0vidGHm5mmyjUQjUOjse2BveOXlx9uB4M1nRe+b11X0Mdo9eNgW9pLT3FLGoHLAyp9SKfoTuhkH2+vez+zx8z5EXL0lvqIHwC7WVRikTX3mPUNhrArrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UjTHN4y5; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UjTHN4y5"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b7277324054so1010043366b.0
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 13:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766006484; x=1766611284; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZuVN2CaIzHjRxEtnG3bWAThkh+zmNjEeqTj9XRn3BsM=;
        b=UjTHN4y5lKTU9HWtJCdZu5MWAZmoIefoBy/HLichNTH+Ud2XZo8RMXkl6HxebYGiYg
         zCNAXLejG9PzjrWxT+fYbgIqovmJumCH7bB437H7kgMQ3RxFpe/ZD2bsC9cIzwkTguzt
         khQDzbLhhsh0iVLMjQ4aEOcGAy0rdwoQJ7aD4iZhu7JkD3tYJ73KaOFX7VSt3Jj9Zbn6
         A9kPz1aFY67am9wY9p70MoaBlUTVgzX3+OstwRZD1V62XGj+M6EIUn2b7jymp2qWQ6gw
         pRVDvmRGz5D8rIAy0NFOgDUEkVZXXZC1g4UpjCpPeDxDzfnFn7A6JM40KK6ikotM1WIm
         DPOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006484; x=1766611284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZuVN2CaIzHjRxEtnG3bWAThkh+zmNjEeqTj9XRn3BsM=;
        b=bnTrXtXqvglLPXdI4N2dFzLv3ytOtj9hbO90K0+ap7VId3GFbCm2JVXe6eYUtorOml
         8k2qzbAwM4t4208VJJwvxNIkBjLDq7Sa6Grc/Zb9pka7rAbX4/3la3qSakgOli/Wyxz7
         YCXwI/30EGmgXm7pbsFjwJkY5RdbFWPTUAFAhN7BLCb+eeNOIACcnN3gmMK8DyLgZSEK
         Jjw/rdYnKEYA6PbPQ9op0V8XuKKYjGaZ6AXqVKZJYVVdr1OeRsxA/pYV2zPT6bWIhtHO
         sA8A8BeOud9lGpmfhfehsYYJTPIhx+Y2+a/9Ty62BdS2Mk6+vo1fbxWkW7MJK3YhVtfE
         iBYA==
X-Gm-Message-State: AOJu0YyCH1h0Ouh95LOAKpVCdF2EaQmsAbDsDtxDhFR4L8JwGdC05cqp
	6hEmG7IbcbOhaSeWhcpvXsF17yNDxVII8Yt9eO2qFnwHfWZEFkrBrolEhHLALIyZQaI=
X-Gm-Gg: AY/fxX7nBDG5NMI9SatrHakT6dR/MCbfZsuFTC+FpFdpyorLZxIQo3Jix0S5XZTjNQs
	nxl5Ma9qhAo0OLjL3hPYZkyCgP1YQlVERANG6QakcwKEQtizs1gxQhNMxjGkcRn40/j0vS0LuMV
	Nv+C0f97IIjpnxJ+icM8AXb8b09KUZXKbB13v/xbY1Gnm/yNGakLfNEnE8LbM4uA4ea0jvKxJH6
	xZoNlCQlBFOEvbRNHNEqNxjE5DLmMGnvgSius/oA9KIJj8hOPA6AdTdhjWLL1jvTK4wZcqnd3h5
	HeywQBTN00dz7AFDLCcvOILMtfM6IIfpqHb0ErvYQIPe94cyCocXH0Qsch4IS2kygr6kWdFyHE+
	95WBDjcxqSlr32QvFizaExzH/g8MtCIQfGKjlZSVsbkyzuy8uZoQ+FTB43DsxstJQB/lATX522H
	yfkKRVm4Hy4A45LBIQw31iNRaCTQD+VuV7l02Pw4QVWn3j/grs/zTp6wYWSSagWHfRdPzq79Dgk
	Q==
X-Google-Smtp-Source: AGHT+IEHGeCM9LYvx5w2+m6sSbjcD9AdlDWTq1Hei5pXh7KwQA5ciwj2cJTZpb8Uz4VxiALKxHrZ8A==
X-Received: by 2002:a17:906:ee81:b0:b6d:67b0:ca0b with SMTP id a640c23a62f3a-b7d23a7b1ffmr2029346366b.61.1766006484148;
        Wed, 17 Dec 2025 13:21:24 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b8023118b0dsm30458466b.31.2025.12.17.13.21.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 13:21:23 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 03/21] multipathd: free paths in checker_finished()
Date: Wed, 17 Dec 2025 22:20:55 +0100
Message-ID: <20251217212113.234959-4-mwilck@suse.com>
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

Modifying the pathvec in a deep call stack is unexpected and
error-prone. Free paths in the checkerloop instead, after
having synced all maps.

Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/libmultipath.version | 1 +
 libmultipath/structs_vec.c        | 7 +++----
 libmultipath/structs_vec.h        | 1 +
 multipathd/main.c                 | 1 +
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 89ae2a3..e5b7b83 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -58,6 +58,7 @@ global:
 	change_foreign;
 	check_alias_settings;
 	check_daemon;
+	check_removed_paths;
 	checker_clear_message;
 	checker_disable;
 	checker_enable;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index f651b29..3a9ab58 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -573,16 +573,16 @@ static struct path *find_devt_in_pathgroups(const struct multipath *mpp,
 	return NULL;
 }
 
-static void check_removed_paths(const struct multipath *mpp, vector pathvec)
+void check_removed_paths(vector pathvec)
 {
 	struct path *pp;
 	int i;
 
 	vector_foreach_slot(pathvec, pp, i) {
-		if (pp->mpp == mpp &&
+		if (pp->mpp &&
 		    (pp->initialized == INIT_REMOVED ||
 		     pp->initialized == INIT_PARTIAL) &&
-		    !find_devt_in_pathgroups(mpp, pp->dev_t)) {
+		    !find_devt_in_pathgroups(pp->mpp, pp->dev_t)) {
 			condlog(2, "%s: %s: freeing path in %s state",
 				__func__, pp->dev,
 				pp->initialized == INIT_REMOVED ?
@@ -615,7 +615,6 @@ void sync_paths(struct multipath *mpp, vector pathvec)
 			orphan_path(pp, "path removed externally");
 		}
 	}
-	check_removed_paths(mpp, pathvec);
 	update_mpp_paths(mpp, pathvec);
 	vector_foreach_slot (mpp->paths, pp, i)
 		pp->mpp = mpp;
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 1188ada..cb02d75 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -18,6 +18,7 @@ int adopt_paths (vector pathvec, struct multipath *mpp,
 void orphan_path (struct path * pp, const char *reason);
 void set_path_removed(struct path *pp);
 
+void check_removed_paths(vector pathvec);
 int verify_paths(struct multipath *mpp);
 int update_mpp_paths(struct multipath * mpp, vector pathvec);
 int update_multipath_strings (struct multipath *mpp, vector pathvec);
diff --git a/multipathd/main.c b/multipathd/main.c
index d3bf4d0..49a1f25 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3127,6 +3127,7 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
 	}
 	if (uev_timed_out && !need_to_delay_reconfig(vecs))
 		unblock_reconfigure();
+	check_removed_paths(vecs->pathvec);
 	partial_retrigger_tick(vecs->pathvec);
 }
 
-- 
2.52.0

