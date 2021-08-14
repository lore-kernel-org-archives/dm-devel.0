Return-Path: <SRS0=ouO8=NI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92CF7C4338F
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 07:26:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E046D60C3E
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 07:26:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E046D60C3E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=aisec.fraunhofer.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-pC4gkiEUO0CTVcKkhooKLw-1; Tue, 17 Aug 2021 03:26:29 -0400
X-MC-Unique: pC4gkiEUO0CTVcKkhooKLw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69CBD18C8C01;
	Tue, 17 Aug 2021 07:26:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 459BB1017CF5;
	Tue, 17 Aug 2021 07:26:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1989C4A7C8;
	Tue, 17 Aug 2021 07:26:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17EIYiHq016563 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 14 Aug 2021 14:34:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 622992167807; Sat, 14 Aug 2021 18:34:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BFD72167804
	for <dm-devel@redhat.com>; Sat, 14 Aug 2021 18:34:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D4558D138C
	for <dm-devel@redhat.com>; Sat, 14 Aug 2021 18:34:41 +0000 (UTC)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-551-obyOFZ6YO1upJPHlXt-x1w-1; Sat, 14 Aug 2021 14:34:37 -0400
X-MC-Unique: obyOFZ6YO1upJPHlXt-x1w-1
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
	mrelayeu.kundenserver.de (mreue010 [212.227.15.167]) with ESMTPSA
	(Nemesis)
	id 1MBlgy-1mMhBF450u-00CDbq; Sat, 14 Aug 2021 20:34:34 +0200
From: =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To: Casey Schaufler <casey@schaufler-ca.com>
Date: Sat, 14 Aug 2021 20:33:52 +0200
Message-Id: <20210814183359.4061-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
X-Provags-ID: V03:K1:upD3yRH5hFfQxAWGBD+cbK34kBXTUgHSWOzn/0o6eeF1UV6INC8
	nWPgpTusd43NAKiNW/RRkfsimIls0/5covPu+MlMNO1CgSuOgsKyCxP67wyycvX6bpXZW8j
	9ntlEWN0juSCWi5UL3LWVABcW/IB1QL8mClvRBJ8NtfMnFH31qoERcZEl9qwYdCKD8OduYI
	erw+aM7QGnaCuvKgh6J/g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:eWWgpQeMjvI=:T0Hp/BqnPHfzstvVBrwuaq
	d9wZNcguphCGb0uUPPLHkAr47mebdBJ1ENtO7PAbg+r6Chhv2q5M4BuDxrSUkVAAEGqMaZhtX
	JwJTrLwnMMWcDYGgeAW0ew+0Mh6lLGRAO5qoScBCKB/YD2sS7+W46wFW1mIhj7p8ziCkGI1cn
	zs89DeL0zb17GPxBXOu6FkJxuYXL/N6PkzsJ3LYSqNItwmXHY86BD8hnwtXCZdZ7D1gO62Qzs
	F2Vwi2qXtsWiMJwm6aQShqpCqLAJTbJSBz5bECiLDv/6aJW8jt0AqjO4IQ9en1POH3SylTJiG
	mwuRk0rxHiih5CcY/a6zh8OHtTWKPBgg38xm2RIMa/skMskrJ2EYANQPmVZsfSQaMLEXpUlbs
	FKNShznyjfCzqhIteNK74OEZxfTPsuRMD2xrL3yBdFfTTZmW5psKg5q9k8/T/noMJDW9MzVvj
	QExk+2XP/0xvGc6H4pv2tuFN3xt40y9exlHpzG+T1GGfM05CjQaI6NNsdS9c5RvZVfwpyK0+c
	0zWCyEENWVoCzN7ewNeIxQaDiKaT3a7LeFpnT5n/M7DtDv+/ZD+TL1pBOaO/792n45O44aD5W
	ummoytgWaKbeMDdKAqJ8fLf136lbDLKOAlp5y3tsrWRZfX2IeEiXz876R2qyL5g3wxLhTfpUM
	KvDc1vQEiXFutEmjN6RKvpuBdLvx1oz6v3s0weoyCbzXOEzeDzZ39h+uknhcA5ZC8dzqzSAkr
	MMnasIL/khokW7o2JUAyAAWE/JqnEK9VfxJxPb3z2B07MuJ3yFaWKbS7I9yUoGMXIr6HpjiJ7
	UqrJGoBwQzUHP4cOcT9ioEmtfpyistA47sNu8AT1dQnGWT5vcikQ/4bWNaQOQMZtxNVs4+z0g
	Vv31CrOmyEIG6jcszs1A==
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 17 Aug 2021 03:26:00 -0400
Cc: =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
	Paul Moore <paul@paul-moore.com>,
	Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
	Eric Paris <eparis@redhat.com>, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-audit@redhat.com, Alasdair Kergon <agk@redhat.com>
Subject: [dm-devel] [PATCH v2 0/3] dm: audit event logging
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

ZG0gaW50ZWdyaXR5IGFuZCBhbHNvIHN0YWNrZWQgZG0gY3J5cHQgZGV2aWNlcyB0cmFjayBpbnRl
Z3JpdHkKdmlvbGF0aW9ucyBpbnRlcm5hbGx5LiBUaHVzLCBpbnRlZ3JpdHkgdmlvbGF0aW9ucyBj
b3VsZCBiZSBwb2xsZWQKZnJvbSB1c2VyIHNwYWNlLCBlLmcuLCBieSAnaW50ZWdyaXR5c2V0dXAg
c3RhdHVzJy4KCj5Gcm9tIGFuIGF1ZGl0aW5nIHBlcnNwZWN0aXZlLCB3ZSBvbmx5IGNvdWxkIHNl
ZSB0aGF0IHRoZXJlIHdlcmUKYSBudW1iZXIgb2YgaW50ZWdyaXR5IHZpb2xhdGlvbnMsIGJ1dCBu
b3Qgd2hlbiBhbmQgd2hlcmUgdGhlCnZpb2xhdGlvbiBleGFjdGx5IHdhcyB0YWtpbmcgcGxhY2Uu
IFRoZSBjdXJyZW50IGVycm9yIGxvZyB0bwp0aGUga2VybmVsIHJpbmcgYnVmZmVyLCBjb250YWlu
cyB0aG9zZSBpbmZvcm1hdGlvbiwgdGltZSBzdGFtcCBhbmQKc2VjdG9yIG9uIGRldmljZS4gSG93
ZXZlciwgZm9yIGF1ZGl0aW5nIHRoZSBhdWRpdCBzdWJzeXN0ZW0gcHJvdmlkZXMKYSBzZXBhcmF0
ZSBsb2dnaW5nIG1lY2hhbmlzbSB3aGljaCBtZWV0cyBjZXJ0YWluIGNyaXRlcmlhIGZvciBzZWN1
cmUKYXVkaXQgbG9nZ2luZy4KCldpdGggdGhpcyBzbWFsbCBzZXJpZXMgd2UgbWFrZSB1c2Ugb2Yg
dGhlIGtlcm5lbCBhdWRpdCBmcmFtZXdvcmsKYW5kIGV4dGVuZCB0aGUgZG0gZHJpdmVyIHRvIGxv
ZyBhdWRpdCBldmVudHMgaW4gY2FzZSBvZiBzdWNoCmludGVncml0eSB2aW9sYXRpb25zLiBGdXJ0
aGVyLCB3ZSBhbHNvIGxvZyBjb25zdHJ1Y3Rpb24gYW5kCmRlc3RydWN0aW9uIG9mIHRoZSBkZXZp
Y2UgbWFwcGluZ3MuCgpXZSBmb2N1cyBvbiBkbS1pbnRlZ3JpdHkgYW5kIHN0YWNrZWQgZG0tY3J5
cHQgZGV2aWNlcyBmb3Igbm93LgpIb3dldmVyLCB0aGUgaGVscGVyIGZ1bmN0aW9ucyB0byBsb2cg
YXVkaXQgbWVzc2FnZXMgc2hvdWxkIGJlCmFwcGxpY2FibGUgdG8gZG0gdmVyaXR5IHRvby4KClRo
ZSBmaXJzdCBwYXRjaCBpbnRyb2R1Y2UgZ2VuZXJpYyBhdWRpdCB3cmFwcGVyIGZ1bmN0aW9ucy4K
VGhlIHNlY29uZCBwYXRjaCBtYWtlcyB1c2Ugb2YgdGhlIGF1ZGl0IHdyYXBwZXIgZnVuY3Rpb25z
IGluIHRoZQpkbS1pbnRlZ3JpdHkuYy4KVGhlIHRoaXJkIHBhdGNoIHVzZXMgdGhlIHdyYXBwZXIg
ZnVuY3Rpb25zIGluIGRtLWNyeXB0LmMuCgpUaGUgYXVkaXQgbG9ncyBsb29rIGxpa2UgdGhpcyBp
ZiBleGVjdXRpbmcgdGhlIGZvbGxvd2luZyBzaW1wbGUgdGVzdDoKCiMgZGQgaWY9L2Rldi96ZXJv
IG9mPXRlc3QuaW1nIGJzPTFNIGNvdW50PTEwMjQKIyBsb3NldHVwIC1mIHRlc3QuaW1nCiMgaW50
ZWdyaXR5c2V0dXAgLXZEIGZvcm1hdCAtLWludGVncml0eSBzaGEyNTYgLXQgMzIgL2Rldi9sb29w
MCAKIyBpbnRlZ3JpdHlzZXR1cCBvcGVuIC1EIC9kZXYvbG9vcDAgLS1pbnRlZ3JpdHkgc2hhMjU2
IGludGVncml0eXRlc3QKIyBpbnRlZ3JpdHlzZXR1cCBzdGF0dXMgaW50ZWdyaXR5dGVzdAojIGlu
dGVncml0eXNldHVwIGNsb3NlIGludGVncml0eXRlc3QKIyBpbnRlZ3JpdHlzZXR1cCBvcGVuIC1E
IC9kZXYvbG9vcDAgLS1pbnRlZ3JpdHkgc2hhMjU2IGludGVncml0eXRlc3QKIyBpbnRlZ3JpdHlz
ZXR1cCBzdGF0dXMgaW50ZWdyaXR5dGVzdAojIGRkIGlmPS9kZXYvdXJhbmRvbSBvZj0vZGV2L2xv
b3AwIGJzPTUxMiBjb3VudD0xIHNlZWs9MTAwMDAwCiMgZGQgaWY9L2Rldi9tYXBwZXIvaW50ZWdy
aXR5dGVzdCBvZj0vZGV2L251bGwKCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KYXVkaXQubG9n
IGZyb20gYXVkaXRkCgp0eXBlPVVOS05PV05bMTMzNl0gbXNnPWF1ZGl0KDE2Mjg2OTI4NjIuMTg3
OjQwOSk6IG1vZHVsZT1pbnRlZ3JpdHkgZGV2PTI1NDozIG9wPWN0ciByZXM9MQp0eXBlPVVOS05P
V05bMTMzNl0gbXNnPWF1ZGl0KDE2Mjg2OTI4NjIuNDQzOjQxMCk6IG1vZHVsZT1pbnRlZ3JpdHkg
ZGV2PTI1NDozIG9wPWR0ciByZXM9MQp0eXBlPVVOS05PV05bMTMzNl0gbXNnPWF1ZGl0KDE2Mjg2
OTI4NjIuNTQzOjQxMSk6IG1vZHVsZT1pbnRlZ3JpdHkgZGV2PTI1NDozIG9wPWN0ciByZXM9MQp0
eXBlPVVOS05PV05bMTMzNl0gbXNnPWF1ZGl0KDE2Mjg2OTI4NzcuOTQzOjQxMik6IG1vZHVsZT1p
bnRlZ3JpdHkgZGV2PTI1NDozIG9wPWR0ciByZXM9MQoKdHlwZT1VTktOT1dOWzEzMzZdIG1zZz1h
dWRpdCgxNjI4NjkyODg3LjI4Nzo0MTMpOiBtb2R1bGU9aW50ZWdyaXR5IGRldj0yNTQ6MyBvcD1j
dHIgcmVzPTEKCnR5cGU9VU5LTk9XTlsxMzM2XSBtc2c9YXVkaXQoMTYyODY5MjkyNS4xNTY6NDE3
KTogbW9kdWxlPWludGVncml0eSBkZXY9MjU0OjMgb3A9ZHRyIHJlcz0xCgp0eXBlPVVOS05PV05b
MTMzNl0gbXNnPWF1ZGl0KDE2Mjg2OTI5MzAuNzIwOjQxOCk6IG1vZHVsZT1pbnRlZ3JpdHkgZGV2
PTI1NDozIG9wPWN0ciByZXM9MQoKdHlwZT1VTktOT1dOWzEzMzZdIG1zZz1hdWRpdCgxNjI4Njky
OTg5LjM0NDo0MTkpOiBtb2R1bGU9aW50ZWdyaXR5IGRldj0yNTQ6MyBvcD1pbnRlZ3JpdHktY2hl
Y2tzdW0gc2VjdG9yPTc3NDgwIHJlcz0wCnR5cGU9VU5LTk9XTlsxMzM2XSBtc2c9YXVkaXQoMTYy
ODY5Mjk4OS4zNDg6NDIwKTogbW9kdWxlPWludGVncml0eSBkZXY9MjU0OjMgb3A9aW50ZWdyaXR5
LWNoZWNrc3VtIHNlY3Rvcj03NzQ4MCByZXM9MAp0eXBlPVVOS05PV05bMTMzNl0gbXNnPWF1ZGl0
KDE2Mjg2OTI5ODkuMzQ4OjQyMSk6IG1vZHVsZT1pbnRlZ3JpdHkgZGV2PTI1NDozIG9wPWludGVn
cml0eS1jaGVja3N1bSBzZWN0b3I9Nzc0ODAgcmVzPTAKdHlwZT1VTktOT1dOWzEzMzZdIG1zZz1h
dWRpdCgxNjI4NjkyOTg5LjM0ODo0MjIpOiBtb2R1bGU9aW50ZWdyaXR5IGRldj0yNTQ6MyBvcD1p
bnRlZ3JpdHktY2hlY2tzdW0gc2VjdG9yPTc3NDgwIHJlcz0wCnR5cGU9VU5LTk9XTlsxMzM2XSBt
c2c9YXVkaXQoMTYyODY5Mjk4OS4zNDg6NDIzKTogbW9kdWxlPWludGVncml0eSBkZXY9MjU0OjMg
b3A9aW50ZWdyaXR5LWNoZWNrc3VtIHNlY3Rvcj03NzQ4MCByZXM9MAp0eXBlPVVOS05PV05bMTMz
Nl0gbXNnPWF1ZGl0KDE2Mjg2OTI5ODkuMzQ4OjQyNCk6IG1vZHVsZT1pbnRlZ3JpdHkgZGV2PTI1
NDozIG9wPWludGVncml0eS1jaGVja3N1bSBzZWN0b3I9Nzc0ODAgcmVzPTAKdHlwZT1VTktOT1dO
WzEzMzZdIG1zZz1hdWRpdCgxNjI4NjkyOTg5LjM0ODo0MjUpOiBtb2R1bGU9aW50ZWdyaXR5IGRl
dj0yNTQ6MyBvcD1pbnRlZ3JpdHktY2hlY2tzdW0gc2VjdG9yPTc3NDgwIHJlcz0wCnR5cGU9VU5L
Tk9XTlsxMzM2XSBtc2c9YXVkaXQoMTYyODY5Mjk4OS4zNDg6NDI2KTogbW9kdWxlPWludGVncml0
eSBkZXY9MjU0OjMgb3A9aW50ZWdyaXR5LWNoZWNrc3VtIHNlY3Rvcj03NzQ4MCByZXM9MAp0eXBl
PVVOS05PV05bMTMzNl0gbXNnPWF1ZGl0KDE2Mjg2OTI5ODkuMzQ4OjQyNyk6IG1vZHVsZT1pbnRl
Z3JpdHkgZGV2PTI1NDozIG9wPWludGVncml0eS1jaGVja3N1bSBzZWN0b3I9Nzc0ODAgcmVzPTAK
dHlwZT1VTktOT1dOWzEzMzZdIG1zZz1hdWRpdCgxNjI4NjkyOTg5LjM0ODo0MjgpOiBtb2R1bGU9
aW50ZWdyaXR5IGRldj0yNTQ6MyBvcD1pbnRlZ3JpdHktY2hlY2tzdW0gc2VjdG9yPTc3NDgwIHJl
cz0wCgp2MiBDaGFuZ2VzOgotIEZpeGVkIGNvbXBpbGUgZXJyb3JzIGlmIENPTkZJR19ETV9BVURJ
VCBpcyBub3Qgc2V0Ci0gRml4ZWQgZm9ybWF0dGluZyBhbmQgdHlwb3MgYXMgc3VnZ2VzdGVkIGJ5
IENhc2V5CgpNaWNoYWVsIFdlacOfICgzKToKICBkbTogaW50cm9kdWNlIGF1ZGl0IGV2ZW50IG1v
ZHVsZSBmb3IgZGV2aWNlIG1hcHBlcgogIGRtIGludGVncml0eTogbG9nIGF1ZGl0IGV2ZW50cyBm
b3IgZG0taW50ZWdyaXR5IHRhcmdldAogIGRtIGNyeXB0OiBsb2cgYWVhZCBpbnRlZ3JpdHkgdmlv
bGF0aW9ucyB0byBhdWRpdCBzdWJzeXN0ZW0KCiBkcml2ZXJzL21kL0tjb25maWcgICAgICAgICB8
IDEwICsrKysrKysKIGRyaXZlcnMvbWQvTWFrZWZpbGUgICAgICAgIHwgIDQgKysrCiBkcml2ZXJz
L21kL2RtLWF1ZGl0LmMgICAgICB8IDU5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrCiBkcml2ZXJzL21kL2RtLWF1ZGl0LmggICAgICB8IDMzICsrKysrKysrKysrKysrKysr
KysrKwogZHJpdmVycy9tZC9kbS1jcnlwdC5jICAgICAgfCAyMiArKysrKysrKysrKy0tLQogZHJp
dmVycy9tZC9kbS1pbnRlZ3JpdHkuYyAgfCAyNSArKysrKysrKysrKysrLS0tCiBpbmNsdWRlL3Vh
cGkvbGludXgvYXVkaXQuaCB8ICAxICsKIDcgZmlsZXMgY2hhbmdlZCwgMTQ2IGluc2VydGlvbnMo
KyksIDggZGVsZXRpb25zKC0pCiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9tZC9kbS1hdWRp
dC5jCiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9tZC9kbS1hdWRpdC5oCgotLSAKMi4yMC4x
CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xp
c3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

