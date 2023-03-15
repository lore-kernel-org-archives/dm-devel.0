Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04AE1C7618B
	for <dm-devel@archiver.kernel.org>; Wed, 15 Mar 2023 16:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678898922;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sm2EuHu5IcfYejIZgwVptMiCGuj42IXb1lXn4IQMt5Q=;
	b=QIgO9CBkUuLGTVvWXgtRBI0pexDNk53xB2xojKIvTnF5U1oYLIgMa/86VrmLvqCZmHWmBX
	vfkhWubhR9pCIR/90T0dGiawXAd/9OIbEZPZdNAy+AJvU83z6gUKuDFODgssDAQNYNdKlK
	YIFQ6/GROm9oLPc1Tn2oKxgykVsCcoY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-KmPDWfOeMjCDzHAop6rYwA-1; Wed, 15 Mar 2023 12:48:38 -0400
X-MC-Unique: KmPDWfOeMjCDzHAop6rYwA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E656101A553;
	Wed, 15 Mar 2023 16:48:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9189443FBE;
	Wed, 15 Mar 2023 16:48:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 55C1619466DF;
	Wed, 15 Mar 2023 16:48:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AF7481946597
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Mar 2023 16:48:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9D74840C6E67; Wed, 15 Mar 2023 16:48:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9681C40BC797
 for <dm-devel@redhat.com>; Wed, 15 Mar 2023 16:48:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BE9D801206
 for <dm-devel@redhat.com>; Wed, 15 Mar 2023 16:48:26 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-136-iJrDxRsLMLSe6VTq4uI1eg-1; Wed,
 15 Mar 2023 12:48:22 -0400
X-MC-Unique: iJrDxRsLMLSe6VTq4uI1eg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 433751FD80;
 Wed, 15 Mar 2023 16:48:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 011FC13A00;
 Wed, 15 Mar 2023 16:48:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id LonmOdT2EWS4FQAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 15 Mar 2023 16:48:20 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 15 Mar 2023 17:48:12 +0100
Message-Id: <20230315164813.2939-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH] multipath-tools tests: use assert_true/false
 instead of assert()
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
Cc: =?UTF-8?q?Dirk=20M=C3=BCller?= <dirk@dmllr.de>, dm-devel@redhat.com,
 dmueller@suse.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

RnJvbTogRGlyayBNw7xsbGVyIDxkaXJrQGRtbGxyLmRlPgoKT3RoZXJ3aXNlIHRoZSBidWlsZCBm
YWlscyB3aXRoIHVzZXJzcGFjZS1yY3UgMC4xNCB3aXRoCgogICBlcnJvcjogaW1wbGljaXQgZGVj
bGFyYXRpb24gb2YgZnVuY3Rpb24gJ2Fzc2VydCcgWy1XZXJyb3I9aW1wbGljaXQtZnVuY3Rpb24t
ZGVjbGFyYXRpb25dCiAgIG5vdGU6ICdhc3NlcnQnIGlzIGRlZmluZWQgaW4gaGVhZGVyICc8YXNz
ZXJ0Lmg+JzsgZGlkIHlvdSBmb3JnZXQgdG8gJyNpbmNsdWRlIDxhc3NlcnQuaD4nPwoKVW50aWwg
bGlidXJjdSAwLjEzLjAsIHRoaXMgZGlkbid0IHNob3cgdXAgYXMgYSBjb21waWxlIGVycm9yLCBi
ZWNhdXNlCiJhc3NlcnQuaCIgd2FzIHB1bGxlZCBpbiB2aWEgY29uZmlnLmggLT4gdXJjdS5oLgoK
QnV0IHRoZXNlIGFzc2VydCgpIGNhbGxzIHNob3VsZCBoYXZlIGJlZW4gY21vY2thIGFzc2VydCBt
YWNyb3MKaW4gdGhlIGZpcnN0IHBsYWNlLgoKU2lnbmVkLW9mZi1ieTogRGlyayBNw7xsbGVyIDxk
aXJrQGRtbGxyLmRlPgpTaWduZWQtb2ZmLWJ5OiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNv
bT4KLS0tCiB0ZXN0cy91dGlsLmMgfCA0NCArKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQogdGVzdHMvdnBkLmMgIHwgIDIgKy0KIDIgZmlsZXMgY2hhbmdlZCwgMjIg
aW5zZXJ0aW9ucygrKSwgMjQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvdGVzdHMvdXRpbC5j
IGIvdGVzdHMvdXRpbC5jCmluZGV4IDlhZmZiMGUuLmQ2MDgzZGMgMTAwNjQ0Ci0tLSBhL3Rlc3Rz
L3V0aWwuYworKysgYi90ZXN0cy91dGlsLmMKQEAgLTE5Myw3ICsxOTMsNyBAQCBzdGF0aWMgdm9p
ZCB0ZXN0X2JpdG1hc2tfMSh2b2lkICoqc3RhdGUpCiAJZm9yIChqID0gMDsgaiA8IEJJVEFSUl9T
WjsgaisrKSB7CiAJCWZvciAoaSA9IDA7IGkgPCA2NDsgaSsrKSB7CiAJCQliID0gNjQgKiBqICsg
aTsKLQkJCWFzc2VydCghaXNfYml0X3NldF9pbl9iaXRmaWVsZChiLCBiZikpOworCQkJYXNzZXJ0
X2ZhbHNlKGlzX2JpdF9zZXRfaW5fYml0ZmllbGQoYiwgYmYpKTsKIAkJCXNldF9iaXRfaW5fYml0
ZmllbGQoYiwgYmYpOwogCQkJZm9yIChrID0gMDsgayA8IEJJVEFSUl9TWjsgaysrKSB7CiAjaWYg
MApAQCAtMjA3LDEzICsyMDcsMTMgQEAgc3RhdGljIHZvaWQgdGVzdF9iaXRtYXNrXzEodm9pZCAq
KnN0YXRlKQogCQkJfQogCQkJZm9yIChtID0gMDsgbSA8IDY0OyBtKyspCiAJCQkJaWYgKGkgPT0g
bSkKLQkJCQkJYXNzZXJ0KGlzX2JpdF9zZXRfaW5fYml0ZmllbGQoNjQgKiBqICsgbSwKLQkJCQkJ
CQkJICAgICAgYmYpKTsKKwkJCQkJYXNzZXJ0X3RydWUoaXNfYml0X3NldF9pbl9iaXRmaWVsZCg2
NCAqIGogKyBtLAorCQkJCQkJCQkJICAgYmYpKTsKIAkJCQllbHNlCi0JCQkJCWFzc2VydCghaXNf
Yml0X3NldF9pbl9iaXRmaWVsZCg2NCAqIGogKyBtLAotCQkJCQkJCQkgICAgICAgYmYpKTsKKwkJ
CQkJYXNzZXJ0X2ZhbHNlKGlzX2JpdF9zZXRfaW5fYml0ZmllbGQoNjQgKiBqICsgbSwKKwkJCQkJ
CQkJCSAgIGJmKSk7CiAJCQljbGVhcl9iaXRfaW5fYml0ZmllbGQoYiwgYmYpOwotCQkJYXNzZXJ0
KCFpc19iaXRfc2V0X2luX2JpdGZpZWxkKGIsIGJmKSk7CisJCQlhc3NlcnRfZmFsc2UoaXNfYml0
X3NldF9pbl9iaXRmaWVsZChiLCBiZikpOwogCQkJZm9yIChrID0gMDsgayA8IEJJVEFSUl9TWjsg
aysrKQogCQkJCWFzc2VydF9pbnRfZXF1YWwoYXJyW2tdLCAwVUxMKTsKIAkJfQpAQCAtMjM1LDE2
ICsyMzUsMTYgQEAgc3RhdGljIHZvaWQgdGVzdF9iaXRtYXNrXzIodm9pZCAqKnN0YXRlKQogCWZv
ciAoaiA9IDA7IGogPCBCSVRBUlJfU1o7IGorKykgewogCQlmb3IgKGkgPSAwOyBpIDwgNjQ7IGkr
KykgewogCQkJYiA9IDY0ICogaiArIGk7Ci0JCQlhc3NlcnQoIWlzX2JpdF9zZXRfaW5fYml0Zmll
bGQoYiwgYmYpKTsKKwkJCWFzc2VydF9mYWxzZShpc19iaXRfc2V0X2luX2JpdGZpZWxkKGIsIGJm
KSk7CiAJCQlzZXRfYml0X2luX2JpdGZpZWxkKGIsIGJmKTsKIAkJCWZvciAobSA9IDA7IG0gPCA2
NDsgbSsrKQogCQkJCWlmIChtIDw9IGkpCi0JCQkJCWFzc2VydChpc19iaXRfc2V0X2luX2JpdGZp
ZWxkKDY0ICogaiArIG0sCi0JCQkJCQkJCSAgICAgIGJmKSk7CisJCQkJCWFzc2VydF90cnVlKGlz
X2JpdF9zZXRfaW5fYml0ZmllbGQoNjQgKiBqICsgbSwKKwkJCQkJCQkJCSAgIGJmKSk7CiAJCQkJ
ZWxzZQotCQkJCQlhc3NlcnQoIWlzX2JpdF9zZXRfaW5fYml0ZmllbGQoNjQgKiBqICsgbSwKLQkJ
CQkJCQkJICAgICAgIGJmKSk7Ci0JCQlhc3NlcnQoaXNfYml0X3NldF9pbl9iaXRmaWVsZChiLCBi
ZikpOworCQkJCQlhc3NlcnRfZmFsc2UoaXNfYml0X3NldF9pbl9iaXRmaWVsZCg2NCAqIGogKyBt
LAorCQkJCQkJCQkJICAgIGJmKSk7CisJCQlhc3NlcnRfdHJ1ZShpc19iaXRfc2V0X2luX2JpdGZp
ZWxkKGIsIGJmKSk7CiAJCQlmb3IgKGsgPSAwOyBrIDwgQklUQVJSX1NaOyBrKyspIHsKIAkJCQlp
ZiAoayA8IGogfHwgKGsgPT0gaiAmJiBpID09IDYzKSkKIAkJCQkJYXNzZXJ0X2ludF9lcXVhbChh
cnJba10sIH4wVUxMKTsKQEAgLTI2MCwxNiArMjYwLDE2IEBAIHN0YXRpYyB2b2lkIHRlc3RfYml0
bWFza18yKHZvaWQgKipzdGF0ZSkKIAlmb3IgKGogPSAwOyBqIDwgQklUQVJSX1NaOyBqKyspIHsK
IAkJZm9yIChpID0gMDsgaSA8IDY0OyBpKyspIHsKIAkJCWIgPSA2NCAqIGogKyBpOwotCQkJYXNz
ZXJ0KGlzX2JpdF9zZXRfaW5fYml0ZmllbGQoYiwgYmYpKTsKKwkJCWFzc2VydF90cnVlKGlzX2Jp
dF9zZXRfaW5fYml0ZmllbGQoYiwgYmYpKTsKIAkJCWNsZWFyX2JpdF9pbl9iaXRmaWVsZChiLCBi
Zik7CiAJCQlmb3IgKG0gPSAwOyBtIDwgNjQ7IG0rKykKIAkJCQlpZiAobSA8PSBpKQotCQkJCQlh
c3NlcnQoIWlzX2JpdF9zZXRfaW5fYml0ZmllbGQoNjQgKiBqICsgbSwKLQkJCQkJCQkJICAgICAg
IGJmKSk7CisJCQkJCWFzc2VydF9mYWxzZShpc19iaXRfc2V0X2luX2JpdGZpZWxkKDY0ICogaiAr
IG0sCisJCQkJCQkJCQkgICAgYmYpKTsKIAkJCQllbHNlCi0JCQkJCWFzc2VydChpc19iaXRfc2V0
X2luX2JpdGZpZWxkKDY0ICogaiArIG0sCi0JCQkJCQkJCSAgICAgIGJmKSk7Ci0JCQlhc3NlcnQo
IWlzX2JpdF9zZXRfaW5fYml0ZmllbGQoYiwgYmYpKTsKKwkJCQkJYXNzZXJ0X3RydWUoaXNfYml0
X3NldF9pbl9iaXRmaWVsZCg2NCAqIGogKyBtLAorCQkJCQkJCQkJICAgYmYpKTsKKwkJCWFzc2Vy
dF9mYWxzZShpc19iaXRfc2V0X2luX2JpdGZpZWxkKGIsIGJmKSk7CiAJCQlmb3IgKGsgPSAwOyBr
IDwgQklUQVJSX1NaOyBrKyspIHsKIAkJCQlpZiAoayA8IGogfHwgKGsgPT0gaiAmJiBpID09IDYz
KSkKIAkJCQkJYXNzZXJ0X2ludF9lcXVhbChhcnJba10sIDBVTEwpOwpAQCAtMzE2LDkgKzMxNiw4
IEBAIHN0YXRpYyB2b2lkIF90ZXN0X2JpdG1hc2tfc21hbGwodW5zaWduZWQgaW50IG4pCiAJdWlu
dDMyX3QgKmFycjsKIAl1bnNpZ25lZCBpbnQgc2l6ZSA9IG1heWJlX3N3YXBfaWR4KChuIC0gMSkg
LyAzMikgKyAxLCBpOwogCi0JYXNzZXJ0KHNpemVvZihiaXRmaWVsZF90KSA9PSA0IHx8IHNpemVv
ZihiaXRmaWVsZF90KSA9PSA4KTsKLQlhc3NlcnQobiA8PSA2NCk7Ci0JYXNzZXJ0KG4gPj0gMSk7
CisJYXNzZXJ0X3RydWUoc2l6ZW9mKGJpdGZpZWxkX3QpID09IDQgfHwgc2l6ZW9mKGJpdGZpZWxk
X3QpID09IDgpOworCWFzc2VydF9pbl9yYW5nZShuLCAxLCA2NCk7CiAKIAliZiA9IGFsbG9jX2Jp
dGZpZWxkKG4pOwogCWFzc2VydF9ub25fbnVsbChiZik7CkBAIC0zNjYsOCArMzY1LDcgQEAgc3Rh
dGljIHZvaWQgX3Rlc3RfYml0bWFza19zbWFsbF8yKHVuc2lnbmVkIGludCBuKQogCXVpbnQzMl90
ICphcnI7CiAJdW5zaWduZWQgaW50IHNpemUgPSBtYXliZV9zd2FwX2lkeCgobiAtIDEpIC8gMzIp
ICsgMSwgaTsKIAotCWFzc2VydChuIDw9IDEyOCk7Ci0JYXNzZXJ0KG4gPj0gNjUpOworCWFzc2Vy
dF9pbl9yYW5nZShuLCA2NSwgMTI4KTsKIAogCWJmID0gYWxsb2NfYml0ZmllbGQobik7CiAJYXNz
ZXJ0X25vbl9udWxsKGJmKTsKZGlmZiAtLWdpdCBhL3Rlc3RzL3ZwZC5jIGIvdGVzdHMvdnBkLmMK
aW5kZXggYTdkMjA5Mi4uMWIyZDYyZCAxMDA2NDQKLS0tIGEvdGVzdHMvdnBkLmMKKysrIGIvdGVz
dHMvdnBkLmMKQEAgLTExOSw3ICsxMTksNyBAQCBzdGF0aWMgdm9pZCBoZXgyYmluKHVuc2lnbmVk
IGNoYXIgKmRzdCwgY29uc3QgY2hhciAqc3JjLAogCWNvbnN0IGNoYXIgKnNjOwogCXVuc2lnbmVk
IGNoYXIgKmRzOwogCi0JYXNzZXJ0KHNyY2xlbiAlIDIgPT0gMCk7CisJYXNzZXJ0X3RydWUoc3Jj
bGVuICUgMiA9PSAwKTsKIAlmb3IgKHNjID0gc3JjLCBkcyA9IGRzdDsKIAkgICAgIHNjIDwgc3Jj
ICsgc3JjbGVuICYmICBkcyA8IGRzdCArIGRzdGxlbjsKIAkgICAgIHNjICs9IDIsICsrZHMpCi0t
IAoyLjM5LjIKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0
dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

