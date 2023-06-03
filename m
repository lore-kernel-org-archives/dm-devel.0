Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BCC2C77B7A
	for <dm-devel@archiver.kernel.org>; Sat,  3 Jun 2023 10:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685786571;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=30v1szDftPc21sH1hQEk3vd6Baid3s2Kq9QyQoByUmU=;
	b=Yu4i6jgv6ZsmbUR6gG7f0YYiPSoXJropNOnBYhuPEQPqBNza+/pozdnveDq3Uzeo5z1zNb
	A2EDZWWJ1TwlMEbaxnmzcb5cGUJUF63NnuVEDIvC470dp7WqxidgJt5YVY7HeB/dqCu3Jq
	8K/5u7Vzp+LJ/N7F0mCSS0RoG4P2Uwo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-31-9_jthEvQNGGY63uejGQS8A-1; Sat, 03 Jun 2023 06:02:47 -0400
X-MC-Unique: 9_jthEvQNGGY63uejGQS8A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02EC880231B;
	Sat,  3 Jun 2023 10:02:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A3C8D492B00;
	Sat,  3 Jun 2023 10:02:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 572A519465A3;
	Sat,  3 Jun 2023 10:02:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B7E1019465A2
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Jun 2023 10:02:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5530A403175; Sat,  3 Jun 2023 10:02:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D5B7403176
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 10:02:42 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31C4C380350F
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 10:02:42 +0000 (UTC)
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com
 [209.85.160.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-n-FFXH8kNzO0b7O9QNM73Q-1; Sat, 03 Jun 2023 06:02:36 -0400
X-MC-Unique: n-FFXH8kNzO0b7O9QNM73Q-1
Received: by mail-qt1-f182.google.com with SMTP id
 d75a77b69052e-3f805d07040so23252291cf.3; 
 Sat, 03 Jun 2023 03:02:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685786555; x=1688378555;
 h=content-transfer-encoding:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=zq9Nh8bEibGouLkryzSvC1bkCWK7b78+RcX1RlhTE48=;
 b=NheG46SwrJZIVkoFPALUyrzvWGUTzkziI4N/i659bF2Pjv8K6syWMMlQwdOZi6G86L
 sNN+9KPmBGaM0XbNzBgSQ0vmVDLP+2l+0Cyp34Qy78DnL2aUdMxJfg4KcKbVSwl3I6Wg
 fhuuliZA2E6eLkLfBRDlwUZiFClkttLzvBDJVJhc7hh4dFKEtOgGHiLozcTCSYklNvtH
 Y2vo65lLhX5gsQ1FwRZo5l1dMbeukL41RAreer9EzZDZi0Ob3womdLrO/QWIUJtzhbQs
 cw72X0RjrpzkPRR/K4aNiRTrzZrzJMGIxdn1gXr5e8+DFXvlavEavj0erbPV7GGpqQqR
 zkBg==
X-Gm-Message-State: AC+VfDzxgSINqwX1PKo2+R9bZso0RSmfeLx8oKxKDdFt0tEt+sflLS2V
 JTHF8MpyisDyc8MkZf5DLkRnxQTuiNCmEtOXPngl0dE8/CM=
X-Google-Smtp-Source: ACHHUZ6dufwscDnwqTMUs09109CISPNJ7D6drmoYxnNgmRiNrYonA9wblKVk2KtR/4dVQPdMGWVeSZe7uHum1Xq5ur8=
X-Received: by 2002:a05:622a:2c5:b0:3f5:15bf:94e5 with SMTP id
 a5-20020a05622a02c500b003f515bf94e5mr1206290qtx.17.1685786554880; Sat, 03 Jun
 2023 03:02:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230530002032.15227-1-eatnumber1@gmail.com>
In-Reply-To: <20230530002032.15227-1-eatnumber1@gmail.com>
From: Russell Harmon <eatnumber1@gmail.com>
Date: Sat, 3 Jun 2023 03:02:09 -0700
Message-ID: <CA+zrezTKon+02mfMRsW34Tkovqn3FsSD2_9tk-+a4icjt9PsDg@mail.gmail.com>
To: mpatocka@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH] Improve the dm-integrity documentation.
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

QXBvbG9naWVzIGZvciBteSBpbmV4cGVyaWVuY2UgaGVyZSwgYnV0IGlzIHRoaXMgcGF0Y2ggbGlr
ZWx5IHRvIGdldAppbmNsdWRlZD8gSSBzZWUgdGhlcmUncyBiZWVuIG5vIGRpc2N1c3Npb24uCgpP
biBNb24sIE1heSAyOSwgMjAyMyBhdCA1OjIw4oCvUE0gUnVzc2VsbCBIYXJtb24gPGVhdG51bWJl
cjFAZ21haWwuY29tPiB3cm90ZToKPgo+IERvY3VtZW50cyB0aGUgbWVhbmluZyBvZiB0aGUgImJ1
ZmZlciIsIGFkZHMgZG9jdW1lbnRhdGlvbiBvZiB0aGUgY3VycmVudAo+IGRlZmF1bHRzLCBhbmQg
cHJvdmlkZXMgYW4gZXhhbXBsZSBvZiBob3cgdGhlIHR1bmFibGVzIHJlbGF0ZSB0byBlYWNoCj4g
b3RoZXIuCj4KPiBTaWduZWQtb2ZmLWJ5OiBSdXNzZWxsIEhhcm1vbiA8ZWF0bnVtYmVyMUBnbWFp
bC5jb20+Cj4gLS0tCj4gIC4uLi9kZXZpY2UtbWFwcGVyL2RtLWludGVncml0eS5yc3QgICAgICAg
ICAgICB8IDQ0ICsrKysrKysrKysrKy0tLS0tLS0KPiAgMSBmaWxlIGNoYW5nZWQsIDI3IGluc2Vy
dGlvbnMoKyksIDE3IGRlbGV0aW9ucygtKQo+Cj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24v
YWRtaW4tZ3VpZGUvZGV2aWNlLW1hcHBlci9kbS1pbnRlZ3JpdHkucnN0IGIvRG9jdW1lbnRhdGlv
bi9hZG1pbi1ndWlkZS9kZXZpY2UtbWFwcGVyL2RtLWludGVncml0eS5yc3QKPiBpbmRleCA4ZGIx
NzJlZmEyNzIuLjYzNGE3ODBkN2M1MSAxMDA2NDQKPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2FkbWlu
LWd1aWRlL2RldmljZS1tYXBwZXIvZG0taW50ZWdyaXR5LnJzdAo+ICsrKyBiL0RvY3VtZW50YXRp
b24vYWRtaW4tZ3VpZGUvZGV2aWNlLW1hcHBlci9kbS1pbnRlZ3JpdHkucnN0Cj4gQEAgLTI1LDcg
KzI1LDcgQEAgbW9kZSBpdCBjYWxjdWxhdGVzIGFuZCB2ZXJpZmllcyB0aGUgaW50ZWdyaXR5IHRh
ZyBpbnRlcm5hbGx5LiBJbiB0aGlzCj4gIG1vZGUsIHRoZSBkbS1pbnRlZ3JpdHkgdGFyZ2V0IGNh
biBiZSB1c2VkIHRvIGRldGVjdCBzaWxlbnQgZGF0YQo+ICBjb3JydXB0aW9uIG9uIHRoZSBkaXNr
IG9yIGluIHRoZSBJL08gcGF0aC4KPgo+IC1UaGVyZSdzIGFuIGFsdGVybmF0ZSBtb2RlIG9mIG9w
ZXJhdGlvbiB3aGVyZSBkbS1pbnRlZ3JpdHkgdXNlcyBiaXRtYXAKPiArVGhlcmUncyBhbiBhbHRl
cm5hdGUgbW9kZSBvZiBvcGVyYXRpb24gd2hlcmUgZG0taW50ZWdyaXR5IHVzZXMgYSBiaXRtYXAK
PiAgaW5zdGVhZCBvZiBhIGpvdXJuYWwuIElmIGEgYml0IGluIHRoZSBiaXRtYXAgaXMgMSwgdGhl
IGNvcnJlc3BvbmRpbmcKPiAgcmVnaW9uJ3MgZGF0YSBhbmQgaW50ZWdyaXR5IHRhZ3MgYXJlIG5v
dCBzeW5jaHJvbml6ZWQgLSBpZiB0aGUgbWFjaGluZQo+ICBjcmFzaGVzLCB0aGUgdW5zeW5jaHJv
bml6ZWQgcmVnaW9ucyB3aWxsIGJlIHJlY2FsY3VsYXRlZC4gVGhlIGJpdG1hcCBtb2RlCj4gQEAg
LTM4LDYgKzM4LDE1IEBAIHRoZSBkZXZpY2UuIEJ1dCBpdCB3aWxsIG9ubHkgZm9ybWF0IHRoZSBk
ZXZpY2UgaWYgdGhlIHN1cGVyYmxvY2sgY29udGFpbnMKPiAgemVyb2VzLiBJZiB0aGUgc3VwZXJi
bG9jayBpcyBuZWl0aGVyIHZhbGlkIG5vciB6ZXJvZWQsIHRoZSBkbS1pbnRlZ3JpdHkKPiAgdGFy
Z2V0IGNhbid0IGJlIGxvYWRlZC4KPgo+ICtBY2Nlc3NlcyB0byB0aGUgb24tZGlzayBtZXRhZGF0
YSBhcmVhIGNvbnRhaW5pbmcgY2hlY2tzdW1zIChha2EgdGFncykgaXMKPiArYnVmZmVyZWQgdXNp
bmcgZG0tYnVmaW8uIFdoZW4gYW4gYWNjZXNzIHRvIGFueSBnaXZlbiBtZXRhZGF0YSBhcmVhCj4g
K29jY3VycywgZWFjaCB1bmlxdWUgbWV0YWRhdGEgYXJlYSBnZXRzIGl0cyBvd24gYnVmZmVyKHMp
LiBUaGUgYnVmZmVyIHNpemUKPiAraXMgY2FwcGVkIGF0IHRoZSBzaXplIG9mIHRoZSBtZXRhZGF0
YSBhcmVhLCBidXQgbWF5IGJlIHNtYWxsZXIsIHRoZXJlYnkKPiArcmVxdWlyaW5nIG11bHRpcGxl
IGJ1ZmZlcnMgdG8gcmVwcmVzZW50IHRoZSBmdWxsIG1ldGFkYXRhIGFyZWEuIEEgc21hbGxlcgo+
ICtidWZmZXIgc2l6ZSB3aWxsIHByb2R1Y2UgYSBzbWFsbGVyIHJlc3VsdGluZyByZWFkL3dyaXRl
IG9wZXJhdGlvbiB0byB0aGUKPiArbWV0YWRhdGEgYXJlYSBmb3Igc21hbGwgcmVhZHMvd3JpdGVz
LiBBIGZ1bGwgd3JpdGUgdG8gdGhlIGRhdGEgY292ZXJlZCBieQo+ICthIHNpbmdsZSBidWZmZXIg
ZG9lcyAqbm90KiBza2lwIHRoZSByZWFkIG9mIHRoZSBtZXRhZGF0YS4KPiArCj4gIFRvIHVzZSB0
aGUgdGFyZ2V0IGZvciB0aGUgZmlyc3QgdGltZToKPgo+ICAxLiBvdmVyd3JpdGUgdGhlIHN1cGVy
YmxvY2sgd2l0aCB6ZXJvZXMKPiBAQCAtOTMsNyArMTAyLDcgQEAgam91cm5hbF9zZWN0b3JzOm51
bWJlcgo+ICAgICAgICAgZGV2aWNlLiBJZiB0aGUgZGV2aWNlIGlzIGFscmVhZHkgZm9ybWF0dGVk
LCB0aGUgdmFsdWUgZnJvbSB0aGUKPiAgICAgICAgIHN1cGVyYmxvY2sgaXMgdXNlZC4KPgo+IC1p
bnRlcmxlYXZlX3NlY3RvcnM6bnVtYmVyCj4gK2ludGVybGVhdmVfc2VjdG9yczpudW1iZXIgKGRl
ZmF1bHQgMzI3NjgpCj4gICAgICAgICBUaGUgbnVtYmVyIG9mIGludGVybGVhdmVkIHNlY3RvcnMu
IFRoaXMgdmFsdWVzIGlzIHJvdW5kZWQgZG93biB0bwo+ICAgICAgICAgYSBwb3dlciBvZiB0d28u
IElmIHRoZSBkZXZpY2UgaXMgYWxyZWFkeSBmb3JtYXR0ZWQsIHRoZSB2YWx1ZSBmcm9tCj4gICAg
ICAgICB0aGUgc3VwZXJibG9jayBpcyB1c2VkLgo+IEBAIC0xMDIsMjAgKzExMSwxNiBAQCBtZXRh
X2RldmljZTpkZXZpY2UKPiAgICAgICAgIERvbid0IGludGVybGVhdmUgdGhlIGRhdGEgYW5kIG1l
dGFkYXRhIG9uIHRoZSBkZXZpY2UuIFVzZSBhCj4gICAgICAgICBzZXBhcmF0ZSBkZXZpY2UgZm9y
IG1ldGFkYXRhLgo+Cj4gLWJ1ZmZlcl9zZWN0b3JzOm51bWJlcgo+IC0gICAgICAgVGhlIG51bWJl
ciBvZiBzZWN0b3JzIGluIG9uZSBidWZmZXIuIFRoZSB2YWx1ZSBpcyByb3VuZGVkIGRvd24gdG8K
PiAtICAgICAgIGEgcG93ZXIgb2YgdHdvLgo+ICtidWZmZXJfc2VjdG9yczpudW1iZXIgKGRlZmF1
bHQgMTI4KQo+ICsgICAgICAgVGhlIG51bWJlciBvZiBzZWN0b3JzIGluIG9uZSBtZXRhZGF0YSBi
dWZmZXIuIFRoZSB2YWx1ZSBpcyByb3VuZGVkCj4gKyAgICAgICBkb3duIHRvIGEgcG93ZXIgb2Yg
dHdvLgo+Cj4gLSAgICAgICBUaGUgdGFnIGFyZWEgaXMgYWNjZXNzZWQgdXNpbmcgYnVmZmVycywg
dGhlIGJ1ZmZlciBzaXplIGlzCj4gLSAgICAgICBjb25maWd1cmFibGUuIFRoZSBsYXJnZSBidWZm
ZXIgc2l6ZSBtZWFucyB0aGF0IHRoZSBJL08gc2l6ZSB3aWxsCj4gLSAgICAgICBiZSBsYXJnZXIs
IGJ1dCB0aGVyZSBjb3VsZCBiZSBsZXNzIEkvT3MgaXNzdWVkLgo+IC0KPiAtam91cm5hbF93YXRl
cm1hcms6bnVtYmVyCj4gK2pvdXJuYWxfd2F0ZXJtYXJrOm51bWJlciAoZGVmYXVsdCA1MCkKPiAg
ICAgICAgIFRoZSBqb3VybmFsIHdhdGVybWFyayBpbiBwZXJjZW50cy4gV2hlbiB0aGUgc2l6ZSBv
ZiB0aGUgam91cm5hbAo+ICAgICAgICAgZXhjZWVkcyB0aGlzIHdhdGVybWFyaywgdGhlIHRocmVh
ZCB0aGF0IGZsdXNoZXMgdGhlIGpvdXJuYWwgd2lsbAo+ICAgICAgICAgYmUgc3RhcnRlZC4KPgo+
IC1jb21taXRfdGltZTpudW1iZXIKPiArY29tbWl0X3RpbWU6bnVtYmVyIChkZWZhdWx0IDEwMDAw
KQo+ICAgICAgICAgQ29tbWl0IHRpbWUgaW4gbWlsbGlzZWNvbmRzLiBXaGVuIHRoaXMgdGltZSBw
YXNzZXMsIHRoZSBqb3VybmFsIGlzCj4gICAgICAgICB3cml0dGVuLiBUaGUgam91cm5hbCBpcyBh
bHNvIHdyaXR0ZW4gaW1tZWRpYXRlbHkgaWYgdGhlIEZMVVNICj4gICAgICAgICByZXF1ZXN0IGlz
IHJlY2VpdmVkLgo+IEBAIC0xNjMsMTEgKzE2OCwxMCBAQCBqb3VybmFsX21hYzphbGdvcml0aG0o
OmtleSkgICAgICAgKHRoZSBrZXkgaXMgb3B0aW9uYWwpCj4gICAgICAgICB0aGUgam91cm5hbC4g
VGh1cywgbW9kaWZpZWQgc2VjdG9yIG51bWJlciB3b3VsZCBiZSBkZXRlY3RlZCBhdAo+ICAgICAg
ICAgdGhpcyBzdGFnZS4KPgo+IC1ibG9ja19zaXplOm51bWJlcgo+IC0gICAgICAgVGhlIHNpemUg
b2YgYSBkYXRhIGJsb2NrIGluIGJ5dGVzLiAgVGhlIGxhcmdlciB0aGUgYmxvY2sgc2l6ZSB0aGUK
PiArYmxvY2tfc2l6ZTpudW1iZXIgKGRlZmF1bHQgNTEyKQo+ICsgICAgICAgVGhlIHNpemUgb2Yg
YSBkYXRhIGJsb2NrIGluIGJ5dGVzLiBUaGUgbGFyZ2VyIHRoZSBibG9jayBzaXplIHRoZQo+ICAg
ICAgICAgbGVzcyBvdmVyaGVhZCB0aGVyZSBpcyBmb3IgcGVyLWJsb2NrIGludGVncml0eSBtZXRh
ZGF0YS4KPiAtICAgICAgIFN1cHBvcnRlZCB2YWx1ZXMgYXJlIDUxMiwgMTAyNCwgMjA0OCBhbmQg
NDA5NiBieXRlcy4gIElmIG5vdAo+IC0gICAgICAgc3BlY2lmaWVkIHRoZSBkZWZhdWx0IGJsb2Nr
IHNpemUgaXMgNTEyIGJ5dGVzLgo+ICsgICAgICAgU3VwcG9ydGVkIHZhbHVlcyBhcmUgNTEyLCAx
MDI0LCAyMDQ4IGFuZCA0MDk2IGJ5dGVzLgo+Cj4gIHNlY3RvcnNfcGVyX2JpdDpudW1iZXIKPiAg
ICAgICAgIEluIHRoZSBiaXRtYXAgbW9kZSwgdGhpcyBwYXJhbWV0ZXIgc3BlY2lmaWVzIHRoZSBu
dW1iZXIgb2YKPiBAQCAtMjA5LDYgKzIxMywxMiBAQCB0YWJsZSBhbmQgc3dhcCB0aGUgdGFibGVz
IHdpdGggc3VzcGVuZCBhbmQgcmVzdW1lKS4gVGhlIG90aGVyIGFyZ3VtZW50cwo+ICBzaG91bGQg
bm90IGJlIGNoYW5nZWQgd2hlbiByZWxvYWRpbmcgdGhlIHRhcmdldCBiZWNhdXNlIHRoZSBsYXlv
dXQgb2YgZGlzawo+ICBkYXRhIGRlcGVuZCBvbiB0aGVtIGFuZCB0aGUgcmVsb2FkZWQgdGFyZ2V0
IHdvdWxkIGJlIG5vbi1mdW5jdGlvbmFsLgo+Cj4gK0ZvciBleGFtcGxlLCBvbiBhIGRldmljZSB1
c2luZyB0aGUgZGVmYXVsdCBpbnRlcmxlYXZlX3NlY3RvcnMgb2YgMzI3NjgsIGEKPiArYmxvY2tf
c2l6ZSBvZiA1MTIsIGFuZCBhbiBpbnRlcm5hbF9oYXNoIG9mIGNyYzMyYyB3aXRoIGEgdGFnIHNp
emUgb2YgNAo+ICtieXRlcywgaXQgd2lsbCB0YWtlIDEyOCBLaUIgb2YgdGFncyB0byB0cmFjayBh
IGZ1bGwgZGF0YSBhcmVhLCByZXF1aXJpbmcKPiArMjU2IHNlY3RvcnMgb2YgbWV0YWRhdGEgcGVy
IGRhdGEgYXJlYS4gV2l0aCB0aGUgZGVmYXVsdCBidWZmZXJfc2VjdG9ycyBvZgo+ICsxMjgsIHRo
YXQgbWVhbnMgdGhlcmUgd2lsbCBiZSAyIGJ1ZmZlcnMgcGVyIG1ldGFkYXRhIGFyZWEsIG9yIDIg
YnVmZmVycwo+ICtwZXIgMTYgTWlCIG9mIGRhdGEuCj4KPiAgU3RhdHVzIGxpbmU6Cj4KPiBAQCAt
Mjg1LDggKzI5NSw4IEBAIFRoZSBsYXlvdXQgb2YgdGhlIGZvcm1hdHRlZCBibG9jayBkZXZpY2U6
Cj4gICogb25lIG9yIG1vcmUgcnVucyBvZiBpbnRlcmxlYXZlZCB0YWdzIGFuZCBkYXRhLgo+ICAg
ICAgRWFjaCBydW4gY29udGFpbnM6Cj4KPiAtICAgICAgICogdGFnIGFyZWEgLSBpdCBjb250YWlu
cyBpbnRlZ3JpdHkgdGFncy4gVGhlcmUgaXMgb25lIHRhZyBmb3IgZWFjaAo+IC0gICAgICAgICBz
ZWN0b3IgaW4gdGhlIGRhdGEgYXJlYQo+ICsgICAgICAgKiB0YWcgYXJlYSAtIGl0IGNvbnRhaW5z
IGludGVncml0eSB0YWdzLiBUaGVyZSBpcyBvbmUgdGFnIGZvciBlYWNoIHNlY3RvciBpbgo+ICsg
ICAgICAgICB0aGUgZGF0YSBhcmVhLiBUaGUgc2l6ZSBvZiB0aGlzIGFyZWEgaXMgYWx3YXlzIDRL
aUIgb3IgZ3JlYXRlci4KPiAgICAgICAgICogZGF0YSBhcmVhIC0gaXQgY29udGFpbnMgZGF0YSBz
ZWN0b3JzLiBUaGUgbnVtYmVyIG9mIGRhdGEgc2VjdG9ycwo+ICAgICAgICAgICBpbiBvbmUgcnVu
IG11c3QgYmUgYSBwb3dlciBvZiB0d28uIGxvZzIgb2YgdGhpcyB2YWx1ZSBpcyBzdG9yZWQKPiAg
ICAgICAgICAgaW4gdGhlIHN1cGVyYmxvY2suCj4gLS0KPiAyLjM0LjEKPgoKLS0KZG0tZGV2ZWwg
bWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5j
b20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

