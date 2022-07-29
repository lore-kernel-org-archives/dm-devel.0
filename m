Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39714C00144
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jul 2022 06:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659075131;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sm2rUFOczNDUuYKqZgnink1M4Io2aymHkUXjvKgMhtk=;
	b=UB2ivj6RSWI2G28FAsEXb2UsYINvQmTzNUyxrjXAg9zvCGJ821vUuTHAaU313hBjsOQv8/
	S6zsrRJgkrjNLdZ94ByhlmPj1htsLn4wDDX1hTDw7KnsymPuvXQV26ePuYnXaYlK5xsKUu
	xW6v1EFPAfIN/LvjwRqSGb6g4jznpOM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-bOYHn40MPfWEGUmWZs355g-1; Fri, 29 Jul 2022 02:12:08 -0400
X-MC-Unique: bOYHn40MPfWEGUmWZs355g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5232B3C1014D;
	Fri, 29 Jul 2022 06:12:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4098790A11;
	Fri, 29 Jul 2022 06:12:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0E932193211B;
	Fri, 29 Jul 2022 06:12:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 287F41932121
 for <dm-devel@listman.corp.redhat.com>; Fri, 29 Jul 2022 06:12:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1D335C28125; Fri, 29 Jul 2022 06:12:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1944FC28100
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 06:12:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87F6029AA3AD
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 06:12:04 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-NLjSEKrHPnW5qs3VZLLAUQ-1; Fri, 29 Jul 2022 02:12:00 -0400
X-MC-Unique: NLjSEKrHPnW5qs3VZLLAUQ-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4LvHFR1F8fzl6y1;
 Fri, 29 Jul 2022 14:10:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
 by APP3 (Coremail) with SMTP id _Ch0CgCnCWkneuNiP6ZGBQ--.22656S4;
 Fri, 29 Jul 2022 14:11:53 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: stable@vger.kernel.org, hch@lst.de, axboe@kernel.dk, snitzer@redhat.com
Date: Fri, 29 Jul 2022 14:23:53 +0800
Message-Id: <20220729062356.1663513-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: _Ch0CgCnCWkneuNiP6ZGBQ--.22656S4
X-Coremail-Antispam: 1UD129KBjvJXoWxWF4rCFyxJr45GrWrWF45KFg_yoW7Jr43pr
 43Kr45Cr48Kr17JF43AF1UJr1UJr47AF1UXryxGr18J3Wj93WUXryUJr4UAryUJr4UZry7
 tr1DJw48tr1UtaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUyG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWUuVWrJwAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vI
 r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
 xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
 cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
 AvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
 xVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH stable 5.10 0/3] dm: fix nullptr crash
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
Cc: linux-block@vger.kernel.org, yukuai3@huawei.com, dm-devel@redhat.com,
 yi.zhang@huawei.com, yukuai1@huaweicloud.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

RnJvbTogWXUgS3VhaSA8eXVrdWFpM0BodWF3ZWkuY29tPgoKVGhpcyBwYXRjaHNldCBiYWNrcG9y
dCB0aHJlZSBwYXRjaGVzIHRvIGZpeCBhIGNyYXNoIGZvdW5kIGJ5IG91ciB0ZXN0OgoKQlVHOiBr
ZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlLCBhZGRyZXNzOiAwMDAwMDAwMDAwMDAwMWEw
CiNQRjogc3VwZXJ2aXNvciByZWFkIGFjY2VzcyBpbiBrZXJuZWwgbW9kZQojUEY6IGVycm9yX2Nv
ZGUoMHgwMDAwKSAtIG5vdC1wcmVzZW50IHBhZ2UKUEdEIDAgUDREIDAKT29wczogMDAwMCBbIzFd
IFBSRUVNUFQgU01QCkNQVTogMSBQSUQ6IDEzMTcgQ29tbTogbW91bnQgTm90IHRhaW50ZWQgNS4x
MC4wLTE2NjkxLWdmNjA3NjQzMjgyN2QtZGlydHkgIzE2OQpIYXJkd2FyZSBuYW1lOiBRRU1VIFN0
YW5kYXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyA/LTIwMTkwNzI3XzA3MzgzNi00
ClJJUDogMDAxMDpfX2Jsa19tcV9zY2hlZF9iaW9fbWVyZ2UrMHg5ZC8weDFhMApDb2RlOiA4NyAx
ZSA5ZCA4OSBkMCAyNSAwMCAwMCAwMCAwMSAwZiA4NSBhZCAwMCAwMCAwMCA0OCA4MyAwNSAyNSBh
MSAzNyAwYyAwMSAzClJTUDogMDAxODpmZmZmYzkwMDAwNDczYjUwIEVGTEFHUzogMDAwMTAyMDIK
UkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogMDAwMDAwMDAwMDAwMDAwMCBSQ1g6IGZmZmZjOTAw
MDA0NzNiOTgKUkRYOiAwMDAwMDAwMDAwMDAxMDAwIFJTSTogZmZmZjg4ODEwODBjNzUwMCBSREk6
IGZmZmY4ODgxMDNhOWNjMTgKUkJQOiBmZmZmODg4MTNiYzgwMDAwIFIwODogMDAwMDAwMDAwMDAw
MDAwMSBSMDk6IDAwMDAwMDAwMDAwMDAwMDAKUjEwOiBmZmZmODg4MTA3MTBiZTMwIFIxMTogMDAw
MDAwMDAwMDAwMDAwMCBSMTI6IGZmZmY4ODgxMDNhOWNjMTgKUjEzOiBmZmZmODg4MTA4MGM3NTAw
IFIxNDogMDAwMDAwMDAwMDAwMDAwMSBSMTU6IDAwMDAwMDAwMDAwMDAwMDAKRlM6ICAwMDAwN2Y1
MWJjZGJiMDQwKDAwMDApIEdTOmZmZmY4ODgxM2JjODAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAw
MDAwMDAwMApDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMz
CkNSMjogMDAwMDAwMDAwMDAwMDFhMCBDUjM6IDAwMDAwMDAxMGQ3MTUwMDAgQ1I0OiAwMDAwMDAw
MDAwMDAwNmUwCkRSMDogMDAwMDAwMDAwMDAwMDAwMCBEUjE6IDAwMDAwMDAwMDAwMDAwMDAgRFIy
OiAwMDAwMDAwMDAwMDAwMDAwCkRSMzogMDAwMDAwMDAwMDAwMDAwMCBEUjY6IDAwMDAwMDAwZmZm
ZTBmZjAgRFI3OiAwMDAwMDAwMDAwMDAwNDAwCgpDYWxsIFRyYWNlOgogYmxrX21xX3N1Ym1pdF9i
aW8rMHgxMTUvMHhkODAKIHN1Ym1pdF9iaW9fbm9hY2N0KzB4NGZmLzB4NjEwCiBzdWJtaXRfYmlv
KzB4YWEvMHgxYTAKIHN1Ym1pdF9iaF93YmMrMHgxY2IvMHgyZjAKIHN1Ym1pdF9iaCsweDE3LzB4
MjAKIGV4dDRfcmVhZF9iaCsweDYzLzB4MTcwCiBleHQ0X3JlYWRfYmhfbG9jaysweDJjLzB4ZDAK
IF9fZXh0NF9zYl9icmVhZF9nZnAuaXNyYS4wKzB4YTAvMHhmMAogZXh0NF9maWxsX3N1cGVyKzB4
MjFmLzB4NTYxMAogPyBwb2ludGVyKzB4MzFiLzB4NWEwCiA/IHZzbnByaW50ZisweDEzMS8weDdk
MAogbW91bnRfYmRldisweDIzMy8weDI4MAogPyBleHQ0X2NhbGN1bGF0ZV9vdmVyaGVhZCsweDY2
MC8weDY2MAogZXh0NF9tb3VudCsweDE5LzB4MzAKIGxlZ2FjeV9nZXRfdHJlZSsweDM1LzB4OTAK
IHZmc19nZXRfdHJlZSsweDI5LzB4MTAwCiA/IGNhcGFibGUrMHgxZC8weDMwCiBwYXRoX21vdW50
KzB4OGE3LzB4MTE1MAogZG9fbW91bnQrMHg4ZC8weGMwCiBfX3NlX3N5c19tb3VudCsweDE0YS8w
eDIyMAogX194NjRfc3lzX21vdW50KzB4MjkvMHg0MAogZG9fc3lzY2FsbF82NCsweDQ1LzB4NzAK
IGVudHJ5X1NZU0NBTExfNjRfYWZ0ZXJfaHdmcmFtZSsweDQ0LzB4YTkKUklQOiAwMDMzOjB4N2Y1
MWJiZTE2MjNhCkNvZGU6IDQ4IDhiIDBkIDUxIGRjIDJiIDAwIGY3IGQ4IDY0IDg5IDAxIDQ4IDgz
IGM4IGZmIGMzIDY2IDJlIDBmIDFmIDg0IDAwIDAwIDgKUlNQOiAwMDJiOjAwMDA3ZmZmMTczYWU4
OTggRUZMQUdTOiAwMDAwMDI0NiBPUklHX1JBWDogMDAwMDAwMDAwMDAwMDBhNQpSQVg6IGZmZmZm
ZmZmZmZmZmZmZGEgUkJYOiAwMDAwNTYxNjlhMTIwMDMwIFJDWDogMDAwMDdmNTFiYmUxNjIzYQpS
RFg6IDAwMDA1NjE2OWExMjAyMTAgUlNJOiAwMDAwNTYxNjlhMTIwMjUwIFJESTogMDAwMDU2MTY5
YTEyMDIzMApSQlA6IDAwMDAwMDAwMDAwMDAwMDAgUjA4OiAwMDAwMDAwMDAwMDAwMDAwIFIwOTog
MDAwMDdmZmYxNzNhZDc5OApSMTA6IDAwMDAwMDAwYzBlZDAwMDAgUjExOiAwMDAwMDAwMDAwMDAw
MjQ2IFIxMjogMDAwMDU2MTY5YTEyMDIzMApSMTM6IDAwMDA1NjE2OWExMjAyMTAgUjE0OiAwMDAw
MDAwMDAwMDAwMDAwIFIxNTogMDAwMDdmNTFiY2JhYzE4NApNb2R1bGVzIGxpbmtlZCBpbjogZG1f
c2VydmljZV90aW1lIGRtX211bHRpcGF0aApDUjI6IDAwMDAwMDAwMDAwMDAxYTAKLS0tWyBlbmQg
dHJhY2UgYWM1ZDg2ZTA5ZmRjN2M5OCBdLS0tClJJUDogMDAxMDpfX2Jsa19tcV9zY2hlZF9iaW9f
bWVyZ2UrMHg5ZC8weDFhMApDb2RlOiA4NyAxZSA5ZCA4OSBkMCAyNSAwMCAwMCAwMCAwMSAwZiA4
NSBhZCAwMCAwMCAwMCA0OCA4MyAwNSAyNSBhMSAzNyAwYyAwMSAzClJTUDogMDAxODpmZmZmYzkw
MDAwNDczYjUwIEVGTEFHUzogMDAwMTAyMDIKUkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogMDAw
MDAwMDAwMDAwMDAwMCBSQ1g6IGZmZmZjOTAwMDA0NzNiOTgKUkRYOiAwMDAwMDAwMDAwMDAxMDAw
IFJTSTogZmZmZjg4ODEwODBjNzUwMCBSREk6IGZmZmY4ODgxMDNhOWNjMTgKUkJQOiBmZmZmODg4
MTNiYzgwMDAwIFIwODogMDAwMDAwMDAwMDAwMDAwMSBSMDk6IDAwMDAwMDAwMDAwMDAwMDAKUjEw
OiBmZmZmODg4MTA3MTBiZTMwIFIxMTogMDAwMDAwMDAwMDAwMDAwMCBSMTI6IGZmZmY4ODgxMDNh
OWNjMTgKUjEzOiBmZmZmODg4MTA4MGM3NTAwIFIxNDogMDAwMDAwMDAwMDAwMDAwMSBSMTU6IDAw
MDAwMDAwMDAwMDAwMDAKRlM6ICAwMDAwN2Y1MWJjZGJiMDQwKDAwMDApIEdTOmZmZmY4ODgxM2Jj
ODAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApDUzogIDAwMTAgRFM6IDAwMDAgRVM6
IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzCkNSMjogMDAwMDdmMTBlOTdhNTAwMCBDUjM6IDAw
MDAwMDAxMGQ3MTUwMDAgQ1I0OiAwMDAwMDAwMDAwMDAwNmUwCkRSMDogMDAwMDAwMDAwMDAwMDAw
MCBEUjE6IDAwMDAwMDAwMDAwMDAwMDAgRFIyOiAwMDAwMDAwMDAwMDAwMDAwCkRSMzogMDAwMDAw
MDAwMDAwMDAwMCBEUjY6IDAwMDAwMDAwZmZmZTBmZjAgRFI3OiAwMDAwMDAwMDAwMDAwNDAwCktl
cm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KS2VybmVsIE9mZnNldDog
ZGlzYWJsZWQKLS0tWyBlbmQgS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZhdGFsIGV4Y2Vw
dGlvbiBdLS0tCgpyb290IGNhdXNlOgp0MSBkbS1tcGF0aAkJdDIgbW91bnQKCmFsbG9jX2Rldgog
bWQtPnF1ZXVlID0gYmxrX2FsbG9jX3F1ZXVlCiBhZGRfZGlza19ub19xdWV1ZV9yZWcKCmRtX3Nl
dHVwX21kX3F1ZXVlCiBjYXNlIERNX1RZUEVfUkVRVUVTVF9CQVNFRCAtPiBtdWx0aXBhdGgKICBt
ZC0+ZGlzay0+Zm9wcyA9ICZkbV9ycV9ibGtfZG9wczsKCQkJZXh0NF9maWxsX3N1cGVyCiAgICAg
ICAgICAgICAgICAgICAgICAgIOKUil9fZXh0NF9zYl9icmVhZF9nZnAKICAgICAgICAgICAgICAg
ICAgICAgICAg4pSKIGV4dDRfcmVhZF9iaAogICAgICAgICAgICAgICAgICAgICAgICDilIogIHN1
Ym1pdF9iaW8gLT4gcXVldWUgaXMgbm90IGluaXRpYWxpemVkIHlldAogICAgICAgICAgICAgICAg
ICAgICAgICDilIogICBfX2Jsa19tcV9zY2hlZF9iaW9fbWVyZ2UKICAgICAgICAgICAgICAgICAg
ICAgICAg4pSKICAgIGN0eCA9IGJsa19tcV9nZXRfY3R4KHEpOyAtPiBjdHggaXMgTlVMTAogIGRt
X21xX2luaXRfcmVxdWVzdF9xdWV1ZQoKUGF0Y2ggMyBpcyB0aGUgZml4IHBhdGNoLCBhbmQgcGF0
Y2ggMSwyIGlzIG5lZWRlZCB0byBiYWNrcG9ydCBwYXRjaCAzLgoKUGxlYXNlIG5vdGVkIHRoYXQg
dGhlcmUgYXJlIGxvdHMgb2YgY29uZmljdHMgYmV0d2VlbiA1LjEwIGFuZCBtYWlubGluZSwKYW5k
IEkgbWFkZSBwbGVudHkgYWRhcHRhdGlvbnMgaW4gdGhlc2UgcGF0Y2hlcy4KCkkgYWxyZWFkeSB0
ZXN0ZWQgdGhpcyBwYXRjaHNldCB3aXRoIGRtdGVzdCBjcmVhdGUvcmVtb3ZlIHRlc3RzOgoKZG10
ZXN0IHJ1biAtLXN1aXRlIHRoaW4tcHJvdmlzaW9uaW5nIC10IC9DcmVhdGlvblxEZWxldGlvbi8K
CkNocmlzdG9waCBIZWxsd2lnICgzKToKICBibG9jazogbG9vayB1cCBob2xkZXJzIGJ5IGJkZXYK
ICBibG9jazogc3VwcG9ydCBkZWxheWVkIGhvbGRlciByZWdpc3RyYXRpb24KICBkbTogZGVsYXkg
cmVnaXN0ZXJpbmcgdGhlIGdlbmRpc2sKCiBibG9jay9nZW5oZC5jICAgICAgICAgICAgIHwgIDEz
ICsrKysrCiBkcml2ZXJzL21kL2RtLmMgICAgICAgICAgIHwgIDI0ICsrKysrLS0tLQogZnMvYmxv
Y2tfZGV2LmMgICAgICAgICAgICB8IDEwNSArKysrKysrKysrKysrKysrKysrKysrKysrKystLS0t
LS0tLS0tLQogaW5jbHVkZS9saW51eC9ibGtfdHlwZXMuaCB8ICAgMyAtLQogaW5jbHVkZS9saW51
eC9nZW5oZC5oICAgICB8ICAgOSArKystCiA1IGZpbGVzIGNoYW5nZWQsIDExMCBpbnNlcnRpb25z
KCspLCA0NCBkZWxldGlvbnMoLSkKCi0tIAoyLjMxLjEKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlz
dApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWwK

