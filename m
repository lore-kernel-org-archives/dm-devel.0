Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4430C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 15:34:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-psRoC2ZIO1C9l80oDbvICw-1; Thu, 24 Mar 2022 11:34:54 -0400
X-MC-Unique: psRoC2ZIO1C9l80oDbvICw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0AFAD3804522;
	Thu, 24 Mar 2022 15:34:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AD3FAC15D7B;
	Thu, 24 Mar 2022 15:34:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 124601940368;
	Thu, 24 Mar 2022 15:34:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 548471947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 12:30:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3BCBB441983; Tue, 22 Mar 2022 12:30:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 371CE43E901
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 12:30:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E40480159B
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 12:30:51 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-YKNCKZrpP_GLCTpS4Hay5w-1; Tue, 22 Mar 2022 08:30:47 -0400
X-MC-Unique: YKNCKZrpP_GLCTpS4Hay5w-1
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.207])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KN9kp4dxgz6H6rn;
 Tue, 22 Mar 2022 20:28:34 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Tue, 22 Mar 2022 13:30:44 +0100
Received: from [10.47.85.68] (10.47.85.68) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Tue, 22 Mar
 2022 12:30:44 +0000
Message-ID: <a5e42012-c1fc-082e-e636-594abc07dd70@huawei.com>
Date: Tue, 22 Mar 2022 12:30:42 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
References: <1647945585-197349-1-git-send-email-john.garry@huawei.com>
 <1647945585-197349-2-git-send-email-john.garry@huawei.com>
 <20220322111848.GA29270@lst.de>
 <cacc3f7b-c8be-0f72-1c52-562c15b468a4@huawei.com>
 <b5df2ef1-2d6d-340e-e4b4-09132dc0516b@suse.de>
From: John Garry <john.garry@huawei.com>
In-Reply-To: <b5df2ef1-2d6d-340e-e4b4-09132dc0516b@suse.de>
X-Originating-IP: [10.47.85.68]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Thu, 24 Mar 2022 15:34:42 +0000
Subject: Re: [dm-devel] [PATCH 01/11] blk-mq: Add blk_mq_init_queue_ops()
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
Cc: axboe@kernel.dk, bvanassche@acm.org, martin.petersen@oracle.com,
 chenxiang66@hisilicon.com, damien.lemoal@opensource.wdc.com,
 linux-kernel@vger.kernel.org, ming.lei@redhat.com, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org,
 jejb@linux.ibm.com, beanhuo@micron.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMjIvMDMvMjAyMiAxMjoxNiwgSGFubmVzIFJlaW5lY2tlIHdyb3RlOgo+IE9uIDMvMjIvMjIg
MTI6MzMsIEpvaG4gR2Fycnkgd3JvdGU6Cj4+IE9uIDIyLzAzLzIwMjIgMTE6MTgsIENocmlzdG9w
aCBIZWxsd2lnIHdyb3RlOgo+Pj4gT24gVHVlLCBNYXIgMjIsIDIwMjIgYXQgMDY6Mzk6MzVQTSAr
MDgwMCwgSm9obiBHYXJyeSB3cm90ZToKPj4+PiBBZGQgYW4gQVBJIHRvIGFsbG9jYXRlIGEgcmVx
dWVzdCBxdWV1ZSB3aGljaCBhY2NlcHRzIGEgY3VzdG9tIHNldCBvZgo+Pj4+IGJsa19tcV9vcHMg
Zm9yIHRoYXQgcmVxdWVzdCBxdWV1ZS4KPj4+Pgo+Pj4+IFRoZSByZWFzb24gd2hpY2ggd2UgbWF5
IHdhbnQgY3VzdG9tIG9wcyBpcyBmb3IgcXVldWluZyByZXF1ZXN0cyAKPj4+PiB3aGljaCB3ZQo+
Pj4+IGRvbid0IHdhbnQgdG8gZ28gdGhyb3VnaCB0aGUgbm9ybWFsIHF1ZXVpbmcgcGF0aC4KPj4+
Cj4+PiBFd3cuwqAgSSByZWFsbHkgZG8gbm90IHRoaW5rIHdlIHNob3VsZCBkbyBzZXBhcmF0ZSBv
cHMgcGVyIHF1ZXVlLCBhcyB0aGF0Cj4+PiBpcyBnb2luZyB0byBnZXQgdXMgaW50byBhIGRlZXAg
bWVzcyBldmVudHVhbGx5Lgo+Pj4KPj4KPj4gWWVhaC4uLiBzbyBmYXIgKGhlcmUpIGl0IHdvcmtz
IG91dCBxdWl0ZSBuaWNlbHksIGFzIHdlIGRvbid0IG5lZWQgdG8gCj4+IGNoYW5nZSB0aGUgU0NT
SSBibGsgbXEgb3BzIG5vciBhbGxvY2F0ZSBhIHNjc2lfZGV2aWNlIC0gZXZlcnl0aGluZyBpcyAK
Pj4ganVzdCBzZXBhcmF0ZS4KPj4KPj4gVGhlIG90aGVyIG1ldGhvZCBtZW50aW9uZWQgcHJldmlv
dXNseSB3YXMgdG8gYWRkIHRoZSByZXF1ZXN0IAo+PiAicmVzZXJ2ZWQiIGZsYWcgYW5kIGFkZCBu
ZXcgcGF0aHMgaW4gc2NzaV9xdWV1ZV9ycSgpIGV0IGFsIHRvIGhhbmRsZSAKPj4gdGhpcywgYnV0
IHRoYXQgZ2V0cyBtZXNzeS4KPj4KPj4gQW55IG90aGVyIGlkZWFzIC4uLj8KPj4KPiAKPiBBcyBv
dXRsaW5lZCBpbiB0aGUgb3RoZXIgbWFpbCwgSSB0aGluayBtaWdodCBiZSB1c2VmdWwgaXMgdG8g
aGF2ZSBhIAo+IF90aGlyZF8gdHlwZSBvZiByZXF1ZXN0cyAoaW4gYWRkaXRpb24gdG8gdGhlIG5v
cm1hbCBhbmQgdGhlIHJlc2VydmVkIG9uZXMpLgo+IFRoYXQgb25lIHdvdWxkIGJlIGFsbG9jYXRl
ZCBmcm9tIHRoZSBub3JtYWwgSS9PIHBvb2wgKGFuZCBoZW5jZSBjb3VsZCAKPiBmYWlsIGlmIHRo
ZSBwb29sIGlzIGV4aGF1c3RlZCksIGJ1dCB3b3VsZCBiZSBhYmxlIHRvIGNhcnJ5IGEgZGlmZmVy
ZW50IAo+IHBheWxvYWQgKHR5cGUpIHRoYW4gdGhlIG5vcm1hbCByZXF1ZXN0cy4KCkFzIG1lbnRp
b25lZCBpbiB0aGUgY292ZXIgbGV0dGVyIHJlc3BvbnNlLCBpdCBqdXN0IHNlZW1zIGJlc3QgdG8g
a2VlcCAKdGhlIG5vcm1hbCBzY3NpX2NtbmQgcGF5bG9hZCBidXQgaGF2ZSBvdGhlciBtZWFucyB0
byBhZGQgb24gdGhlIGludGVybmFsIApjb21tYW5kIGRhdGEsIGxpa2UgdXNpbmcgaG9zdF9zY3Jp
YmJsZSBvciBzY3NpX2NtbmQgcHJpdiBkYXRhLgoKPiBBbmQgd2UgY291bGQgaGF2ZSBhIHNlcGFy
YXRlIHF1ZXVlX3JxIGZvciB0aGVzZSByZXF1ZXN0cywgYXMgd2UgY2FuIAo+IGRpZmZlcmVudGlh
dGUgdGhlbSBpbiB0aGUgYmxvY2sgbGF5ZXIuCgpJIGRvbid0IGtub3csIGxldCBtZSB0aGluayBh
Ym91dCBpdC4gTWF5YmUgd2UgY291bGQgYWRkIGFuICJpbnRlcm5hbCIgCmJsayBmbGFnLCB3aGlj
aCB1c2VzIGEgc2VwYXJhdGUgImludGVybmFsIiBxdWV1ZV9ycSBjYWxsYmFjay4KClRoYW5rcywK
Sm9obgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6
Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

