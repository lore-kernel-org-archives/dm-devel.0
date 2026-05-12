Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8253EDE59;
	Tue, 12 May 2026 18:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609056; cv=none; b=B0h1kCwXuIXc5iu/+mzghTv+oShCc3pfuEFfnSd3wq4LDPMryrdrC8FZ32xnUMhiDYGevr2AyYgIJub205v5OX49A74cBOsiqlbP2d2jERuLscCsYjojE1jiV11ZvJeaDTHk0Bv56nLCMjLrP6rdl5w+I5PGxRPNHf1RPwLU/XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609056; c=relaxed/simple;
	bh=4wTiUWk+kXDfsSDTUkqMRFg521OYTDMxR3952/wrLf8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ka/Z5mJ4vT/NV6Rct/IsM7ZNRAC1+4NmzXMZCk5Ssk++6aXuF6CbQhB77Wh9vRXAvmMLP9kjPVH8nbeqJWstyYt/bcOHNQVqTigM5yVkRblPtoU0Dg3XyCZG9xijR2t5omZ05eYXnSPAqOo3yyMVSk86eoDZQcD1lo96O1s1e2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nPiVuNxX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nPiVuNxX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Jv9iEDDVJEBKZBfKo5BN0Msjy+MqMxFpvywOcjoM8zU=; b=nPiVuNxXKrbFE3zHF60q6sRYtp
	VF6WxC/lJ5YR5Y5iCGh8H3dEgpiB6P+D0nSFScg2rAHlVwKHTDfpyvWnl+G+D98CjOObQICGen8xs
	XwQamf6wIry9FFLv7HS9UQrDvsVT9XmHVTpIf6IsOMBzaIO6TAEKPhwSTERNA8YuG6GWUOGpUDZGT
	K3kOGX5RRxZ7q4Y3T2dTwEX2azvevDw2a/oaSo1tRP+e77wE4IOMAClrL+C/gW7Kgu7cmJcJ+8gkD
	0fGd/yRLpPUNZuGsKsKC6r7kDqGXBqW5WZN3x1YybgRdOmxhOiPM4E+LQgfCD1tAiVV76aNk6KXeU
	yZFHnARw==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMrSk-000000002hu-34qZ;
	Tue, 12 May 2026 18:04:10 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Linlin Zhang <linlin.zhang@oss.qualcomm.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH] dm: fix dm-inlinecrypt docs warnings
Date: Tue, 12 May 2026 11:04:09 -0700
Message-ID: <20260512180409.1193504-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add this file to the index and use a longer heading overline string
to eliminate warnings:

Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst:1: WARNING: Title overline too short.
========
dm-inlinecrypt
========
Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst: WARNING: document isn't included in any toctree [toc.not_included]

Fixes: b4a0774bd7fd ("dm: add documentation for dm-inlinecrypt target")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org

 Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst |    4 ++--
 Documentation/admin-guide/device-mapper/index.rst          |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

--- linux-next-20260508.orig/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
+++ linux-next-20260508/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
@@ -1,6 +1,6 @@
-========
+==============
 dm-inlinecrypt
-========
+==============
 
 Device-Mapper's "inlinecrypt" target provides transparent encryption of block devices
 using the inline encryption hardware.
--- linux-next-20260508.orig/Documentation/admin-guide/device-mapper/index.rst
+++ linux-next-20260508/Documentation/admin-guide/device-mapper/index.rst
@@ -15,6 +15,7 @@ Device Mapper
     dm-flakey
     dm-ima
     dm-init
+    dm-inlinecrypt
     dm-integrity
     dm-io
     dm-log
