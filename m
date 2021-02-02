Return-Path: <SRS0=YUkt=HE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C06FC433E0
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 21:28:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ADDAE64F91
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 21:28:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADDAE64F91
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-603-hm8Wku71O0aqjBYINhC-Mg-1; Tue, 02 Feb 2021 16:27:58 -0500
X-MC-Unique: hm8Wku71O0aqjBYINhC-Mg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E7C3804023;
	Tue,  2 Feb 2021 21:27:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 22AEB5D9DE;
	Tue,  2 Feb 2021 21:27:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 317C950039;
	Tue,  2 Feb 2021 21:27:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 112LRmtt015460 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Feb 2021 16:27:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4797B2026D35; Tue,  2 Feb 2021 21:27:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 424B12026D49
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 21:27:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E3B9F800969
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 21:27:45 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-574-L8MhaqylNwi4K1zLNVHr7w-1;
	Tue, 02 Feb 2021 16:27:42 -0500
X-MC-Unique: L8MhaqylNwi4K1zLNVHr7w-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id F3D6DACBA;
	Tue,  2 Feb 2021 21:27:40 +0000 (UTC)
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>, lixiaokeng@huawei.com
Date: Tue,  2 Feb 2021 22:27:26 +0100
Message-Id: <20210202212729.18442-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 112LRmtt015460
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 0/3] consistent behavior of filter_property()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

This is a spring-off of the previous discussion under the subject
"libmultipath: fix NULL dereference in get_be64".

Repeating part of the text of my last post there:

pp->uid_attribute may be set from the hwtable, which
means that vendor/product must be known, which in turn means that
uid_attribute can't be set correctly before sysfs_pathinfo() is run.
Thus, in order to be consistent, we need to move the filter_property()
further down in pathinfo(), after the call to sysfs_pathinfo(). 

However, that has a side effect. As Ben already stated,
pp->uid_attribute currently is *never* set the first time the call
chain pathinfo()->filter_property() is run. After the proposed change,
it would *always* be set in this call chain, possibly leading to more
cases where pathinfo returns PATHINFO_SKIPPED.

This matters e.g. for "multipath -w". When we remove a WWID, we must
be sure get_refwwid() fills in the wwid, which won't happen if
PATHINFO_SKIPPED is returned.

(While looking at this, I discovered that it didn't work in current
upstream either. I guess it has been broken since 0.6.0, or
355291b ("libmultipath: filter for missing property in get_refwwid()"
This lead to the addition of patch 3/3).

In order not to break such use cases, we need to make the
filter_property() test in pathinfo() dependent on DI_BLACKLIST. That
would make a lot of sense, but it'd cause a semantic change.

Comments welcome.

Regards
Martin


Martin Wilck (3):
  pathinfo: call filter_property() after sysfs_pathinfo()
  libmultipath: pathinfo: call filter_property only with DI_BLACKLIST
  multipath -w: allow removing blacklisted paths

 libmultipath/configure.c |  4 +-
 libmultipath/discovery.c | 19 +++++++--
 libmultipath/valid.c     |  4 --
 tests/Makefile           |  2 +-
 tests/test-lib.c         | 18 ++++----
 tests/valid.c            | 91 ++++++++++++++++++++++++++++++++++++----
 6 files changed, 111 insertions(+), 27 deletions(-)

-- 
2.29.2


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

