Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213231094B
	for <dm-devel@lists.linux.dev>; Sat, 11 Nov 2023 08:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PTg7Ex8m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699691033;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id;
	bh=9wpGhzXZChj5clhug3J2BVZAt2Oh+rChw/gsEhQ5Mhs=;
	b=PTg7Ex8mZIvkJfW0dzuPHKLLc1B9pEgpLuQX2RsO0V+4OL1ogg3wWfMOlup/xzrm0s/Jqd
	joUhyjypUqMAlfqHdhwUIH/xkiA22L08fA6e81OexUtjZvFfjFjA/wRaEdYXChi31WfcXD
	t6ZE0UPua8aH6hUeE6Ml48iF8vqwYr0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-JxXKVZH6PgSsy1rdZPbKsg-1; Sat, 11 Nov 2023 03:23:46 -0500
X-MC-Unique: JxXKVZH6PgSsy1rdZPbKsg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EE1E101A529
	for <dm-devel@lists.linux.dev>; Sat, 11 Nov 2023 08:23:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 37113502A
	for <dm-devel@lists.linux.dev>; Sat, 11 Nov 2023 08:23:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E89FF1946587
	for <dm-devel@lists.linux.dev>; Sat, 11 Nov 2023 08:23:45 +0000 (UTC)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: dm-devel@redhat.com mailing list reminder
From: dm-devel-bounces@redhat.com
To: dm-devel@lists.linux.dev
X-No-Archive: yes
Message-ID: <mailman.0.1699691024.2044366.dm-devel@redhat.com>
Date: Sat, 11 Nov 2023 08:23:44 +0000
Precedence: bulk
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
List-Id: device-mapper development <dm-devel.redhat.com>
X-List-Administrivia: yes
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

You, or someone posing as you, has requested a password reminder for
your membership on the mailing list dm-devel@redhat.com.  You will
need this password in order to change your membership options (e.g. do
you want regular delivery or digest delivery), and having this
password makes it easier for you to unsubscribe from the mailing list.

You are subscribed with the address: dm-devel@lists.linux.dev

Your dm-devel password is: abtaxaec

To make changes to your membership options, log in and visit your
options web page:

    https://listman.redhat.com/mailman/options/dm-devel/dm-devel%40lists.linux.dev


You can also make such changes via email by sending a message to:

    dm-devel-request@redhat.com

with the text "help" in the subject or body.  The automatic reply will
contain more detailed instructions.

Questions or comments?  Please send them to the dm-devel mailing list
administrator at dm-devel-owner@redhat.com.

