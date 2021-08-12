Return-Path: <SRS0=J1Yh=NE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6320EC4338F
	for <dm-devel@archiver.kernel.org>; Fri, 13 Aug 2021 06:41:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8FF12610CD
	for <dm-devel@archiver.kernel.org>; Fri, 13 Aug 2021 06:41:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8FF12610CD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=aisec.fraunhofer.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-LlrkPLA0PN2Z5UvAIx_JxQ-1; Fri, 13 Aug 2021 02:40:58 -0400
X-MC-Unique: LlrkPLA0PN2Z5UvAIx_JxQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F77A80124F;
	Fri, 13 Aug 2021 06:40:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 97EC9908E;
	Fri, 13 Aug 2021 06:40:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 00AB24BB7C;
	Fri, 13 Aug 2021 06:40:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17CF3YS4011452 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Aug 2021 11:03:34 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AAF88200B68B; Thu, 12 Aug 2021 15:03:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A5FA1209A50B
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 15:03:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1024F8D1382
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 15:03:33 +0000 (UTC)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.134])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-70-XVJaCniQNIK71OoIKp9i8Q-1; Thu, 12 Aug 2021 11:03:27 -0400
X-MC-Unique: XVJaCniQNIK71OoIKp9i8Q-1
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
	mrelayeu.kundenserver.de (mreue009 [212.227.15.167]) with ESMTPSA
	(Nemesis)
	id 1MQMm9-1mRAbi44UT-00MJ0W; Thu, 12 Aug 2021 16:58:12 +0200
From: =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To: michael.weiss@aisec.fraunhofer.de
Date: Thu, 12 Aug 2021 16:57:41 +0200
Message-Id: <20210812145748.4460-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
X-Provags-ID: V03:K1:E1yluKd3qSTn/LHmKKMFbuZnMtW/v47VwlVPW92Z/ltMRz2knBo
	LUQyCYEC2nBrlG4SmrbzjHjDS+Fd9D8OehmDmOZsqJTjivtsonN6npkNg2hb0DLCrbWKdMe
	vP+JeClAaWg4eL3AUzJ82BiSyzvh/upNN3Nu1JcQuCiX16YxsbS3NKsO4T3mVfUaolBaR93
	bRYbvp64iIhA48Q+iXc/g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:wtYB+dUr/+0=:9cDTj2TGS4hk9WjFWhojsY
	t4FCMsouLLdkjYe/GQ/Vsi50oiDOeBYX5JxaFn62Lj+2TYhlYDQKpx+YOxRJp7UWBIivEC+tm
	6zJb3oiDgjiUczlualrmYoswchlyD5O87ST7tw3qC4SthjDgP+9GW6QvyQ4C93YozxkbsN/lI
	kJ/Dcm3bZO6aPoG+LAX86pe+UbsgKuTpMmh/En3JdPvGOp/Ue8phxIV9IKsIS1h3tz4aF5/YT
	UUA2aUTCcW3kHDz3MEUcjaeuk2j951PAKYGAAAVK+leK/au5GKtK03Yhztml6ErpD6IkvkscM
	URTFjGdBybMA0hQEQVyy8sL5YD4jKs9LToiaZVCGR+JI1NZOxsNARSUbfQfW7tRa9sR6+1KmX
	vFscIuiWBRIpwih8SEMfI4Ebjwj38vZ7cHnuqbtzACsBw6/6uHRL7N+Oc+8qy7nFwiS23gAI9
	7v8Y8eqxhk5e0qZZ40nZkF3RenHhRdSmMYveZi0sU8fLid6RInoIz7uX/nokCz8mmB6Gb/W/X
	VGbu6g8YsqmdruuxRXfJ6v5RTOgQ/qZDbhyoCpBCfG9Z9cnpO7xO2NRFFKcZ2p/oi5FIpbntm
	B2/9oIGcQwPwhymNwyLwWPHQAp42U7oBAhjHQZzzWxWhsrO1PbsAq8cfaavEwXIWdZWFMjZX+
	mSdkW2sdvBDzZ0lzAbOLUZ6vedMomqoUnI0fiyS7WN9b4ntcr+e0vMr0w49I2q9D3J2nOUQfN
	nyl//g5zZaZXR4wSdaDVkbKOtQIltbh0ogScsBgngVl4vd3XpBQIpMH4BVRn3IaM9XbaplUkO
	3QwwyhOeuiiHoBc2xlo6VKFxDmyTZOPM6C5PnX+ykUSbXkXBuJBydNsvxgsrGzpoXie5rFsuJ
	uMMybh23vFCU/t3ce3XA==
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 13 Aug 2021 02:36:56 -0400
Cc: Paul Moore <paul@paul-moore.com>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
	linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, linux-audit@redhat.com,
	Alasdair Kergon <agk@redhat.com>
Subject: [dm-devel] [PATCH 0/3] dm: audit event logging
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
cz0wCgpNaWNoYWVsIFdlacOfICgzKToKICBkbTogaW50cm9kdWNlIGF1ZGl0IGV2ZW50IG1vZHVs
ZSBmb3IgZGV2aWNlIG1hcHBlcgogIGRtIGludGVncml0eTogbG9nIGF1ZGl0IGV2ZW50cyBmb3Ig
ZG0taW50ZWdyaXR5IHRhcmdldAogIGRtIGNyeXB0OiBsb2cgYWVhZCBpbnRlZ3JpdHkgdmlvbGF0
aW9ucyB0byBhdWRpdCBzdWJzeXN0ZW0KCiBkcml2ZXJzL21kL0tjb25maWcgICAgICAgICB8IDEw
ICsrKysrKysKIGRyaXZlcnMvbWQvTWFrZWZpbGUgICAgICAgIHwgIDQgKysrCiBkcml2ZXJzL21k
L2RtLWF1ZGl0LmMgICAgICB8IDU5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrCiBkcml2ZXJzL21kL2RtLWF1ZGl0LmggICAgICB8IDMzICsrKysrKysrKysrKysrKysrKysr
KwogZHJpdmVycy9tZC9kbS1jcnlwdC5jICAgICAgfCAyMyArKysrKysrKysrKystLS0KIGRyaXZl
cnMvbWQvZG0taW50ZWdyaXR5LmMgIHwgMjUgKysrKysrKysrKysrKy0tLQogaW5jbHVkZS91YXBp
L2xpbnV4L2F1ZGl0LmggfCAgMiArKwogNyBmaWxlcyBjaGFuZ2VkLCAxNDggaW5zZXJ0aW9ucygr
KSwgOCBkZWxldGlvbnMoLSkKIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL21kL2RtLWF1ZGl0
LmMKIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL21kL2RtLWF1ZGl0LmgKCi0tIAoyLjIwLjEK
Ci0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlz
dG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

