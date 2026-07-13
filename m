Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04EC355819
	for <dm-devel@lists.linux.dev>; Mon, 13 Jul 2026 19:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783970763; cv=none; b=hKe5q7ZEJVMtck74FyEgxeVSlNjdxgciSaiHWusWL/OfUElRv4MSHEJsraOLbtaB0wP6SGALGznNauDVLL0tZ1h9NJgUcSe0B+eDomFUVI5bOmWXVhS8DpIC9gBE6Vl3S18WQxY9nychiE/OxV8XEvcqcOcnrAFexvGOuMpp0Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783970763; c=relaxed/simple;
	bh=S44Kcdxr9iULuaAqu8ofyzcTfJSjmh+82XS0GqP2IUY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=a1CNIUZ+kQVBUDUTs80ThMWZNZBDTu/mt5KuTyi4xxZjOvEfHsstwre/TbH6GxFsgpKDNck74/gkRMAV3URK/1saLwLsr2vx4FQinmBjaS7cIJPgTKY2BB3M/C/SeI0Mh1nVeD+UW/m1KiWebi4vHDI/8ebhHjd/nrtB8JE2UYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SM8zMokS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SM8zMokS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783970761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=f4MZ0X8QcswqEP2Vyx1BzYaLcI2h3kLnYm1jky8/tb8=;
	b=SM8zMokSvgR4I3H38YnSU+4lMMOnOqzqUwKCJSCUtDmsQQdE5IO+FcA6rYOk9J0hrK6pkb
	Apz6hCbvO+WZe64jlmeAU9VbK9LKHPPlh2mOj+rqNFOGXAquLdzVZDTPR9ctrP+XMQp4yd
	ejLBPf3aDYicli40gzRxepTlk49hfYs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-OuYMu-aCNyacpTAY4X3GMw-1; Mon,
 13 Jul 2026 15:25:57 -0400
X-MC-Unique: OuYMu-aCNyacpTAY4X3GMw-1
X-Mimecast-MFC-AGG-ID: OuYMu-aCNyacpTAY4X3GMw_1783970757
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E8E8E180044D;
	Mon, 13 Jul 2026 19:25:56 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ABB18180059F;
	Mon, 13 Jul 2026 19:25:55 +0000 (UTC)
Date: Mon, 13 Jul 2026 21:25:53 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Subject: [PATCH] dm-table: fix spelling
Message-ID: <077e2c07-2676-ec89-25fe-a2c38805f295@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dMetk5-G6NgO8OAg8ixGk3kbGuyJ71ocdpMqalMldYs_1783970757
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Fix spelling: impementation -> implementation.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6

---
 drivers/md/dm-table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c	2026-02-23 19:31:52.000000000 +0100
+++ linux-2.6/drivers/md/dm-table.c	2026-06-23 13:36:13.000000000 +0200
@@ -2035,7 +2035,7 @@ int dm_table_set_restrictions(struct dm_
 		limits->features &= ~BLK_FEAT_NOWAIT;
 
 	/*
-	 * The current polling impementation does not support request based
+	 * The current polling implementation does not support request based
 	 * stacking.
 	 */
 	if (!__table_type_bio_based(t->type))

