Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E57F4C4167E
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 15:34:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-FVlEYHwmMMOylxkuhtJnCw-1; Thu, 24 Mar 2022 11:34:56 -0400
X-MC-Unique: FVlEYHwmMMOylxkuhtJnCw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C36B805F69;
	Thu, 24 Mar 2022 15:34:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 208A641136E0;
	Thu, 24 Mar 2022 15:34:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C439F1940362;
	Thu, 24 Mar 2022 15:34:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 067B41947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 12:17:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DF4FF53D8; Tue, 22 Mar 2022 12:17:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DAE257AD1
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 12:17:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3FB33C1EA4C
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 12:17:11 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-QVI1LFKTMZ-b-JVuavigUA-1; Tue, 22 Mar 2022 08:17:07 -0400
X-MC-Unique: QVI1LFKTMZ-b-JVuavigUA-1
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.200])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KN9R30Xy3z686wW;
 Tue, 22 Mar 2022 20:14:55 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 22 Mar 2022 13:17:05 +0100
Received: from [10.47.85.68] (10.47.85.68) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Tue, 22 Mar
 2022 12:17:04 +0000
Message-ID: <9ab30c12-4451-d96a-f3de-5b883a92aed5@huawei.com>
Date: Tue, 22 Mar 2022 12:17:03 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
To: Hannes Reinecke <hare@suse.de>, <axboe@kernel.dk>,
 <damien.lemoal@opensource.wdc.com>, <bvanassche@acm.org>,
 <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <hch@lst.de>,
 <ming.lei@redhat.com>
References: <1647945585-197349-1-git-send-email-john.garry@huawei.com>
 <1537235d-ac22-6914-4b31-4482e9536098@suse.de>
From: John Garry <john.garry@huawei.com>
In-Reply-To: <1537235d-ac22-6914-4b31-4482e9536098@suse.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mailman-Approved-At: Thu, 24 Mar 2022 15:34:42 +0000
Subject: Re: [dm-devel] [PATCH RFC 00/11] blk-mq/libata/scsi: SCSI driver
 tagging improvements
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
Cc: linux-scsi@vger.kernel.org, chenxiang66@hisilicon.com,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, dm-devel@redhat.com, beanhuo@micron.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMjIvMDMvMjAyMiAxMTozMCwgSGFubmVzIFJlaW5lY2tlIHdyb3RlOgo+IE9uIDMvMjIvMjIg
MTE6MzksIEpvaG4gR2Fycnkgd3JvdGU6Cj4+IEN1cnJlbnRseSBTQ1NJIGxvdy1sZXZlbCBkcml2
ZXJzIGFyZSByZXF1aXJlZCB0byBtYW5hZ2UgdGFncyBmb3IgY29tbWFuZHMKPj4gd2hpY2ggZG8g
bm90IGNvbWUgdmlhIHRoZSBibG9jayBsYXllciAtIGxpYmF0YSBpbnRlcm5hbCBjb21tYW5kcyB3
b3VsZCBiZQo+PiBhbiBleGFtcGxlIG9mIG9uZSBvZiB0aGVzZS4KPj4KPj4gVGhlcmUgd2FzIHNv
bWUgd29yayB0byBwcm92aWRlICJyZXNlcnZlZCBjb21tYW5kcyIgc3VwcG9ydCBpbiBzdWNoIHNl
cmllcwo+PiBhcyAKPj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtc2NzaS8yMDIxMTEy
NTE1MTA0OC4xMDM5MTAtMS1oYXJlQHN1c2UuZGUvCj4+Cj4+IFRoaXMgd2FzIGJhc2VkIG9uIGFs
bG9jYXRpbmcgYSByZXF1ZXN0IGZvciB0aGUgbGlmZXRpbWUgb2YgdGhlICJpbnRlcm5hbCIKPj4g
Y29tbWFuZC4KPj4KPj4gVGhpcyBzZXJpZXMgdHJpZXMgdG8gc29sdmUgdGhhdCBwcm9ibGVtIGJ5
IG5vdCBqdXN0IGFsbG9jYXRpbmcgdGhlIAo+PiByZXF1ZXN0Cj4+IGJ1dCBhbHNvIHNlbmRpbmcg
aXQgdGhyb3VnaCB0aGUgYmxvY2sgbGF5ZXIsIHRoYXQgYmVpbmcgdGhlIG5vcm1hbCBmbG93Cj4+
IGZvciBhIHJlcXVlc3QuIFdlIG5lZWQgdG8gZG8gdGhpcyBhcyB3ZSBtYXkgb25seSBwb2xsIGNv
bXBsZXRpb24gb2YKPj4gcmVxdWVzdHMgdGhyb3VnaCB0aGUgYmxvY2sgbGF5ZXIsIHNvIHdvdWxk
IG5lZWQgdG8gZG8gdGhpcyBmb3IgcG9sbCBxdWV1ZQo+PiBzdXBwb3J0Lgo+Pgo+PiBUaGVyZSBp
cyBzdGlsbCBzY29wZSB0byBhbGxvY2F0ZSBjb21tYW5kcyBqdXN0IHRvIGdldCBhIHRhZyBhcyB0
b2tlbiBhcwo+PiB0aGF0IG1heSBzdWl0IHNvbWUgb3RoZXIgc2NlbmFyaW9zLCBidXQgaXQncyBu
b3Qgd2hhdCB3ZSBkbyBoZXJlLgo+Pgo+PiBUaGlzIHNlcmllcyBleHRlbmRzIGJsay1tcSB0byBz
dXBwb3J0IGEgcmVxdWVzdCBxdWV1ZSBoYXZpbmcgYSBjdXN0b20gc2V0Cj4+IG9mIG9wcy4gSW4g
YWRkaXRpb24gU0NTSSBjb3JlIGNvZGUgYWRkcyBzdXBwb3J0IGZvciB0aGVzZSB0eXBlIG9mIAo+
PiByZXF1ZXN0cy4KPj4KPj4gVGhpcyBzZXJpZXMgZG9lcyBub3QgaW5jbHVkZSBTQ1NJIGNvcmUg
aGFuZGxpbmcgZm9yIGVuYWJsaW5nIHJlc2VydmVkCj4+IHRhZ3MgcGVyIHRhZ3NldCwgYnV0IHRo
YXQgd291bGQgYmUgZWFzeSB0byBhZGQuCj4+Cj4+IEJhc2VkIG9uIG1rcC1zY3NpIDUuMTgvc2Nz
aS1zdGFnaW5nIEAgNjZkYWYzZTZiOTkzCj4+Cj4+IFBsZWFzZSBjb25zaWRlciBhcyBhbiBSRkMg
Zm9yIG5vdy4gSSB0aGluayB0aGF0IHRoZSBsaWJhdGEgY2hhbmdlIGhhcyB0aGUKPj4gbGFyZ2Vz
dCBzY29wZSBmb3IgaW1wcm92ZW1lbnQuLi4KPj4KPiAKPiBHcmFuZCBzZWVpbmcgdGhhdCBzb21l
b25lIGlzIHRha2luZyBpdCB1cC4gVGhhbmtzIGZvciBkb2luZyB0aGlzIQo+IAo+IEJ1dDoKPiBB
bGxvY2F0aW5nIGEgcXVldWUgZm9yIGV2ZXJ5IHJlcXVlc3QgKGVnIGluIHBhdGNoIDMpIGlzIG92
ZXJraWxsLiBJZiB3ZSAKPiB3YW50IHRvIGdvIHRoYXQgcm91dGUgd2Ugc2hvdWxkIGJlIGFsbG9j
YXRpbmcgdGhlIHF1ZXVlIHVwZnJvbnQgKGVnIHdoZW4gCj4gY3JlYXRpbmcgdGhlIGRldmljZSBp
dHNlbGYpLCBhbmQgdGhlbiBqdXN0IHJlZmVyZW5jaW5nIGl0LgoKRm9yIHBhdGNoICMzIEkgbmVl
ZGVkIHRvIGFsbG9jYXRlIGEgc2VwYXJhdGUgcmVxdWVzdCBxdWV1ZSBhcyB0aGUgc2NzaSAKZGV2
aWNlIGlzIG5vdCBjcmVhdGVkIGJ5IHRoYXQgc3RhZ2UuCgpBbmQgdGhlbiBmb3Igb3RoZXIgc2Nl
bmFyaW9zIGluIHdoaWNoIHdlIGFsbG9jYXRlIHRoZSBzZXBhcmF0ZSByZXF1ZXN0IApxdWV1ZSwg
c2luY2UgdGhlIHNjaGVtZSBoZXJlIGlzIHRvIGFsbG9jYXRlIGEgcmVxdWVzdCBxdWV1ZSB3aXRo
IApkaWZmZXJlbnQgb3BzLCB3ZSBjYW4ndCB1c2UgdGhlIHNhbWUgc2NzaV9kZXZpY2UgcmVxdWVz
dCBxdWV1ZS4KCm5vdGU6IEFzIGZvciBhbGxvY2F0aW5nIHJlcXVlc3QgcXVldWVzIGZvciB0aGUg
bGlmZXRpbWUgb2YgdGhlIGhvc3QsIHdlIApuZWVkIHRvIHJlbWVtYmVyIHRoYXQgYmxrLW1xIGZh
aXJseSByZXNlcnZlcyBhIHRhZyBidWRnZXQgcGVyIHJlcXVlc3QgCnF1ZXVlLCBhbmQgaXQgd291
bGQgYmUgYSB3YXN0ZSB0byBrZWVwIGEgYnVkZ2V0IGp1c3QgZm9yIHRoZXNlIGludGVybmFsIApj
b21tYW5kcy4gU28gdGhhdCBpcyB3aHkgSSBvbmx5IGtlZXAgdGhlIHJlcXVlc3QgcXVldWVzIHRl
bXBvcmFyaWx5LgoKPiAKPiBIb3dldmVyLCBjYW4ndCBzYXkgSSBsaWtlIHRoaXMgYXBwcm9hY2gu
IEkndmUgYmVlbiBwbGF5aW5nIGFyb3VuZCB3aXRoIAo+IHN1cHBvcnRpbmcgaW50ZXJuYWwgY29t
bWFuZHMsIGFuZCByZWFsbHkgZm91bmQgdHdvIGNvbnN0cmFpbnRzIHJlYWxseSAKPiBhbm5veWlu
ZzoKPiAKPiAtIFRoZSB0YWdzZXQgc3VwcG9ydHMgb25seSBfb25lXyBzZXQgb2YgcGF5bG9hZCB2
aWEKPiAgwqAgYmxrX21xX3JxXyh0byxmcm9tKV9wZHUoKS4KPiBUaGlzIHJlcXVpcmVzIGVhY2gg
cmVxdWVzdCB0byBiZSBvZiB0aGUgc2FtZSB0eXBlLCBhbmQgd2l0aCB0aGF0IG1ha2luZwo+IGl0
IHJlYWxseSBoYXJkIGZvciByZS1wdXJwb3NpbmcgdGhlIHJlcXVlc3QgZm9yIGludGVybmFsIHVz
YWdlLiBJbiB0aGUKPiBlbmQgSSBzZXR0bGVkIGJ5IGp1c3Qga2VlcGluZyBpdCBhbmQgc2tpcHBp
bmcgdGhlIFNDU0kgY29tbWFuZCBmaWVsZC4KClRoYXQgc291bmRzIHJlYXNvbmFibGUuCgpGb3Ig
dGhpcyBzZXJpZXMgSSBhbSBqdXN0IGZpeGluZyB1cCBsaWJzYXMsIGFuZCBsaWJzYXMgaGFzIGEg
c2FzX3Rhc2sgCnBlciBjb21tYW5kIGFscmVhZHksIHNvIHdlIGNhbiBqdXN0IGFsbG9jYXRlIHRo
ZSBzYXNfdGFzayBzZXBhcmF0ZWx5IGFuZCAKdXNlIHRoZSBob3N0X3NjcmliYmxlIHRvIHBvaW50
IHRvIHRoZSBzYXNfdGFzay4KCj4gSWYgd2UgY291bGQgaGF2ZSBhIGRpc3RpbmN0IFBEVSB0eXBl
IGZvciBpbnRlcm5hbCBjb21tYW5kcyBJIGd1ZXNzIAo+IHRoaW5ncyB3b3VsZCBiZSBlYXNpZXIu
CgpPdGhlciBkcml2ZXJzIGNhbiBkbyBzb21ldGhpbmcgc2ltaWxhciB0byBhYm92ZSBvciB1c2Ug
dGhlIHNjc2kgcHJpdiBkYXRhLgoKPiAKPiAtIFRoZSBudW1iZXIgb2YgcmVzZXJ2ZWQgY29tbWFu
ZHMgaXMgc3RhdGljLgo+IFdpdGggdGhhdCBpdCdzIGdldHRpbmcgcmVhbGx5IGhhcmQgdXNpbmcg
cmVzZXJ2ZWQgY29tbWFuZHMgd2l0aCAKPiBsb3ctcXVldWUgZGVwdGggZGV2aWNlcyBsaWtlIEFU
QTsgd2Ugb25seSBoYXZlIDMxIGNvbW1hbmRzIHRvIHdvcmsgd2l0aCwgCj4gYW5kIHNldHRpbmcg
b25lIG9yIHR3byBhc2lkZSBmb3IgVE1GIGlzIHJlYWxseSBtYWtpbmcgYSBkaWZmZXJlbmNlIAo+
IHBlcmZvcm1hbmNlIHdpc2UuIEl0IHdvdWxkIGJlIF9hd2Vzb21lXyBpZiB3ZSBjb3VsZCBhbGxv
Y2F0ZSByZXNlcnZlZCAKPiBjb21tYW5kcyBkeW5hbWljYWxseSAoaWUganVzdCBtYXJraW5nIGEg
Y29tbWFuZCBhcyAncmVzZXJ2ZWQnIG9uY2UgCj4gYWxsb2NhdGVkKS4KCkkgc2VlLiBTbyB5b3Ug
d2FudCB0byBhbGxvY2F0ZSBhIHJlcXVlc3QsIG1hcmsgYXMgImludGVybmFsIiwgYW5kIHRoZW4g
CndlIGhhdmUgYSBmbGFnIHdoaWNoIGNhbiBiZSB1c2VkIHRvIGRlY2lkZSB3aGljaCBwYXRoIHdl
IG5lZWQgdG8gc2VuZCBpdCAKb24uIGVoLCBtYXliZSBzY3NpX2NtbmQuc3VibWl0dGVyIGNvdWxk
IGJlIHVzZWQKCj4gU3VyZSwgaXQgd29uJ3QgaGF2ZSB0aGUgc2FtZSBndWFyYW50ZWVzIGFzICdy
ZWFsJyByZXNlcnZlZCBjb21tYW5kcywgYnV0IAo+IGluIG1vc3QgY2FzZXMgd2UgZG9uJ3QgYWN0
dWFsbHkgbmVlZCB0aGF0Lgo+IAo+IE1heWJlIHRoZXNlIGFyZSBzb21lIGxpbmVzIHdlIGNvdWxk
IGludmVzdGlnYXRlPwo+IEhtbT8KPiAKClRoYW5rcywKSm9obgoKLS0KZG0tZGV2ZWwgbWFpbGlu
ZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFp
bG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

