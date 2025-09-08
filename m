Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BADF31283F
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376015; cv=none; b=D37Sf30DmGl5CGmBAah3ozruP8t+SHxKY1/85rlj5Dys2JOrMWV/NXIgeTsG03R3wNrfuomkuCyRu9yfiJT2mpr60nXPTmpTSlKiIA3eCe1UubMgAm59b5Nor7rOT1kSAk/TlgD3guD5MlU9+3cHXFie8gWkbihFtDtJ0GWnYgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376015; c=relaxed/simple;
	bh=CS7eMaP7MK+jH4zGKAm7EHYUonSEU5220k7tgoLrw+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=gSBe3BTFVnYXIiPdOe69I8ir+qlm+H6lQuFoOdnnLu9CAOjI5bJcGHNEQUojL57QZ6+hmoLiZ3QpeWA5J/Z3Ucvrzke6xhaPdqRfAJeL/L+wme/wvwnoc46jxXk7J+ApgbJ8aaqg1HxGcM80ZKnrF26r5m4grQT2LQ2oEQMQ114=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WMWwcPpw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WMWwcPpw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nCUxSs3Z+52X3mhhE4T4TCGYyw9CSuPs03RlR+nWq9Q=;
	b=WMWwcPpwBgqoOvGkeP4tZpaXpbKt4bhLJJ3nToE/keRvhmMrrGQGE5D2QdDdAoV4aSdyLI
	sf7YSg0y7TEQrN5GRqIWpGHQ7z8sYAQgTnA8DR8R7jxbObbRo5rh90OPHZXbnZupOV2stK
	fJlUIQf9SdwcRnXrmRTUkQQk9QJtr9c=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-567--nNTl76YOiuC6UXiNcpbEQ-1; Mon,
 08 Sep 2025 20:00:06 -0400
X-MC-Unique: -nNTl76YOiuC6UXiNcpbEQ-1
X-Mimecast-MFC-AGG-ID: -nNTl76YOiuC6UXiNcpbEQ_1757376005
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E0C819560AD;
	Tue,  9 Sep 2025 00:00:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 460DC1955F24;
	Tue,  9 Sep 2025 00:00:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589003QS751088
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:03 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 589003kq751087;
	Mon, 8 Sep 2025 20:00:03 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 02/32] libmpathpersist: remove uneeded wrapper function.
Date: Mon,  8 Sep 2025 19:59:32 -0400
Message-ID: <20250909000002.751039-3-bmarzins@redhat.com>
In-Reply-To: <20250909000002.751039-1-bmarzins@redhat.com>
References: <20250909000002.751039-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _9imuVgJtnuKaG1jkcd1y804rXG55polMdozbcAmfr8_1757376005
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

mpath_send_prin_activepath() just calls prin_do_scsi_ioctl() with exactly
the same arguments that it is passed, and returns the same return. remove
it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 9ed9f5a7..5ec896bd 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -49,17 +49,6 @@ struct threadinfo {
 	struct prout_param param;
 };
 
-static int mpath_send_prin_activepath (char * dev, int rq_servact,
-				struct prin_resp * resp, int noisy)
-{
-
-	int rc;
-
-	rc = prin_do_scsi_ioctl(dev, rq_servact, resp,  noisy);
-
-	return (rc);
-}
-
 static int mpath_prin_activepath (struct multipath *mpp, int rq_servact,
 	struct prin_resp * resp, int noisy)
 {
@@ -80,8 +69,7 @@ static int mpath_prin_activepath (struct multipath *mpp, int rq_servact,
 
 			condlog(3, "%s: sending pr in command to %s ",
 				mpp->wwid, pp->dev);
-			ret = mpath_send_prin_activepath(pp->dev, rq_servact,
-							 resp, noisy);
+			ret = prin_do_scsi_ioctl(pp->dev, rq_servact, resp, noisy);
 			switch(ret)
 			{
 				case MPATH_PR_SUCCESS:
-- 
2.50.1

