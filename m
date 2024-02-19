Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F7E374DD
	for <dm-devel@lists.linux.dev>; Mon, 19 Feb 2024 20:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708374414; cv=none; b=oWp2lf0o8/HG25i/HHVu11QkDeiDbG5XQnTyQIBNsBCWqBOtq5Gv6NZmMYza7FbMobyel2D/l6OZwJi8yQYyOt61buxeSklpRwCpAsVAw/slEjOzU4ND1huJvfW2ML2tduq1PxivtzVvdCEjsVqhPRGaEULJGwzhGlHCLBYCF3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708374414; c=relaxed/simple;
	bh=bKr3Xh+cNGu41moki2fwJh3zEFA56Mt7QWCpVMvi23Y=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=uaH5W8wi6dbf3NEfGXZnL+Tw4LGN3PcqVRlQlIRducDKHgS2Hcy5lldmA8M8m9vnOhug0+N/8fj9oIulrrwzy5i+VkDU0/D4fi8CZi11WmaBzV8ggdJcKLI+iU7QZy6KTAITHTZg35w1D2DFyge6ihuAAJoLADlfT8/8+AQjw9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S5MIRfVB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S5MIRfVB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708374411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=fsaitop5OGpHas/JRIn9eC089u4ob2lxgvGpR8W2hPU=;
	b=S5MIRfVBZMSkE4k/v0MrxlelGd+NMKXx6m5jy8SaIpd6LBRLY58sKHaAMwnBRg7MzfPeM6
	KOnOEvGBAfUpXocPaKoGq6cdnyggltO1edkwLazyBimm45yDmBTuxjGcm48siRUpwy50sv
	JV8sQRYgTBdMi8tOqK4/4nR5v2NzFO0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-VrjeHXJpMiqxfuOK-Rg0bg-1; Mon, 19 Feb 2024 15:26:50 -0500
X-MC-Unique: VrjeHXJpMiqxfuOK-Rg0bg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23297108BF33
	for <dm-devel@lists.linux.dev>; Mon, 19 Feb 2024 20:26:50 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DDC0492BE2;
	Mon, 19 Feb 2024 20:26:50 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 0151730C1B8F; Mon, 19 Feb 2024 20:26:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id ED3233FB4E;
	Mon, 19 Feb 2024 21:26:49 +0100 (CET)
Date: Mon, 19 Feb 2024 21:26:49 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH 0/5] dm-integrity, dm-verity and dm-crypt recheck patches
Message-ID: <ab6d4358-3430-e2c9-bb93-c1e8cf72395@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

Here I'm sending the recheck patches for dm-integrity, dm-verity and 
dm-crypt.

They fix an error that can be triggered by this program: 
https://people.redhat.com/~mpatocka/testcases/blk-auth-modify/read2.c

Mikulas

