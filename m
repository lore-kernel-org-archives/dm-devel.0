Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15EC748F
	for <dm-devel@lists.linux.dev>; Sat,  2 Mar 2024 02:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709348339; cv=none; b=ZNObUEsJKAmbEOgqkxBKIuCaKPK8ndCq26lbzK0AinZWCGUQumhxOPlFyLpOahip7ZwDTMZcnF1lRyDTgo+Q7imWN30P2IuYP2glfeFZqy0VQgFMRFZJDl/IA9Wf8C8ryZonBki+CF1Zzkhlhx+gtK98Yv18++PbyobAXGtlGDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709348339; c=relaxed/simple;
	bh=1+Y6YCU0+0n8KnEbkV5Gl7bILCGeBT4xJXEqiMbP2e4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=q1VXC4ZJpFLABiMc1lw3GDm+bt4TZiMX04cMnJl8PTu7I50g5BkKU5/iTD14vxbyhq6npMR5CJXv/hjJpP5TM9D4R+lMg5hGtI9QLPFe7i+6kswetX3JO74ur1UTwdp2mTJZWK/ONaRGTmRXCJ9yqK9cZFC8rPwy1vaC/S0Briw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=erhx5wg9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="erhx5wg9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709348336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EgyssESIlDBtGxdAS8mWCmz6dpLU7DxraxTtXgU+Bnk=;
	b=erhx5wg974AnjOoezMBYAyVfjwpHvebxXR8TKQ7mKOP5BTmTcxgdkoiXN8HoFRZKEnUE7J
	9fkTe1X7Oi0ifAkc2Q6yeIGE6c897qRf2rbYgRDfZJRNTnuSr1Z8rwkerHhye0GfvR2xyG
	hO0dfp2XkJu7Oka47NcDo0QMVVJ+Ycg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-Tsv498reN0C8k6IFkzS9Kw-1; Fri, 01 Mar 2024 21:58:55 -0500
X-MC-Unique: Tsv498reN0C8k6IFkzS9Kw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70157811E79
	for <dm-devel@lists.linux.dev>; Sat,  2 Mar 2024 02:58:55 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 68D782166B31;
	Sat,  2 Mar 2024 02:58:55 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 5FE69A1C05; Fri,  1 Mar 2024 21:58:55 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 0/3] dm vdo: move functions to vdo_ namespace
Date: Fri,  1 Mar 2024 21:58:52 -0500
Message-ID: <cover.1709348197.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Mike Snitzer (3):
  dm vdo funnel-queue: change from uds_ to vdo_ namespace
  dm vdo logger: change from uds_ to vdo_ namespace
  dm vdo string-utils: change from uds_ to vdo_ namespace

-- 
2.42.0

