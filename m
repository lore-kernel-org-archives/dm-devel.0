Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E6055E4C
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 20:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709326044; cv=none; b=RFOSJRh6lDfQ8Q36rwv6UMn71/t4FNM1T3w8Ue7CzPxhqQnajoIjlKRa6LNxxshtRO7r0YhHlh29YMWc9tagj61Ks8sy6dzq1aw2bDA1lUpzDK/ZrqOrgULlmsm42uxNG8vGJ1mLe9ux7mbIrZBwB24W/wrI5J540bDt3ZHGjX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709326044; c=relaxed/simple;
	bh=ThIKAFo4X7DUlanECkGzj15FS2psSyjvMCYn6JqTcSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IlVb0vaK9Gmw8SvIWFpq464CY9lj0U7DsmiHbz6qkwXYgPWXror2Bcw1qd1ZroMatbyraW9RFsXYdXdwWHBxZ9p5aYaBFWXHgGOJlhHIJtlrgrLg9foY3qLKtFCEsTRqF8No83Sqwzqo5DVHg1IHCP+QpjrmvXHKxefu/DZVLeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RtRLpcZe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RtRLpcZe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709326042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w8Z5/g6zwvPw5AojOVC4QhFCl1G9nISkmW2IkqYEWis=;
	b=RtRLpcZeQtZ33s0AVNDttIlvHWTWGP3KKYwOtorT7JL0blEzjLv2+JsRbPsiboATWOlPCP
	CQC1/Rt0EaSAkkkuHnwMQnCOn30D/HTaMWU9hXxiz6vyJi3W6ZXSOZv1jtB9R/mFHZbucs
	hE6ew0hm1IwtezNPo0akFA784IreU9M=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-256-FAL85yRMNy-OmikNN83jkQ-1; Fri,
 01 Mar 2024 15:47:20 -0500
X-MC-Unique: FAL85yRMNy-OmikNN83jkQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20D1D1C05AD4
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 20:47:20 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0D380400D295;
	Fri,  1 Mar 2024 20:47:20 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 0880CA1B82; Fri,  1 Mar 2024 15:47:20 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 3/4] dm vdo: document log_level parameter
Date: Fri,  1 Mar 2024 15:47:18 -0500
Message-ID: <e4d291611e7d6158e5e6d460d6c3fa431a0b7770.1709325896.git.msakai@redhat.com>
In-Reply-To: <cover.1709325895.git.msakai@redhat.com>
References: <cover.1709325895.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Ken Raeburn <raeburn@redhat.com>

Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 Documentation/admin-guide/device-mapper/vdo.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/admin-guide/device-mapper/vdo.rst b/Documentation/admin-guide/device-mapper/vdo.rst
index a199009979d9..a3572582ead8 100644
--- a/Documentation/admin-guide/device-mapper/vdo.rst
+++ b/Documentation/admin-guide/device-mapper/vdo.rst
@@ -315,6 +315,13 @@ GB of RAM per 1 TB of window. For sparse indexes, the index requires 1 GB
 of RAM per 10 TB of window. The index configuration is set when the target
 is formatted and may not be modified.
 
+Module Parameters
+=================
+
+The vdo driver has a numeric parameter 'log_level' which controls the
+verbosity of logging from the driver. The default setting is 6
+(LOGLEVEL_INFO and more severe messages).
+
 Run-time Usage
 ==============
 
-- 
2.42.0

