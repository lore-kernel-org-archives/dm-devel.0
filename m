Return-Path: <SRS0=SrOh=MF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FB52C07E9A
	for <dm-devel@archiver.kernel.org>; Tue, 13 Jul 2021 00:56:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AF8CE611CB
	for <dm-devel@archiver.kernel.org>; Tue, 13 Jul 2021 00:56:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF8CE611CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-djPXoPo5PLaybK_53BAM5Q-1; Mon, 12 Jul 2021 20:56:11 -0400
X-MC-Unique: djPXoPo5PLaybK_53BAM5Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EE26804309;
	Tue, 13 Jul 2021 00:56:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 639FE60C17;
	Tue, 13 Jul 2021 00:56:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 388C21809CB2;
	Tue, 13 Jul 2021 00:56:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16D0the7025285 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 12 Jul 2021 20:55:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5FCE92033969; Tue, 13 Jul 2021 00:55:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C04B20341A1
	for <dm-devel@redhat.com>; Tue, 13 Jul 2021 00:55:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E029100DE6F
	for <dm-devel@redhat.com>; Tue, 13 Jul 2021 00:55:41 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-405-llyeiw6UPuqfSyiZ2EzTgw-1;
	Mon, 12 Jul 2021 20:55:39 -0400
X-MC-Unique: llyeiw6UPuqfSyiZ2EzTgw-1
Received: from Lenovo-Legion-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id E8A3620B6C50;
	Mon, 12 Jul 2021 17:49:11 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E8A3620B6C50
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
Date: Mon, 12 Jul 2021 17:48:57 -0700
Message-Id: <20210713004904.8808-1-tusharsu@linux.microsoft.com>
MIME-Version: 1.0
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 16D0the7025285
X-loop: dm-devel@redhat.com
Cc: tusharsu@linux.microsoft.com, nramas@linux.microsoft.com,
	linux-integrity@vger.kernel.org, zohar@linux.ibm.com
Subject: [dm-devel] [PATCH 0/7] device mapper target measurements using IMA
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

Rm9yIGEgZ2l2ZW4gc3lzdGVtLCB2YXJpb3VzIGV4dGVybmFsIHNlcnZpY2VzL2luZnJhc3RydWN0
dXJlIHRvb2xzCihpbmNsdWRpbmcgdGhlIGF0dGVzdGF0aW9uIHNlcnZpY2UpIGludGVyYWN0IHdp
dGggaXQgLSBib3RoIGR1cmluZyB0aGUKc2V0dXAgYW5kIGR1cmluZyByZXN0IG9mIHRoZSBzeXN0
ZW0gcnVuLXRpbWUuICBUaGV5IHNoYXJlIHNlbnNpdGl2ZSBkYXRhCmFuZC9vciBleGVjdXRlIGNy
aXRpY2FsIHdvcmtsb2FkIG9uIHRoYXQgc3lzdGVtLiAgVGhlIGV4dGVybmFsIHNlcnZpY2VzCm1h
eSB3YW50IHRvIHZlcmlmeSB0aGUgY3VycmVudCBydW4tdGltZSBzdGF0ZSBvZiB0aGUgcmVsZXZh
bnQga2VybmVsCnN1YnN5c3RlbXMgYmVmb3JlIGZ1bGx5IHRydXN0aW5nIHRoZSBzeXN0ZW0gd2l0
aCBidXNpbmVzcy1jcml0aWNhbApkYXRhL3dvcmtsb2FkLgoKRGV2aWNlIG1hcHBlciBpcyBvbmUg
c3VjaCBrZXJuZWwgc3Vic3lzdGVtIHRoYXQgcGxheXMgYSBjcml0aWNhbCByb2xlIG9uCmEgZ2l2
ZW4gc3lzdGVtIGJ5IHByb3ZpZGluZyB2YXJpb3VzIGltcG9ydGFudCBmdW5jdGlvbmFsaXRpZXMg
dG8gdGhlCmJsb2NrIGRldmljZXMgd2l0aCB2YXJpb3VzIHRhcmdldCB0eXBlcyBsaWtlIGNyeXB0
LCB2ZXJpdHksIGludGVncml0eSAKZXRjLiAgRWFjaCBvZiB0aGVzZSB0YXJnZXQgdHlwZXPigJkg
ZnVuY3Rpb25hbGl0aWVzIGNhbiBiZSBjb25maWd1cmVkIHdpdGgKdmFyaW91cyBhdHRyaWJ1dGVz
LiAgVGhlIGF0dHJpYnV0ZXMgY2hvc2VuIHRvIGNvbmZpZ3VyZSB0aGVzZSB0YXJnZXQgdHlwZXMK
Y2FuIHNpZ25pZmljYW50bHkgaW1wYWN0IHRoZSBzZWN1cml0eSBwcm9maWxlIG9mIHRoZSBibG9j
ayBkZXZpY2UsCmFuZCBpbi10dXJuLCBvZiB0aGUgc3lzdGVtIGl0c2VsZi4gIEZvciBpbnN0YW5j
ZSwgdGhlIHR5cGUgb2YgZW5jcnlwdGlvbgphbGdvcml0aG0gYW5kIHRoZSBrZXkgc2l6ZSBkZXRl
cm1pbmVzIHRoZSBzdHJlbmd0aCBvZiBlbmNyeXB0aW9uIGZvciBhCmdpdmVuIGJsb2NrIGRldmlj
ZS4KClRoZXJlZm9yZSwgdmVyaWZ5aW5nIHRoZSBjdXJyZW50IHN0YXRlIG9mIHZhcmlvdXMgYmxv
Y2sgZGV2aWNlcyBhcyB3ZWxsCmFzIHRoZWlyIHZhcmlvdXMgdGFyZ2V0IGF0dHJpYnV0ZXMgaXMg
Y3J1Y2lhbCBmb3IgZXh0ZXJuYWwgc2VydmljZXMKYmVmb3JlIGZ1bGx5IHRydXN0aW5nIHRoZSBz
eXN0ZW0gd2l0aCBidXNpbmVzcy1jcml0aWNhbCBkYXRhL3dvcmtsb2FkLgoKSU1BIHByb3ZpZGVz
IHRoZSBuZWNlc3NhcnkgZnVuY3Rpb25hbGl0eSBmb3IgZGV2aWNlIG1hcHBlciB0byBtZWFzdXJl
IHRoZQpzdGF0ZSBhbmQgY29uZmlndXJhdGlvbiBvZiB2YXJpb3VzIGJsb2NrIGRldmljZXMgLQog
IC0gQlkgZGV2aWNlIG1hcHBlciBpdHNlbGYsIGZyb20gd2l0aGluIHRoZSBrZXJuZWwsCiAgLSBp
biBhIHRhbXBlciByZXNpc3RhbnQgd2F5LAogIC0gYW5kIHJlLW1lYXN1cmVkIC0gdHJpZ2dlcmVk
IG9uIHN0YXRlL2NvbmZpZ3VyYXRpb24gY2hhbmdlLgoKVGhpcyBwYXRjaCBzZXJpZXMgdXNlcyB0
aGlzIElNQSBmdW5jdGlvbmFsaXR5LCBieSBjYWxsaW5nIHRoZSBmdW5jdGlvbgppbWFfbWVhc3Vy
ZV9jcml0aWNhbF9kYXRhKCksIHdoZW4gYSBibG9jayBkZXZpY2Ugc3RhdGUgaXMgY2hhbmdlZCAo
ZS5nLgpvbiBkZXZpY2UgY3JlYXRlLCByZXN1bWUsIHJlbmFtZSwgcmVtb3ZlIGV0Yy4pICBJdCBt
ZWFzdXJlcyB0aGUgZGV2aWNlCnN0YXRlIGFuZCBjb25maWd1cmF0aW9uIGFuZCBzdG9yZXMgaXQg
aW4gSU1BIGxvZ3MsIHNvIHRoYXQgaXQgY2FuIGJlCnVzZWQgYnkgZXh0ZXJuYWwgc2VydmljZXMg
Zm9yIG1hbmFnaW5nIHRoZSBzeXN0ZW0uCgoKVHVzaGFyIFN1Z2FuZGhpICg3KToKICBkbTogbWVh
c3VyZSBkYXRhIG9uIHRhYmxlIGxvYWQKICBkbTogbWVhc3VyZSBkYXRhIG9uIGRldmljZSByZXN1
bWUKICBkbTogbWVhc3VyZSBkYXRhIG9uIGRldmljZSByZW1vdmUKICBkbTogbWVhc3VyZSBkYXRh
IG9uIHRhYmxlIGNsZWFyCiAgZG06IG1lYXN1cmUgZGF0YSBvbiBkZXZpY2UgcmVuYW1lCiAgZG06
IHVwZGF0ZSB0YXJnZXQgc3BlY2lmaWMgc3RhdHVzIGZ1bmN0aW9ucyB0byBtZWFzdXJlIGRhdGEK
ICBkbTogYWRkIGRvY3VtZW50YXRpb24gZm9yIElNQSBtZWFzdXJlbWVudCBzdXBwb3J0CgogLi4u
L2FkbWluLWd1aWRlL2RldmljZS1tYXBwZXIvZG0taW1hLnJzdCAgICAgIHwgMzA2ICsrKysrKysr
CiAuLi4vYWRtaW4tZ3VpZGUvZGV2aWNlLW1hcHBlci9pbmRleC5yc3QgICAgICAgfCAgIDEgKwog
ZHJpdmVycy9tZC9NYWtlZmlsZSAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAyICsKIGRy
aXZlcnMvbWQvZG0tY2FjaGUtdGFyZ2V0LmMgICAgICAgICAgICAgICAgICB8ICAyNCArCiBkcml2
ZXJzL21kL2RtLWNsb25lLXRhcmdldC5jICAgICAgICAgICAgICAgICAgfCAgIDcgKwogZHJpdmVy
cy9tZC9kbS1jb3JlLmggICAgICAgICAgICAgICAgICAgICAgICAgIHwgICA1ICsKIGRyaXZlcnMv
bWQvZG0tY3J5cHQuYyAgICAgICAgICAgICAgICAgICAgICAgICB8ICAyOSArCiBkcml2ZXJzL21k
L2RtLWRlbGF5LmMgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDQgKwogZHJpdmVycy9tZC9k
bS1kdXN0LmMgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICA0ICsKIGRyaXZlcnMvbWQvZG0t
ZWJzLXRhcmdldC5jICAgICAgICAgICAgICAgICAgICB8ICAgMyArCiBkcml2ZXJzL21kL2RtLWVy
YS10YXJnZXQuYyAgICAgICAgICAgICAgICAgICAgfCAgIDQgKwogZHJpdmVycy9tZC9kbS1mbGFr
ZXkuYyAgICAgICAgICAgICAgICAgICAgICAgIHwgICA0ICsKIGRyaXZlcnMvbWQvZG0taW1hLmMg
ICAgICAgICAgICAgICAgICAgICAgICAgICB8IDcyNSArKysrKysrKysrKysrKysrKysKIGRyaXZl
cnMvbWQvZG0taW1hLmggICAgICAgICAgICAgICAgICAgICAgICAgICB8ICA1NiArKwogZHJpdmVy
cy9tZC9kbS1pbnRlZ3JpdHkuYyAgICAgICAgICAgICAgICAgICAgIHwgIDI0ICsKIGRyaXZlcnMv
bWQvZG0taW9jdGwuYyAgICAgICAgICAgICAgICAgICAgICAgICB8ICAyNCArLQogZHJpdmVycy9t
ZC9kbS1saW5lYXIuYyAgICAgICAgICAgICAgICAgICAgICAgIHwgICA4ICsKIGRyaXZlcnMvbWQv
ZG0tbG9nLXVzZXJzcGFjZS1iYXNlLmMgICAgICAgICAgICB8ICAgMyArCiBkcml2ZXJzL21kL2Rt
LWxvZy13cml0ZXMuYyAgICAgICAgICAgICAgICAgICAgfCAgIDQgKwogZHJpdmVycy9tZC9kbS1s
b2cuYyAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDEwICsKIGRyaXZlcnMvbWQvZG0tbXBh
dGguYyAgICAgICAgICAgICAgICAgICAgICAgICB8ICAyOSArCiBkcml2ZXJzL21kL2RtLXBzLWhp
c3RvcmljYWwtc2VydmljZS10aW1lLmMgICAgfCAgIDMgKwogZHJpdmVycy9tZC9kbS1wcy1pby1h
ZmZpbml0eS5jICAgICAgICAgICAgICAgIHwgICAzICsKIGRyaXZlcnMvbWQvZG0tcHMtcXVldWUt
bGVuZ3RoLmMgICAgICAgICAgICAgICB8ICAgMyArCiBkcml2ZXJzL21kL2RtLXBzLXJvdW5kLXJv
YmluLmMgICAgICAgICAgICAgICAgfCAgIDQgKwogZHJpdmVycy9tZC9kbS1wcy1zZXJ2aWNlLXRp
bWUuYyAgICAgICAgICAgICAgIHwgICAzICsKIGRyaXZlcnMvbWQvZG0tcmFpZC5jICAgICAgICAg
ICAgICAgICAgICAgICAgICB8ICAzOSArCiBkcml2ZXJzL21kL2RtLXJhaWQxLmMgICAgICAgICAg
ICAgICAgICAgICAgICAgfCAgMTggKwogZHJpdmVycy9tZC9kbS1zbmFwLXBlcnNpc3RlbnQuYyAg
ICAgICAgICAgICAgIHwgICA0ICsKIGRyaXZlcnMvbWQvZG0tc25hcC10cmFuc2llbnQuYyAgICAg
ICAgICAgICAgICB8ICAgNCArCiBkcml2ZXJzL21kL2RtLXNuYXAuYyAgICAgICAgICAgICAgICAg
ICAgICAgICAgfCAgMTMgKwogZHJpdmVycy9tZC9kbS1zdHJpcGUuYyAgICAgICAgICAgICAgICAg
ICAgICAgIHwgIDE2ICsKIGRyaXZlcnMvbWQvZG0tc3dpdGNoLmMgICAgICAgICAgICAgICAgICAg
ICAgICB8ICAgNCArCiBkcml2ZXJzL21kL2RtLXRoaW4uYyAgICAgICAgICAgICAgICAgICAgICAg
ICAgfCAgIDggKwogZHJpdmVycy9tZC9kbS11bnN0cmlwZS5jICAgICAgICAgICAgICAgICAgICAg
IHwgICA0ICsKIGRyaXZlcnMvbWQvZG0tdmVyaXR5LXRhcmdldC5jICAgICAgICAgICAgICAgICB8
ICA0NSArKwogZHJpdmVycy9tZC9kbS13cml0ZWNhY2hlLmMgICAgICAgICAgICAgICAgICAgIHwg
ICAzICsKIGRyaXZlcnMvbWQvZG0tem9uZWQtdGFyZ2V0LmMgICAgICAgICAgICAgICAgICB8ICAg
MyArCiBkcml2ZXJzL21kL2RtLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDMg
KwogaW5jbHVkZS9saW51eC9kZXZpY2UtbWFwcGVyLmggICAgICAgICAgICAgICAgIHwgICA2ICst
CiBpbmNsdWRlL3VhcGkvbGludXgvZG0taW9jdGwuaCAgICAgICAgICAgICAgICAgfCAgIDYgKwog
NDEgZmlsZXMgY2hhbmdlZCwgMTQ2NCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQogY3Jl
YXRlIG1vZGUgMTAwNjQ0IERvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUvZGV2aWNlLW1hcHBlci9k
bS1pbWEucnN0CiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9tZC9kbS1pbWEuYwogY3JlYXRl
IG1vZGUgMTAwNjQ0IGRyaXZlcnMvbWQvZG0taW1hLmgKCi0tIAoyLjI1LjEKCgotLQpkbS1kZXZl
bCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

