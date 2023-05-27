Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24ED5C7EE23
	for <dm-devel@archiver.kernel.org>; Mon, 29 May 2023 04:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685335919;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=58er9yHHF8n3+/Sv9/TAr4zFrhGrfRcvhZ0tjAtENWs=;
	b=e0Q/glbmG1XnJd/NfSlIiAacwC8KPdDrreBBMf8CrmQn+yuNLVGEVSRTlf9LloAEjIMdT3
	JduldnX7Ix31pK8+J1KhQGcD4ZTWaS1YjLCXqIUo+Ach6bC0ccwfT1bWc/uuob3HKJRIom
	Tv/q0LtqWhYn5lEqGS1ukDLqNtBY3jo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-WO_cZWWfMLO-BdYVIA4CNw-1; Mon, 29 May 2023 00:51:57 -0400
X-MC-Unique: WO_cZWWfMLO-BdYVIA4CNw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FB3D800B2A;
	Mon, 29 May 2023 04:51:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 09ED740C6CDF;
	Mon, 29 May 2023 04:51:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B537B19465B7;
	Mon, 29 May 2023 04:51:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DF8DC19465A0
 for <dm-devel@listman.corp.redhat.com>; Sat, 27 May 2023 03:13:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BC70A7AE4; Sat, 27 May 2023 03:13:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B47F853BB
 for <dm-devel@redhat.com>; Sat, 27 May 2023 03:13:29 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 98056101A52C
 for <dm-devel@redhat.com>; Sat, 27 May 2023 03:13:29 +0000 (UTC)
Received: from out30-132.freemail.mail.aliyun.com
 (out30-132.freemail.mail.aliyun.com [115.124.30.132]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384)
 id us-mta-607-ykdCUkZwME6uihS71KOvkg-1; Fri, 26 May 2023 23:13:25 -0400
X-MC-Unique: ykdCUkZwME6uihS71KOvkg-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R121e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046051;
 MF=durui@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
 TI=SMTPD_---0VjYXb68_1685157200
Received: from localhost(mailfrom:durui@linux.alibaba.com
 fp:SMTPD_---0VjYXb68_1685157200) by smtp.aliyun-inc.com;
 Sat, 27 May 2023 11:13:20 +0800
From: Du Rui <durui@linux.alibaba.com>
To: hsiangkao@linux.alibaba.com
Date: Sat, 27 May 2023 11:13:19 +0800
Message-Id: <20230527031319.92200-1-durui@linux.alibaba.com>
In-Reply-To: <ac8519fd-85f4-e778-0c6c-b2e893a37628@linux.alibaba.com>
References: <ac8519fd-85f4-e778-0c6c-b2e893a37628@linux.alibaba.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Mon, 29 May 2023 04:51:50 +0000
Subject: Re: [dm-devel] dm overlaybd: targets mapping OverlayBD image
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
Cc: gscrivan@redhat.com, durui@linux.alibaba.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, dm-devel@redhat.com, alexl@redhat.com,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.alibaba.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> Block drivers has nothing to do on filesystem page cache stuffs, also
> currently your approach has nothing to do with pmem stuffs (If you must
> mention "DAX" to proposal your "page cache sharing", please _here_
> write down your detailed design first and explain how it could work to
> ours if you really want to do.)

We have already done experiments (by virtio pmem), to make virtual PMEM
device in QEMU, make guest vm sharing only one memory mapping on host,
with filesystem that supports DAX. In guest vm, fs keeps no page cache,
maybe "sharing pagecache" is not such accurate description, but sharing
memory pages on host can do prevent making duplicated pagecache pages in
VMs.

Please make sure that you have already understood that dm-overlaybd are
for GENERIC purpose. It is NOT a special design for container, and have
nothing related to filesystem implementations.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

