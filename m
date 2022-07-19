Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3916CCA47F
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jul 2022 12:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658234034;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lNLrwaJcvtUpgLMRV3dtma33//PogZ1DkzHh81nJEiY=;
	b=XfpMdNSo/s7mstKfrw44GwOGcKIEKIM1lllzznOth+SXI2voNDdii1/9PmedP/y242rbJ+
	3UZjf2HOOvK6n3DfDWnqLimYQNHl484pLdqp0ZBnAl4BCbgOM7z1PficnbizLYc+CKBjOJ
	QKsyaZLYpZKwDzw9FLr2WyM29s5asYo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-OGfpa2OrPnC_MCLukcTclA-1; Tue, 19 Jul 2022 08:33:51 -0400
X-MC-Unique: OGfpa2OrPnC_MCLukcTclA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23044299E757;
	Tue, 19 Jul 2022 12:33:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5DA06492C3B;
	Tue, 19 Jul 2022 12:33:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 194A0196419C;
	Tue, 19 Jul 2022 12:33:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 88AF91945DA7
 for <dm-devel@listman.corp.redhat.com>; Tue, 19 Jul 2022 12:33:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 792542026609; Tue, 19 Jul 2022 12:33:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F8622026987
 for <dm-devel@redhat.com>; Tue, 19 Jul 2022 12:33:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FD441C06EDD
 for <dm-devel@redhat.com>; Tue, 19 Jul 2022 12:33:44 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
 [45.249.212.188]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-dhehYqmBPfCKBJuB7oL7wQ-1; Tue, 19 Jul 2022 08:33:42 -0400
X-MC-Unique: dhehYqmBPfCKBJuB7oL7wQ-1
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.54])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LnHhV2NcHzVg9T;
 Tue, 19 Jul 2022 20:10:02 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Jul 2022 20:13:40 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Jul 2022 20:13:39 +0800
Message-ID: <4a5b490d-6361-a745-9e4c-0fe240c8b93f@huawei.com>
Date: Tue, 19 Jul 2022 20:13:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
 <bmarzins@redhat.com>, <mwilck@suse.com>, <dm-devel@redhat.com>
From: Wu Guanghao <wuguanghao3@huawei.com>
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [Question] multipathd add/remove paths takes a long time
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
Cc: lixiaokeng@huawei.com, liuxing108@huawei.com, zhangying134@huawei.com,
 chenmao2@huawei.com, linfeilong@huawei.com, liuzhiqiang26@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The system has 1K multipath devices, each device has 16 paths.
Execute multipathd add/multipathd remove or uev_add_path/
uev_remove_path to add/remove paths, which takes over 20s.
What's more, the second checkloop may be execed immediately
after finishing first checkloop. It's too long.

We found that time was mostly spent waiting for locks.

checkerloop(){
	...
	lock(&vecs->lock);
	vector_foreach_slot (vecs->pathvec, pp, i) {
		rc = check_path(...); // Too many paths, it takes a long time
		...
	}
	lock_cleanup_pop(vecs->lock);
	...
}

Can the range of vecs->lock locks be adjusted to reduce the time consuming
when adding/removing paths?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

