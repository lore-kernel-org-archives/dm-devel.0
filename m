Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74F91C7619A
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 19:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681240431;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aYvkA2uD8eptslOO1iJfoTnnChtNSHZH31rpa3faxdU=;
	b=bCACoOVtxBrZxmYV4NmD798lhTmlFe3XpSPh5WDggmBzvaEZlC0Es4MSVmGj6srbRZHpCu
	FFE+ouiPg9dXYO0p49ozc7L3uTToxT52CEp91Tprtt/taBYocP3C3a7GRN8QonGENiDiZa
	wALYCzzI04GjKLPlkRNnPBZ7EHwko/Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-oaklEZGPN8KwjHWSyiI1Tw-1; Tue, 11 Apr 2023 15:13:48 -0400
X-MC-Unique: oaklEZGPN8KwjHWSyiI1Tw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6AB4811E7C;
	Tue, 11 Apr 2023 19:13:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A017E40BC797;
	Tue, 11 Apr 2023 19:13:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5F3131946A41;
	Tue, 11 Apr 2023 19:13:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0A13E1946A46
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Apr 2023 19:13:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F1A19112132D; Tue, 11 Apr 2023 19:13:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EA4931121320
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 19:13:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBCDE85A588
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 19:13:39 +0000 (UTC)
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com
 [209.85.128.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-B6K4ldlUNsS_fjuOfxFwqA-1; Tue, 11 Apr 2023 15:13:38 -0400
X-MC-Unique: B6K4ldlUNsS_fjuOfxFwqA-1
Received: by mail-yw1-f173.google.com with SMTP id
 00721157ae682-54ee17a659bso177921537b3.4
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 12:13:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1681240417; x=1683832417;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=ZyhAcQmoHbAJmyI6qNybDWX+d0nq9TvXS/75WN8UzuA=;
 b=s7b0bJq3l/3GkwXcVEfMK9RaMKTv6FXgPgcH/ag2vRIFjQN5EAKtASHwxozFcl+NQu
 05UlDaBm2dB+7WXjx3FX5/HEYRRa9twFFQMGvwfa/+jCGLSx/nO2j1oowkUDif+JrfNM
 nbL8Kap3jlcboCLGm2N3neYNZhHIGzpr7nZh3T54Xnolh3WisZ9DBXI5UMvrpDGIoH4V
 9562TmBeFunHBdI0o5P7PrZnbVyzVuzH2qwvwWlsFb/c0FQazg447oSASstgawmG5hPe
 raZAqU0hoobqBJBdgHt9aQ9oJnyrZ5lvW3noefvvcBv7jPB8pl2hwXeqE67T/FLYa/IO
 Q4dQ==
X-Gm-Message-State: AAQBX9d+VnlyeNkfz3ufk0PXmijbhQ2jVbHzHrASBre2ATaVUUanuXp/
 WGdLQZZ/imgaiCllYRY6BDE2qCiI0LdNp5G2il1Q
X-Google-Smtp-Source: AKy350azG2i8uc9BAHp/wk8VSvxtJ0aqfSk9gTsrxDzJOGJbd8PZzFADbtv5hxGRkczUVNGtVCqIHdlrFObziFErZeI=
X-Received: by 2002:a81:a904:0:b0:54f:2b65:a865 with SMTP id
 g4-20020a81a904000000b0054f2b65a865mr4260299ywh.8.1681240417154; Tue, 11 Apr
 2023 12:13:37 -0700 (PDT)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-3-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhRguGeb8=oNVFebshL_2LLZ4hf0qO97YBVm8OObLsLNTw@mail.gmail.com>
 <20230406200055.GB19196@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20230406200055.GB19196@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 11 Apr 2023 15:13:26 -0400
Message-ID: <CAHC9VhTkEHvoSFu8h=tuGJAjPhohj7ABPi+XXVg4j5MesCbtxw@mail.gmail.com>
To: Fan Wu <wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [RFC PATCH v9 02/16] ipe: add policy parser
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu,
 dm-devel@redhat.com, corbet@lwn.net, roberto.sassu@huawei.com,
 Deven Bowers <deven.desai@linux.microsoft.com>, linux-doc@vger.kernel.org,
 snitzer@kernel.org, jmorris@namei.org, zohar@linux.ibm.com,
 linux-kernel@vger.kernel.org, ebiggers@kernel.org,
 linux-security-module@vger.kernel.org, linux-audit@redhat.com,
 eparis@redhat.com, linux-fscrypt@vger.kernel.org,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBBcHIgNiwgMjAyMyBhdCA0OjAw4oCvUE0gRmFuIFd1IDx3dWZhbkBsaW51eC5taWNy
b3NvZnQuY29tPiB3cm90ZToKPiBPbiBUaHUsIE1hciAwMiwgMjAyMyBhdCAwMjowMjozMlBNIC0w
NTAwLCBQYXVsIE1vb3JlIHdyb3RlOgo+ID4gT24gTW9uLCBKYW4gMzAsIDIwMjMgYXQgNTo1OD8/
P1BNIEZhbiBXdSA8d3VmYW5AbGludXgubWljcm9zb2Z0LmNvbT4gd3JvdGU6Cj4gPiA+Cj4gPiA+
IEZyb206IERldmVuIEJvd2VycyA8ZGV2ZW4uZGVzYWlAbGludXgubWljcm9zb2Z0LmNvbT4KPiA+
ID4KPiA+ID4gSVBFJ3MgaW50ZXJwcmV0YXRpb24gb2YgdGhlIHdoYXQgdGhlIHVzZXIgdHJ1c3Rz
IGlzIGFjY29tcGxpc2hlZCB0aHJvdWdoCj4gPiA+IGl0cyBwb2xpY3kuIElQRSdzIGRlc2lnbiBp
cyB0byBub3QgcHJvdmlkZSBzdXBwb3J0IGZvciBhIHNpbmdsZSB0cnVzdAo+ID4gPiBwcm92aWRl
ciwgYnV0IHRvIHN1cHBvcnQgbXVsdGlwbGUgcHJvdmlkZXJzIHRvIGVuYWJsZSB0aGUgZW5kLXVz
ZXIgdG8KPiA+ID4gY2hvb3NlIHRoZSBiZXN0IG9uZSB0byBzZWVrIHRoZWlyIG5lZWRzLgo+ID4g
Pgo+ID4gPiBUaGlzIHJlcXVpcmVzIHRoZSBwb2xpY3kgdG8gYmUgcmF0aGVyIGZsZXhpYmxlIGFu
ZCBtb2R1bGFyIHNvIHRoYXQKPiA+ID4gaW50ZWdyaXR5IHByb3ZpZGVycywgbGlrZSBmcy12ZXJp
dHksIGRtLXZlcml0eSwgZG0taW50ZWdyaXR5LCBvcgo+ID4gPiBzb21lIG90aGVyIHN5c3RlbSwg
Y2FuIHBsdWcgaW50byB0aGUgcG9saWN5IHdpdGggbWluaW1hbCBjb2RlIGNoYW5nZXMuCj4gPiA+
Cj4gPiA+IFNpZ25lZC1vZmYtYnk6IERldmVuIEJvd2VycyA8ZGV2ZW4uZGVzYWlAbGludXgubWlj
cm9zb2Z0LmNvbT4KPiA+ID4gU2lnbmVkLW9mZi1ieTogRmFuIFd1IDx3dWZhbkBsaW51eC5taWNy
b3NvZnQuY29tPgo+ID4KPiA+IC4uLgo+ID4KPiA+ID4gLS0tCj4gPiA+ICBzZWN1cml0eS9pcGUv
TWFrZWZpbGUgICAgICAgIHwgICAyICsKPiA+ID4gIHNlY3VyaXR5L2lwZS9wb2xpY3kuYyAgICAg
ICAgfCAgOTkgKysrKysrKwo+ID4gPiAgc2VjdXJpdHkvaXBlL3BvbGljeS5oICAgICAgICB8ICA3
NyArKysrKysKPiA+ID4gIHNlY3VyaXR5L2lwZS9wb2xpY3lfcGFyc2VyLmMgfCA1MTUgKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysKPiA+ID4gIHNlY3VyaXR5L2lwZS9wb2xpY3lf
cGFyc2VyLmggfCAgMTEgKwo+ID4gPiAgNSBmaWxlcyBjaGFuZ2VkLCA3MDQgaW5zZXJ0aW9ucygr
KQo+ID4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IHNlY3VyaXR5L2lwZS9wb2xpY3kuYwo+ID4gPiAg
Y3JlYXRlIG1vZGUgMTAwNjQ0IHNlY3VyaXR5L2lwZS9wb2xpY3kuaAo+ID4gPiAgY3JlYXRlIG1v
ZGUgMTAwNjQ0IHNlY3VyaXR5L2lwZS9wb2xpY3lfcGFyc2VyLmMKPiA+ID4gIGNyZWF0ZSBtb2Rl
IDEwMDY0NCBzZWN1cml0eS9pcGUvcG9saWN5X3BhcnNlci5oCgouLi4KCj4gPiA+IGRpZmYgLS1n
aXQgYS9zZWN1cml0eS9pcGUvcG9saWN5X3BhcnNlci5jIGIvc2VjdXJpdHkvaXBlL3BvbGljeV9w
YXJzZXIuYwo+ID4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NAo+ID4gPiBpbmRleCAwMDAwMDAwMDAw
MDAuLmM3YmEwZTg2NTM2Ngo+ID4gPiAtLS0gL2Rldi9udWxsCj4gPiA+ICsrKyBiL3NlY3VyaXR5
L2lwZS9wb2xpY3lfcGFyc2VyLmMKPiA+ID4gQEAgLTAsMCArMSw1MTUgQEAKPiA+ID4gKy8vIFNQ
RFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wCj4gPiA+ICsvKgo+ID4gPiArICogQ29weXJp
Z2h0IChDKSBNaWNyb3NvZnQgQ29ycG9yYXRpb24uIEFsbCByaWdodHMgcmVzZXJ2ZWQuCj4gPiA+
ICsgKi8KPiA+ID4gKwo+ID4gPiArI2luY2x1ZGUgInBvbGljeS5oIgo+ID4gPiArI2luY2x1ZGUg
InBvbGljeV9wYXJzZXIuaCIKPiA+ID4gKyNpbmNsdWRlICJkaWdlc3QuaCIKPiA+ID4gKwo+ID4g
PiArI2luY2x1ZGUgPGxpbnV4L3BhcnNlci5oPgo+ID4gPiArCj4gPiA+ICsjZGVmaW5lIFNUQVJU
X0NPTU1FTlQgICcjJwo+ID4gPiArCj4gPiA+ICsvKioKPiA+ID4gKyAqIG5ld19wYXJzZWRfcG9s
aWN5IC0gQWxsb2NhdGUgYW5kIGluaXRpYWxpemUgYSBwYXJzZWQgcG9saWN5Lgo+ID4gPiArICoK
PiA+ID4gKyAqIFJldHVybjoKPiA+ID4gKyAqICogIUlTX0VSUiAgIC0gT0sKPiA+ID4gKyAqICog
LUVOT01FTSAgIC0gT3V0IG9mIG1lbW9yeQo+ID4gPiArICovCj4gPiA+ICtzdGF0aWMgc3RydWN0
IGlwZV9wYXJzZWRfcG9saWN5ICpuZXdfcGFyc2VkX3BvbGljeSh2b2lkKQo+ID4gPiArewo+ID4g
PiArICAgICAgIHNpemVfdCBpID0gMDsKPiA+ID4gKyAgICAgICBzdHJ1Y3QgaXBlX3BhcnNlZF9w
b2xpY3kgKnAgPSBOVUxMOwo+ID4gPiArICAgICAgIHN0cnVjdCBpcGVfb3BfdGFibGUgKnQgPSBO
VUxMOwo+ID4gPiArCj4gPiA+ICsgICAgICAgcCA9IGt6YWxsb2Moc2l6ZW9mKCpwKSwgR0ZQX0tF
Uk5FTCk7Cj4gPiA+ICsgICAgICAgaWYgKCFwKQo+ID4gPiArICAgICAgICAgICAgICAgcmV0dXJu
IEVSUl9QVFIoLUVOT01FTSk7Cj4gPiA+ICsKPiA+ID4gKyAgICAgICBwLT5nbG9iYWxfZGVmYXVs
dF9hY3Rpb24gPSBpcGVfYWN0aW9uX21heDsKPiA+Cj4gPiBJJ20gYXNzdW1pbmcgeW91J3JlIHVz
aW5nIHRoZSAiaXBlX2FjdGlvbl9tYXgiIGFzIGFuIGludGVudGlvbmFsIGJvZ3VzCj4gPiBwbGFj
ZWhvbGRlciB2YWx1ZSBoZXJlLCB5ZXM/ICBJZiB0aGF0IGlzIHRoZSBjYXNlLCBoYXZlIHlvdSBj
b25zaWRlcmVkCj4gPiBjcmVhdGluZyBhbiAiaW52YWxpZCIgZW51bSB3aXRoIGFuIGV4cGxpY2l0
IHplcm8gdmFsdWUgdG8gc2F2ZSB5b3UKPiA+IHRoaXMgYWRkaXRpb25hbCBhc3NpZ25tZW50ICh5
b3UgYXJlIGFscmVhZHkgdXNpbmcga3phbGxvYygpKT8gIEZvcgo+ID4gZXhhbXBsZToKPiA+Cj4g
PiAgIGVudW0gaXBlX29wX3R5cGUgewo+ID4gICAgIElQRV9PUF9JTlZBTElEID0gMCwKPiA+ICAg
ICBJUEVfT1BfRVhFQywKPiA+ICAgICAuLi4KPiA+ICAgICBJUEVfT1BfTUFYLAo+ID4gICB9Owo+
ID4KPiA+ICAgZW51bSBpcGVfYWN0aW9uX3R5cGUgewo+ID4gICAgIElQRV9BQ1RJT05fSU5WQUxJ
RCA9IDAsCj4gPiAgICAgSVBFX0FDVElPTl9BTExPVywKPiA+ICAgICAuLi4KPiA+ICAgICBJUEVf
QUNUSU9OX01BWCwKPiA+ICAgfTsKPiA+Cj4KPiBZZXMsIElQRV9BQ1RJT05fTUFYIGlzIGtpbmQg
b2YgdGhlIElOVkFMSUQgdmFsdWUgd2UgYXJlIHVzaW5nIGhlcmUuCj4KPiBCdXQgSSB0aGluayB3
ZSBtaWdodCBiZSBhZGRpbmcgdW5uZWNlc3NhcnkgY29tcGxleGl0eSBieSB1c2luZyB0aGUKPiBJ
UEVfT1BfSU5WTElBRCBlbnVtIGhlcmUuIEN1cnJlbnRseSwgd2UgYXJlIHVzaW5nIElQRV9PUF9N
QVggdG8KPiByZXByZXNlbnQgdGhlIG51bWJlciBvZiBvcGVyYXRpb25zIHdlIGhhdmUsIGFuZCB3
ZSBoYXZlIGFsbG9jYXRlZAo+IGFuIElQRV9PUF9NQVgtc2l6ZWQgYXJyYXkgdG8gc3RvcmUgbGlu
a2VkIGxpc3RzIHRoYXQgbGluayBhbGwgcnVsZXMKPiBmb3IgZWFjaCBvcGVyYXRpb24uIElmIHdl
IHdlcmUgdG8gYWRkIElQRV9PUF9JTlZMSUFEIHRvIHRoZSBlbnVtCj4gZGVmaW5pdGlvbiwgdGhl
biBJUEVfT1BfTUFYLTEgd291bGQgYmVjb21lIHRoZSBudW1iZXIgb2Ygb3BlcmF0aW9ucywKPiBh
bmQgd2Ugd291bGQgbmVlZCB0byBjaGFuZ2UgdGhlIGluZGV4IHVzZWQgdG8gYWNjZXNzIHRoZSBs
aW5rZWQgbGlzdAo+IGFycmF5LgoKR290Y2hhLiAgVGhhbmtzIGZvciB0aGUgZXhwbGFuYXRpb24s
IHRoYXQgaGFkbid0IG9jY3VycmVkIHRvIG1lIHdoaWxlCkkgd2FzIHJldmlld2luZyB0aGUgY29k
ZS4KCkFub3RoZXIgb3B0aW9uIHdvdWxkIGJlIHRvIGNyZWF0ZSBhIG1hY3JvIHRvIGhlbHAgcmVp
bmZvcmNlIHRoYXQgdGhlCiJtYXgiIHZhbHVlIGlzIGJlaW5nIHVzZWQgYXMgYW4gImludmFsaWQi
IHZhbHVlLCBmb3IgZXhhbXBsZToKCiNkZWZpbmUgSVBFX09QX0lOVkFMSUQgSVBFX09QX01BWAoK
LS0gCnBhdWwtbW9vcmUuY29tCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVk
aGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVsCg==

