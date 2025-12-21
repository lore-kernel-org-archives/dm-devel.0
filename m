Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975DD226CF6
	for <dm-devel@lists.linux.dev>; Sun, 21 Dec 2025 02:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766285595; cv=none; b=Yqcu3OLl/O/oTDD5VE3m9DGOAELY+zguwRIGgvIWOkXSdM8pCD4y2oIA5cKHC4t5lHdBfCylkp5L3983GOt2qpgwEoAKO19EvHRCwZxSrY4i5vpvlrOSZe9kJH6i/l4/MxSANAGtN9p+BfnJcbiA3olBg+J1B6L3p2G8VdCnYnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766285595; c=relaxed/simple;
	bh=HlLo7Z5T3L6YW5WV2SYQGIzlE+yrnw5rN480ipz1cY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uO+0jhevm3Iy0AJU7OqS0bvC2jEp2x79FmdyV3vDhYGbT2S5ZhIbgn198WDNUZaUa5yuEc8xAR4N7njncDobryF6eWHAM08ItvRWfHUUf1w8NN+GwJEibXavGkFidLsNSHztmHJv95gcM8D7JITKk5a5CCc2AqCGYZaDWhJrgYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bSRK08qM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bSRK08qM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766285592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NXr1FXAq9kqTCI2jVu7X1Njix3LfG6S6ti8goKp8pAY=;
	b=bSRK08qMVoZw9KA/qQ8FQBK4WFWbGtH5rW6Mlahhi1FiRCqTQibONEZIbVlxFDSfsqlPXK
	Rf0+FVz9NtjW5SvGqNzd1RqCPavmgOVQqTbWeI9byZpa/7BCfepXeGatv2RnG1wBL9iSln
	d77MT4OySsFRq+K4/IhQrzNmZS0eRQE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-153-DS8p6C_BOSWeLSDTHIzoLg-1; Sat,
 20 Dec 2025 21:53:07 -0500
X-MC-Unique: DS8p6C_BOSWeLSDTHIzoLg-1
X-Mimecast-MFC-AGG-ID: DS8p6C_BOSWeLSDTHIzoLg_1766285586
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B4B07180028B;
	Sun, 21 Dec 2025 02:53:05 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.44.32.8])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 20347180049F;
	Sun, 21 Dec 2025 02:53:01 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Satya Tangirala <satyat@google.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC v2 07/17] block: consecutive blk_status_t error codes
Date: Sun, 21 Dec 2025 03:52:22 +0100
Message-ID: <20251221025233.87087-8-agruenba@redhat.com>
In-Reply-To: <20251221025233.87087-1-agruenba@redhat.com>
References: <20251221025233.87087-1-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Since commit 9da3d1e912f3 ("block: Add core atomic write support"),
there is a gap in the blk_status_t codes and block status code 18 is
unused.  This causes errno_to_blk_status() and blk_status_to_str() to
return incorrect values for that code.  Fix by making the blk_status_t
codes consecutive again.

Fixes: 9da3d1e912f3 ("block: Add core atomic write support")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 include/linux/blk_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 44c30183ecc3..044a7cec1d70 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -168,7 +168,7 @@ typedef u16 blk_short_t;
 /*
  * Invalid size or alignment.
  */
-#define BLK_STS_INVAL	((__force blk_status_t)19)
+#define BLK_STS_INVAL	((__force blk_status_t)18)
 
 /**
  * blk_path_error - returns true if error may be path related
-- 
2.52.0

