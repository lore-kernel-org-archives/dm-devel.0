Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0F22FCE0E
	for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 18:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752171080; cv=none; b=Orx6iJg8KCMEkMacWyqCSCUHZD02T9YJFniabCvuSN6VqMLCZNEj4ym+/f9PBbKq8p9Lw3xvEYjuUOxiGLHujbgSG2qy5LnyE1dCcw+h3suzP9oDEAZ5ljTxfIkIOOxMJ1CQ8ZaaH8wm6G8fgDuQGm+c0Onv+IoU3Z1MLHpKCIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752171080; c=relaxed/simple;
	bh=MKrehrhn78sXQ3rR8M4VJcg81oTkT7h4X9hT//HFjLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=AnTv0vEPlLTWvlxyVaWt4ARMiUvHzSYwImIng1jyTVlSiieQyooZVUJ7IVMnU/hUN2fPBIjYCXuk/LsXDxsXsHkPnj1SRG2+NsBJ7IHzWl1PmXxXVaHKzIcbYRm36sNT4mhMAIZAIvjgIASvlUi/xCTccaT4xLp3TVaq/RFXKig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QVw0ZvHH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QVw0ZvHH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752171075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s0WMA3TL9Npjt/HYaAAAvhILkJlzLRHeyqip4wZMrJI=;
	b=QVw0ZvHHhIKrWo+K2sCVSoNErbYBA2UhASsBdocnvv7p6KDgI4D3edxAbPC5hsQ92GRc+f
	863CAtS1VJZh1j6pAnTaUHQY64DyjjFSH1KE9GlkOXwYWBhBcbMlHPNeoY+zdZJqwEebOm
	5FUHOk6O0W8ENHvg1oNpwN4cugyKU9w=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-96-ktq-1jlpOUy_kq3ajGDZDw-1; Thu,
 10 Jul 2025 14:11:09 -0400
X-MC-Unique: ktq-1jlpOUy_kq3ajGDZDw-1
X-Mimecast-MFC-AGG-ID: ktq-1jlpOUy_kq3ajGDZDw_1752171065
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F3B281801BD8;
	Thu, 10 Jul 2025 18:11:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B434C180045B;
	Thu, 10 Jul 2025 18:11:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56AIB3MP3997839
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Jul 2025 14:11:03 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56AIB35e3997838;
	Thu, 10 Jul 2025 14:11:03 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 14/15] libmpathpersist: use a switch statement for prout command finalizing
Date: Thu, 10 Jul 2025 14:10:59 -0400
Message-ID: <20250710181100.3997759-15-bmarzins@redhat.com>
In-Reply-To: <20250710181100.3997759-1-bmarzins@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Wq3w7kdpcRMXenyhWhkkmmZz2uqa6gLt1IL3I8OaT_Y_1752171065
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Change the code at the end of do_mpath_persistent_reserve_out() to
use a switch statement instead of multiple if statements. A future
patch will add more actions here, and a switch statement looks cleaner.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 1bb62531..ae0defc2 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -729,15 +729,19 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 		return MPATH_PR_OTHER;
 	}
 
-	if ((ret == MPATH_PR_SUCCESS) && ((rq_servact == MPATH_PROUT_REG_SA) ||
-				(rq_servact ==  MPATH_PROUT_REG_IGN_SA)))
-	{
+	if (ret != MPATH_PR_SUCCESS)
+		return ret;
+
+	switch (rq_servact) {
+	case MPATH_PROUT_REG_SA:
+	case MPATH_PROUT_REG_IGN_SA:
 		if (prkey == 0) {
 			update_prflag(mpp->alias, 0);
 			update_prkey(mpp->alias, 0);
 		} else
 			update_prflag(mpp->alias, 1);
-	} else if ((ret == MPATH_PR_SUCCESS) && (rq_servact == MPATH_PROUT_CLEAR_SA)) {
+		break;
+	case MPATH_PROUT_CLEAR_SA:
 		update_prflag(mpp->alias, 0);
 		update_prkey(mpp->alias, 0);
 	}
-- 
2.48.1

