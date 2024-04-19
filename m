Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AB112D1E8
	for <dm-devel@lists.linux.dev>; Fri, 19 Apr 2024 14:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713535678; cv=none; b=CEqyJb+1Rn11YT89pmnxh539S7QX00WU2yrg9TpvdvHDd8CyoPIymrYFBO2MWk0JOYaBBJhBg69VNta4D0DJghNdvGYOhmqFsliDsrMdIreA6RkvTig7wsCWXvVN7d2EYJh/F+fYCC/u914u1f5viy+D7oi4210r4yww+5rQbiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713535678; c=relaxed/simple;
	bh=U9PXcFOeIqESWu0c2SlNx+UthdhaxoOWvNpzfTWJxZE=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=VFRULdmIjFLhHtcesQKsEhZQytp1vMfp4aaElaaXM+BqhyxBy/TWDLj21oPSiE5hvV7Y9fUjPTsJEz9KWpKnNnfg58Z3LLf3kLUwUkNpVVcNCJwPhMIW5riiBgoML373uUpgd4aNHuxIhIYCAM8HQxT/6V882rLaUXjcNzczg+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XCXSbUc9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XCXSbUc9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713535675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=f53NOzMnZUQO60mZYyg1uEXJF+Smc4vYyV2JpxF7nSA=;
	b=XCXSbUc9NSylyicXobS0bCn49fGsdOG/B+cuG6vWj4zBeVBNNb3GJP+WwDct6tTbKs+P8A
	7hPaq+HnxdE6IXHWfouKHgqSD6/43YWc7eMjYLB9moKa0L2lZBj1wTIWKPT3A8MuFO/oTQ
	FeefxbfqbuDyYHNg1CBB41do+j+XMUc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-56-5zfKPNC7P3CMSYdD_QX0nQ-1; Fri,
 19 Apr 2024 10:07:51 -0400
X-MC-Unique: 5zfKPNC7P3CMSYdD_QX0nQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BC2B29AA38F;
	Fri, 19 Apr 2024 14:07:50 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 858BB49102;
	Fri, 19 Apr 2024 14:07:50 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 6F31930C2BF6; Fri, 19 Apr 2024 14:07:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 6AA053FB54;
	Fri, 19 Apr 2024 16:07:50 +0200 (CEST)
Date: Fri, 19 Apr 2024 16:07:50 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: libc-alpha@sourceware.org
cc: Zdenek Kabelac <zkabelac@redhat.com>, Ondrej Kozina <okozina@redhat.com>, 
    Milan Broz <gmazyland@gmail.com>, dm-devel@lists.linux.dev
Subject: memcpy is leaking secret data through ZMM vector registers
Message-ID: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

As a part of LVM2, we are developing the libdevmapper library. The library 
may be used to load cryptographic keys to the kernel, so it avoids leaking 
the data to kernel memory and to the swap partition.

After the use of cryptographic data, the libdevmapper library clears them 
with memset and frees them afterwards. It executes __asm__ volatile("" ::: 
"memory") to thwart some compiler optimization regarding writing to 
to-be-freed memory.

We have a test "dmsecuretest.sh" that loads cryptographic keys into the 
kernel, dumps a core, the core file is analyzed and if it contains the 
key, the test fails.

This test fails on AMD Zen 4 - the reason for the failure is that the 
"memcpy" function uses ZMM registers for data copying. When memcpy exits, 
the encryption key is present in the ZMM registers and the key remains 
there even after both source and destination buffers of memcpy were 
cleared.

When we perform dynamic symbol lookup, the ZMM registers are spilled on 
the stack and they remain there forever - this is the reason why the core 
file contains the encryption key and the test fails.

I'd like to ask what to do with it? We could use LD_BIND_NOW=1 (or 
-Wl,-z,now) - it mostly works, but not entirely - the key may still be 
present on the stack even if we use LD_BIND_NOW=1.

When I hack the file glibc/sysdeps/x86_64/multiarch/ifunc-memmove.h so 
that it always selects the ERMS variant of memcpy, the problem goes away.

Could it be possible to add some switch to glibc, that could be turned on 
by security-sensitive programs and that would prevent glibc from using the 
vector registers? Or, do you suggest another solution?

Mikulas

