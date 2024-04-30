Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C585F3AC34
	for <dm-devel@lists.linux.dev>; Tue, 30 Apr 2024 07:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714463056; cv=none; b=PWX2fM5wkKX618HBtI07rYb45QD1Lf1BZorGg4OwLNYvKz1OdpfJ5d6GYxrrcNRpLUYDVpHqqXEUe9e+p+YJcLAMTnWNyRs4Za3upgsPIix4l5p6yH6sEQBQspElbxucM7kr5tYPfA+GD3lUvo/wCQW5nShMKFMRnaPVCsPUSbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714463056; c=relaxed/simple;
	bh=qcluHqnuRKTnayLViAB3OeWV4JBmfGQiKxBsne1Sw3g=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b1gx9X1BrP1JNrUGBra9vGILS0/pOCdyLvo9xx7k7np9HR4/TfoBDaxPWTl+TvvgJRfwfRK5gMNtDHvbGaFu96huBR9cjGLb6WAKh17XSM3PbFXBg52CAywN29pp7FsLkj9y9UbnEX2/MnkaeV7h6veMifQ2NCdgnViMpGSZGSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Kg2LsENA; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Kg2LsENA; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Kg2LsENA";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Kg2LsENA"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B30F033E82;
	Tue, 30 Apr 2024 07:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1714463051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qcluHqnuRKTnayLViAB3OeWV4JBmfGQiKxBsne1Sw3g=;
	b=Kg2LsENAA7NjrGuqVw7C9MQX+wzXtltesmVKbFv5s9Hi+S3GQbZdRWFitfw2lIgfelskER
	tM9tgGowQupsFQg0gnOg5zf1WxPm378CcnemaQbe/eMXEwqY7ombtJSp7BCsbwXAYz0D1g
	yIM4qW55EV1Dq83SqTb8kmqTP//BgNg=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1714463051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qcluHqnuRKTnayLViAB3OeWV4JBmfGQiKxBsne1Sw3g=;
	b=Kg2LsENAA7NjrGuqVw7C9MQX+wzXtltesmVKbFv5s9Hi+S3GQbZdRWFitfw2lIgfelskER
	tM9tgGowQupsFQg0gnOg5zf1WxPm378CcnemaQbe/eMXEwqY7ombtJSp7BCsbwXAYz0D1g
	yIM4qW55EV1Dq83SqTb8kmqTP//BgNg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 871DB133A7;
	Tue, 30 Apr 2024 07:44:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /PlsH0uhMGYGOQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 30 Apr 2024 07:44:11 +0000
Message-ID: <8d5c53cfad824ea0cc04774c0ca521ad3d487004.camel@suse.com>
Subject: Re: [PATCH 0/3] multipath-tools: docs housekeeping
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Tue, 30 Apr 2024 09:44:10 +0200
In-Reply-To: <20240427235009.8751-1-xose.vazquez@gmail.com>
References: <20240427235009.8751-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Score: -1.97
X-Spam-Level: 
X-Spamd-Result: default: False [-1.97 / 50.00];
	BAYES_HAM(-2.27)[96.57%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]

T24gU3VuLCAyMDI0LTA0LTI4IGF0IDAxOjUwICswMjAwLCBYb3NlIFZhenF1ZXogUGVyZXogd3Jv
dGU6Cj4gWG9zZSBWYXpxdWV6IFBlcmV6ICgzKToKPiDCoCBtdWx0aXBhdGgtdG9vbHM6IHNpbXBs
aWZ5IGNvbW1lbnQgaW4gaHd0YWJsZQo+IMKgIG11bHRpcGF0aC10b29sczogdW5pZnkgdGV4dCBp
biBtdWx0aXBhdGguY29uZi41Cj4gwqAgbXVsdGlwYXRoLXRvb2xzOiB1cGRhdGUgbWFuIHBhZ2Vz
IGRhdGVzCj4gCj4gwqBsaWJtcGF0aHBlcnNpc3QvbXBhdGhfcGVyc2lzdGVudF9yZXNlcnZlX2lu
LjPCoCB8wqAgMiArLQo+IMKgbGlibXBhdGhwZXJzaXN0L21wYXRoX3BlcnNpc3RlbnRfcmVzZXJ2
ZV9vdXQuMyB8wqAgMiArLQo+IMKgbGlibXVsdGlwYXRoL2h3dGFibGUuY8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgNCArKy0tCj4gwqBtdWx0aXBh
dGgvbXVsdGlwYXRoLjguaW7CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCB8wqAgMiArLQo+IMKgbXVsdGlwYXRoL211bHRpcGF0aC5jb25mLjUuaW7CoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMTQgKysrKysrKy0tLS0tLS0KPiDCoG11bHRpcGF0
aGQvbXVsdGlwYXRoZC44LmluwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCB8wqAgMiArLQo+IMKgNiBmaWxlcyBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspLCAxMyBkZWxl
dGlvbnMoLSkKPiAKPiBDYzogTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+Cj4gQ2M6IEJl
bmphbWluIE1hcnppbnNraSA8Ym1hcnppbnNAcmVkaGF0LmNvbT4KPiBDYzogQ2hyaXN0b3BoZSBW
YXJvcXVpIDxjaHJpc3RvcGhlLnZhcm9xdWlAb3BlbnN2Yy5jb20+Cj4gQ2M6IERNLURFVkVMIE1M
IDxkbS1kZXZlbEBsaXN0cy5saW51eC5kZXY+Cj4gU2lnbmVkLW9mZi1ieTogWG9zZSBWYXpxdWV6
IFBlcmV6IDx4b3NlLnZhenF1ZXpAZ21haWwuY29tPgoKRm9yIHRoZSBzZXJpZXM6ClJldmlld2Vk
LWJ5OiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4KCg==

