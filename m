Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A295BC7EE25
	for <dm-devel@archiver.kernel.org>; Mon, 15 May 2023 01:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684115033;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GlwIDNJv3IubNtbg+PGQN3+M3u7BPAW6nvDQbYA37T8=;
	b=bq1GM4eUhaIF+soNduWk0VMDZEcxEbnf7cucFggytzOwqrWVax26ZfE98X1upHC01v1pX2
	UQd+J6Qg+AaIMVAYuD5+9kd+llyHQEuwU/nIPh9wqYxS2wlNwDrRWAwQxMM8td4R18Yd/j
	kKkf5OTshtFOiUx1Z5sRTXQTO2QDrf0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-HAVPeM0bPhWVuZ22Fu28sw-1; Sun, 14 May 2023 21:43:51 -0400
X-MC-Unique: HAVPeM0bPhWVuZ22Fu28sw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B74E80080E;
	Mon, 15 May 2023 01:43:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 37CA64021D9;
	Mon, 15 May 2023 01:43:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0C28C1946595;
	Mon, 15 May 2023 01:43:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E48DA1946595
 for <dm-devel@listman.corp.redhat.com>; Mon, 15 May 2023 01:43:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A720440C2078; Mon, 15 May 2023 01:43:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F4E440C2077
 for <dm-devel@redhat.com>; Mon, 15 May 2023 01:43:34 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83D76101A54F
 for <dm-devel@redhat.com>; Mon, 15 May 2023 01:43:34 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-59-iN7zA8ECNySRKs-MH5DA5A-1; Sun, 14 May 2023 21:43:31 -0400
X-MC-Unique: iN7zA8ECNySRKs-MH5DA5A-1
Received: from mail02.huawei.com (unknown [172.30.67.169])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QKMb13STlz4f3mHs;
 Mon, 15 May 2023 09:43:25 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP3 (Coremail) with SMTP id _Ch0CgBH9CE9jmFkXtnYIg--.28848S3;
 Mon, 15 May 2023 09:43:27 +0800 (CST)
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>, Christoph Hellwig <hch@lst.de>
References: <20230512080757.387523-1-kch@nvidia.com>
 <20230512130042.GA29078@lst.de>
 <67376534-ac4a-3cd9-fab6-fd3a062f5e48@nvidia.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <2ca38f24-6c6f-4975-fcc8-e700c67029ee@huaweicloud.com>
Date: Mon, 15 May 2023 09:43:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <67376534-ac4a-3cd9-fab6-fd3a062f5e48@nvidia.com>
X-CM-TRANSID: _Ch0CgBH9CE9jmFkXtnYIg--.28848S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
 VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYI7kC6x804xWl14x267AKxVW5JVWrJwAF
 c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
 0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xv
 wVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
 x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG
 64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r
 1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kI
 c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
 AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
 17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
 IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq
 3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
 nIWIevJa73UjIFyTuYvjxUFDGOUUUUU
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
Subject: Re: [dm-devel] [RFC PATCH] block: add meaningful macro for flush op
 flags
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
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "sagi@grimberg.me" <sagi@grimberg.me>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "colyli@suse.de" <colyli@suse.de>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "song@kernel.org" <song@kernel.org>,
 "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
 "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "yukuai \(C\)" <yukuai3@huawei.com>,
 "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
 "agk@redhat.com" <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMy8wNS8xMyA5OjA5LCBDaGFpdGFueWEgS3Vsa2Fybmkg5YaZ6YGTOgo+IE9u
IDUvMTIvMjMgMDY6MDAsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOgo+PiBIZWxsIG5vLiAgVGhp
cyBpcyBqdXN0IG9ic2Z1Y2F0aW9uLiAgV2UgY2FuIGxvb2sgaW50byBhY3R1YWxseSBleHBvc2lu
Zwo+PiBSRVFfT1BfRkxVU0ggYXQgdGhlIGJpbyBsZXZlbCwgYnV0IG5vdCBzb21ldGhpbmcgbGlr
ZSB0aGlzLgo+Pgo+IAo+IGFuZCB0aGF0J3Mgd2h5IEkgbWFkZSBpdCBSRkMsIHRoYW5rcyBmb3Ig
dGhlIGNhbiB5b3UgcGxlYXNlIGVsYWJvcmF0ZQo+IG9uICJleHBvc2luZyBSRVFfT1BfRkxVU0gg
YXQgdGhlIGJpbyBsZXZlbCIgPwoKSSB0aGluayBDaHJpc3RvcGggbWVhbnMgdGhhdCB1c2UgdGhp
cyBmbGFnIGRpcmVjdGx5IGZvciBiaW8sIGl0J3Mgb25seQp1c2VkIGZvciByZXFldXN0IGZvciBu
b3cuCgpUaGFua3MsCkt1YWkKPiAKPiBJJ2QgcmVhbGx5IGxpa2Ugd29yayB0aGF0IC4uLgo+IAo+
IC1jawo+IAo+IAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20K
aHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

