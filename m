Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2201C6FA82
	for <dm-devel@archiver.kernel.org>; Fri, 23 Sep 2022 16:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663950003;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DCi16I+56qTW7F5nbS4eMo4QyDN2n9ia8tI8m0/4eoM=;
	b=MKrFn+qPxtCs0XE5s+u7JnEwkoSEEms4rfuKoa+ZaMbV89PxzHRXhqol0oP+ZKX1cdHqXQ
	59g/7HvYyBFPJpZTqtFCAvdfViBeEKkxCB9LGnbMpTs7LFoLKTt6yPXb6XvfD8smA8A2ZH
	g2U2tUYzt2nTMLGGmfiPOgjzsLALNrg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-380-AkLOWNJUOuCy2Ou1nTNrgw-1; Fri, 23 Sep 2022 12:20:01 -0400
X-MC-Unique: AkLOWNJUOuCy2Ou1nTNrgw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0881F87284B;
	Fri, 23 Sep 2022 16:20:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 75CFB40C2064;
	Fri, 23 Sep 2022 16:19:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3814219465B6;
	Fri, 23 Sep 2022 16:19:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E69DD19465A4
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Sep 2022 16:19:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8C0D5492B05; Fri, 23 Sep 2022 16:19:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 84F34492B04
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 16:19:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 697DB29A9CCC
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 16:19:56 +0000 (UTC)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-590-LzpuY3gVOu2KOw8kvfh83Q-1; Fri, 23 Sep 2022 12:19:52 -0400
X-MC-Unique: LzpuY3gVOu2KOw8kvfh83Q-1
Received: by mail-pj1-f46.google.com with SMTP id
 j6-20020a17090a694600b00200bba67dadso590157pjm.5; 
 Fri, 23 Sep 2022 09:19:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date;
 bh=vnSOT79vZm2Z1X3vBb9NByt6VpxGbBF310FVdgigcRo=;
 b=PZXFxMA0oGzB+dNxUe0tp33N0sSte2CQSMqybjOfnCXuP3jKHmQK7tlNAXejcPirgc
 n0y7fmn8/4jMz86bazXgYMMY7geNlVWnWotirBWY1GXqjpqsA8IUs9C/C5xp8TjtEV0U
 Qcb465cfQWBYlZwMta40Vny6E0G/4YH1Z6Bg9UlLvpQCPeDz7UZBWqc0ZUP0sffP0dl2
 R7EaXaP1WoLZOklNfqEaGMwKFSff7SStyYzdbod1wynTcSCVsZfCpUJuIEEojbBKwiwA
 FAAARBOxIE4pch80DcMQoEG2WlfMo/mVdNI0++LoCQk4kalMPFkeve8NEz1Agr5rRBN/
 KElA==
X-Gm-Message-State: ACrzQf1ytGHMQZOAxGI350mSMWAfO8JffL8XpDd+TN4ApyeQaO/Pm19g
 SQ7VYZs9pIw+sCUGBmZGke0=
X-Google-Smtp-Source: AMsMyM5CMCm0D86HYnpQDo/X7/UqnWT+5BzKuiOzTeV53omgR+X965yxoHmyOZ/dbkOcdr27tB35Ow==
X-Received: by 2002:a17:90a:c782:b0:202:c73e:5488 with SMTP id
 gn2-20020a17090ac78200b00202c73e5488mr21574508pjb.202.1663949991522; 
 Fri, 23 Sep 2022 09:19:51 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:aa13:bc38:2a63:318e?
 ([2620:15c:211:201:aa13:bc38:2a63:318e])
 by smtp.gmail.com with ESMTPSA id
 x18-20020a634852000000b004388f33b80esm5811710pgk.2.2022.09.23.09.19.49
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 23 Sep 2022 09:19:50 -0700 (PDT)
Message-ID: <396ddf4d-5a81-f6dc-b98f-a6cdad553e91@acm.org>
Date: Fri, 23 Sep 2022 09:19:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
To: =?UTF-8?Q?Matias_Bj=c3=b8rling?= <Matias.Bjorling@wdc.com>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Mike Snitzer <snitzer@redhat.com>, Pankaj Raghav <p.raghav@samsung.com>
References: <CGME20220920091120eucas1p2c82c18f552d6298d24547cba2f70b7fc@eucas1p2.samsung.com>
 <20220920091119.115879-1-p.raghav@samsung.com> <YytJhEywBhqcr7MX@redhat.com>
 <7dd9dbc0-b08b-fa47-5452-d448d86ca56b@opensource.wdc.com>
 <8fd1d8b1-9f43-eb03-4a7f-187723d1c483@acm.org>
 <BYAPR04MB4968EB5E341049DFF973B9B1F1519@BYAPR04MB4968.namprd04.prod.outlook.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <BYAPR04MB4968EB5E341049DFF973B9B1F1519@BYAPR04MB4968.namprd04.prod.outlook.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] Please further explain Linux's "zoned storage"
 roadmap [was: Re: [PATCH v14 00/13] support zoned block devices with
 non-power-of-2 zone sizes]
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 "jaegeuk@kernel.org" <jaegeuk@kernel.org>, "hch@lst.de" <hch@lst.de>,
 "agk@redhat.com" <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gOS8yMi8yMiAyMzoyOSwgTWF0aWFzIEJqw7hybGluZyB3cm90ZToKPiBXaXRoIFVGUywgaW4g
dGhlIHByb3Bvc2VkIGNvcHkgSSBoYXZlIChtYXkgYmVlbiBjaGFuZ2VkKSAtIHRoZXJlJ3MKPiB0
aGUgY29uY2VwdCBvZiBnYXAgem9uZXMsIHdoaWNoIGlzIHpvbmVzIHRoYXQgY2Fubm90IGJlIGFj
Y2Vzc2VkIGJ5Cj4gdGhlIGhvc3QuIFRoZSBnYXAgem9uZXMgYXJlIGVzc2VudGlhbGx5ICJMQkEg
ZmlsbGVycyIsIGVuYWJsaW5nIHRoZQo+IG5leHQgd3JpdGVhYmxlIHpvbmUgdG8gc3RhcnQgYXQg
YSBYICogcG93MiBzaXplIG9mZnNldC4gTXkKPiB1bmRlcnN0YW5kaW5nIGlzIHRoYXQgdGhpcyBz
cGVjaWZpYyBhcHByb2FjaCB3YXMgY2hvc2VuIHRvIHNpbXBsaWZ5Cj4gc3RhbmRhcmRpemF0aW9u
IGluIFVGUyBhbmQgYXZvaWQgdXBkYXRpbmcgVDEwJ3MgWkJDIHdpdGggem9uZQo+IGNhcGFjaXR5
IHN1cHBvcnQuCj4gCj4gV2hpbGUgVUZTIHdvdWxkIHRlY2huaWNhbGx5IGV4cG9zZSBub24tcG93
ZXIgb2YgMiB6b25lIHNpemVzLCB0aGV5J3JlCj4gYWxzbywgZHVlIHRvIHRoZSBnYXAgem9uZXMs
IGNvdWxkIGFsc28gYmUgY29uc2lkZXJlZCBwb3dlciBvZiAyIHpvbmVzCj4gaWYgb25lIGNvbnNp
ZGVycyB0aGUgc2VxLiB3cml0ZSB6b25lICsgdGhlIGdhcCB6b25lIGFzIGEgc2luZ2xlCj4gdW5p
dC4KPiAKPiBXaGVuIEkgdGhpbmsgYWJvdXQgaGF2aW5nIFVGUyBzdXBwb3J0IGluIHRoZSBrZXJu
ZWwsIHRoZSBTV1IgYW5kIHRoZQo+IGdhcCB6b25lIGNvdWxkIGJlIHJlcHJlc2VudGVkIGFzIGEg
c2luZ2xlIHVuaXQuIEZvciBleGFtcGxlOgo+IAo+IFVGUyAtIFpvbmUgUmVwb3J0Cj4gICAgWm9u
ZSAwOiBTV1IsIExCQSAwLTExCj4gICAgWm9uZSAxOiBHYXAsIExCQSAxMi0xNQo+ICAgIFpvbmUg
MjogU1dSLCBMQkEgMTYtMjcKPiAgICBab25lIDM6IEdhcCwgTEJBIDI4LTMxCj4gICAgLi4uCj4g
Cj4gS2VybmVsIHJlcHJlc2VudGF0aW9uIC0gWm9uZSBSZXBvcnQgKGFzIHN1cHBvcnRlZCB0b2Rh
eSkKPiAgICBab25lIDA6IFNXUiwgTEJBIDAtMTUsIFpvbmUgQ2FwYWNpdHkgMTIKPiAgICBab25l
IDE6IFNXUiwgTEJBIDE2LTMxLCBab25lIENhcGFjaXR5IDEyCj4gICAgLi4uCj4gCj4gSWYgZG9p
bmcgaXQgdGhpcyB3YXksIGl0IHJlbW92ZXMgdGhlIG5lZWQgZm9yIGZpbGVzeXN0ZW1zLAo+IGRl
dmljZS1tYXBwZXJzLCB1c2VyLXNwYWNlIGFwcGxpY2F0aW9ucyBoYXZpbmcgdG8gdW5kZXJzdGFu
ZCBnYXAKPiB6b25lcywgYW5kIGFsbG93cyBVRlMgdG8gd29yayBvdXQgb2YgdGhlIGJveCB3aXRo
IG5vIGNoYW5nZXMgdG8gdGhlCj4gcmVzdCBvZiB0aGUgem9uZWQgc3RvcmFnZSBlY28tc3lzdGVt
Lgo+IAo+IEhhcyB0aGUgYWJvdmUgcmVwcmVzZW50YXRpb24gYmVlbiBjb25zaWRlcmVkPwoKSGkg
TWF0aWFzLAoKV2hhdCBoYXMgYmVlbiBkZXNjcmliZWQgYWJvdmUgaXMgdGhlIGFwcHJvYWNoIGZy
b20gdGhlIGZpcnN0IHZlcnNpb24gb2YgCnRoZSB6b25lZCBzdG9yYWdlIGZvciBVRlMgKFpVRlMp
IGRyYWZ0IHN0YW5kYXJkLiBTdXBwb3J0IGZvciB0aGlzIAphcHByb2FjaCBpcyBhdmFpbGFibGUg
aW4gdGhlIHVwc3RyZWFtIGtlcm5lbC4gU2VlIGFsc28gIltQQVRDSCB2MiAwLzldIApTdXBwb3J0
IHpvbmVkIGRldmljZXMgd2l0aCBnYXAgem9uZXMiLCAyMDIyLTA0LTIxIAooaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvbGludXgtc2NzaS8yMDIyMDQyMTE4MzAyMy4zNDYyMjkxLTEtYnZhbmFzc2No
ZUBhY20ub3JnLykuCgpTaW5jZSBGMkZTIGV4dGVudHMgbXVzdCBiZSBzcGxpdCBhdCBnYXAgem9u
ZXMsIGdhcCB6b25lcyBuZWdhdGl2ZWx5IAphZmZlY3Qgc2VxdWVudGlhbCByZWFkIGFuZCB3cml0
ZSBwZXJmb3JtYW5jZS4gU28gd2UgYWJhbmRvbmVkIHRoZSBnYXAgCnpvbmUgYXBwcm9hY2guIFRo
ZSBjdXJyZW50IGFwcHJvYWNoIGlzIGFzIGZvbGxvd3M6CiogVGhlIHBvd2VyLW9mLXR3byByZXN0
cmljdGlvbiBmb3IgdGhlIG9mZnNldCBiZXR3ZWVuIHpvbmUgc3RhcnRzIGhhcyAKYmVlbiByZW1v
dmVkLiBHYXAgem9uZXMgYXJlIG5vIGxvbmdlciByZXF1aXJlZC4gSGVuY2UsIHdlIHdpbGwgbmVl
ZCB0aGUgCnBhdGNoZXMgdGhhdCBhZGQgc3VwcG9ydCBmb3Igem9uZSBzaXplcyB0aGF0IGFyZSBu
b3QgYSBwb3dlciBvZiB0d28uCiogVGhlIFNlcXVlbnRpYWwgV3JpdGUgUmVxdWlyZWQgKFNXUikg
YW5kIFNlcXVlbnRpYWwgV3JpdGUgUHJlZmVycmVkIAooU1dQKSB6b25lIHR5cGVzIGFyZSBzdXBw
b3J0ZWQuIFRoZSBmZWVkYmFjayB3ZSByZWNlaXZlZCBmcm9tIFVGUyAKdmVuZG9ycyBpcyB0aGF0
IHdoaWNoIHpvbmUgdHlwZSB3b3JrcyBiZXN0IGRlcGVuZHMgb24gdGhlaXIgZmlybXdhcmUgYW5k
IApBU0lDIGRlc2lnbi4KKiBXZSBuZWVkIGEgcXVldWUgZGVwdGggbGFyZ2VyIHRoYW4gb25lIChR
RCA+IDEpIGZvciB3cml0ZXMgdG8gYWNoaWV2ZSAKdGhlIGZ1bGwgc2VxdWVudGlhbCB3cml0ZSBi
YW5kd2lkdGguIFdlIHBsYW4gdG8gc3VwcG9ydCBRRCA+IDEgYXMgZm9sbG93czoKICAgLSBJZiB3
cml0ZXMgaGF2ZSB0byBiZSBzZXJpYWxpemVkLCBzdWJtaXQgdGhlc2UgdG8gdGhlIHNhbWUgaGFy
ZHdhcmUKICAgICBxdWV1ZS4gQWNjb3JkaW5nIHRvIHRoZSBVRlMgaG9zdCBjb250cm9sbGVyIGlu
dGVyZmFjZSAoVUZTSENJKQogICAgIHN0YW5kYXJkLCBVRlMgaG9zdCBjb250cm9sbGVycyBhcmUg
bm90IGFsbG93ZWQgdG8gcmVvcmRlciBTQ1NJCiAgICAgY29tbWFuZHMgdGhhdCBhcmUgc3VibWl0
dGVkIHRvIHRoZSBzYW1lIGhhcmR3YXJlIHF1ZXVlLiBBIHNvdXJjZSBvZgogICAgIGNvbW1hbmQg
cmVvcmRlcmluZyB0aGF0IHJlbWFpbnMgaXMgdGhlIFNDU0kgcmV0cnkgbWVjaGFuaXNtLiBSZXRy
aWVzCiAgICAgaGFwcGVuIGUuZy4gYWZ0ZXIgYSBjb21tYW5kIHRpbWVvdXQuCiAgIC0gRm9yIFNX
UCB6b25lcywgcmVxdWlyZSB0aGUgVUZTIGRldmljZSBmaXJtd2FyZSB0byB1c2UgaXRzIGdhcmJh
Z2UKICAgICBjb2xsZWN0aW9uIG1lY2hhbmlzbSB0byByZW9yZGVyIGRhdGEgaW4gdGhlIHVubGlr
ZWx5IGNhc2UgdGhhdAogICAgIG91dC1vZi1vcmRlciB3cml0ZXMgaGFwcGVuZWQuCiAgIC0gRm9y
IFNXUiB6b25lcywgcmV0cnkgd3JpdGVzIHRoYXQgZmFpbGVkIGJlY2F1c2UgdGhlc2Ugd2VyZSBy
ZWNlaXZlZAogICAgIG91dC1vZi1vcmRlciBieSBhIFVGUyBkZXZpY2UuIFpCQy0xIHJlcXVpcmVz
IGNvbXBsaWFudCBkZXZpY2VzIHRvCiAgICAgcmVzcG9uZCB3aXRoIElMTEVHQUwgUkVRVUVTVCAv
IFVOQUxJR05FRCBXUklURSBDT01NQU5EIHRvIG91dC1vZi0KICAgICBvcmRlciB3cml0ZXMuCgpX
ZSBoYXZlIGNvbnNpZGVyZWQgdGhlIHpvbmUgYXBwZW5kIGFwcHJvYWNoIGJ1dCBkZWNpZGVkIG5v
dCB0byB1c2UgaXQgCmJlY2F1c2UgaWYgem9uZSBhcHBlbmQgY29tbWFuZHMgZ2V0IHJlb3JkZXJl
ZCB0aGUgZGF0YSBlbmRzIHVwIApwZXJtYW5lbnRseSBvdXQtb2Ytb3JkZXIgb24gdGhlIHN0b3Jh
Z2UgbWVkaXVtLiBUaGlzIGFmZmVjdHMgc2VxdWVudGlhbCAKcmVhZCBwZXJmb3JtYW5jZSBuZWdh
dGl2ZWx5LgoKQmFydC4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQu
Y29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

