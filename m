Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66604449B03
	for <dm-devel@lists.linux.dev>; Tue, 21 Jul 2026 06:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784615259; cv=none; b=HnUY9sA0ASdIFMX0YkxWzCG1B9nyDK99niIoZe+IMfkDqR3P/Tqbqv8fKYkfyqA6ub52WkxCnomRduvsfyx84f3pk5iDIpAH6zxt9zsZIcvmxfl1llK+q7QYObbc3PgyMHzh0aPrrM4hQJHUfNt/YvEabsqXjynZSnKrbpUOI40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784615259; c=relaxed/simple;
	bh=byASn10xRjGKGaaSGdk3CGHrUXjx28U1BkmzmXG5Fls=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=e+X5tyyqUIMH2ZQ1OW6gaNzVZ7bdB6pQ6mZvItSB0NW6nkk0MPaNrQlNbPeXjvBti/bm8SseMcEUSuA7I/HQIuzLY97b7d7mXDZduFRgYsaACA1/GOiln4qLHVgwgWogvxOPDWBzPlAWVmPdr8o3qF/I9Rtg5okKBjAt0e6QwCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BTH/ydDx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BTH/ydDx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784615256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ie/kKluMc0VJ+atn5bvnPt+QE6j0sOF4pt8KIzYYLBk=;
	b=BTH/ydDxfbsjMZd4j0WEam3SwM3Tyx6isxBBqh3ORM82PBTosUREZoFX197S5WCSQlDqU3
	yxRq8ufb0GJcknGhART5lOFX1imU45ROj0dGj8pwqwlTpSfRNK2g4XhOENTZ5yw7QKVQOE
	6NyI7xOrAJ3gHIcm38kBnrmtvhNS274=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-117-eN2S0semP-Wc28-Cz0I39Q-1; Tue,
 21 Jul 2026 02:27:33 -0400
X-MC-Unique: eN2S0semP-Wc28-Cz0I39Q-1
X-Mimecast-MFC-AGG-ID: eN2S0semP-Wc28-Cz0I39Q_1784615252
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 98BDE180025B;
	Tue, 21 Jul 2026 06:27:30 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C8C41800764;
	Tue, 21 Jul 2026 06:27:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 66L6RSaI2478404
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 21 Jul 2026 02:27:28 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 66L6ROuh2478402;
	Tue, 21 Jul 2026 02:27:24 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Kou Wenqi <kouwenqi@kylinos.cn>
Subject: [PATCH] kpartx: check slice size before looking for partition to remove
Date: Tue, 21 Jul 2026 02:27:24 -0400
Message-ID: <20260721062724.2478394-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HPXIw7CkLwGc6jRwYuR_7tt_47aJ6sMEnQe_aP1svMU_1784615252
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

After commit 03071031 ("kpartx: fix crash and truncated device creation
with long -p delimiter"), when attempting to remove deleted partitions
on kpartx -u, kpartx started calling dm_find_part() to check if the
partition existed before checking if the slice size was 0 (and thus
should get removed). The problem is that if dm_find_part() returns
DFP_DEVICE_RELOAD because the partition device exists, part_uuid gets
allocated, and if the slices[j].size is non-zero and the partition
device shouldn't be removed, part_uuid wasn't getting freed. Fix this by
reverting to checking the slice size first.

Fixes: 03071031 ("kpartx: fix crash and truncated device creation
with long -p delimiter")

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/kpartx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index fc8f9e5e..370d09a1 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -577,10 +577,11 @@ main(int argc, char **argv){
 
 			for (j = MAXSLICES-1; j >= 0; j--) {
 				char *part_uuid = NULL, *reason;
-				int res = dm_find_part(mapname, delim, j + 1, uuid,
-						       partname, sizeof(partname),
-						       &part_uuid, verbose);
-				if (slices[j].size || res != DFP_DEVICE_RELOAD)
+
+				if (slices[j].size ||
+				    dm_find_part(mapname, delim, j + 1, uuid, partname,
+						 sizeof(partname), &part_uuid,
+						 verbose) != DFP_DEVICE_RELOAD)
 					continue;
 
 				if (part_uuid && uuid) {
-- 
2.53.0

