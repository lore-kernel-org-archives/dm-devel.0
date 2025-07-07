Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6301A1C5D55
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 20:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751919442; cv=none; b=V0ydfGM1YdCDXN27gOycx9QK233vqeOKu6jm6kwLbVZ48sE9wo2uZdi2Mf1gy0IbrRA8GLBsRowZ9R8sQjbMIcfhSA9iVkDabLGhNwRM1RbnHqsfsGDJIIFC/1G0VmVXKZ7+Zp6uxKZ/xPNqUzSUCBpzZ8PaiMVBCWv/qRDp0b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751919442; c=relaxed/simple;
	bh=yVuF5SHEUHaijuyW5z50NHMhrRqptIlGfxfOOA3VROs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=hEGH6/9ziY/8ydoKZAqz/fIDwBPaffMkTZRYJuRPWjiIiG3DSzbKP0tV07PXJIJsnBsgHpzj3tDOHGjZSKlJKzp6byizR2VtfK6GHkWhJ3WD9xaszMaL1fmb8zJmMONEiMppvDcRM/xhvuQi7UtRIkZlrNt9sUD1glb9LUP8Wsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jOdJdaB8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jOdJdaB8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751919440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=seUUrM/ASxkxzQylj5TXoU27K7t34g1fgNXZf6f6gGU=;
	b=jOdJdaB8y1Ec1s/sENh1KpfI+iDMsaF4j7QHeGx00wEy7kuSc5dq0dShPrwOePOMwfljO8
	bi7LAfRXLuWP3exL2UN7vWh5YyDbCArJthscmarJo7sWZ+YnIY26/4xDkTtAmzUr4VwcY0
	U3Se6bRu6N3hggWNzyB7oGhbjmtMkHc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-371-NWAj8BxYPlqQ-MyBAbF5mQ-1; Mon,
 07 Jul 2025 16:17:17 -0400
X-MC-Unique: NWAj8BxYPlqQ-MyBAbF5mQ-1
X-Mimecast-MFC-AGG-ID: NWAj8BxYPlqQ-MyBAbF5mQ_1751919435
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 572251944A8D;
	Mon,  7 Jul 2025 20:17:15 +0000 (UTC)
Received: from [10.22.80.10] (unknown [10.22.80.10])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4114F195608F;
	Mon,  7 Jul 2025 20:17:11 +0000 (UTC)
Date: Mon, 7 Jul 2025 22:17:07 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
cc: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk, hch@lst.de, 
    dan.j.williams@intel.com, Jonathan.Cameron@Huawei.com, 
    linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
    dm-devel@lists.linux.dev
Subject: =?UTF-8?Q?Re=3A_=5BPATCH_v2_00=2F11=5D_dm-pcache_=E2=80=93_pe?=
 =?UTF-8?Q?rsistent-memory_cache_for_block_devices?=
In-Reply-To: <85b5cb31-b272-305f-8910-c31152485ecf@redhat.com>
Message-ID: <80ada691-ffee-f0ce-64df-9b0117cd9845@redhat.com>
References: <20250707065809.437589-1-dongsheng.yang@linux.dev> <85b5cb31-b272-305f-8910-c31152485ecf@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-pcache/segment.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/md/dm-pcache/segment.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-pcache/segment.h	2025-07-06 15:13:52.000000000 +0200
+++ linux-2.6/drivers/md/dm-pcache/segment.h	2025-07-06 15:14:17.000000000 +0200
@@ -3,6 +3,7 @@
 #define _PCACHE_SEGMENT_H
 
 #include <linux/bio.h>
+#include <linux/bitfield.h>
 
 #include "pcache_internal.h"
 

