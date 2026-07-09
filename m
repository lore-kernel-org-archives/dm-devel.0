Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986702D5C83
	for <dm-devel@lists.linux.dev>; Thu,  9 Jul 2026 19:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783625059; cv=none; b=lxVkOVgxRURidLYyiRSmtnpwYtaizDNutyKvHRjOAMOTc823z6BVz16ILVzt6uicSNsEfDHg4TOGnVZG0sZljLIaizW3t6GN4ykoE6iMs2FgK6vL3DpEnS6XQHa29zmC6Iay5TTFK1QARcd9t931XZNK8swqcYK6Wri6KyB3KYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783625059; c=relaxed/simple;
	bh=HI9F7T2cECzMgwwztUvXvrC+Ta++SI1BoLlH7Kz6vgY=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=tRdNVYoeQN1um8+EdivAjUtpGmqRbYOscWgmOH6iYkSVQDJFlEklSOV9jUlQ/cz9vzRprNVOVjHpPG9rxDNdUjuA1F2fQ4o0mwILpVzNQeeuWCz5zY0JmXmBkl4nX1PDCWeTKa3oEwFeuvDGRDkXCATD3NtmkSwPwDGYiYPFhJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HmSssg/l; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HmSssg/l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783625057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=fJrnW3DAgfJcGTWZ1cS0W669KEMFtBOWzgr0vReNMbs=;
	b=HmSssg/lUb+NuI5bMqdKbCY2t848VUOvuyySLsSYt5QDy0UrNCXwTylWMNJSrwqCKql0o1
	Y9nrKk0h+kWWTpZGCuZEbpr5JOytvB9TiESWewOLwBFPWahU3GO5xktcY7qGqUmi/1YLSC
	43rWKLWiHNNpikP84OZ2vVZ7v5/GGlE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-84-UzpG4qCuP96_HgqAij9I4g-1; Thu,
 09 Jul 2026 15:24:16 -0400
X-MC-Unique: UzpG4qCuP96_HgqAij9I4g-1
X-Mimecast-MFC-AGG-ID: UzpG4qCuP96_HgqAij9I4g_1783625055
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5BD64180137B;
	Thu,  9 Jul 2026 19:24:15 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D18671800347;
	Thu,  9 Jul 2026 19:24:13 +0000 (UTC)
Date: Thu, 9 Jul 2026 21:24:09 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-integrity: don't increment hash_offset twice
Message-ID: <92aaec73-496b-d450-aee8-a694d4ad5aff@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hLx70gPMpivd86oGr8JGAml95NxfqFb9ZvLunJu_4JI_1783625055
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

hash_offset is already incremented in the loop "for (i = 0; i < to_copy;
i++, ts--)". Do not increment it again.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: 84597a44a9d8 ("dm-integrity: dm integrity: add optional discard support")
Cc: stable@vger.kernel.org

---
 drivers/md/dm-integrity.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2026-06-22 17:52:05.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2026-06-29 17:58:14.000000000 +0200
@@ -1480,9 +1480,6 @@ thorough_test:
 			*metadata_offset = 0;
 		}
 
-		if (unlikely(!is_power_of_2(ic->tag_size)))
-			hash_offset = (hash_offset + to_copy) % ic->tag_size;
-
 		total_size -= to_copy;
 	} while (unlikely(total_size));
 

