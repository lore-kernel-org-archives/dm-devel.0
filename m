Return-Path: <SRS0=voF8=GZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A2FC433E6
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jan 2021 08:51:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A64AD239D4
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jan 2021 08:51:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A64AD239D4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-hMVxQH9bM3q2908nHOAIiA-1; Fri, 22 Jan 2021 03:51:35 -0500
X-MC-Unique: hMVxQH9bM3q2908nHOAIiA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DAA61800D41;
	Fri, 22 Jan 2021 08:51:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 766095D9E8;
	Fri, 22 Jan 2021 08:51:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3E2214E58E;
	Fri, 22 Jan 2021 08:51:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10M8jXT4016162 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 22 Jan 2021 03:45:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8F830E779A; Fri, 22 Jan 2021 08:45:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A8E4E7793
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 08:45:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DC4482DFE3
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 08:45:31 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de
	[85.220.165.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-601-TGC55G04Peu2eM8naWD5Mg-1; Fri, 22 Jan 2021 03:45:29 -0500
X-MC-Unique: TGC55G04Peu2eM8naWD5Mg-1
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
	by metis.ext.pengutronix.de with esmtps
	(TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
	(envelope-from <afa@pengutronix.de>)
	id 1l2s2s-00061d-GP; Fri, 22 Jan 2021 09:43:54 +0100
Received: from afa by dude.hi.pengutronix.de with local (Exim 4.92)
	(envelope-from <afa@pengutronix.de>)
	id 1l2s2r-0006HR-PH; Fri, 22 Jan 2021 09:43:53 +0100
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com, Song Liu <song@kernel.org>
Date: Fri, 22 Jan 2021 09:43:21 +0100
Message-Id: <20210122084321.24012-2-a.fatoum@pengutronix.de>
In-Reply-To: <20210122084321.24012-1-a.fatoum@pengutronix.de>
References: <20210122084321.24012-1-a.fatoum@pengutronix.de>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: afa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de);
	SAEximRunCond expanded to false
X-PTX-Original-Recipient: dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 22 Jan 2021 03:51:25 -0500
Cc: Ahmad Fatoum <a.fatoum@pengutronix.de>,
	=?UTF-8?q?Jan=20L=C3=BCbbe?= <jlu@pengutronix.de>,
	Jonathan Corbet <corbet@lwn.net>, Dmitry Baryshkov <dbaryshkov@gmail.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, keyrings@vger.kernel.org,
	kernel@pengutronix.de, linux-integrity@vger.kernel.org
Subject: [dm-devel] [PATCH 2/2] dm crypt: support using trusted keys
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

Q29tbWl0IDI3ZjU0MTFhNzE4YyAoImRtIGNyeXB0OiBzdXBwb3J0IHVzaW5nIGVuY3J5cHRlZCBr
ZXlzIikgZXh0ZW5kZWQKZG0tY3J5cHQgdG8gYWxsb3cgdXNlIG9mICJlbmNyeXB0ZWQiIGtleXMg
YWxvbmcgd2l0aCAidXNlciIgYW5kICJsb2dvbiIuCgpBbG9uZyB0aGUgc2FtZSBsaW5lcywgdGVh
Y2ggZG0tY3J5cHQgdG8gc3VwcG9ydCAidHJ1c3RlZCIga2V5cyBhcyB3ZWxsLgoKU2lnbmVkLW9m
Zi1ieTogQWhtYWQgRmF0b3VtIDxhLmZhdG91bUBwZW5ndXRyb25peC5kZT4KLS0tClVuc3VyZSBv
biB3aGV0aGVyIHRhcmdldF90eXBlOjp2ZXJzaW9uIGlzIHNvbWV0aGluZyBhdXRob3JzIGluY3Jl
bWVudCBvcgptYWludGFpbmVycyBmaXggdXAuIEkgY2FuIHJlc3BpbiBpZiBuZWVkZWQuCgpDYzog
SmFuIEzDvGJiZSA8amx1QHBlbmd1dHJvbml4LmRlPgpDYzogbGludXgtaW50ZWdyaXR5QHZnZXIu
a2VybmVsLm9yZwpDYzoga2V5cmluZ3NAdmdlci5rZXJuZWwub3JnCkNjOiBEbWl0cnkgQmFyeXNo
a292IDxkYmFyeXNoa292QGdtYWlsLmNvbT4KLS0tCiAuLi4vYWRtaW4tZ3VpZGUvZGV2aWNlLW1h
cHBlci9kbS1jcnlwdC5yc3QgICAgfCAgMiArLQogZHJpdmVycy9tZC9LY29uZmlnICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHwgIDEgKwogZHJpdmVycy9tZC9kbS1jcnlwdC5jICAgICAgICAg
ICAgICAgICAgICAgICAgIHwgMjMgKysrKysrKysrKysrKysrKysrLQogMyBmaWxlcyBjaGFuZ2Vk
LCAyNCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL0RvY3VtZW50
YXRpb24vYWRtaW4tZ3VpZGUvZGV2aWNlLW1hcHBlci9kbS1jcnlwdC5yc3QgYi9Eb2N1bWVudGF0
aW9uL2FkbWluLWd1aWRlL2RldmljZS1tYXBwZXIvZG0tY3J5cHQucnN0CmluZGV4IDFhNjc1M2I3
NmRiYi4uYWEyZDA0ZDk1ZGY2IDEwMDY0NAotLS0gYS9Eb2N1bWVudGF0aW9uL2FkbWluLWd1aWRl
L2RldmljZS1tYXBwZXIvZG0tY3J5cHQucnN0CisrKyBiL0RvY3VtZW50YXRpb24vYWRtaW4tZ3Vp
ZGUvZGV2aWNlLW1hcHBlci9kbS1jcnlwdC5yc3QKQEAgLTY3LDcgKzY3LDcgQEAgUGFyYW1ldGVy
czo6CiAgICAgdGhlIHZhbHVlIHBhc3NlZCBpbiA8a2V5X3NpemU+LgogCiA8a2V5X3R5cGU+Ci0g
ICAgRWl0aGVyICdsb2dvbicsICd1c2VyJyBvciAnZW5jcnlwdGVkJyBrZXJuZWwga2V5IHR5cGUu
CisgICAgRWl0aGVyICdsb2dvbicsICd1c2VyJywgJ2VuY3J5cHRlZCcgb3IgJ3RydXN0ZWQnIGtl
cm5lbCBrZXkgdHlwZS4KIAogPGtleV9kZXNjcmlwdGlvbj4KICAgICBUaGUga2VybmVsIGtleXJp
bmcga2V5IGRlc2NyaXB0aW9uIGNyeXB0IHRhcmdldCBzaG91bGQgbG9vayBmb3IKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbWQvS2NvbmZpZyBiL2RyaXZlcnMvbWQvS2NvbmZpZwppbmRleCA5ZTQ0YzA5
ZjY0MTAuLmYyMDE0Mzg1ZDQ4YiAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZC9LY29uZmlnCisrKyBi
L2RyaXZlcnMvbWQvS2NvbmZpZwpAQCAtMjcwLDYgKzI3MCw3IEBAIGNvbmZpZyBETV9DUllQVAog
CXRyaXN0YXRlICJDcnlwdCB0YXJnZXQgc3VwcG9ydCIKIAlkZXBlbmRzIG9uIEJMS19ERVZfRE0K
IAlkZXBlbmRzIG9uIChFTkNSWVBURURfS0VZUyB8fCBFTkNSWVBURURfS0VZUz1uKQorCWRlcGVu
ZHMgb24gKFRSVVNURURfS0VZUyB8fCBUUlVTVEVEX0tFWVM9bikKIAlzZWxlY3QgQ1JZUFRPCiAJ
c2VsZWN0IENSWVBUT19DQkMKIAlzZWxlY3QgQ1JZUFRPX0VTU0lWCmRpZmYgLS1naXQgYS9kcml2
ZXJzL21kL2RtLWNyeXB0LmMgYi9kcml2ZXJzL21kL2RtLWNyeXB0LmMKaW5kZXggN2VlYjkyNDhl
ZGE1Li42YzdjNjg3ZTU0NmMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQvZG0tY3J5cHQuYworKysg
Yi9kcml2ZXJzL21kL2RtLWNyeXB0LmMKQEAgLTM3LDYgKzM3LDcgQEAKICNpbmNsdWRlIDxsaW51
eC9rZXktdHlwZS5oPgogI2luY2x1ZGUgPGtleXMvdXNlci10eXBlLmg+CiAjaW5jbHVkZSA8a2V5
cy9lbmNyeXB0ZWQtdHlwZS5oPgorI2luY2x1ZGUgPGtleXMvdHJ1c3RlZC10eXBlLmg+CiAKICNp
bmNsdWRlIDxsaW51eC9kZXZpY2UtbWFwcGVyLmg+CiAKQEAgLTI0NTIsNiArMjQ1MywyMiBAQCBz
dGF0aWMgaW50IHNldF9rZXlfZW5jcnlwdGVkKHN0cnVjdCBjcnlwdF9jb25maWcgKmNjLCBzdHJ1
Y3Qga2V5ICprZXkpCiAJcmV0dXJuIDA7CiB9CiAKK3N0YXRpYyBpbnQgc2V0X2tleV90cnVzdGVk
KHN0cnVjdCBjcnlwdF9jb25maWcgKmNjLCBzdHJ1Y3Qga2V5ICprZXkpCit7CisJY29uc3Qgc3Ry
dWN0IHRydXN0ZWRfa2V5X3BheWxvYWQgKnRrcDsKKworCXRrcCA9IGtleS0+cGF5bG9hZC5kYXRh
WzBdOworCWlmICghdGtwKQorCQlyZXR1cm4gLUVLRVlSRVZPS0VEOworCisJaWYgKGNjLT5rZXlf
c2l6ZSAhPSB0a3AtPmtleV9sZW4pCisJCXJldHVybiAtRUlOVkFMOworCisJbWVtY3B5KGNjLT5r
ZXksIHRrcC0+a2V5LCBjYy0+a2V5X3NpemUpOworCisJcmV0dXJuIDA7Cit9CisKIHN0YXRpYyBp
bnQgY3J5cHRfc2V0X2tleXJpbmdfa2V5KHN0cnVjdCBjcnlwdF9jb25maWcgKmNjLCBjb25zdCBj
aGFyICprZXlfc3RyaW5nKQogewogCWNoYXIgKm5ld19rZXlfc3RyaW5nLCAqa2V5X2Rlc2M7CkBA
IC0yNDg0LDYgKzI1MDEsMTAgQEAgc3RhdGljIGludCBjcnlwdF9zZXRfa2V5cmluZ19rZXkoc3Ry
dWN0IGNyeXB0X2NvbmZpZyAqY2MsIGNvbnN0IGNoYXIgKmtleV9zdHJpbmcKIAkJICAgIXN0cm5j
bXAoa2V5X3N0cmluZywgImVuY3J5cHRlZDoiLCBrZXlfZGVzYyAtIGtleV9zdHJpbmcgKyAxKSkg
ewogCQl0eXBlID0gJmtleV90eXBlX2VuY3J5cHRlZDsKIAkJc2V0X2tleSA9IHNldF9rZXlfZW5j
cnlwdGVkOworCX0gZWxzZSBpZiAoSVNfRU5BQkxFRChDT05GSUdfVFJVU1RFRF9LRVlTKSAmJgor
CSAgICAgICAgICAgIXN0cm5jbXAoa2V5X3N0cmluZywgInRydXN0ZWQ6Iiwga2V5X2Rlc2MgLSBr
ZXlfc3RyaW5nICsgMSkpIHsKKwkJdHlwZSA9ICZrZXlfdHlwZV90cnVzdGVkOworCQlzZXRfa2V5
ID0gc2V0X2tleV90cnVzdGVkOwogCX0gZWxzZSB7CiAJCXJldHVybiAtRUlOVkFMOwogCX0KQEAg
LTM1NTUsNyArMzU3Niw3IEBAIHN0YXRpYyB2b2lkIGNyeXB0X2lvX2hpbnRzKHN0cnVjdCBkbV90
YXJnZXQgKnRpLCBzdHJ1Y3QgcXVldWVfbGltaXRzICpsaW1pdHMpCiAKIHN0YXRpYyBzdHJ1Y3Qg
dGFyZ2V0X3R5cGUgY3J5cHRfdGFyZ2V0ID0gewogCS5uYW1lICAgPSAiY3J5cHQiLAotCS52ZXJz
aW9uID0gezEsIDIyLCAwfSwKKwkudmVyc2lvbiA9IHsxLCAyMywgMH0sCiAJLm1vZHVsZSA9IFRI
SVNfTU9EVUxFLAogCS5jdHIgICAgPSBjcnlwdF9jdHIsCiAJLmR0ciAgICA9IGNyeXB0X2R0ciwK
LS0gCjIuMzAuMAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20K
aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

