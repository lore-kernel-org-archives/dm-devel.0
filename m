Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EAC3A8E9
	for <dm-devel@lists.linux.dev>; Fri, 17 Nov 2023 17:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LyxTJKa0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700242496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=ycz0/1M6yi1eB3tivc7z6xgQAcOImG6OBFYEwKPli6c=;
	b=LyxTJKa0l1qRUfRU+U3K6TkBye8A4O5DIEILTZ3V+L/dnaKb7yl3UsKSlSDyb6/UOMFfF5
	3aKYdnIa81yI/Fq3wO54XnJcYCZyv3TpE/Apx21koxMXAgIPEdti9bPjPgx+BwBNBVR4BL
	OjTyiB49tT+/pzRRx29oa2980vRI9k4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-xzDbQrIkOxGnPVqJbm0dWg-1; Fri, 17 Nov 2023 12:34:52 -0500
X-MC-Unique: xzDbQrIkOxGnPVqJbm0dWg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F182101A529;
	Fri, 17 Nov 2023 17:34:52 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D7B42166B27;
	Fri, 17 Nov 2023 17:34:52 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 5A2FB30C1A8C; Fri, 17 Nov 2023 17:34:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 56F243FB76;
	Fri, 17 Nov 2023 18:34:52 +0100 (CET)
Date: Fri, 17 Nov 2023 18:34:52 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
cc: Joe Thornber <thornber@redhat.com>, Milan Broz <gmazyland@gmail.com>, 
    Nathan Huckleberry <nhuck@google.com>, dm-devel@lists.linux.dev
Subject: PATCH 0/2] fix dm-verity tasklets
Message-ID: <3bd19ce6-2f60-548f-acd7-cb98aa308661@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

Here I'm sending two patches that fix dm-verity tasklets. If you compile 
the kernel with sleep-in-atomic checks, "veritysetup open --use-tasklets" 
will trigger the warnings.

It needs fixes in dm-bufio and dm-verity.

Mikulas

