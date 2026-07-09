Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6A24499B9
	for <dm-devel@lists.linux.dev>; Thu,  9 Jul 2026 19:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783625606; cv=none; b=WrUcEMn4VMrxbWdYn6Zf3IeLULFft6hgCWL/kOW7EL52PWEUodUktGm6AZJfqiMuNgIGCHQx6Ugs47pI6iQPz9/tbMDifKxp+7Gaxds219puS5iP3Y73xzgDSYVkbwFFj+wCbYFDjkiDXcuJs+jrA5ubsVXkSrcB05Jfio9XLRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783625606; c=relaxed/simple;
	bh=cfaytXwhHPpfd/BcYmkKIclm2M7/gLduXDrGhYPDIVc=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=HU0XQ8ZI3xCbQ9jVTEyLgD+bjPQE2k4Wqwvkvc0ZDSvw0rAOd9ICFkJaCC7GGeWrn3aMeDOb/dT8c4iehSPUY6CqIcmtC4VOgoTeDkzxh6Yo6Peuklk+zTYHudZNBhC2W7Iqg0EczttbDCcRNZOHtUO0aLuun1ihXQr3MVfykWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H/6PbEEL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H/6PbEEL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783625604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=aDLqaHuJag+0UTvRn/apMIW7Pt7jpmVDQPvj7RyYi/8=;
	b=H/6PbEELXH8bmNExUSsJoXsjgA+Ntkyj+AiInVs0YqOXfajd7EN7YS2h9dIjTKPK4ud7si
	++N4+lSjiWMxJXLnzqXObBBIiFwDWqbJaMwcYxU289BLo3JTOYnwKQ9uX8abEXOkWOdpvj
	oygM48jlpKgJO0lQnx8Z1NS/J0cpP5g=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-586-Ir8CTOxmOmGHo_DF-1kTnw-1; Thu,
 09 Jul 2026 15:33:22 -0400
X-MC-Unique: Ir8CTOxmOmGHo_DF-1kTnw-1
X-Mimecast-MFC-AGG-ID: Ir8CTOxmOmGHo_DF-1kTnw_1783625601
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B5590195606F;
	Thu,  9 Jul 2026 19:33:21 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 76D651955D71;
	Thu,  9 Jul 2026 19:33:20 +0000 (UTC)
Date: Thu, 9 Jul 2026 21:33:16 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-verity: avoid double increment of &use_bh_wq_enabled
Message-ID: <6c552142-174a-6d1d-9312-047f5526bc75@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: k8wL6UFzHsQPkGEb701xRWgaW4d7HZob2HMvdnz7Tk8_1783625601
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

verity_parse_opt_args is called twice, first with the only_modifier_opts,
first with only_modifier_opts == true and then with only_modifier_opts ==
false. Thus, the static branch &use_bh_wq_enabled was incremented twice
and the destructor verity_dtr would only decrement it once.

Fix tihs bug by only incrementing it on the first call, on the second
call, when v->use_bh_wq is true, do nothing.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Cc: stable@vger.kernel.org
Fixes: df326e7a0699 ("dm verity: allow optional args to alter primary args handling")

---
 drivers/md/dm-verity-target.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/drivers/md/dm-verity-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-target.c	2026-07-01 13:24:34.000000000 +0200
+++ linux-2.6/drivers/md/dm-verity-target.c	2026-07-01 13:31:00.000000000 +0200
@@ -1262,6 +1262,8 @@ static int verity_parse_opt_args(struct
 			continue;
 
 		} else if (!strcasecmp(arg_name, DM_VERITY_OPT_TASKLET_VERIFY)) {
+			if (v->use_bh_wq)
+				continue;
 			v->use_bh_wq = true;
 			static_branch_inc(&use_bh_wq_enabled);
 			continue;

