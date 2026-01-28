Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE4717D6
	for <dm-devel@lists.linux.dev>; Wed, 28 Jan 2026 00:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769559153; cv=none; b=nr1G8rncC58n+fkbsiVwVhBuw0XBBcEwlijSiDY603iKGEHTG4Knumw00iBYKpIZL6evipzfii+NrFWa+/vvXCkef4Q6NFM33ha1jg+wku5oJOkGD4AdD18rRV4TF3CSmQ6vs8ehvqgwSkH2A+DcKAScSj/DcbtYy6IcO4Sp194=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769559153; c=relaxed/simple;
	bh=ftqjpD3/6xsC6mtx+f7qAMgo/+P73wLSRw1ND38vbkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Po6Ge4o6cT2dCHU6dNPFD69l3FumOZR+erOWOl5JdmP1V/LkTA7w9u2pbXsdurJM6Shtk3fIOHxOqYOM55km2WPGxjeAvVKw278vGVwqAndPa2z5n9jwwGfXu8/H9ad+CrphoNGQpFdHu0SiZON2H4Q0I4bfcc3SRUChqapK0fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VMOoMUJ7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VMOoMUJ7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769559150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+/8K+6HRNa6d1EjSMd/UYplAdVWcCDWMkWFQwCsfa2Y=;
	b=VMOoMUJ7t2fK3XmjKIC/+GVzeVuaY0FJ07YvD/HjCYcqQmmbgrjy+BXjXcQ1nMVRdIqYAc
	nlg0ZHyjybf3XRtaMSTi5I+2i8sBam+9bxDjTFs+/7OsKW1m8RFaofkkowid1RNNYGz6kS
	JdHdPRy0oLj/BGUTHAlv2zURWlmzXsQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-554-UswSKzy7N16l6pdi6CeTxA-1; Tue,
 27 Jan 2026 19:12:27 -0500
X-MC-Unique: UswSKzy7N16l6pdi6CeTxA-1
X-Mimecast-MFC-AGG-ID: UswSKzy7N16l6pdi6CeTxA_1769559146
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 503AC1955D95;
	Wed, 28 Jan 2026 00:12:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 002BF18007D2;
	Wed, 28 Jan 2026 00:12:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60S0COwd462762
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 19:12:24 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60S0COgX462761;
	Tue, 27 Jan 2026 19:12:24 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev
Subject: [PATCH 1/3] dm mpath: Add missing dm_put_device when failing to get scsi dh name
Date: Tue, 27 Jan 2026 19:12:22 -0500
Message-ID: <20260128001224.462746-2-bmarzins@redhat.com>
In-Reply-To: <20260128001224.462746-1-bmarzins@redhat.com>
References: <20260128001224.462746-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xa2hfNjwC0nTIpfJGQRq3CrwJg0ZbzG5aUCVtdOaQCU_1769559146
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When commit fd81bc5cca8f ("scsi: device_handler: Return error pointer in
scsi_dh_attached_handler_name()") added code to fail parsing the path if
scsi_dh_attached_handler_name() failed with -ENOMEM, it didn't clean up
the reference to the path device that had just been taken. Fix this, and
steamline the error paths of parse_path() a little.

Fixes: fd81bc5cca8f ("scsi: device_handler: Return error pointer in scsi_dh_attached_handler_name()")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-mpath.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index c748e7f952c4..6f9d86f4b912 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -960,27 +960,27 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 			attached_handler_name = NULL;
 		} else {
 			r = PTR_ERR(attached_handler_name);
-			goto bad;
+			ti->error = "error allocating handler name";
+			goto bad_put_device;
 		}
 	}
 	if (attached_handler_name || m->hw_handler_name) {
 		INIT_DELAYED_WORK(&p->activate_path, activate_path_work);
 		r = setup_scsi_dh(p->path.dev->bdev, m, &attached_handler_name, &ti->error);
 		kfree(attached_handler_name);
-		if (r) {
-			dm_put_device(ti, p->path.dev);
-			goto bad;
-		}
+		if (r)
+			goto bad_put_device;
 	}
 
 	r = ps->type->add_path(ps, &p->path, as->argc, as->argv, &ti->error);
-	if (r) {
-		dm_put_device(ti, p->path.dev);
-		goto bad;
-	}
+	if (r)
+		goto bad_put_device;
 
 	return p;
- bad:
+
+bad_put_device:
+	dm_put_device(ti, p->path.dev);
+bad:
 	free_pgpath(p);
 	return ERR_PTR(r);
 }
-- 
2.50.1

