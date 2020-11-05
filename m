Return-Path: <SRS0=GP8t=EO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB608C56201
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 17:05:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2A232206C0
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 17:05:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A232206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-IhL4D1pYOfaH6uMkNABS9g-1; Sun, 08 Nov 2020 12:04:58 -0500
X-MC-Unique: IhL4D1pYOfaH6uMkNABS9g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7267185A0D2;
	Sun,  8 Nov 2020 17:04:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 42F0810013BD;
	Sun,  8 Nov 2020 17:04:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 49B41CF55;
	Sun,  8 Nov 2020 17:04:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A5EV36b022152 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 5 Nov 2020 09:31:04 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BE38D207B17A; Thu,  5 Nov 2020 14:31:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B8675207B17B
	for <dm-devel@redhat.com>; Thu,  5 Nov 2020 14:30:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44B22811E76
	for <dm-devel@redhat.com>; Thu,  5 Nov 2020 14:30:59 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
	[148.163.156.1]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-459-PIZvVzp8NZS4DQfaZZhJmA-1; Thu, 05 Nov 2020 09:30:37 -0500
X-MC-Unique: PIZvVzp8NZS4DQfaZZhJmA-1
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
	0A5E2RL8069639; Thu, 5 Nov 2020 09:30:36 -0500
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 34m5ftg0vy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 05 Nov 2020 09:30:35 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A5E3Bwa077583;
	Thu, 5 Nov 2020 09:30:35 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 34m5ftg0ug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 05 Nov 2020 09:30:35 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	0A5ER9Dg016507; Thu, 5 Nov 2020 14:30:32 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com
	(b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma06ams.nl.ibm.com with ESMTP id 34h0fcwh52-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 05 Nov 2020 14:30:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com
	[9.149.105.62])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 0A5EUUee56426984
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Thu, 5 Nov 2020 14:30:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8FDD6AE051;
	Thu,  5 Nov 2020 14:30:30 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 47954AE04D;
	Thu,  5 Nov 2020 14:30:27 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown
	[9.160.97.46]) by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Thu,  5 Nov 2020 14:30:27 +0000 (GMT)
Message-ID: <d0e96ccc49590c5ff11675661592b70b0f021636.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, 
	snitzer@redhat.com, gmazyland@gmail.com, paul@paul-moore.com
Date: Thu, 05 Nov 2020 09:30:26 -0500
In-Reply-To: <20201101222626.6111-3-tusharsu@linux.microsoft.com>
References: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
	<20201101222626.6111-3-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312, 18.0.737
	definitions=2020-11-05_07:2020-11-05,
	2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	malwarescore=0 spamscore=0
	mlxscore=0 phishscore=0 suspectscore=0 clxscore=1015 bulkscore=0
	priorityscore=1501 mlxlogscore=999 adultscore=0 impostorscore=0
	lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2011050092
X-MIME-Autoconverted: from 8bit to quoted-printable by
	mx0a-001b2d01.pphosted.com id 0A5E2RL8069639
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0A5EV36b022152
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Sun, 08 Nov 2020 12:04:49 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v5 2/7] IMA: update
 process_buffer_measurement to measure buffer hash
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgVHVzaGFyLAoKUGxlYXNlIGRvbid0IGluY2x1ZGUgdGhlIGZpbGVuYW1lIGluIHRoZSBTdWJq
ZWN0IGxpbmVbMV0uICAgVGhlIFN1YmplY3QKbGluZSBzaG91bGQgYmUgYSBzdW1tYXJ5IHBocmFz
ZSBkZXNjcmliaW5nIHRoZSBwYXRjaC4gICBJbiB0aGlzIGNhc2UsCml0IGlzIGFkZGluZyBzdXBw
b3J0IGZvciBtZWFzdXJpbmcgdGhlIGJ1ZmZlciBkYXRhIGhhc2guCgpPbiBTdW4sIDIwMjAtMTEt
MDEgYXQgMTQ6MjYgLTA4MDAsIFR1c2hhciBTdWdhbmRoaSB3cm90ZToKPiBwcm9jZXNzX2J1ZmZl
cl9tZWFzdXJlbWVudCgpIGN1cnJlbnRseSBvbmx5IG1lYXN1cmVzIHRoZSBpbnB1dCBidWZmZXIu
Cj4gSW4gY2FzZSBvZiBTZUxpbnV4IHBvbGljeSBtZWFzdXJlbWVudCwgdGhlIHBvbGljeSBiZWlu
ZyBtZWFzdXJlZCBjb3VsZAo+IGJlIGxhcmdlIChzZXZlcmFsIE1CKS4gVGhpcyBtYXkgcmVzdWx0
IGluIGEgbGFyZ2UgZW50cnkgaW4gSU1BCj4gbWVhc3VyZW1lbnQgbG9nLgoKU0VMaW51eCBpcyBh
biBleGFtcGxlIG9mIG1lYXN1cmluZyBsYXJnZSBidWZmZXIgZGF0YS4gIFBsZWFzZSByZXdyaXRl
CnRoaXMgcGF0Y2ggZGVzY3JpcHRpb24gKGFuZCB0aGUgb3RoZXIgcGF0Y2ggZGVzY3JpcHRpb25z
IGluIHRoaXMgcGF0Y2gKc2V0KSB3aXRob3V0IHVzaW5nIHRoZSBleGFtcGxlIHRvIGRlc2NyaWJl
IGl0cyBwdXJwb3NlIFsxXS4KCkluIHRoaXMgY2FzZSwgeW91IG1pZ2h0IHNheSwKClRoZSBvcmln
aW5hbCBJTUEgYnVmZmVyIGRhdGEgbWVhc3VyZW1lbnQgc2l6ZXMgd2VyZSBzbWFsbCAoZS5nLiBi
b290CmNvbW1hbmQgbGluZSksIGJ1dCBuZXcgYnVmZmVyIGRhdGEgbWVhc3VyZW1lbnQgdXNlIGNh
c2VzIGFyZSBhIGxvdApsYXJnZXIuICBKdXN0IGFzIElNQSBtZWFzdXJlcyB0aGUgZmlsZSBkYXRh
IGhhc2gsIG5vdCB0aGUgZmlsZSBkYXRhLApJTUEgc2hvdWxkIHNpbWlsYXJseSBzdXBwb3J0IG1l
YXN1cmluZyB0aGUgYnVmZmVyIGRhdGEgaGFzaC4KCj4gCj4gSW50cm9kdWNlIGEgYm9vbGVhbiBw
YXJhbWV0ZXIgbWVhc3VyZV9idWZfaGFzaCB0byBzdXBwb3J0IG1lYXN1cmluZwo+IGhhc2ggb2Yg
YSBidWZmZXIsIHdoaWNoIHdvdWxkIGJlIG11Y2ggc21hbGxlciwgaW5zdGVhZCBvZiB0aGUgYnVm
ZmVyCj4gaXRzZWxmLgoKPiBUbyB1c2UgdGhlIGZ1bmN0aW9uYWxpdHkgaW50cm9kdWNlZCBpbiB0
aGlzIHBhdGNoLCB0aGUgYXR0ZXN0YXRpb24KPiBjbGllbnQgYW5kIHRoZSBzZXJ2ZXIgY2hhbmdl
cyBuZWVkIHRvIGdvIGhhbmQgaW4gaGFuZC4gVGhlCj4gY2xpZW50L2tlcm5lbCB3b3VsZCBrbm93
IHdoYXQgZGF0YSBpcyBiZWluZyBtZWFzdXJlZCBhcy1pcwo+IChlLmcuIEtFWEVDX0NNRExJTkUp
LCBhbmQgd2hhdCBkYXRhIGhhcyBpdOKAmXMgaGFzaCBtZWFzdXJlZCAoZS5nLiBTZUxpbnV4Cj4g
UG9saWN5KS4gQW5kIHRoZSBhdHRlc3RhdGlvbiBzZXJ2ZXIgc2hvdWxkIHZlcmlmeSBkYXRhL2hh
c2ggYWNjb3JkaW5nbHkuCj4gCj4gSnVzdCBsaWtlIHRoZSBkYXRhIGJlaW5nIG1lYXN1cmVkIGlu
IG90aGVyIGNhc2VzLCB0aGUgYXR0ZXN0YXRpb24gc2VydmVyCj4gd2lsbCBrbm93IHdoYXQgYXJl
IHBvc3NpYmxlIHZhbHVlcyBvZiB0aGUgbGFyZ2UgYnVmZmVycyBiZWluZyBtZWFzdXJlZC4KPiBl
LmcuIHRoZSBwb3NzaWJsZSB2YWxpZCBTZUxpbnV4IHBvbGljeSB2YWx1ZXMgdGhhdCBhcmUgYmVp
bmcgcHVzaGVkIHRvCj4gdGhlIGNsaWVudC4gVGhlIGF0dGVzdGF0aW9uIHNlcnZlciB3aWxsIGhh
dmUgdG8gbWFpbnRhaW4gdGhlIGhhc2ggb2YKPiB0aG9zZSBidWZmZXIgdmFsdWVzLgoKRWFjaCBw
YXRjaCBpbiB0aGUgcGF0Y2ggc2V0IGJ1aWxkcyB1cG9uIHRoZSBwcmV2aW91cyBvbmUuICAgKFRo
aW5rIG9mCml0IGFzIGEgc3RvcnksIHdoZXJlIGVhY2ggY2hhcHRlciBidWlsZHMgdXBvbiB0aGUg
cHJldmlvdXMgb25lcy4pICAKV2l0aCByYXJlIGV4Y2VwdGlvbnMsIHNob3VsZCBwYXRjaGVzIHJl
ZmVyZW5jZSBzdWJzZXF1ZW50IHBhdGNoZXMuIFsyXQoKWzFdIFJlZmVyIHRvIERvY3VtZW50YXRp
b24vcHJvY2Vzcy9zdWJtaXR0aW5nLXBhdGNoZXMucnN0ClsyXSBSZWZlciB0byB0aGUgc2VjdGlv
biAiOCkgQ29tbWVudGluZyIgaW4KRG9jdW1lbnRhdGlvbi9wcm9jZXNzL2NvZGluZy1zdHlsZS5y
c3QKCnRoYW5rcywKCk1pbWkKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVk
aGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

