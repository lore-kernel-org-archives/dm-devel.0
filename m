Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 548D5C7EE22
	for <dm-devel@archiver.kernel.org>; Tue,  9 May 2023 00:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683593515;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TbxTFN/vgWnZNMNq/EkvTQSLJyVHDWQqrL8BIgzdis4=;
	b=ASX99fkC8Kf9o+4zCrHzk7bgtmm2d1sE+isMXJEjwVolIUWJIYz9akeDbvTE6704/k0/Eu
	Rd2AyD12kMOk+fGvvczuZNDC2QHISXwhZV+cKqVuUaIscXqSsoCROu41nFncW8HHAgm++/
	umsiXjB70BKrdx7kAC7OTETWzi7Tlkg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-256-WuwZ1U3qO9uwO886zRnZ2g-1; Mon, 08 May 2023 20:51:51 -0400
X-MC-Unique: WuwZ1U3qO9uwO886zRnZ2g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA267100F655;
	Tue,  9 May 2023 00:51:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 846B71121314;
	Tue,  9 May 2023 00:51:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 68E0B19452C5;
	Tue,  9 May 2023 00:51:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9AF6219452C4
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 May 2023 00:51:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8E9EBC15BA0; Tue,  9 May 2023 00:51:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 86C4EC16024
 for <dm-devel@redhat.com>; Tue,  9 May 2023 00:51:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57C02381D4C3
 for <dm-devel@redhat.com>; Tue,  9 May 2023 00:51:48 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-BuVWlrSbMYSBTkBqan_sWQ-1; Mon, 08 May 2023 20:51:44 -0400
X-MC-Unique: BuVWlrSbMYSBTkBqan_sWQ-1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="377879144"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; d="scan'208";a="377879144"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
 by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 08 May 2023 17:51:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="842901610"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; d="scan'208";a="842901610"
Received: from ahdamali-mobl.amr.corp.intel.com (HELO [10.212.29.166])
 ([10.212.29.166])
 by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 08 May 2023 17:51:42 -0700
Message-ID: <5652406b-1764-ee02-d76f-c2c7ab66d213@intel.com>
Date: Mon, 8 May 2023 17:51:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
To: "Chang S. Bae" <chang.seok.bae@intel.com>,
 Eric Biggers <ebiggers@kernel.org>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20230410225936.8940-1-chang.seok.bae@intel.com>
 <20230410225936.8940-8-chang.seok.bae@intel.com> <ZFWLoOZZTnBrid+7@gmail.com>
 <1b2eb485-2320-b33b-a0ac-53f7cb170adc@intel.com>
 <8748511c-cf9a-f3ce-e560-d0646dc3d108@intel.com>
 <e9508862-1fdb-d27f-8138-3b7691671405@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <e9508862-1fdb-d27f-8138-3b7691671405@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
 gmazyland@gmail.com, charishma1.gairuboyina@intel.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNS84LzIzIDE3OjMxLCBDaGFuZyBTLiBCYWUgd3JvdGU6Cj4+IFdpdGggdGhlIG1hY3JvLCB0
aGV5J2xsIGdldCBubyB0eXBlIHdhcm5pbmcuwqAgVGhlIGlubGluZSBhY3R1YWxseSBtYWtlcwo+
PiBpdCBlYXNpZXIgdG8gZmluZCBidWdzIGJlY2F1c2UgZm9sa3Mgd2lsbCBnZXQgX3NvbWVfIHR5
cGUgY2hlY2tpbmcgbm8KPj4gbWF0dGVyIGhvdyB0aGV5IGNvbXBpbGUgdGhlIGNvZGUuCj4gCj4g
QWgsIHdoZW4gdGhlIHByb3RvdHlwZSB3aXRoIG9uZSBvciBtb3JlIGFyZ3VtZW50cywgJ3N0YXRp
YyBpbmxpbmUnCj4gYWxsb3dzIHRoZSBjaGVjay4gVGhlbiBpdCBpcyBub3QgYW4gJ2VpdGhlci13
YXknIHRoaW5nLgo+IAo+IExvb2tpbmcgYXQgdGhlIHg4NiBjb2RlLCB0aGVyZSBhcmUgc29tZSBz
ZWVtaW5nbHkgcmVsYXRlZDoKPiAKPiAkIGdpdCBncmVwICJkbyB7IH0gd2hpbGUgKDApIiBhcmNo
L3g4NiB8IGdyZXAgLXYgIigpIgouLi4KClJpZ2h0LiAgSXQncyBub3QgYSBoYXJkIGFuZCBmYXN0
IHJ1bGUuICBXZSBjZXJ0YWlubHkgdGFrZSBjb2RlIGVpdGhlcgp3YXkgYW5kIHRoZXJlIGNhbiBi
ZSByZWFsIHJlYXNvbnMgdG8gZG8gaXQgb25lIHdheSB2ZXJzdXMgdGhlIG90aGVyLgoKLS0KZG0t
ZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJl
ZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

