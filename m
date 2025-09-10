Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83458303C85
	for <dm-devel@lists.linux.dev>; Wed, 10 Sep 2025 22:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757545102; cv=none; b=AYwTioelRThuyB1WgYAzywNPaxQf+y58QWygkMAg5BBIjOJRIsI+O41lHbCvuUQsf+houMSPnu4yZmcE6qcom9AOf7UJ+6ULB5sMfQBQt7n3Ik4rky4snliU9GiIfyMfhz2jES3iKdwPU0jcs7ksNfrRb3+EjjhfJgD8we3nHUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757545102; c=relaxed/simple;
	bh=ayPptgbA4ZbnDOXyYv38ci/nJAV4YLUMUx6lQClMaUA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=fh61KFT60RJ6wRKd8wD3+PAGFSIk4n+5oHOPAOtbp6SDFruThkA/h16a081A7NMvXDUQnO09G5xKjd+atUo6t6i52p+z0Ni8BfSm1vS9NsWU/kxsO6H4ZygZ/Ayku1fm92WzCSV5dkguI9h1xLltEa4XOE/z/+yBZ+heyhM5t38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MItDoD+V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MItDoD+V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757545099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WhtMV3oL7DcVA3eBymO6SMxsHSf9gwjcpT9CRa792Dw=;
	b=MItDoD+VKXxzyeVIW7woIDAHNI9XxZkGozuAOqNNyWQFt9fUMlPW0IWz1X5FX0ceCA9jdg
	L84It7bH4oRxYfEE1u+CX1avA+iRTNJqmszoAjAXN5i/X4Wj3G0seR5vXILMRTBhzgLuU0
	ltrq904kWnnMrphTGBUUA4MM8oMq5Zk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-350-auVGnSCeMi2-kwNKw8-gpA-1; Wed,
 10 Sep 2025 18:58:16 -0400
X-MC-Unique: auVGnSCeMi2-kwNKw8-gpA-1
X-Mimecast-MFC-AGG-ID: auVGnSCeMi2-kwNKw8-gpA_1757545095
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA7281800365;
	Wed, 10 Sep 2025 22:58:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F433180035E;
	Wed, 10 Sep 2025 22:58:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 58AMwCYM829858
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:58:12 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 58AMwC6o829857;
	Wed, 10 Sep 2025 18:58:12 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 0/2] libmpathpersist: two final fixes
Date: Wed, 10 Sep 2025 18:58:10 -0400
Message-ID: <20250910225812.829847-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KryNLD23rCf7ncNv93AjWwXLeCaeAjVdJ4faCngH_LE_1757545095
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

These patches take care of a corner case where changing a registered key
can race with a path getting restored and a make peempting work
correctly with All Registrants type reservations.

Benjamin Marzinski (2):
  libmpathpersist: handle updating key race condition
  libmpathpersist: handle preempting all registrants reservations

 libmpathpersist/mpath_persist_int.c | 31 +++++++++++++++++++++++++----
 libmultipath/prkey.c                | 16 +++++++++++++--
 libmultipath/structs.h              |  1 +
 multipathd/main.c                   | 12 ++++++++++-
 4 files changed, 53 insertions(+), 7 deletions(-)

-- 
2.50.1

