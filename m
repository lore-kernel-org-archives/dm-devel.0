Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32B9BC4332F
	for <dm-devel@archiver.kernel.org>; Thu,  3 Nov 2022 07:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667462243;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TzoW5DkMAQaQ8dwNvgEZsXonIRKPbfD6/z/O0UWtjeU=;
	b=KrNFaqD/wd7PelInxYSA9Jmt6sJgFv7x/CEh/fZ3IRWXQiHdV+sQwYvuTzcmZ3VTyJarQt
	fSo3Zi+tpjhp2BG2s5KkXzwz73mC7/+khGZda0jEAj7zbzbXyKpqcCkiM2kYlaxBVnzaAB
	HPFyOZRO6eucY2qnOrPMRcgum9hUCJw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-96-kYPOJ8zFN56Qlc7tAwP0XQ-1; Thu, 03 Nov 2022 03:57:20 -0400
X-MC-Unique: kYPOJ8zFN56Qlc7tAwP0XQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8ADED187505A;
	Thu,  3 Nov 2022 07:57:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 77F881121314;
	Thu,  3 Nov 2022 07:57:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 34BC01947041;
	Thu,  3 Nov 2022 07:57:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0B8341946594
 for <dm-devel@listman.corp.redhat.com>; Thu,  3 Nov 2022 01:03:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 112111415123; Thu,  3 Nov 2022 01:03:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 096D7141511F
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 01:03:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2B78811E67
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 01:03:39 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-ndv1EC_ROoWY3gCrdE2WJQ-1; Wed, 02 Nov 2022 21:03:32 -0400
X-MC-Unique: ndv1EC_ROoWY3gCrdE2WJQ-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4N2ln33rb1z6R4nV;
 Thu,  3 Nov 2022 09:00:55 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP2 (Coremail) with SMTP id Syh0CgBH39NfE2NjNdITBQ--.33068S3;
 Thu, 03 Nov 2022 09:03:28 +0800 (CST)
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
References: <20221102064854.GA8950@lst.de>
 <1dc5c1d0-72b6-5455-0b05-5c755ad69045@huaweicloud.com>
 <20221102141700.GA4442@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <3380eda2-6a38-4593-0071-6ff86dcdcda3@huaweicloud.com>
Date: Thu, 3 Nov 2022 09:03:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20221102141700.GA4442@lst.de>
X-CM-TRANSID: Syh0CgBH39NfE2NjNdITBQ--.33068S3
X-Coremail-Antispam: 1UD129KBjvdXoWrZw1DZFW8Cw1rWF45KrW7Arb_yoWftFcEgr
 Z5u3yDJw1UGa13KF1ftr15Wa9IqFs8Xry8Xr13ZFs5Xa4xX393JFWku348Xa15GrsxArn0
 kryYk3s2vw4SgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
 9fnUUIcSsGvfJTRUUUb48FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
 6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
 A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
 Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
 0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
 jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
 1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CEbIxv
 r21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
 WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
 7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
 1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4U
 MIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUU
 U==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Thu, 03 Nov 2022 07:57:17 +0000
Subject: Re: [dm-devel] [PATCH 8/7] block: don't claim devices that are not
 live in bd_link_disk_holder
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMi8xMS8wMiAyMjoxNywgQ2hyaXN0b3BoIEhlbGx3aWcg5YaZ6YGTOgo+IE9u
IFdlZCwgTm92IDAyLCAyMDIyIGF0IDA4OjE3OjM3UE0gKzA4MDAsIFl1IEt1YWkgd3JvdGU6Cj4+
IEkgdGhpbmsgdGhpcyBpcyBzdGlsbCBub3Qgc2FmZSDwn6SUCj4gCj4gSW5kZWVkIC0gd3Jvbmcg
b3Blbl9tdXRleC4KPiAKPj4gKyAgICAgICAvKgo+PiArICAgICAgICAqIGRlbF9nZW5kaXNrIGRy
b3BzIHRoZSBpbml0aWFsIHJlZmVyZW5jZSB0byBiZF9ob2xkZXJfZGlyLCBzbyB3ZQo+PiBuZWVk
Cj4+ICsgICAgICAgICogdG8ga2VlcCBvdXIgb3duIGhlcmUgdG8gYWxsb3cgZm9yIGNsZWFudXAg
cGFzdCB0aGF0IHBvaW50Lgo+PiArICAgICAgICAqLwo+PiArICAgICAgIG11dGV4X2xvY2soJmJk
ZXYtPmJkX2Rpc2stPm9wZW5fbXV0ZXgpOwo+PiArICAgICAgIGlmICghZGlza19saXZlKGJkZXYt
PmJkX2Rpc2spKSB7Cj4+ICsgICAgICAgICAgICAgICByZXQgPSAtRU5PREVWOwo+PiArICAgICAg
ICAgICAgICAgbXV0ZXhfdW5sb2NrKCZiZGV2LT5iZF9kaXNrLT5vcGVuX211dGV4KTsKPj4gKyAg
ICAgICAgICAgICAgIGdvdG8gb3V0X3VubG9jazsKPj4gKyAgICAgICB9Cj4gCj4gSSB0aGluayB0
aGlzIG5lZWRzIHRvIGJlIGRvbmUgYmVmb3JlIHRha2luZyBkaXNrLT5vcGVuX211dGV4LCBvdGhl
cndpc2UKPiB3ZSBjcmVhdGUgYSBsb2NrIG9yZGVyIGRlcGVuZGVuY3kuICBBbHNvIHRoZSBjb21t
ZW50IHNlZW1zIHRvIG92ZXJmbG93Cj4gdGhlIHVzdWFsIDgwIGNoYXJhY3RlciBsaW1pdCwgYW5k
IGFzIHlvdSBub3RlZCBpbiB0aGUgbmV4dCBtYWlsIHRoaXMKPiBuZWVkcyBtb3JlIHVud2luZGlu
Zy4gIEJ1dCB5ZXMsIG90aGVyd2lzZSB0aGlzIGlzIHRoZSByaWdodCB0aGluZyB0bwo+IGRvLiAg
RG8geW91IHdhbnQgdG8gc2VuZCBhIHJlcGxhY2VtZW50IGZvciB0aGlzIHBhdGNoPwo+IApPZiBj
b3Vyc2UuIEFuZCBJIGp1c3Qgc3BvdHRlZCBhIG5ldyBwcm9ibGVtIGhlcmUsIEknbGwgc2VuZCB0
aGVtCnRvZ2V0aGVyLgoKVGhhbmtzLApLdWFpCj4gLgo+IAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBs
aXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbAo=

