Return-Path: <SRS0=YGrs=PR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 298C3C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 29 Oct 2021 05:51:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8D5B86108F
	for <dm-devel@archiver.kernel.org>; Fri, 29 Oct 2021 05:51:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8D5B86108F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-q1ISyxXYP6W-mI7op6dmiw-1; Fri, 29 Oct 2021 01:51:22 -0400
X-MC-Unique: q1ISyxXYP6W-mI7op6dmiw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B10BE10168C0;
	Fri, 29 Oct 2021 05:51:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CB6D5F707;
	Fri, 29 Oct 2021 05:51:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 516FC1806D03;
	Fri, 29 Oct 2021 05:51:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19T5p97S001687 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 29 Oct 2021 01:51:09 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 947D04010FEC; Fri, 29 Oct 2021 05:51:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F8D840CFD0B
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 05:51:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 750BF866DF1
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 05:51:09 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-125-1HzmXEbZO8m_OvIVhn3zwA-1; Fri, 29 Oct 2021 01:51:06 -0400
X-MC-Unique: 1HzmXEbZO8m_OvIVhn3zwA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DAEDD218E0;
	Fri, 29 Oct 2021 05:51:04 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 19BF713AF5;
	Fri, 29 Oct 2021 05:51:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id JCVQA8iLe2GSVAAAMHmgww
	(envelope-from <hare@suse.de>); Fri, 29 Oct 2021 05:51:04 +0000
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	=?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier@javigon.com>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
	<PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
	<CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
	<20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
	<c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
	<20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
	<fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
	<20211008064925.oyjxbmngghr2yovr@mpHalley.local>
	<2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <ba6c099b-42bf-4c7d-a923-00e7758fc835@suse.de>
Date: Fri, 29 Oct 2021 07:51:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19T5p97S001687
X-loop: dm-devel@redhat.com
Cc: Vincent Fu <vincent.fu@samsung.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Adam Manzanares <a.manzanares@samsung.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"msnitzer@redhat.com" <msnitzer@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"hch@lst.de" <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"rwheeler@redhat.com" <rwheeler@redhat.com>
Subject: Re: [dm-devel] [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
	Offload
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTAvMjkvMjEgMjoyMSBBTSwgQ2hhaXRhbnlhIEt1bGthcm5pIHdyb3RlOgo+IE9uIDEwLzcv
MjEgMTE6NDkgUE0sIEphdmllciBHb256w6FsZXogd3JvdGU6Cj4+IEV4dGVybmFsIGVtYWlsOiBV
c2UgY2F1dGlvbiBvcGVuaW5nIGxpbmtzIG9yIGF0dGFjaG1lbnRzCj4+Cj4+Cj4+IE9uIDA2LjEw
LjIwMjEgMTA6MzMsIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToKPj4+IE9uIDEwLzYvMjEgMzowNSBB
TSwgSmF2aWVyIEdvbnrDoWxleiB3cm90ZToKPj4+PiBJIGFncmVlIHRoYXQgdGhlIHRvcGljIGlz
IGNvbXBsZXguIEhvd2V2ZXIsIHdlIGhhdmUgbm90IGJlZW4gYWJsZSB0bwo+Pj4+IGZpbmQgYSBj
bGVhciBwYXRoIGZvcndhcmQgaW4gdGhlIG1haWxpbmcgbGlzdC4KPj4+Cj4+PiBIbW0gLi4uIHJl
YWxseT8gQXQgbGVhc3QgTWFydGluIFBldGVyc2VuIGFuZCBJIGNvbnNpZGVyIGRldmljZSBtYXBw
ZXIKPj4+IHN1cHBvcnQgZXNzZW50aWFsLiBIb3cgYWJvdXQgc3RhcnRpbmcgZnJvbSBNaWt1bGFz
JyBwYXRjaCBzZXJpZXMgdGhhdAo+Pj4gc3VwcG9ydHMgdGhlIGRldmljZSBtYXBwZXI/IFNlZSBh
bHNvCj4+PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvYWxwaW5lLkxSSC4yLjAyLjIxMDgx
NzE2MzAxMjAuMzAzNjNAZmlsZTAxLmludHJhbmV0LnByb2QuaW50LnJkdTIucmVkaGF0LmNvbS8K
Pj4+Cj4gCj4gV2hlbiB3ZSBhZGQgYSBuZXcgUkVRX09QX1hYWCB3ZSBuZWVkIHRvIG1ha2Ugc3Vy
ZSBpdCB3aWxsIHdvcmsgd2l0aAo+IGRldmljZSBtYXBwZXIsIHNvIEkgYWdyZWUgd2l0aCBCYXJ0
IGFuZCBNYXJ0aW4uCj4gCj4gU3RhcnRpbmcgd2l0aCBNaWt1bGFzIHBhdGNoZXMgaXMgYSByaWdo
dCBkaXJlY3Rpb24gYXMgb2Ygbm93Li4KPiAKPj4KPj4gVGhhbmtzIGZvciB0aGUgcG9pbnRlcnMu
IFdlIGFyZSBsb29raW5nIGludG8gTWlrdWxhcycgcGF0Y2ggLSBJIGFncmVlCj4+IHRoYXQgaXQg
aXMgYSBnb29kIHN0YXJ0Lgo+Pgo+Pj4+IFdoYXQgZG8geW91IHRoaW5rIGFib3V0IGpvaW5pbmcg
dGhlIGNhbGwgdG8gdGFsayB2ZXJ5IHNwZWNpZmljIG5leHQKPj4+PiBzdGVwcyB0byBnZXQgYSBw
YXRjaHNldCB0aGF0IHdlIGNhbiBzdGFydCByZXZpZXdpbmcgaW4gZGV0YWlsLgo+Pj4KPj4+IEkg
Y2FuIGRvIHRoYXQuCj4+Cj4+IFRoYW5rcy4gSSB3aWxsIHdhaXQgdW50aWwgQ2hhaXRhbnlhJ3Mg
cmVwbHkgb24gaGlzIHF1ZXN0aW9ucy4gV2Ugd2lsbAo+PiBzdGFydCBzdWdnZXN0aW5nIHNvbWUg
ZGF0ZXMgdGhlbi4KPj4KPiAKPiBJIHRoaW5rIGF0IHRoaXMgcG9pbnQgd2UgbmVlZCB0byBhdCBs
ZWFzdCBkZWNpZGUgb24gaGF2aW5nIGEgZmlyc3QgY2FsbAo+IGZvY3VzZWQgb24gaG93IHRvIHBy
b2NlZWQgZm9yd2FyZCB3aXRoIE1pa3VsYXMgYXBwcm9hY2ggIC4uLgo+IAo+IEphdmllciwgY2Fu
IHlvdSBwbGVhc2Ugb3JnYW5pemUgYSBjYWxsIHdpdGggcGVvcGxlIHlvdSBsaXN0ZWQgaW4gdGhp
cwo+IHRocmVhZCBlYXJsaWVyID8KPiAKQWxzbyBLZWl0aCBwcmVzZW50ZWQgaGlzIHdvcmsgb24g
YSBzaW1wbGUgem9uZS1iYXNlZCByZW1hcHBpbmcgYmxvY2sgCmRldmljZSwgd2hpY2ggaW5jbHVk
ZWQgYW4gaW4ta2VybmVsIGNvcHkgb2ZmbG9hZCBmYWNpbGl0eS4KSWRlYSBpcyB0byBsaWZ0IHRo
YXQgYXMgYSBzdGFuZGFsb25lIHBhdGNoIHN1Y2ggdGhhdCB3ZSBjYW4gdXNlIGl0IGEgCmZhbGxi
YWNrIChpZSBzb2Z0d2FyZSkgaW1wbGVtZW50YXRpb24gaWYgbm8gb3RoZXIgY29weSBvZmZsb2Fk
IG1lY2hhbmlzbSAKaXMgYXZhaWxhYmxlLgoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4gSGFubmVz
IFJlaW5lY2tlICAgICAgICAgICAgICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hpdGVjdApoYXJlQHN1
c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNF
IFNvZnR3YXJlIFNvbHV0aW9ucyBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcK
SFJCIDM2ODA5IChBRyBOw7xybmJlcmcpLCBHZXNjaMOkZnRzZsO8aHJlcjogRmVsaXggSW1lbmTD
tnJmZmVyCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0
cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

