Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A43A7C4167B
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 13:18:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-cqWrSuJSPpeVjs1zzQXBwA-1; Thu, 14 Apr 2022 09:18:27 -0400
X-MC-Unique: cqWrSuJSPpeVjs1zzQXBwA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E29B296A621;
	Thu, 14 Apr 2022 13:18:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1CDBF14583C1;
	Thu, 14 Apr 2022 13:18:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9A7D61940345;
	Thu, 14 Apr 2022 13:18:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 68145194034F
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 13:18:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1053A401E75; Thu, 14 Apr 2022 13:18:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CEB8416148
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 13:18:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8EF338149B0
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 13:18:22 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-3pSvJ3e9OIGEqYyJvBhNww-1; Thu, 14 Apr 2022 09:18:18 -0400
X-MC-Unique: 3pSvJ3e9OIGEqYyJvBhNww-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 7B8DA1F746;
 Thu, 14 Apr 2022 13:18:17 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4D97C132C0;
 Thu, 14 Apr 2022 13:18:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id EdQnERkfWGKcQQAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 14 Apr 2022 13:18:17 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 14 Apr 2022 15:18:04 +0200
Message-Id: <20220414131811.2551-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH 0/7] multipath-tools: remove deprecated options
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============3907742191751218126=="

--===============3907742191751218126==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Martin Wilck <mwilck@suse.com>

As discussed earlier [1], multipath_dir and config_dir are deprecated
and are now removed. They are replaced by compile-time options.
This patch set also removes the long-deprecated getuid_callout option.

Regards
Martin

[1] https://listman.redhat.com/archives/dm-devel/2021-November/048346.html

PS: I haven't yet figured out the reason for the late problems with
my emails on dm-devel. So far I'm just hoping they'll get through this
time.

Martin Wilck (7):
  libmultipath: add declare_deprecated_handler() helper
  multipath-tools: make multipath_dir a compiled-in option
  multipath-tools: make config_dir a compiled-in option
  libmultipath: print error message for pg_timeout
  libmultipath: remove support for long-deprecated options
  multipath-tools: stop supporting getuid_callout
  libmultipath.version: bump version

 Makefile.inc                      |   6 +-
 README.md                         |   6 +
 libmultipath/Makefile             |   2 +-
 libmultipath/callout.c            | 221 ------------------------------
 libmultipath/callout.h            |   7 -
 libmultipath/checkers.c           |  20 +--
 libmultipath/checkers.h           |   4 +-
 libmultipath/config.c             |  31 +----
 libmultipath/config.h             |   5 -
 libmultipath/defaults.h           |   2 -
 libmultipath/dict.c               | 104 ++++----------
 libmultipath/discovery.c          |  22 +--
 libmultipath/foreign.c            |  11 +-
 libmultipath/foreign.h            |   2 +-
 libmultipath/libmultipath.version |   2 +-
 libmultipath/prio.c               |  19 +--
 libmultipath/prio.h               |   6 +-
 libmultipath/propsel.c            |  39 ++----
 libmultipath/structs.c            |   1 -
 libmultipath/structs.h            |   1 -
 multipath/main.c                  |   6 +-
 multipath/multipath.conf.5        |  40 +-----
 multipathd/main.c                 |   6 +-
 multipathd/uxlsnr.c               |  27 +---
 24 files changed, 106 insertions(+), 484 deletions(-)
 delete mode 100644 libmultipath/callout.c
 delete mode 100644 libmultipath/callout.h

--=20
2.35.1


--===============3907742191751218126==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============3907742191751218126==--

