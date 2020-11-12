Return-Path: <SRS0=awJs=ET=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C75CC63697
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:02:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C37E7208D5
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:02:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C37E7208D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-PQhyMm4nMP2ro3K-uo92TQ-1; Fri, 13 Nov 2020 03:02:51 -0500
X-MC-Unique: PQhyMm4nMP2ro3K-uo92TQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A2E36D248;
	Fri, 13 Nov 2020 08:02:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C9475D9F7;
	Fri, 13 Nov 2020 08:02:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0B45958112;
	Fri, 13 Nov 2020 08:02:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ACNuN3R019748 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Nov 2020 18:56:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9AAFB1111C88; Thu, 12 Nov 2020 23:56:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 95FCD1111C83
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 23:56:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 529B390E428
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 23:56:20 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-33-RpO5qg92MMSZWlqics1iWQ-1; Thu, 12 Nov 2020 18:56:18 -0500
X-MC-Unique: RpO5qg92MMSZWlqics1iWQ-1
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
	0ACNVp91147093; Thu, 12 Nov 2020 18:56:17 -0500
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0b-001b2d01.pphosted.com with ESMTP id 34sdd0tj8g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 12 Nov 2020 18:56:17 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ACNuHkb042971;
	Thu, 12 Nov 2020 18:56:17 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com
	[149.81.74.107])
	by mx0b-001b2d01.pphosted.com with ESMTP id 34sdd0tj7v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 12 Nov 2020 18:56:17 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
	by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	0ACNrdN9014028; Thu, 12 Nov 2020 23:56:15 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com
	(d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by ppma03fra.de.ibm.com with ESMTP id 34q084296e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 12 Nov 2020 23:56:15 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 0ACNu5sP8323784
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Thu, 12 Nov 2020 23:56:05 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4BDB14204B;
	Thu, 12 Nov 2020 23:56:05 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E02D042042;
	Thu, 12 Nov 2020 23:56:01 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown
	[9.160.105.204])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Thu, 12 Nov 2020 23:56:01 +0000 (GMT)
Message-ID: <0f25c77c042f3e62405f12966c2358fe8cd82116.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, 
	snitzer@redhat.com, gmazyland@gmail.com, paul@paul-moore.com
Date: Thu, 12 Nov 2020 18:56:01 -0500
In-Reply-To: <25622ca6-359d-fa97-c5e6-e314cba51306@linux.microsoft.com>
References: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
	<20201101222626.6111-4-tusharsu@linux.microsoft.com>
	<1f83ec246cb6356c340b379ab00e43f0b5bba0ae.camel@linux.ibm.com>
	<25622ca6-359d-fa97-c5e6-e314cba51306@linux.microsoft.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312, 18.0.737
	definitions=2020-11-12_14:2020-11-12,
	2020-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	suspectscore=0 clxscore=1015
	malwarescore=0 impostorscore=0 phishscore=0 adultscore=0
	lowpriorityscore=0 mlxscore=0 bulkscore=0 priorityscore=1501
	spamscore=0
	mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2011120129
X-MIME-Autoconverted: from 8bit to quoted-printable by
	mx0b-001b2d01.pphosted.com id 0ACNVp91147093
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0ACNuN3R019748
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 13 Nov 2020 03:02:15 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v5 3/7] IMA: add hook to measure critical data
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

SGkgVHVzaGFyLAoKT24gVGh1LCAyMDIwLTExLTEyIGF0IDEzOjU3IC0wODAwLCBUdXNoYXIgU3Vn
YW5kaGkgd3JvdGU6Cj4gPj4gZGlmZiAtLWdpdCBhL3NlY3VyaXR5L2ludGVncml0eS9pbWEvaW1h
X21haW4uYyBiL3NlY3VyaXR5L2ludGVncml0eS9pbWEvaW1hX21haW4uYwo+ID4+IGluZGV4IDQ0
ODVkODdjMGFhNS4uNmUxYjExZGNiYTUzIDEwMDY0NAo+ID4+IC0tLSBhL3NlY3VyaXR5L2ludGVn
cml0eS9pbWEvaW1hX21haW4uYwo+ID4+ICsrKyBiL3NlY3VyaXR5L2ludGVncml0eS9pbWEvaW1h
X21haW4uYwo+ID4+IEBAIC05MjEsNiArOTIxLDQ0IEBAIHZvaWQgaW1hX2tleGVjX2NtZGxpbmUo
aW50IGtlcm5lbF9mZCwgY29uc3Qgdm9pZCAqYnVmLCBpbnQgc2l6ZSkKPiA+PiAgIAlmZHB1dChm
KTsKPiA+PiAgIH0KPiA+PiAgIAo+ID4+ICsvKioKPiA+PiArICogaW1hX21lYXN1cmVfY3JpdGlj
YWxfZGF0YSAtIG1lYXN1cmUga2VybmVsIHN1YnN5c3RlbSBkYXRhCj4gPj4gKyAqIGNyaXRpY2Fs
IHRvIGludGVncml0eSBvZiB0aGUga2VybmVsCj4gPiAKPiA+IFBsZWFzZSBjaGFuZ2UgdGhpcyB0
byAibWVhc3VyZSBrZXJuZWwgaW50ZWdyaXR5IGNyaXRpY2FsIGRhdGEiLgo+ID4gCj4gKlF1ZXN0
aW9uKgo+IFRoYW5rcyBNaW1pLiBEbyB5b3Ugd2FudCB1cyBqdXN0IHRvIHVwZGF0ZSB0aGUgZGVz
Y3JpcHRpb24sIG9yIGRvIHlvdQo+IHdhbnQgdXMgdG8gdXBkYXRlIHRoZSBmdW5jdGlvbiBuYW1l
IHRvbz8KCkp1c3QgdGhlIGRlc2NyaXB0aW9uLgoKPiAKPiBJIGJlbGlldmUgeW91IG1lYW50IGp1
c3QgZGVzY3JpcHRpb24sIGJ1dCBzdGlsbCB3YW50IHRvIGNsYXJpZnkuCj4gCj4gaW1hX21lYXN1
cmVfa2VybmVsX2ludGVncml0eV9jcml0aWNhbF9kYXRhKCkgd291bGQgYmUgdG9vIGxvbmcuCj4g
TWF5YmUgaW1hX21lYXN1cmVfaW50ZWdyaXR5X2NyaXRpY2FsX2RhdGEoKT8KPiAKPiBPciBkbyB5
b3Ugd2FudCB1cyB0byBrZWVwIHRoZSBleGlzdGluZyBpbWFfbWVhc3VyZV9jcml0aWNhbF9kYXRh
KCk/Cj4gQ291bGQgeW91IHBsZWFzZSBsZXQgdXMga25vdz8KPiAKPiA+PiArICogQGV2ZW50X2Rh
dGFfc291cmNlOiBuYW1lIG9mIHRoZSBkYXRhIHNvdXJjZSBiZWluZyBtZWFzdXJlZDsKPiA+PiAr
ICogdHlwaWNhbGx5IGl0IHNob3VsZCBiZSB0aGUgbmFtZSBvZiB0aGUga2VybmVsIHN1YnN5c3Rl
bSB0aGF0IGlzIHNlbmRpbmcKPiA+PiArICogdGhlIGRhdGEgZm9yIG1lYXN1cmVtZW50Cj4gPiAK
PiA+IEluY2x1ZGluZyAiZGF0YV9zb3VyY2UiIGhlcmUgaXNuJ3QgcXVpdGUgcmlnaHQuICAiZGF0
YSBzb3VyY2UiIHNob3VsZAo+ID4gb25seSBiZSBhZGRlZCBpbiB0aGUgZmlyc3QgcGF0Y2ggd2hp
Y2ggdXNlcyBpdCwgbm90IGhlcmUuICAgV2hlbiBhZGRpbmcKPiA+IGl0IHBsZWFzZSBzaG9ydGVu
IHRoZSBmaWVsZCBkZXNjcmlwdGlvbiB0byAia2VybmVsIGRhdGEgc291cmNlIi4gICBUaGUKPiA+
IGxvbmdlciBleHBsYW5hdGlvbiBjYW4gYmUgaW5jbHVkZWQgaW4gdGhlIGxvbmdlciBmdW5jdGlv
biBkZXNjcmlwdGlvbi4KPiA+IAo+ICpRdWVzdGlvbioKPiBEbyB5b3UgbWVhbiB0aGUgcGFyYW1l
dGVyIEBldmVudF9kYXRhX3NvdXJjZSBzaG91bGQgYmUgcmVtb3ZlZCBmcm9tIHRoaXMKPiBwYXRj
aD8gQW5kIHRoZW4gbGF0ZXIgYWRkZWQgaW4gcGF0Y2ggNy83IOKAkyB3aGVyZSBTZUxpbnV4IHVz
ZXMgaXQ/CgpEYXRhIHNvdXJjZSBzdXBwb3J0IGRvZXNuJ3QgYmVsb25nIGluIHRoaXMgcGF0Y2gu
ICBFYWNoIHBhdGNoIHNob3VsZCBkbwpvbmUgbG9naWNhbCB0aGluZyBhbmQgb25seSB0aGF0IG9u
ZSB0aGluZy4gIFRoaXMgcGF0Y2ggaXMgYWRkaW5nCnN1cHBvcnQgZm9yIG1lYXN1cmluZyBjcml0
aWNhbCBkYXRhLiAgVGhlIGRhdGEgc291cmNlIHBhdGNoIHdpbGwgbGltaXQKdGhlIGNyaXRpY2Fs
IGRhdGEgYmVpbmcgbWVhc3VyZWQuCgpPdGhlciB0aGFuIHVwZGF0aW5nIHRoZSBkYXRhIHNvdXJj
ZSBsaXN0IGluIHRoZSBkb2N1bWVudGF0aW9uLApkZWZpbml0ZWx5IGRvIG5vdCBhZGQgZGF0YSBz
b3VyY2Ugc3VwcG9ydCB0byB0aGUgU0VMaW51eCBwYXRjaC4KCnRoYW5rcywKCk1pbWkKCgotLQpk
bS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

