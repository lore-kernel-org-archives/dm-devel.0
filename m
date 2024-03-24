Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE081CF9C
	for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 21:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711314803; cv=none; b=EZBNdl0vfPkp9c8vPLaOQBK0cAfI2QZl4DaL8V2/gTPGARlS54j0V6LDgpuTQRx6HktbiW+AFGbbyXNmLZ8fLmiCLYKNAXvQIaRcgnFsTzNJslr8bcKCqlMLAmvpuSss3TdpjqmQ8/SWbgspkbyazJ6tIRDz0m6oMvm57+/llRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711314803; c=relaxed/simple;
	bh=Y2K6qR17eHxvoUrOzS1SfeffRCN2g6M1mKdeyozEZb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mx3IEFptrxKmh6+R4SuK89rGeJ6DXUI+WVDV0fGV78Xf+pRM+1NT12WN4WeOOdWrJwwk/n3kfbRw+p9TPPY5QqH6VYxahIWHQ0G1YkipnTTV4IeWYu/hqagDz+KgMiRlcAQCsLIsD/ZKvchJIytDDOiJnJe51bzFsMxuMxd0J4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HbdATqu+; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HbdATqu+"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a46d0a8399aso798627066b.1
        for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 14:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711314800; x=1711919600; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3K3YB8hVLkNzQmbktZJfx433a3kH+4eiUqJXesv88Qw=;
        b=HbdATqu+YCUa5fAVFyq7/XIgBiNcnTl3oVIqmT7Ug68lqaa21QN2FhNWUgPARVxBMX
         ijauZgsG1NfK1XArQHGjLIVzpYn3O0vkVTr3uI//uzksv+QpaKTjuc9TbJuwiSYhleeo
         wQtiKVE+3lmkq6jPR3DUzPB1hIrG8PclK/gOn1PqrJZmzdL8TCnmQE1QA/h7BNRVjSeH
         HbHinccX8KkMUxt3rmSlYPT9zt1XtcXaVcHlDqzE7akw0PI7UqTbK2pmcYtg7FityBi/
         704flqZ0JVp9KjiRECUK/S6JFDkmYyEdT+vto44rnSCs5bmPA0WWJ8YsMnHvHdrjrqxR
         8ucA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711314800; x=1711919600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3K3YB8hVLkNzQmbktZJfx433a3kH+4eiUqJXesv88Qw=;
        b=jOpN0CC0nUID5IgDeSHVRIjmhukrr/VjgLy0ZFtJXtg3+aP8G4y8DXSYgaNMtsF/zW
         gcTxqN7zx5NrWQxOLmoVK+BltJYYdtuOgndIu/eAfTh87YRsxhiyfX0+0ZqTlibKwYAq
         MPXIj+rg+vQkdeeJ5EZ2FIKH2P5b0aYqw7Z9RNWbuv78INBFgPjcrouee1H78qruIye5
         CgfrgIW6xNYZzmhU8VZpH2SjltEagtspr4Zmwr96vh5ANOVAqiVLYFeXM7bRu3hNNGge
         skcmgYGKgxGcZC0O/dweOTi+puDOC2gQE3JrGKHTutyDxVY/v4NUxwUSGmaPc9A+c47x
         S2Zg==
X-Gm-Message-State: AOJu0YwVBg2b9/dMGRKNckf9axeU1GVBbZDVim/J7qJ8hW0Wby4iBdMF
	pzUpptIj35zb9ELkNFybqSqToZ+2S5CP2sx2CsL5V6U8lXKILpetT43QemCvoeg=
X-Google-Smtp-Source: AGHT+IGXGA5Y2Weobv9XFvZj74lqxJnRGTJAsYxtMba3xcbQHzFT7SgPrUiZzefELSu4Dk/40oPq8A==
X-Received: by 2002:a17:906:6713:b0:a46:8227:2d0c with SMTP id a19-20020a170906671300b00a4682272d0cmr3840836ejp.1.1711314800141;
        Sun, 24 Mar 2024 14:13:20 -0700 (PDT)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id lv16-20020a170906bc9000b00a464f709687sm2314720ejb.59.2024.03.24.14.13.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Mar 2024 14:13:19 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 06/11] 11-dm-mpath.rules: don't import properties with new 13-dm-disk.rules
Date: Sun, 24 Mar 2024 22:12:56 +0100
Message-ID: <20240324211301.7200-7-mwilck@suse.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240324211301.7200-1-mwilck@suse.com>
References: <20240324211301.7200-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With the late changes to 13-dm-disk.rules, we don't need to import any
blkid-generated properties from the udev database, because they will
be imported later.

Except for ID_FS_TYPE, this actually holds since lvm2 commit 94f77a4 ("udev:
import previous results of blkid when in suspended state"), included in lvm2
2.03.19, but we have no simple way to detect the version of the lvm2 rules.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index cf004fd..8f22954 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -124,6 +124,10 @@ LABEL="scan_import"
 # have never been properly set. Don't import them.
 ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!="1", GOTO="import_end"
 
+# DM rules v3 will import missing properties on 13-dm-disk.rules.
+# No need to do it here.
+ENV{DM_UDEV_RULES_VSN}=="3", GOTO="import_end"
+
 # Don't import the properties from db if we will run blkid later.
 ENV{DM_NOSCAN}!="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}!="1", GOTO="import_end"
 
-- 
2.43.2

