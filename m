Return-Path: <SRS0=jKmk=GI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63924C433E0
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 20:17:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A978E22D5A
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 20:17:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A978E22D5A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-HIWfd2g7N3CUEUfj710glA-1; Tue, 05 Jan 2021 15:17:05 -0500
X-MC-Unique: HIWfd2g7N3CUEUfj710glA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90CDA80F040;
	Tue,  5 Jan 2021 20:17:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3840B57;
	Tue,  5 Jan 2021 20:17:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0B17D180954D;
	Tue,  5 Jan 2021 20:17:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 105KGwCx017683 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 5 Jan 2021 15:16:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 39B4E2026DE4; Tue,  5 Jan 2021 20:16:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3476B2026D76
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 20:16:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE189858284
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 20:16:55 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
	[148.163.156.1]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-454-f6QNyG-hNIS-Upvunsx3uQ-1; Tue, 05 Jan 2021 15:16:50 -0500
X-MC-Unique: f6QNyG-hNIS-Upvunsx3uQ-1
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
	105JYjej170045; Tue, 5 Jan 2021 15:16:49 -0500
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 35vwc030jt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 05 Jan 2021 15:16:49 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 105KF645144664;
	Tue, 5 Jan 2021 15:16:48 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.98])
	by mx0a-001b2d01.pphosted.com with ESMTP id 35vwc030j3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 05 Jan 2021 15:16:48 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	105KCU4o030045; Tue, 5 Jan 2021 20:16:46 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com
	(d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by ppma03ams.nl.ibm.com with ESMTP id 35tgf8b6r0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 05 Jan 2021 20:16:46 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com
	[9.149.105.61])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 105KGiCp41091494
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Tue, 5 Jan 2021 20:16:44 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0827111C04C;
	Tue,  5 Jan 2021 20:16:44 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B780511C050;
	Tue,  5 Jan 2021 20:16:40 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown
	[9.160.22.135])
	by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue,  5 Jan 2021 20:16:40 +0000 (GMT)
Message-ID: <3b5dd02fab216746409ccede82f51382539824d3.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, 
	snitzer@redhat.com, gmazyland@gmail.com, paul@paul-moore.com
Date: Tue, 05 Jan 2021 15:16:39 -0500
In-Reply-To: <9afab02b-4b02-485d-cca2-bdf8b1cf87e7@linux.microsoft.com>
References: <20201212180251.9943-1-tusharsu@linux.microsoft.com>
	<20201212180251.9943-4-tusharsu@linux.microsoft.com>
	<5ae72a76664ce7011d3041689efbfe1a2c67d44f.camel@linux.ibm.com>
	<9afab02b-4b02-485d-cca2-bdf8b1cf87e7@linux.microsoft.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343, 18.0.737
	definitions=2021-01-05_06:2021-01-05,
	2021-01-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	mlxscore=0 suspectscore=0
	phishscore=0 clxscore=1015 impostorscore=0 adultscore=0 mlxlogscore=999
	lowpriorityscore=0 priorityscore=1501 bulkscore=0 spamscore=0
	malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2101050112
X-MIME-Autoconverted: from 8bit to quoted-printable by
	mx0a-001b2d01.pphosted.com id 105JYjej170045
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 105KGwCx017683
X-loop: dm-devel@redhat.com
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v9 3/8] IMA: define a hook to measure kernel
 integrity critical data
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCAyMDIxLTAxLTA1IGF0IDEyOjAxIC0wODAwLCBUdXNoYXIgU3VnYW5kaGkgd3JvdGU6
Cj4gCj4gPj4gZGF0YS4gSG93ZXZlciwgdmFyaW91cyBkYXRhIHN0cnVjdHVyZXMsIHBvbGljaWVz
LCBhbmQgc3RhdGVzCj4gPiAKPiA+IEhlcmUgYW5kIGV2ZXJ5d2hlcmUgZWxzZSwgdGhlcmUgYXJl
IHR3byBibGFua3MgYWZ0ZXIgYSBwZXJpb2QuCj4gPiAKPiBJIGNoZWNrZWQgdGhpcyBwYXRjaCBm
aWxlIGluIG11bHRpcGxlIHRleHQgZWRpdG9ycywgYnV0IGNvdWxkbuKAmXQgZmluZAo+IGFueSBp
bnN0YW5jZSBvZiBwZXJpb2QgZm9sbG93ZWQgYnkgdHdvIHNwYWNlcy4gSSB3aWxsIGRvdWJsZSBj
aGVjayBhZ2FpbiAKPiBhbGwgdGhlIHBhdGNoZXMgZm9yIG11bHRpcGxlIHNwYWNlcywgYW5kIHJl
bW92ZSB0aGVtIGlmIGFueS4KClRoZXJlIHNob3VsZCBiZSB0d28gYmxhbmtzIGFmdGVyIGEgcGVy
aW9kLCBub3Qgb25lIGJsYW5rLgoKPHNuaXA+Cgo+ID4+ICsgKgo+ID4+ICsgKiBNZWFzdXJlIHRo
ZSBrZXJuZWwgc3Vic3lzdGVtIGRhdGEsIGNyaXRpY2FsIHRvIHRoZSBpbnRlZ3JpdHkgb2YgdGhl
IGtlcm5lbCwKPiA+PiArICogaW50byB0aGUgSU1BIGxvZyBhbmQgZXh0ZW5kIHRoZSBAcGNyLgo+
ID4+ICsgKgo+ID4+ICsgKiBVc2UgQGV2ZW50X25hbWUgdG8gZGVzY3JpYmUgdGhlIHN0YXRlL2J1
ZmZlciBkYXRhIGNoYW5nZS4KPiA+PiArICogRXhhbXBsZXMgb2YgY3JpdGljYWwgZGF0YSAoQGJ1
ZikgY291bGQgYmUgdmFyaW91cyBkYXRhIHN0cnVjdHVyZXMsCj4gPj4gKyAqIHBvbGljaWVzLCBh
bmQgc3RhdGVzIHN0b3JlZCBpbiBrZXJuZWwgbWVtb3J5IHRoYXQgY2FuIGltcGFjdCB0aGUgaW50
ZWdyaXR5Cj4gPj4gKyAqIG9mIHRoZSBzeXN0ZW0uCj4gPj4gKyAqCj4gPj4gKyAqIElmIEBtZWFz
dXJlX2J1Zl9oYXNoIGlzIHNldCB0byB0cnVlIC0gbWVhc3VyZSBoYXNoIG9mIHRoZSBidWZmZXIg
ZGF0YSwKPiA+PiArICogZWxzZSBtZWFzdXJlIHRoZSBidWZmZXIgZGF0YSBpdHNlbGYuCj4gPj4g
KyAqIEBtZWFzdXJlX2J1Zl9oYXNoIGNhbiBiZSB1c2VkIHRvIHNhdmUgc3BhY2UsIGlmIHRoZSBk
YXRhIGJlaW5nIG1lYXN1cmVkCj4gPj4gKyAqIGlzIHRvbyBsYXJnZS4KPiA+PiArICoKPiA+PiAr
ICogVGhlIGRhdGEgKEBidWYpIGNhbiBvbmx5IGJlIG1lYXN1cmVkLCBub3QgYXBwcmFpc2VkLgo+
ID4gCj4gPiBUaGUgIi8qKiIgaXMgdGhlIHN0YXJ0IG9mIGtlcm5lbC1kb2MuICBIYXZlIHlvdSBz
ZWVuIGFueXdoZXJlIGVsc2UgaW4KPiBNeSBpbXByZXNzaW9uIHdhcyB0aGUgaG9va3MgaW4gaW1h
X21haW4uYyBlLmcuIGltYV9maWxlX2ZyZWUoKQo+IGltYV9maWxlX21tYXAoKSByZXF1aXJlZCB0
aGUgZG91YmxlLWFzdGVyaXNrICgiLyoqIiksIGFuZCBpbnRlcm5hbAo+IGZ1bmN0aW9ucyBsaWtl
IGltYV9yZHdyX3Zpb2xhdGlvbl9jaGVjaygpIHJlcXVpcmUgYSBzaW5nbGUtYXN0ZXJpc2sKPiAo
Ii8qIikKPiAKPiBrZXJuZWwtZG9jLnJzdCBzdWdnZXN0IHRoZSBkb3VibGUtYXN0ZXJpc2sgKCIv
KioiKSBmb3IgZnVuY3Rpb24gY29tbWVudAo+IGFzIHdlbGwuCj4gCj4gRnVuY3Rpb24gZG9jdW1l
bnRhdGlvbgo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KPiAKPiBUaGUgZ2VuZXJhbCBmb3JtYXQg
b2YgYSBmdW5jdGlvbiBhbmQgZnVuY3Rpb24tbGlrZSBtYWNybyBrZXJuZWwtZG9jIAo+IGNvbW1l
bnQgaXM6Ogo+IAo+ICAgIC8qKgo+ICAgICAqIGZ1bmN0aW9uX25hbWUoKSAtIEJyaWVmIGRlc2Ny
aXB0aW9uIG9mIGZ1bmN0aW9uLgo+IAo+IFBsZWFzZSBsZXQgbWUga25vdyBpZiB5b3Ugc3RpbGwg
d2FudCBtZSB0byByZW1vdmUgdGhlIGRvdWJsZS1hc3Rlcmlzawo+ICgiLyoqIikgaGVyZS4KClll
cywgb2YgY291cnNlIHRoaXMgbmVlZHMgdG8gYmUga2VybmVsLWRvYyBhbmQgcmVxdWlyZXMgIi8q
KiIKCj4gCj4gPiB0aGUga2VybmVsIHVzaW5nIHRoZSBAPHZhcmlhYmxlIG5hbWU+IGluIHRoZSBs
b25nZXIgZnVuY3Rpb24KPiA+IGRlc2NyaXB0aW9uPyAgSGF2ZSB5b3Ugc2VlbiB0aGlzIHN0eWxl
IG9mIGxvbmdlciAgIGZ1bmN0aW9uCj4gPiBkZXNjcmlwdGlvbj8gIFJlZmVyIHRvIERvY3VtZW50
YXRpb24vZG9jLWd1aWRlL2tlcm5lbC1kb2MucnN0IGFuZCBvdGhlcgo+ID4gY29kZSBmb3IgZXhh
bXBsZXMuCj4gPiAKPiBUaGFua3MuIEkgd2lsbCByZW1vdmUgdGhlIHByZWZpeCAiQCIgZnJvbSA8
dmFyaWFibGUgbmFtZT4gaW4gdGhlIGxvbmdlciAKPiBmdW5jdGlvbiBkZXNjcmlwdGlvbi4KClJl
bW92aW5nIHRoZSBAPHZhcmlhYmxlIG5hbWU+IGlzbid0IHN1ZmZpY2llbnQuICBQbGVhc2UgbG9v
ayBhdCBvdGhlcgpleGFtcGxlcyBvZiBsb25nZXIgZnVuY3Rpb24gZGVmaW5pdGlvbnMgYmVmb3Jl
IHJlcG9zdGluZy4KCnRoYW5rcywKCk1pbWkKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0t
ZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWw=

