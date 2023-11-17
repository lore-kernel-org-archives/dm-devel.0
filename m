Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515A03EA79
	for <dm-devel@lists.linux.dev>; Fri, 17 Nov 2023 17:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kzb7OPmD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700241596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=oYY5hpNb6elf4W3xziCEh14qemoC79ZEVAbUqKqDXKQ=;
	b=Kzb7OPmDZJ3+Nwpm+88C5gDGdQOqn5O17Ja8cVWDsBSuFGPjpTmicDJ83AmvccJNuCzUil
	4x5IHzPqWyCcy3UCNnyw2EdzMOkNS2+LTIo+W1vtPbyd++hzfFkGmKe+z5oPYfUMlWwz9X
	0LjJzqqTyGJmGj1FPKvxgkOtqPoC7sM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-316-Bm2mncroOkWUbXJFvFYe1A-1; Fri, 17 Nov 2023 12:19:52 -0500
X-MC-Unique: Bm2mncroOkWUbXJFvFYe1A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C03F811E7E;
	Fri, 17 Nov 2023 17:19:52 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 43DA1492BE0;
	Fri, 17 Nov 2023 17:19:52 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 17AB130C1A8C; Fri, 17 Nov 2023 17:19:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 0A2A13FB76;
	Fri, 17 Nov 2023 18:19:52 +0100 (CET)
Date: Fri, 17 Nov 2023 18:19:51 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
cc: Christian Loehle <christian.loehle@arm.com>, 
    Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, 
    Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@lists.linux.dev
Subject: [PATCH 0/3] dm-delay patches
Message-ID: <1b597cf-499b-a84c-fa5a-87a630987dff@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

Here I'm sending the dm-delay patches.

Patch 1 fixes a race condition that existed in dm-delay since ever.
Patch 2 fixes bugs that were introduced by 70bbeb29fab0.
Patch 3 is a small refactoring to reduce code size.

Mikulas

