Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E877C4332F
	for <dm-devel@archiver.kernel.org>; Tue, 29 Nov 2022 07:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669705512;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=095FBMiDh1hfk6x2gT/C9GUIitwLU5Y0Dl76Jq2I4ds=;
	b=TJpTIF/A9qpqXdrH4dATOOheDD40izp+qGsjuNzmKxIiYKbcQ4Cf80DUMs7rQ7qNH602II
	D3rTh1Z42yAMctQ9kaUfxkIeHI9Bg7l0Kgin/owHQBv5vrjBgHi0cmhCkGS2hrYwXi7cXA
	maiDLWLYO7/gWIEdtuUFpajJ43P2VOw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-TUCxONDuPuOrE95NwikZ6g-1; Tue, 29 Nov 2022 02:05:08 -0500
X-MC-Unique: TUCxONDuPuOrE95NwikZ6g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC7682999B46;
	Tue, 29 Nov 2022 07:05:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 393842166B4F;
	Tue, 29 Nov 2022 07:05:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E8F251946597;
	Tue, 29 Nov 2022 07:05:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C75451946594
 for <dm-devel@listman.corp.redhat.com>; Tue, 29 Nov 2022 07:04:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B1431492B05; Tue, 29 Nov 2022 07:04:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A9C6C492B07
 for <dm-devel@redhat.com>; Tue, 29 Nov 2022 07:04:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 850BF85A5B6
 for <dm-devel@redhat.com>; Tue, 29 Nov 2022 07:04:57 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
 [45.249.212.188]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-1MEBuJngN_i0HbzG83hw9A-1; Tue, 29 Nov 2022 02:04:55 -0500
X-MC-Unique: 1MEBuJngN_i0HbzG83hw9A-1
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NLtc9059YzHwH2;
 Tue, 29 Nov 2022 15:04:09 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (7.193.23.68) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 29 Nov 2022 15:04:28 +0800
Received: from [10.174.178.46] (10.174.178.46) by
 kwepemm600013.china.huawei.com (7.193.23.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 29 Nov 2022 15:04:27 +0800
To: <snitzer@kernel.org>, <Martin.Wilck@suse.com>, <ejt@redhat.com>,
 <jack@suse.cz>, <tytso@mit.edu>, <yi.zhang@huawei.com>
References: <20221111121029.3985561-1-chengzhihao1@huawei.com>
 <20221111121029.3985561-3-chengzhihao1@huawei.com>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <0cc9063d-22da-4602-6839-7207d92cfaa8@huawei.com>
Date: Tue, 29 Nov 2022 15:04:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20221111121029.3985561-3-chengzhihao1@huawei.com>
X-Originating-IP: [10.174.178.46]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 2/3] dm bufio: Split main logic out of
 dm_bufio_client creation/destroy
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

1NogMjAyMi8xMS8xMSAyMDoxMCwgWmhpaGFvIENoZW5nINC0tcA6CkhpIE1pa2UsCkkgZm91bmQg
cGF0Y2ggMS8zIGhhcyBiZWVuIGFwcGxpZWQgdG8gbWFpbmxpbmUsIGFueSB0aG91Z2h0cyBmb3Ig
cGF0Y2ggCjIvMyBhbmQgMy8zPyBUaGFua3MuCgo+IFNwbGl0IG1haW4gbG9naWMgZXhjZXB0cyBz
aHJpbmtlciByZWdpc3Rlci91bnJlZ2lzdGVyIG91dCBvZgo+IGRtX2J1ZmlvX2NsaWVudCBjcmVh
dGlvbi9kZXN0cm95LCB0aGUgZXh0cmFjdGVkIGNvZGUgaXMgd3JhcHBlZAo+IGludG8gbmV3IGhl
bHBlcnMgX19kb19pbml0IGFuZCBfX2RvX2Rlc3Ryb3kuCj4gVGhpcyBjb21taXQgaXMgcHJlcGFy
ZSB0byBzdXBwb3J0IGRtX2J1ZmlvX2NsaWVudCByZXNldHRpbmcuCj4gCj4gU2lnbmVkLW9mZi1i
eTogWmhpaGFvIENoZW5nIDxjaGVuZ3poaWhhbzFAaHVhd2VpLmNvbT4KPiAtLS0KPiAgIGRyaXZl
cnMvbWQvZG0tYnVmaW8uYyAgICB8IDE0NCArKysrKysrKysrKysrKysrKysrKysrKysrKystLS0t
LS0tLS0tLS0KPiAgIGluY2x1ZGUvbGludXgvZG0tYnVmaW8uaCB8ICAgNCArLQo+ICAgMiBmaWxl
cyBjaGFuZ2VkLCAxMDEgaW5zZXJ0aW9ucygrKSwgNDcgZGVsZXRpb25zKC0pCj4gCgotLQpkbS1k
ZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

