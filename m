Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C14256C70
	for <dm-devel@lists.linux.dev>; Tue, 30 Dec 2025 15:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.134.164.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767108158; cv=none; b=fm8zSkOvNbUPlpPnEV5RX+ZuM9zHys2Qy2HilCGT0qxhu38ht9nmOVLsp41v5T0D4EiKHj5s2iwaK8pUSqE/SINeRMn2NIRuUlbiq/pUfcJRNWmSVs0IgqO2OMlEI0qZ2lBQFBdpnue7VIo0zB+VIei4citdtyIUFThcjZkTCGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767108158; c=relaxed/simple;
	bh=suIXkmoVQmlzBUmLipBdlApoDeFj2mkohzt3LfyOh/c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eJdCebtkGGs9mOXvM07XHiwtdmiP/lDqm0VxwDgr8wG4eyJaTX1CWQXd5gLwaZ+9cdGbNWDFRjImn625L4mupWTBShG2QA+peNlpqwtGYkGTLF7mHOA5sUoUTFHPF+yKAMt3hujElHJWcZ/vJtARn/Qy6nLfuL5WyfsRJUMwzI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr; spf=pass smtp.mailfrom=inria.fr; dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b=TXsy7mMA; arc=none smtp.client-ip=192.134.164.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inria.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b="TXsy7mMA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BwGeXmrO0Of+jJVl/9dhbuBAE3i4wNQakMB9+Ir1KTY=;
  b=TXsy7mMAxWipJ06hzTCYq2VGcXvSV89stByvK+lrrUjLQsmfJH5qro5z
   X+c2V39QSrEHqnbmoY5qe84QuwDYo/4P4xWjxnnNnlIRp1ZOcClnk1g0P
   o9OMP80B5prwjqblihZkzqfC1F+2//cjJYnmNuYF2ge9qvWPzlpuyWKSm
   8=;
X-CSE-ConnectionGUID: bd+a9HoiQE+fKIUqZyhgjg==
X-CSE-MsgGUID: RpHYAj6fSQKnTayLEuA/cg==
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.21,189,1763420400"; 
   d="scan'208";a="134753959"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.102.196])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2025 16:22:34 +0100
From: Julia Lawall <Julia.Lawall@inria.fr>
To: Matthew Sakai <msakai@redhat.com>
Cc: yunbolyu@smu.edu.sg,
	kexinsun@smail.nju.edu.cn,
	ratnadiraw@smu.edu.sg,
	xutong.ma@inria.fr,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/md/dm-vdo/data-vio.h: adjust function name reference
Date: Tue, 30 Dec 2025 16:22:27 +0100
Message-Id: <20251230152227.97578-1-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no function advance_compression_stage().  But
advance_data_vio_compression_stage() does iterate through
the values of the data_vio_compression_stage enum, so it
seems to be what was intended.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/md/dm-vdo/data-vio.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-vdo/data-vio.h b/drivers/md/dm-vdo/data-vio.h
index 067b983bb291..58a1ac806885 100644
--- a/drivers/md/dm-vdo/data-vio.h
+++ b/drivers/md/dm-vdo/data-vio.h
@@ -88,8 +88,8 @@ struct zoned_pbn {
 };
 
 /*
- * Where a data_vio is on the compression path; advance_compression_stage() depends on the order of
- * this enum.
+ * Where a data_vio is on the compression path; advance_data_vio_compression_stage()
+ * depends on the order of this enum.
  */
 enum data_vio_compression_stage {
 	/* A data_vio which has not yet entered the compression path */

