Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DA91D90DF;
	Sat, 20 Dec 2025 03:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766202590; cv=none; b=Q0asKfyk5eJ8JrC1QfOC1BgvNO0BV2Stwt2OzGlDjYi+oEDKBLsQObwKaVRP/RJMKbWqVpZBl7DCGeTOxabgEIeqF6D9T5znSqoqA+yYb5hpB1pMDY8iCbOxV5zjQ2Q/0PczzW7ijFLSykT84wvTt/qDRxlPS3fvhq+EO0kQbSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766202590; c=relaxed/simple;
	bh=QWh9rxCDoyp2juQL2Q1ZXFFSFiSU37YjjmSjsZmDVc4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Sz/uCP2i9Roh7lLMF14aIr9l4h6I/T59DjTZxy+rD+wf7W0yJetX/UV3V/rWVgd4SbP4iXW3orXI4TvlW1ji4FAEKzeexixEugrVmjTyWGT3V2tykFRPfXMkI/9v1HhW+pat9R4/yzvzpT3AZ8ZzERQyw/dk5Hi5b2qVKoI8nLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nFs1me0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nFs1me0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40163C4CEF5;
	Sat, 20 Dec 2025 03:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766202589;
	bh=QWh9rxCDoyp2juQL2Q1ZXFFSFiSU37YjjmSjsZmDVc4=;
	h=From:Date:Subject:To:Cc:From;
	b=nFs1me0NHvzgDwN0vE8GxjlcUSL21L5JGQteBCscNwpKpAIDAMKXnmXn00a8OkPoR
	 lLWudfZKFm7IRQTWeYT+7SDgTk9YIgntpZfdcZ0AhYQ8lI/gS/d5J9ENBqmVskPNJU
	 loHutJ/GNoMp8FFiENs97+NWWxP5UDo+hRgD7sDNTQl97P4AdqZfCiXsVK8pYRviWW
	 0O7yw/FXDW4uVF7ImgIn1Sv5ivI0MOJSfUh0+T23GLAe2IQs6VVu60jsyy3RokqDyA
	 lmH1WkywZ6f3Bw/hX//SxVQGzEHbtAfSwFMcoKfWZZQzuCRIv1wVTOV1BwQtjUV7rk
	 5612b2g9BNXiA==
From: Daniel Gomez <da.gomez@kernel.org>
Date: Sat, 20 Dec 2025 04:49:37 +0100
Subject: [PATCH] dm: replace -EEXIST with -EBUSY
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251220-dev-module-init-eexists-dm-devel-v1-1-90ed00444ea0@samsung.com>
X-B4-Tracking: v=1; b=H4sIANAcRmkC/x2NwQrCMBAFf6Xs2QWzkqD+ingQ90UX2lSybSmU/
 rvR4zAws5GjGpyu3UYVi7mNpUE4dPR8P8oLbNqY5CgxSDizYuFh1LlvptjEwGo+OevwU+hZNMW
 UL1lOKVLLfCqyrf/F7b7vX13hMfhyAAAA
X-Change-ID: 20251218-dev-module-init-eexists-dm-devel-2d656f9f2365
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
 Aaron Tomlin <atomlin@atomlin.com>, Lucas De Marchi <demarchi@kernel.org>, 
 dm-devel@lists.linux.dev, linux-modules@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Daniel Gomez <da.gomez@samsung.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3952; i=da.gomez@samsung.com;
 h=from:subject:message-id; bh=MG8e+vxiY9C9ehStOyYYHRRXlZKUpSGUgXejP7etWME=;
 b=owEBbQKS/ZANAwAIAUCeo8QfGVH7AcsmYgBpRhzZeZlSIe1p2xlI3eFIWTKBGw6SEvI3Bn1vw
 rmtxaeFxnyJAjMEAAEIAB0WIQTvdRrhHw9z4bnGPFNAnqPEHxlR+wUCaUYc2QAKCRBAnqPEHxlR
 +346EACVULz1BLBsWaPWpD4Z/3jTvDiinEDK8Ekgi5Cc/7TBCp8VVusYMRUyHqOXKNfbe/8J5+B
 Qe35rFvildNH6bhrbvmDm3pwJpFEfCORu2zFZg/AyUfhyD0uO0C/9+7yfjqYNJ47uOU34uN+GyK
 rLRCfBGMMFTN/rWQm8mrhVTp26zNCuWTr7X/u8+gvyir/4Crid7c78bMbq0Vaz8+3Arxyjpt2Pn
 Bcn19Y16B+31RXuGTryDg0qJ/jhb0eWMjOrTrnonytFK9Bg8vAM9+GeBnCuVZBONxReeiR1tnRP
 Zcs4iYfSU3Wl3Q+Qs7/sqdIYpyU+mXXAhUq+GkNMabrO3sulfzZPx06nM4IZ14/w4W2AKoenUrf
 fctDw/VOBGjQZa1GlCorRjvL3pbd5PUWwAiUldzJvWYyjZPCZbCyuhFS9K6zwKXBHUHuoaxARyz
 2rJ7VjNu2CKkL/pRC/zMa6StbxLVvZ4OwGzDm5A7SUJ7Zs7/WuDfq8UOZ/HfZNU4ekpNXJU02zs
 7dHz7OfHKTFTNH3NL1BYnYnDYaHcxo4DG1G71j2Eea2Wjix3hBep4mkAW3S881n9IMq15GXRaG3
 mIMIXCES5MxDY7SJNuy6mnnQUtrQKRPfnBlHlRj5SuamMaQTt8ey2ZwOWoDLjGEjh3lRzW4ywLS
 HenzJUJsDYyJgnw==
X-Developer-Key: i=da.gomez@samsung.com; a=openpgp;
 fpr=B2A7A9CFDD03B540FF58B27185F56EA4E9E8138F

From: Daniel Gomez <da.gomez@samsung.com>

The -EEXIST error code is reserved by the module loading infrastructure
to indicate that a module is already loaded. When a module's init
function returns -EEXIST, userspace tools like kmod interpret this as
"module already loaded" and treat the operation as successful, returning
0 to the user even though the module initialization actually failed.

This follows the precedent set by commit 54416fd76770 ("netfilter:
conntrack: helper: Replace -EEXIST by -EBUSY") which fixed the same
issue in nf_conntrack_helper_register().

Affected modules:
  * dm_cache dm_clone dm_integrity dm_mirror dm_multipath dm_pcache
  * dm_vdo dm-ps-round-robin dm_historical_service_time dm_io_affinity
  * dm_queue_length dm_service_time dm_snapshot

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
---
The error code -EEXIST is reserved by the kernel module loader to
indicate that a module with the same name is already loaded. When a
module's init function returns -EEXIST, kmod interprets this as "module
already loaded" and reports success instead of failure [1].

The kernel module loader will include a safety net that provides -EEXIST
to -EBUSY with a warning [2], and a documentation patch has been sent to
prevent future occurrences [3].

These affected code paths were identified using a static analysis tool
[4] that traces -EEXIST returns to module_init(). The tool was developed
with AI assistance and all findings were manually validated.

Link: https://lore.kernel.org/all/aKEVQhJpRdiZSliu@orbyte.nwl.cc/ [1]
Link: https://lore.kernel.org/all/20251013-module-warn-ret-v1-0-ab65b41af01f@intel.com/ [2]
Link: https://lore.kernel.org/all/20251218-dev-module-init-eexists-modules-docs-v1-0-361569aa782a@samsung.com/ [3]
Link: https://gitlab.com/-/snippets/4913469 [4]
---
 drivers/md/dm-exception-store.c | 2 +-
 drivers/md/dm-log.c             | 2 +-
 drivers/md/dm-path-selector.c   | 2 +-
 drivers/md/dm-target.c          | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index c3799757bf4a..88f119a0a2ae 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -116,7 +116,7 @@ int dm_exception_store_type_register(struct dm_exception_store_type *type)
 	if (!__find_exception_store_type(type->name))
 		list_add(&type->list, &_exception_store_types);
 	else
-		r = -EEXIST;
+		r = -EBUSY;
 	spin_unlock(&_lock);
 
 	return r;
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 9d85d045f9d9..bced5a783ee3 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -121,7 +121,7 @@ int dm_dirty_log_type_register(struct dm_dirty_log_type *type)
 	if (!__find_dirty_log_type(type->name))
 		list_add(&type->list, &_log_types);
 	else
-		r = -EEXIST;
+		r = -EBUSY;
 	spin_unlock(&_lock);
 
 	return r;
diff --git a/drivers/md/dm-path-selector.c b/drivers/md/dm-path-selector.c
index d0b883fabfeb..2b0ac200f1c0 100644
--- a/drivers/md/dm-path-selector.c
+++ b/drivers/md/dm-path-selector.c
@@ -107,7 +107,7 @@ int dm_register_path_selector(struct path_selector_type *pst)
 
 	if (__find_path_selector_type(pst->name)) {
 		kfree(psi);
-		r = -EEXIST;
+		r = -EBUSY;
 	} else
 		list_add(&psi->list, &_path_selectors);
 
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 8fede41adec0..1fd41289de36 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -88,7 +88,7 @@ int dm_register_target(struct target_type *tt)
 	if (__find_target_type(tt->name)) {
 		DMERR("%s: '%s' target already registered",
 		      __func__, tt->name);
-		rv = -EEXIST;
+		rv = -EBUSY;
 	} else {
 		list_add(&tt->list, &_targets);
 	}

---
base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
change-id: 20251218-dev-module-init-eexists-dm-devel-2d656f9f2365

Best regards,
--  
Daniel Gomez <da.gomez@samsung.com>

