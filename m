Return-Path: <SRS0=pCrV=OO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92DADC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 24 Sep 2021 02:41:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1929B6105A
	for <dm-devel@archiver.kernel.org>; Fri, 24 Sep 2021 02:41:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1929B6105A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-PP-X20iUOxS-2pxgUdCY_w-1; Thu, 23 Sep 2021 22:41:47 -0400
X-MC-Unique: PP-X20iUOxS-2pxgUdCY_w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3724B1023F4F;
	Fri, 24 Sep 2021 02:41:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 51C9C2C9D5;
	Fri, 24 Sep 2021 02:41:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F3480180598A;
	Fri, 24 Sep 2021 02:41:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18O2faj0025333 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 23 Sep 2021 22:41:36 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A654920E48F1; Fri, 24 Sep 2021 02:41:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F17C204FF65
	for <dm-devel@redhat.com>; Fri, 24 Sep 2021 02:41:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DAF2680B719
	for <dm-devel@redhat.com>; Fri, 24 Sep 2021 02:41:30 +0000 (UTC)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
	[209.85.216.49]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-454-nUHB7LVmNzWqlLUjhVbLEw-1; Thu, 23 Sep 2021 22:41:29 -0400
X-MC-Unique: nUHB7LVmNzWqlLUjhVbLEw-1
Received: by mail-pj1-f49.google.com with SMTP id t20so5898457pju.5
	for <dm-devel@redhat.com>; Thu, 23 Sep 2021 19:41:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:references:from:in-reply-to
	:content-transfer-encoding;
	bh=9+p6L8B4O/n8EMzclj/VBULev9+tNp3GWiqPl3IpA6c=;
	b=w2PF+e/ZYDqWps1MBGIbwkcjtWvFxsUpmbtCxw0Tn3cMmXmWRu+O/xDDIqkiS+1jXb
	0o/yiLaMZieBqpCjdgP1NKTBJRr2Md+b6w67PZk30HHANZVrF1JfE2HdKmu+dcH88g45
	sk4OctPEXw5VqSJlSaG5aEzCT1NeTYHLi5TXcKwTabO6VFJvZjEtk1RBShRfrgvw5dZZ
	JwK+U9zIeGN7eNHIcTC3RVYACYJe5hDjnbyF2EWwN+i/iLEQEoMeMaWG0tdCoZZjV9hq
	vBJ/796iAdqzKd9NQNRtW7Y9F3Q9RmD6K1TVrd8zptaX9q/CKzH5eKo366EA5CyqgnAf
	nTig==
X-Gm-Message-State: AOAM532tnaqU9xhVKzQLHmTciJzsoRWa2RUjk14AFiamVGz33yQI9k3n
	M/m9s1jGcNfE6hdKuozt1OP8vi95bL8=
X-Google-Smtp-Source: ABdhPJwROiQFjf7XHKuOTIrgsabWxeUVV5IYIc4IYh154a21o0QN+NFxFO/O/1CvLG4y4I4Cgt8fVw==
X-Received: by 2002:a17:90a:de8b:: with SMTP id
	n11mr9130881pjv.84.1632451287583; 
	Thu, 23 Sep 2021 19:41:27 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:cbba:97c1:e6a:66d5?
	([2601:647:4000:d7:cbba:97c1:e6a:66d5])
	by smtp.gmail.com with ESMTPSA id
	o14sm7195378pfh.84.2021.09.23.19.41.26
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 23 Sep 2021 19:41:27 -0700 (PDT)
Message-ID: <84d981de-0d85-06cb-42f2-c49bf78c3623@acm.org>
Date: Thu, 23 Sep 2021 19:41:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.1.0
To: =?UTF-8?B?5p2O5bmz?= <liping3@lixiang.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
References: <e24c85d63b888d1837ed2a8336eedc906ce08878.ac8516ec.e05e.4d3b.9a64.59e4e334e2f7@feishu.cn>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e24c85d63b888d1837ed2a8336eedc906ce08878.ac8516ec.e05e.4d3b.9a64.59e4e334e2f7@feishu.cn>
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
Subject: Re: [dm-devel] dm-init.c: boot up race with partitions
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gOS8yMi8yMSAxODozMywg5p2O5bmzIHdyb3RlOgo+IEkgZW5jb3VudGVyZWQgdGhlIHNhbWUg
cHJvYmxlbSBhcyB0aGlzIG9uZS4gSXMgdGhlcmUgYSBzb2x1dGlvbj8KSG93IGFib3V0IGEgY3Jl
YXRpbmcgdGhlIHZlcml0eSBkZXZpY2UgZnJvbSBpbnNpZGUgYSB1ZGV2IHJ1bGU/CgpUaGFua3Ms
CgpCYXJ0LgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0
cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

