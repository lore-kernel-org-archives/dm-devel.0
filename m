Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35FDEEB64D7
	for <dm-devel@archiver.kernel.org>; Wed, 14 Jun 2023 02:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686708300;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=K+czNiOz+iQq6UUPb74m5ie+i+fPnu/XXPrEBl1lHd8=;
	b=PCltnlyg/l2E1ni3m3Gk5MT4sJMTh120Q1PRSBqT44o5Ymwz+PEdSSoeV3ziE3U4jXvj9a
	Xx5tOL4/DZAB3q4B6AGzbkSas80RVUyDufxRAte3AHl8oEkPsz10gDlahIDXLoX18fk5e+
	x7+RDYwyRmGVie6Kg0rWXAD+Ev2C9pk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-Rt6qN75hO025Yd-F6AgIlQ-1; Tue, 13 Jun 2023 22:04:56 -0400
X-MC-Unique: Rt6qN75hO025Yd-F6AgIlQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6268299E769;
	Wed, 14 Jun 2023 02:04:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 40023492C1B;
	Wed, 14 Jun 2023 02:04:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1417419452C2;
	Wed, 14 Jun 2023 02:04:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 778CA194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Jun 2023 02:04:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3A2A82166B25; Wed, 14 Jun 2023 02:04:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 31A362166B26
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 02:04:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9BD2299E76A
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 02:04:43 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-AOw6TakQO7SBNUc4d6JIYw-1; Tue, 13 Jun 2023 22:04:40 -0400
X-MC-Unique: AOw6TakQO7SBNUc4d6JIYw-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QgpdZ5FqNz4f3mWR;
 Wed, 14 Jun 2023 10:04:34 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgAHoZQxIIlkJhyeLg--.20675S3;
 Wed, 14 Jun 2023 10:04:35 +0800 (CST)
To: Yu Kuai <yukuai1@huaweicloud.com>, Xiao Ni <xni@redhat.com>,
 guoqing.jiang@linux.dev, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com, song@kernel.org
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-5-yukuai1@huaweicloud.com>
 <05aa3b09-7bb9-a65a-6231-4707b4b078a0@redhat.com>
 <74b404c4-4fdb-6eb3-93f1-0e640793bba6@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6e738d9b-6e92-20b7-f9d9-e1cf71d26d73@huaweicloud.com>
Date: Wed, 14 Jun 2023 10:04:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <74b404c4-4fdb-6eb3-93f1-0e640793bba6@huaweicloud.com>
X-CM-TRANSID: gCh0CgAHoZQxIIlkJhyeLg--.20675S3
X-Coremail-Antispam: 1UD129KBjvdXoW7JFy7GrWkJr1UWFyUWw47XFb_yoWxCrc_ua
 nrC34DGr18WanIqFyvkrn5Zrs7XryfCryUZa4UXF1UtrW0gFyDZF1xuw15Zw15Xw48Gw4I
 grZ0krWUua10gjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
 9fnUUIcSsGvfJTRUUUba8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
 6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
 A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
 6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
 Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
 I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
 4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
 c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
 AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
 17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
 IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3
 Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
 sGvfC2KfnxnUUI43ZEXa7VU1a9aPUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH -next v2 4/6] md: refactor
 idle/frozen_sync_thread() to fix deadlock
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
Cc: linux-raid@vger.kernel.org, "yukuai \(C\)" <yukuai3@huawei.com>,
 yangerkun@huawei.com, linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMy8wNi8xNCA5OjQ4LCBZdSBLdWFpIOWGmemBkzoKCgo+Pgo+PiBJbiB0aGUg
cGF0Y2gsIHN5bmNfc2VxIGlzIGFkZGVkIGluIG1kX3JlYXBfc3luY190aHJlYWQuIEluIAo+PiBp
ZGxlX3N5bmNfdGhyZWFkLCBpZiBzeW5jX3NlcSBpc24ndCBlcXVhbAo+Pgo+PiBtZGRldi0+c3lu
Y19zZXEsIGl0IHNob3VsZCBtZWFuIHRoZXJlIGlzIHNvbWVvbmUgdGhhdCBzdG9wcyB0aGUgc3lu
YyAKPj4gdGhyZWFkIGFscmVhZHksIHJpZ2h0PyBXaHkgZG8KPj4KPj4geW91IHNheSAnbmV3IHN0
YXJ0ZWQgc3luYyB0aHJlYWQnIGhlcmU/CgpJZiBzb21lb25lIHN0b3BzIHRoZSBzeW5jIHRocmVh
ZCwgYW5kIG5ldyBzeW5jIHRocmVhZCBpcyBub3Qgc3RhcnRlZCwKdGhlbiB0aGlzIHN5bmNfc2Vx
IHdvbid0IG1ha2UgYSBkaWZmZXJlbmNlLCBhYm92ZSB3YWl0X2V2ZW50KCkgd2lsbCBub3QKd2Fp
dCBiZWNhdXNlICF0ZXN0X2JpdChNRF9SRUNPVkVSWV9SVU5OSU5HLCAmbWRkZXYtPnJlY292ZXJ5
KSB3aWxsIHBhc3MuClNvICdzeW5jX3NlcScgaXMgb25seSB1c2VkIHdoZW4gdGhlIG9sZCBzeW5j
IHRocmVhZCBzdG9wcyBhbmQgbmV3IHN5bmMKdGhyZWFkIHN0YXJ0cywgYWRkICdzeW5jX3NlcScg
d2lsbCBieXBhc3MgdGhpcyBjYXNlLgoKVGhhbmtzLApLdWFpCgotLQpkbS1kZXZlbCBtYWlsaW5n
IGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWls
bWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

