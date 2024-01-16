Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3932111181
	for <dm-devel@lists.linux.dev>; Tue, 16 Jan 2024 07:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NeuZSY+S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705388710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ycWKmT9L6WD4D9x/TtnkEnSlxX4CSsS0nkKOKg4x+Yc=;
	b=NeuZSY+SMiSFfuo6c2DWGS4gcxvWBzS0XrE1yLo1lubD2B5bmxUF3pth0jhr+dubHvANEO
	ySn5q4t2N9fqQJ9yMsNtou2AavpiQhloI+bweR/VY6tDygFXfTZ5Y2wxQIXYZCX2Bf94Lb
	9q3kXKXgXgsYlfcIIJXoXiSdrXjn0C4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-556-V2uuz4yMNaaaRpdl6G5xkA-1; Tue,
 16 Jan 2024 02:05:08 -0500
X-MC-Unique: V2uuz4yMNaaaRpdl6G5xkA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49D29280FEC3;
	Tue, 16 Jan 2024 07:05:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4463D492BC6;
	Tue, 16 Jan 2024 07:05:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 40G758dw010582
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 02:05:08 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 40G758di010581;
	Tue, 16 Jan 2024 02:05:08 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 2/2] multipathd: fix auto-resize configuration
Date: Tue, 16 Jan 2024 02:05:07 -0500
Message-ID: <20240116070507.10563-3-bmarzins@redhat.com>
In-Reply-To: <20240116070507.10563-1-bmarzins@redhat.com>
References: <20240116070507.10563-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

The code acted like AUTO_RESIZE_UNDEFINED didn't exist, but since
conf->auto_resize was never set to AUTO_RESIZE_NEVER, the default was in
fact AUTO_RESIZE_UNDEFINED, which ended up getting treated like
AUTO_RESIZE_GROW_SHRINK. Remove AUTO_RESIZE_UNDEFINED, so
AUTO_RESIZE_NEVER really is the default.

Fixes: 981b83ad1 ("multipathd: Add auto_resize config option")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/defaults.h | 1 -
 libmultipath/structs.h  | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 64b633f2..d01f9712 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -56,7 +56,6 @@
 #define DEFAULT_UNKNOWN_FIND_MULTIPATHS_TIMEOUT 1
 #define DEFAULT_ALL_TG_PT ALL_TG_PT_OFF
 #define DEFAULT_RECHECK_WWID RECHECK_WWID_OFF
-#define DEFAULT_AUTO_RESIZE AUTO_RESIZE_NEVER
 /* Enable no foreign libraries by default */
 #define DEFAULT_ENABLE_FOREIGN "NONE"
 
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index a1aac1b4..f133e78f 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -180,8 +180,7 @@ enum queue_mode_states {
 };
 
 enum auto_resize_state {
-	AUTO_RESIZE_UNDEF = 0,
-	AUTO_RESIZE_NEVER,
+	AUTO_RESIZE_NEVER = 0,
 	AUTO_RESIZE_GROW_ONLY,
 	AUTO_RESIZE_GROW_SHRINK,
 };
-- 
2.43.0

