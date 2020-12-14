Return-Path: <SRS0=pYhN=FS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A0AC2BB40
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 11:01:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A16F622BEF
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 11:01:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A16F622BEF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=web.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-9cDK4_fWPeCOrvBUjoQcYg-1; Mon, 14 Dec 2020 06:01:08 -0500
X-MC-Unique: 9cDK4_fWPeCOrvBUjoQcYg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6644B1926DB4;
	Mon, 14 Dec 2020 11:00:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 45DD070490;
	Mon, 14 Dec 2020 11:00:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 17C761809CA1;
	Mon, 14 Dec 2020 11:00:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BEASMdq024818 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Dec 2020 05:28:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 704D747CEF; Mon, 14 Dec 2020 10:28:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AF1F47CE9
	for <dm-devel@redhat.com>; Mon, 14 Dec 2020 10:28:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 77407858EEC
	for <dm-devel@redhat.com>; Mon, 14 Dec 2020 10:28:18 +0000 (UTC)
Received: from mout.web.de (mout.web.de [212.227.17.11]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-14-O55BNh1kOA65Sggt-UForg-1;
	Mon, 14 Dec 2020 05:28:13 -0500
X-MC-Unique: O55BNh1kOA65Sggt-UForg-1
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.173.71]) by smtp.web.de (mrweb103
	[213.165.67.124]) with ESMTPSA (Nemesis) id 0MJTVP-1kq7jN2BWl-0032UA;
	Mon, 14 Dec 2020 11:28:02 +0100
To: Dan Carpenter <dan.carpenter@oracle.com>, kernel-janitors@vger.kernel.org, 
	linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	dm-devel@redhat.com
References: <466b4c6d-032f-fbcc-58ac-75f6f39d734f@web.de>
	<20201210151035.GC1578121@piout.net> <20201211083731.GP2789@kadam>
	<e7910b04-4c4a-567b-d87d-d12352a48cfc@web.de>
	<20201214070536.GB2809@kadam>
From: Markus Elfring <Markus.Elfring@web.de>
Message-ID: <61475054-0975-532d-ad2d-982506f6c329@web.de>
Date: Mon, 14 Dec 2020 11:27:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201214070536.GB2809@kadam>
X-Provags-ID: V03:K1:KMH+ryiTF0xG/6BaC2g6dGBKrvJhnHlLdvxaPvM149AIzj7U0U5
	2uW550FRJpZnRc4HevCK8BxVAjWSnQrCgmSnBkrt+Kxg95nrEntoVdoRAiqfnBDZHYO9Cq7
	DHCmJg0bJCqPJtstlgSKELtTfVwbgWOJH1TR0iMW1CtjL7+/Hw+00H/9pWWouXcQQS0s33A
	3YeEC9Q6S+RXLOwcnUSvQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:wn6Cmq2Icec=:pIG6YYkrHqIFK/p3FI9j6T
	I+mopxgvodMfMeLd/gqpWoPcDOvaxl7hsP4P5iGJjG+MvQyIujhXRojKwhFSwEWhc3y3oSqgg
	YhIKNp9T0xSod3UWLN7fvPF81HRphrGiC/E7vpjnjuxAXpSFo8R6o4524K7u2kiur0OF7xm5s
	CEketrkBkvpNPt82vUt/Y6LrcyiX8hgLXK7wanBODqjHil0XGAcCZROyCkYlvsrwwNao+01Rb
	kSAuvb+RWKvucYpowP+JEqmo5NPvjHHDFGL29WrpJEmq9MAu3rn0EXbVBmeDBv/3Xu85OPEKo
	vaMvyQzsfLCN9QovczSFyfmOHzUj+fDJdbeMkgXUp2OcG4vtMYJpbk3LU12zYHzyHhKB3JSF+
	QHeOBLf3vHHXbYEiSV8U/Hs1A90WHTMqBCvA5egcOI58kc7vSEeJIugpA5HeW+BES405k394K
	Z2TMqw2gOkiRXvTmsJwNkmxiPxCW+UoxPLMxxPTtWSvkt4sGvOzOegqaRP9a7evS0190STECW
	oOu5ufIShA+L1sjafhYNxZ6bxIPj/tkeBi18QiLeZ894+DNL8bE38fNYVAew+k1ny8F6hI0z8
	xzWOqJAN/R1wBkf17ZtE0PvXX6ijb1j7MGYRHEfao4g/6SxqXTD9G67NK+LlhI0eDlXLLZu0y
	48WiyQFTZdCLgsGnnuWIcU7+L406z6z7Y9PwQ5yh9nXiZdZ9fM10ubkcCg4nf47pvKyTaSokU
	h1nJZt17fJt3npQdcTcWz1kNAdEhZDX4YPLLs63TJ3ruIwlI9nnFC/T0D3QRPOLFrohnwz9n+
	hdCshFVYA2LeQ4e0yEt1xI8fMuowL0boV+EUOcPoTC1H6sadji6sDc02hDXkaqGqwcb1ggjHJ
	/ncjj7aFEBTTXXZ/HHNw==
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BEASMdq024818
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 14 Dec 2020 06:00:28 -0500
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Rikard Falkeborn <rikard.falkeborn@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, Julia Lawall <Julia.Lawall@lip6.fr>,
	Ludovic Desroches <ludovic.desroches@microchip.com>,
	Evgeniy Polyakov <zbr@ioremap.net>, Joe Perches <joe@perches.com>,
	Colin Ian King <colin.king@canonical.com>,
	Ulf Hansson <ulf.hansson@linaro.org>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel]
 =?utf-8?q?=E2=80=A6=3A_Reduce_scope_for_the_variable_?=
 =?utf-8?b?4oCc4oCm4oCdIGluIOKApigp?=
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

PiBQcm9iYWJseSB0aGUgb3RoZXIgcGVvcGxlIGFyZSByaWdodCB0aGF0IG1ha2luZyBzY29wZXMg
c2hvcnRlciBpcyBtb3JlCj4gaW1wb3J0YW50IHdoZW4gdGhlIGZ1bmN0aW9uIGlzIHZlcnkgbG9u
Zy4KCkhvdyBtdWNoIHdpbGwgc2l6ZXMgb2YgZnVuY3Rpb24gaW1wbGVtZW50YXRpb25zIGluZmx1
ZW5jZSB0aGUgYWNjZXB0YW5jZQpmb3IgcG9zc2libGUgc291cmNlIGNvZGUgcmVmYWN0b3Jpbmdz
PwpodHRwczovL3JlZmFjdG9yaW5nLmNvbS9jYXRhbG9nL3JlZHVjZVNjb3BlT2ZWYXJpYWJsZS5o
dG1sCgoqIFdvdWxkIHlvdSBmaW5kIGFub3RoZXIgY29udmVyc2lvbiBvZiBhbiBleHRyYSBudWxs
IHBvaW50ZXIgaW5pdGlhbGlzYXRpb24KICB0byBhIGxhdGVyIHZhcmlhYmxlIGRlZmluaXRpb24g
aGVscGZ1bCB0aGVuIGF0IG90aGVyIHBsYWNlcz8KCiAgRXhhbXBsZToKICBbUEFUQ0hdIGRtIHNu
YXBzaG90OiBSZWR1Y2Ugc2NvcGUgZm9yIHRoZSB2YXJpYWJsZSDigJxwZeKAnSBpbiBzbmFwc2hv
dF9tYXAoKQogIGh0dHBzOi8vZWxpeGlyLmJvb3RsaW4uY29tL2xpbnV4L3Y1LjEwL3NvdXJjZS9k
cml2ZXJzL21kL2RtLXNuYXAuYyNMMTk0MQogIGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC90cmVlL2RyaXZlcnMvbWQvZG0t
c25hcC5jP2lkPTJjODVlYmM1N2IzZTE4MTdiNmNlMWE2YjcwMzkyOGUxMTNhOTA0NDIjbjE5NDEK
CiogSG93IGRvIHlvdSB0aGluayBhYm91dCB0byBvbWl0IHRoZSBpbml0aWFsaXNhdGlvbiBmb3Ig
dGhlIHZhcmlhYmxlIOKAnHJldOKAnQogIGluIHRoZSBpbXBsZW1lbnRhdGlvbiBvZiB0aGUgZnVu
Y3Rpb24g4oCcdzFfdWV2ZW504oCdCiAgKGJlY2F1c2UgaXQgd2lsbCBiZSByZWFzc2lnbmVkIGJ5
IGEgZnVuY3Rpb24gY2FsbCBhIGJpdCBsYXRlcik/CiAgaHR0cHM6Ly9lbGl4aXIuYm9vdGxpbi5j
b20vbGludXgvdjUuMTAvc291cmNlL2RyaXZlcnMvdzEvdzEuYyNMNTc4CiAgaHR0cHM6Ly9naXQu
a2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXguZ2l0L3Ry
ZWUvZHJpdmVycy93MS93MS5jP2lkPTJjODVlYmM1N2IzZTE4MTdiNmNlMWE2YjcwMzkyOGUxMTNh
OTA0NDIjbjU3OAoKICBXb3VsZCBhbnkgYWRqdXN0bWVudCB3aXRoIHRoZSB0YWcg4oCcQWRkcmVz
c2VzLUNvdmVyaXR5OiAoIlVudXNlZCB2YWx1ZSIp4oCdCiAgYmVjb21lIHJlbGV2YW50IGhlcmU/
CgpSZWdhcmRzLApNYXJrdXMKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVk
aGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

