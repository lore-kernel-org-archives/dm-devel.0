Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD0D189528
	for <dm-devel@lists.linux.dev>; Mon, 31 Mar 2025 23:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743463062; cv=none; b=NwgBxQCJwsrgR4vvbDPMIImRQNytVqE3BktWjtfs4V8FRrkBQSqDXHqZOTSnbvRSeNVuWer6JfI5HpyFKsI/BuRD6bSHOuKEmHrnQA/kwAMLjmF5iXpmYtF1agyC9iHAVJPauImLW0V5U+mZP0Szv1DjM73hdFuk8AdBNg0GhDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743463062; c=relaxed/simple;
	bh=CuN6+D5ZqtTmGk17pE7Z+aCbNysBVqnqk7UyBPXzhgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=IHg0gWPiidObHSRKeZLYUl2kd8Vg6hXr3385P/JCtKj5wMmqcjELQqd3mCa1Mq0kPj+1YRXgx3mOskuXICRENm2gL/foroMtrw7iUwiKCTXqaGohZeSPR8V4wCVTF1axU0jCIj7DaKSjcCPamjyQnWLjavUo3eCUcPX5S6h3Z1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TkcbCBUE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TkcbCBUE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743463057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z1u71JUgkCrZaaxyjgoiV8hcOXhStEfcLPqU6XJO4OM=;
	b=TkcbCBUEi3aktP3/A99yLU0FXLzh4v1PXskiHrsLEwEmFPH9sCavKvPPg1QaZaPxmiWfJ1
	x79JqENs55tQmG4tSHP3d64H5pbh6KprWifSQJ/yc50PIXxpjMJu4nrCrhgM/7qY/UX77I
	IJ30VKPlr6ifDwloccDLEfmF6ze72GQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-231-BEDrj17YMOO74YhAR_Itvw-1; Mon,
 31 Mar 2025 19:17:34 -0400
X-MC-Unique: BEDrj17YMOO74YhAR_Itvw-1
X-Mimecast-MFC-AGG-ID: BEDrj17YMOO74YhAR_Itvw_1743463053
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 15963195422C;
	Mon, 31 Mar 2025 23:17:33 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B18ED180174E;
	Mon, 31 Mar 2025 23:17:32 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 52VNHV842857671
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 31 Mar 2025 19:17:31 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 52VNHVEB2857670;
	Mon, 31 Mar 2025 19:17:31 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 1/3] multipathd: monitor new multipath dev even if we can't update it
Date: Mon, 31 Mar 2025 19:17:28 -0400
Message-ID: <20250331231730.2857655-2-bmarzins@redhat.com>
In-Reply-To: <20250331231730.2857655-1-bmarzins@redhat.com>
References: <20250331231730.2857655-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bS8Fb2lZq_hIUrU6gae4uPJqVs6h7dJt8Uoaycx9_mM_1743463053
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If a multipath device was created by the multipath command, multipathd
might not agree with how the device was created. ev_add_map() can reload
the device with a different table by calling add_map_without_path() ->
update_map(). If this reloading of the map failed, multipathd was simply
ignoring the multipath device, even though it still existed.

One way that reloading can fail is if a path that multipathd already has
initialized goes offline. If a multipath device is created by the
multipath command while the path is offline, it will not use the offline
path, since multipath won't be able to get the necessary pathinfo.
However, multipathd will already have the pathinfo for the path, and may
not even know that it's offline, since the path is an orphan. When it
tries to reload the device, it will include the offline path, and the
reload will fail.

Instead of ignoring the device if it can't reload it, multipathd should
just montior it as it is. When the path device is no longer offline, it
can be added back to the multipath device by calling
"multipathd reconfigure" or "multipathd add path <path>".

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck  <mwilck@suse.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index e63b6aa7..7aaae773 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -679,7 +679,7 @@ retry:
 	}
 
 fail:
-	if (new_map && (retries < 0 || wait_for_events(mpp, vecs))) {
+	if (new_map && wait_for_events(mpp, vecs)) {
 		condlog(0, "%s: failed to create new map", mpp->alias);
 		remove_map(mpp, vecs->pathvec, vecs->mpvec);
 		return 1;
-- 
2.48.1

