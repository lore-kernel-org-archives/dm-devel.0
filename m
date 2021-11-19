Return-Path: <SRS0=IN2R=QG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B15CCC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 19 Nov 2021 18:28:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9387361B42
	for <dm-devel@archiver.kernel.org>; Fri, 19 Nov 2021 18:28:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9387361B42
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=yourcmc.ru
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-51-OjdTO5L1PK-UgjwIn8FuPA-1; Fri, 19 Nov 2021 13:27:58 -0500
X-MC-Unique: OjdTO5L1PK-UgjwIn8FuPA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 873D11DDE9;
	Fri, 19 Nov 2021 18:27:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A9CA160862;
	Fri, 19 Nov 2021 18:27:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3F40E4A703;
	Fri, 19 Nov 2021 18:27:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AJIRlWd002844 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 19 Nov 2021 13:27:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 927D81121315; Fri, 19 Nov 2021 18:27:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8DD111121318
	for <dm-devel@redhat.com>; Fri, 19 Nov 2021 18:27:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A12CC10665A0
	for <dm-devel@redhat.com>; Fri, 19 Nov 2021 18:27:44 +0000 (UTC)
Received: from yourcmc.ru (yourcmc.ru [195.209.40.11]) by relay.mimecast.com
	with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-442-J1U4DFiuMJq60MwpGhCHdg-1; Fri, 19 Nov 2021 13:27:41 -0500
X-MC-Unique: J1U4DFiuMJq60MwpGhCHdg-1
Received: from yourcmc.ru (localhost [127.0.0.1])
	by yourcmc.ru (Postfix) with ESMTP id 1610BFE0662
	for <dm-devel@redhat.com>; Fri, 19 Nov 2021 21:24:43 +0300 (MSK)
Received: from rainloop.yourcmc.ru (yourcmc.ru [195.209.40.11])
	by yourcmc.ru (Postfix) with ESMTPSA id 00D60FE0658
	for <dm-devel@redhat.com>; Fri, 19 Nov 2021 21:24:42 +0300 (MSK)
MIME-Version: 1.0
Date: Fri, 19 Nov 2021 18:24:42 +0000
From: vitalif@yourcmc.ru
Message-ID: <8b08d35705cd7a03f46209e2a7dad64a@yourcmc.ru>
To: dm-devel@redhat.com
X-Virus-Scanned: ClamAV using ClamSMTP
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
Subject: [dm-devel] dm-era over mdadm raid5 loses discard support
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
Content-Type: multipart/mixed; boundary="--=_RainLoop_972_723717203.1637346282"

----=_RainLoop_972_723717203.1637346282
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi!=0A=0AA dm-era device created over a RAID5 array loses discard support.=
=0A=0ATest script is attached.=0A=0AIf you run it on SSD you'll see somethi=
ng like:=0A=0Aloop0 4096=0Aloop1 4096=0Aloop2 4096=0Aloop3 4096=0Amd55 1048=
576=0Aloop_test_era 0=0A=0AI.e. mdadm device supports discard, but dm-era d=
evice started over it doesn't.=0A=0AIf you create a dm-era device over a no=
rmal block device without mdadm RAID5 or even over mdadm RAID1 - it will pr=
eserve discard support.=0A=0AWhy? How can it be fixed?=0A=0A--=20=0AWith be=
st regards,=0A  Vitaliy Filippov

----=_RainLoop_972_723717203.1637346282
Content-Type: application/octet-stream; name="raid5_test.sh"
Content-Disposition: attachment; filename="raid5_test.sh"
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKCnNldCAtZQoKbW9kcHJvYmUgZG0tZXJhCmRkIGlmPS9kZXYvemVybyBvZj10
ZXN0MSBicz0xTSBzZWVrPTEwMDAgY291bnQ9MQpkZCBpZj0vZGV2L3plcm8gb2Y9dGVzdDIgYnM9
MU0gc2Vlaz0xMDAwIGNvdW50PTEKZGQgaWY9L2Rldi96ZXJvIG9mPXRlc3QzIGJzPTFNIHNlZWs9
MTAwMCBjb3VudD0xCmRkIGlmPS9kZXYvemVybyBvZj10ZXN0NCBicz0xTSBzZWVrPTEwIGNvdW50
PTEKbG9zZXR1cCAtLWRpcmVjdC1pbyAvZGV2L2xvb3AwIHRlc3QxCmxvc2V0dXAgLS1kaXJlY3Qt
aW8gL2Rldi9sb29wMSB0ZXN0Mgpsb3NldHVwIC0tZGlyZWN0LWlvIC9kZXYvbG9vcDIgdGVzdDMK
bG9zZXR1cCAtLWRpcmVjdC1pbyAvZGV2L2xvb3AzIHRlc3Q0CmVjaG8gbG9vcDAgJChjYXQgL3N5
cy9ibG9jay9sb29wMC9xdWV1ZS9kaXNjYXJkX2dyYW51bGFyaXR5KQplY2hvIGxvb3AxICQoY2F0
IC9zeXMvYmxvY2svbG9vcDEvcXVldWUvZGlzY2FyZF9ncmFudWxhcml0eSkKZWNobyBsb29wMiAk
KGNhdCAvc3lzL2Jsb2NrL2xvb3AyL3F1ZXVlL2Rpc2NhcmRfZ3JhbnVsYXJpdHkpCmVjaG8gbG9v
cDMgJChjYXQgL3N5cy9ibG9jay9sb29wMy9xdWV1ZS9kaXNjYXJkX2dyYW51bGFyaXR5KQptZGFk
bSAtQyAtLW1ldGFkYXRhPTAuOSAtLWxldmVsPTUgLS1yYWlkLWRldmljZXM9MyAvZGV2L21kNTUg
L2Rldi9sb29wMCAvZGV2L2xvb3AxIC9kZXYvbG9vcDIKZWNobyBtZDU1ICQoY2F0IC9zeXMvYmxv
Y2svbWQ1NS9xdWV1ZS9kaXNjYXJkX2dyYW51bGFyaXR5KQpkbXNldHVwIGNyZWF0ZSBsb29wX3Rl
c3RfZXJhIC0tdGFibGUgIjAgJChzdWRvIGJsb2NrZGV2IC0tZ2V0c3ogL2Rldi9tZDU1KSBlcmEg
L2Rldi9sb29wMyAvZGV2L21kNTUgMTAyNCIKZWNobyBsb29wX3Rlc3RfZXJhICQoY2F0IC9zeXMv
YmxvY2svbG9vcDAvJChyZWFkbGluayAvZGV2L21hcHBlci9sb29wX3Rlc3RfZXJhKS9xdWV1ZS9k
aXNjYXJkX2dyYW51bGFyaXR5KQpkbXNldHVwIHJlbW92ZSBsb29wX3Rlc3RfZXJhCm1kYWRtIC0t
c3RvcCAvZGV2L21kNTUKbG9zZXR1cCAtZCAvZGV2L2xvb3AwCmxvc2V0dXAgLWQgL2Rldi9sb29w
MQpsb3NldHVwIC1kIC9kZXYvbG9vcDIKbG9zZXR1cCAtZCAvZGV2L2xvb3AzCg==
----=_RainLoop_972_723717203.1637346282
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
----=_RainLoop_972_723717203.1637346282--

