Return-Path: <SRS0=kRAg=EI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA10C388F2
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 07:58:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BA54921556
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 07:58:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA54921556
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-KlEL2ebrM6ec3L8rK5bDvA-1; Mon, 02 Nov 2020 02:58:39 -0500
X-MC-Unique: KlEL2ebrM6ec3L8rK5bDvA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2047C1006C98;
	Mon,  2 Nov 2020 07:58:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 03DE460C15;
	Mon,  2 Nov 2020 07:58:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D15C58C7AF;
	Mon,  2 Nov 2020 07:58:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A1MQh7D029354 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 1 Nov 2020 17:26:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 478281111C72; Sun,  1 Nov 2020 22:26:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 43DF51111C6F
	for <dm-devel@redhat.com>; Sun,  1 Nov 2020 22:26:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2827B80088F
	for <dm-devel@redhat.com>; Sun,  1 Nov 2020 22:26:40 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-196-0fR7FBpIP7eQSa00PfxrdQ-1;
	Sun, 01 Nov 2020 17:26:37 -0500
X-MC-Unique: 0fR7FBpIP7eQSa00PfxrdQ-1
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 449EF20B9C34;
	Sun,  1 Nov 2020 14:26:36 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 449EF20B9C34
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: zohar@linux.ibm.com, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
Date: Sun,  1 Nov 2020 14:26:21 -0800
Message-Id: <20201101222626.6111-3-tusharsu@linux.microsoft.com>
In-Reply-To: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
References: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0A1MQh7D029354
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 02 Nov 2020 02:58:01 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: [dm-devel] [PATCH v5 2/7] IMA: update process_buffer_measurement to
	measure buffer hash
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

cHJvY2Vzc19idWZmZXJfbWVhc3VyZW1lbnQoKSBjdXJyZW50bHkgb25seSBtZWFzdXJlcyB0aGUg
aW5wdXQgYnVmZmVyLgpJbiBjYXNlIG9mIFNlTGludXggcG9saWN5IG1lYXN1cmVtZW50LCB0aGUg
cG9saWN5IGJlaW5nIG1lYXN1cmVkIGNvdWxkCmJlIGxhcmdlIChzZXZlcmFsIE1CKS4gVGhpcyBt
YXkgcmVzdWx0IGluIGEgbGFyZ2UgZW50cnkgaW4gSU1BCm1lYXN1cmVtZW50IGxvZy4KCkludHJv
ZHVjZSBhIGJvb2xlYW4gcGFyYW1ldGVyIG1lYXN1cmVfYnVmX2hhc2ggdG8gc3VwcG9ydCBtZWFz
dXJpbmcKaGFzaCBvZiBhIGJ1ZmZlciwgd2hpY2ggd291bGQgYmUgbXVjaCBzbWFsbGVyLCBpbnN0
ZWFkIG9mIHRoZSBidWZmZXIKaXRzZWxmLgoKVG8gdXNlIHRoZSBmdW5jdGlvbmFsaXR5IGludHJv
ZHVjZWQgaW4gdGhpcyBwYXRjaCwgdGhlIGF0dGVzdGF0aW9uCmNsaWVudCBhbmQgdGhlIHNlcnZl
ciBjaGFuZ2VzIG5lZWQgdG8gZ28gaGFuZCBpbiBoYW5kLiBUaGUKY2xpZW50L2tlcm5lbCB3b3Vs
ZCBrbm93IHdoYXQgZGF0YSBpcyBiZWluZyBtZWFzdXJlZCBhcy1pcwooZS5nLiBLRVhFQ19DTURM
SU5FKSwgYW5kIHdoYXQgZGF0YSBoYXMgaXTigJlzIGhhc2ggbWVhc3VyZWQgKGUuZy4gU2VMaW51
eApQb2xpY3kpLiBBbmQgdGhlIGF0dGVzdGF0aW9uIHNlcnZlciBzaG91bGQgdmVyaWZ5IGRhdGEv
aGFzaCBhY2NvcmRpbmdseS4KCkp1c3QgbGlrZSB0aGUgZGF0YSBiZWluZyBtZWFzdXJlZCBpbiBv
dGhlciBjYXNlcywgdGhlIGF0dGVzdGF0aW9uIHNlcnZlcgp3aWxsIGtub3cgd2hhdCBhcmUgcG9z
c2libGUgdmFsdWVzIG9mIHRoZSBsYXJnZSBidWZmZXJzIGJlaW5nIG1lYXN1cmVkLgplLmcuIHRo
ZSBwb3NzaWJsZSB2YWxpZCBTZUxpbnV4IHBvbGljeSB2YWx1ZXMgdGhhdCBhcmUgYmVpbmcgcHVz
aGVkIHRvCnRoZSBjbGllbnQuIFRoZSBhdHRlc3RhdGlvbiBzZXJ2ZXIgd2lsbCBoYXZlIHRvIG1h
aW50YWluIHRoZSBoYXNoIG9mCnRob3NlIGJ1ZmZlciB2YWx1ZXMuCgpTaWduZWQtb2ZmLWJ5OiBU
dXNoYXIgU3VnYW5kaGkgPHR1c2hhcnN1QGxpbnV4Lm1pY3Jvc29mdC5jb20+Ci0tLQogc2VjdXJp
dHkvaW50ZWdyaXR5L2ltYS9pbWEuaCAgICAgICAgICAgICAgICAgfCAgMyArKy0KIHNlY3VyaXR5
L2ludGVncml0eS9pbWEvaW1hX2FwcHJhaXNlLmMgICAgICAgIHwgIDIgKy0KIHNlY3VyaXR5L2lu
dGVncml0eS9pbWEvaW1hX2FzeW1tZXRyaWNfa2V5cy5jIHwgIDIgKy0KIHNlY3VyaXR5L2ludGVn
cml0eS9pbWEvaW1hX21haW4uYyAgICAgICAgICAgIHwgMjUgKysrKysrKysrKysrKysrKysrLS0K
IHNlY3VyaXR5L2ludGVncml0eS9pbWEvaW1hX3F1ZXVlX2tleXMuYyAgICAgIHwgIDMgKystCiA1
IGZpbGVzIGNoYW5nZWQsIDI5IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvc2VjdXJpdHkvaW50ZWdyaXR5L2ltYS9pbWEuaCBiL3NlY3VyaXR5L2ludGVncml0eS9p
bWEvaW1hLmgKaW5kZXggODg3NTA4NWRiNjg5Li4wZjc3ZTBiNjk3YTMgMTAwNjQ0Ci0tLSBhL3Nl
Y3VyaXR5L2ludGVncml0eS9pbWEvaW1hLmgKKysrIGIvc2VjdXJpdHkvaW50ZWdyaXR5L2ltYS9p
bWEuaApAQCAtMjY3LDcgKzI2Nyw4IEBAIHZvaWQgaW1hX3N0b3JlX21lYXN1cmVtZW50KHN0cnVj
dCBpbnRlZ3JpdHlfaWludF9jYWNoZSAqaWludCwgc3RydWN0IGZpbGUgKmZpbGUsCiAJCQkgICBz
dHJ1Y3QgaW1hX3RlbXBsYXRlX2Rlc2MgKnRlbXBsYXRlX2Rlc2MpOwogdm9pZCBwcm9jZXNzX2J1
ZmZlcl9tZWFzdXJlbWVudChzdHJ1Y3QgaW5vZGUgKmlub2RlLCBjb25zdCB2b2lkICpidWYsIGlu
dCBzaXplLAogCQkJCWNvbnN0IGNoYXIgKmV2ZW50bmFtZSwgZW51bSBpbWFfaG9va3MgZnVuYywK
LQkJCQlpbnQgcGNyLCBjb25zdCBjaGFyICpmdW5jX2RhdGEpOworCQkJCWludCBwY3IsIGNvbnN0
IGNoYXIgKmZ1bmNfZGF0YSwKKwkJCQlib29sIG1lYXN1cmVfYnVmX2hhc2gpOwogdm9pZCBpbWFf
YXVkaXRfbWVhc3VyZW1lbnQoc3RydWN0IGludGVncml0eV9paW50X2NhY2hlICppaW50LAogCQkJ
ICAgY29uc3QgdW5zaWduZWQgY2hhciAqZmlsZW5hbWUpOwogaW50IGltYV9hbGxvY19pbml0X3Rl
bXBsYXRlKHN0cnVjdCBpbWFfZXZlbnRfZGF0YSAqZXZlbnRfZGF0YSwKZGlmZiAtLWdpdCBhL3Nl
Y3VyaXR5L2ludGVncml0eS9pbWEvaW1hX2FwcHJhaXNlLmMgYi9zZWN1cml0eS9pbnRlZ3JpdHkv
aW1hL2ltYV9hcHByYWlzZS5jCmluZGV4IDNkZDhjMmU0MzE0ZS4uYmU2NGMwYmY2MmE3IDEwMDY0
NAotLS0gYS9zZWN1cml0eS9pbnRlZ3JpdHkvaW1hL2ltYV9hcHByYWlzZS5jCisrKyBiL3NlY3Vy
aXR5L2ludGVncml0eS9pbWEvaW1hX2FwcHJhaXNlLmMKQEAgLTM0Nyw3ICszNDcsNyBAQCBpbnQg
aW1hX2NoZWNrX2JsYWNrbGlzdChzdHJ1Y3QgaW50ZWdyaXR5X2lpbnRfY2FjaGUgKmlpbnQsCiAJ
CWlmICgocmMgPT0gLUVQRVJNKSAmJiAoaWludC0+ZmxhZ3MgJiBJTUFfTUVBU1VSRSkpCiAJCQlw
cm9jZXNzX2J1ZmZlcl9tZWFzdXJlbWVudChOVUxMLCBkaWdlc3QsIGRpZ2VzdHNpemUsCiAJCQkJ
CQkgICAiYmxhY2tsaXN0ZWQtaGFzaCIsIE5PTkUsCi0JCQkJCQkgICBwY3IsIE5VTEwpOworCQkJ
CQkJICAgcGNyLCBOVUxMLCBmYWxzZSk7CiAJfQogCiAJcmV0dXJuIHJjOwpkaWZmIC0tZ2l0IGEv
c2VjdXJpdHkvaW50ZWdyaXR5L2ltYS9pbWFfYXN5bW1ldHJpY19rZXlzLmMgYi9zZWN1cml0eS9p
bnRlZ3JpdHkvaW1hL2ltYV9hc3ltbWV0cmljX2tleXMuYwppbmRleCAxYzY4YzUwMGMyNmYuLmE3
NDA5NTc5MzkzNiAxMDA2NDQKLS0tIGEvc2VjdXJpdHkvaW50ZWdyaXR5L2ltYS9pbWFfYXN5bW1l
dHJpY19rZXlzLmMKKysrIGIvc2VjdXJpdHkvaW50ZWdyaXR5L2ltYS9pbWFfYXN5bW1ldHJpY19r
ZXlzLmMKQEAgLTYwLDUgKzYwLDUgQEAgdm9pZCBpbWFfcG9zdF9rZXlfY3JlYXRlX29yX3VwZGF0
ZShzdHJ1Y3Qga2V5ICprZXlyaW5nLCBzdHJ1Y3Qga2V5ICprZXksCiAJICovCiAJcHJvY2Vzc19i
dWZmZXJfbWVhc3VyZW1lbnQoTlVMTCwgcGF5bG9hZCwgcGF5bG9hZF9sZW4sCiAJCQkJICAga2V5
cmluZy0+ZGVzY3JpcHRpb24sIEtFWV9DSEVDSywgMCwKLQkJCQkgICBrZXlyaW5nLT5kZXNjcmlw
dGlvbik7CisJCQkJICAga2V5cmluZy0+ZGVzY3JpcHRpb24sIGZhbHNlKTsKIH0KZGlmZiAtLWdp
dCBhL3NlY3VyaXR5L2ludGVncml0eS9pbWEvaW1hX21haW4uYyBiL3NlY3VyaXR5L2ludGVncml0
eS9pbWEvaW1hX21haW4uYwppbmRleCBhZTVkYTlmMzMzOWQuLjQ0ODVkODdjMGFhNSAxMDA2NDQK
LS0tIGEvc2VjdXJpdHkvaW50ZWdyaXR5L2ltYS9pbWFfbWFpbi5jCisrKyBiL3NlY3VyaXR5L2lu
dGVncml0eS9pbWEvaW1hX21haW4uYwpAQCAtNzg3LDEyICs3ODcsMTUgQEAgaW50IGltYV9wb3N0
X2xvYWRfZGF0YShjaGFyICpidWYsIGxvZmZfdCBzaXplLAogICogQGZ1bmM6IElNQSBob29rCiAg
KiBAcGNyOiBwY3IgdG8gZXh0ZW5kIHRoZSBtZWFzdXJlbWVudAogICogQGZ1bmNfZGF0YTogcHJp
dmF0ZSBkYXRhIHNwZWNpZmljIHRvIEBmdW5jLCBjYW4gYmUgTlVMTC4KKyAqIEBtZWFzdXJlX2J1
Zl9oYXNoOiBpZiBzZXQgdG8gdHJ1ZSAtIHdpbGwgbWVhc3VyZSBoYXNoIG9mIHRoZSBidWYsCisg
KiAgICAgICAgICAgICAgICAgICAgaW5zdGVhZCBvZiBidWYKICAqCiAgKiBCYXNlZCBvbiBwb2xp
Y3ksIHRoZSBidWZmZXIgaXMgbWVhc3VyZWQgaW50byB0aGUgaW1hIGxvZy4KICAqLwogdm9pZCBw
cm9jZXNzX2J1ZmZlcl9tZWFzdXJlbWVudChzdHJ1Y3QgaW5vZGUgKmlub2RlLCBjb25zdCB2b2lk
ICpidWYsIGludCBzaXplLAogCQkJCWNvbnN0IGNoYXIgKmV2ZW50bmFtZSwgZW51bSBpbWFfaG9v
a3MgZnVuYywKLQkJCQlpbnQgcGNyLCBjb25zdCBjaGFyICpmdW5jX2RhdGEpCisJCQkJaW50IHBj
ciwgY29uc3QgY2hhciAqZnVuY19kYXRhLAorCQkJCWJvb2wgbWVhc3VyZV9idWZfaGFzaCkKIHsK
IAlpbnQgcmV0ID0gMDsKIAljb25zdCBjaGFyICphdWRpdF9jYXVzZSA9ICJFTk9NRU0iOwpAQCAt
ODA3LDYgKzgxMCw4IEBAIHZvaWQgcHJvY2Vzc19idWZmZXJfbWVhc3VyZW1lbnQoc3RydWN0IGlu
b2RlICppbm9kZSwgY29uc3Qgdm9pZCAqYnVmLCBpbnQgc2l6ZSwKIAkJc3RydWN0IGltYV9kaWdl
c3RfZGF0YSBoZHI7CiAJCWNoYXIgZGlnZXN0W0lNQV9NQVhfRElHRVNUX1NJWkVdOwogCX0gaGFz
aCA9IHt9OworCWNoYXIgZGlnZXN0X2hhc2hbSU1BX01BWF9ESUdFU1RfU0laRV07CisJaW50IGhh
c2hfbGVuID0gaGFzaF9kaWdlc3Rfc2l6ZVtpbWFfaGFzaF9hbGdvXTsKIAlpbnQgdmlvbGF0aW9u
ID0gMDsKIAlpbnQgYWN0aW9uID0gMDsKIAl1MzIgc2VjaWQ7CkBAIC04NTUsNiArODYwLDIxIEBA
IHZvaWQgcHJvY2Vzc19idWZmZXJfbWVhc3VyZW1lbnQoc3RydWN0IGlub2RlICppbm9kZSwgY29u
c3Qgdm9pZCAqYnVmLCBpbnQgc2l6ZSwKIAkJZ290byBvdXQ7CiAJfQogCisJaWYgKG1lYXN1cmVf
YnVmX2hhc2gpIHsKKwkJbWVtY3B5KGRpZ2VzdF9oYXNoLCBoYXNoLmhkci5kaWdlc3QsIGhhc2hf
bGVuKTsKKworCQlyZXQgPSBpbWFfY2FsY19idWZmZXJfaGFzaChkaWdlc3RfaGFzaCwKKwkJCQkJ
ICAgaGFzaF9sZW4sCisJCQkJCSAgIGlpbnQuaW1hX2hhc2gpOworCQlpZiAocmV0IDwgMCkgewor
CQkJYXVkaXRfY2F1c2UgPSAibWVhc3VyZV9idWZfaGFzaF9lcnJvciI7CisJCQlnb3RvIG91dDsK
KwkJfQorCisJCWV2ZW50X2RhdGEuYnVmID0gZGlnZXN0X2hhc2g7CisJCWV2ZW50X2RhdGEuYnVm
X2xlbiA9IGhhc2hfbGVuOworCX0KKwogCXJldCA9IGltYV9hbGxvY19pbml0X3RlbXBsYXRlKCZl
dmVudF9kYXRhLCAmZW50cnksIHRlbXBsYXRlKTsKIAlpZiAocmV0IDwgMCkgewogCQlhdWRpdF9j
YXVzZSA9ICJhbGxvY19lbnRyeSI7CkBAIC04OTYsNyArOTE2LDggQEAgdm9pZCBpbWFfa2V4ZWNf
Y21kbGluZShpbnQga2VybmVsX2ZkLCBjb25zdCB2b2lkICpidWYsIGludCBzaXplKQogCQlyZXR1
cm47CiAKIAlwcm9jZXNzX2J1ZmZlcl9tZWFzdXJlbWVudChmaWxlX2lub2RlKGYuZmlsZSksIGJ1
Ziwgc2l6ZSwKLQkJCQkgICAia2V4ZWMtY21kbGluZSIsIEtFWEVDX0NNRExJTkUsIDAsIE5VTEwp
OworCQkJCSAgICJrZXhlYy1jbWRsaW5lIiwgS0VYRUNfQ01ETElORSwgMCwgTlVMTCwKKwkJCQkg
ICBmYWxzZSk7CiAJZmRwdXQoZik7CiB9CiAKZGlmZiAtLWdpdCBhL3NlY3VyaXR5L2ludGVncml0
eS9pbWEvaW1hX3F1ZXVlX2tleXMuYyBiL3NlY3VyaXR5L2ludGVncml0eS9pbWEvaW1hX3F1ZXVl
X2tleXMuYwppbmRleCA2OWE4NjI2YTM1YzAuLmMyZjJhZDM0ZjliNyAxMDA2NDQKLS0tIGEvc2Vj
dXJpdHkvaW50ZWdyaXR5L2ltYS9pbWFfcXVldWVfa2V5cy5jCisrKyBiL3NlY3VyaXR5L2ludGVn
cml0eS9pbWEvaW1hX3F1ZXVlX2tleXMuYwpAQCAtMTYyLDcgKzE2Miw4IEBAIHZvaWQgaW1hX3By
b2Nlc3NfcXVldWVkX2tleXModm9pZCkKIAkJCQkJCSAgIGVudHJ5LT5wYXlsb2FkX2xlbiwKIAkJ
CQkJCSAgIGVudHJ5LT5rZXlyaW5nX25hbWUsCiAJCQkJCQkgICBLRVlfQ0hFQ0ssIDAsCi0JCQkJ
CQkgICBlbnRyeS0+a2V5cmluZ19uYW1lKTsKKwkJCQkJCSAgIGVudHJ5LT5rZXlyaW5nX25hbWUs
CisJCQkJCQkgICBmYWxzZSk7CiAJCWxpc3RfZGVsKCZlbnRyeS0+bGlzdCk7CiAJCWltYV9mcmVl
X2tleV9lbnRyeShlbnRyeSk7CiAJfQotLSAKMi4xNy4xCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBs
aXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVs

