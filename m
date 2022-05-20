Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 365CCC433FE
	for <dm-devel@archiver.kernel.org>; Fri, 20 May 2022 14:26:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-kH9HoCTUNnek6YV2_mqjdw-1; Fri, 20 May 2022 10:26:31 -0400
X-MC-Unique: kH9HoCTUNnek6YV2_mqjdw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE8F8804197;
	Fri, 20 May 2022 14:26:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6575F40D2820;
	Fri, 20 May 2022 14:26:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 37FE41947058;
	Fri, 20 May 2022 14:26:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 32122194704C
 for <dm-devel@listman.corp.redhat.com>; Fri, 20 May 2022 14:26:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 20BD9C50943; Fri, 20 May 2022 14:26:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CFCEC50941
 for <dm-devel@redhat.com>; Fri, 20 May 2022 14:26:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05622185A79C
 for <dm-devel@redhat.com>; Fri, 20 May 2022 14:26:26 +0000 (UTC)
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de
 [81.169.146.220]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-LfK9S_A8P1inhFklD7RjcA-1; Fri, 20 May 2022 10:26:23 -0400
X-MC-Unique: LfK9S_A8P1inhFklD7RjcA-1
X-RZG-AUTH: ":PHkGeUmrW+uCZmxs998QJRUX30nOwJd7nOD9sw/xoauycprg5uef7cgCEpy7sPc="
X-RZG-CLASS-ID: mo00
Received: from USER-PC.fritz.box by smtp.strato.de (RZmta 47.42.2 DYNA|AUTH)
 with ESMTPSA id Y03eaey4KEQDQD4
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
 (Client did not present a certificate);
 Fri, 20 May 2022 16:26:13 +0200 (CEST)
From: Thore Sommer <public@thson.de>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com,
 nramas@linux.microsoft.com
Date: Fri, 20 May 2022 16:26:02 +0200
Message-Id: <20220520142605.270625-1-public@thson.de>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH 0/3] dm ima: allow targets to remeasure their
 state
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
Cc: linux-integrity@vger.kernel.org, Thore Sommer <public@thson.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The existing device mapper IMA measurements only measure the table content
on target creation. This is fine for targets that do not change their table
during runtime, but some targets like verity use the table to display state
changes. Those changes are not visible through the existing device mapper
integration.

A new DM event "dm_target_update" is introduced for targets to remeasure
their table entry. This event is intended to be used by targets that change
their table entries to indicate potential security relevant information.
This allows for a more complete Remote Attestation of device mapper
targets.

One example use case is to verify the with verity protected root filesystem
using Remote Attestation via IMA. This was not possible before because the
corruption is only detected during runtime and not when the table is
loaded.

Keylime [1] has experimental support for validating this event, but it has
to be enabled manually.

Changes since RFC patch set [2]:
 - Added suggested changes from Lakshmi
 - rewrote target index calculation and removed unnecessary NULL check
 - rewrote verity integration to be more readable
 - Added more detailed description to the single commit messages


[1] https://keylime.dev/
[2] https://lore.kernel.org/linux-integrity/20220106203436.281629-1-public@thson.de/T/


Thore Sommer (3):
  dm ima: allow targets to remeasure their table entry
  dm verity: add support for IMA target update event
  dm ima: add documentation target update event

 .../admin-guide/device-mapper/dm-ima.rst      | 33 +++++++++
 drivers/md/dm-ima.c                           | 70 +++++++++++++++++++
 drivers/md/dm-ima.h                           |  2 +
 drivers/md/dm-verity-target.c                 | 10 ++-
 4 files changed, 113 insertions(+), 2 deletions(-)

-- 
2.36.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

