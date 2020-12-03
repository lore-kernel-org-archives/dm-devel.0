Return-Path: <SRS0=D9Ri=FI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93591C433FE
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 09:27:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D7DFF227BF
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 09:27:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7DFF227BF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-C6bUIZqaM2eIAr9EznT8CA-1; Fri, 04 Dec 2020 04:27:47 -0500
X-MC-Unique: C6bUIZqaM2eIAr9EznT8CA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEFB2180A097;
	Fri,  4 Dec 2020 09:27:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A30DD5D6AC;
	Fri,  4 Dec 2020 09:27:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 790621809CA2;
	Fri,  4 Dec 2020 09:27:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3MWakh011152 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 17:32:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 77115101F0BD; Thu,  3 Dec 2020 22:32:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 72CC31020435
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 22:32:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 608C7858284
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 22:32:36 +0000 (UTC)
Received: from mail-pj1-f66.google.com (mail-pj1-f66.google.com
	[209.85.216.66]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-529-FePLMiroMJuMI5qkLIcJXg-1; Thu, 03 Dec 2020 17:32:34 -0500
X-MC-Unique: FePLMiroMJuMI5qkLIcJXg-1
Received: by mail-pj1-f66.google.com with SMTP id v1so1919620pjr.2
	for <dm-devel@redhat.com>; Thu, 03 Dec 2020 14:32:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:cc:from:to;
	bh=kWu6dOTpWM5OEhpvvxAmGbYOm4nAgVI2rftl3/PRnJw=;
	b=uJbziiPumbRumX+sFyeh2ZY10me2MaLeQ0SRhjVnaItC9VkPV8HjLRW3MB4BcXK8vb
	qm/383FZkjggBf1xz8874/mzIbZ9su4WqP96kpuLBZAENhAe8D5rBGgQFQG/tDBgc6mH
	PXLdC1YBuw68FN9qu9qMLOBYVEKvwRe96sO/2sGNM9GP0sozPotsR2mUakZx82uJR7eD
	KLbf/xlqJ4ubiUKVd+hYPXmrXKNZZn6CYQFaj60wVfS05SpWFWLesWUPBXEjB+FksmXv
	XXETvdoHhbhcteq2ZHA+P0vdseOvPL5yBWJ3xK2KAYe9NGw34A68X7L/kvLj8JWkUWYO
	r6xQ==
X-Gm-Message-State: AOAM532Ph3QnJI2xB925D1npRxrKFGTzssSwwAKMlJFjYI7QNKdKfz+D
	Kd+ybQr8FpvIVIemulJfLptflQ==
X-Google-Smtp-Source: ABdhPJyss4HB0tRKuTdlmynwH8EalWY5UH5526iClcnKVeSXxYoDVLrUWDJ1cBtKdu4wdMbvN0OThQ==
X-Received: by 2002:a17:902:758c:b029:da:a6e1:e06 with SMTP id
	j12-20020a170902758cb02900daa6e10e06mr1222353pll.67.1607034752937;
	Thu, 03 Dec 2020 14:32:32 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net.
	[76.210.143.223])
	by smtp.gmail.com with ESMTPSA id g6sm305006pjd.3.2020.12.03.14.32.32
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 03 Dec 2020 14:32:32 -0800 (PST)
Date: Thu,  3 Dec 2020 13:58:59 -0800
Message-Id: <20201203215859.2719888-6-palmer@dabbelt.com>
In-Reply-To: <20201203215859.2719888-1-palmer@dabbelt.com>
References: <20201203215859.2719888-1-palmer@dabbelt.com>
MIME-Version: 1.0
From: Palmer Dabbelt <palmer@dabbelt.com>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 04 Dec 2020 04:27:21 -0500
Cc: corbet@lwn.net, linux-doc@vger.kernel.org, kernel-team@android.com,
	Palmer Dabbelt <palmerdabbelt@google.com>,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	song@kernel.org, linux-kselftest@vger.kernel.org, shuah@kernel.org
Subject: [dm-devel] [PATCH v1 5/5] MAINTAINERS: Add myself as a dm-user
	maintainer
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

RnJvbTogUGFsbWVyIERhYmJlbHQgPHBhbG1lcmRhYmJlbHRAZ29vZ2xlLmNvbT4KCkknbSBub3Qg
c3VyZSB0aGlzIGlzIGJpZyBlbm91Z2ggdG8gd2FycmFudCBhbiBlbnRyeSBpbiB0aGUgTUFJTlRB
SU5FUlMgZmlsZSwKYnV0IEkga25vdyBpdCBjYW4gYmUgcXVpdGUgYSBiaXQgb2Ygd29yayB0byBt
YWludGFpbiBzb21ldGhpbmcgbGlrZSB0aGlzIHNvIEknbQpoYXBweSB0byBzaWduIHVwIGlmIHRo
YXQgaGVscHMuCgpTaWduZWQtb2ZmLWJ5OiBQYWxtZXIgRGFiYmVsdCA8cGFsbWVyZGFiYmVsdEBn
b29nbGUuY29tPgotLS0KIE1BSU5UQUlORVJTIHwgNyArKysrKysrCiAxIGZpbGUgY2hhbmdlZCwg
NyBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvTUFJTlRBSU5FUlMgYi9NQUlOVEFJTkVSUwpp
bmRleCAyZGFhNmVlNjczZjcuLmFiOWQ3NzQ2Y2ZiNCAxMDA2NDQKLS0tIGEvTUFJTlRBSU5FUlMK
KysrIGIvTUFJTlRBSU5FUlMKQEAgLTUxOTgsNiArNTE5OCwxMyBAQCBXOglodHRwOi8vc291cmNl
cy5yZWRoYXQuY29tL2NsdXN0ZXIvCiBUOglnaXQgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L3RlaWdsYW5kL2xpbnV4LWRsbS5naXQKIEY6CWZzL2RsbS8KIAor
RE0gVVNFUiAoQmxvY2sgRGV2aWNlIGluIFVzZXJzcGFjZSkKK006CVBhbG1lciBEYWJiZWx0IDxw
YWxtZXJkYWJiZWx0QGdvb2dsZS5jb20+CitTOglNYWludGFpbmVkCitGOglpbmNsdWRlL2xpbnV4
L2RtLXVzZXIuaAorRjoJZHJpdmVycy9tZC9kbS11c2VyLmMKK0Y6CXRvb2xzL3Rlc3Rpbmcvc2Vs
ZnRlc3RzL2RtLXVzZXIvCisKIERNQSBCVUZGRVIgU0hBUklORyBGUkFNRVdPUksKIE06CVN1bWl0
IFNlbXdhbCA8c3VtaXQuc2Vtd2FsQGxpbmFyby5vcmc+CiBNOglDaHJpc3RpYW4gS8O2bmlnIDxj
aHJpc3RpYW4ua29lbmlnQGFtZC5jb20+Ci0tIAoyLjI5LjIuNDU0LmdhZmYyMGRhM2EyLWdvb2cK
Ci0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

