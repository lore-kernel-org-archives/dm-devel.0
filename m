Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED471684BE
	for <dm-devel@lists.linux.dev>; Tue,  7 Jul 2026 00:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783385304; cv=none; b=op8dugYF0ez6wmYRYUWj3Jex1nE1hvAnFits3AfdV2j2eb5rBV5HIAUKZoAvzxNXzZForXhHsC0lDNYM3t9ESxP8Ucf5xRVsptOWltUwiKHXwFJtHEBJeqTIzLHk9kfVdDYqUWh303C10MYkP0UtCOK/CxJzCgrPkrBJow9vr4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783385304; c=relaxed/simple;
	bh=D0eetOtEj1IWwsXntzhMhouZOGeoRckWKevzTliOTXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=qshw6wA4Pxkj17DTD1Xw0qH1ew387f6AoNnNinALjZkBECrk7q8PNJjJR22ruHqVXlo5Ac/jtBW+MzpqECc12KdBcfoSX3bZ9u+WjxnluonqvAfhK8vLwpSDp5AAew14YcOLirD9iknZ9gmMRIYv736Hfph10S6skt5omHhL0ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UNs6MOsl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UNs6MOsl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783385301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TCacBSCMqg6/PK42kr4N3unLbA5DT5CNjrFUoFlyFDw=;
	b=UNs6MOsliMaecrHper0NBUHPp+vPIXU3AEfft8ZJrK6abFUKa4/fTd2n5GDLs75zbUDLnq
	q+idtrg5BFidXx22Yxbnwrj0wyPOPI0vg7/FHBcCggX2DsDV80WdYPlyA4SOf4ioFlrmzH
	mxIJeh8YUrsZP+AQUe4Jn0sPv1AySno=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-640-STk587J9NZmj5FKnR1bOCw-1; Mon,
 06 Jul 2026 20:48:20 -0400
X-MC-Unique: STk587J9NZmj5FKnR1bOCw-1
X-Mimecast-MFC-AGG-ID: STk587J9NZmj5FKnR1bOCw_1783385299
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 553BA1955DBA;
	Tue,  7 Jul 2026 00:48:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0733818005A9;
	Tue,  7 Jul 2026 00:48:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6670mH5s1958278
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 6 Jul 2026 20:48:17 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6670mHGd1958277;
	Mon, 6 Jul 2026 20:48:17 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/2] Remove unsed DEFAULT_DISABLE_CHANGED_WWIDS define
Date: Mon,  6 Jul 2026 20:48:17 -0400
Message-ID: <20260707004817.1958264-2-bmarzins@redhat.com>
In-Reply-To: <20260707004817.1958264-1-bmarzins@redhat.com>
References: <20260707004817.1958264-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uAq2Ly-EestKnLyAIxgD3XzBWLXKd3ZXL-smyALwQxc_1783385299
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

disable_changed_wwids is deprecated and unused.

Suggested-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/defaults.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index ea1fce0e..c3ae42e9 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -49,7 +49,6 @@
 #define UNSET_PARTITION_DELIM "/UNSET/"
 #define DEFAULT_PARTITION_DELIM	NULL
 #define DEFAULT_SKIP_KPARTX SKIP_KPARTX_OFF
-#define DEFAULT_DISABLE_CHANGED_WWIDS 1
 #define DEFAULT_MAX_SECTORS_KB MAX_SECTORS_KB_UNDEF
 #define DEFAULT_GHOST_DELAY GHOST_DELAY_OFF
 #define DEFAULT_FIND_MULTIPATHS_TIMEOUT -10
-- 
2.53.0

