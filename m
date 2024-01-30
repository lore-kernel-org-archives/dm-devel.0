Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1B778B5A
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 18:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706640346; cv=none; b=WyzdQ04hAKLdiYaangUdFAIiYWSi0bAVq21wMdkrENgtBeKLaJlVJZwx2JxdlCrpNiBdlR8JV+f9SkGJfG47+QHBLhS/UG7kqhamrhY2aXSzcZyBVHN9YJ2/rwW+tvVZLt7Yi9tjekTwPgz8GJHMggDLV9b1u8YXRTm361TUU0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706640346; c=relaxed/simple;
	bh=UbOdDzyHvljP+NqbwCRifGD+vj3R45VAUtzISnhmOvg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jtgWrrVTh+UNaQ3jdP5TzutjygUSyaEQwcF3APFE1UaOTT3Wl5bnlucNUaf4fSJpcNFqmGLI6/YFmfpXRkDo2fYdv6Ty7W/G/4dyEtONtswJdc/lyv8uGRlICXs8qSMn19IODQYUUfu8BCWNxY61GqLj6Ya2fj7QD41G9dC9qXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XJNsLtSQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XJNsLtSQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706640343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XYFciaigEjWR85UjVjWC768V6I/N699x6Q+nqNE+d6Y=;
	b=XJNsLtSQpYoZ/ctsIDAhIc1j6rqR313zqX0hh/iV/xel3nv8fFq6rbddjKMisI3wa+bCus
	lA8XZng9iY9NOCX1qb+7i7AqahQRWi3wYwgChxD85sKi3Hs0hEWVJxcV2imKTZRa5ipwAJ
	+1ArKQHBFD4Q/0Okp7xSUsL9e7Gp2FY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-216-B05GN_YsMbS7BfARU0MexA-1; Tue,
 30 Jan 2024 13:45:40 -0500
X-MC-Unique: B05GN_YsMbS7BfARU0MexA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8EFD029AC022;
	Tue, 30 Jan 2024 18:45:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D8EC111E9;
	Tue, 30 Jan 2024 18:45:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 40UIjdQG256952
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 30 Jan 2024 13:45:39 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 40UIjcgX256951;
	Tue, 30 Jan 2024 13:45:38 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 0/2] Minor multipath fixes
Date: Tue, 30 Jan 2024 13:45:36 -0500
Message-ID: <20240130184538.256941-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

two small fixes.

Benjamin Marzinski (2):
  libmultipath: fix displaying auto_resize config setting
  multipath-tools tests: add void parameter to functions

 libmultipath/dict.c | 2 --
 tests/alias.c       | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

-- 
2.43.0

