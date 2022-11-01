Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B428BC4332F
	for <dm-devel@archiver.kernel.org>; Wed,  2 Nov 2022 08:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667378506;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CBHmjtcTCC8CmRBI127l3eDq1L6DKIeT/fcJ+aiHgc8=;
	b=au8ytotC3XYjg1JFzhlyrAyhgq6kedIRYOT3a9nRr9/cAkwsz+MRl1FPAbtulIJUKt3Ht7
	dQ6RbMfI9xVA3DpXn25CWr9ZUSUVTFve0XjmiaQDpHGQAsvy8DviXlw7KwLJp+HTpCI98o
	qkCANiqk7h92shBX0KRMfzOVS+G6qXs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-FJ4SD0xOMbON_A7TAJTUOg-1; Wed, 02 Nov 2022 04:41:43 -0400
X-MC-Unique: FJ4SD0xOMbON_A7TAJTUOg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB9D429324AE;
	Wed,  2 Nov 2022 08:41:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6F22F200D8C0;
	Wed,  2 Nov 2022 08:41:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5178C1946597;
	Wed,  2 Nov 2022 08:41:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 97EB81946594
 for <dm-devel@listman.corp.redhat.com>; Tue,  1 Nov 2022 11:13:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 702FA40C2144; Tue,  1 Nov 2022 11:13:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 68A0040C2140
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 11:13:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E074185A78F
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 11:13:01 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-d9WsYsxSNM2dmsJVRrkckw-1; Tue, 01 Nov 2022 07:12:57 -0400
X-MC-Unique: d9WsYsxSNM2dmsJVRrkckw-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4N1nP90Mhbz6PkHL;
 Tue,  1 Nov 2022 19:10:21 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgA3Recz_2Bjz8IpAg--.4987S3;
 Tue, 01 Nov 2022 19:12:52 +0800 (CST)
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
References: <20221030153120.1045101-1-hch@lst.de>
 <20221030153120.1045101-8-hch@lst.de>
 <fd409996-e5e1-d7af-b31d-87db943eaa25@huaweicloud.com>
 <20221101104927.GA13823@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d3f6ec1d-8141-19d1-ce4c-d42710f4a636@huaweicloud.com>
Date: Tue, 1 Nov 2022 19:12:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20221101104927.GA13823@lst.de>
X-CM-TRANSID: gCh0CgA3Recz_2Bjz8IpAg--.4987S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtryUKF15JrWftF1DCw4rKrg_yoWkKwb_u3
 45uFWxJr4F9w13K3Zrtr13WrZxJF1jv3y8ZFZ3Gan5WrWUX3W7GF4fJwn8Aw4xGw4DG3s0
 yryYk3yDuwsFvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
 9fnUUIcSsGvfJTRUUUb4kFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
 6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
 A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
 6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
 Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
 I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
 4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
 Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
 0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
 0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
 WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8
 JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
 UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Wed, 02 Nov 2022 08:41:39 +0000
Subject: Re: [dm-devel] [PATCH 7/7] block: store the holder kobject in
 bd_holder_disk
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 "yukuai \(C\)" <yukuai3@huawei.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="gbk"; Format="flowed"

SGksCgrU2iAyMDIyLzExLzAxIDE4OjQ5LCBDaHJpc3RvcGggSGVsbHdpZyDQtLXAOgo+IE9uIE1v
biwgT2N0IDMxLCAyMDIyIGF0IDA5OjUyOjA0QU0gKzA4MDAsIFl1IEt1YWkgd3JvdGU6Cj4+PiAg
ICAgIAlJTklUX0xJU1RfSEVBRCgmaG9sZGVyLT5saXN0KTsKPj4+IC0JaG9sZGVyLT5iZGV2ID0g
YmRldjsKPj4+ICAgIAlob2xkZXItPnJlZmNudCA9IDE7Cj4+PiArCWhvbGRlci0+aG9sZGVyX2Rp
ciA9IGtvYmplY3RfZ2V0KGJkZXYtPmJkX2hvbGRlcl9kaXIpOwo+Pgo+PiBJIHdvbmRlciBpcyB0
aGlzIHNhZmUgaGVyZSwgaWYga29iamVjdCByZWZlcmVuY2UgaXMgMCBoZXJlIGFuZAo+PiBiZF9o
b2xkZXJfZGlyIGlzIGFib3V0IHRvIGJlIGZyZWVkLiBIZXJlIGluIGtvYmplY3RfZ2V0LCBrcmVm
X2dldCgpIHdpbGwKPj4gd2FybiBhYm91dCB1YWYsIGFuZCBrb2JqZWN0X2dldCB3aWxsIHJldHVy
biBhIGFkZHJlc3MgdGhhdCBpcyBhYm91dCB0bwo+PiBiZSBmcmVlZC4KPiAKPiBCdXQgaG93IGNv
dWxkIHRoZSByZWZlcmVuY2UgYmUgMCBoZXJlPyAgVGhlIGRyaXZlciB0aGF0IGNhbGxzCj4gYmRf
bGlua19kaXNrX2hvbGRlciBtdXN0IGhhdmUgdGhlIGJsb2NrIGRldmljZSBvcGVuIGFuZCB0aHVz
IGhvbGQgYQo+IHJlZmVyZW5jZSB0byBpdC4KCkxpa2UgSSBzYWlkIGJlZm9yZSwgdGhlIGNhbGxl
ciBvZiBiZF9saW5rX2Rpc2tfaG9sZGVyKCkgZ2V0IGJkZXYgYnkKYmxrZGV2X2dldF9ieV9kZXYo
KSwgd2hpY2ggZG8gbm90IGdyYWIgcmVmZXJlbmNlIG9mIGhvbGRlcl9kaXIsIGFuZApncmFiIGRp
c2sgcmVmZXJlbmNlIGNhbiBvbmx5IHByZXZlbnQgZGlza19yZWxlYXNlKCkgdG8gYmUgY2FsbGVk
LCBub3QKZGVsX2dlbmRpc2soKSB3aGlsZSBob2xkZXJfZGlyIHJlZmVyZW5jZSBpcyBkcm9wcGVk
IGluIGRlbF9nZW5kaXNrKCkKYW5kIGNhbiBiZSBkZWNyZWFzZWQgdG8gMC4KCklmIHlvdSBhZ3Jl
ZSB3aXRoIGFib3ZlIGV4cGxhbmF0aW9uLCBJIHRyaWVkIHRvIGZpeCB0aGlzOgoKMSkgbW92ZSBr
b2JqZWN0X3B1dChiZF9ob2xkZXJfZGlyKSBmcm9tIGRlbF9nZW5kaXNrIHRvIGRpc2tfcmVsZWFz
ZSwKdGhlcmUgc2VlbXMgdG8gYmUgYSBsb3Qgb2Ygb3RoZXIgZGVwZW5kZW5jaWVzLgoKMikgcHJv
dGVjdCBiZF9ob2xkZXJfZGlyIHJlZmVyZW5jZSBieSBvcGVuX211dGV4LgoKVGhhbmtzLApLdWFp
Cj4gCj4gLgo+IAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20K
aHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

