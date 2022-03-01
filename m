Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B2DEC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  2 Mar 2022 06:26:14 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-MwswpJL6MUmohzXxZvSvMA-1; Wed, 02 Mar 2022 01:26:08 -0500
X-MC-Unique: MwswpJL6MUmohzXxZvSvMA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12429108087A;
	Wed,  2 Mar 2022 06:26:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 10DBE4F848;
	Wed,  2 Mar 2022 06:26:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 31E3B44A59;
	Wed,  2 Mar 2022 06:25:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 221E8IvM024254 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Mar 2022 09:08:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 27C16401E5A; Tue,  1 Mar 2022 14:08:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 24083492C14
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 14:08:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0FEDF802A5A
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 14:08:18 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com
	[45.249.212.255]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-494-cZzHpepkNDKpJf2Lcz6Vog-1; Tue, 01 Mar 2022 09:08:15 -0500
X-MC-Unique: cZzHpepkNDKpJf2Lcz6Vog-1
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.55])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4K7Jr36JBVz1GBw4;
	Tue,  1 Mar 2022 22:03:31 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
	dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.21; Tue, 1 Mar 2022 22:08:10 +0800
Received: from [10.174.176.127] (10.174.176.127) by
	dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.21; Tue, 1 Mar 2022 22:08:10 +0800
To: Mike Snitzer <snitzer@redhat.com>
References: <20220228141354.1091687-1-luomeng12@huawei.com>
	<YhzsJKjj4VK1wK/W@redhat.com>
From: luomeng <luomeng12@huawei.com>
Message-ID: <f73ee01c-49be-a0d3-3646-0afdf166720a@huawei.com>
Date: Tue, 1 Mar 2022 22:07:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
	Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <YhzsJKjj4VK1wK/W@redhat.com>
X-Originating-IP: [10.174.176.127]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
	dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 221E8IvM024254
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 02 Mar 2022 01:25:55 -0500
Cc: yukuai3@huawei.com, dm-devel@redhat.com, ejt@redhat.com, agk@redhat.com
Subject: Re: [dm-devel] Revert "dm space maps: don't reset space map
 allocation cursor when committing"
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

QmVjYXVzZSB0aGluLXBvb2wgaXMgc3RvcmFnZSBvdmVyLWNvbW1pdG1lbnQsIG9uZSBvZiB0aGUg
Zm9sbG93aW5nIApzY2VuYXJpb3MgZXhpc3RzOiBjb25zdGFudGx5IGNyZWF0ZSBhbmQgZGVsZXRl
IGZpbGUsIHRoZW4gdGhlIHNlYXJjaCAKZG9lc24ndCBoaXQgdGhlIGVuZCBvZiB0aGUgbWV0YWRh
dGEgZGV2aWNlLCBidXQgcmFtZGlzayBoaXRzIHRoZSBlbmQgCihub3Qgc3VwcG9ydCBkaXNjYXJk
KS4gU28gdGhlIGN1cnNvciBkb2Vzbid0IHJlc2V0LgoK1NogMjAyMi8yLzI4IDIzOjM3LCBNaWtl
IFNuaXR6ZXIg0LS1wDoKPiBXaGF0IHlvdSdyZSBzYXlpbmcgZG9lc24ndCBtYWtlIGFueSBzZW5z
ZS4gIEVzcGVjaWFsbHkgd2hlbiB5b3UKPiBjb25zaWRlciB0aGlzIGxhc3QgcGFydCBvZiB0aGUg
Y29tbWl0IG1lc3NhZ2U6Cj4gIkZpeCB0aGVzZSBpc3N1ZXMgYnkgbGVhdmluZyB0aGUgY3Vyc29y
IGFsb25lLCBvbmx5IHJlc2V0dGluZyB3aGVuIHRoZQo+ICAgc2VhcmNoIGhpdHMgdGhlIGVuZCBv
ZiB0aGUgbWV0YWRhdGEgZGV2aWNlLiIKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2
ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVs

