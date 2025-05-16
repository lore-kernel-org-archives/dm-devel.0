Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772C4157E99
	for <dm-devel@lists.linux.dev>; Fri, 16 May 2025 16:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747411249; cv=none; b=J+vw9NNVBb1BSmuUg+vzTRvhYCkxYtGFKkpyFhlD4OpYgIAEhvJi9x8PDNoTe+7JAKZ9YLfqMKojzxigdeM/OYPaCEtcY/3C+8ULz5p6uv/jI/UFD8GbLPfOtl1WTOyOP69ZMIm4fPUWwb+gv3A3AAt/smbiuY0YLcOCI25mtVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747411249; c=relaxed/simple;
	bh=doVMENvPfbidyznr0fjGyM+N8FMzTAOdKkvrvzAQGvY=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=lLaOUpRZmGRRMD/0jXIHOw2DGm7fU+1ukLkHpSFLHPATZ7wBwjTyAfPhetG7Q5WiazJjYi0cnoVFsDiR5o4RWw5nzO8mNRRkOk9CKxgwqr1pxYAqGkGBUYsBDMQRNxxDIegK3RiifZUTcBJ3WRUaDd75M2KgMpKcYAaiHAaCZoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AhOEdWVU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AhOEdWVU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747411246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=04dvSvadinv+H6MbwZewI9064tz274ETH+8sGkt3VIo=;
	b=AhOEdWVUzS9oYEvQBQxsPK+OxxxOt4B7pCQMzZVbLexWsgj2bJ0EHcm96sCQFliaXda88X
	mflH1Z2AAD5/tGm/+XaGwBWPbJOYRxVdFn2QcIsM20qd0p1RvqEsSV544La4SDFnr3LuYT
	ZaFLKwUZk8rC+du8SpHOo8mGzyFI9oE=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-154-v46JiDbaNJ-IgSmZmkSXBA-1; Fri,
 16 May 2025 12:00:41 -0400
X-MC-Unique: v46JiDbaNJ-IgSmZmkSXBA-1
X-Mimecast-MFC-AGG-ID: v46JiDbaNJ-IgSmZmkSXBA_1747411240
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6EE75195609E;
	Fri, 16 May 2025 16:00:40 +0000 (UTC)
Received: from [10.22.80.45] (unknown [10.22.80.45])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 815C019560AE;
	Fri, 16 May 2025 16:00:38 +0000 (UTC)
Date: Fri, 16 May 2025 18:00:33 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yu Kuai <yukuai3@huawei.com>, Song Liu <song@kernel.org>
cc: zkabelac@redhat.com, linux-raid@vger.kernel.org, dm-devel@lists.linux.dev
Subject: LVM2 test breakage
Message-ID: <34fa755d-62c8-4588-8ee1-33cb1249bdf2@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi

The commit e879a0d9cb086c8e52ce6c04e5bfa63825a6213c breaks the test 
shell/lvcreate-large-raid.sh in the lvm2 testsuite.

The breakage is caused by removing the line "read_bio->bi_opf = op | 
do_sync;"

Mikulas

