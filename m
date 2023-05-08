Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B706C7EE2D
	for <dm-devel@archiver.kernel.org>; Tue,  9 May 2023 00:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683590613;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GMRIoEKwo7rUsvpE+/bWnGC54FCjYCMC0Dsbsroi/yA=;
	b=UlsWH9VTjgK/Ee2/xk92gs/I8eJTm8NT0lVdeIQg1PbgbOsJhd4a0ZoZtaSCJVeK4iCuPg
	I4jAinHdTXzPMCrHXAoaQNCuL4Wpx4f17mxlcpDLmrC+d1bK6KmOwzItiExontpVdGxEoM
	v9CJhF/hKnGQqajjy8IR9rFcy77rm+4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-NjtpQi_aPyWLrE7d6s4hsw-1; Mon, 08 May 2023 20:03:30 -0400
X-MC-Unique: NjtpQi_aPyWLrE7d6s4hsw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D805B280558B;
	Tue,  9 May 2023 00:03:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 153B863F86;
	Tue,  9 May 2023 00:03:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DA77019451C8;
	Tue,  9 May 2023 00:03:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B4EB81946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  8 May 2023 21:57:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9464940C6F42; Mon,  8 May 2023 21:57:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CCDD40C6F41
 for <dm-devel@redhat.com>; Mon,  8 May 2023 21:57:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71DCA85A5A3
 for <dm-devel@redhat.com>; Mon,  8 May 2023 21:57:34 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-oXoewXvzM8StYLO9iu4zkA-1; Mon, 08 May 2023 17:57:32 -0400
X-MC-Unique: oXoewXvzM8StYLO9iu4zkA-1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="377859373"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; d="scan'208";a="377859373"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
 by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 08 May 2023 14:56:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="788274135"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; d="scan'208";a="788274135"
Received: from ahdamali-mobl.amr.corp.intel.com (HELO [10.212.29.166])
 ([10.212.29.166])
 by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 08 May 2023 14:56:28 -0700
Message-ID: <8748511c-cf9a-f3ce-e560-d0646dc3d108@intel.com>
Date: Mon, 8 May 2023 14:56:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
To: "Chang S. Bae" <chang.seok.bae@intel.com>,
 Eric Biggers <ebiggers@kernel.org>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20230410225936.8940-1-chang.seok.bae@intel.com>
 <20230410225936.8940-8-chang.seok.bae@intel.com> <ZFWLoOZZTnBrid+7@gmail.com>
 <1b2eb485-2320-b33b-a0ac-53f7cb170adc@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <1b2eb485-2320-b33b-a0ac-53f7cb170adc@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Tue, 09 May 2023 00:03:21 +0000
Subject: Re: [dm-devel] [PATCH v6 07/12] x86/cpu/keylocker: Load an internal
 wrapping key at boot-time
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
Cc: x86@kernel.org, herbert@gondor.apana.org.au, ardb@kernel.org,
 dave.hansen@linux.intel.com, dan.j.williams@intel.com,
 linux-kernel@vger.kernel.org, mingo@kernel.org,
 lalithambika.krishnakumar@intel.com, dm-devel@redhat.com,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 linux-crypto@vger.kernel.org, luto@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, bernie.keany@intel.com, tglx@linutronix.de,
 bp@suse.de, gmazyland@gmail.com, charishma1.gairuboyina@intel.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNS84LzIzIDExOjE4LCBDaGFuZyBTLiBCYWUgd3JvdGU6Cj4gT24gNS81LzIwMjMgNDowNSBQ
TSwgRXJpYyBCaWdnZXJzIHdyb3RlOgo+PiBPbiBNb24sIEFwciAxMCwgMjAyMyBhdCAwMzo1OToz
MVBNIC0wNzAwLCBDaGFuZyBTLiBCYWUgd3JvdGU6Cj4+PiDCoCArI2lmZGVmIENPTkZJR19YODZf
S0VZTE9DS0VSCj4+PiArdm9pZCBzZXR1cF9rZXlsb2NrZXIoc3RydWN0IGNwdWluZm9feDg2ICpj
KTsKPj4+ICt2b2lkIGRlc3Ryb3lfa2V5bG9ja2VyX2RhdGEodm9pZCk7Cj4+PiArI2Vsc2UKPj4+
ICsjZGVmaW5lIHNldHVwX2tleWxvY2tlcihjKSBkbyB7IH0gd2hpbGUgKDApCj4+PiArI2RlZmlu
ZSBkZXN0cm95X2tleWxvY2tlcl9kYXRhKCkgZG8geyB9IHdoaWxlICgwKQo+Pj4gKyNlbmRpZgo+
Pgo+PiBTaG91bGRuJ3QgdGhlICFDT05GSUdfWDg2X0tFWUxPQ0tFUiBzdHVicyBiZSBzdGF0aWMg
aW5saW5lIGZ1bmN0aW9ucwo+PiBpbnN0ZWFkIG9mCj4+IG1hY3Jvcywgc28gdGhhdCB0eXBlIGNo
ZWNraW5nIHdvcmtzPwo+IAo+IEkgdGhpbmsgZWl0aGVyIHdheSB3b3JrcyBoZXJlLiBUaGlzIG1h
Y3JvIGlzIGp1c3QgZm9yIG5vdGhpbmcuCgpDaGFuZywgSSBkbyBwcmVmZXIgdGhlICdzdGF0aWMg
aW5saW5lJyBhcyBhIGdlbmVyYWwgcnVsZS4gIFRoaW5rIG9mIHRoaXM6CgpzdGF0aWMgaW5saW5l
IHZvaWQgc2V0dXBfa2V5bG9ja2VyKHN0cnVjdCBjcHVpbmZvX3g4NiAqYykge30KCnZlcnN1czoK
CiNkZWZpbmUgc2V0dXBfa2V5bG9ja2VyKGMpIGRvIHsgfSB3aGlsZSAoMCkKCkltYWdpbmUgc29t
ZSBkb3BlIGRvZXM6CgoJY2hhciBjOwoJLi4uCglzZXR1cF9rZXlsb2NrZXIoYyk7CgpXaXRoIHRo
ZSBtYWNybywgdGhleSdsbCBnZXQgbm8gdHlwZSB3YXJuaW5nLiAgVGhlIGlubGluZSBhY3R1YWxs
eSBtYWtlcwppdCBlYXNpZXIgdG8gZmluZCBidWdzIGJlY2F1c2UgZm9sa3Mgd2lsbCBnZXQgX3Nv
bWVfIHR5cGUgY2hlY2tpbmcgbm8KbWF0dGVyIGhvdyB0aGV5IGNvbXBpbGUgdGhlIGNvZGUuCgot
LQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3Rt
YW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

