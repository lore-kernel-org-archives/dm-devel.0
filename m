Return-Path: <SRS0=awJs=ET=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 655ACC4742C
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:02:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C5EBD20857
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:02:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5EBD20857
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-_NnEe1IzMxKJEqod72Cebg-1; Fri, 13 Nov 2020 03:02:45 -0500
X-MC-Unique: _NnEe1IzMxKJEqod72Cebg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B9BF8049E2;
	Fri, 13 Nov 2020 08:02:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B7055577C;
	Fri, 13 Nov 2020 08:02:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 50BC85810D;
	Fri, 13 Nov 2020 08:02:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ACMQJuD010994 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Nov 2020 17:26:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2AB4D107124; Thu, 12 Nov 2020 22:26:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 248D710711D
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 22:26:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D14CD85829F
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 22:26:16 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
	[148.163.156.1]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-521-OC5D8DrjPwOKpg3Z5dSI_g-1; Thu, 12 Nov 2020 17:26:12 -0500
X-MC-Unique: OC5D8DrjPwOKpg3Z5dSI_g-1
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
	0ACMLe6H075500; Thu, 12 Nov 2020 17:26:10 -0500
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 34sc39tkxv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 12 Nov 2020 17:26:10 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ACMLfUi075596;
	Thu, 12 Nov 2020 17:26:10 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 34sc39tkx5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 12 Nov 2020 17:26:10 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	0ACMEMM8027040; Thu, 12 Nov 2020 22:19:36 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com
	(b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma06ams.nl.ibm.com with ESMTP id 34njuh63rg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 12 Nov 2020 22:19:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com
	[9.149.105.61])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 0ACMJX1V57540880
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Thu, 12 Nov 2020 22:19:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B1C8B11C04C;
	Thu, 12 Nov 2020 22:19:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 862A411C050;
	Thu, 12 Nov 2020 22:19:30 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown
	[9.160.105.204])
	by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Thu, 12 Nov 2020 22:19:30 +0000 (GMT)
Message-ID: <0fa1a12388681b49167b58e349cb7c9e996dcd05.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, 
	snitzer@redhat.com, gmazyland@gmail.com, paul@paul-moore.com
Date: Thu, 12 Nov 2020 17:19:29 -0500
In-Reply-To: <7034a775-cde6-1eae-132a-4cb84f310bca@linux.microsoft.com>
References: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
	<20201101222626.6111-3-tusharsu@linux.microsoft.com>
	<d0e96ccc49590c5ff11675661592b70b0f021636.camel@linux.ibm.com>
	<7034a775-cde6-1eae-132a-4cb84f310bca@linux.microsoft.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312, 18.0.737
	definitions=2020-11-12_13:2020-11-12,
	2020-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	mlxscore=0 malwarescore=0
	adultscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0
	suspectscore=0 bulkscore=0 clxscore=1015 spamscore=0 priorityscore=1501
	impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2011120124
X-MIME-Autoconverted: from 8bit to quoted-printable by
	mx0a-001b2d01.pphosted.com id 0ACMLe6H075500
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0ACMQJuD010994
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 13 Nov 2020 03:02:15 -0500
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCAyMDIwLTExLTEyIGF0IDEzOjQ3IC0wODAwLCBUdXNoYXIgU3VnYW5kaGkgd3JvdGU6
Cj4gPiBPbiBTdW4sIDIwMjAtMTEtMDEgYXQgMTQ6MjYgLTA4MDAsIFR1c2hhciBTdWdhbmRoaSB3
cm90ZToKPiA+PiBwcm9jZXNzX2J1ZmZlcl9tZWFzdXJlbWVudCgpIGN1cnJlbnRseSBvbmx5IG1l
YXN1cmVzIHRoZSBpbnB1dCBidWZmZXIuCj4gPj4gSW4gY2FzZSBvZiBTZUxpbnV4IHBvbGljeSBt
ZWFzdXJlbWVudCwgdGhlIHBvbGljeSBiZWluZyBtZWFzdXJlZCBjb3VsZAo+ID4+IGJlIGxhcmdl
IChzZXZlcmFsIE1CKS4gVGhpcyBtYXkgcmVzdWx0IGluIGEgbGFyZ2UgZW50cnkgaW4gSU1BCj4g
Pj4gbWVhc3VyZW1lbnQgbG9nLgo+ID4gCj4gPiBTRUxpbnV4IGlzIGFuIGV4YW1wbGUgb2YgbWVh
c3VyaW5nIGxhcmdlIGJ1ZmZlciBkYXRhLiAgUGxlYXNlIHJld3JpdGUKPiA+IHRoaXMgcGF0Y2gg
ZGVzY3JpcHRpb24gKGFuZCB0aGUgb3RoZXIgcGF0Y2ggZGVzY3JpcHRpb25zIGluIHRoaXMgcGF0
Y2gKPiA+IHNldCkgd2l0aG91dCB1c2luZyB0aGUgZXhhbXBsZSB0byBkZXNjcmliZSBpdHMgcHVy
cG9zZSBbMV0uCj4gPiAKPiA+IEluIHRoaXMgY2FzZSwgeW91IG1pZ2h0IHNheSwKPiA+IAo+ID4g
VGhlIG9yaWdpbmFsIElNQSBidWZmZXIgZGF0YSBtZWFzdXJlbWVudCBzaXplcyB3ZXJlIHNtYWxs
IChlLmcuIGJvb3QKPiA+IGNvbW1hbmQgbGluZSksIGJ1dCBuZXcgYnVmZmVyIGRhdGEgbWVhc3Vy
ZW1lbnQgdXNlIGNhc2VzIGFyZSBhIGxvdAo+ID4gbGFyZ2VyLiAgSnVzdCBhcyBJTUEgbWVhc3Vy
ZXMgdGhlIGZpbGUgZGF0YSBoYXNoLCBub3QgdGhlIGZpbGUgZGF0YSwKPiA+IElNQSBzaG91bGQg
c2ltaWxhcmx5IHN1cHBvcnQgbWVhc3VyaW5nIHRoZSBidWZmZXIgZGF0YSBoYXNoLgo+ID4gCj4g
U3VyZS4gVGhhbmtzIGEgbG90IGZvciBnaXZpbmcgYW4gZXhhbXBsZSB3b3JkaW5nIGZvciB1cy4g
V2lsbCB1cGRhdGUuCj4gPj4KPiA+PiBJbnRyb2R1Y2UgYSBib29sZWFuIHBhcmFtZXRlciBtZWFz
dXJlX2J1Zl9oYXNoIHRvIHN1cHBvcnQgbWVhc3VyaW5nCj4gPj4gaGFzaCBvZiBhIGJ1ZmZlciwg
d2hpY2ggd291bGQgYmUgbXVjaCBzbWFsbGVyLCBpbnN0ZWFkIG9mIHRoZSBidWZmZXIKPiA+PiBp
dHNlbGYuCj4gPiAKPiA+PiBUbyB1c2UgdGhlIGZ1bmN0aW9uYWxpdHkgaW50cm9kdWNlZCBpbiB0
aGlzIHBhdGNoLCB0aGUgYXR0ZXN0YXRpb24KPiA+PiBjbGllbnQgYW5kIHRoZSBzZXJ2ZXIgY2hh
bmdlcyBuZWVkIHRvIGdvIGhhbmQgaW4gaGFuZC4gVGhlCj4gPj4gY2xpZW50L2tlcm5lbCB3b3Vs
ZCBrbm93IHdoYXQgZGF0YSBpcyBiZWluZyBtZWFzdXJlZCBhcy1pcwo+ID4+IChlLmcuIEtFWEVD
X0NNRExJTkUpLCBhbmQgd2hhdCBkYXRhIGhhcyBpdOKAmXMgaGFzaCBtZWFzdXJlZCAoZS5nLiBT
ZUxpbnV4Cj4gPj4gUG9saWN5KS4gQW5kIHRoZSBhdHRlc3RhdGlvbiBzZXJ2ZXIgc2hvdWxkIHZl
cmlmeSBkYXRhL2hhc2ggYWNjb3JkaW5nbHkuCj4gPj4KPiA+PiBKdXN0IGxpa2UgdGhlIGRhdGEg
YmVpbmcgbWVhc3VyZWQgaW4gb3RoZXIgY2FzZXMsIHRoZSBhdHRlc3RhdGlvbiBzZXJ2ZXIKPiA+
PiB3aWxsIGtub3cgd2hhdCBhcmUgcG9zc2libGUgdmFsdWVzIG9mIHRoZSBsYXJnZSBidWZmZXJz
IGJlaW5nIG1lYXN1cmVkLgo+ID4+IGUuZy4gdGhlIHBvc3NpYmxlIHZhbGlkIFNlTGludXggcG9s
aWN5IHZhbHVlcyB0aGF0IGFyZSBiZWluZyBwdXNoZWQgdG8KPiA+PiB0aGUgY2xpZW50LiBUaGUg
YXR0ZXN0YXRpb24gc2VydmVyIHdpbGwgaGF2ZSB0byBtYWludGFpbiB0aGUgaGFzaCBvZgo+ID4+
IHRob3NlIGJ1ZmZlciB2YWx1ZXMuCj4gPiAKPiA+IEVhY2ggcGF0Y2ggaW4gdGhlIHBhdGNoIHNl
dCBidWlsZHMgdXBvbiB0aGUgcHJldmlvdXMgb25lLiAgIChUaGluayBvZgo+ID4gaXQgYXMgYSBz
dG9yeSwgd2hlcmUgZWFjaCBjaGFwdGVyIGJ1aWxkcyB1cG9uIHRoZSBwcmV2aW91cyBvbmVzLikK
PiA+IFdpdGggcmFyZSBleGNlcHRpb25zLCBzaG91bGQgcGF0Y2hlcyByZWZlcmVuY2Ugc3Vic2Vx
dWVudCBwYXRjaGVzLiBbMl0KPiA+IAo+ID4gWzFdIFJlZmVyIHRvIERvY3VtZW50YXRpb24vcHJv
Y2Vzcy9zdWJtaXR0aW5nLXBhdGNoZXMucnN0Cj4gPiBbMl0gUmVmZXIgdG8gdGhlIHNlY3Rpb24g
IjgpIENvbW1lbnRpbmciIGluCj4gPiBEb2N1bWVudGF0aW9uL3Byb2Nlc3MvY29kaW5nLXN0eWxl
LnJzdAo+ID4gCj4gSSBhbSBub3Qgc3VyZSBpZiB5b3UgaGF2ZSBhbnkgY29uY2VybnMgYWJvdXQg
dGhlIGxhc3QgdHdvIHBhcmFncmFwaHMuCj4gVGhlIGRlc2NyaXB0aW9uIGFib3V0IHRoZSBhdHRl
c3RhdGlvbiBjbGllbnQgYW5kIHNlcnZlciAodGhlIGxhc3QgdHdvCj4gcGFyYWdyYXBocykgd2Fz
IGFkZGVkIGZvciBpbmZvcm1hdGlvbi9jbGFyaWZpY2F0aW9uIHB1cnBvc2Ugb25seSwgYXMgcGVy
Cj4geW91ciBmZWVkYmFjayBvbiBwcmV2aW91cyBpdGVyYXRpb25zLiBUaGUgc3Vic2VxdWVudCBw
YXRjaGVzIGRvbuKAmXQgaGF2ZQo+IGFueSBjb2RlIHBlcnRhaW5pbmcgdG8gYXR0ZXN0YXRpb24g
Y2xpZW50L3NlcnZlci4KPiAKPiAqUXVlc3Rpb24qCj4gTWF5YmUgdGhlIGxhc3QgdHdvIHBhcmFn
cmFwaHMgYXJlIGNvbmZ1c2luZy9yZWR1bmRhbnQuIENvdWxkIHlvdSBwbGVhc2UKPiBsZXQgbWUg
a25vdyBpZiBJIHNob3VsZCByZW1vdmUgdGhlIGFib3ZlIHR3byBwYXJhZ3JhcGhzIGFsdG9nZXRo
ZXI/IAo+IChzdGFydGluZyB3aXRoIOKAnFRvIHVzZSB0aGUgZnVuY3Rpb25hbGl0eSBpbnRyb2R1
Y2VkIGluIHRoaXMgcGF0Y2ggLi4u4oCdKQo+IAo+IElmIHdlIGRlY2lkZSB0byBrZWVwIHRoZSBw
YXJhZ3JhcGhzLCBJIHdpbGwgcmVtb3ZlIHRoZSBzcGVjaWZpYyBleGFtcGxlcwo+IChLRVhFQ19D
TURMSU5FLCBTZUxpbnV4IGV0Yy4pIGFzIHlvdSBtZW50aW9uZWQgZWxzZXdoZXJlLgoKSW5zdGVh
ZCBvZiB0aGUgYWJvdmUgdHdvIHBhcmFncmFwaHMsIHBlcmhhcHMgZXhwbGFpbiBob3cgbWVhc3Vy
aW5nIHRoZQpmaWxlIGRhdGEgaGFzaCBkaWZmZXJzIGZyb20gbWVhc3VyaW5nIHRoZSBidWZmZXIg
ZGF0YSBoYXNoLiAgS2VlcCB0aGUKZXhwbGFuYXRpb24gZ2VuZXJpYywgc2hvcnQgYW5kIHNpbXBs
ZS4KCk1pbWkKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpo
dHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

