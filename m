Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459B11F755B
	for <dm-devel@lists.linux.dev>; Wed,  2 Apr 2025 23:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743635614; cv=none; b=LyUBLEhWo0XFYtBNawxcnvPumdvwZFf5jMS5Hq5tVvYlh4x0v73LBzsHensVIJV3Y/y3re9MUFpeeB1IA3HZ+NX0pUUGurxBSQPOQwfC4YbSm7ZZCzLnxM3s/Hm92nArkLIxBjoa2ypxUY6WpHIi+JKVZdZanrDvUbE/NLwloEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743635614; c=relaxed/simple;
	bh=5F0pser7xeHU3dNHOuKLEf1HF3Ny3Bdall0NaTLNgQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=FjUPqMznop7q/ISfiCI9uXI0PnC9OfbadlK/U6W51HLGKRUy1WQpYodGdXKLM9/Zw/r1KAT07OFeLO90yrmG8FnJHUUjUecjYN7zdb846VoDJ+pJrc+1cSMmNUKUZACLM4AmgQ27QomO1Pe1SCTtuG9imFKQFZUINi+NjObCLd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GViSpKRP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GViSpKRP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743635610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ac4cHuBPk05HpekGxC/h0J5fHiT6ZmljnDOnXcQVDbQ=;
	b=GViSpKRPpMGu7FJbawFjJavgmxQ8pOHc92tgPyQNtfHFV+MPIXpt0NzVissywUTkf77W5r
	MYu45EjQ+cilExpd978SyTF5EuiyGrxDoj6dL+jxRS+KMqPQ0b5WQcv7tS8tFE8UmF0GrV
	1BRFudl7K0hg8Z25+eCl0o1w5aPOcaE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-471-yxkuI4jeMo-8vLIlcSx2Ew-1; Wed,
 02 Apr 2025 19:13:26 -0400
X-MC-Unique: yxkuI4jeMo-8vLIlcSx2Ew-1
X-Mimecast-MFC-AGG-ID: yxkuI4jeMo-8vLIlcSx2Ew_1743635605
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F5E91956089;
	Wed,  2 Apr 2025 23:13:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFEBF180176A;
	Wed,  2 Apr 2025 23:13:24 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 532NDN0x3044093
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 2 Apr 2025 19:13:23 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 532NDNRv3044092;
	Wed, 2 Apr 2025 19:13:23 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 4/4] multipathd: don't update paths in INIT_MISSING_UDEV
Date: Wed,  2 Apr 2025 19:13:22 -0400
Message-ID: <20250402231322.3044064-5-bmarzins@redhat.com>
In-Reply-To: <20250402231322.3044064-1-bmarzins@redhat.com>
References: <20250402231322.3044064-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RiOAi6ghZstEd2Ud1DrjJcN76Mlzb2sk-R1KbDdcBuw_1743635605
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

There is nothing for update_uninitialized_path() to do for paths in the
INIT_MISSING_UDEV state. In fact, there shouldn't be any paths in this
state when update_uninitialized_path() is called, since they will have
switched to a different state in check_uninitialized_path().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck  <mwilck@suse.com>
---
 multipathd/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 61ebf316..99d603f9 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2890,7 +2890,6 @@ update_uninitialized_path(struct vectors * vecs, struct path * pp)
 	struct config *conf;
 
 	if (pp->initialized != INIT_NEW && pp->initialized != INIT_FAILED &&
-	    pp->initialized != INIT_MISSING_UDEV &&
 	    !(pp->initialized == INIT_OK && pp->add_when_online))
 		return CHECK_PATH_SKIPPED;
 
-- 
2.48.1

