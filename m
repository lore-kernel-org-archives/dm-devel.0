Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70ED441740
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 21:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W37H2M5E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698356859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1TpkxA2WjPiy1cRsPdyl9AKk+VqEjs8I+5jriOwuGuY=;
	b=W37H2M5EjTMtWpFXVlA9VRWL4Uxc42ACBpXc+fQlG8w64ch824ENQfa5RwGcbfPwPBzt/S
	OzgIByudOKjZ+y+nT6ZychJbvXkYdF4eSlnAxB7kZPSYLr6DDH9Fv/Gg0a2ezxAHn60OPZ
	bxFkIsra+eeKOGivGGKxU8siqCOt4Dw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-00DnKNgaM9maIMO7qnPBmg-1; Thu, 26 Oct 2023 17:47:28 -0400
X-MC-Unique: 00DnKNgaM9maIMO7qnPBmg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09DE1101B436;
	Thu, 26 Oct 2023 21:47:28 +0000 (UTC)
Received: from pbitcolo-build-10.permabit.com (pbitcolo-build-10.permabit.lab.eng.bos.redhat.com [10.19.117.76])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F381840C6F7B;
	Thu, 26 Oct 2023 21:47:27 +0000 (UTC)
Received: by pbitcolo-build-10.permabit.com (Postfix, from userid 1138)
	id B6CE93003C; Thu, 26 Oct 2023 17:47:27 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: add MAINTAINERS file entry
Date: Thu, 26 Oct 2023 17:47:27 -0400
Message-Id: <20231026214727.1067606-1-msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8b17e29a75c8..5357fbe1cc90 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6001,6 +6001,15 @@ F:	include/linux/device-mapper.h
 F:	include/linux/dm-*.h
 F:	include/uapi/linux/dm-*.h
 
+DEVICE-MAPPER VDO TARGET
+M:	Matthew Sakai <msakai@redhat.com>
+M:	dm-devel@lists.linux.dev
+L:	dm-devel@lists.linux.dev
+S:	Maintained
+F:	Documentation/admin-guide/device-mapper/vdo*.rst
+F:	drivers/md/dm-vdo-target.c
+F:	drivers/md/dm-vdo/
+
 DEVLINK
 M:	Jiri Pirko <jiri@resnulli.us>
 L:	netdev@vger.kernel.org
-- 
2.40.0

