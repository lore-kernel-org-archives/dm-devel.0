Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8D29C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 14:03:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-SaWB2qsxM1eBeuNkefcEBA-1; Tue, 22 Mar 2022 10:03:16 -0400
X-MC-Unique: SaWB2qsxM1eBeuNkefcEBA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 944C2382054E;
	Tue, 22 Mar 2022 14:03:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C0306400F736;
	Tue, 22 Mar 2022 14:03:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 78B571949762;
	Tue, 22 Mar 2022 14:03:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2B91E1947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 14:03:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E850EC07F4B; Tue, 22 Mar 2022 14:03:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E3FFDC090DC
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 14:03:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBA47899ED3
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 14:03:10 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-3tEIGuIUNRi-U6SPoVl7CA-1; Tue, 22 Mar 2022 10:03:06 -0400
X-MC-Unique: 3tEIGuIUNRi-U6SPoVl7CA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 123B7210E2;
 Tue, 22 Mar 2022 14:03:05 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D1B4112FC5;
 Tue, 22 Mar 2022 14:03:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id ZcjaMhjXOWI6HQAAMHmgww
 (envelope-from <hare@suse.de>); Tue, 22 Mar 2022 14:03:04 +0000
Message-ID: <306df4cf-0ee0-2b1e-044c-aed6c70122f9@suse.de>
Date: Tue, 22 Mar 2022 15:03:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
To: John Garry <john.garry@huawei.com>, Christoph Hellwig <hch@lst.de>
References: <1647945585-197349-1-git-send-email-john.garry@huawei.com>
 <1647945585-197349-2-git-send-email-john.garry@huawei.com>
 <20220322111848.GA29270@lst.de>
 <cacc3f7b-c8be-0f72-1c52-562c15b468a4@huawei.com>
 <b5df2ef1-2d6d-340e-e4b4-09132dc0516b@suse.de>
 <a5e42012-c1fc-082e-e636-594abc07dd70@huawei.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <a5e42012-c1fc-082e-e636-594abc07dd70@huawei.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMy8yMi8yMiAxMzozMCwgSm9obiBHYXJyeSB3cm90ZToKPiBPbiAyMi8wMy8yMDIyIDEyOjE2
LCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6Cj4+IE9uIDMvMjIvMjIgMTI6MzMsIEpvaG4gR2Fycnkg
d3JvdGU6Cj4+PiBPbiAyMi8wMy8yMDIyIDExOjE4LCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToK
Pj4+PiBPbiBUdWUsIE1hciAyMiwgMjAyMiBhdCAwNjozOTozNVBNICswODAwLCBKb2huIEdhcnJ5
IHdyb3RlOgo+Pj4+PiBBZGQgYW4gQVBJIHRvIGFsbG9jYXRlIGEgcmVxdWVzdCBxdWV1ZSB3aGlj
aCBhY2NlcHRzIGEgY3VzdG9tIHNldCBvZgo+Pj4+PiBibGtfbXFfb3BzIGZvciB0aGF0IHJlcXVl
c3QgcXVldWUuCj4+Pj4+Cj4+Pj4+IFRoZSByZWFzb24gd2hpY2ggd2UgbWF5IHdhbnQgY3VzdG9t
IG9wcyBpcyBmb3IgcXVldWluZyByZXF1ZXN0cyAKPj4+Pj4gd2hpY2ggd2UKPj4+Pj4gZG9uJ3Qg
d2FudCB0byBnbyB0aHJvdWdoIHRoZSBub3JtYWwgcXVldWluZyBwYXRoLgo+Pj4+Cj4+Pj4gRXd3
LsKgIEkgcmVhbGx5IGRvIG5vdCB0aGluayB3ZSBzaG91bGQgZG8gc2VwYXJhdGUgb3BzIHBlciBx
dWV1ZSwgYXMgCj4+Pj4gdGhhdAo+Pj4+IGlzIGdvaW5nIHRvIGdldCB1cyBpbnRvIGEgZGVlcCBt
ZXNzIGV2ZW50dWFsbHkuCj4+Pj4KPj4+Cj4+PiBZZWFoLi4uIHNvIGZhciAoaGVyZSkgaXQgd29y
a3Mgb3V0IHF1aXRlIG5pY2VseSwgYXMgd2UgZG9uJ3QgbmVlZCB0byAKPj4+IGNoYW5nZSB0aGUg
U0NTSSBibGsgbXEgb3BzIG5vciBhbGxvY2F0ZSBhIHNjc2lfZGV2aWNlIC0gZXZlcnl0aGluZyBp
cyAKPj4+IGp1c3Qgc2VwYXJhdGUuCj4+Pgo+Pj4gVGhlIG90aGVyIG1ldGhvZCBtZW50aW9uZWQg
cHJldmlvdXNseSB3YXMgdG8gYWRkIHRoZSByZXF1ZXN0IAo+Pj4gInJlc2VydmVkIiBmbGFnIGFu
ZCBhZGQgbmV3IHBhdGhzIGluIHNjc2lfcXVldWVfcnEoKSBldCBhbCB0byBoYW5kbGUgCj4+PiB0
aGlzLCBidXQgdGhhdCBnZXRzIG1lc3N5Lgo+Pj4KPj4+IEFueSBvdGhlciBpZGVhcyAuLi4/Cj4+
Pgo+Pgo+PiBBcyBvdXRsaW5lZCBpbiB0aGUgb3RoZXIgbWFpbCwgSSB0aGluayBtaWdodCBiZSB1
c2VmdWwgaXMgdG8gaGF2ZSBhIAo+PiBfdGhpcmRfIHR5cGUgb2YgcmVxdWVzdHMgKGluIGFkZGl0
aW9uIHRvIHRoZSBub3JtYWwgYW5kIHRoZSByZXNlcnZlZCAKPj4gb25lcykuCj4+IFRoYXQgb25l
IHdvdWxkIGJlIGFsbG9jYXRlZCBmcm9tIHRoZSBub3JtYWwgSS9PIHBvb2wgKGFuZCBoZW5jZSBj
b3VsZCAKPj4gZmFpbCBpZiB0aGUgcG9vbCBpcyBleGhhdXN0ZWQpLCBidXQgd291bGQgYmUgYWJs
ZSB0byBjYXJyeSBhIGRpZmZlcmVudCAKPj4gcGF5bG9hZCAodHlwZSkgdGhhbiB0aGUgbm9ybWFs
IHJlcXVlc3RzLgo+IAo+IEFzIG1lbnRpb25lZCBpbiB0aGUgY292ZXIgbGV0dGVyIHJlc3BvbnNl
LCBpdCBqdXN0IHNlZW1zIGJlc3QgdG8ga2VlcCAKPiB0aGUgbm9ybWFsIHNjc2lfY21uZCBwYXls
b2FkIGJ1dCBoYXZlIG90aGVyIG1lYW5zIHRvIGFkZCBvbiB0aGUgaW50ZXJuYWwgCj4gY29tbWFu
ZCBkYXRhLCBsaWtlIHVzaW5nIGhvc3Rfc2NyaWJibGUgb3Igc2NzaV9jbW5kIHByaXYgZGF0YS4K
PiAKV2VsbDsgSSBmb3VuZCB0aGF0IG1vc3QgZHJpdmVycyBJIGhhZCBiZWVuIGxvb2tpbmcgYXQg
dGhlIHNjc2kgY29tbWFuZCAKcGF5bG9hZCBpc24ndCB1c2VkIGF0IGFsbDsgdGhlIGRyaXZlcnMg
cHJpbWFyaWx5IGNhcmVkIGFib3V0IHRoZSAKKGRyaXZlci1wcm92aWRlZCkgcGF5bG9hZCwgYW5k
IHdlcmUgY29tcGxldGVseSBpZ25vcmluZyB0aGUgc2NzaSBjb21tYW5kIApwYXlsb2FkLgoKU2lt
aWxhciBmb3IgQVRBL2xpYnNhczogeW91IGJhc2ljYWxseSBuZXZlciBpc3N1ZSByZWFsIHNjc2kg
Y29tbWFuZHMsIApidXQgZWl0aGVyICdyYXcnIEFUQSByZXF1ZXN0cyBvciBTQ1NJIFRNRnMuIE5v
bmUgb2Ygd2hpY2ggYXJlIHNjc2kgCmNvbW1hbmRzLCBzbyBwcm92aWRpbmcgdGhlbSBpcyBhIGJp
dCBvZiBhIHdhc3RlLgoKKEFuZCBjYXVzZXMgaXJyaXRhdGlvbnMsIHRvbywgYXMgYSBzY3NpIGNv
bW1hbmQgcmVxdWlyZXMgYXNzb2NpYXRlZCAKcG9pbnRlcnMgbGlrZSAtPmRldmljZSBldGMgdG8g
YmUgc2V0IHVwLiBXaGljaCBtYWtlcyBpdCB0cmlja3kgdG8gdXNlIApmb3IgdGhlIGluaXRpYWwg
ZGV2aWNlIHNldHVwLikKCj4+IEFuZCB3ZSBjb3VsZCBoYXZlIGEgc2VwYXJhdGUgcXVldWVfcnEg
Zm9yIHRoZXNlIHJlcXVlc3RzLCBhcyB3ZSBjYW4gCj4+IGRpZmZlcmVudGlhdGUgdGhlbSBpbiB0
aGUgYmxvY2sgbGF5ZXIuCj4gCj4gSSBkb24ndCBrbm93LCBsZXQgbWUgdGhpbmsgYWJvdXQgaXQu
IE1heWJlIHdlIGNvdWxkIGFkZCBhbiAiaW50ZXJuYWwiIAo+IGJsayBmbGFnLCB3aGljaCB1c2Vz
IGEgc2VwYXJhdGUgImludGVybmFsIiBxdWV1ZV9ycSBjYWxsYmFjay4KPiAKWWVhaCwgdGhhdCdz
IHdoYXQgSSBoYWQgaW4gbWluZC4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWlu
ZWNrZQkJICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlCQkJ
ICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlv
bnMgR2VybWFueSBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcKSFJCIDM2ODA5
IChBRyBOw7xybmJlcmcpLCBHRjogRmVsaXggSW1lbmTDtnJmZmVyCgotLQpkbS1kZXZlbCBtYWls
aW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9t
YWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

