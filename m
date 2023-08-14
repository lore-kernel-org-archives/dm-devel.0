Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31BB2C04A94
	for <dm-devel@archiver.kernel.org>; Mon, 14 Aug 2023 14:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692023216;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=L7n9GwZjw5+MAn2DsP+nYYyABoZG23kXaWC4LRrbhoE=;
	b=AGNWv4Lq0FObEnVhpv/Po0rvOv5OT7zPe+7Q1ArVjA8i7DILE9A5twVbfbZV9VRrXa+a43
	40+GvIqXmeCcntdc4PqGEBpS/x0k9lPh4pyj4WQvHcyvlVWNxiZhpLHquM8PWxmMuyfvj3
	pTibQ86DW7x8WKQ0yUWc8Re7QOUBUw4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-537-q2rYJVqPNxGRVU7kTyv58w-1; Mon, 14 Aug 2023 10:26:53 -0400
X-MC-Unique: q2rYJVqPNxGRVU7kTyv58w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCEDA8015AB;
	Mon, 14 Aug 2023 14:26:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7DB552166B26;
	Mon, 14 Aug 2023 14:26:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4715A1946587;
	Mon, 14 Aug 2023 14:26:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 660441946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 14 Aug 2023 14:26:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5157D4A9005; Mon, 14 Aug 2023 14:26:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 499074021B9
 for <dm-devel@redhat.com>; Mon, 14 Aug 2023 14:26:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E1F2856DED
 for <dm-devel@redhat.com>; Mon, 14 Aug 2023 14:26:50 +0000 (UTC)
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com
 [209.85.210.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-hWW3ncl4P-W6lYDL78vOvA-1; Mon, 14 Aug 2023 10:26:48 -0400
X-MC-Unique: hWW3ncl4P-W6lYDL78vOvA-1
Received: by mail-pf1-f177.google.com with SMTP id
 d2e1a72fcca58-6877eb31261so2871787b3a.1; 
 Mon, 14 Aug 2023 07:26:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1692023207; x=1692628007;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=lqPfjKBh4fEn5Wj87LjUhKggel2I0g0zW4XnW9s14SU=;
 b=Tv0cAkIleKnHXj/wx0/pRJNzwZUsx3GcXi8Kn8JC0rKau4SbWg7Svl68lLqVCESPt4
 KzVh+MUqaUIKuDk6zzEXlIBw8f8MgGMYpo0T1i6PG//ApRSEwmGSizEHBXRqh+/MCEdE
 MgB0muhbMVSAz607IO/iSBDQcx64c29tT7F9u4/mY9PmDOog8hyKiox3hqMjc4+3D4+w
 Ljytca8ABCiC9zwTk+2lcy9aylqkXyZlnO9fHVF+TEQaVD8J5mTrS7yi/YoRm557V7dh
 V8lzl+eQeiUWm1l5GyT8ICOCAImR5zn/0zrFpj9DF3kk1GnA7vXbtrt2YhqyZnculwIm
 h00g==
X-Gm-Message-State: AOJu0YxQnN/4/nTBHNbsPbFOG70wBr+5BmoX/k5PTZOEofQ7Wyzal2ml
 YDgQSsrxxyIfE9fKBp13CqY=
X-Google-Smtp-Source: AGHT+IHOmH/CPfbHjiPSRAabws5WhG05U7tv659QbNd/xn288gX5HmehFp2dEtU52oDRt4xSfXpfVg==
X-Received: by 2002:a05:6a21:7985:b0:135:2f12:7662 with SMTP id
 bh5-20020a056a21798500b001352f127662mr8501008pzc.33.1692023206792; 
 Mon, 14 Aug 2023 07:26:46 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:e105:59a6:229c:65de?
 ([2620:15c:211:201:e105:59a6:229c:65de])
 by smtp.gmail.com with ESMTPSA id
 x17-20020aa79191000000b006874c47e918sm7977606pfa.124.2023.08.14.07.26.45
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 14 Aug 2023 07:26:46 -0700 (PDT)
Message-ID: <abad92af-d8b2-0488-cc75-01a3f4e8e270@acm.org>
Date: Mon, 14 Aug 2023 07:26:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
To: Nitesh Shetty <nj.shetty@samsung.com>
References: <20230811105300.15889-1-nj.shetty@samsung.com>
 <CGME20230811105648epcas5p3ae8b8f6ed341e2aa253e8b4de8920a4d@epcas5p3.samsung.com>
 <20230811105300.15889-3-nj.shetty@samsung.com>
 <3b1da341-1c7f-e28f-d6aa-cecb83188f34@acm.org>
 <20230814121853.ms4acxwr56etf3ph@green245>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230814121853.ms4acxwr56etf3ph@green245>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v14 02/11] Add infrastructure for copy
 offload in block and request layer.
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
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 martin.petersen@oracle.com, Jonathan Corbet <corbet@lwn.net>,
 gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>,
 linux-doc@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 dm-devel@redhat.com, dlemoal@kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
 mcgrof@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: acm.org
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gOC8xNC8yMyAwNToxOCwgTml0ZXNoIFNoZXR0eSB3cm90ZToKPiBPbiAyMy8wOC8xMSAwMjoy
NVBNLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6Cj4+IE9uIDgvMTEvMjMgMDM6NTIsIE5pdGVzaCBT
aGV0dHkgd3JvdGU6Cj4+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9ibGtfdHlwZXMuaCBi
L2luY2x1ZGUvbGludXgvYmxrX3R5cGVzLmgKPj4+IGluZGV4IDBiYWQ2MmNjYTNkMC4uZGUwYWQ3
YTBkNTcxIDEwMDY0NAo+Pj4gK3N0YXRpYyBpbmxpbmUgYm9vbCBvcF9pc19jb3B5KGJsa19vcGZf
dCBvcCkKPj4+ICt7Cj4+PiArwqDCoMKgIHJldHVybiAoKG9wICYgUkVRX09QX01BU0spID09IFJF
UV9PUF9DT1BZX1NSQyB8fAo+Pj4gK8KgwqDCoMKgwqDCoMKgIChvcCAmIFJFUV9PUF9NQVNLKSA9
PSBSRVFfT1BfQ09QWV9EU1QpOwo+Pj4gK30KPj4+ICsKPj4KPj4gVGhlIGFib3ZlIGZ1bmN0aW9u
IHNob3VsZCBiZSBtb3ZlZCBpbnRvIGluY2x1ZGUvbGludXgvYmxrLW1xLmggYmVsb3cgdGhlCj4+
IGRlZmluaXRpb24gb2YgcmVxX29wKCkgc3VjaCB0aGF0IGl0IGNhbiB1c2UgcmVxX29wKCkgaW5z
dGVhZCBvZiAKPj4gb3Blbi1jb2RpbmcgaXQuCj4+Cj4gV2UgdXNlIHRoaXMgbGF0ZXIgZm9yIGRt
IHBhdGNoZXMocGF0Y2ggOSkgYXMgd2VsbCwgYW5kIHdlIGRvbid0IGhhdmUgCj4gcmVxdWVzdCBh
dAo+IHRoYXQgdGltZS4KCk15IHVuZGVyc3RhbmRpbmcgaXMgdGhhdCBpbmNsdWRlL2xpbnV4L2Js
a190eXBlcy5oIHNob3VsZCBvbmx5IGNvbnRhaW4KZGF0YSB0eXBlcyBhbmQgY29uc3RhbnRzIGFu
ZCBoZW5jZSB0aGF0IGlubGluZSBmdW5jdGlvbnMgbGlrZQpvcF9pc19jb3B5KCkgc2hvdWxkIGJl
IG1vdmVkIGVsc2V3aGVyZS4KCkJhcnQuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2
ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVsCg==

