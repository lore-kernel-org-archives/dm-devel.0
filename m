Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21611C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  2 May 2022 04:39:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-c7E1g9usNkK-N2BJwOY13w-1; Mon, 02 May 2022 00:39:15 -0400
X-MC-Unique: c7E1g9usNkK-N2BJwOY13w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F37D1018AA4;
	Mon,  2 May 2022 04:39:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 641A42024CCE;
	Mon,  2 May 2022 04:39:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2548B194705F;
	Mon,  2 May 2022 04:39:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 06A82194705E
 for <dm-devel@listman.corp.redhat.com>; Mon,  2 May 2022 04:39:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E971CC52C85; Mon,  2 May 2022 04:39:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E5C44C52C82
 for <dm-devel@redhat.com>; Mon,  2 May 2022 04:39:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC3388002B2
 for <dm-devel@redhat.com>; Mon,  2 May 2022 04:39:09 +0000 (UTC)
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au
 [211.29.132.249]) by relay.mimecast.com with ESMTP id
 us-mta-294-Q6M6B0DEPH6hpJ9xDKIahQ-1; Mon, 02 May 2022 00:39:08 -0400
X-MC-Unique: Q6M6B0DEPH6hpJ9xDKIahQ-1
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au
 [49.181.2.147])
 by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 71FEB10E608C;
 Mon,  2 May 2022 14:09:53 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
 (envelope-from <david@fromorbit.com>)
 id 1nlNNf-006zFQ-FJ; Mon, 02 May 2022 14:09:51 +1000
Date: Mon, 2 May 2022 14:09:51 +1000
From: Dave Chinner <david@fromorbit.com>
To: Nitesh Shetty <nj.shetty@samsung.com>
Message-ID: <20220502040951.GC1360180@dread.disaster.area>
References: <CGME20220426101804epcas5p4a0a325d3ce89e868e4924bbdeeba6d15@epcas5p4.samsung.com>
 <20220426101241.30100-1-nj.shetty@samsung.com>
 <6a85e8c8-d9d1-f192-f10d-09052703c99a@opensource.wdc.com>
 <20220427124951.GA9558@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220427124951.GA9558@test-zns>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=626f5993
 a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
 a=IkcTkHD0fZMA:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
 a=ldjz8t_eVu9c6UoTg2wA:9 a=QEXdDO2ut3YA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v4 00/10] Add Copy offload support
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
Cc: linux-scsi@vger.kernel.org,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org, nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBBcHIgMjcsIDIwMjIgYXQgMDY6MTk6NTFQTSArMDUzMCwgTml0ZXNoIFNoZXR0eSB3
cm90ZToKPiBPIFdlZCwgQXByIDI3LCAyMDIyIGF0IDExOjE5OjQ4QU0gKzA5MDAsIERhbWllbiBM
ZSBNb2FsIHdyb3RlOgo+ID4gT24gNC8yNi8yMiAxOToxMiwgTml0ZXNoIFNoZXR0eSB3cm90ZToK
PiA+ID4gVGhlIHBhdGNoIHNlcmllcyBjb3ZlcnMgdGhlIHBvaW50cyBkaXNjdXNzZWQgaW4gTm92
ZW1iZXIgMjAyMSB2aXJ0dWFsIGNhbGwKPiA+ID4gW0xTRi9NTS9CRlAgVE9QSUNdIFN0b3JhZ2U6
IENvcHkgT2ZmbG9hZFswXS4KPiA+ID4gV2UgaGF2ZSBjb3ZlcmVkIHRoZSBJbml0aWFsIGFncmVl
ZCByZXF1aXJlbWVudHMgaW4gdGhpcyBwYXRjaHNldC4KPiA+ID4gUGF0Y2hzZXQgYm9ycm93cyBN
aWt1bGFzJ3MgdG9rZW4gYmFzZWQgYXBwcm9hY2ggZm9yIDIgYmRldgo+ID4gPiBpbXBsZW1lbnRh
dGlvbi4KPiA+ID4gCj4gPiA+IE92ZXJhbGwgc2VyaWVzIHN1cHBvcnRzIOKAkwo+ID4gPiAKPiA+
ID4gMS4gRHJpdmVyCj4gPiA+IC0gTlZNZSBDb3B5IGNvbW1hbmQgKHNpbmdsZSBOUyksIGluY2x1
ZGluZyBzdXBwb3J0IGluIG52bWUtdGFyZ2V0IChmb3IKPiA+ID4gICAgIGJsb2NrIGFuZCBmaWxl
IGJhY2tlbmQpCj4gPiAKPiA+IEl0IHdvdWxkIGFsc28gYmUgbmljZSB0byBoYXZlIGNvcHkgb2Zm
bG9hZCBlbXVsYXRpb24gaW4gbnVsbF9ibGsgZm9yIHRlc3RpbmcuCj4gPgo+IAo+IFdlIGNhbiBw
bGFuIHRoaXMgaW4gbmV4dCBwaGFzZSBvZiBjb3B5IHN1cHBvcnQsIG9uY2UgdGhpcyBzZXJpZXMg
c2V0dGxlcyBkb3duLgoKV2h5IG5vdCBqdXN0IGhvb2sgdGhlIGxvb3BiYWNrIGRyaXZlciB1cCB0
byBjb3B5X2ZpbGVfcmFuZ2UoKSBzbwp0aGF0IHRoZSBiYWNrZW5kIGZpbGVzeXN0ZW0gY2FuIGp1
c3QgcmVmbGluayBjb3B5IHRoZSByYW5nZXMgYmVpbmcKcGFzc2VkPyBUaGF0IHdvdWxkIGVuYWJs
ZSB0ZXN0aW5nIG9uIGJ0cmZzLCBYRlMgYW5kIE5GU3Y0LjIgaG9zdGVkCmltYWdlIGZpbGVzIHdp
dGhvdXQgbmVlZGluZyBhbnkgc3BlY2lhbCBibG9jayBkZXZpY2Ugc2V0dXAgYXQgYWxsLi4uCgpp
LmUuIEkgdGhpbmsgeW91J3JlIGRvaW5nIHRoaXMgY29tcGVsdGVseSBiYWNrd2FyZHMgYnkgdHJ5
aW5nIHRvCnRhcmdldCBub24tZXhpc3RlbnQgaGFyZHdhcmUgZmlyc3QuLi4uCgpDaGVlcnMsCgpE
YXZlLgotLSAKRGF2ZSBDaGlubmVyCmRhdmlkQGZyb21vcmJpdC5jb20KCi0tCmRtLWRldmVsIG1h
aWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

