Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79833E94139
	for <dm-devel@archiver.kernel.org>; Sat,  7 Oct 2023 02:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696647022;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7wJqBtqpCKHymRyiUlAdRiuHYuAD1x29ii4lUWA5EFQ=;
	b=YF+w7Zd0EvEZe9Ux04PmZETTmdISrHeJR8RWgR4JeTwM2gmjhw6vvdx7lnMX+3SRbMzuEI
	/quXImKPYs0pRqP+eF6olWFvH0ZXHKWCAHn0mg/bWqxdWWbEm4X/BdWIxMSopB52RguZje
	N1sFxjrEwEwBQxTPH+5tgSJCwIt8DPo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-Atf7E6ntOXqIAnqceB20bA-1; Fri, 06 Oct 2023 22:50:08 -0400
X-MC-Unique: Atf7E6ntOXqIAnqceB20bA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04A4E3C13505;
	Sat,  7 Oct 2023 02:50:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ACB42C15BB8;
	Sat,  7 Oct 2023 02:50:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2A04F19465B6;
	Sat,  7 Oct 2023 02:50:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C09F81946588
 for <dm-devel@listman.corp.redhat.com>; Sat,  7 Oct 2023 02:50:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 67440C158BA; Sat,  7 Oct 2023 02:50:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FBEBC15BB8
 for <dm-devel@redhat.com>; Sat,  7 Oct 2023 02:50:04 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D31585A5A8
 for <dm-devel@redhat.com>; Sat,  7 Oct 2023 02:50:04 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-533-DpQDNgSONDC03mEuH_bhyg-1; Fri, 06 Oct 2023 22:50:02 -0400
X-MC-Unique: DpQDNgSONDC03mEuH_bhyg-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4S2VBL5RLDz4f3kjc;
 Sat,  7 Oct 2023 10:49:30 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgAXrt06xyBlfdFPCQ--.31163S3;
 Sat, 07 Oct 2023 10:49:32 +0800 (CST)
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
References: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
 <CAPhsuW5cUgqy9fqj+Z4nGPQrAok-eQ=NipNxb0TL_kuCFaPMcw@mail.gmail.com>
 <f59cbb99-33dd-c427-2e43-5a07ab9fbf51@huaweicloud.com>
 <CAPhsuW7TRODsR_N95AmXJCZvpTuSKgbOjnYGxMGAWtmt3x9Vkw@mail.gmail.com>
 <eb4ea24d-f7b4-899b-9259-2d48dc83e48f@huaweicloud.com>
 <CAPhsuW72zSALeSk96QAdq4cHf=y_n13MOBmxH-dTUKjkbc_jig@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <9ce30c2f-bc45-6072-b454-aca154b779ce@huaweicloud.com>
Date: Sat, 7 Oct 2023 10:49:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAPhsuW72zSALeSk96QAdq4cHf=y_n13MOBmxH-dTUKjkbc_jig@mail.gmail.com>
X-CM-TRANSID: gCh0CgAXrt06xyBlfdFPCQ--.31163S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
 VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYk7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
 6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
 kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8I
 cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
 Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
 6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72
 CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4II
 rI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr4
 1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
 67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
 8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAv
 wI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
 0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH -next v3 00/25] md: synchronize io with array
 reconfiguration
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, snitzer@kernel.org,
 dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 xni@redhat.com, "yukuai \(C\)" <yukuai3@huawei.com>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMy8xMC8wNyAxMDo0MCwgU29uZyBMaXUg5YaZ6YGTOgo+PiBDYW4geW91IHRh
a2UgYSBsb29rIGFib3V0IHRoaXMgbmV3IGNvdmVyIGxldHRlcj8KPiAKPiBJIGRvbid0IGhhdmUg
dGltZSByaWdodCBub3cgdG8gbG9vayBpbnRvIGFsbCB0aGUgZGV0YWlscywgYnV0IGl0IGxvb2tz
Cj4gZ3JlYXQgYXQgZmlyc3QgZ2xhbmNlLiBXZSBjYW4gc3RpbGwgZWRpdCBpdCBhIGxpdHRsZSBi
aXQgd2hlbiBhcHBseWluZyB0aGUKPiBwYXRjaHNldCwgYnV0IHRoYXQgbWF5IG5vdCBiZSBuZWNl
c3NhcnkuCgpZZWFoLCBpdCdzIG5vdCB1cmdlbnQgc28geW91IGNhbiB0YWtlIGl0IHNsb3csIEkg
anVzdCB3YW50IHRvIG1ha2Ugc3VyZQp0aGF0IHlvdSdyZSBnb29kIHdpdGggaXQuIEknbGwgZWRp
dCB0aGlzIGNvdmVyIGxldHRlciBhIGJpdCBhbmQgc2VuZCB2NApzb29uLgoKVGhhbmtzLApLdWFp
CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xp
c3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

