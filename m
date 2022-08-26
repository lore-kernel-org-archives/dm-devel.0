Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A99EAECAAD7
	for <dm-devel@archiver.kernel.org>; Fri, 26 Aug 2022 16:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661530957;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cZsXm6zYB7s9XXgAtvOOmABpo9V0J9JDTSmPfNnOcfo=;
	b=UwEq8y7XKxHa3AxcZV+zChOIiloB/FrngEIhxrzvPjCR579RDuCudpN0tSvTBB8RtgFzMT
	CE4T3G6LWkzoy2ojM410Nwl99MLv01qXQewXtbT04k0O5ZVbMug/JtldICZZ3WQubsbHwd
	5aAFau0ggaTdELhndtA51k4v1Oz9QWg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-eyKW9ujBP7i1bglcbNukbA-1; Fri, 26 Aug 2022 12:22:34 -0400
X-MC-Unique: eyKW9ujBP7i1bglcbNukbA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40E243801F6A;
	Fri, 26 Aug 2022 16:22:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 804E5403348;
	Fri, 26 Aug 2022 16:22:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5DCF91946A4C;
	Fri, 26 Aug 2022 16:22:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 87D261946A43
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 Aug 2022 16:22:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 79FBC403348; Fri, 26 Aug 2022 16:22:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7656940334C
 for <dm-devel@redhat.com>; Fri, 26 Aug 2022 16:22:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5EE5F280EA39
 for <dm-devel@redhat.com>; Fri, 26 Aug 2022 16:22:28 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-646-nc7_B8mqP8KjHrBODyeN9g-1; Fri,
 26 Aug 2022 12:22:25 -0400
X-MC-Unique: nc7_B8mqP8KjHrBODyeN9g-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 82E041F460;
 Fri, 26 Aug 2022 16:22:24 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 53FC313421;
 Fri, 26 Aug 2022 16:22:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id wXr5EkDzCGPocAAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 26 Aug 2022 16:22:24 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 26 Aug 2022 18:21:58 +0200
Message-Id: <20220826162203.20317-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH v3 0/5] multipath: optimizations for large mptable
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

We observe that multipath operations take a long time if the multipaths
section in multipath.conf contains a lot of alias settings
(10000+ in our case). This hurts in particular in udev rules, when
multipath -u or multipath -U is invoked, but also for command line
invocations like "multipath -ll".

This series provides a few optimizations for this use case. It speeds
up simple multipath operations in the test case by a factor of 20.

Changes v2->v3, after discussion with Benjamin Marzinski:

 01, 02: added msort.c from glibc and adapted to our needs.
         Numbering changes accordingly.
 03, 04: (was 01, 02): remove pointer comparisons from v2 again, this was a
         dumb idea. Use the stable msort algorithm instead.

Changes wrt v1, after suggestions from Benjamin Marzinski:

 01, 02: Use pointer comparisons to achieve stable sorting with qsort
 02:  Fix return without popping the cleanup handler. The way I fixed this
      leaves the possibility that some memory won't be freed if a thread is
      killed while executing vector_convert(). I think this is acceptible;
      avoiding it would complicate the code, with very small benefit.
 02: Remove unnecessary checks and break loop if alias==NULL is encountered.

Martin Wilck (5):
  libmultipath: add msort.c from glibc
  libmultipath: modifications for msort.c
  libmultipath: merge_mptable(): sort table by wwid
  libmultipath: check_alias_settings(): pre-sort mptable by alias
  multipath: optimize program startup for frequent invocations

 libmultipath/Makefile |   2 +-
 libmultipath/alias.c  |  37 +++++-
 libmultipath/config.c |  15 ++-
 libmultipath/msort.c  | 268 ++++++++++++++++++++++++++++++++++++++++++
 libmultipath/msort.h  |   6 +
 libmultipath/vector.c |   9 ++
 libmultipath/vector.h |   1 +
 multipath/main.c      |  33 +++---
 8 files changed, 349 insertions(+), 22 deletions(-)
 create mode 100644 libmultipath/msort.c
 create mode 100644 libmultipath/msort.h

-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

