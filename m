Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA694824B7
	for <dm-devel@lists.linux.dev>; Mon, 15 Apr 2024 18:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713204414; cv=none; b=mLGa5cUx8wQPHUUMV3l9r7rqn+hk3fpWVQigmcH+XVa8Y4GrFYdJLfXUDt+0aSTFsWBipitfmbcAJYdiKZicXF34CHRA+7Fx7McRHZnNmk5zXr2X8LalZrG8Ad0GnT032RLJl6h5kFfbEWfkGp43s+qQaWk6nj7D9uq77xxyUL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713204414; c=relaxed/simple;
	bh=DcuCBCqijCxSReWU5dnyKbJkKxWCPvR7qe92JHAJNnA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cOxNj0Ya+P4Au2oi7+G7w6QEPMNCBlZt9u+BmM1BeQ6NOTCFIrfRM0VLini/32+SXhbVt+lM/9frgBCvzVC1Aoa7sSuLasYd6i02xBnB0p6Zdd65tUBKAId0h2iAXFZpg5LnGYagwjxFGAmr7FFvFdzoeCvXMuaMuLpVEFibdpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FHd26AOK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FHd26AOK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713204411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gzhU6TWnVcNjb2SZZ0gVtXU7eCTYjuZSXwdeI7qaIE0=;
	b=FHd26AOKH3S0gTK+GJcbXIK3y6UCisKDRxPBSxzf76iR8ZK6YqdNPEyA7OglkEX9I4g8Lf
	ilhNeKkOqPPCRRNfrTpFycgjCVUxSx3t6ISeX6tiyXUcewm7AX5Gsj7oDkvfi4eoWU4PO9
	4FAcQTktg4eslZ9g3JxGgpl6/ZnCeVc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-641-caNqETi0Mgux6kmwi9Ud1A-1; Mon,
 15 Apr 2024 14:06:47 -0400
X-MC-Unique: caNqETi0Mgux6kmwi9Ud1A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E18529AA3BD;
	Mon, 15 Apr 2024 18:06:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 146E71C060A6;
	Mon, 15 Apr 2024 18:06:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43FI6kcx1903344
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Apr 2024 14:06:46 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43FI6k0P1903343;
	Mon, 15 Apr 2024 14:06:46 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] multipathd: Set CPUWeight to 1000
Date: Mon, 15 Apr 2024 14:06:46 -0400
Message-ID: <20240415180646.1903335-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

If multipathd doesn't become a real time process, it was scheduled as a
normal process, without any priority increase. Bump up the CPUWeight so
that even as a normal process, it will still run with increased
priority.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/multipathd.service.in | 1 +
 1 file changed, 1 insertion(+)

diff --git a/multipathd/multipathd.service.in b/multipathd/multipathd.service.in
index 18bb367e..1b3fccd2 100644
--- a/multipathd/multipathd.service.in
+++ b/multipathd/multipathd.service.in
@@ -20,6 +20,7 @@ ExecStart=/sbin/multipathd -d -s
 ExecReload=/sbin/multipathd reconfigure
 TasksMax=infinity
 LimitRTPRIO=infinity
+CPUWeight=1000
 
 [Install]
 WantedBy=sysinit.target
-- 
2.43.0

