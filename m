Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 852E3C636CC
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319277;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zTRPTTqa7lo2MnAkiWMldkn6EHag1i00dYQj0DvrmMg=;
	b=XNvFsg2HBZXyYvfSaqhuw/fTPxBRKl/cBRikFZE+XymggWujebiLC3iVuxzGrNs9pHyU1l
	ik1+UJAg5nfG2K/3rkPJBvY91JQ36hGgdXD0JOsxRr7NdCA6K2BNTqSh3ZVnx++ksdR3ut
	nPo4rgfy/fQBRNX1VVY0qlwCoaqqji0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-hWXSPvWhMEGBkvajgTzE4g-1; Mon, 13 Feb 2023 15:14:34 -0500
X-MC-Unique: hWXSPvWhMEGBkvajgTzE4g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7A8680006E;
	Mon, 13 Feb 2023 20:14:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 90356140EBF6;
	Mon, 13 Feb 2023 20:14:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 520B11946588;
	Mon, 13 Feb 2023 20:14:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 03B071946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:14:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E824A492B05; Mon, 13 Feb 2023 20:14:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E00F0492B04
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBDDD86C165
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:30 +0000 (UTC)
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com
 [209.85.219.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-82-PGR-OVaaNBeqyN6kNdcssQ-1; Mon, 13 Feb 2023 15:14:29 -0500
X-MC-Unique: PGR-OVaaNBeqyN6kNdcssQ-1
Received: by mail-qv1-f48.google.com with SMTP id q10so9077766qvt.10
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:14:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=b8V19dG4696q4kwQcAeGFDeSw7fqjMeFlyiU7L5nd7c=;
 b=L0BLLnake6H0vmzOd8DvOnlmO7uXieZ61fvTKUuiTHyhkaKQ6H5kMAw7yu9OlcZcmD
 o/hB2ueZQf5Y9ePHzuu3rImr+5jYJ6on34+qWwayLPEcAyqx3RJXa2EAnPsN1ydWzmNI
 KUC1OMCOhd2JqZM0rkOOYZHtUZ/biEjaxZbgjrhM3o4TdiXWaj2+V7zF4Z/1UhYVZbBI
 /hZLavjaL9zf93++U+Vxrk4MyamyH4RUg2Tcz35OI6Goi+HHL9SE0RjXJWI4ufZEgMTJ
 cyyj8CoRNs32Zb505u5Q/2+GMxVbisHPeiYAVlajCNiG3B6DIT/FL7m4VDrKvH22+J5/
 I3Xw==
X-Gm-Message-State: AO0yUKXhDScGlNeWHqHLrDkebejbxLr3UvHb2G1hjobk9hjtPTYeXCfV
 K+wrFOBdTGNxW4DXKVxryq7b941N0wq3WQyaq8uV3AxZJU07LrjC0cq+UfNOX9aXGMFyu68uWOQ
 dQeQMs32ZRXlrohMRfEPUuEZFVBjoCMg/iXrnVi4ZSe1nmO+wx9CbxFhsPzUVr0/BlO7kyw==
X-Google-Smtp-Source: AK7set/dwUCzS6FlR9d6+m+m0VxmO4gVizk2xaLzRw99ebr29EdSXJKuO1GwqI5nrlVCcTZGq4Rccg==
X-Received: by 2002:ad4:576e:0:b0:56e:9eb2:5e92 with SMTP id
 r14-20020ad4576e000000b0056e9eb25e92mr471049qvx.11.1676319267895; 
 Mon, 13 Feb 2023 12:14:27 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 t185-20020a37aac2000000b0071eddd3bebbsm10390830qke.81.2023.02.13.12.14.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:14:27 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:23 -0500
Message-Id: <20230213201401.45973-2-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH 01/39] dm: add missing SPDX-License-Indentifiers
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: ebiggers@kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bio-prison-v1.c                            | 1 +
 drivers/md/dm-bio-prison-v1.h                            | 1 +
 drivers/md/dm-bio-prison-v2.c                            | 1 +
 drivers/md/dm-bio-prison-v2.h                            | 1 +
 drivers/md/dm-bio-record.h                               | 1 +
 drivers/md/dm-bufio.c                                    | 1 +
 drivers/md/dm-cache-background-tracker.c                 | 1 +
 drivers/md/dm-cache-background-tracker.h                 | 1 +
 drivers/md/dm-cache-block-types.h                        | 1 +
 drivers/md/dm-cache-metadata.c                           | 1 +
 drivers/md/dm-cache-metadata.h                           | 1 +
 drivers/md/dm-cache-policy-internal.h                    | 1 +
 drivers/md/dm-cache-policy-smq.c                         | 1 +
 drivers/md/dm-cache-policy.c                             | 1 +
 drivers/md/dm-cache-policy.h                             | 1 +
 drivers/md/dm-cache-target.c                             | 1 +
 drivers/md/dm-core.h                                     | 1 +
 drivers/md/dm-crypt.c                                    | 1 +
 drivers/md/dm-delay.c                                    | 1 +
 drivers/md/dm-ebs-target.c                               | 1 +
 drivers/md/dm-exception-store.c                          | 1 +
 drivers/md/dm-exception-store.h                          | 1 +
 drivers/md/dm-flakey.c                                   | 1 +
 drivers/md/dm-ima.h                                      | 4 ++--
 drivers/md/dm-init.c                                     | 1 -
 drivers/md/dm-integrity.c                                | 1 +
 drivers/md/dm-io-rewind.c                                | 2 +-
 drivers/md/dm-io-tracker.h                               | 1 +
 drivers/md/dm-io.c                                       | 1 +
 drivers/md/dm-ioctl.c                                    | 1 +
 drivers/md/dm-kcopyd.c                                   | 1 +
 drivers/md/dm-linear.c                                   | 1 +
 drivers/md/dm-log-userspace-base.c                       | 1 +
 drivers/md/dm-log-userspace-transfer.c                   | 1 +
 drivers/md/dm-log-userspace-transfer.h                   | 1 +
 drivers/md/dm-log-writes.c                               | 1 +
 drivers/md/dm-log.c                                      | 1 +
 drivers/md/dm-mpath.c                                    | 1 +
 drivers/md/dm-mpath.h                                    | 1 +
 drivers/md/dm-path-selector.c                            | 1 +
 drivers/md/dm-path-selector.h                            | 1 +
 drivers/md/dm-ps-queue-length.c                          | 1 +
 drivers/md/dm-ps-round-robin.c                           | 1 +
 drivers/md/dm-ps-service-time.c                          | 1 +
 drivers/md/dm-raid.c                                     | 1 +
 drivers/md/dm-raid1.c                                    | 1 +
 drivers/md/dm-region-hash.c                              | 1 +
 drivers/md/dm-rq.c                                       | 1 +
 drivers/md/dm-rq.h                                       | 1 +
 drivers/md/dm-snap-persistent.c                          | 1 +
 drivers/md/dm-snap-transient.c                           | 1 +
 drivers/md/dm-snap.c                                     | 1 +
 drivers/md/dm-stripe.c                                   | 1 +
 drivers/md/dm-switch.c                                   | 1 +
 drivers/md/dm-sysfs.c                                    | 1 +
 drivers/md/dm-table.c                                    | 1 +
 drivers/md/dm-target.c                                   | 1 +
 drivers/md/dm-thin-metadata.c                            | 1 +
 drivers/md/dm-thin-metadata.h                            | 1 +
 drivers/md/dm-thin.c                                     | 1 +
 drivers/md/dm-unstripe.c                                 | 1 +
 drivers/md/dm-verity-verify-sig.h                        | 2 +-
 drivers/md/dm-zero.c                                     | 1 +
 drivers/md/dm.c                                          | 1 +
 drivers/md/persistent-data/dm-array.c                    | 1 +
 drivers/md/persistent-data/dm-array.h                    | 1 +
 drivers/md/persistent-data/dm-bitset.c                   | 1 +
 drivers/md/persistent-data/dm-bitset.h                   | 1 +
 drivers/md/persistent-data/dm-block-manager.c            | 1 +
 drivers/md/persistent-data/dm-block-manager.h            | 1 +
 drivers/md/persistent-data/dm-btree-internal.h           | 1 +
 drivers/md/persistent-data/dm-btree-remove.c             | 1 +
 drivers/md/persistent-data/dm-btree-spine.c              | 1 +
 drivers/md/persistent-data/dm-btree.c                    | 1 +
 drivers/md/persistent-data/dm-btree.h                    | 1 +
 drivers/md/persistent-data/dm-persistent-data-internal.h | 1 +
 drivers/md/persistent-data/dm-space-map-common.c         | 1 +
 drivers/md/persistent-data/dm-space-map-common.h         | 1 +
 drivers/md/persistent-data/dm-space-map-disk.c           | 1 +
 drivers/md/persistent-data/dm-space-map-disk.h           | 1 +
 drivers/md/persistent-data/dm-space-map-metadata.c       | 1 +
 drivers/md/persistent-data/dm-space-map-metadata.h       | 1 +
 drivers/md/persistent-data/dm-space-map.h                | 1 +
 drivers/md/persistent-data/dm-transaction-manager.c      | 1 +
 drivers/md/persistent-data/dm-transaction-manager.h      | 1 +
 include/linux/device-mapper.h                            | 1 +
 include/linux/dm-bufio.h                                 | 1 +
 include/linux/dm-dirty-log.h                             | 1 +
 include/linux/dm-io.h                                    | 1 +
 include/linux/dm-kcopyd.h                                | 1 +
 include/linux/dm-region-hash.h                           | 1 +
 91 files changed, 91 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-bio-prison-v1.c b/drivers/md/dm-bio-prison-v1.c
index 1f8f98efd97a..db7d95d3bb5e 100644
--- a/drivers/md/dm-bio-prison-v1.c
+++ b/drivers/md/dm-bio-prison-v1.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2012 Red Hat, Inc.
  *
diff --git a/drivers/md/dm-bio-prison-v1.h b/drivers/md/dm-bio-prison-v1.h
index cec52ac5e1ae..7f3e581158f0 100644
--- a/drivers/md/dm-bio-prison-v1.h
+++ b/drivers/md/dm-bio-prison-v1.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2011-2017 Red Hat, Inc.
  *
diff --git a/drivers/md/dm-bio-prison-v2.c b/drivers/md/dm-bio-prison-v2.c
index 9dec3b61cf70..09b84f0c1fbf 100644
--- a/drivers/md/dm-bio-prison-v2.c
+++ b/drivers/md/dm-bio-prison-v2.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2012-2017 Red Hat, Inc.
  *
diff --git a/drivers/md/dm-bio-prison-v2.h b/drivers/md/dm-bio-prison-v2.h
index 6e04234268db..3059f3f7656d 100644
--- a/drivers/md/dm-bio-prison-v2.h
+++ b/drivers/md/dm-bio-prison-v2.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2011-2017 Red Hat, Inc.
  *
diff --git a/drivers/md/dm-bio-record.h b/drivers/md/dm-bio-record.h
index 745e3ab4aa0a..6d9016d35a5d 100644
--- a/drivers/md/dm-bio-record.h
+++ b/drivers/md/dm-bio-record.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
  *
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 19caaf684ee3..b16e6b215726 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2009-2011 Red Hat, Inc.
  *
diff --git a/drivers/md/dm-cache-background-tracker.c b/drivers/md/dm-cache-background-tracker.c
index 7887f99b82bd..67d9b9309032 100644
--- a/drivers/md/dm-cache-background-tracker.c
+++ b/drivers/md/dm-cache-background-tracker.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2017 Red Hat. All rights reserved.
  *
diff --git a/drivers/md/dm-cache-background-tracker.h b/drivers/md/dm-cache-background-tracker.h
index b5056e8275c1..a42209c24ec2 100644
--- a/drivers/md/dm-cache-background-tracker.h
+++ b/drivers/md/dm-cache-background-tracker.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2017 Red Hat. All rights reserved.
  *
diff --git a/drivers/md/dm-cache-block-types.h b/drivers/md/dm-cache-block-types.h
index 389c9e8ac785..8d660c329805 100644
--- a/drivers/md/dm-cache-block-types.h
+++ b/drivers/md/dm-cache-block-types.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2012 Red Hat, Inc.
  *
diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 83a5975bcc72..ba8abd5cb5b4 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2012 Red Hat, Inc.
  *
diff --git a/drivers/md/dm-cache-metadata.h b/drivers/md/dm-cache-metadata.h
index 0905f2c1615e..c20d3f29ef12 100644
--- a/drivers/md/dm-cache-metadata.h
+++ b/drivers/md/dm-cache-metadata.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2012 Red Hat, Inc.
  *
diff --git a/drivers/md/dm-cache-policy-internal.h b/drivers/md/dm-cache-policy-internal.h
index 56f0a23f698c..43f0808d09e3 100644
--- a/drivers/md/dm-cache-policy-internal.h
+++ b/drivers/md/dm-cache-policy-internal.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2012 Red Hat. All rights reserved.
  *
diff --git a/drivers/md/dm-cache-policy-smq.c b/drivers/md/dm-cache-policy-smq.c
index a3d281fc14c3..2c8b2ce8b7fe 100644
--- a/drivers/md/dm-cache-policy-smq.c
+++ b/drivers/md/dm-cache-policy-smq.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2015 Red Hat. All rights reserved.
  *
diff --git a/drivers/md/dm-cache-policy.c b/drivers/md/dm-cache-policy.c
index c1a3cee99b44..af425491862b 100644
--- a/drivers/md/dm-cache-policy.c
+++ b/drivers/md/dm-cache-policy.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2012 Red Hat. All rights reserved.
  *
diff --git a/drivers/md/dm-cache-policy.h b/drivers/md/dm-cache-policy.h
index 06eb31af626f..fed3e8d00914 100644
--- a/drivers/md/dm-cache-policy.h
+++ b/drivers/md/dm-cache-policy.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2012 Red Hat. All rights reserved.
  *
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 5e92fac90b67..07790e07cfa7 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2012 Red Hat. All rights reserved.
  *
diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 6c6bd24774f2..37d546ca604d 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Internal header file _only_ for device mapper core
  *
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index b9c41fd42e8a..b8333b966a4d 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2003 Jana Saout <jana@saout.de>
  * Copyright (C) 2004 Clemens Fruhwirth <clemens@endorphin.org>
diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 869afef5654a..cc87a159b0cd 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2005-2007 Red Hat GmbH
  *
diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
index 512cc6cea095..3c4c206675e2 100644
--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2020 Red Hat GmbH
  *
diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index 3997f34cfebc..5619c9fa90d6 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2001-2002 Sistina Software (UK) Limited.
  * Copyright (C) 2006-2008 Red Hat GmbH
diff --git a/drivers/md/dm-exception-store.h b/drivers/md/dm-exception-store.h
index b5f20eba3641..2fec405ec079 100644
--- a/drivers/md/dm-exception-store.h
+++ b/drivers/md/dm-exception-store.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2001-2002 Sistina Software (UK) Limited.
  * Copyright (C) 2008 Red Hat, Inc. All rights reserved.
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 335684a1aeaa..f0b878c90731 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2003 Sistina Software (UK) Limited.
  * Copyright (C) 2004, 2010-2011 Red Hat, Inc. All rights reserved.
diff --git a/drivers/md/dm-ima.h b/drivers/md/dm-ima.h
index b8c3b614670b..e6e9c075dcc9 100644
--- a/drivers/md/dm-ima.h
+++ b/drivers/md/dm-ima.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- *
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
  * Copyright (C) 2021 Microsoft Corporation
  *
  * Author: Tushar Sugandhi <tusharsu@linux.microsoft.com>
diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
index dc4381d68313..de8d8d0049e0 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -1,5 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0
-
 /*
  * dm-init.c
  * Copyright (C) 2017 The Chromium OS Authors <chromium-os-dev@chromium.org>
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index c62c21aadf32..eaf698c09829 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2016-2017 Red Hat, Inc. All rights reserved.
  * Copyright (C) 2016-2017 Milan Broz
diff --git a/drivers/md/dm-io-rewind.c b/drivers/md/dm-io-rewind.c
index 0db53ccb94ba..ce05819cbe8b 100644
--- a/drivers/md/dm-io-rewind.c
+++ b/drivers/md/dm-io-rewind.c
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright 2022 Red Hat, Inc.
  */
diff --git a/drivers/md/dm-io-tracker.h b/drivers/md/dm-io-tracker.h
index bdcc6273ebf0..ed6b543ad6b0 100644
--- a/drivers/md/dm-io-tracker.h
+++ b/drivers/md/dm-io-tracker.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2021 Red Hat, Inc. All rights reserved.
  *
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 783564533459..fc2ea6e29038 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2003 Sistina Software
  * Copyright (C) 2006 Red Hat GmbH
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 0b6ec35f4f2d..16f55dc65382 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2001, 2002 Sistina Software (UK) Limited.
  * Copyright (C) 2004 - 2006 Red Hat, Inc. All rights reserved.
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 4d3bbbea2e9a..837f2a6dd00e 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2002 Sistina Software (UK) Limited.
  * Copyright (C) 2006 Red Hat GmbH
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 3212ef6aa81b..0515a7715a8a 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2001-2003 Sistina Software (UK) Limited.
  *
diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
index 9ab93ebea889..3d5ef22e005f 100644
--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2006-2009 Red Hat, Inc.
  *
diff --git a/drivers/md/dm-log-userspace-transfer.c b/drivers/md/dm-log-userspace-transfer.c
index fdf8ec304f8d..36e803603256 100644
--- a/drivers/md/dm-log-userspace-transfer.c
+++ b/drivers/md/dm-log-userspace-transfer.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2006-2009 Red Hat, Inc.
  *
diff --git a/drivers/md/dm-log-userspace-transfer.h b/drivers/md/dm-log-userspace-transfer.h
index 04ee874f9153..314f36fe3e91 100644
--- a/drivers/md/dm-log-userspace-transfer.h
+++ b/drivers/md/dm-log-userspace-transfer.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2006-2009 Red Hat, Inc.
  *
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 178e13a5b059..ea8a17dfa893 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2014 Facebook. All rights reserved.
  *
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index cf10fa667797..df2e55441648 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2003 Sistina Software
  * Copyright (C) 2004-2008 Red Hat, Inc. All rights reserved.
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 0e325469a252..50adee92ad56 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2003 Sistina Software Limited.
  * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
diff --git a/drivers/md/dm-mpath.h b/drivers/md/dm-mpath.h
index e230f7196259..beb88b7dcb66 100644
--- a/drivers/md/dm-mpath.h
+++ b/drivers/md/dm-mpath.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
  *
diff --git a/drivers/md/dm-path-selector.c b/drivers/md/dm-path-selector.c
index fa0ccc585cb4..5863f286cff4 100644
--- a/drivers/md/dm-path-selector.c
+++ b/drivers/md/dm-path-selector.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2003 Sistina Software.
  * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
diff --git a/drivers/md/dm-path-selector.h b/drivers/md/dm-path-selector.h
index 83cac2b04b66..20a58ce13c60 100644
--- a/drivers/md/dm-path-selector.h
+++ b/drivers/md/dm-path-selector.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2003 Sistina Software.
  * Copyright (C) 2004 Red Hat, Inc. All rights reserved.
diff --git a/drivers/md/dm-ps-queue-length.c b/drivers/md/dm-ps-queue-length.c
index cef70657bbbc..28b1e6cd308f 100644
--- a/drivers/md/dm-ps-queue-length.c
+++ b/drivers/md/dm-ps-queue-length.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2004-2005 IBM Corp.  All Rights Reserved.
  * Copyright (C) 2006-2009 NEC Corporation.
diff --git a/drivers/md/dm-ps-round-robin.c b/drivers/md/dm-ps-round-robin.c
index 27f44c5fa04e..f823fbfac73f 100644
--- a/drivers/md/dm-ps-round-robin.c
+++ b/drivers/md/dm-ps-round-robin.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2003 Sistina Software.
  * Copyright (C) 2004-2005 Red Hat, Inc. All rights reserved.
diff --git a/drivers/md/dm-ps-service-time.c b/drivers/md/dm-ps-service-time.c
index 3ec9c33265c5..e3b6a00cb7ec 100644
--- a/drivers/md/dm-ps-service-time.c
+++ b/drivers/md/dm-ps-service-time.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2007-2009 NEC Corporation.  All Rights Reserved.
  *
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8c66a986d647..09caef1b45d9 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2010-2011 Neil Brown
  * Copyright (C) 2010-2018 Red Hat, Inc. All rights reserved.
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 06a38dc32025..0eebf90c138d 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2003 Sistina Software Limited.
  * Copyright (C) 2005-2008 Red Hat, Inc. All rights reserved.
diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
index 1f760451e6f4..2ac1dd406135 100644
--- a/drivers/md/dm-region-hash.c
+++ b/drivers/md/dm-region-hash.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2003 Sistina Software Limited.
  * Copyright (C) 2004-2008 Red Hat, Inc. All rights reserved.
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index a41209a43506..e4a7d66cb7cd 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2016 Red Hat, Inc. All rights reserved.
  *
diff --git a/drivers/md/dm-rq.h b/drivers/md/dm-rq.h
index 1eea0da641db..429a8a1a34e6 100644
--- a/drivers/md/dm-rq.h
+++ b/drivers/md/dm-rq.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Internal header file for device mapper
  *
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 680cc05ec654..3abcc5565870 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2001-2002 Sistina Software (UK) Limited.
  * Copyright (C) 2006-2008 Red Hat GmbH
diff --git a/drivers/md/dm-snap-transient.c b/drivers/md/dm-snap-transient.c
index 0e0ae4c36b37..147aa7d1264e 100644
--- a/drivers/md/dm-snap-transient.c
+++ b/drivers/md/dm-snap-transient.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2001-2002 Sistina Software (UK) Limited.
  * Copyright (C) 2006-2008 Red Hat GmbH
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index d1c2f84d27e3..99d5cf1130f0 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2001-2002 Sistina Software (UK) Limited.
  *
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index baa085cc67bd..c7721878773b 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2001-2003 Sistina Software (UK) Limited.
  *
diff --git a/drivers/md/dm-switch.c b/drivers/md/dm-switch.c
index 534dc2ca8bb0..497a685137d0 100644
--- a/drivers/md/dm-switch.c
+++ b/drivers/md/dm-switch.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2010-2012 by Dell Inc.  All rights reserved.
  * Copyright (C) 2011-2013 Red Hat, Inc.
diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
index e28c92478536..9e97a5d9e1ec 100644
--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2008 Red Hat, Inc. All rights reserved.
  *
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 24ad42b385c1..c458f03129ca 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2001 Sistina Software (UK) Limited.
  * Copyright (C) 2004-2008 Red Hat, Inc. All rights reserved.
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 8cd5184e62f0..ef11379584b2 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2001 Sistina Software (UK) Limited
  *
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 6bcc4c4786d8..bc43b5919a20 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2011-2012 Red Hat, Inc.
  *
diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
index 4d7a2caf21d9..7126279ea040 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2010-2011 Red Hat, Inc.
  *
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 64cfcf46881d..7da4ce41cb78 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2011-2012 Red Hat UK.
  *
diff --git a/drivers/md/dm-unstripe.c b/drivers/md/dm-unstripe.c
index fdc8921e5c19..021ca2959909 100644
--- a/drivers/md/dm-unstripe.c
+++ b/drivers/md/dm-unstripe.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2017 Intel Corporation.
  *
diff --git a/drivers/md/dm-verity-verify-sig.h b/drivers/md/dm-verity-verify-sig.h
index 3987c7141f79..64c17d1c1753 100644
--- a/drivers/md/dm-verity-verify-sig.h
+++ b/drivers/md/dm-verity-verify-sig.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2019 Microsoft Corporation.
  *
diff --git a/drivers/md/dm-zero.c b/drivers/md/dm-zero.c
index faa1dbffc8b4..44822f9b1671 100644
--- a/drivers/md/dm-zero.c
+++ b/drivers/md/dm-zero.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2003 Jana Saout <jana@saout.de>
  *
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9bdf87fa7052..c4a99bdb956c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2001, 2002 Sistina Software (UK) Limited.
  * Copyright (C) 2004-2008 Red Hat, Inc. All rights reserved.
diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persistent-data/dm-array.c
index 3a963d783a86..38d5bfcc48a9 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2012 Red Hat, Inc.
  *
diff --git a/drivers/md/persistent-data/dm-array.h b/drivers/md/persistent-data/dm-array.h
index d7d2d579c662..ef0e1375773a 100644
--- a/drivers/md/persistent-data/dm-array.h
+++ b/drivers/md/persistent-data/dm-array.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2012 Red Hat, Inc.
  *
diff --git a/drivers/md/persistent-data/dm-bitset.c b/drivers/md/persistent-data/dm-bitset.c
index b7208d82e748..6c71eef8fffe 100644
--- a/drivers/md/persistent-data/dm-bitset.c
+++ b/drivers/md/persistent-data/dm-bitset.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2012 Red Hat, Inc.
  *
diff --git a/drivers/md/persistent-data/dm-bitset.h b/drivers/md/persistent-data/dm-bitset.h
index df888da04ee1..13143c5f4b60 100644
--- a/drivers/md/persistent-data/dm-bitset.h
+++ b/drivers/md/persistent-data/dm-bitset.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2012 Red Hat, Inc.
  *
diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index 11935864f50f..c21b46db04a3 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2011 Red Hat, Inc.
  *
diff --git a/drivers/md/persistent-data/dm-block-manager.h b/drivers/md/persistent-data/dm-block-manager.h
index e728937f376a..9aa79cd1d5b8 100644
--- a/drivers/md/persistent-data/dm-block-manager.h
+++ b/drivers/md/persistent-data/dm-block-manager.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2011 Red Hat, Inc.
  *
diff --git a/drivers/md/persistent-data/dm-btree-internal.h b/drivers/md/persistent-data/dm-btree-internal.h
index 893edb426dba..b77a308bcd36 100644
--- a/drivers/md/persistent-data/dm-btree-internal.h
+++ b/drivers/md/persistent-data/dm-btree-internal.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2011 Red Hat, Inc.
  *
diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
index 4ead31e0d8ce..358e6da623e5 100644
--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2011 Red Hat, Inc.
  *
diff --git a/drivers/md/persistent-data/dm-btree-spine.c b/drivers/md/persistent-data/dm-btree-spine.c
index e653458888a7..f62336caa8b9 100644
--- a/drivers/md/persistent-data/dm-btree-spine.c
+++ b/drivers/md/persistent-data/dm-btree-spine.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2011 Red Hat, Inc.
  *
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index 5ce64e93aae7..b17e12b03b0f 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2011 Red Hat, Inc.
  *
diff --git a/drivers/md/persistent-data/dm-btree.h b/drivers/md/persistent-data/dm-btree.h
index d2ae5aa4d00b..74583403fb8f 100644
--- a/drivers/md/persistent-data/dm-btree.h
+++ b/drivers/md/persistent-data/dm-btree.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2011 Red Hat, Inc.
  *
diff --git a/drivers/md/persistent-data/dm-persistent-data-internal.h b/drivers/md/persistent-data/dm-persistent-data-internal.h
index c49e26fff36c..b2cd998d774c 100644
--- a/drivers/md/persistent-data/dm-persistent-data-internal.h
+++ b/drivers/md/persistent-data/dm-persistent-data-internal.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2011 Red Hat, Inc.
  *
diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index bfbfa750e016..f46bbc65e4c0 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2011 Red Hat, Inc.
  *
diff --git a/drivers/md/persistent-data/dm-space-map-common.h b/drivers/md/persistent-data/dm-space-map-common.h
index 706ceb85d680..e28c12ea4a6c 100644
--- a/drivers/md/persistent-data/dm-space-map-common.h
+++ b/drivers/md/persistent-data/dm-space-map-common.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2011 Red Hat, Inc.
  *
diff --git a/drivers/md/persistent-data/dm-space-map-disk.c b/drivers/md/persistent-data/dm-space-map-disk.c
index d0a8d5e73c28..fccd8a86797c 100644
--- a/drivers/md/persistent-data/dm-space-map-disk.c
+++ b/drivers/md/persistent-data/dm-space-map-disk.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2011 Red Hat, Inc.
  *
diff --git a/drivers/md/persistent-data/dm-space-map-disk.h b/drivers/md/persistent-data/dm-space-map-disk.h
index 447a0a9a2d9f..d6adc2185dba 100644
--- a/drivers/md/persistent-data/dm-space-map-disk.h
+++ b/drivers/md/persistent-data/dm-space-map-disk.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2011 Red Hat, Inc.
  *
diff --git a/drivers/md/persistent-data/dm-space-map-metadata.c b/drivers/md/persistent-data/dm-space-map-metadata.c
index 392ae26134a4..c4ccb72123bf 100644
--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2011 Red Hat, Inc.
  *
diff --git a/drivers/md/persistent-data/dm-space-map-metadata.h b/drivers/md/persistent-data/dm-space-map-metadata.h
index 64df923974d8..8f8a7a97e9e0 100644
--- a/drivers/md/persistent-data/dm-space-map-metadata.h
+++ b/drivers/md/persistent-data/dm-space-map-metadata.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2011 Red Hat, Inc.
  *
diff --git a/drivers/md/persistent-data/dm-space-map.h b/drivers/md/persistent-data/dm-space-map.h
index a015cd11f6e9..c87f99b14ef9 100644
--- a/drivers/md/persistent-data/dm-space-map.h
+++ b/drivers/md/persistent-data/dm-space-map.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2011 Red Hat, Inc.
  *
diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/drivers/md/persistent-data/dm-transaction-manager.c
index 16643fc974e8..5bcfb50baad8 100644
--- a/drivers/md/persistent-data/dm-transaction-manager.c
+++ b/drivers/md/persistent-data/dm-transaction-manager.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2011 Red Hat, Inc.
  *
diff --git a/drivers/md/persistent-data/dm-transaction-manager.h b/drivers/md/persistent-data/dm-transaction-manager.h
index 906c02ed0365..2a1390f59288 100644
--- a/drivers/md/persistent-data/dm-transaction-manager.h
+++ b/drivers/md/persistent-data/dm-transaction-manager.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2011 Red Hat, Inc.
  *
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 2de90525b234..56b2cf2cc6e4 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2001 Sistina Software (UK) Limited.
  * Copyright (C) 2004-2008 Red Hat, Inc. All rights reserved.
diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
index 15d9e15ca830..2cf1a7a24746 100644
--- a/include/linux/dm-bufio.h
+++ b/include/linux/dm-bufio.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2009-2011 Red Hat, Inc.
  *
diff --git a/include/linux/dm-dirty-log.h b/include/linux/dm-dirty-log.h
index 7084503c3405..9c0f62162fab 100644
--- a/include/linux/dm-dirty-log.h
+++ b/include/linux/dm-dirty-log.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2003 Sistina Software
  * Copyright (C) 2004-2008 Red Hat, Inc. All rights reserved.
diff --git a/include/linux/dm-io.h b/include/linux/dm-io.h
index 8e1c4ab5df04..0ab753163ca3 100644
--- a/include/linux/dm-io.h
+++ b/include/linux/dm-io.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2003 Sistina Software
  * Copyright (C) 2004 - 2008 Red Hat, Inc. All rights reserved.
diff --git a/include/linux/dm-kcopyd.h b/include/linux/dm-kcopyd.h
index c1707ee5b540..64e7d7d7da04 100644
--- a/include/linux/dm-kcopyd.h
+++ b/include/linux/dm-kcopyd.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2001 - 2003 Sistina Software
  * Copyright (C) 2004 - 2008 Red Hat, Inc. All rights reserved.
diff --git a/include/linux/dm-region-hash.h b/include/linux/dm-region-hash.h
index 9e2a7a401df5..7feaa3a53f7b 100644
--- a/include/linux/dm-region-hash.h
+++ b/include/linux/dm-region-hash.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2003 Sistina Software Limited.
  * Copyright (C) 2004-2008 Red Hat, Inc. All rights reserved.
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

