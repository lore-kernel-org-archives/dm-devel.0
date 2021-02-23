Return-Path: <SRS0=Sgdu=HZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9712DC433E0
	for <dm-devel@archiver.kernel.org>; Tue, 23 Feb 2021 20:23:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1711B64E4B
	for <dm-devel@archiver.kernel.org>; Tue, 23 Feb 2021 20:23:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1711B64E4B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-BGTbM4NgNAqwg8V10gc97g-1; Tue, 23 Feb 2021 15:23:06 -0500
X-MC-Unique: BGTbM4NgNAqwg8V10gc97g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E0C1107ACC7;
	Tue, 23 Feb 2021 20:23:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D56C6FEF0;
	Tue, 23 Feb 2021 20:23:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B0F1B4EA32;
	Tue, 23 Feb 2021 20:23:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11NKMx1u029900 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Feb 2021 15:22:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 418271005B62; Tue, 23 Feb 2021 20:22:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C9BF1000DAA
	for <dm-devel@redhat.com>; Tue, 23 Feb 2021 20:22:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3FDD100AFF1
	for <dm-devel@redhat.com>; Tue, 23 Feb 2021 20:22:55 +0000 (UTC)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
	[209.85.221.49]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-319-fyDJjEAfMUKBXhAx4VyUxA-1; Tue, 23 Feb 2021 15:22:21 -0500
X-MC-Unique: fyDJjEAfMUKBXhAx4VyUxA-1
Received: by mail-wr1-f49.google.com with SMTP id 7so23893215wrz.0;
	Tue, 23 Feb 2021 12:22:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references:mime-version:content-transfer-encoding;
	bh=5fh/D1A+JiA68ji7CME2QlrIQrJhB9RCBAudcPZNzck=;
	b=qmW8hwLlWkk0YvB1nsTtbuGH388fm9iFvNLWeySk8Wg19x/Bb+zZd0FQS/z/bdbP10
	UCSHvqRYQMfJFnTiZcegVlwxMkaCpp+6WYPnfggOU3ZcZz+LH47+lQsLPyiAWA7M14pD
	QjXXWbfD+y9Ua/Ae6lf+jfqxX0MAAX2twfY36Sya9garaOQ7AAcKwdvJ1mSUHtcyY3H9
	8+Sd8cYNBC02PrWHeKCAacbbwrkuEmEKNMAGgt9x1f1LCFJggu8zW5l2RC+KibZGR4ZK
	KJz7/00NrgBs9s8Y3rQjPT2tuRVSWhF5AJ5EEWcC1o2Fc5JgnOMtxB0ZxIPe2U9aRiTI
	A+Fg==
X-Gm-Message-State: AOAM5327LK3g3/KtAxEP34hux8PagUfAt52z7nO8j8uj6Na3PUeFhA9k
	4wHBLbicAKl4bes56cIjNcv92ccQKiE=
X-Google-Smtp-Source: ABdhPJx/+Ep89Sibo1iSUcyjlYpnVeP5r9e3humFdcQNG+3kFULnpLmOL4DjXQXHJopW3TUVHL4tkQ==
X-Received: by 2002:a5d:4044:: with SMTP id w4mr20003557wrp.121.1614111740229; 
	Tue, 23 Feb 2021 12:22:20 -0800 (PST)
Received: from merlot.mazyland.net (39.35.broadband4.iol.cz. [85.71.35.39])
	by smtp.googlemail.com with ESMTPSA id
	w4sm3718072wmc.13.2021.02.23.12.22.19
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 23 Feb 2021 12:22:19 -0800 (PST)
From: Milan Broz <gmazyland@gmail.com>
To: dm-devel@redhat.com
Date: Tue, 23 Feb 2021 21:21:21 +0100
Message-Id: <20210223202121.898736-2-gmazyland@gmail.com>
In-Reply-To: <20210223202121.898736-1-gmazyland@gmail.com>
References: <20210222211528.848441-1-gmazyland@gmail.com>
	<20210223202121.898736-1-gmazyland@gmail.com>
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
X-loop: dm-devel@redhat.com
Cc: stable@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Carretero?= <cJ-ko@zougloub.eu>,
	mpatocka@redhat.com, Milan Broz <gmazyland@gmail.com>,
	Sami Tolvanen <samitolvanen@google.com>
Subject: [dm-devel] [PATCH 2/2] dm-verity: Fix FEC for RS roots non-aligned
	to block size
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T3B0aW9uYWwgRm9yd2FyZCBFcnJvciBDb3JyZWN0aW9uIChGRUMpIGNvZGUgaW4gZG0tdmVyaXR5
IHVzZXMKUmVlZC1Tb2xvbW9uIGNvZGUgYW5kIHNob3VsZCBzdXBwb3J0IHJvb3RzIGZyb20gMiB0
byAyNC4KClRoZSBlcnJvciBjb3JyZWN0aW9uIHBhcml0eSBieXRlcyAob2Ygcm9vdHMgbGVuZ3Ro
cyBwZXIgUlMgYmxvY2spIGFyZSBzdG9yZWQKb24gYSBzZXBhcmF0ZSBkZXZpY2UgaW4gc2VxdWVu
Y2Ugd2l0aG91dCBhbnkgcGFkZGluZy4KCkN1cnJlbnRseSwgdG8gYWNjZXNzIEZFQyBkZXZpY2Us
IHRoZSBkbS12ZXJpdHktZmVjIGNvZGUgdXNlcyBkbS1idWZpbyBjbGllbnQKd2l0aCBibG9jayBz
aXplIHNldCB0byB2ZXJpdHkgZGF0YSBibG9jayAodXN1YWxseSA0MDk2IG9yIDUxMiBieXRlcyku
CgpCZWNhdXNlIHRoaXMgYmxvY2sgc2l6ZSBpcyBub3QgZGl2aXNpYmxlIGJ5IHNvbWUgKG1vc3Qh
KSBvZiB0aGUgcm9vdHMKc3VwcG9ydGVkIGxlbmd0aHMsIGRhdGEgcmVwYWlyIGNhbm5vdCB3b3Jr
IGZvciBwYXJ0aWFsbHkgc3RvcmVkCnBhcml0eSBieXRlcy4KClRoaXMgcGF0Y2ggY2hhbmdlcyBG
RUMgZGV2aWNlIGRtLWJ1ZmlvIGJsb2NrIHNpemUgdG8gInJvb3RzIDw8IFNFQ1RPUl9TSElGVCIK
d2hlcmUgd2UgY2FuIGJlIHN1cmUgdGhhdCB0aGUgZnVsbCBwYXJpdHkgZGF0YSBpcyBhbHdheXMg
YXZhaWxhYmxlLgooVGhlcmUgY2Fubm90IGJlIHBhcnRpYWwgRkVDIGJsb2NrcyBiZWNhdXNlIHBh
cml0eSBtdXN0IGNvdmVyIHdob2xlIHNlY3RvcnMuKQoKQmVjYXVzZSB0aGUgb3B0aW9uYWwgRkVD
IHN0YXJ0aW5nIG9mZnNldCBjb3VsZCBiZSB1bmFsaWduZWQgdG8gdGhpcwpuZXcgYmxvY2sgc2l6
ZSwgd2UgaGF2ZSB0byB1c2UgZG1fYnVmaW9fc2V0X3NlY3Rvcl9vZmZzZXQoKSB0byBjb25maWd1
cmUgaXQuCgpUaGUgcHJvYmxlbSBpcyBlYXNpbHkgcmVwcm9kdWNpYmxlIHVzaW5nIHZlcml0eXNl
dHVwLApoZXJlIGZvciBleGFtcGxlIGZvciByb290cz0xMzoKCiAgIyBjcmVhdGUgdmVyaXR5IGRl
dmljZSB3aXRoIFJTIEZFQwogIGRkIGlmPS9kZXYvdXJhbmRvbSBvZj1kYXRhLmltZyBicz00MDk2
IGNvdW50PTggc3RhdHVzPW5vbmUKICB2ZXJpdHlzZXR1cCBmb3JtYXQgZGF0YS5pbWcgaGFzaC5p
bWcgLS1mZWMtZGV2aWNlPWZlYy5pbWcgLS1mZWMtcm9vdHM9MTMgfCBhd2sgJy9eUm9vdCBoYXNo
L3sgcHJpbnQgJDMgfScgPnJvb3RoYXNoCgogICMgY3JlYXRlIGFuIGVyYXN1cmUgdGhhdCBzaG91
bGQgYmUgYWx3YXlzIHJlcGFpcmFibGUgd2l0aCB0aGlzIHJvb3RzIHNldHRpbmcKICBkZCBpZj0v
ZGV2L3plcm8gb2Y9ZGF0YS5pbWcgY29udj1ub3RydW5jIGJzPTEgY291bnQ9OCBzZWVrPTQwODgg
c3RhdHVzPW5vbmUKCiAgIyB0cnkgdG8gcmVhZCBpdCB0aHJvdWdoIGRtLXZlcml0eQogIHZlcml0
eXNldHVwIG9wZW4gZGF0YS5pbWcgdGVzdCBoYXNoLmltZyAtLWZlYy1kZXZpY2U9ZmVjLmltZyAt
LWZlYy1yb290cz0xMyAkKGNhdCByb290aGFzaCkKICBkZCBpZj0vZGV2L21hcHBlci90ZXN0IG9m
PS9kZXYvbnVsbCBicz00MDk2IHN0YXR1cz1ub3hmZXIKICAjIHdhaXQgZm9yIHBvc3NpYmxlIHJl
Y3Vyc2l2ZSByZWNvdmVyeSBpbiBrZXJuZWwKICB1ZGV2YWRtIHNldHRsZQogIHZlcml0eXNldHVw
IGNsb3NlIHRlc3QKCldpdGhvdXQgaXQsIEZFQyBjb2RlIHVzdWFsbHkgZW5kcyBvbiB1bnJlY292
ZXJhYmxlIGZhaWx1cmUgaW4gUlMgZGVjb2RlcjoKICBkZXZpY2UtbWFwcGVyOiB2ZXJpdHktZmVj
OiA3OjE6IEZFQyAwOiBmYWlsZWQgdG8gY29ycmVjdDogLTc0CiAgLi4uCgpXaXRoIHRoZSBwYXRj
aCwgZXJyb3JzIGFyZSBwcm9wZXJseSByZXBhaXJlZC4KICBkZXZpY2UtbWFwcGVyOiB2ZXJpdHkt
ZmVjOiA3OjE6IEZFQyAwOiBjb3JyZWN0ZWQgOCBlcnJvcnMKICAuLi4KClRoaXMgcHJvYmxlbSBp
cyBwcmVzZW50IGluIGFsbCBrZXJuZWxzIHNpbmNlIHRoZSBGRUMgY29kZSBpbnRyb2R1Y3Rpb24g
KGtlcm5lbCA0LjUpLgoKQUZBSUsgdGhlIHByb2JsZW0gaXMgbm90IHZpc2libGUgaW4gQW5kcm9p
ZCAgZWNvc3lzdGVtIGJlY2F1c2UgaXQgYWx3YXlzCnVzZSBkZWZhdWx0IFJTIHJvb3RzPTIuCgpT
aWduZWQtb2ZmLWJ5OiBNaWxhbiBCcm96IDxnbWF6eWxhbmRAZ21haWwuY29tPgpUZXN0ZWQtYnk6
IErDqXLDtG1lIENhcnJldGVybyA8Y0ota29Aem91Z2xvdWIuZXU+ClJldmlld2VkLWJ5OiBTYW1p
IFRvbHZhbmVuIDxzYW1pdG9sdmFuZW5AZ29vZ2xlLmNvbT4KQ2M6IHN0YWJsZUB2Z2VyLmtlcm5l
bC5vcmcKLS0tCiBkcml2ZXJzL21kL2RtLXZlcml0eS1mZWMuYyB8IDIyICsrKysrKysrKysrKy0t
LS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLXZlcml0eS1mZWMuYyBiL2RyaXZlcnMvbWQv
ZG0tdmVyaXR5LWZlYy5jCmluZGV4IGZiNDFiNGYyM2M0OC4uNjY0MDFjYTFmNjI0IDEwMDY0NAot
LS0gYS9kcml2ZXJzL21kL2RtLXZlcml0eS1mZWMuYworKysgYi9kcml2ZXJzL21kL2RtLXZlcml0
eS1mZWMuYwpAQCAtNjEsMTggKzYxLDE4IEBAIHN0YXRpYyBpbnQgZmVjX2RlY29kZV9yczgoc3Ry
dWN0IGRtX3Zlcml0eSAqdiwgc3RydWN0IGRtX3Zlcml0eV9mZWNfaW8gKmZpbywKIHN0YXRpYyB1
OCAqZmVjX3JlYWRfcGFyaXR5KHN0cnVjdCBkbV92ZXJpdHkgKnYsIHU2NCByc2IsIGludCBpbmRl
eCwKIAkJCSAgIHVuc2lnbmVkICpvZmZzZXQsIHN0cnVjdCBkbV9idWZmZXIgKipidWYpCiB7Ci0J
dTY0IHBvc2l0aW9uLCBibG9jazsKKwl1NjQgcG9zaXRpb24sIGJsb2NrLCByZW07CiAJdTggKnJl
czsKIAogCXBvc2l0aW9uID0gKGluZGV4ICsgcnNiKSAqIHYtPmZlYy0+cm9vdHM7Ci0JYmxvY2sg
PSBwb3NpdGlvbiA+PiB2LT5kYXRhX2Rldl9ibG9ja19iaXRzOwotCSpvZmZzZXQgPSAodW5zaWdu
ZWQpKHBvc2l0aW9uIC0gKGJsb2NrIDw8IHYtPmRhdGFfZGV2X2Jsb2NrX2JpdHMpKTsKKwlibG9j
ayA9IGRpdjY0X3U2NF9yZW0ocG9zaXRpb24sIHYtPmZlYy0+cm9vdHMgPDwgU0VDVE9SX1NISUZU
LCAmcmVtKTsKKwkqb2Zmc2V0ID0gKHVuc2lnbmVkKXJlbTsKIAotCXJlcyA9IGRtX2J1ZmlvX3Jl
YWQodi0+ZmVjLT5idWZpbywgdi0+ZmVjLT5zdGFydCArIGJsb2NrLCBidWYpOworCXJlcyA9IGRt
X2J1ZmlvX3JlYWQodi0+ZmVjLT5idWZpbywgYmxvY2ssIGJ1Zik7CiAJaWYgKElTX0VSUihyZXMp
KSB7CiAJCURNRVJSKCIlczogRkVDICVsbHU6IHBhcml0eSByZWFkIGZhaWxlZCAoYmxvY2sgJWxs
dSk6ICVsZCIsCiAJCSAgICAgIHYtPmRhdGFfZGV2LT5uYW1lLCAodW5zaWduZWQgbG9uZyBsb25n
KXJzYiwKLQkJICAgICAgKHVuc2lnbmVkIGxvbmcgbG9uZykodi0+ZmVjLT5zdGFydCArIGJsb2Nr
KSwKKwkJICAgICAgKHVuc2lnbmVkIGxvbmcgbG9uZylibG9jaywKIAkJICAgICAgUFRSX0VSUihy
ZXMpKTsKIAkJKmJ1ZiA9IE5VTEw7CiAJfQpAQCAtMTU1LDcgKzE1NSw3IEBAIHN0YXRpYyBpbnQg
ZmVjX2RlY29kZV9idWZzKHN0cnVjdCBkbV92ZXJpdHkgKnYsIHN0cnVjdCBkbV92ZXJpdHlfZmVj
X2lvICpmaW8sCiAKIAkJLyogcmVhZCB0aGUgbmV4dCBibG9jayB3aGVuIHdlIHJ1biBvdXQgb2Yg
cGFyaXR5IGJ5dGVzICovCiAJCW9mZnNldCArPSB2LT5mZWMtPnJvb3RzOwotCQlpZiAob2Zmc2V0
ID49IDEgPDwgdi0+ZGF0YV9kZXZfYmxvY2tfYml0cykgeworCQlpZiAob2Zmc2V0ID49IHYtPmZl
Yy0+cm9vdHMgPDwgU0VDVE9SX1NISUZUKSB7CiAJCQlkbV9idWZpb19yZWxlYXNlKGJ1Zik7CiAK
IAkJCXBhciA9IGZlY19yZWFkX3Bhcml0eSh2LCByc2IsIGJsb2NrX29mZnNldCwgJm9mZnNldCwg
JmJ1Zik7CkBAIC02NzQsNyArNjc0LDcgQEAgaW50IHZlcml0eV9mZWNfY3RyKHN0cnVjdCBkbV92
ZXJpdHkgKnYpCiB7CiAJc3RydWN0IGRtX3Zlcml0eV9mZWMgKmYgPSB2LT5mZWM7CiAJc3RydWN0
IGRtX3RhcmdldCAqdGkgPSB2LT50aTsKLQl1NjQgaGFzaF9ibG9ja3M7CisJdTY0IGhhc2hfYmxv
Y2tzLCBmZWNfYmxvY2tzOwogCWludCByZXQ7CiAKIAlpZiAoIXZlcml0eV9mZWNfaXNfZW5hYmxl
ZCh2KSkgewpAQCAtNzQ0LDE1ICs3NDQsMTcgQEAgaW50IHZlcml0eV9mZWNfY3RyKHN0cnVjdCBk
bV92ZXJpdHkgKnYpCiAJfQogCiAJZi0+YnVmaW8gPSBkbV9idWZpb19jbGllbnRfY3JlYXRlKGYt
PmRldi0+YmRldiwKLQkJCQkJICAxIDw8IHYtPmRhdGFfZGV2X2Jsb2NrX2JpdHMsCisJCQkJCSAg
Zi0+cm9vdHMgPDwgU0VDVE9SX1NISUZULAogCQkJCQkgIDEsIDAsIE5VTEwsIE5VTEwpOwogCWlm
IChJU19FUlIoZi0+YnVmaW8pKSB7CiAJCXRpLT5lcnJvciA9ICJDYW5ub3QgaW5pdGlhbGl6ZSBG
RUMgYnVmaW8gY2xpZW50IjsKIAkJcmV0dXJuIFBUUl9FUlIoZi0+YnVmaW8pOwogCX0KIAotCWlm
IChkbV9idWZpb19nZXRfZGV2aWNlX3NpemUoZi0+YnVmaW8pIDwKLQkgICAgKChmLT5zdGFydCAr
IGYtPnJvdW5kcyAqIGYtPnJvb3RzKSA+PiB2LT5kYXRhX2Rldl9ibG9ja19iaXRzKSkgeworCWRt
X2J1ZmlvX3NldF9zZWN0b3Jfb2Zmc2V0KGYtPmJ1ZmlvLCBmLT5zdGFydCA8PCAodi0+ZGF0YV9k
ZXZfYmxvY2tfYml0cyAtIFNFQ1RPUl9TSElGVCkpOworCisJZmVjX2Jsb2NrcyA9IGRpdjY0X3U2
NChmLT5yb3VuZHMgKiBmLT5yb290cywgdi0+ZmVjLT5yb290cyA8PCBTRUNUT1JfU0hJRlQpOwor
CWlmIChkbV9idWZpb19nZXRfZGV2aWNlX3NpemUoZi0+YnVmaW8pIDwgZmVjX2Jsb2Nrcykgewog
CQl0aS0+ZXJyb3IgPSAiRkVDIGRldmljZSBpcyB0b28gc21hbGwiOwogCQlyZXR1cm4gLUUyQklH
OwogCX0KLS0gCjIuMzAuMQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhh
dC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZl
bA==

