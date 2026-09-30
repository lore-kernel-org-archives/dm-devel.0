Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CB54CC63A
	for <dm-devel@lists.linux.dev>; Wed, 30 Sep 2026 19:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797114; cv=none; b=t72FX2nwRWME6+IGVLM3ndQv1rEoRbvZxmxRIp4fucqf+oNgS/Tg/4FI1t+XrmRWABR1Y0BajkTCJZhB75bGYY+hAE4Fxm8ZCpjY9co+oQlZpYoqderOcvmdrjnQ3+qd3A5Njr5WMKSt35d+MdinjSxpBBfgm79dr9Xyy/YvmZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797114; c=relaxed/simple;
	bh=YzTg0JRi8nxdZLzO/WArosUJAXHoUh3eGVcTojav570=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=udb7BT4jRm4FH00ZgGD2np6s0r38mI6cff5sZFPu1kC+iZGpDf/qG+ZdjR4+YQ49ygMzvIx1MZHwm4Hl8to4ZgBPkOu35HfG+Cs4Lg0YQUnYbEOdZzZ0Lb0tCBwBd2bT6nBwwvfEF8P51jFE35TNe0up00ecvk5W1O2+mueArvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AThAsSoG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AThAsSoG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790797112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=Fu7DR2jOGIkK3VqKSeMbr5y64WpqlBrsgyVbIX2gGZo=;
	b=AThAsSoGzGs7DmEUPLLBB0jVYDk1Wq6iR5N35TpInXBbEewNoaaWqigYH3H/AKQrshaveE
	6zCL04TxdKuUYa5Oegx0Sq7tf/kkC7R0v2iAcFTIMTwGi4b7Hcz7W6yMpSthKHmD5CIXgq
	vdlgdw+NcqvaRKkj+SiB4GlMpgzZuiY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-78-Ln2MoM3uOryAsaXES97JTQ-1; Wed,
 30 Sep 2026 15:38:30 -0400
X-MC-Unique: Ln2MoM3uOryAsaXES97JTQ-1
X-Mimecast-MFC-AGG-ID: Ln2MoM3uOryAsaXES97JTQ_1790797109
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1995B193E8C3;
	Wed, 30 Sep 2026 19:38:29 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C71531956095;
	Wed, 30 Sep 2026 19:38:27 +0000 (UTC)
Date: Wed, 30 Sep 2026 21:38:25 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH 1/5] dm-writecache: report I/O error if flush failed
Message-ID: <2bcb8398-e8a3-c1f1-ddd6-00f99d2b2ce3@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _rhzHkCeL5Ekeg7lbWWZZ-pVPZoySyecp8QfEhIIWZ0_1790797109
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

There was a bug that if writecache_flush fails due to I/O error, the
error is not reported in the FUA bio. This commit fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: opencode:big-pickle
Cc: stable@vger.kernel.org
Fixes: 48debafe4f2f ("dm: add writecache target")

---
 drivers/md/dm-writecache.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c
+++ linux-2.6/drivers/md/dm-writecache.c
@@ -1493,10 +1493,13 @@ bio_copy:
 		}
 	} while (bio->bi_iter.bi_size);
 
-	if (unlikely(bio->bi_opf & REQ_FUA || wc->uncommitted_blocks >= wc->autocommit_blocks))
+	if (unlikely(bio->bi_opf & REQ_FUA || wc->uncommitted_blocks >= wc->autocommit_blocks)) {
 		writecache_flush(wc);
-	else
+		if (writecache_has_error(wc))
+			bio->bi_status = BLK_STS_IOERR;
+	} else {
 		writecache_schedule_autocommit(wc);
+	}
 
 	return WC_MAP_SUBMIT;
 }

