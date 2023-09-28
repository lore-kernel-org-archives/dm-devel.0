Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D375E732E7
	for <dm-devel@archiver.kernel.org>; Thu, 28 Sep 2023 15:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695916629;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=E1Q40B8PS3EVWbEtli95zgoc2K4XmgIldhIYaEDnSA8=;
	b=Rk8v143kGXNovwA+o6erobJTWFk7om3Edx6ZTIT2iXLC4chu2F6WQtF+e0BWhIWcgP+h4l
	O6YdJDNhBhzBolsesc6v3y1brblMXfXwzUEsAE9cxzMjMdl3XJxaQvtdxy64cawattymB0
	iPIQt4yTFOrjFh7KgECwk+8Dt8Pxb60=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-KIRUrabSO6q7L_NlFjMkbg-1; Thu, 28 Sep 2023 11:57:05 -0400
X-MC-Unique: KIRUrabSO6q7L_NlFjMkbg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2CDE85A5BE;
	Thu, 28 Sep 2023 15:56:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 851C210005D2;
	Thu, 28 Sep 2023 15:56:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 118141946588;
	Thu, 28 Sep 2023 15:56:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 55E601946588
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Sep 2023 15:54:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 35C25176E4; Thu, 28 Sep 2023 15:54:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E71A28FE
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 15:54:27 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4715780610B
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 15:54:23 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-9p4klYxfPpCFf-96oU2pyA-1; Thu, 28 Sep 2023 11:54:18 -0400
X-MC-Unique: 9p4klYxfPpCFf-96oU2pyA-1
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
 by dfw.source.kernel.org (Postfix) with ESMTP id E788261BC5;
 Thu, 28 Sep 2023 15:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99021C433C9;
 Thu, 28 Sep 2023 15:54:16 +0000 (UTC)
Received: by mail-lf1-f45.google.com with SMTP id
 2adb3069b0e04-504b84d59cbso2856227e87.3; 
 Thu, 28 Sep 2023 08:54:16 -0700 (PDT)
X-Gm-Message-State: AOJu0YyYQQpyTlz7D+E8+u3ATGEerkRkhdidFcjIupSnL3uH+tBmHsr1
 S22qld6cQwEf3fOwKsjxShWCRCdQ4u3qeE1JwU4=
X-Google-Smtp-Source: AGHT+IEFVO/hg/PaKGBPZ3PqAJvJdpHC85BEs/x41TCJ51mvcCeENmSCWHHD1AbaeO30TlabyaCKiL8f7JBOcLjICYU=
X-Received: by 2002:a19:8c43:0:b0:4fe:1681:9377 with SMTP id
 i3-20020a198c43000000b004fe16819377mr1438879lfj.44.1695916454807; Thu, 28 Sep
 2023 08:54:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
 <20230928061543.1845742-2-yukuai1@huaweicloud.com>
In-Reply-To: <20230928061543.1845742-2-yukuai1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Thu, 28 Sep 2023 08:54:02 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7-Kq_bFpXtDUpiWtmBTFajewv=Uv4_GZR4zcoB9m1dBg@mail.gmail.com>
Message-ID: <CAPhsuW7-Kq_bFpXtDUpiWtmBTFajewv=Uv4_GZR4zcoB9m1dBg@mail.gmail.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH -next v3 01/25] md: use READ_ONCE/WRITE_ONCE
 for 'suspend_lo' and 'suspend_hi'
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, snitzer@kernel.org,
 dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 xni@redhat.com, yukuai3@huawei.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBTZXAgMjcsIDIwMjMgYXQgMTE6MjLigK9QTSBZdSBLdWFpIDx5dWt1YWkxQGh1YXdl
aWNsb3VkLmNvbT4gd3JvdGU6Cj4KPiBGcm9tOiBZdSBLdWFpIDx5dWt1YWkzQGh1YXdlaS5jb20+
Cj4KPiBCZWNhdXNlIHJlYWRpbmcgJ3N1c3BlbmRfbG8nIGFuZCAnc3VzcGVuZF9oaScgZnJvbSBt
ZF9oYW5kbGVfcmVxdWVzdCgpCj4gaXMgbm90IHByb3RlY3RlZCwgdXNlIFJFQURfT05DRS9XUklU
RV9PTkNFIHRvIHByZXZlbnQgcmVhZGluZyBhYm5vcm1hbAo+IHZhbHVlLgoKSSByZXBocmFzZSB0
aGlzIGEgYml0OgoKUHJvdGVjdCAnc3VzcGVuZF9sbycgYW5kICdzdXNwZW5kX2hpJyB3aXRoIFJF
QURfT05DRS9XUklURV9PTkNFIHRvIHByZXZlbnQKcmVhZGluZyBhYm5vcm1hbCB2YWx1ZXMuCgpU
aGFua3MsClNvbmcKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29t
Cmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

