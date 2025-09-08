Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECA9306B10
	for <dm-devel@lists.linux.dev>; Mon,  8 Sep 2025 13:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757337466; cv=none; b=X2N3wbAuF3n69sUn6COXGRblFzUd86YCpLOGyYPl3hINhJ+kE9QdLLgW2e/jO6rwPHsLyUJZyYuA45tB0ftUNeZEwNMFo1igkoe+Fauxq9ZhP1RNi4zf3qC/MeFVI6zcOp9km/5j/WREfWvT2KBvuzLwPSMtpZLlB5dhFaLYzCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757337466; c=relaxed/simple;
	bh=Mjent7guAuk/n67VVVGkA+DyqfIwX1q9B0D+L6SXWbQ=;
	h=Message-ID:Date:From:To:Cc:Subject; b=GNDYECfbL6Dm6QsUrAFdPmXQUviUSsgKpKxtL1WCdYD0PjtlTYQMnB68PH5MnieBbTZ7ZOBJOiOm2buifUtewTT78My/4j3gyx1HzBcOBB9EBs9VJMdJ4omUknBNcYXQ1VdikK8LN3cgnzHHQkvoTU2nAGNljJcF440p/p57St8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IFaRWa0W; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IFaRWa0W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757337464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc; bh=Mjent7guAuk/n67VVVGkA+DyqfIwX1q9B0D+L6SXWbQ=;
	b=IFaRWa0WOe/6P0wbV9fSztuF/PjDm7R7wY4SAHOp6MfivOxAj4XD0JYQ1bgb0sQLlSrw0X
	tA2LIpKq/K+gHhuQupqXuXuQscmPphkyGyvHFwpCcByQceUfTj94isBOjfzvfNTct9LgPA
	rUvrN+zZIQ+/IwqkktrdJuv4fYnOyso=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-687-K1gB9V9MOseEzBv57VKC3Q-1; Mon,
 08 Sep 2025 09:17:38 -0400
X-MC-Unique: K1gB9V9MOseEzBv57VKC3Q-1
X-Mimecast-MFC-AGG-ID: K1gB9V9MOseEzBv57VKC3Q_1757337457
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7658918002C1;
	Mon,  8 Sep 2025 13:17:36 +0000 (UTC)
Received: from debian4.vm (unknown [10.44.32.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 105561800576;
	Mon,  8 Sep 2025 13:17:31 +0000 (UTC)
Received: by debian4.vm (sSMTP sendmail emulation); Mon, 08 Sep 2025 15:17:29 +0200
Message-ID: <20250908131642.385445532@debian4.vm>
User-Agent: quilt/0.68
Date: Mon, 08 Sep 2025 15:16:42 +0200
From: Mikulas Patocka <mpatocka@redhat.com>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Biggers <ebiggers@kernel.org>,
 dengler@linux.ibm.com,
 linux-s390@vger.kernel.org,
 dm-devel@lists.linux.dev,
 ifranzki@linux.ibm.com,
 agk@redhat.com,
 snitzer@kernel.org,
 gmazyland@gmail.com
Subject: [PATCH v2 0/7] dm-integrity: asynchronous hash support
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

Hi

These patches add asynchronous hash support to dm-integrity.

Harald, please test them, I will commit them if they work for you.

Mikulas

