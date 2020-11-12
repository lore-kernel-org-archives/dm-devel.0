Return-Path: <SRS0=awJs=ET=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB11C388F7
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:02:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E57EF20857
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:02:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E57EF20857
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-KC23KEHRMO64KHFW0DUVhg-1; Fri, 13 Nov 2020 03:02:47 -0500
X-MC-Unique: KC23KEHRMO64KHFW0DUVhg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C3C7101962E;
	Fri, 13 Nov 2020 08:02:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F76A75125;
	Fri, 13 Nov 2020 08:02:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3404758111;
	Fri, 13 Nov 2020 08:02:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ACLvZ5v006970 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Nov 2020 16:57:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4939B1009B8E; Thu, 12 Nov 2020 21:57:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4528B1008B96
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 21:57:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F9601021F88
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 21:57:33 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-502-nTM44wQDOca8pWEE_H1WLQ-1;
	Thu, 12 Nov 2020 16:57:24 -0500
X-MC-Unique: nTM44wQDOca8pWEE_H1WLQ-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id CBA5920C2872;
	Thu, 12 Nov 2020 13:57:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CBA5920C2872
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
References: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
	<20201101222626.6111-4-tusharsu@linux.microsoft.com>
	<1f83ec246cb6356c340b379ab00e43f0b5bba0ae.camel@linux.ibm.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <25622ca6-359d-fa97-c5e6-e314cba51306@linux.microsoft.com>
Date: Thu, 12 Nov 2020 13:57:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1f83ec246cb6356c340b379ab00e43f0b5bba0ae.camel@linux.ibm.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0ACLvZ5v006970
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAyMDIwLTExLTA2IDU6MjQgYS5tLiwgTWltaSBab2hhciB3cm90ZToKPiBIaSBUdXNoYXIs
Cj4gCj4gT24gU3VuLCAyMDIwLTExLTAxIGF0IDE0OjI2IC0wODAwLCBUdXNoYXIgU3VnYW5kaGkg
d3JvdGU6Cj4+IEN1cnJlbnRseSwgSU1BIGRvZXMgbm90IHByb3ZpZGUgYSBnZW5lcmljIGZ1bmN0
aW9uIGZvciBrZXJuZWwgc3Vic3lzdGVtcwo+PiB0byBtZWFzdXJlIHRoZWlyIGNyaXRpY2FsIGRh
dGEuIEV4YW1wbGVzIG9mIGNyaXRpY2FsIGRhdGEgaW4gdGhpcyBjb250ZXh0Cj4+IGNvdWxkIGJl
IGtlcm5lbCBpbi1tZW1vcnkgci9vIHN0cnVjdHVyZXMsIGhhc2ggb2YgdGhlIG1lbW9yeSBzdHJ1
Y3R1cmVzLAo+PiBvciBkYXRhIHRoYXQgcmVwcmVzZW50cyBhIGxpbnV4IGtlcm5lbCBzdWJzeXN0
ZW0gc3RhdGUgY2hhbmdlLiBUaGUKPj4gY3JpdGljYWwgZGF0YSwgaWYgYWNjaWRlbnRhbGx5IG9y
IG1hbGljaW91c2x5IGFsdGVyZWQsIGNhbiBjb21wcm9taXNlCj4+IHRoZSBpbnRlZ3JpdHkgb2Yg
dGhlIHN5c3RlbS4KPiAKPiBTdGFydCBvdXQgd2l0aCB3aGF0IElNQSBkb2VzIGRvIChlLmcuIG1l
YXN1cmVzIGZpbGVzIGFuZCBtb3JlIHJlY2VudGx5Cj4gYnVmZmVyIGRhdGEpLiAgQWZ0ZXJ3YXJk
cyBjb250aW51ZSB3aXRoIGtlcm5lbCBpbnRlZ3JpdHkgY3JpdGljYWwgZGF0YQo+IHNob3VsZCBh
bHNvIGJlIG1lYXN1cmVkLiAgUGxlYXNlIGluY2x1ZGUgYSBkZWZpbml0aW9uIG9mIGtlcm5lbAo+
IGludGVncml0eSBjcml0aWNhbCBkYXRhIGhlcmUsIGFzIHdlbGwgYXMgaW4gdGhlIGNvdmVyIGxl
dHRlci4KPiAKWWVzLCB3aWxsIGRvLiBJIHdpbGwgYWxzbyBkZXNjcmliZSB3aGF0IGtlcm5lbCBp
bnRlZ3JpdHkgY3JpdGljYWwgZGF0YQppcyDigJMgYnkgcHJvdmlkaW5nIGEgZGVmaW5pdGlvbiwg
YW5kIG5vdCBieSBleGFtcGxlIC0gIGFzIHlvdSBzdWdnZXN0ZWQuCihoZXJlIGFuZCBpbiB0aGUg
Y292ZXIgbGV0dGVyKQoKPj4KPj4gQSBnZW5lcmljIGZ1bmN0aW9uIHByb3ZpZGVkIGJ5IElNQSB0
byBtZWFzdXJlIGNyaXRpY2FsIGRhdGEgd291bGQgZW5hYmxlCj4+IHZhcmlvdXMgc3Vic3lzdGVt
cyB3aXRoIGVhc2llciBhbmQgZmFzdGVyIG9uLWJvYXJkaW5nIHRvIHVzZSBJTUEKPj4gaW5mcmFz
dHJ1Y3R1cmUgYW5kIHdvdWxkIGFsc28gYXZvaWQgY29kZSBkdXBsaWNhdGlvbi4KPiAKPiBCeSBk
ZWZpbml0aW9uIExTTSBhbmQgSU1BIGhvb2tzIGFyZSBnZW5lcmljIHdpdGggY2FsbGVycyBpbiBh
cHByb3ByaWF0ZQo+IHBsYWNlcyBpbiB0aGUga2VybmVsLiAgIFRoaXMgcGFyYWdyYXBoIGlzIHJl
ZHVuZGFudC4KPiAKU291bmRzIGdvb2QuIEkgd2lsbCByZW1vdmUgdGhpcyBwYXJhZ3JhcGguCj4+
Cj4+IEFkZCBhIG5ldyBJTUEgZnVuYyBDUklUSUNBTF9EQVRBIGFuZCBhIGNvcnJlc3BvbmRpbmcg
SU1BIGhvb2sKPj4gaW1hX21lYXN1cmVfY3JpdGljYWxfZGF0YSgpIHRvIHN1cHBvcnQgbWVhc3Vy
aW5nIGNyaXRpY2FsIGRhdGEgZm9yCj4+IHZhcmlvdXMga2VybmVsIHN1YnN5c3RlbXMuCj4gCj4g
SW5zdGVhZCBvZiB1c2luZyB0aGUgd29yZCAiYWRkIiwgaXQgd291bGQgYmUgbW9yZSBhcHByb3By
aWF0ZSB0byB1c2UKPiB0aGUgd29yZCAiZGVmaW5lIi4gICBEZWZpbmUgYSBuZXcgSU1BIGhvb2sg
bmFtZWQKPiBpbWFfbWVhc3VyZV9jcml0aWNhbF9kYXRhIHRvIG1lYXN1cmUga2VybmVsIGludGVn
cml0eSBjcml0aWNhbCBkYXRhLgo+IFBsZWFzZSBhbHNvIHVwZGF0ZSB0aGUgU3ViamVjdCBsaW5l
IGFzIHdlbGwuICAiaW1hOiBkZWZpbmUgYW4gSU1BIGhvb2sKPiB0byBtZWFzdXJlIGtlcm5lbCBp
bnRlZ3JpdHkgY3JpdGljYWwgZGF0YSIuCj4gClNvdW5kcyBnb29kLiBXaWxsIGRvLgo+Pgo+PiBT
aWduZWQtb2ZmLWJ5OiBUdXNoYXIgU3VnYW5kaGkgPHR1c2hhcnN1QGxpbnV4Lm1pY3Jvc29mdC5j
b20+Cj4+IC0tLQo+Pgo+PiBkaWZmIC0tZ2l0IGEvc2VjdXJpdHkvaW50ZWdyaXR5L2ltYS9pbWFf
bWFpbi5jIGIvc2VjdXJpdHkvaW50ZWdyaXR5L2ltYS9pbWFfbWFpbi5jCj4+IGluZGV4IDQ0ODVk
ODdjMGFhNS4uNmUxYjExZGNiYTUzIDEwMDY0NAo+PiAtLS0gYS9zZWN1cml0eS9pbnRlZ3JpdHkv
aW1hL2ltYV9tYWluLmMKPj4gKysrIGIvc2VjdXJpdHkvaW50ZWdyaXR5L2ltYS9pbWFfbWFpbi5j
Cj4+IEBAIC05MjEsNiArOTIxLDQ0IEBAIHZvaWQgaW1hX2tleGVjX2NtZGxpbmUoaW50IGtlcm5l
bF9mZCwgY29uc3Qgdm9pZCAqYnVmLCBpbnQgc2l6ZSkKPj4gICAJZmRwdXQoZik7Cj4+ICAgfQo+
PiAgIAo+PiArLyoqCj4+ICsgKiBpbWFfbWVhc3VyZV9jcml0aWNhbF9kYXRhIC0gbWVhc3VyZSBr
ZXJuZWwgc3Vic3lzdGVtIGRhdGEKPj4gKyAqIGNyaXRpY2FsIHRvIGludGVncml0eSBvZiB0aGUg
a2VybmVsCj4gCj4gUGxlYXNlIGNoYW5nZSB0aGlzIHRvICJtZWFzdXJlIGtlcm5lbCBpbnRlZ3Jp
dHkgY3JpdGljYWwgZGF0YSIuCj4gCipRdWVzdGlvbioKVGhhbmtzIE1pbWkuIERvIHlvdSB3YW50
IHVzIGp1c3QgdG8gdXBkYXRlIHRoZSBkZXNjcmlwdGlvbiwgb3IgZG8geW91CndhbnQgdXMgdG8g
dXBkYXRlIHRoZSBmdW5jdGlvbiBuYW1lIHRvbz8KCkkgYmVsaWV2ZSB5b3UgbWVhbnQganVzdCBk
ZXNjcmlwdGlvbiwgYnV0IHN0aWxsIHdhbnQgdG8gY2xhcmlmeS4KCmltYV9tZWFzdXJlX2tlcm5l
bF9pbnRlZ3JpdHlfY3JpdGljYWxfZGF0YSgpIHdvdWxkIGJlIHRvbyBsb25nLgpNYXliZSBpbWFf
bWVhc3VyZV9pbnRlZ3JpdHlfY3JpdGljYWxfZGF0YSgpPwoKT3IgZG8geW91IHdhbnQgdXMgdG8g
a2VlcCB0aGUgZXhpc3RpbmcgaW1hX21lYXN1cmVfY3JpdGljYWxfZGF0YSgpPwpDb3VsZCB5b3Ug
cGxlYXNlIGxldCB1cyBrbm93PwoKPj4gKyAqIEBldmVudF9kYXRhX3NvdXJjZTogbmFtZSBvZiB0
aGUgZGF0YSBzb3VyY2UgYmVpbmcgbWVhc3VyZWQ7Cj4+ICsgKiB0eXBpY2FsbHkgaXQgc2hvdWxk
IGJlIHRoZSBuYW1lIG9mIHRoZSBrZXJuZWwgc3Vic3lzdGVtIHRoYXQgaXMgc2VuZGluZwo+PiAr
ICogdGhlIGRhdGEgZm9yIG1lYXN1cmVtZW50Cj4gCj4gSW5jbHVkaW5nICJkYXRhX3NvdXJjZSIg
aGVyZSBpc24ndCBxdWl0ZSByaWdodC4gICJkYXRhIHNvdXJjZSIgc2hvdWxkCj4gb25seSBiZSBh
ZGRlZCBpbiB0aGUgZmlyc3QgcGF0Y2ggd2hpY2ggdXNlcyBpdCwgbm90IGhlcmUuICAgV2hlbiBh
ZGRpbmcKPiBpdCBwbGVhc2Ugc2hvcnRlbiB0aGUgZmllbGQgZGVzY3JpcHRpb24gdG8gImtlcm5l
bCBkYXRhIHNvdXJjZSIuICAgVGhlCj4gbG9uZ2VyIGV4cGxhbmF0aW9uIGNhbiBiZSBpbmNsdWRl
ZCBpbiB0aGUgbG9uZ2VyIGZ1bmN0aW9uIGRlc2NyaXB0aW9uLgo+IAoqUXVlc3Rpb24qCkRvIHlv
dSBtZWFuIHRoZSBwYXJhbWV0ZXIgQGV2ZW50X2RhdGFfc291cmNlIHNob3VsZCBiZSByZW1vdmVk
IGZyb20gdGhpcwpwYXRjaD8gQW5kIHRoZW4gbGF0ZXIgYWRkZWQgaW4gcGF0Y2ggNy83IOKAkyB3
aGVyZSBTZUxpbnV4IHVzZXMgaXQ/CgpCdXQgaW1hX21lYXN1cmVfY3JpdGljYWxfZGF0YSgpIGNh
bGxzIHByb2Nlc3NfYnVmZmVyX21lYXN1cmVtZW50KCksIGFuZApwX2JfbSgpIGFjY2VwdHMgaXQg
YXMgcGFydCBvZiB0aGUgcGFyYW0gQGZ1bmNfZGF0YS4KCldoYXQgc2hvdWxkIHdlIHBhc3MgdG8g
cF9iX20oKSBAZnVuY19kYXRhIGluIHRoaXMgcGF0Y2gsIGlmIHdlIHJlbW92ZQpAZXZlbnRfZGF0
YV9zb3VyY2UgZnJvbSB0aGlzIHBhdGNoPwoKPj4gKyAqIEBldmVudF9uYW1lOiBuYW1lIG9mIGFu
IGV2ZW50IGZyb20gdGhlIGtlcm5lbCBzdWJzeXN0ZW0gdGhhdCBpcyBzZW5kaW5nCj4+ICsgKiB0
aGUgZGF0YSBmb3IgbWVhc3VyZW1lbnQKPiAKPiBBcyB0aGlzIGlzIGJlaW5nIHBhc3NlZCB0byBw
cm9jZXNzX2J1ZmZlcl9tZWFzdXJlbWVudCgpLCB0aGlzIHNob3VsZCBiZQo+IHRoZSBzYW1lIG9y
IHNpbWlsYXIgdG8gdGhlIGV4aXN0aW5nIGRlZmluaXRpb24uCj4gCk9rLiBJIHdpbGwgY2hhbmdl
IHRoaXMgdG8gQGV2ZW50bmFtZSB0byBiZSBjb25zaXN0ZW10IHdpdGggcF9iX20oKS4KCj4+ICsg
KiBAYnVmOiBwb2ludGVyIHRvIGJ1ZmZlciBjb250YWluaW5nIGRhdGEgdG8gbWVhc3VyZQo+PiAr
ICogQGJ1Zl9sZW46IGxlbmd0aCBvZiBidWZmZXIoaW4gYnl0ZXMpCj4+ICsgKiBAbWVhc3VyZV9i
dWZfaGFzaDogaWYgc2V0IHRvIHRydWUgLSB3aWxsIG1lYXN1cmUgaGFzaCBvZiB0aGUgYnVmLAo+
PiArICogICAgICAgICAgICAgICAgICAgIGluc3RlYWQgb2YgYnVmCj4gCj4gICBrZXJuZWwgZG9j
IHJlcXVpcmVzIGEgc2luZ2xlIGxpbmUuICBJbiB0aGlzIGNhc2UsIHBsZWFzZSBzaG9ydGVuIHRo
ZQo+IGFyZ3VtZW50IGRlZmluaXRpb24gdG8gIm1lYXN1cmUgYnVmZmVyIGRhdGEgb3IgYnVmZmVy
IGRhdGEgaGFzaCIuICAgVGhlCj4gZGV0YWlscyBjYW4gYmUgaW5jbHVkZWQgaW4gdGhlIGxvbmdl
ciBmdW5jdGlvbiBkZXNjcmlwdGlvbi4KPiAKU291bmRzIGdvb2QuIFdpbGwgZG8uCj4+ICsgKgo+
PiArICogQSBnaXZlbiBrZXJuZWwgc3Vic3lzdGVtIChldmVudF9kYXRhX3NvdXJjZSkgbWF5IHNl
bmQKPj4gKyAqIGRhdGEgKGJ1ZikgdG8gYmUgbWVhc3VyZWQgd2hlbiB0aGUgZGF0YSBvciB0aGUg
c3Vic3lzdGVtIHN0YXRlIGNoYW5nZXMuCj4+ICsgKiBUaGUgc3RhdGUvZGF0YSBjaGFuZ2UgY2Fu
IGJlIGRlc2NyaWJlZCBieSBldmVudF9uYW1lLgo+PiArICogRXhhbXBsZXMgb2YgY3JpdGljYWwg
ZGF0YSAoYnVmKSBjb3VsZCBiZSBrZXJuZWwgaW4tbWVtb3J5IHIvbyBzdHJ1Y3R1cmVzLAo+PiAr
ICogaGFzaCBvZiB0aGUgbWVtb3J5IHN0cnVjdHVyZXMsIG9yIGRhdGEgdGhhdCByZXByZXNlbnRz
IHN1YnN5c3RlbQo+PiArICogc3RhdGUgY2hhbmdlLgo+PiArICogbWVhc3VyZV9idWZfaGFzaCBj
YW4gYmUgdXNlZCB0byBzYXZlIHNwYWNlLCBpZiB0aGUgZGF0YSBiZWluZyBtZWFzdXJlZAo+PiAr
ICogaXMgdG9vIGxhcmdlLgo+PiArICogVGhlIGRhdGEgKGJ1ZikgY2FuIG9ubHkgYmUgbWVhc3Vy
ZWQsIG5vdCBhcHByYWlzZWQuCj4+ICsgKi8KPiAKPiBQbGVhc2UgcmVtb3ZlIHRoaXMgbG9uZ2Vy
IGZ1bmN0aW9uIGRlc2NyaXB0aW9uLCByZXBsYWNpbmcgaXQgc29tZXRoaW5nCj4gbW9yZSBhcHBy
b3ByaWF0ZS4gIFRoZSBzdWJzZXF1ZW50IHBhdGNoIHRoYXQgaW50cm9kdWNlcyB0aGUgImRhdGEK
PiBzb3VyY2UiIHBhcmFtZXRlciB3b3VsZCBleHBhbmQgdGhlIGRlc2NyaXB0aW9uLgo+IAo+IHRo
YW5rcywKPiAKPiBNaW1pCj4gCipRdWVzdGlvbioKSGkgTWltaSwgd2lsbCBkby4KRG8geW91IHdh
bnQgdGhlIGRhdGFfc291cmNlIHRvIGJlIHBhcnQgb2YgU2VMaW51eCBwYXRjaD8gKHBhdGNoIDcv
NyBvZgp0aGlzIHNlcmllcykuCk9yIGEgc2VwYXJhdGUgcGF0Y2ggYmVmb3JlIGl0Pwp+VHVzaGFy
Cgo+PiArdm9pZCBpbWFfbWVhc3VyZV9jcml0aWNhbF9kYXRhKGNvbnN0IGNoYXIgKmV2ZW50X2Rh
dGFfc291cmNlLAo+PiArCQkJICAgICAgIGNvbnN0IGNoYXIgKmV2ZW50X25hbWUsCj4+ICsJCQkg
ICAgICAgY29uc3Qgdm9pZCAqYnVmLCBpbnQgYnVmX2xlbiwKPj4gKwkJCSAgICAgICBib29sIG1l
YXN1cmVfYnVmX2hhc2gpCj4+ICt7Cj4+ICsJaWYgKCFldmVudF9uYW1lIHx8ICFldmVudF9kYXRh
X3NvdXJjZSB8fCAhYnVmIHx8ICFidWZfbGVuKSB7Cj4+ICsJCXByX2VycigiSW52YWxpZCBhcmd1
bWVudHMgcGFzc2VkIHRvICVzKCkuXG4iLCBfX2Z1bmNfXyk7Cj4+ICsJCXJldHVybjsKPj4gKwl9
Cj4+ICsKPj4gKwlwcm9jZXNzX2J1ZmZlcl9tZWFzdXJlbWVudChOVUxMLCBidWYsIGJ1Zl9sZW4s
IGV2ZW50X25hbWUsCj4+ICsJCQkJICAgQ1JJVElDQUxfREFUQSwgMCwgZXZlbnRfZGF0YV9zb3Vy
Y2UsCj4+ICsJCQkJICAgbWVhc3VyZV9idWZfaGFzaCk7Cj4+ICt9Cj4+ICsKPj4gICBzdGF0aWMg
aW50IF9faW5pdCBpbml0X2ltYSh2b2lkKQo+PiAgIHsKPj4gICAJaW50IGVycm9yOwoKCi0tCmRt
LWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

