Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B62ECC77B7C
	for <dm-devel@archiver.kernel.org>; Wed, 24 May 2023 23:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684970482;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fjOBsB6fnDjtawBzYpxxwvTN7DE1IAGtpGYytUQsUNk=;
	b=XEH76xgraTK50wWR2ntPLUBsMUeQLQI/6+eZrWCwuaOqhfDjnGaMgFsMZ636Iwr4vcO426
	4p8XkdnoQQlIhJuMhBQ8eLF5aZivep8or31/Mog+oHmDufoN6uSmspU4pOfqtb1hpEtV35
	YFY94dj/1G0OjBWYNeP/4TT/JsHSCus=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249-oV4F_ie4Ml22Yy86xNucNg-1; Wed, 24 May 2023 19:21:19 -0400
X-MC-Unique: oV4F_ie4Ml22Yy86xNucNg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D4C329AB434;
	Wed, 24 May 2023 23:21:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1E71B40C6EC4;
	Wed, 24 May 2023 23:21:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D33B919465A8;
	Wed, 24 May 2023 23:21:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B895519465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 May 2023 23:21:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9BB02400F17; Wed, 24 May 2023 23:21:15 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E53F492B00;
 Wed, 24 May 2023 23:21:15 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 34ONLD5i028709;
 Wed, 24 May 2023 18:21:13 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 34ONLCQn028708;
 Wed, 24 May 2023 18:21:12 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 24 May 2023 18:21:07 -0500
Message-Id: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH 0/5] priority and pathgroup switching changes
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
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

These are a set of changes that mostly effect how multipathd handles
switching or reordering pathgroups for devices where group_by_prio
isn't set. They are meant to apply on top of my "multipath: Add a
group_by_tgp path grouping policy" patchset.

Benjamin Marzinski (5):
  libmultipath: don't count PRIO_UNDEF paths for pathgroup priority
  multipath-tools tests: add tests to verify PRIO_UDEF changes
  multipathd: refresh all priorities if one has changed
  multipathd: reload map if the path groups are out of order
  multipathd: don't assume mpp->paths will exist in
    need_switch_pathgroup

 libmultipath/libmultipath.version |  5 +++
 libmultipath/switchgroup.c        | 39 +++++++++++++++--
 libmultipath/switchgroup.h        |  1 +
 multipathd/main.c                 | 69 ++++++++++++++++++++-----------
 tests/pgpolicy.c                  | 42 +++++++++++++++++++
 5 files changed, 129 insertions(+), 27 deletions(-)

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

