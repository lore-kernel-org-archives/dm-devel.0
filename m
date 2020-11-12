Return-Path: <SRS0=awJs=ET=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE51C4742C
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:02:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3A469208D5
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:02:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A469208D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-_inq-YBxN1mwamEIiIvypQ-1; Fri, 13 Nov 2020 03:02:42 -0500
X-MC-Unique: _inq-YBxN1mwamEIiIvypQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5ABF31084D68;
	Fri, 13 Nov 2020 08:02:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 385A75D9F7;
	Fri, 13 Nov 2020 08:02:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 09C2E58100;
	Fri, 13 Nov 2020 08:02:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ACM9b54008502 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Nov 2020 17:09:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AEFC82156A53; Thu, 12 Nov 2020 22:09:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A941F2156A50
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 22:09:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9446A8582BA
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 22:09:34 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-3--jmeYcDxMN-7F32fLn-IoQ-1;
	Thu, 12 Nov 2020 17:09:32 -0500
X-MC-Unique: -jmeYcDxMN-7F32fLn-IoQ-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id F2E2220C2877;
	Thu, 12 Nov 2020 14:09:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F2E2220C2877
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
References: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
	<20201101222626.6111-6-tusharsu@linux.microsoft.com>
	<bef97a69db37d358db21668b179fd8821430b1b4.camel@linux.ibm.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <5826d3df-c263-f6c8-cac0-094b3c5a9395@linux.microsoft.com>
Date: Thu, 12 Nov 2020 14:09:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bef97a69db37d358db21668b179fd8821430b1b4.camel@linux.ibm.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0ACM9b54008502
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 13 Nov 2020 03:02:15 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v5 5/7] IMA: validate supported kernel data
 sources before measurement
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
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAyMDIwLTExLTA2IDY6MDEgYS5tLiwgTWltaSBab2hhciB3cm90ZToKPiBIaSBUdXNoYXIs
Cj4gCj4gT24gU3VuLCAyMDIwLTExLTAxIGF0IDE0OjI2IC0wODAwLCBUdXNoYXIgU3VnYW5kaGkg
d3JvdGU6Cj4+IEN1cnJlbnRseSwgSU1BIGRvZXMgbm90IHJlc3RyaWN0IHJhbmRvbSBkYXRhIHNv
dXJjZXMgZnJvbSBtZWFzdXJpbmcKPj4gdGhlaXIgZGF0YSB1c2luZyBpbWFfbWVhc3VyZV9jcml0
aWNhbF9kYXRhKCkuIEFueSBrZXJuZWwgZGF0YSBzb3VyY2UgY2FuCj4+IGNhbGwgdGhlIGZ1bmN0
aW9uLCBhbmQgaXQncyBkYXRhIHdpbGwgZ2V0IG1lYXN1cmVkIGFzIGxvbmcgYXMgdGhlIGlucHV0
Cj4+IGV2ZW50X2RhdGFfc291cmNlIGlzIHBhcnQgb2YgdGhlIElNQSBwb2xpY3kgLSBDUklUSUNB
TF9EQVRBK2RhdGFfc291cmNlcy4KPj4KPj4gVG8gZW5zdXJlIHRoYXQgb25seSBkYXRhIGZyb20g
c3VwcG9ydGVkIHNvdXJjZXMgYXJlIG1lYXN1cmVkLCB0aGUga2VybmVsCj4+IHN1YnN5c3RlbSBu
YW1lIG5lZWRzIHRvIGJlIGFkZGVkIHRvIGEgY29tcGlsZS10aW1lIGxpc3Qgb2Ygc3VwcG9ydGVk
Cj4+IHNvdXJjZXMgKGFuICJhbGxvd2VkIGxpc3Qgb2YgY29tcG9uZW50cyIpLiBJTUEgdGhlbiB2
YWxpZGF0ZXMgdGhlIGlucHV0Cj4+IHBhcmFtZXRlciAtICJldmVudF9kYXRhX3NvdXJjZSIgcGFz
c2VkIHRvIGltYV9tZWFzdXJlX2NyaXRpY2FsX2RhdGEoKQo+PiBhZ2FpbnN0IHRoaXMgYWxsb3dl
ZCBsaXN0IGF0IHJ1bi10aW1lLgo+Pgo+PiBUaGlzIGNvbXBpbGUtdGltZSBsaXN0IG11c3QgYmUg
dXBkYXRlZCB3aGVuIGtlcm5lbCBzdWJzeXN0ZW1zIGFyZQo+PiB1cGRhdGVkIHRvIG1lYXN1cmUg
dGhlaXIgZGF0YSB1c2luZyBJTUEuCj4+Cj4+IFByb3ZpZGUgYW4gaW5mcmFzdHJ1Y3R1cmUgZm9y
IGtlcm5lbCBkYXRhIHNvdXJjZXMgdG8gYmUgYWRkZWQgdG8KPj4gSU1BJ3Mgc3VwcG9ydGVkIGRh
dGEgc291cmNlcyBsaXN0IGF0IGNvbXBpbGUtdGltZS4gVXBkYXRlCj4+IGltYV9tZWFzdXJlX2Ny
aXRpY2FsX2RhdGEoKSB0byB2YWxpZGF0ZSwgYXQgcnVuLXRpbWUsIHRoYXQgdGhlIGRhdGEKPj4g
c291cmNlIGlzIHN1cHBvcnRlZCBiZWZvcmUgbWVhc3VyaW5nIHRoZSBkYXRhIGNvbWluZyBmcm9t
IHRoYXQgc291cmNlLgo+IAo+IEZvciB0aG9zZSBpbnRlcmVzdGVkIGluIGxpbWl0aW5nIHdoaWNo
IGNyaXRpY2FsIGRhdGEgdG8gbWVhc3VyZSwgdGhlCj4gImRhdGEgc291cmNlcyIgSU1BIHBvbGlj
eSBydWxlIG9wdGlvbiBhbHJlYWR5IGRvZXMgdGhhdC4gICBXaHkgaXMgdGhpcwo+IG5lZWRlZD8K
PiAKPiB0aGFua3MsCj4gCj4gTWltaQo+IAoKVGhpcyB3YXNu4oCZdCBwYXJ0IG9mIHRoZSBpbml0
aWFsIHNlcmllcy4gQW5kIEkgd2FzbuKAmXQgY29udmluY2VkIGlmIGl0IHdhcwpyZWFsbHkgbmVl
ZGVkLiA6KSBJIGFkZGVkIGl0IGJhc2VkIG9uIHRoZSBmZWVkYmFjayBpbiB2MiBvZiB0aGlzCnNl
cmllcy4gKHBhc3RlZCBiZWxvdyBmb3IgcmVmZXJlbmNlWzFdKS4KCk1heWJlIEkgbWlzdW5kZXJz
dG9vZCB5b3VyIGZlZWRiYWNrIGF0IHRoYXQgdGltZS4KCipRdWVzdGlvbioKQ291bGQgeW91IHBs
ZWFzZSBsZXQgbWUga25vdyBpZiB5b3Ugd2FudCB1cyB0byByZW1vdmUgdGhpcyBwYXRjaD8KCgpb
MV0gRnJvbSB2MiBvZiB0aGlzIHNlcmllczoKaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9w
cm9qZWN0L2xpbnV4LWludGVncml0eS9wYXRjaC8yMDIwMDgyMTE4MjEwNy41MzI4LTMtdHVzaGFy
c3VAbGludXgubWljcm9zb2Z0LmNvbS8gCgoKID4+Pj4gImtleXJpbmdzPSIgaXNuJ3QgYm91bmRl
ZCBiZWNhdXNlIGtleXJpbmdzIGNhbiBiZSBjcmVhdGVkIGJ5IAp1c2Vyc3BhY2UuCiA+Pj4+IFBl
cmhhcHMga2V5cmluZyBuYW1lcyBoYXMgYSBtaW5pbXVtL21heGltdW0gbGVuZ3RoLiAgSU1BIGlz
bid0CiA+Pj4+IG1lYXN1cmluZyB1c2Vyc3BhY2UgY29uc3RydXN0cy4gIFNob3VsZG4ndCB0aGUg
bGlzdCBvZiBjcml0aWNhbCBkYXRhCiA+Pj4+IGJlaW5nIG1lYXN1cmVkIGJlIGJvdW5kZWQgYW5k
IHZlcmlmaWVkPwogPj4+IFRoZSBjb21tZW50IGlzIG5vdCBlbnRpcmVseSBjbGVhci4KID4+PiBE
byB5b3UgbWVhbiB0aGVyZSBzaG91bGQgYmUgc29tZSBzb3J0IG9mIGFsbG93X2xpc3QgaW4gSU1B
LCBhZ2FpbnN0CiA+Pj4gd2hpY2ggdGhlIHZhbHVlcyBpbiAiZGF0YV9zb3VyY2VzPSIgc2hvdWxk
IGJlIHZldHRlZD8gQW5kIGlmIHRoZQogPj4+IHZhbHVlIGlzIHByZXNlbnQgaW4gdGhlIElNQSBh
bGxvd19saXN0LCB0aGVuIG9ubHkgdGhlIG1lYXN1cmVtZW50cyBmb3IKID4+PiB0aGF0IGRhdGEg
c291cmNlIGFyZSBhbGxvd2VkPwogPj4+CiA+Pj4gT3IgZG8geW91IG1lYW4gc29tZXRoaW5nIGVs
c2U/CiA+PgogPj4gWWVzLCBzb21ldGhpbmcgYWxvbmcgdGhvc2UgbGluZXMuICBEb2VzIHRoZSBs
aXN0IG9mIGNyaXRpY2FsIGRhdGEgbmVlZAogPj4gdG8gYmUgdmV0dGVkPyAgQW5kIGlmIHNvLCBh
Z2FpbnN0IHdoYXQ/CiA+IEkgYW0gdGhpbmtpbmcgb2YgaGF2aW5nIGFuIGVudW0gYW5kIHN0cmlu
ZyBhcnJheSAtIGp1c3QgbGlrZSBpbWFfaG9va3MKID4gYW5kIGltYV9ob29rc19tZWFzdXJlX3N0
ciBpbiBpbWEuaC4KID4gQW5kIGFueSBuZXcga2VybmVsIGNvbXBvbmVudCB0aGF0IHdvdWxkIHN1
cHBvcnQgZ2VuZXJpYyBJTUEgbWVhc3VyZW1lbnRzCiA+IGluIGZ1dHVyZSB3b3VsZCBoYXZlIHRv
IGFkZCBpdHNlbGYgdG8gdGhlIGVudW0vYXJyYXkuCiA+IEFuZCB0aGUgcGFyYW0gKmV2ZW50X2Rh
dGFfc291cmNlIGluIGltYV9tZWFzdXJlX2NyaXRpY2FsX2RhdGEoKSB3aWxsIGJlCiA+IHZldHRl
ZCBhZ2FpbnN0IHRoZSBhYm92ZSBlbnVtL3N0cmluZyBhcnJheS4KID4KID4gSSB3aWxsIGltcGxl
bWVudCBpdCBpbiB0aGUgbmV4dCBpdGVyYXRpb24sIGFuZCBob3BlZnVsbHkgdGhlIHZldHRpbmcK
ID4gd29ya2Zsb3cgd2lsbCBiZSBtb3JlIGNsZWFyLgogPgogPiB+VHVzaGFyCiA+PgogPj4gTWlt
aQoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
d3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

