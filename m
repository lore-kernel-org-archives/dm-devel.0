Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD842264602
	for <dm-devel@lists.linux.dev>; Thu, 15 Jan 2026 21:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768512329; cv=none; b=QwHbgXEfKjqlTX12VJsoHFE5dWMtnvIA3fT3sYTp2gq/sGpxQcIjNybBJrBtLGj4QmwGwgNLK3N0Uu7H+hFCWwa1t2kNJrIIhj+OWolxfme1AgSurAYAAH06wsAm17ZA8sBUxsP6ISTq7uzFjsN9mocNO0x8aFt+1QvLLwgfbW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768512329; c=relaxed/simple;
	bh=gTGLVrFY+0dO6x85vDoWb6g9esju8PxIO6Up5v5nxEM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=f3CqY84OHQ2/d6QTSflB2o7UVsphnRUqk5Y5Byt7unkCoE5ZcxzkOq1bCFSbAyIvF/nl8D+Fhlhh/wZmUmuB0t8kLrflOloeYeQMeVL5xmhaMiWiSjbmbaCa58Ee9G5b8lsMZ8moEeaQuZyMZYmoxftm16xzi+Stb93ftVJdpXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=a0d+opYU; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=n1K5UXCL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="a0d+opYU";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="n1K5UXCL"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D1EF7336B9;
	Thu, 15 Jan 2026 21:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1768512326; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gTGLVrFY+0dO6x85vDoWb6g9esju8PxIO6Up5v5nxEM=;
	b=a0d+opYUZDwQBWGXPsLK4p6qq8oLUXIUUojdSdi0W0WsAPg2vVv6T4GNGE/YQlzk1L3V+3
	JjB+4fBr2W0ULZut4Pf8/tQ6+jSzhj2AwNGPE8/nZn03XAvgWvXs8uzIvSEXdsDSFFZX+P
	kJXLCHuI/w2+wQj8ODgOmWU+/GGDMLY=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1768512325; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gTGLVrFY+0dO6x85vDoWb6g9esju8PxIO6Up5v5nxEM=;
	b=n1K5UXCLW9IKSxPyRkVUjfpan7z9hSDy0llx/ON44iUhJY/tJ8JrQejnHGvhSEL1bXY6vf
	SvGeXTTfcDOu+N1nZSY6khDpCJ3zEXrH9q4y+EIydHvcqsBIc6R5kR4qhC5ARNRC8pCml2
	AEjgncB27ewLyKOY+7u3+hBgUTNAy/4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC4913EA63;
	Thu, 15 Jan 2026 21:25:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pAxrKEVbaWkdZwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 15 Jan 2026 21:25:25 +0000
Message-ID: <1013360c887d3d62b30d6baa832c653ee1456a10.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: move SPDX-License-Identifier to the
 top of the file
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Thu, 15 Jan 2026 22:25:25 +0100
In-Reply-To: <20260112161607.55522-1-xose.vazquez@gmail.com>
References: <20260112161607.55522-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spamd-Result: default: False [-2.70 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.991];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.70
X-Spam-Level: 

T24gTW9uLCAyMDI2LTAxLTEyIGF0IDE3OjE2ICswMTAwLCBYb3NlIFZhenF1ZXogUGVyZXogd3Jv
dGU6Cj4gQ2M6IE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPgo+IENjOiBCZW5qYW1pbiBN
YXJ6aW5za2kgPGJtYXJ6aW5zQHJlZGhhdC5jb20+Cj4gQ2M6IENocmlzdG9waGUgVmFyb3F1aSA8
Y2hyaXN0b3BoZS52YXJvcXVpQG9wZW5zdmMuY29tPgo+IENjOiBETV9ERVZFTC1NTCA8ZG0tZGV2
ZWxAbGlzdHMubGludXguZGV2Pgo+IFNpZ25lZC1vZmYtYnk6IFhvc2UgVmF6cXVleiBQZXJleiA8
eG9zZS52YXpxdWV6QGdtYWlsLmNvbT4KPiAtLS0KPiDCoGxpYm1wYXRoY21kL2xpYm1wYXRoY21k
LnZlcnNpb27CoMKgwqDCoMKgwqDCoMKgIHwgMiArLQo+IMKgbGlibXBhdGhwZXJzaXN0L2xpYm1w
YXRocGVyc2lzdC52ZXJzaW9uIHwgMiArLQo+IMKgbGlibXBhdGh1dGlsL2xpYm1wYXRodXRpbC52
ZXJzaW9uwqDCoMKgwqDCoMKgIHwgMiArLQo+IMKgbGlibXBhdGh1dGlsL3N0cmJ1Zi5jwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMiArLQo+IMKgbGlibXBhdGh1dGlsL3N0
cmJ1Zi5owqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMiArLQo+IMKgbGli
bXVsdGlwYXRoL2xpYm11bHRpcGF0aC52ZXJzaW9uwqDCoMKgwqDCoMKgIHwgMiArLQo+IMKgbXVs
dGlwYXRoZC9tdWx0aXBhdGhjLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDIg
Ky0KPiDCoHRlc3RzL2NsaS5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgfCAzICstLQo+IMKgdGVzdHMvZGV2dC5jwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMyArLS0KPiDCoHRlc3Rz
L21hcGluZm8uY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCB8IDIgKy0KPiDCoHRlc3RzL21wYXRodmFsaWQuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCB8IDMgKy0tCj4gwqB0ZXN0cy9zdHJidWYuY8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMiArLQo+IMKgdGVzdHMvc3lz
ZnMuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
fCAyICstCj4gwqB0ZXN0cy92cGQuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMiArLQo+IMKgMTQgZmlsZXMgY2hhbmdlZCwgMTQgaW5z
ZXJ0aW9ucygrKSwgMTcgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2xpYm1wYXRoY21k
L2xpYm1wYXRoY21kLnZlcnNpb24KPiBiL2xpYm1wYXRoY21kL2xpYm1wYXRoY21kLnZlcnNpb24K
PiBpbmRleCA4MWJkYjJiNy4uZTY3Mjc1NWEgMTAwNjQ0Cj4gLS0tIGEvbGlibXBhdGhjbWQvbGli
bXBhdGhjbWQudmVyc2lvbgo+ICsrKyBiL2xpYm1wYXRoY21kL2xpYm1wYXRoY21kLnZlcnNpb24K
PiBAQCAtMSw2ICsxLDYgQEAKPiArLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAt
b3ItbGF0ZXIKCkl0IHR1cm5zIG91dCB0aGF0IHRoZSBsaW5rZXIgZG9lc24ndCBhcHByZWNpYXRl
IEMrKy1zdHlsZSBjb21tZW50cyBpbgpsaW5rZXIgc2NyaXB0cy4gSSdsbCBmaXggdGhhdCwgYnV0
IG5leHQgdGltZSBwbGVhc2UgY29tcGlsZS10ZXN0IHlvdXIKcGF0Y2hlcy4KCkknbSBub3Qgc3Vy
ZSBpZiB0aGUgbGljZW5zZSB0YWcgcmVhbGx5IG5lZWRzIHRvIGJlIGluIHRoZQpmaXJzdCBsaW5l
IG9mIGV2ZXJ5IGZpbGUuIEkgb25seSBmb3VuZCB0aGUgcmVjb21tZW5kYXRpb24gdG8KcHV0IGl0
ICJuZWFyIHRoZSB0b3AiLiBBbnl3YXksCgpSZXZpZXdlZC1ieTogTWFydGluIFdpbGNrIDxtd2ls
Y2tAc3VzZS5jb20+CgpbIEkgdGhvdWdodCBJJ2Qgc2VudCBhIHJlc3BvbnNlIHRvIHRoaXMgcGF0
Y2ggYWxyZWFkeSwgYnV0IEkgY2FuJ3QgZmluZAppdCBhbnkgbW9yZS4gU29ycnkgaWYgeW91IGdl
dCB0aGlzIG11bHRpcGxlIHRpbWVzLiBdCg==

