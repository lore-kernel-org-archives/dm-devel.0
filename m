Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166402AEE1
	for <dm-devel@lists.linux.dev>; Tue,  2 Dec 2025 03:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764644540; cv=none; b=SMxJ9www9MGPUGzz+PW0oF50UwpU/QCDEKVc+hF1ac9YL8wIGTLOkv4ZrlinzgWRuzALVLWMzMXVod2XAPdpudtG6M82MuyyA6vqUiCZ+iVGv4Lto++i8W7t9iJ2bKKFcs9edZwQktolN64oATD1G/GMDvsg60VsLmIJGBP9OqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764644540; c=relaxed/simple;
	bh=VeVZJ9/D17TrpaHlWYebe4opwfRFN8Q7J94l5tj8tkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=itRronUkIs7MHzLQmh7Crq+er4nu4r0ItepnKDzuOcBfPwYaqQ77OXyLWzbRK7B378GqgrwUWYZAdcPBQ/mkq9J5SE+rZ/23YFZ2Fqq53k5kkFWt5CnrWRFZpDFtsE0YY/pqv0X7LlNE6+1XMiozCyUgDZYz7yzstvUQp4bAtxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fm7N4Uh4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fm7N4Uh4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764644538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R7AO2PFzp1HMCq/g3LZhd3h2oxvHrl2dPVtc6Ii129M=;
	b=Fm7N4Uh4YWKbXoEbV1wHH+P1SdHeWq3lCGjoDxa8cR2J+118fD8f15P0+2RpvGrQ9Nkg4B
	ljE2obs7lqvhTj9wKBwm5dGggGRgDsrzpxVDSv7XYKigqyNKnVB7VDVvhakrkl4Gds01w7
	5zhEMKdrDAkID8esCIP2cwRCqn9mSFs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-57-5aNCm9o4OEqEnX6aeTFqoQ-1; Mon,
 01 Dec 2025 22:02:16 -0500
X-MC-Unique: 5aNCm9o4OEqEnX6aeTFqoQ-1
X-Mimecast-MFC-AGG-ID: 5aNCm9o4OEqEnX6aeTFqoQ_1764644536
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C5F02180009D;
	Tue,  2 Dec 2025 03:02:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5EF65195608E;
	Tue,  2 Dec 2025 03:02:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5B232E8g1432989
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 1 Dec 2025 22:02:14 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5B232E2I1432988;
	Mon, 1 Dec 2025 22:02:14 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 3/4] multipathd: remember number of registered keys when ioctl fails
Date: Mon,  1 Dec 2025 22:02:12 -0500
Message-ID: <20251202030213.1432964-4-bmarzins@redhat.com>
In-Reply-To: <20251202030213.1432964-1-bmarzins@redhat.com>
References: <20251202030213.1432964-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7xInzILLJtuS_WjfOlEhcTWS4pEHTs_BNoDEBB4k3G4_1764644536
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If prin_do_scsi_ioctl() fails in update_map_pr() for some reason other
than Persistent Reservations not being supported, It shouldn't clear the
number of registered keys, since there's no reason to think that it has
changed. Similarly, if update_map_pr() fails in mpath_pr_event_handle(),
don't assume that the nr_keys_needed was cleared. Just return whatever
the value is now. This saves multipathd from doing pointless calls to
update_map_pr(), if one of the paths is failing.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 4c86f31e..a7650639 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -4278,7 +4278,9 @@ void unset_pr(struct multipath *mpp)
  * The number of found keys must be at least as large as *nr_keys,
  * and if MPATH_PR_SUCCESS is returned and mpp->prflag is PR_SET after
  * the call, *nr_keys will be set to the number of found keys. Otherwise
- * it will be set to 0.
+ * if mpp->prflag is PR_UNSET it will be set to 0. If MPATH_PR_SUCCESS
+ * is not returned and mpp->prflag is not PR_UNSET, nr_keys will not be
+ * changed.
  */
 static int update_map_pr(struct multipath *mpp, struct path *pp, unsigned int *nr_keys)
 {
@@ -4307,11 +4309,12 @@ static int update_map_pr(struct multipath *mpp, struct path *pp, unsigned int *n
 
 	ret = prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RKEY_SA, &resp, 0);
 	if (ret != MPATH_PR_SUCCESS) {
-		if (ret == MPATH_PR_ILLEGAL_REQ)
+		if (ret == MPATH_PR_ILLEGAL_REQ) {
 			unset_pr(mpp);
+			*nr_keys = 0;
+		}
 		condlog(0, "%s : pr in read keys service action failed Error=%d",
 			mpp->alias, ret);
-		*nr_keys = 0;
 		return ret;
 	}
 
@@ -4427,7 +4430,7 @@ retry:
 			clear_reg ? "Clearing" : "Setting", pp->dev, ret);
 	} else if (!clear_reg) {
 		if (update_map_pr(mpp, pp, &nr_keys_needed) != MPATH_PR_SUCCESS)
-			return 0;
+			return nr_keys_needed;
 		if (mpp->prflag != PR_SET) {
 			memset(&param, 0, sizeof(param));
 			clear_reg = true;
-- 
2.50.1

