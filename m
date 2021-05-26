Return-Path: <SRS0=2AwM=KV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FFC8C47087
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 01:09:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D6471613F1
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 01:09:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6471613F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-r9GaBI3PN2KbZ9oYRrzUmw-1; Tue, 25 May 2021 21:09:53 -0400
X-MC-Unique: r9GaBI3PN2KbZ9oYRrzUmw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E8AE80B72A;
	Wed, 26 May 2021 01:09:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AAAFD687DF;
	Wed, 26 May 2021 01:09:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A849F1800BB8;
	Wed, 26 May 2021 01:09:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14Q19iPf020087 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 21:09:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 168D520287CB; Wed, 26 May 2021 01:09:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 11F802021458
	for <dm-devel@redhat.com>; Wed, 26 May 2021 01:09:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18DC2185A79C
	for <dm-devel@redhat.com>; Wed, 26 May 2021 01:09:42 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-262-tBGNbL45NNeJtu0Dg6DfQQ-1;
	Tue, 25 May 2021 21:09:39 -0400
X-MC-Unique: tBGNbL45NNeJtu0Dg6DfQQ-1
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id BA1C820B7178;
	Tue, 25 May 2021 18:00:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BA1C820B7178
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: dm-devel@redhat.com
Date: Tue, 25 May 2021 17:59:47 -0700
Message-Id: <20210526005954.31564-1-tusharsu@linux.microsoft.com>
MIME-Version: 1.0
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14Q19iPf020087
X-loop: dm-devel@redhat.com
Cc: tusharsu@linux.microsoft.com, nramas@linux.microsoft.com,
	zohar@linux.ibm.com, snitzer@redhat.com, agk@redhat.com
Subject: [dm-devel] [RFC 0/7] device mapper target measurements using IMA
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGVsbG8gYWxsLApJIGhhdmUgYmVlbiB3b3JraW5nIG9uIG1lYXN1cmluZyB2YXJpb3VzIGRldmlj
ZSBtYXBwZXIgdGFyZ2V0IGF0dHJpYnV0ZXMKdXNpbmcgSU1BIGtlcm5lbCBzdWJzeXN0ZW0uIAoo
bW9yZSBjb250ZXh0IGluIHRoZSBwYXRjaCBzZXJpZXMgY292ZXItbGV0dGVyIGJlbG93KQoKSSBz
dGlsbCBoYXZlIHRvIHdvcmsgb246CiAtIGZpbGxpbmcgdGhlIGdhcHMgaW4gdGhlIGRvY3VtZW50
YXRpb24sIAogLSB0ZXN0aW5nIHNvbWUgY29ybmVyIGNhc2VzIGV0Yy4KCkJ1dCBJIHdvdWxkIGxp
a2UgdG8gZ2V0IGFuIGVhcmx5IGZlZWRiYWNrIGZyb20gdGhlIGRldmljZS1tYXBwZXIKY29tbXVu
aXR5IG9uIHRoZSBjb2RlIGFuZCB0aGVyZWZvcmUgc2hhcmluZyB0aGUgc2VyaWVzIGFzIGFuIFJG
QyBmb3IKdGhlIHRpbWUgYmVpbmcuCgpUaGFua3MsClR1c2hhcgoKLS0tLS0tLS0tLS0tLS0tLQot
LUNvdmVyIExldHRlci0tCi0tLS0tLS0tLS0tLS0tLS0KRm9yIGEgZ2l2ZW4gc3lzdGVtLCB2YXJp
b3VzIGV4dGVybmFsIHNlcnZpY2VzL2luZnJhc3RydWN0dXJlIHRvb2xzCihpbmNsdWRpbmcgdGhl
IGF0dGVzdGF0aW9uIHNlcnZpY2UpIGludGVyYWN0IHdpdGggaXQgLSBib3RoIGR1cmluZyB0aGUK
c2V0dXAgYW5kIGR1cmluZyByZXN0IG9mIHRoZSBzeXN0ZW0gcnVuLXRpbWUuICBUaGV5IHNoYXJl
IHNlbnNpdGl2ZSBkYXRhCmFuZC9vciBleGVjdXRlIGNyaXRpY2FsIHdvcmtsb2FkIG9uIHRoYXQg
c3lzdGVtLiAgVGhlIGV4dGVybmFsIHNlcnZpY2VzCm1heSB3YW50IHRvIHZlcmlmeSB0aGUgY3Vy
cmVudCBydW4tdGltZSBzdGF0ZSBvZiB0aGUgcmVsZXZhbnQga2VybmVsCnN1YnN5c3RlbXMgYmVm
b3JlIGZ1bGx5IHRydXN0aW5nIHRoZSBzeXN0ZW0gd2l0aCBidXNpbmVzcy1jcml0aWNhbApkYXRh
L3dvcmtsb2FkLgoKRGV2aWNlIG1hcHBlciBpcyBvbmUgc3VjaCBrZXJuZWwgc3Vic3lzdGVtIHRo
YXQgcGxheXMgYSBjcml0aWNhbCByb2xlIG9uCmEgZ2l2ZW4gc3lzdGVtIGJ5IHByb3ZpZGluZyB2
YXJpb3VzIGltcG9ydGFudCBmdW5jdGlvbmFsaXRpZXMgdG8gdGhlCmJsb2NrIGRldmljZXMgdXNp
bmcgdmFyaW91cyB0YXJnZXQgdHlwZXMgbGlrZSBjcnlwdCwgdmVyaXR5LCBpbnRlZ3JpdHkgCmV0
Yy4gIEVhY2ggb2YgdGhlc2UgdGFyZ2V0IHR5cGVz4oCZIGZ1bmN0aW9uYWxpdGllcyBjYW4gYmUg
Y29uZmlndXJlZCB3aXRoCnZhcmlvdXMgYXR0cmlidXRlcy4gIFRoZSBhdHRyaWJ1dGVzIGNob3Nl
biB0byBjb25maWd1cmUgdGhlc2UgdGFyZ2V0IHR5cGVzCmNhbiBzaWduaWZpY2FudGx5IGltcGFj
dCB0aGUgc2VjdXJpdHkgcHJvZmlsZSBvZiB0aGUgYmxvY2sgZGV2aWNlLAphbmQgaW4tdHVybiwg
b2YgdGhlIHN5c3RlbSBpdHNlbGYuICBGb3IgaW5zdGFuY2UsIHRoZSB0eXBlIG9mIGVuY3J5cHRp
b24KYWxnb3JpdGhtIGFuZCB0aGUga2V5IHNpemUgZGV0ZXJtaW5lcyB0aGUgc3RyZW5ndGggb2Yg
ZW5jcnlwdGlvbiBmb3IgYQpnaXZlbiBibG9jayBkZXZpY2UuCgpUaGVyZWZvcmUsIHZlcmlmeWlu
ZyB0aGUgY3VycmVudCBzdGF0ZSBvZiB2YXJpb3VzIGJsb2NrIGRldmljZXMgYXMgd2VsbAphcyB0
aGVpciB2YXJpb3VzIHRhcmdldCBhdHRyaWJ1dGVzIGlzIGNydWNpYWwgZm9yIGV4dGVybmFsIHNl
cnZpY2VzCmJlZm9yZSBmdWxseSB0cnVzdGluZyB0aGUgc3lzdGVtIHdpdGggYnVzaW5lc3MtY3Jp
dGljYWwgZGF0YS93b3JrbG9hZC4KCklNQSBwcm92aWRlcyB0aGUgbmVjZXNzYXJ5IGZ1bmN0aW9u
YWxpdHkgZm9yIGRldmljZSBtYXBwZXIgdG8gbWVhc3VyZSB0aGUKc3RhdGUgYW5kIGNvbmZpZ3Vy
YXRpb24gb2YgdmFyaW91cyBibG9jayBkZXZpY2VzIC0KICAtIEJZIGRldmljZSBtYXBwZXIgaXRz
ZWxmLCBmcm9tIHdpdGhpbiB0aGUga2VybmVsLAogIC0gaW4gYSB0YW1wZXIgcmVzaXN0YW50IHdh
eSwKICAtIGFuZCByZS1tZWFzdXJlZCAtIHRyaWdnZXJlZCBvbiBzdGF0ZS9jb25maWd1cmF0aW9u
IGNoYW5nZS4KClRoaXMgcGF0Y2ggc2VyaWVzIHVzZXMgdGhpcyBJTUEgZnVuY3Rpb25hbGl0eSwg
YnkgY2FsbGluZyB0aGUgZnVuY3Rpb24KaW1hX21lYXN1cmVfY3JpdGljYWxfZGF0YSgpLCB3aGVu
IGEgYmxvY2sgZGV2aWNlIHN0YXRlIGlzIGNoYW5nZWQgKGUuZy4Kb24gZGV2aWNlIGNyZWF0ZSwg
cmVzdW1lLCByZW5hbWUsIHJlbW92ZSBldGMuKSAgSXQgbWVhc3VyZXMgdGhlIGRldmljZQpzdGF0
ZSBhbmQgY29uZmlndXJhdGlvbiBhbmQgc3RvcmVzIGl0IGluIElNQSBsb2dzLCBzbyB0aGF0IGl0
IGNhbiBiZQp1c2VkIGJ5IGV4dGVybmFsIHNlcnZpY2VzIGZvciBtYW5hZ2luZyB0aGUgc3lzdGVt
LgoKVHVzaGFyIFN1Z2FuZGhpICg3KToKICBkbTogbWVhc3VyZSBkYXRhIG9uIHRhYmxlIGxvYWQK
ICBkbTogbWVhc3VyZSBkYXRhIG9uIGRldmljZSByZXN1bWUKICBkbTogbWVhc3VyZSBkYXRhIG9u
IGRldmljZSByZW1vdmUKICBkbTogbWVhc3VyZSBkYXRhIG9uIHRhYmxlIGNsZWFyCiAgZG06IG1l
YXN1cmUgZGF0YSBvbiBkZXZpY2UgcmVuYW1lCiAgZG06IHVwZGF0ZSB0YXJnZXQgc3BlY2lmaWMg
c3RhdHVzIGZ1bmN0aW9ucyB0byBtZWFzdXJlIGRhdGEKICBkbTogYWRkIGRvY3VtZW50YXRpb24g
Zm9yIElNQSBtZWFzdXJlbWVudCBzdXBwb3J0CgogLi4uL2FkbWluLWd1aWRlL2RldmljZS1tYXBw
ZXIvZG0taW1hLnJzdCAgICAgIHwgMjcxICsrKysrKysrKysrCiAuLi4vYWRtaW4tZ3VpZGUvZGV2
aWNlLW1hcHBlci9pbmRleC5yc3QgICAgICAgfCAgIDEgKwogZHJpdmVycy9tZC9NYWtlZmlsZSAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAyICsKIGRyaXZlcnMvbWQvZG0tY2FjaGUtdGFy
Z2V0LmMgICAgICAgICAgICAgICAgICB8ICAzMCArKwogZHJpdmVycy9tZC9kbS1jbG9uZS10YXJn
ZXQuYyAgICAgICAgICAgICAgICAgIHwgICA3ICsKIGRyaXZlcnMvbWQvZG0tY29yZS5oICAgICAg
ICAgICAgICAgICAgICAgICAgICB8ICAgNSArCiBkcml2ZXJzL21kL2RtLWNyeXB0LmMgICAgICAg
ICAgICAgICAgICAgICAgICAgfCAgNTAgKysKIGRyaXZlcnMvbWQvZG0tZGVsYXkuYyAgICAgICAg
ICAgICAgICAgICAgICAgICB8ICAgNCArCiBkcml2ZXJzL21kL2RtLWR1c3QuYyAgICAgICAgICAg
ICAgICAgICAgICAgICAgfCAgIDQgKwogZHJpdmVycy9tZC9kbS1lYnMtdGFyZ2V0LmMgICAgICAg
ICAgICAgICAgICAgIHwgICAzICsKIGRyaXZlcnMvbWQvZG0tZXJhLXRhcmdldC5jICAgICAgICAg
ICAgICAgICAgICB8ICAgNCArCiBkcml2ZXJzL21kL2RtLWZsYWtleS5jICAgICAgICAgICAgICAg
ICAgICAgICAgfCAgIDQgKwogZHJpdmVycy9tZC9kbS1pbWEuYyAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHwgNDQyICsrKysrKysrKysrKysrKysrKwogZHJpdmVycy9tZC9kbS1pbWEuaCAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHwgIDQxICsrCiBkcml2ZXJzL21kL2RtLWludGVncml0eS5j
ICAgICAgICAgICAgICAgICAgICAgfCAgMzggKysKIGRyaXZlcnMvbWQvZG0taW9jdGwuYyAgICAg
ICAgICAgICAgICAgICAgICAgICB8ICAyMyArLQogZHJpdmVycy9tZC9kbS1saW5lYXIuYyAgICAg
ICAgICAgICAgICAgICAgICAgIHwgICA4ICsKIGRyaXZlcnMvbWQvZG0tbG9nLXVzZXJzcGFjZS1i
YXNlLmMgICAgICAgICAgICB8ICAgMyArCiBkcml2ZXJzL21kL2RtLWxvZy13cml0ZXMuYyAgICAg
ICAgICAgICAgICAgICAgfCAgIDQgKwogZHJpdmVycy9tZC9kbS1sb2cuYyAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHwgIDEwICsKIGRyaXZlcnMvbWQvZG0tbXBhdGguYyAgICAgICAgICAgICAg
ICAgICAgICAgICB8ICAyOSArKwogZHJpdmVycy9tZC9kbS1wcy1oaXN0b3JpY2FsLXNlcnZpY2Ut
dGltZS5jICAgIHwgICAzICsKIGRyaXZlcnMvbWQvZG0tcHMtaW8tYWZmaW5pdHkuYyAgICAgICAg
ICAgICAgICB8ICAgMyArCiBkcml2ZXJzL21kL2RtLXBzLXF1ZXVlLWxlbmd0aC5jICAgICAgICAg
ICAgICAgfCAgIDMgKwogZHJpdmVycy9tZC9kbS1wcy1yb3VuZC1yb2Jpbi5jICAgICAgICAgICAg
ICAgIHwgICA0ICsKIGRyaXZlcnMvbWQvZG0tcHMtc2VydmljZS10aW1lLmMgICAgICAgICAgICAg
ICB8ICAgMyArCiBkcml2ZXJzL21kL2RtLXJhaWQuYyAgICAgICAgICAgICAgICAgICAgICAgICAg
fCAgNDIgKysKIGRyaXZlcnMvbWQvZG0tcmFpZDEuYyAgICAgICAgICAgICAgICAgICAgICAgICB8
ICAxOCArCiBkcml2ZXJzL21kL2RtLXNuYXAtcGVyc2lzdGVudC5jICAgICAgICAgICAgICAgfCAg
IDQgKwogZHJpdmVycy9tZC9kbS1zbmFwLXRyYW5zaWVudC5jICAgICAgICAgICAgICAgIHwgICA0
ICsKIGRyaXZlcnMvbWQvZG0tc25hcC5jICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAxNiAr
CiBkcml2ZXJzL21kL2RtLXN0cmlwZS5jICAgICAgICAgICAgICAgICAgICAgICAgfCAgMTUgKwog
ZHJpdmVycy9tZC9kbS1zd2l0Y2guYyAgICAgICAgICAgICAgICAgICAgICAgIHwgICA0ICsKIGRy
aXZlcnMvbWQvZG0tdGhpbi5jICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgOCArCiBkcml2
ZXJzL21kL2RtLXVuc3RyaXBlLmMgICAgICAgICAgICAgICAgICAgICAgfCAgIDQgKwogZHJpdmVy
cy9tZC9kbS12ZXJpdHktdGFyZ2V0LmMgICAgICAgICAgICAgICAgIHwgIDQ2ICsrCiBkcml2ZXJz
L21kL2RtLXdyaXRlY2FjaGUuYyAgICAgICAgICAgICAgICAgICAgfCAgIDMgKwogZHJpdmVycy9t
ZC9kbS16b25lZC10YXJnZXQuYyAgICAgICAgICAgICAgICAgIHwgICAzICsKIGluY2x1ZGUvbGlu
dXgvZGV2aWNlLW1hcHBlci5oICAgICAgICAgICAgICAgICB8ICAgNiArLQogaW5jbHVkZS91YXBp
L2xpbnV4L2RtLWlvY3RsLmggICAgICAgICAgICAgICAgIHwgICA2ICsKIDQwIGZpbGVzIGNoYW5n
ZWQsIDExNzUgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKIGNyZWF0ZSBtb2RlIDEwMDY0
NCBEb2N1bWVudGF0aW9uL2FkbWluLWd1aWRlL2RldmljZS1tYXBwZXIvZG0taW1hLnJzdAogY3Jl
YXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbWQvZG0taW1hLmMKIGNyZWF0ZSBtb2RlIDEwMDY0NCBk
cml2ZXJzL21kL2RtLWltYS5oCgotLSAKMi4xNy4xCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0
CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9s
aXN0aW5mby9kbS1kZXZlbA==

