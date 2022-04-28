Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAE5FC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:23:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-sWvYA-4HNSmrvHAaY6m3bQ-1; Fri, 29 Apr 2022 04:23:49 -0400
X-MC-Unique: sWvYA-4HNSmrvHAaY6m3bQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 705143838C89;
	Fri, 29 Apr 2022 08:23:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5EC074010E30;
	Fri, 29 Apr 2022 08:23:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0C4C4194706D;
	Fri, 29 Apr 2022 08:23:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3D9A21947046
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Apr 2022 05:41:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1FE29464516; Thu, 28 Apr 2022 05:41:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B981464511
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 05:41:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0517E811E76
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 05:41:52 +0000 (UTC)
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-kgjO1yQFPkaOgY8pSmof7A-1; Thu, 28 Apr 2022 01:41:10 -0400
X-MC-Unique: kgjO1yQFPkaOgY8pSmof7A-1
Received: from [192.168.0.2] (ip5f5aeb1b.dynamic.kabel-deutschland.de
 [95.90.235.27])
 (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested) (Authenticated sender: pmenzel)
 by mx.molgen.mpg.de (Postfix) with ESMTPSA id 5957C61EA1923;
 Thu, 28 Apr 2022 07:32:45 +0200 (CEST)
Message-ID: <e5aa84ee-69b3-b02a-014d-597a5a03987d@molgen.mpg.de>
Date: Thu, 28 Apr 2022 07:32:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
To: Matthias Kaehlcke <mka@chromium.org>
References: <20220426213110.3572568-1-mka@chromium.org>
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220426213110.3572568-1-mka@chromium.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Fri, 29 Apr 2022 08:23:40 +0000
Subject: Re: [dm-devel] [PATCH v2 0/3] LoadPin: Enable loading from trusted
 dm-verity devices
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
Cc: Douglas Anderson <dianders@chromium.org>, Kees Cook <keescook@chromium.org>,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
 linux-security-module@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
 "Serge E . Hallyn" <serge@hallyn.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

RGVhciBNYXR0aGlhcywKCgpUaGFuayB5b3UgZm9yIHlvdXIgcGF0Y2hlcy4KCkFtIDI2LjA0LjIy
IHVtIDIzOjMxIHNjaHJpZWIgTWF0dGhpYXMgS2FlaGxja2U6Cj4gQXMgb2Ygbm93IExvYWRQaW4g
cmVzdHJpY3RzIGxvYWRpbmcgb2Yga2VybmVsIGZpbGVzIHRvIGEgc2luZ2xlCj4gcGlubmVkIGZp
bGVzeXN0ZW0sIHR5cGljYWxseSB0aGUgcm9vdGZzLiBUaGlzIHdvcmtzIGZvciBtYW55Cgpb4oCm
XQoKQSBzbWFsbCBuaXQsIGlmIHlvdSBzaG91bGQgcmVyb2xsIHRoZSBwYXRjaGVzLCBwbGVhc2Ug
dXNlIDc1IGNoYXJhY3RlcnMgCnBlciBsaW5lIGluIGNvbW1pdCBtZXNzYWdlcy4gKGBzY3JpcHRz
L2NoZWNrcGF0Y2gucGxgIHVzZXMgdGhhdCBudW1iZXIuKQoKCktpbmQgcmVnYXJkcywKClBhdWwK
Ci0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlz
dG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

