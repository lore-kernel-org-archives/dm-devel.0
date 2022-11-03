Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBBB8C4332F
	for <dm-devel@archiver.kernel.org>; Thu,  3 Nov 2022 07:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667462247;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iMLWhTIXAyE/n8j3QIsrK7zfBPfRR0S2OtyNWo/Xkhc=;
	b=PYRPky2ojZf6T8bfihucFUfRoUXXuSv9kWWPGdRixBHVToG3BWCFyB6+aXph4FdaK2mGht
	lWWC5qjuIUooBVJUN8Z0KPNJQgWoERg0lNOcse/mMKFsLOio0MH/GZftAGpzPqphqPMd0p
	eReBnnbnvNhV8Vca3+IRvk71aU3ap0I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-7fUr1NJoNA6gXVs1hZkr_w-1; Thu, 03 Nov 2022 03:57:24 -0400
X-MC-Unique: 7fUr1NJoNA6gXVs1hZkr_w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C3E53C0F68E;
	Thu,  3 Nov 2022 07:57:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3FE8340C2140;
	Thu,  3 Nov 2022 07:57:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2348E1946A6C;
	Thu,  3 Nov 2022 07:57:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D69C51946594
 for <dm-devel@listman.corp.redhat.com>; Thu,  3 Nov 2022 07:35:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B5946492B09; Thu,  3 Nov 2022 07:35:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AE80C492B06
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 07:35:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93C8E801231
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 07:35:37 +0000 (UTC)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com
 [209.85.214.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-214-Kg2PiyQVP1usi2NQPm6g6g-1; Thu, 03 Nov 2022 03:35:35 -0400
X-MC-Unique: Kg2PiyQVP1usi2NQPm6g6g-1
Received: by mail-pl1-f172.google.com with SMTP id y4so1156372plb.2
 for <dm-devel@redhat.com>; Thu, 03 Nov 2022 00:35:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:subject:from:to:user-agent:mime-version
 :date:message-id:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=oTGWQumIwIYgq/ddyb5Xf/lRMZTena1TqxoLY+5s09s=;
 b=ezzT4C/ODBEYecgAIHwjYAxdVfm3hIebRG5OogPWFpVouLt88MGLW3uFgsjht+rauE
 I7E10N5tbqStXwokREDH1bbKCheBLDODSmbB7t9GlxGoEPBI3lgfERNP3zdS1dWovT1F
 0RkS63C1ytd/w8xZ7A18p11ivVy+fFUQvFxODsKwxf5X31RUlTmUtLaS/9RRGMXJYOer
 qQ2QZN4PGjEQpMRss1RDs0QJvruAe6Q9y3sQGxM1lFsXtjvbVCCGfOiNsAhUpaivvuV7
 g8DE3suDVRXFZr8J2mLJWPhR7PftniZrgGvNnPA6uyqK4yrV73h2VB7OcqFWvvmRi6uK
 lCZA==
X-Gm-Message-State: ACrzQf2DpYezYtxhWsnHND0zbS0IBbgCk743lymoqzofsUqoAeqZdp0m
 m+9wpoMdna+pOsc2Yr6iIKExd7TcjzOgZg==
X-Google-Smtp-Source: AMsMyM40KEkv1zx0bnGR5/9puq17gGzpl3fCaoLFg69b2PsxAzIrL2dDQuTU2iJ1NUUmydwJM4Dh+w==
X-Received: by 2002:a17:903:2305:b0:186:ed93:fc3f with SMTP id
 d5-20020a170903230500b00186ed93fc3fmr28996139plh.15.1667460934006; 
 Thu, 03 Nov 2022 00:35:34 -0700 (PDT)
Received: from [10.87.56.20] ([139.177.225.253])
 by smtp.gmail.com with ESMTPSA id
 x13-20020aa78f0d000000b00565c8634e55sm48305pfr.135.2022.11.03.00.35.31
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 03 Nov 2022 00:35:33 -0700 (PDT)
Message-ID: <62cc8b6c-edc6-5ee6-d9fd-d1e0819db36c@bytedance.com>
Date: Thu, 3 Nov 2022 15:35:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
To: dm-devel@redhat.com
From: Zhiyong Ye <yezhiyong@bytedance.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Thu, 03 Nov 2022 07:57:17 +0000
Subject: [dm-devel] Question about how to share dm-thin on multiple hosts
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi all,

I am new to dm-devel. When using dm-thin via lvm, I found it difficult 
to share dm-thin on multiple hosts.

The background is that I want to implement live migration of VMs in the 
lvm + iSCSI environment, in which lvmlockd is used to coordinate access 
to shared storage. There are multiple hosts in the cluster using the 
same iSCSI connection, and the VMs running in this environment use 
thinlv volumes. But if want to live migrate the vm, it will be difficult 
since thinlv which from the same thin pool can only be exclusive active 
on one host.

I'm curious why the dm-thin doesn't support multi-host shared access, 
just like the dm-linear does. If I try to write a new dm-thin target or 
make some modifications based on the existing dm-thin target to support 
this feature, is it technically feasible?

Regards!

Zhiyong Ye

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

