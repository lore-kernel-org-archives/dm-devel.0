Return-Path: <SRS0=rSqa=QD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C1CC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 16 Nov 2021 14:15:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 976FE61C15
	for <dm-devel@archiver.kernel.org>; Tue, 16 Nov 2021 14:15:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 976FE61C15
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-7satU1l-ONGqmaCC423lXw-1; Tue, 16 Nov 2021 09:15:13 -0500
X-MC-Unique: 7satU1l-ONGqmaCC423lXw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 468C1802C91;
	Tue, 16 Nov 2021 14:15:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 083D260C81;
	Tue, 16 Nov 2021 14:15:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B3CDA1832DD2;
	Tue, 16 Nov 2021 14:15:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AGEF6To005105 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 16 Nov 2021 09:15:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4A61A2166B2D; Tue, 16 Nov 2021 14:15:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 452392166B26
	for <dm-devel@redhat.com>; Tue, 16 Nov 2021 14:15:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E01D181E066
	for <dm-devel@redhat.com>; Tue, 16 Nov 2021 14:15:03 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com
	[45.249.212.255]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-36-TR9ygYrqN6Oz67_tsFzqSA-1; Tue, 16 Nov 2021 09:15:01 -0500
X-MC-Unique: TR9ygYrqN6Oz67_tsFzqSA-1
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Htnf42KySz1DJVW;
	Tue, 16 Nov 2021 21:56:12 +0800 (CST)
Received: from kwepemm600010.china.huawei.com (7.193.23.86) by
	dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Tue, 16 Nov 2021 21:58:34 +0800
Received: from [10.174.179.176] (10.174.179.176) by
	kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.15; Tue, 16 Nov 2021 21:58:33 +0800
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Martin Wilck
	<mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, "dm-devel
	mailing list" <dm-devel@redhat.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <78637f61-851d-cf9d-d308-9c22396d2071@huawei.com>
Date: Tue, 16 Nov 2021 21:58:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
X-Originating-IP: [10.174.179.176]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
	kwepemm600010.china.huawei.com (7.193.23.86)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: [dm-devel] =?utf-8?q?=5BPATCH_0/5=5D_multipath-tools_series?=
 =?utf-8?q?=EF=BC=9A_some_codeclean_and_add_prflag_to_path?=
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

lixiaokeng (5):
  Fix potential null pointer dereference
  remove unnecessary memset
  remove unnecessary free
  Match FREE and MALLOC/STRDUP/REALLOC
  add prflag to path

 kpartx/dasd.c                            |  5 +++--
 kpartx/kpartx.c                          |  7 ++++---
 libmpathpersist/mpath_persist.c          |  2 +-
 libmultipath/blacklist.c                 |  6 +++---
 libmultipath/checkers/emc_clariion.c     |  2 +-
 libmultipath/config.c                    |  4 ++--
 libmultipath/configure.c                 |  4 ++--
 libmultipath/discovery.c                 |  8 +++++---
 libmultipath/dmparser.c                  |  2 +-
 libmultipath/foreign/nvme.c              |  4 +++-
 libmultipath/log.c                       |  1 -
 libmultipath/parser.c                    |  2 +-
 libmultipath/prioritizers/weightedpath.c |  3 +--
 libmultipath/structs.c                   |  3 ++-
 libmultipath/structs.h                   | 12 ++++++++++++
 libmultipath/util.c                      | 10 +++++++++-
 multipathd/cli_handlers.c                | 15 ++++++++++-----
 multipathd/main.c                        |  9 ++++++---
 multipathd/waiter.c                      |  1 -
 19 files changed, 66 insertions(+), 34 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

