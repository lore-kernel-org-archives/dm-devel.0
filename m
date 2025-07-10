Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2176B2FCFCC
	for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 18:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752171072; cv=none; b=TUh2RRVzdotfH+IhLy0IUvEbBF9MteHQbuNRgjQJyfRdWULNtfLVxqh6T+/MgclkV8wR4ISToByfdCCDdm/PsnejqMZQbReqxtZ+9W9E5Rs/Wm2btrjZC8R+SDM/ozWs24/oWUio/xkw+d5j6K/jO5YRMYc/yVZ7pNzJb34OxG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752171072; c=relaxed/simple;
	bh=NL0ujqU9YiCcq1A7oJ846naqobClq4ERYTlfx9JjUOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=JcIy3PpXF7Wrdepb9jmZTzKF2mpAqevk/t/aD/Ro8iDYeLRyJj72cwSItDAiK2m28lOXBrhlI4uJDCY0XL0Fwn6ZvuLQ8UyNJqf8GKGkO5dJZICQXAzQBG1PPOZsCOjB9/lUifI31chk/x6d73RonxK/AwvhoxMUqOpfhuJGy48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aB+baF69; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aB+baF69"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752171069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZmqOM3trOraIQaEjZ9+GxAdEOjwwcUZeXd3ypYV0VWs=;
	b=aB+baF69PPTjJzsGQQRKWV7lyiXnFyXwziRgPTl9tGWSXwFSifDUyuen2FcnHHqo5HDtkM
	KmcfgxhesoCyOQsju7mMJ52DC18y5u487POPE1Bm+4Zi631r84EdvxMP5u9GUMXuml0zHF
	UFS9eZlmdpVmt7uXW9EEQK8Jkazhwv4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-155--b8HGY2TPuGDMENb74mkmw-1; Thu,
 10 Jul 2025 14:11:04 -0400
X-MC-Unique: -b8HGY2TPuGDMENb74mkmw-1
X-Mimecast-MFC-AGG-ID: -b8HGY2TPuGDMENb74mkmw_1752171063
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 986971800287;
	Thu, 10 Jul 2025 18:11:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 51A77195607A;
	Thu, 10 Jul 2025 18:11:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56AIB18E3997799
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Jul 2025 14:11:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56AIB1pg3997798;
	Thu, 10 Jul 2025 14:11:01 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 04/15] libmpathpersist: remove pointless update_map_pr ret value code
Date: Thu, 10 Jul 2025 14:10:49 -0400
Message-ID: <20250710181100.3997759-5-bmarzins@redhat.com>
In-Reply-To: <20250710181100.3997759-1-bmarzins@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xvB6eMDsmxCQn-ddH3qNL0YhtXyVkI39P57Lbyk1Ljk_1752171063
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Don't set ret to MPATH_PR_SUCCESS, after the code just made sure that
it was already set to MPATH_PR_SUCCESS.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 4172167a..f2c81fa0 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -757,8 +757,6 @@ int update_map_pr(struct multipath *mpp)
 		goto out;
 	}
 
-	ret = MPATH_PR_SUCCESS;
-
 	if (resp->prin_descriptor.prin_readkeys.additional_length == 0 )
 	{
 		condlog(was_set ? 1 : 3, "%s: No key found. Device may not be registered. ", mpp->alias);
-- 
2.48.1

