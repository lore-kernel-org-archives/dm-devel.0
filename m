Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB856C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 17:52:28 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-h40LpdVEN_uiwUORlx3r0Q-1; Tue, 15 Feb 2022 12:52:22 -0500
X-MC-Unique: h40LpdVEN_uiwUORlx3r0Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52A7B1800D50;
	Tue, 15 Feb 2022 17:52:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF3126E187;
	Tue, 15 Feb 2022 17:52:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AA8FB4BB7C;
	Tue, 15 Feb 2022 17:52:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21FHq9TY024474 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Feb 2022 12:52:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 226BE2166B5D; Tue, 15 Feb 2022 17:52:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D76D2166B4F
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 17:52:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3A7E3C23382
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 17:52:05 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
	[148.163.156.1]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-344-ePzhCKw3MH2O6_RHg6TsbQ-1; Tue, 15 Feb 2022 12:52:01 -0500
X-MC-Unique: ePzhCKw3MH2O6_RHg6TsbQ-1
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	21FHHTJT014589; Tue, 15 Feb 2022 17:52:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3e8gesrqbx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 15 Feb 2022 17:52:00 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21FHoPkf032748;
	Tue, 15 Feb 2022 17:51:59 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.98])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3e8gesrqb1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 15 Feb 2022 17:51:59 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21FHmXSf003285;
	Tue, 15 Feb 2022 17:51:57 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com
	(d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by ppma03ams.nl.ibm.com with ESMTP id 3e64ha1q5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 15 Feb 2022 17:51:57 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com
	[9.149.105.232])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 21FHptxE37421398
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Tue, 15 Feb 2022 17:51:55 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4926952050;
	Tue, 15 Feb 2022 17:51:55 +0000 (GMT)
Received: from [9.145.18.90] (unknown [9.145.18.90])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E5EB25204E;
	Tue, 15 Feb 2022 17:51:54 +0000 (GMT)
Message-ID: <33ffe0bf-7ffb-4ca4-91d0-fc55ea67c751@linux.ibm.com>
Date: Tue, 15 Feb 2022 18:51:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
To: Martin Wilck <martin.wilck@suse.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
References: <20220214185559.28363-1-maier@linux.ibm.com>
	<20220214185559.28363-2-maier@linux.ibm.com>
	<f122514cab837e0e613a105c90335a91f60a72d0.camel@suse.com>
From: Steffen Maier <maier@linux.ibm.com>
In-Reply-To: <f122514cab837e0e613a105c90335a91f60a72d0.camel@suse.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SpD8WeC0Ah_A38TQ0Et0rlCrBFrrovAg
X-Proofpoint-GUID: V-ktfJBC8cEigbSmaigbVJZd8fwPNpc_
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
	engine=ICAP:2.0.205, Aquarius:18.0.816, Hydra:6.0.425,
	FMLib:17.11.62.513
	definitions=2022-02-15_04,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	mlxscore=0 malwarescore=0
	spamscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0
	priorityscore=1501 phishscore=0 clxscore=1015 lowpriorityscore=0
	impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202150101
X-MIME-Autoconverted: from 8bit to base64 by mx0a-001b2d01.pphosted.com id
	21FHHTJT014589
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21FHq9TY024474
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 1/2] libmultipath: support host adapter
 name lookup for s390x ccw bus
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
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMi8xNC8yMiAyMDoxOSwgTWFydGluIFdpbGNrIHdyb3RlOgo+IE9uIE1vbiwgMjAyMi0wMi0x
NCBhdCAxOTo1NSArMDEwMCwgU3RlZmZlbiBNYWllciB3cm90ZToKPj4gVGhlcmUgYXJlIGFsc28g
KEZDUCkgSEJBcyB0aGF0IGFwcGVhciBvbiBhIGJ1cyBkaWZmZXJlbnQgZnJvbSBQQ0kuCj4+Cj4+
IENvbXBsZW1lbnRzIHYwLjYuMCBjb21taXQKPj4gMDFhYjJhNDY4ZWEyICgibGlibXVsdGlwYXRo
OiBBZGQgYWRkaXRpb25hbCBwYXRoIHdpbGRjYXJkcyIpLgo+Pgo+PiBXaXRoIHRoYXQgd2UgY2Fu
IGVhc2lseSBnZXQgdGhlIGZ1bGwgRkNQIGFkZHJlc3NpbmcgdHJpcGxldAo+PiAoSEJBLCBXV1BO
LCBMVU4pIGZyb20gbXVsdGlwYXRoIHRvb2xzIHdpdGhvdXQgYWRkaXRpb25hbCB0b29scwo+PiBh
bmQgY29ycmVsYXRpb246Cj4+Cj4+ICQgbXVsdGlwYXRoZCAtaydzaG93IHBhdGhzIGZvcm1hdCAi
JXd8JWl8JWF8JXIiJwo+PiB1dWlkwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgfGhjaWzCoMKgwqDCoMKgwqAgfGhvc3QgYWRhcHRlcnx0YXJn
ZXQKPj4gV1dQTgo+PiAzNjAwNTA3NjQwMDgyMDI5M2U4MDAwMDAwMDAwMDAwYTB8MTowOjM6MTYw
wqAgfDAuMC41MDgwICAgIHwweDUwMDUwNzY4MGIyNWM0NDkKPj4gMzYwMDUwNzY0MDA4MjAyOTNl
ODAwMDAwMDAwMDAwMGEwfDE6MDo0OjE2MMKgIHwwLjAuNTA4MCAgICB8MHg1MDA1MDc2ODBiMjVj
NDQ4Cj4+IDM2MDA1MDc2NDAwODIwMjkzZTgwMDAwMDAwMDAwMDBhMHw1ODowOjM6MTYwIHwwLjAu
NTBjMCAgICB8MHg1MDA1MDc2ODBiMjZjNDQ5Cj4+IDM2MDA1MDc2NDAwODIwMjkzZTgwMDAwMDAw
MDAwMDBhMHw1ODowOjQ6MTYwIHwwLjAuNTBjMCAgICB8MHg1MDA1MDc2ODBiMjZjNDQ4Cj4+Cj4+
ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgXl5eXl5eXl4KPj4gIMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIGluc3RlYWQgb2YgW3VuZGVmXQo+Pgo+PiBBcyBhIHNpZGUgZWZmZWN0IHRoaXMgcGF0Y2gg
dGhlb3JldGljYWxseSBhbHNvIGVuYWJsZXMgZ3JvdXAgYnkKPj4gaG9zdCBhZGFwdGVyIGZvciBz
MzkweCBiYXNlZCBvbiB2MC42LjAgY29tbWl0IGEyOGU2MWU1Y2M5YQo+PiAoIkNyYWZ0ZWQgb3Jk
ZXJpbmcgb2YgY2hpbGQgcGF0aHMgZm9yIHJvdW5kIHJvYmluIHBhdGggc2VsZWN0b3IiKS4KPj4K
Pj4gUmV2aWV3ZWQtYnk6IEJlbmphbWluIEJsb2NrIDxiYmxvY2tAbGludXguaWJtLmNvbT4KPj4g
U2lnbmVkLW9mZi1ieTogU3RlZmZlbiBNYWllciA8bWFpZXJAbGludXguaWJtLmNvbT4KPj4gLS0t
Cj4+Cj4+IE5vdGVzOgo+PiAgwqDCoMKgIENoYW5nZXMgc2luY2UgdjE6Cj4+ICDCoMKgwqAgLSBN
YWtlIHN5c2ZzX2dldF9ob3N0X3BjaV9uYW1lKCkgc3RhdGljIGFuZCBnZW5lcmFsaXplIGZvciBh
ZGFwdGVycwo+PiAgwqDCoMKgwqDCoCBvbiBkaWZmZXJlbnQgYnVzIHR5cGVzLCBpbiBvcmRlciB0
byByZWR1Y2UgY29kZSBkdXBsaWNhdGlvbiAoQmVuKS4KPj4gIMKgwqDCoMKgwqAgVGhlIGFuY2Vz
dG9yIHdhbGsgaXMgYWx3YXlzIHRoZSBzYW1lIGJhc2VkIG9uIGtlcm5lbCBkcml2ZXIgY29yZQo+
PiAgwqDCoMKgwqDCoCB3aXRoIHRoZSBvbmx5IGRpZmZlcmVuY2UgdGhhdCBQQ0kgbWF0Y2hlcyBh
Z2FpbnN0IGRyaXZlciBuYW1lCj4+ICDCoMKgwqDCoMKgIHdoZXJlYXMgQ0NXIG1hdGNoZXMgYWdh
aW5zdCBzdWJzeXN0ZW0gbmFtZS4KPj4gIMKgwqDCoMKgwqAgVW5mb3J0dW5hdGVseSwgdGhlIGRp
ZmZzdGF0IGluY3JlYXNlZCBiZWNhdXNlIEkgaGFkIHRvIG1vdmUgdGhlCj4+ICDCoMKgwqDCoMKg
IG5ldyBzdGF0aWMgc3lzZnNfZ2V0X2hvc3RfYnVzX2lkKCkgaW4gZnJvbnQgb2YgaXRzIG9ubHkg
dXNlcgo+PiAgwqDCoMKgwqDCoCBzeXNmc19nZXRfaG9zdF9hZGFwdGVyX25hbWUoKSBbb3IgZWxz
ZSBhIHN0cmFuZ2UgdXBmcm9udCBwcm90b3R5cGUKPj4gIMKgwqDCoMKgwqAgd291bGQgaGF2ZSBi
ZWVuIG5lY2Vzc2FyeV0uCj4+Cj4+ICDCoGxpYm11bHRpcGF0aC9kaXNjb3ZlcnkuYyB8IDY5ICsr
KysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0KPj4gIMKgbGlibXVsdGlwYXRo
L2Rpc2NvdmVyeS5oIHzCoCAxIC0KPj4gIMKgMiBmaWxlcyBjaGFuZ2VkLCAzOCBpbnNlcnRpb25z
KCspLCAzMiBkZWxldGlvbnMoLSkKPj4KPj4gZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9kaXNj
b3ZlcnkuYyBiL2xpYm11bHRpcGF0aC9kaXNjb3ZlcnkuYwo+PiBpbmRleCA3ZDkzOWFlMDgwMDQu
LjVhYmE3ZThkNDk1ZiAxMDA2NDQKPj4gLS0tIGEvbGlibXVsdGlwYXRoL2Rpc2NvdmVyeS5jCj4+
ICsrKyBiL2xpYm11bHRpcGF0aC9kaXNjb3ZlcnkuYwo+Pgo+PiBbLi4uXQo+PiAtCj4+IC1pbnQg
c3lzZnNfZ2V0X2hvc3RfcGNpX25hbWUoY29uc3Qgc3RydWN0IHBhdGggKnBwLCBjaGFyICpwY2lf
bmFtZSkKPj4gK3N0YXRpYyBpbnQgc3lzZnNfZ2V0X2hvc3RfYnVzX2lkKGNvbnN0IHN0cnVjdCBw
YXRoICpwcCwgY2hhcgo+PiAqYnVzX2lkKQo+PiAgwqB7Cj4+ICDCoMKgwqDCoMKgwqDCoMKgc3Ry
dWN0IHVkZXZfZGV2aWNlICpob3N0ZGV2LCAqcGFyZW50Owo+PiAgwqDCoMKgwqDCoMKgwqDCoGNo
YXIgaG9zdF9uYW1lW0hPU1RfTkFNRV9MRU5dOwo+PiAtwqDCoMKgwqDCoMKgwqBjb25zdCBjaGFy
ICpkcml2ZXJfbmFtZSwgKnZhbHVlOwo+PiArwqDCoMKgwqDCoMKgwqBjb25zdCBjaGFyICpkcml2
ZXJfbmFtZSwgKnN1YnN5c3RlbV9uYW1lLCAqdmFsdWU7Cj4+ICAgCj4+IC3CoMKgwqDCoMKgwqDC
oGlmICghcHAgfHwgIXBjaV9uYW1lKQo+PiArwqDCoMKgwqDCoMKgwqBpZiAoIXBwIHx8ICFidXNf
aWQpCj4+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAxOwo+PiAgIAo+
PiAgwqDCoMKgwqDCoMKgwqDCoHNwcmludGYoaG9zdF9uYW1lLCAiaG9zdCVkIiwgcHAtPnNnX2lk
Lmhvc3Rfbm8pOwo+IAo+IE5pdDogV2hpbGUgYXQgaXQsIHlvdSBjb3VsZCBoYXZlIGNoYW5nZWQg
c3ByaW50ZigpIHRvIHNucHJpbnRmKCkuCj4gQnV0IHRoaXMgaXMgbm8gcmVxdWlyZW1lbnQsIGNh
biBiZSBkb25lIHNlcGFyYXRlbHkgLyBsYXRlci4KPiAKPj4gQEAgLTUyNSwxMCArNDk5LDE3IEBA
IGludCBzeXNmc19nZXRfaG9zdF9wY2lfbmFtZShjb25zdCBzdHJ1Y3QgcGF0aAo+PiAqcHAsIGNo
YXIgKnBjaV9uYW1lKQo+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9Cj4+ICDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmICghc3RyY21wKGRyaXZlcl9uYW1lLCAi
cGNpZXBvcnQiKSkKPj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGJyZWFrOwo+IAo+IFRoZSBjb250ZXh0IGRvZXNuJ3Qgc2hvdyBpdCBoZXJlLCBidXQg
YWJvdmUgdGhlc2UgbGluZXMsIHdlIGhhdmUKPiAKPiAJCWlmICghZHJpdmVyX25hbWUpIHsKPiAJ
CQlwYXJlbnQgPSB1ZGV2X2RldmljZV9nZXRfcGFyZW50KHBhcmVudCk7Cj4gCQkJY29udGludWU7
Cj4gCQl9Cj4gCj4gSXMgaXQgY2VydGFpbiB0aGF0IHRoaXMgY29uZGl0aW9uIGNhbid0IGNhdXNl
IGEgdmFsaWQgY2N3IGRldmljZSAod2hlcmUKPiB0aGUgZHJpdmVyIGF0dHJpYnV0ZSBpc24ndCBy
ZXF1aXJlZCkgdG8gYmUgc2tpcHBlZCB3aXRoIHRoZSAiY29udGludWUiCj4gc3RhdGVtZW50PyBF
dmVuIGlmIHRoZSBhbnN3ZXIgaXMgInllcyIsIEknZCBwcmVmZXIgc2VsZi1leHBsYW5hdG9yeQoK
SSBoYWQgdGhlIHNhbWUgdGhvdWdodCwgYnV0IGl0IGRvZXMgd29yay4gQXBwYXJlbnRseSwgdGhl
IGRldmljZSBub2RlIHdlJ3JlIAppbnRlcmVzdGVkIGluIGZvciBjY3ctYXR0YWNoZWQgRkNQIGRl
dmljZXMgaGFzIGJvdGggZHJpdmVyIGFuZCBzdWJzeXN0ZW0gCmF0dHJpYnV0ZXMgdGhhdCBleGlz
dCBhbmQgYm90aCB3aXRoIGEgbm9uLWVtcHR5IHZhbHVlLiBTbyB3ZSdyZSBnb29kLCBldmVuIGlm
IAp0aGUgcHJlY2VkaW5nICJlYXJseSBjb250aW51ZSIgc2tpcHBlZCBhbiB1bmludGVyZXN0aW5n
IHBhcmVudC4gSG93ZXZlciwgCnByb3ZpbmcgZ2VuZXJhbGl0eSBpcyBiZXlvbmQgbXkgY2FwYWJp
bGl0aWVzLCBhcyBJJ20gbm90IGV2ZW4gc3VyZSBsaWJ1ZGV2IAp3b3JrcyBvbiB0aGUgdWRldiBk
YXRhYmFzZSBvciBzeXNmcyBkaXJlY3RseS4gRm9yIGluc3RhbmNlLAoKIyB1ZGV2YWRtIGluZm8g
LWEgL3N5cy9jbGFzcy9zY3NpX2hvc3QvaG9zdDIKCnNob3dzIFNVQlNZU1RFTSBhbmQgRFJJVkVS
IHByb3BlcnR5IGZvciBlYWNoIHBhcnQgb2YgdGhlIGFuY2VzdG9yIGNoYWluLCB0aG91Z2ggCnNv
bWV0aW1lcyB3aXRoIGVtcHR5IHN0cmluZyB2YWx1ZXMgd2hpY2ggd291bGQgbm90IGJlIGEgcHJv
YmxlbSwgd2hlcmVhcwoKIyBkaXI9JChyZWFkbGluayAtZSAvc3lzL2NsYXNzL3Njc2lfaG9zdC9o
b3N0Mi8pOyB3aGlsZSBbIC1uICIkZGlyIiBdOyBkbyBlY2hvIAokZGlyOyBscyAtbGFGICRkaXIv
ZHJpdmVyICRkaXIvc3Vic3lzdGVtOyBkaXI9JHtkaXIlLyp9OyBkb25lCgpzaG93cyBzb21lIGFu
Y2VzdG9ycyBjb21wbGV0ZWx5IGxhY2tpbmcgImRyaXZlciIgYW5kIHNvbWUgYWxzbyBsYWNraW5n
ICJzdWJzeXN0ZW0iLgoKPiBjb2RlIGhlcmUsIGJlY2F1c2Ugbm90IGFsbCBvZiB1cyBhcmUgczM5
MCAvIGNjdyBleHBlcnRzLgoKSSBkb24ndCB0aGluayB0aGVyZSBpcyBhbnl0aGluZyBzcGVjaWZp
YyB0byBhcmNoaXRlY3R1cmUgb3IgYnVzIHR5cGUuCgpJbiBmYWN0LCBJIHdhcyBzdXJwcmlzZWQg
dG8gc2VlIHRoaXMgY29kZSBoZXJlIHRvIG1hdGNoIGZvciBkcml2ZXIgInBjaWVwb3J0IiAKW2Fs
c28gInBjaSoqZSoqcG9ydCIgc291bmRzIGxpa2UgUENJLUV4cHJlc3MsIHNvIHdoYXQgYWJvdXQg
SEJBcyBhdHRhY2hlZCB0byAKdGhlIG9sZCBwYXJhbGxlbCBQQ0kgaW5zdGVhZCBvZiBQQ0llP10s
IGJlY2F1c2UgdWRldi1idWlsdGluLXBhdGhfaWQuYyBsb29rcyAKdmVyeSBjb25zaXN0ZW50IGFu
ZCBzaW1pbGFyIGJldHdlZW4gcGNpIGFuZCBjY3cgdG8gbWU6CgpzdGF0aWMgaW50IGJ1aWx0aW5f
cGF0aF9pZChzZF9kZXZpY2UgKmRldiwgc2RfbmV0bGluayAqKnJ0bmwsIGludCBhcmdjLCBjaGFy
IAoqYXJndltdLCBib29sIHRlc3QpIHsKCiAgICAgICAgLyogd2FsayB1cCB0aGUgY2hhaW4gb2Yg
ZGV2aWNlcyBhbmQgY29tcG9zZSBwYXRoICovCiAgICAgICAgIHBhcmVudCA9IGRldjsKICAgICAg
ICAgd2hpbGUgKHBhcmVudCkgewogICAgICAgICAgICAgICAgIGNvbnN0IGNoYXIgKnN1YnN5cywg
KnN5c25hbWU7CgogICAgICAgICAgICAgICAgIGlmIChzZF9kZXZpY2VfZ2V0X3N1YnN5c3RlbShw
YXJlbnQsICZzdWJzeXMpIDwgMCB8fAogICAgICAgICAgICAgICAgICAgICBzZF9kZXZpY2VfZ2V0
X3N5c25hbWUocGFyZW50LCAmc3lzbmFtZSkgPCAwKSB7CiAgICAgICAgICAgICAgICAgICAgICAg
ICA7CgogICAgICAgICAgICAgICAgIH0gZWxzZSBpZiAoc3RyZXEoc3Vic3lzLCAicGNpIikpIHsK
ICAgICAgICAgICAgICAgICAgICAgICAgIHBhdGhfcHJlcGVuZCgmcGF0aCwgInBjaS0lcyIsIHN5
c25hbWUpOwogICAgICAgICAgICAgICAgICAgICAgICAgaWYgKGNvbXBhdF9wYXRoKQogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBwYXRoX3ByZXBlbmQoJmNvbXBhdF9wYXRoLCAicGNp
LSVzIiwgc3lzbmFtZSk7CiAgICAgICAgICAgICAgICAgICAgICAgICBwYXJlbnQgPSBza2lwX3N1
YnN5c3RlbShwYXJlbnQsICJwY2kiKTsKICAgICAgICAgICAgICAgICAgICAgICAgIHN1cHBvcnRl
ZF9wYXJlbnQgPSB0cnVlOwoKICAgICAgICAgICAgICAgICB9IGVsc2UgaWYgKHN0cmVxKHN1YnN5
cywgImNjdyIpKSB7CiAgICAgICAgICAgICAgICAgICAgICAgICBwYXRoX3ByZXBlbmQoJnBhdGgs
ICJjY3ctJXMiLCBzeXNuYW1lKTsKICAgICAgICAgICAgICAgICAgICAgICAgIGlmIChjb21wYXRf
cGF0aCkKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcGF0aF9wcmVwZW5kKCZjb21w
YXRfcGF0aCwgImNjdy0lcyIsIHN5c25hbWUpOwogICAgICAgICAgICAgICAgICAgICAgICAgcGFy
ZW50ID0gc2tpcF9zdWJzeXN0ZW0ocGFyZW50LCAiY2N3Iik7CiAgICAgICAgICAgICAgICAgICAg
ICAgICBzdXBwb3J0ZWRfdHJhbnNwb3J0ID0gdHJ1ZTsKICAgICAgICAgICAgICAgICAgICAgICAg
IHN1cHBvcnRlZF9wYXJlbnQgPSB0cnVlOwoKSG93ZXZlciwgdGhlIGRldGFpbHMgaW5zaWRlIHNk
X2RldmljZV9nZXRfc3Vic3lzdGVtKCkgYW5kIApzZF9kZXZpY2VfZ2V0X3N5c25hbWUoKSBhcmUg
YmV5b25kIG15IHBvd2VycyB0byB1bmRlcnN0YW5kLCBzbyB0aGVyZSBtaWdodCBiZSAKZGlmZmVy
ZW5jZXMgaGlkZGVuIGluIHRoZXJlLgoKVGhhdCBzYWlkLCBJIGRvbid0IHdhbnQgdG8gdG91Y2gg
dGhlIFBDSSBwYXJ0IGhlcmUuIEkgZG9uJ3QgZXZlbiBoYXZlIHNvbWV0aGluZyAKdG8gdGVzdCB0
aGF0LgoKPiBBbHNvLCB0aGUgY29kZSByZWFkYWJpbGl0eSBjb3VsZCBiZSBpbXByb3ZlZCBieSBj
aGFuZ2luZyB0aGUgd2hpbGUgbG9vcAo+IHRvIGEgZm9yIGxvb3AgYW5kIGdldHRpbmcgcmlkIG9m
IHRoZSBtdWx0aXBsZQo+IHVkZXZfZGV2aWNlX2dldF9wYXJlbnQocGFyZW50KSBjYWxscy4gTGlr
ZSBhYm92ZSwgbm90IGEgcmVxdWlyZW1lbnQsCj4gYnV0IHRoZSBjaGFuZ2Ugd291bGQgYmUgd2Vs
Y29tZS4KPiAKPiAKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHN1YnN5c3RlbV9u
YW1lID0gdWRldl9kZXZpY2VfZ2V0X3N1YnN5c3RlbShwYXJlbnQpOwo+PiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgaWYgKCFzdWJzeXN0ZW1fbmFtZSkgewo+PiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHBhcmVudCA9IHVkZXZfZGV2aWNlX2dl
dF9wYXJlbnQocGFyZW50KTsKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBjb250aW51ZTsKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0K
Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmICghc3RyY21wKHN1YnN5c3RlbV9u
YW1lLCAiY2N3IikpCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgYnJlYWs7Cj4+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHBhcmVudCA9
IHVkZXZfZGV2aWNlX2dldF9wYXJlbnQocGFyZW50KTsKPj4gIMKgwqDCoMKgwqDCoMKgwqB9Cj4+
ICDCoMKgwqDCoMKgwqDCoMKgaWYgKHBhcmVudCkgewo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgLyogcGNpX2RldmljZSBmb3VuZAo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgLyogcGNpX2RldmljZSBvciBjY3cgZmNwIGRldmljZSBmb3VuZAo+PiAgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKi8KPj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgdmFsdWUgPSB1ZGV2X2RldmljZV9nZXRfc3lzbmFtZShwYXJlbnQpOwo+PiAgIAo+PiBA
QCAtNTM3LDcgKzUxOCw3IEBAIGludCBzeXNmc19nZXRfaG9zdF9wY2lfbmFtZShjb25zdCBzdHJ1
Y3QgcGF0aAo+PiAqcHAsIGNoYXIgKnBjaV9uYW1lKQo+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIDE7Cj4+ICDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoH0KPj4gICAKPj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oHN0cm5jcHkocGNpX25hbWUsIHZhbHVlLCBTTE9UX05BTUVfU0laRSk7Cj4+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBzdHJuY3B5KGJ1c19pZCwgdmFsdWUsIFNMT1RfTkFNRV9TSVpF
KTsKPiAKPiBBZ2FpbiBub3QgbWFuZGF0b3J5LCBidXQgd2Ugc2hvdWxkIHJlcGxhY2Ugc3RybmNw
eSgpIGJ5IHN0cmxjcHkoKSB3aGVuCj4gd2UgZW5jb3VudGVyIGl0LgoKV29ya2luZyBvbiB0aGUg
b3RoZXIgcmV2aWV3IGNvbW1lbnRzLiBTdGF5IHR1bmVkIGZvciB2My4KCgotLSAKTWl0IGZyZXVu
ZGxpY2hlbiBHcnVlc3NlbiAvIEtpbmQgcmVnYXJkcwpTdGVmZmVuIE1haWVyCgpMaW51eCBvbiBJ
Qk0gWiBhbmQgTGludXhPTkUKCmh0dHBzOi8vd3d3LmlibS5jb20vcHJpdmFjeS91cy9lbi8KSUJN
IERldXRzY2hsYW5kIFJlc2VhcmNoICYgRGV2ZWxvcG1lbnQgR21iSApWb3JzaXR6ZW5kZXIgZGVz
IEF1ZnNpY2h0c3JhdHM6IEdyZWdvciBQaWxsZW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBEYXZpZCBG
YWxsZXIKU2l0eiBkZXIgR2VzZWxsc2NoYWZ0OiBCb2VibGluZ2VuClJlZ2lzdGVyZ2VyaWNodDog
QW10c2dlcmljaHQgU3R1dHRnYXJ0LCBIUkIgMjQzMjk0CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxp
c3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFu
L2xpc3RpbmZvL2RtLWRldmVs

