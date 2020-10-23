Return-Path: <SRS0=x48V=EB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33D94C2D0A3
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:22:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9898520735
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:22:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9898520735
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-ahOlOoQyOBaPI9zy-j-wKA-1; Mon, 26 Oct 2020 03:22:29 -0400
X-MC-Unique: ahOlOoQyOBaPI9zy-j-wKA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84538803F4F;
	Mon, 26 Oct 2020 07:22:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6395E19C66;
	Mon, 26 Oct 2020 07:22:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3968A92F27;
	Mon, 26 Oct 2020 07:22:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09NMt3Nq006993 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 23 Oct 2020 18:55:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6ACBF207A5ED; Fri, 23 Oct 2020 22:55:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 65C8A207A642
	for <dm-devel@redhat.com>; Fri, 23 Oct 2020 22:55:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C4D38007DF
	for <dm-devel@redhat.com>; Fri, 23 Oct 2020 22:55:01 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-538-FzT4fbnOM9-KrBj4ugVStA-1;
	Fri, 23 Oct 2020 18:54:56 -0400
X-MC-Unique: FzT4fbnOM9-KrBj4ugVStA-1
Received: from [192.168.86.21] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 1DA2020B4905;
	Fri, 23 Oct 2020 15:54:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1DA2020B4905
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com
References: <20200923192011.5293-1-tusharsu@linux.microsoft.com>
	<20200923192011.5293-6-tusharsu@linux.microsoft.com>
	<dc22359475f0c233abdb9257d1ca745d4be3f9af.camel@linux.ibm.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <016d20e1-bb8f-f1f5-c69b-6fd811126e0c@linux.microsoft.com>
Date: Fri, 23 Oct 2020 15:54:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <dc22359475f0c233abdb9257d1ca745d4be3f9af.camel@linux.ibm.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09NMt3Nq006993
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 26 Oct 2020 03:19:18 -0400
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v4 5/6] IMA: add hook to measure critical
 data from kernel components
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAyMDIwLTEwLTIyIDM6MzUgcC5tLiwgTWltaSBab2hhciB3cm90ZToKPiBIaSBUdXNoYXIs
Cj4gCj4gT24gV2VkLCAyMDIwLTA5LTIzIGF0IDEyOjIwIC0wNzAwLCBUdXNoYXIgU3VnYW5kaGkg
d3JvdGU6Cj4+IEN1cnJlbnRseSwgSU1BIGRvZXMgbm90IHByb3ZpZGUgYSBnZW5lcmljIGZ1bmN0
aW9uIGZvciBrZXJuZWwgY29tcG9uZW50cwo+PiB0byBtZWFzdXJlIHRoZWlyIGRhdGEuIEEgZ2Vu
ZXJpYyBmdW5jdGlvbiBwcm92aWRlZCBieSBJTUEgd291bGQKPj4gZW5hYmxlIHZhcmlvdXMgcGFy
dHMgb2YgdGhlIGtlcm5lbCB3aXRoIGVhc2llciBhbmQgZmFzdGVyIG9uLWJvYXJkaW5nIHRvCj4+
IHVzZSBJTUEgaW5mcmFzdHJ1Y3R1cmUsIHdvdWxkIGF2b2lkIGNvZGUgZHVwbGljYXRpb24sIGFu
ZCBjb25zaXN0ZW50Cj4+IHVzYWdlIG9mIElNQSBwb2xpY3kgb3B0aW9uICJkYXRhX3NvdXJjZXM6
PSIgYWNyb3NzIHRoZSBrZXJuZWwuCj4+Cj4+IEFkZCBhIG5ldyBJTUEgZnVuYyBDUklUSUNBTF9E
QVRBIGFuZCBhIGNvcnJlc3BvbmRpbmcgSU1BIGhvb2sKPj4gaW1hX21lYXN1cmVfY3JpdGljYWxf
ZGF0YSgpIHRvIHN1cHBvcnQgbWVhc3VyaW5nIHZhcmlvdXMgY3JpdGljYWwga2VybmVsCj4+IGNv
bXBvbmVudHMuIExpbWl0IHRoZSBtZWFzdXJlbWVudCB0byB0aGUgY29tcG9uZW50cyB0aGF0IGFy
ZSBzcGVjaWZpZWQKPj4gaW4gdGhlIElNQSBwb2xpY3kgLSBDUklUSUNBTF9EQVRBK2RhdGFfc291
cmNlcy4KPj4KPj4gU2lnbmVkLW9mZi1ieTogVHVzaGFyIFN1Z2FuZGhpIDx0dXNoYXJzdUBsaW51
eC5taWNyb3NvZnQuY29tPgo+IAo+IE5vcm1hbGx5IHRoZSBuZXcgTFNNIG9yIElNQSBob29rIGlz
IGRlZmluZWQgYmVmb3JlIGRlZmluaW5nIGEgbWV0aG9kIG9mCj4gY29uc3RyYWluaW5nIHRoYXQg
aG9vay4gIFBsZWFzZSBkcm9wIDIvNiAoSU1BOiBjb25kaXRpb25hbGx5IGFsbG93Cj4gZW1wdHkg
cnVsZSBkYXRhKSBhbmQgcmV2ZXJzZSB0aGUgb3JkZXIgb2YgNC82IGFuZCA1LzYuICAgVGhhdCB3
aWxsCj4gYWxsb3cgZWFjaCBwYXRjaCB0byB1cGRhdGUgdGhlIERvY3VtZW50YXRpb24gYXBwcm9w
cmlhdGVseSwgbWFraW5nIHRoZQo+IGNoYW5nZSBzZWxmIGNvbnRhaW5lZC4KPiAKU3VyZS4gSSB3
aWxsIGRyb3AgMi82LCBhbmQgcmV2ZXJzZSB0aGUgb3JkZXIgb2YgNC82IGFuZCA1LzYuCj4+IC0t
LQo+PiAgIERvY3VtZW50YXRpb24vQUJJL3Rlc3RpbmcvaW1hX3BvbGljeSB8ICA4ICsrKysrKy0K
Pj4gICBpbmNsdWRlL2xpbnV4L2ltYS5oICAgICAgICAgICAgICAgICAgfCAgOCArKysrKysrCj4+
ICAgc2VjdXJpdHkvaW50ZWdyaXR5L2ltYS9pbWEuaCAgICAgICAgIHwgIDEgKwo+PiAgIHNlY3Vy
aXR5L2ludGVncml0eS9pbWEvaW1hX2FwaS5jICAgICB8ICAyICstCj4+ICAgc2VjdXJpdHkvaW50
ZWdyaXR5L2ltYS9pbWFfbWFpbi5jICAgIHwgMjYgKysrKysrKysrKysrKysrKysrKysrCj4+ICAg
c2VjdXJpdHkvaW50ZWdyaXR5L2ltYS9pbWFfcG9saWN5LmMgIHwgMzQgKysrKysrKysrKysrKysr
KysrKysrKysrLS0tLQo+PiAgIDYgZmlsZXMgY2hhbmdlZCwgNzIgaW5zZXJ0aW9ucygrKSwgNyBk
ZWxldGlvbnMoLSkKPj4KPj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vQUJJL3Rlc3Rpbmcv
aW1hX3BvbGljeSBiL0RvY3VtZW50YXRpb24vQUJJL3Rlc3RpbmcvaW1hX3BvbGljeQo+PiBpbmRl
eCBhODFjZjc5ZmIyNTUuLmQzM2JiNTEzMDlmYyAxMDA2NDQKPj4gLS0tIGEvRG9jdW1lbnRhdGlv
bi9BQkkvdGVzdGluZy9pbWFfcG9saWN5Cj4+ICsrKyBiL0RvY3VtZW50YXRpb24vQUJJL3Rlc3Rp
bmcvaW1hX3BvbGljeQo+PiBAQCAtMjksNyArMjksNyBAQCBEZXNjcmlwdGlvbjoKPj4gICAJCWJh
c2U6IAlmdW5jOj0gW0JQUk1fQ0hFQ0tdW01NQVBfQ0hFQ0tdW0NSRURTX0NIRUNLXVtGSUxFX0NI
RUNLXVtNT0RVTEVfQ0hFQ0tdCj4+ICAgCQkJCVtGSVJNV0FSRV9DSEVDS10KPj4gICAJCQkJW0tF
WEVDX0tFUk5FTF9DSEVDS10gW0tFWEVDX0lOSVRSQU1GU19DSEVDS10KPj4gLQkJCQlbS0VYRUNf
Q01ETElORV0gW0tFWV9DSEVDS10KPj4gKwkJCQlbS0VYRUNfQ01ETElORV0gW0tFWV9DSEVDS10g
W0NSSVRJQ0FMX0RBVEFdCj4+ICAgCQkJbWFzazo9IFtbXl1NQVlfUkVBRF0gW1teXU1BWV9XUklU
RV0gW1teXU1BWV9BUFBFTkRdCj4+ICAgCQkJICAgICAgIFtbXl1NQVlfRVhFQ10KPj4gICAJCQlm
c21hZ2ljOj0gaGV4IHZhbHVlCj4+IEBAIC01MSw2ICs1MSw4IEBAIERlc2NyaXB0aW9uOgo+PiAg
IAkJCWRhdGFfc291cmNlczo9IGxpc3Qgb2Yga2VybmVsIGNvbXBvbmVudHMKPj4gICAJCQkoZWcs
IHNlbGludXh8YXBwYXJtb3J8ZG0tY3J5cHQpIHRoYXQgY29udGFpbiBkYXRhIGNyaXRpY2FsCj4+
ICAgCQkJdG8gdGhlIHNlY3VyaXR5IG9mIHRoZSBrZXJuZWwuCj4+ICsJCQlPbmx5IHZhbGlkIHdo
ZW4gYWN0aW9uIGlzICJtZWFzdXJlIiBhbmQgZnVuYyBpcwo+PiArCQkJQ1JJVElDQUxfREFUQS4K
Pj4gICAKPj4gICAJCWRlZmF1bHQgcG9saWN5Ogo+PiAgIAkJCSMgUFJPQ19TVVBFUl9NQUdJQwo+
PiBAQCAtMTI4LDMgKzEzMCw3IEBAIERlc2NyaXB0aW9uOgo+PiAgIAkJa2V5cyBhZGRlZCB0byAu
YnVpbHRpbl90cnVzdGVkX2tleXMgb3IgLmltYSBrZXlyaW5nOgo+PiAgIAo+PiAgIAkJCW1lYXN1
cmUgZnVuYz1LRVlfQ0hFQ0sga2V5cmluZ3M9LmJ1aWx0aW5fdHJ1c3RlZF9rZXlzfC5pbWEKPj4g
Kwo+PiArCQlFeGFtcGxlIG9mIG1lYXN1cmUgcnVsZSB1c2luZyBDUklUSUNBTF9EQVRBIHRvIG1l
YXN1cmUgY3JpdGljYWwgZGF0YQo+PiArCj4+ICsJCQltZWFzdXJlIGZ1bmM9Q1JJVElDQUxfREFU
QSBkYXRhX3NvdXJjZXM9c2VsaW51eHxhcHBhcm1vcnxkbS1jcnlwdAo+IAo+IAo+IEFzIGRhdGEg
c291cmNlcyBhcmUgYWRkZWQsIHRoZSBkb2N1bWVudGF0aW9uIGV4YW1wbGUgc2hvdWxkIGJlIHVw
ZGF0ZWQKPiB0byByZWZsZWN0IHRoZSBuZXcgc291cmNlLiAgUGxlYXNlIGRvIG5vdCBpbmNsdWRl
IGV4YW1wbGVzIHRoYXQgZG9uJ3QKPiB5ZXQgZXhpc3QuCj4gCk1ha2VzIHNlbnNlLiBXaWxsIGRv
Lgo+IAo+PiBkaWZmIC0tZ2l0IGEvc2VjdXJpdHkvaW50ZWdyaXR5L2ltYS9pbWFfbWFpbi5jIGIv
c2VjdXJpdHkvaW50ZWdyaXR5L2ltYS9pbWFfbWFpbi5jCj4+IGluZGV4IDY4ODhmYzM3MmFiZi4u
ZDU1ODk2ZjI4NzkwIDEwMDY0NAo+PiAtLS0gYS9zZWN1cml0eS9pbnRlZ3JpdHkvaW1hL2ltYV9t
YWluLmMKPj4gKysrIGIvc2VjdXJpdHkvaW50ZWdyaXR5L2ltYS9pbWFfbWFpbi5jCj4+IEBAIC04
NjcsNiArODY3LDMyIEBAIHZvaWQgaW1hX2tleGVjX2NtZGxpbmUoaW50IGtlcm5lbF9mZCwgY29u
c3Qgdm9pZCAqYnVmLCBpbnQgc2l6ZSkKPj4gICAJZmRwdXQoZik7Cj4+ICAgfQo+PiAgIAo+PiAr
LyoqCj4+ICsgKiBpbWFfbWVhc3VyZV9jcml0aWNhbF9kYXRhIC0gbWVhc3VyZSBjcml0aWNhbCBk
YXRhCj4+ICsgKiBAZXZlbnRfbmFtZTogbmFtZSBmb3IgdGhlIGdpdmVuIGRhdGEKPj4gKyAqIEBl
dmVudF9kYXRhX3NvdXJjZTogbmFtZSBvZiB0aGUgZXZlbnQgZGF0YSBzb3VyY2UKPj4gKyAqIEBi
dWY6IHBvaW50ZXIgdG8gYnVmZmVyIGNvbnRhaW5pbmcgZGF0YSB0byBtZWFzdXJlCj4+ICsgKiBA
YnVmX2xlbjogbGVuZ3RoIG9mIGJ1ZmZlcihpbiBieXRlcykKPj4gKyAqIEBtZWFzdXJlX2J1Zl9o
YXNoOiBpZiBzZXQgdG8gdHJ1ZSAtIHdpbGwgbWVhc3VyZSBoYXNoIG9mIHRoZSBidWYsCj4+ICsg
KiAgICAgICAgICAgICAgICAgICAgaW5zdGVhZCBvZiBidWYKPj4gKyAqCj4+ICsgKiBCdWZmZXJz
IGNhbiBvbmx5IGJlIG1lYXN1cmVkLCBub3QgYXBwcmFpc2VkLgo+PiArICovCj4gCj4gUGVyaGFw
cyB0aGUgcmVhc29uIGZvciBkZWZpbmluZyBib3RoIHRoZSBldmVudF9uYW1lIGFuZAo+IGV2ZW50
X2RhdGFfc291cmNlIHdpbGwgYmVjb21lIGNsZWFyZXIgd2l0aCBhbiBleGFtcGxlLiAgQXQgdGhp
cyBwb2ludCBJCj4gY2FuIG9ubHkgZ3Vlc3MgYXMgdG8gd2h5IGJvdGggYXJlIG5lZWRlZCAoZS5n
LiBwZXJoYXBzIGEgZGF0YSBzb3VyY2UKPiBkZWZpbmVzIG11bHRpcGxlIGV2ZW50cykuCj4gClll
cy4gUHJlY2lzZWx5LiBGb3IgZXhhbXBsZSwgaW4g4oCcZG0tY3J5cHTigJ0gY2FzZTogdGhlIGRh
dGEgc291cmNlIGlzCuKAnGRtLWNyeXB04oCdIGFuZCBwb3NzaWJsZSBldmVudHMgYXJlIOKAnGFk
ZF90YXJnZXTigJ0sIOKAnHBvc3Rfc3VzcGVuZOKAnSwKInJlc3VtZSIgZXRjLiBJIHdpbGwgYWRk
IGEgbW9yZSBkZXRhaWxlZCBob29rIGRlc2NyaXB0aW9uIGFzIHlvdQpzdWdnZXN0ZWQgYmVsb3cs
IGFuZCBleHBsYWluIHRoaXMgcG9pbnQgaW4gaXQuCj4gV2hpbGUgIkJ1ZmZlcnMgY2FuIG9ubHkg
YmUgbWVhc3VyZWQsIG5vdCBhcHByYWlzZWQiIGlzIHRydWUsIGl0IHdhcyBjdXQKPiAmIHBhc3Rl
ZCBmcm9tIGltYV9rZXhlY19jbWRsaW5lLiAgTWVhc3VyaW5nIHRoZSBrZXhlYyBib290IGNtZGxp
bmUgaXMKPiBzZWxmIGRlc2NyaWJpbmcuICBIZXJlLCBhIGxhcmdlciwgbW9yZSBkZXRhaWxlZCBJ
TUEgaG9vayBkZXNjcmlwdGlvbgo+IHdvdWxkIGJlIGFwcHJvcHJpYXRlLgpXaWxsIGFkZC4gVGhh
bmtzIE1pbWkuCj4gCj4gdGhhbmtzLAo+IAo+IE1pbWkKPiAKCgotLQpkbS1kZXZlbCBtYWlsaW5n
IGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWw=

