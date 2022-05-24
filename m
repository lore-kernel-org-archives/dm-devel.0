Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F706C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 24 May 2022 05:19:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-529-LuQvlm41PlWrhVKQ_QQYvQ-1; Tue, 24 May 2022 01:19:42 -0400
X-MC-Unique: LuQvlm41PlWrhVKQ_QQYvQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AC78380673F;
	Tue, 24 May 2022 05:19:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8208C2026D6A;
	Tue, 24 May 2022 05:19:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 57A211947BA1;
	Tue, 24 May 2022 05:19:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5EE691947068
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 May 2022 05:19:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3E7AE1400AFB; Tue, 24 May 2022 05:19:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 399F61402404
 for <dm-devel@redhat.com>; Tue, 24 May 2022 05:19:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2225B85A5B5
 for <dm-devel@redhat.com>; Tue, 24 May 2022 05:19:37 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-dJgWVefdM_yL8sHrhV8U1Q-1; Tue, 24 May 2022 01:19:28 -0400
X-MC-Unique: dJgWVefdM_yL8sHrhV8U1Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 2F2DC1F8DB;
 Tue, 24 May 2022 05:19:27 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B775713ADF;
 Tue, 24 May 2022 05:19:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id jK6VK95qjGIlGgAAMHmgww
 (envelope-from <hare@suse.de>); Tue, 24 May 2022 05:19:26 +0000
Message-ID: <a7a409dc-4cf3-7096-50f6-7f794d4a0b9b@suse.de>
Date: Tue, 24 May 2022 07:19:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
To: Pankaj Raghav <p.raghav@samsung.com>, axboe@kernel.dk, hch@lst.de,
 snitzer@redhat.com, damien.lemoal@opensource.wdc.com,
 Johannes.Thumshirn@wdc.com
References: <20220523161601.58078-1-p.raghav@samsung.com>
 <CGME20220523161606eucas1p2676c4d47f9fcb145f69b29db1f04fe6e@eucas1p2.samsung.com>
 <20220523161601.58078-3-p.raghav@samsung.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220523161601.58078-3-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v5 2/7] block: allow blk-zoned devices to
 have non-power-of-2 zone size
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
Cc: gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>, dsterba@suse.com, jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNS8yMy8yMiAxODoxNSwgUGFua2FqIFJhZ2hhdiB3cm90ZToKPiBDaGVja2luZyBpZiBhIGdp
dmVuIHNlY3RvciBpcyBhbGlnbmVkIHRvIGEgem9uZSBpcyBhIGNvbW1vbgo+IG9wZXJhdGlvbiB0
aGF0IGlzIHBlcmZvcm1lZCBmb3Igem9uZWQgZGV2aWNlcy4gQWRkCj4gYmxrX3F1ZXVlX2lzX3pv
bmVfc3RhcnQgaGVscGVyIHRvIGNoZWNrIGZvciB0aGlzIGluc3RlYWQgb2Ygb3BlbmNvZGluZyBp
dAo+IGV2ZXJ5d2hlcmUuCj4gCj4gQ29udmVydCB0aGUgY2FsY3VsYXRpb25zIG9uIHpvbmUgc2l6
ZSB0byBiZSBnZW5lcmljIGluc3RlYWQgb2YgcmVseWluZyBvbgo+IHBvd2VyX29mXzIgYmFzZWQg
bG9naWMgaW4gdGhlIGJsb2NrIGxheWVyIHVzaW5nIHRoZSBoZWxwZXJzIHdoZXJldmVyCj4gcG9z
c2libGUuCj4gCj4gVGhlIG9ubHkgaG90IHBhdGggYWZmZWN0ZWQgYnkgdGhpcyBjaGFuZ2UgZm9y
IHBvd2VyX29mXzIgem9uZWQgZGV2aWNlcwo+IGlzIGluIGJsa19jaGVja196b25lX2FwcGVuZCgp
IGJ1dCBibGtfcXVldWVfaXNfem9uZV9zdGFydCgpIGhlbHBlciBpcwo+IHVzZWQgdG8gb3B0aW1p
emUgdGhlIGNhbGN1bGF0aW9uIGZvciBwbzIgem9uZSBzaXplcy4gTm90ZSB0aGF0IHRoZSBhcHBl
bmQKPiBwYXRoIGNhbm5vdCBiZSBhY2Nlc3NlZCBieSBkaXJlY3QgcmF3IGFjY2VzcyB0byB0aGUg
YmxvY2sgZGV2aWNlIGJ1dCBvbmx5Cj4gdGhyb3VnaCBhIGZpbGVzeXN0ZW0gYWJzdHJhY3Rpb24u
Cj4gCj4gRmluYWxseSwgYWxsb3cgbm9uIHBvd2VyIG9mIDIgem9uZWQgZGV2aWNlcyBwcm92aWRl
ZCB0aGF0IHRoZWlyIHpvbmUKPiBjYXBhY2l0eSBhbmQgem9uZSBzaXplIGFyZSBlcXVhbC4gVGhl
IG1haW4gbW90aXZhdGlvbiB0byBhbGxvdyBub24KPiBwb3dlcl9vZl8yIHpvbmVkIGRldmljZSBp
cyB0byByZW1vdmUgdGhlIHVubWFwcGVkIExCQSBiZXR3ZWVuIHpjYXAgYW5kCj4genN6ZSBmb3Ig
ZGV2aWNlcyB0aGF0IGNhbm5vdCBoYXZlIGEgcG93ZXJfb2ZfMiB6Y2FwLgo+IAo+IFJldmlld2Vk
LWJ5OiBMdWlzIENoYW1iZXJsYWluIDxtY2dyb2ZAa2VybmVsLm9yZz4KPiBTaWduZWQtb2ZmLWJ5
OiBQYW5rYWogUmFnaGF2IDxwLnJhZ2hhdkBzYW1zdW5nLmNvbT4KPiAtLS0KPiAgIGJsb2NrL2Js
ay1jb3JlLmMgICAgICAgfCAgMyArLS0KPiAgIGJsb2NrL2Jsay16b25lZC5jICAgICAgfCAyNiAr
KysrKysrKysrKysrKysrKysrKy0tLS0tLQo+ICAgaW5jbHVkZS9saW51eC9ibGtkZXYuaCB8IDIx
ICsrKysrKysrKysrKysrKysrKysrKwo+ICAgMyBmaWxlcyBjaGFuZ2VkLCA0MiBpbnNlcnRpb25z
KCspLCA4IGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9ibG9jay9ibGstY29yZS5jIGIv
YmxvY2svYmxrLWNvcmUuYwo+IGluZGV4IGJjMDUwNjc3MjE1Mi4uYmYxZWFlMTQyMTE4IDEwMDY0
NAo+IC0tLSBhL2Jsb2NrL2Jsay1jb3JlLmMKPiArKysgYi9ibG9jay9ibGstY29yZS5jCj4gQEAg
LTYzMCw4ICs2MzAsNyBAQCBzdGF0aWMgaW5saW5lIGJsa19zdGF0dXNfdCBibGtfY2hlY2tfem9u
ZV9hcHBlbmQoc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsCj4gICAJCXJldHVybiBCTEtfU1RTX05P
VFNVUFA7Cj4gICAKPiAgIAkvKiBUaGUgYmlvIHNlY3RvciBtdXN0IHBvaW50IHRvIHRoZSBzdGFy
dCBvZiBhIHNlcXVlbnRpYWwgem9uZSAqLwo+IC0JaWYgKHBvcyAmIChibGtfcXVldWVfem9uZV9z
ZWN0b3JzKHEpIC0gMSkgfHwKPiAtCSAgICAhYmxrX3F1ZXVlX3pvbmVfaXNfc2VxKHEsIHBvcykp
Cj4gKwlpZiAoIWJsa19xdWV1ZV9pc196b25lX3N0YXJ0KHEsIHBvcykgfHwgIWJsa19xdWV1ZV96
b25lX2lzX3NlcShxLCBwb3MpKQo+ICAgCQlyZXR1cm4gQkxLX1NUU19JT0VSUjsKPiAgIAo+ICAg
CS8qCj4gZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay16b25lZC5jIGIvYmxvY2svYmxrLXpvbmVkLmMK
PiBpbmRleCBlN2VlYzUxM2RkNDIuLjY2NTk5M2IxMzY2OCAxMDA2NDQKPiAtLS0gYS9ibG9jay9i
bGstem9uZWQuYwo+ICsrKyBiL2Jsb2NrL2Jsay16b25lZC5jCj4gQEAgLTI4OCwxMCArMjg4LDEw
IEBAIGludCBibGtkZXZfem9uZV9tZ210KHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsIGVudW0g
cmVxX29wZiBvcCwKPiAgIAkJcmV0dXJuIC1FSU5WQUw7Cj4gICAKPiAgIAkvKiBDaGVjayBhbGln
bm1lbnQgKGhhbmRsZSBldmVudHVhbCBzbWFsbGVyIGxhc3Qgem9uZSkgKi8KPiAtCWlmIChzZWN0
b3IgJiAoem9uZV9zZWN0b3JzIC0gMSkpCj4gKwlpZiAoIWJsa19xdWV1ZV9pc196b25lX3N0YXJ0
KHEsIHNlY3RvcikpCj4gICAJCXJldHVybiAtRUlOVkFMOwo+ICAgCj4gLQlpZiAoKG5yX3NlY3Rv
cnMgJiAoem9uZV9zZWN0b3JzIC0gMSkpICYmIGVuZF9zZWN0b3IgIT0gY2FwYWNpdHkpCj4gKwlp
ZiAoIWJsa19xdWV1ZV9pc196b25lX3N0YXJ0KHEsIG5yX3NlY3RvcnMpICYmIGVuZF9zZWN0b3Ig
IT0gY2FwYWNpdHkpCj4gICAJCXJldHVybiAtRUlOVkFMOwo+ICAgCj4gICAJLyoKPiBAQCAtNDg5
LDE0ICs0ODksMjggQEAgc3RhdGljIGludCBibGtfcmV2YWxpZGF0ZV96b25lX2NiKHN0cnVjdCBi
bGtfem9uZSAqem9uZSwgdW5zaWduZWQgaW50IGlkeCwKPiAgIAkgKiBzbWFsbGVyIGxhc3Qgem9u
ZS4KPiAgIAkgKi8KPiAgIAlpZiAoem9uZS0+c3RhcnQgPT0gMCkgewo+IC0JCWlmICh6b25lLT5s
ZW4gPT0gMCB8fCAhaXNfcG93ZXJfb2ZfMih6b25lLT5sZW4pKSB7Cj4gLQkJCXByX3dhcm4oIiVz
OiBJbnZhbGlkIHpvbmVkIGRldmljZSB3aXRoIG5vbiBwb3dlciBvZiB0d28gem9uZSBzaXplICgl
bGx1KVxuIiwKPiAtCQkJCWRpc2stPmRpc2tfbmFtZSwgem9uZS0+bGVuKTsKPiArCQlpZiAoem9u
ZS0+bGVuID09IDApIHsKPiArCQkJcHJfd2FybigiJXM6IEludmFsaWQgem9uZSBzaXplIiwgZGlz
ay0+ZGlza19uYW1lKTsKPiArCQkJcmV0dXJuIC1FTk9ERVY7Cj4gKwkJfQo+ICsKPiArCQkvKgo+
ICsJCSAqIERvbid0IGFsbG93IHpvbmVkIGRldmljZSB3aXRoIG5vbiBwb3dlcl9vZl8yIHpvbmUg
c2l6ZSB3aXRoCj4gKwkJICogem9uZSBjYXBhY2l0eSBsZXNzIHRoYW4gem9uZSBzaXplLgo+ICsJ
CSAqLwo+ICsJCWlmICghaXNfcG93ZXJfb2ZfMih6b25lLT5sZW4pICYmCj4gKwkJICAgIHpvbmUt
PmNhcGFjaXR5IDwgem9uZS0+bGVuKSB7Cj4gKwkJCXByX3dhcm4oIiVzOiBJbnZhbGlkIHpvbmUg
Y2FwYWNpdHkgZm9yIG5vbiBwb3dlciBvZiAyIHpvbmUgc2l6ZSIsCj4gKwkJCQlkaXNrLT5kaXNr
X25hbWUpOwo+ICAgCQkJcmV0dXJuIC1FTk9ERVY7Cj4gICAJCX0KPiAgIAo+ICAgCQlhcmdzLT56
b25lX3NlY3RvcnMgPSB6b25lLT5sZW47Cj4gLQkJYXJncy0+bnJfem9uZXMgPSAoY2FwYWNpdHkg
KyB6b25lLT5sZW4gLSAxKSA+PiBpbG9nMih6b25lLT5sZW4pOwo+ICsJCS8qCj4gKwkJICogRGl2
aXNpb24gaXMgdXNlZCB0byBjYWxjdWxhdGUgbnJfem9uZXMgZm9yIGJvdGggcG93ZXJfb2ZfMgo+
ICsJCSAqIGFuZCBub24gcG93ZXJfb2ZfMiB6b25lIHNpemVzIGFzIGl0IGlzIG5vdCBpbiB0aGUg
aG90IHBhdGguCj4gKwkJICovCj4gKwkJYXJncy0+bnJfem9uZXMgPSBkaXY2NF91NjQoY2FwYWNp
dHkgKyB6b25lLT5sZW4gLSAxLCB6b25lLT5sZW4pOwo+ICAgCX0gZWxzZSBpZiAoem9uZS0+c3Rh
cnQgKyBhcmdzLT56b25lX3NlY3RvcnMgPCBjYXBhY2l0eSkgewo+ICAgCQlpZiAoem9uZS0+bGVu
ICE9IGFyZ3MtPnpvbmVfc2VjdG9ycykgewo+ICAgCQkJcHJfd2FybigiJXM6IEludmFsaWQgem9u
ZWQgZGV2aWNlIHdpdGggbm9uIGNvbnN0YW50IHpvbmUgc2l6ZVxuIiwKPiBkaWZmIC0tZ2l0IGEv
aW5jbHVkZS9saW51eC9ibGtkZXYuaCBiL2luY2x1ZGUvbGludXgvYmxrZGV2LmgKPiBpbmRleCBj
NGU0YzcwNzFiN2IuLmY1YzdhNDEwMzJiYSAxMDA2NDQKPiAtLS0gYS9pbmNsdWRlL2xpbnV4L2Js
a2Rldi5oCj4gKysrIGIvaW5jbHVkZS9saW51eC9ibGtkZXYuaAo+IEBAIC02NzYsNiArNjc2LDIx
IEBAIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50IGJsa19xdWV1ZV96b25lX25vKHN0cnVjdCBy
ZXF1ZXN0X3F1ZXVlICpxLAo+ICAgCXJldHVybiBkaXY2NF91NjQoc2VjdG9yLCB6b25lX3NlY3Rv
cnMpOwo+ICAgfQo+ICAgCj4gK3N0YXRpYyBpbmxpbmUgYm9vbCBibGtfcXVldWVfaXNfem9uZV9z
dGFydChzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc2VjdG9yX3Qgc2VjKQo+ICt7Cj4gKwlzZWN0
b3JfdCB6b25lX3NlY3RvcnMgPSBibGtfcXVldWVfem9uZV9zZWN0b3JzKHEpOwo+ICsJdTY0IHJl
bWFpbmRlciA9IDA7Cj4gKwo+ICsJaWYgKCFibGtfcXVldWVfaXNfem9uZWQocSkpCj4gKwkJcmV0
dXJuIGZhbHNlOwo+ICsKCk5vdCBzdXJlIGlmIHdlIG5lZWQgdGhpcyBoZXJlOyBzdXJlbHkgYmxr
X3F1ZXVlX3pvbmVfc2VjdG9ycygpIHdpbGwKYWxyZWFkeSBiYXJmLCBhbmQgbm9uZSBvZiB0aGUg
Y2FsbGVycyBkaWQgdGhpcyBjaGVjay4KCj4gKwlpZiAoaXNfcG93ZXJfb2ZfMih6b25lX3NlY3Rv
cnMpKQo+ICsJCXJldHVybiBJU19BTElHTkVEKHNlYywgem9uZV9zZWN0b3JzKTsKPiArCj4gKwlk
aXY2NF91NjRfcmVtKHNlYywgem9uZV9zZWN0b3JzLCAmcmVtYWluZGVyKTsKPiArCXJldHVybiBy
ZW1haW5kZXIgPT0gMDsKPiArfQo+ICsKPiAgIHN0YXRpYyBpbmxpbmUgYm9vbCBibGtfcXVldWVf
em9uZV9pc19zZXEoc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsCj4gICAJCQkJCSBzZWN0b3JfdCBz
ZWN0b3IpCj4gICB7Cj4gQEAgLTcyMiw2ICs3MzcsMTIgQEAgc3RhdGljIGlubGluZSB1bnNpZ25l
ZCBpbnQgYmxrX3F1ZXVlX3pvbmVfbm8oc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsCj4gICB7Cj4g
ICAJcmV0dXJuIDA7Cj4gICB9Cj4gKwo+ICtzdGF0aWMgaW5saW5lIGJvb2wgYmxrX3F1ZXVlX2lz
X3pvbmVfc3RhcnQoc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsIHNlY3Rvcl90IHNlYykKPiArewo+
ICsJcmV0dXJuIGZhbHNlOwo+ICt9Cj4gKwo+ICAgc3RhdGljIGlubGluZSB1bnNpZ25lZCBpbnQg
cXVldWVfbWF4X29wZW5fem9uZXMoY29uc3Qgc3RydWN0IHJlcXVlc3RfcXVldWUgKnEpCj4gICB7
Cj4gICAJcmV0dXJuIDA7Ck90aGVyd2lzZSBsb29rcyBnb29kLgoKQ2hlZXJzLAoKSGFubmVzCi0t
IApEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAgICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hp
dGVjdApoYXJlQHN1c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICArNDkgOTExIDc0
MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQw
OSBOw7xybmJlcmcKSFJCIDM2ODA5IChBRyBOw7xybmJlcmcpLCBHZXNjaMOkZnRzZsO8aHJlcjog
SXZvIFRvdGV2LCBBbmRyZXcKTXllcnMsIEFuZHJldyBNY0RvbmFsZCwgTWFydGplIEJvdWRpZW4g
TW9lcm1hbgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0
cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

