Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739CAA29
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 00:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721176376; cv=none; b=DjL+cIDbbOxJbqUiUoTimiOvgBrfsvQeSVNTwworjEZFZuqdprtI7FgZ/rS18+E/llJn8icDSTtIsZViKCw0kN59VVnDip7PZsqUXc0uDOUd+vZPu78GkfwN3MEG5GbzPH3dE/2VTZOXw5ogWpd3IQm8wwZp6H2sOqt+hqVhPY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721176376; c=relaxed/simple;
	bh=oVXSIusgUpMsbAk86xBOpa0jsC40l9Ajo48DBdqTtW0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bGIZClQtYc919ROXiNBYiYvuSg+p0SPtPN+nuufeJn6IXf5L5Vrp3FKsPKrPofQN56oJhywWctqJiWKGGIGRyDWkfYhA07V/aQnBRVhLRr8igB7oreBBNXSzRH9l3/nqeUbiEYBeflUVfD28Tb7b2LhP9pkzJgHrXfSgv+Q27l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dxEbzPP3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dxEbzPP3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721176373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6pzbneWVBRkUb3De34yVGogs/jezuH8jdhGZyXhzgu8=;
	b=dxEbzPP3vmHLwaToEdKHzkZ36xJDaG7kq3BoFN465jefmjlWv/8AaJ2+JP/MC1HOViDlkR
	dhxgDN7NfvjO7mAYGcQdt5y5k4tMZx5w6Hl2UaqHhQ5GAj9gpw7853T+OhtUsrsUFEWete
	WDGPITRUa1iAjsqDdQ9l1JcgAJfSsqU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-SU5_PMBrMNCs_lX1wSDXzQ-1; Tue,
 16 Jul 2024 20:32:49 -0400
X-MC-Unique: SU5_PMBrMNCs_lX1wSDXzQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5C93E1955D44
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 00:32:48 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 128783000183;
	Wed, 17 Jul 2024 00:32:48 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 87EB7532A3; Tue, 16 Jul 2024 20:32:47 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Masatake YAMATO <yamato@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: fix a minor formatting issue in vdo.rst
Date: Tue, 16 Jul 2024 20:32:47 -0400
Message-ID: <20240717003247.155324-1-msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Masatake YAMATO <yamato@redhat.com>

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 Documentation/admin-guide/device-mapper/vdo.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/admin-guide/device-mapper/vdo.rst b/Documentation/admin-guide/device-mapper/vdo.rst
index 7e1ecafdf91e..c69ac186863a 100644
--- a/Documentation/admin-guide/device-mapper/vdo.rst
+++ b/Documentation/admin-guide/device-mapper/vdo.rst
@@ -241,6 +241,7 @@ Messages
 All vdo devices accept messages in the form:
 
 ::
+
         dmsetup message <target-name> 0 <message-name> <message-parameters>
 
 The messages are:
-- 
2.45.2

