Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0121C2439
	for <dm-devel@lists.linux.dev>; Thu, 12 Sep 2024 21:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726177799; cv=none; b=QXQYw7rf8prjUrbifFDXyRXkvncgKB6ly8O0Y2vVXEHp34TOh/yCTlIBXWc4jj6x1vJeII5MZ+hnsxs+Qe5cMywveEuoNx84kLHe1SZg8g8XhP0oswzP/fAxGdZh0f6o3wGK6UmR/jNCSohp/tI8wgd4RyNwxz5xQxLmVXh+Bs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726177799; c=relaxed/simple;
	bh=oUUQxL8lngai9HYI1KI075A71/0yKOuieuGB/uQh2uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g9uDnakmmpfd3RBBDgBzgZge0d2hcOtaOtF5ZVrIBHehfpFtSGmj0WO4BpY4LtqO4ItbaSDlLvZFeUerZ+uHWsB/DGRIqxLMwv49vLOkEsGrwruCC28qrpYJOOTc8lxtdSxrYQL2SKUgO0rNF6y1reIfz9HH9MVhmfjgPGjenb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HZ7BNoFC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HZ7BNoFC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726177797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tFjAkU37RT/OVZVw7Ccd/QYvoq1tLMhDHEEoekJ8nCY=;
	b=HZ7BNoFCnX2NKLvK5OPScYPrcJ1NiAHCjZM+ejEHpQiynp6zmaVf1UPuDKt8NWRT2hv7Uh
	YNhz2bGaySJjpulXwljJHRX8bUS/AKKVibOIG1pKPnywQwKkFzIULdnOkW9Wtp+6qFv+fa
	aTGXirzR0+V9CEJftOklD+qIuVQsit4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-nREQADmyNwqKj5UrY9OUiw-1; Thu,
 12 Sep 2024 17:49:53 -0400
X-MC-Unique: nREQADmyNwqKj5UrY9OUiw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E4BE81955D45;
	Thu, 12 Sep 2024 21:49:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7AEDD19560B9;
	Thu, 12 Sep 2024 21:49:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 48CLnpV8783914
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 17:49:51 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 48CLnp7A783913;
	Thu, 12 Sep 2024 17:49:51 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 16/22] multipathd: only refresh prios on PATH_UP and PATH_GHOST
Date: Thu, 12 Sep 2024 17:49:41 -0400
Message-ID: <20240912214947.783819-17-bmarzins@redhat.com>
In-Reply-To: <20240912214947.783819-1-bmarzins@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

The way that multipathd was handling priority refreshes had some issues.
Some of the multipath prioritizers can hang when run on a failed path.
Multipathd was only skipping paths in PATH_DOWN, but there are other
states where the prioritizer is also likely to hang, such as
PATH_TIMEOUT, PATH_SHAKY, and to a lesser extent, PATH_DELAYED.

Also, before the recent patch splitting the priority updating from the
path checking, multipathd wasn't consistent with which states would
cause
paths to get their priorities updated. If a path changed its state to
anything other than PATH_UP or PATH_GHOST, it wouldn't get its priority
updated.  But if a path kept the same state its priority would get
updated as long at the state wasn't PATH_DOWN.

For safety's sake, a path's priority should only get refreshed when its
in the PATH_UP or PATH_GHOST state. This shouldn't cause problems. Only
paths that are in the PATH_UP or PATH_GHOST state are usable by the
kenel and contibute to the pathgroup's priority.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 75bc0620..91806e9d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2162,7 +2162,7 @@ static bool update_prio(struct multipath *mpp, bool refresh_all)
 
 	vector_foreach_slot (mpp->pg, pgp, i) {
 		vector_foreach_slot (pgp->paths, pp, j) {
-			if (pp->state == PATH_DOWN)
+			if (pp->state != PATH_UP && pp->state != PATH_GHOST)
 				continue;
 			if (!refresh_all &&
 			    pp->is_checked != CHECK_PATH_CHECKED) {
@@ -2186,7 +2186,7 @@ static bool update_prio(struct multipath *mpp, bool refresh_all)
 	 */
 	vector_foreach_slot (mpp->pg, pgp, i) {
 		vector_foreach_slot (pgp->paths, pp, j) {
-			if (pp->state == PATH_DOWN)
+			if (pp->state != PATH_UP && pp->state != PATH_GHOST)
 				continue;
 			if (pp->is_checked == CHECK_PATH_CHECKED)
 				continue;
-- 
2.45.0

