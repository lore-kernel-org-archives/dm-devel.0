Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F41C4645B
	for <dm-devel@lists.linux.dev>; Fri, 17 Nov 2023 21:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ags8KFY6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700254806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pN+P8OYJ9k5r7mbQgkYIC8IYakZv3DXVBRH3ejLHj3A=;
	b=ags8KFY6PBTjyPOZubvg6a8U9R92d8Gbz3pMs9qGHI3eRL3LT1m+zvlPyKdSJPoS7NzzVz
	urjouzSQwWTKjvD5pCLFk5jXpRlXAvfEMhGrGo6CSDoaeb1XBnfkr1IalApD5tnQKrm3kk
	d1anCBggX0vJpFqZsWqLJ582HhLsQPA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-257-bLXP0lUzMa6JPT8jHzXi7w-1; Fri,
 17 Nov 2023 16:00:05 -0500
X-MC-Unique: bLXP0lUzMa6JPT8jHzXi7w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A1B73C00209
	for <dm-devel@lists.linux.dev>; Fri, 17 Nov 2023 21:00:05 +0000 (UTC)
Received: from pbitcolo-build-10.permabit.com (pbitcolo-build-10.permabit.lab.eng.bos.redhat.com [10.19.117.76])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 202A540C6EB9;
	Fri, 17 Nov 2023 21:00:05 +0000 (UTC)
Received: by pbitcolo-build-10.permabit.com (Postfix, from userid 1138)
	id D2A733003D; Fri, 17 Nov 2023 16:00:04 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH v5 40/40] dm vdo: add MAINTAINERS file entry
Date: Fri, 17 Nov 2023 15:59:57 -0500
Message-Id: <a91bd7ccc071af269f6e329673f75168b51304d2.1700250814.git.msakai@redhat.com>
In-Reply-To: <cover.1700250814.git.msakai@redhat.com>
References: <cover.1700250814.git.msakai@redhat.com>
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

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ce3f9099bf23..7402652ac5a5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6002,6 +6002,15 @@ F:	include/linux/device-mapper.h
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

