Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA45A3AE706
	for <dm-devel@lists.linux.dev>; Mon, 10 Aug 2026 21:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786395939; cv=none; b=YOq//lIefGhbedpsoig/Y9+vL53EQ95wekLFWK+fVfTNkOvgtQ17PEbkNhNqKr3qj7tX9HlSDXw4KvwhUYB3MdS/eCUvyfrnmG0VehZzNgqdD7FcCg3Rmv66y1ufYpIVpjMHvREQE9tJE6TrUO0GTzhPpPKgyOWdgpI/LYUXnA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786395939; c=relaxed/simple;
	bh=v/wuty/KzZh6PYseYXZaTYOjzPXKil/aux9lA9oZxEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=C5onMdepZeCiYevrkU9u3oNshi8SvEwHGmNOGFD7gnKm4LtiXCh2tPlUoZnHDixxzciXz4Ki71G42TJ04OtAQZojkrK836QKghEbco6i833ORiFLjV7PkXypcnJ4UTOL+wIUp3xwOFRQMcCqn27+NXX1+BCN1a+824prje9Fs3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FPLHH977; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FPLHH977"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786395936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8ziI0t1SqZKQZRigm+s9rJKZor2BOSkl7l1co3wBCqw=;
	b=FPLHH977G7hSHfWQ7hy7hVn3DvSwkODraIZ6TGxtNVFeLxWkSYqynBPkY8F41jHEL83xgB
	OqUlAjMF5FkaREchMNZvHYyu47udEqAaVaFfpJm9u+xxAgqha0AB/D9P152AIuzU31olMZ
	siWam9z/yxsDKwK765wcAVEWO4BDoN4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-510-GtVBGzPgMkmgPbZ1i5biNQ-1; Mon,
 10 Aug 2026 17:05:33 -0400
X-MC-Unique: GtVBGzPgMkmgPbZ1i5biNQ-1
X-Mimecast-MFC-AGG-ID: GtVBGzPgMkmgPbZ1i5biNQ_1786395932
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54B071800658;
	Mon, 10 Aug 2026 21:05:32 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 12A04195DF96;
	Mon, 10 Aug 2026 21:05:31 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 67AL5UBR1313206
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 10 Aug 2026 17:05:30 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 67AL5UOj1313193;
	Mon, 10 Aug 2026 17:05:30 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] libmpathutil: don't call pthread_testcancel as part of udev commands
Date: Mon, 10 Aug 2026 17:05:30 -0400
Message-ID: <20260810210530.1313185-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6bqOs98lsjDgo252CuQ_rDe_2-lrGXx92lfh8GOmelY_1786395932
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Commit 47a654f0 ("libmpathutil: udev: prevent interruption by thread
cancellation") added pthread_testcancel() calls to the udev command
wrappers. This makes these commands cancellation points (but only after
any waiting has already happened without cancellation), while the rest
of the code assumes that they are not.

This can cause problems like in uev_update_path() when multipathd first
calls udev_device_unref(pp->udev) and afterwards resets pp->udev. If the
thread is cancelled after unref'ing device in the udev_device_unref()
call, pp->udev will still point to the now-freed udev_device.

Fixes: 47a654f0 ("libmpathutil: udev: prevent interruption by thread cancellation")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathutil/mt-libudev.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/libmpathutil/mt-libudev.c b/libmpathutil/mt-libudev.c
index 813ce588..b81cf9c6 100644
--- a/libmpathutil/mt-libudev.c
+++ b/libmpathutil/mt-libudev.c
@@ -14,7 +14,6 @@ static pthread_mutex_t libudev_mutex = PTHREAD_MUTEX_INITIALIZER;
 		__r = func();						\
 		pthread_mutex_unlock(&libudev_mutex);			\
 		pthread_setcancelstate(__oldstate, NULL);		\
-		pthread_testcancel();					\
 		return __r;						\
 	}
 
@@ -27,7 +26,6 @@ static pthread_mutex_t libudev_mutex = PTHREAD_MUTEX_INITIALIZER;
 		__r = func(__arg1);						\
 		pthread_mutex_unlock(&libudev_mutex);			\
 		pthread_setcancelstate(__oldstate, NULL);		\
-		pthread_testcancel();					\
 		return __r;						\
 	}
 
@@ -40,7 +38,6 @@ static pthread_mutex_t libudev_mutex = PTHREAD_MUTEX_INITIALIZER;
 		__r = func(__arg1, __arg2);				\
 		pthread_mutex_unlock(&libudev_mutex);			\
 		pthread_setcancelstate(__oldstate, NULL);		\
-		pthread_testcancel();					\
 		return __r;						\
 	}
 
@@ -53,7 +50,6 @@ static pthread_mutex_t libudev_mutex = PTHREAD_MUTEX_INITIALIZER;
 		__r = func(__arg1, __arg2, __arg3);			\
 		pthread_mutex_unlock(&libudev_mutex);			\
 		pthread_setcancelstate(__oldstate, NULL);		\
-		pthread_testcancel();					\
 		return __r;						\
 	}
 
-- 
2.46.1

