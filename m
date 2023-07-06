Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 674C7EB64DA
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971644;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Wi76sZocDO/BdQ6ZBMdUWMER8ndjEFyYchCNUwzNmRg=;
	b=dyLQtLHFItZYFnbdN7HqdW5uhrscAZ0XXaqT9hlYd9ao3CqGElROIsLv17w3Mp/RVdoC2z
	eKcBf1Q7aLBTqlx2l54ZK2MdXWKAM+TiSB/wDoRCsteWtRJ0jR/e2ln7p9xJOaz4EinceJ
	e1yJK7JmM5zeyIf3MAs/Mxsaa8UCmmQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-e5DNn_PQP_exJV-C9yC3Mg-1; Mon, 10 Jul 2023 02:47:19 -0400
X-MC-Unique: e5DNn_PQP_exJV-C9yC3Mg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92CCF8019DC;
	Mon, 10 Jul 2023 06:47:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5A0E0C478DE;
	Mon, 10 Jul 2023 06:47:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CFF0519465B5;
	Mon, 10 Jul 2023 06:47:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 453411946589
 for <dm-devel@listman.corp.redhat.com>; Thu,  6 Jul 2023 13:11:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 45A40F6434; Thu,  6 Jul 2023 13:11:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E5D3F5CFB
 for <dm-devel@redhat.com>; Thu,  6 Jul 2023 13:11:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 236BA873238
 for <dm-devel@redhat.com>; Thu,  6 Jul 2023 13:11:26 +0000 (UTC)
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-54-HFgbDOq_OzGavH4-84V0ng-1; Thu,
 06 Jul 2023 09:11:24 -0400
X-MC-Unique: HFgbDOq_OzGavH4-84V0ng-1
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
 (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested) (Authenticated sender: pmenzel)
 by mx.molgen.mpg.de (Postfix) with ESMTPSA id 5C3AD61E5FE01;
 Thu,  6 Jul 2023 15:01:05 +0200 (CEST)
Message-ID: <37c7a3f7-f769-a313-3279-e8e415369ba4@molgen.mpg.de>
Date: Thu, 6 Jul 2023 15:01:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
To: Yu Kuai <yukuai1@huaweicloud.com>
References: <20230706071622.563073-1-yukuai1@huaweicloud.com>
 <20230706071622.563073-3-yukuai1@huaweicloud.com>
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230706071622.563073-3-yukuai1@huaweicloud.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: Re: [dm-devel] [PATCH -next 2/3] md/dm-raid: cleanup multiple
 equivalent goto tags from raid_ctr()
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
Cc: yi.zhang@huawei.com, heinzm@redhat.com, yangerkun@huawei.com,
 snitzer@kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 song@kernel.org, dm-devel@redhat.com, yukuai3@huawei.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: molgen.mpg.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

RGVhciBZdSwKCgpUaGFuayB5b3UgZm9yIHlvdXIgcGF0Y2guIFNvbWUgbWlub3Igbml0cywgaWYg
eW91IGFyZSBpbnRlcmVzdGVkLgoKQW0gMDYuMDcuMjMgdW0gMDk6MTYgc2NocmllYiBZdSBLdWFp
Ogo+IEZyb206IFl1IEt1YWkgPHl1a3VhaTNAaHVhd2VpLmNvbT4KPiAKPiBUaGVyZSBhcmUgZm91
ciBlcXVpdmFsZW50IGdvdG8gdGFncyBpbiByYWlkX2N0cigpLCBjbGVhbiB0aGVtIHVwIHRvIHVz
ZQo+IGp1c3Qgb25lLCB0aGVyZSBhcmUgbm8gZnVuY3Rpb25hbCBjaGFuZ2UgYW5kIHByZXBhcmUg
dG8gZml4IHRoYXQKCk1heWJlOgoKVGhlcmUgKmlzKiBubyBmdW5jdGlvbmFsIGNoYW5nZSwgYW5k
IGlzIGEgcHJlcGFyYXRpb24gdG8gZml4IGFuIAp1bnByb3RlY3RlZCBgbWRfc3RvcCgpYC4KCj4g
bWRfc3RvcCgpIGlzIG5vdCBwcm90ZWN0ZWQuCgpJbiB0aGUgY29tbWl0IG1lc3NhZ2Ugc3VtbWFy
eS90aXRsZSwgSeKAmWQgc3BlbGwgdGhlIHZlcmIgd2l0aCBhIHNwYWNlOgoKICAgICBDbGVhbiB1
cCBmb3VyIGVxdWl2YWxlbnQgZ290byB0YWdzIGluIHJhaWRfY3RyKCkKCj4gU2lnbmVkLW9mZi1i
eTogWXUgS3VhaSA8eXVrdWFpM0BodWF3ZWkuY29tPgo+IC0tLQo+ICAgZHJpdmVycy9tZC9kbS1y
YWlkLmMgfCAyNyArKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0KPiAgIDEgZmlsZSBjaGFuZ2Vk
LCA5IGluc2VydGlvbnMoKyksIDE4IGRlbGV0aW9ucygtKQoKW+KApl0KCgpLaW5kIHJlZ2FyZHMs
CgpQYXVsCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

