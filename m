Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BC317C9E
	for <dm-devel@lists.linux.dev>; Mon,  8 Dec 2025 14:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765205298; cv=none; b=jH/woG9DrIEmkrg3yhDp4+xc5fTVAVWtca9CgfKaaPbVGufbSCSs21wpZsZJHRMODWQwj+VTBrr+G4dKPdyD2SbPg4qievXZJB3jHVf8NkT2BE0RQK5gZ76mMYdZ0/6Y8PQVjOIpsF6x+uT8igIb6ci0nc3Wu2xCZtx9tbc2BoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765205298; c=relaxed/simple;
	bh=1ZXzV8bIzCOjJ2HpUVee80SkQHtt/CPc9R7iYfZDYIw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HL04AmWEP3u4left2FYIiJEZwBTeI7FFkoJ84G34YG+dL2GCNJ9qC2/xtLgoqj09qHmnPvFVHUyl3w/JlEzRSaFIkCS0AQnptVIXPxTLfVAV+etEfloepsTaQ+JGBPMFJDuffgFtiZzLCRWn3oBe2mZbzjcVkyv12p/DnJ1JM9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ROTz/n4X; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ROTz/n4X"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42e2e671521so2951741f8f.1
        for <dm-devel@lists.linux.dev>; Mon, 08 Dec 2025 06:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765205294; x=1765810094; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1ZXzV8bIzCOjJ2HpUVee80SkQHtt/CPc9R7iYfZDYIw=;
        b=ROTz/n4XvepvWHBgy7mpD2SmmcQqQ1Y8QFQnP+b64cGsdR9Gbh2OdEooX3LtvL+As4
         Uie+6wlIefRyltvCLAgG9g/a3YG6/pk67dvnBQAz79OfS5nEvTwkWy+O+tX/rKyqpd06
         CivKZj6Wgo40CdBrjocc3kVd47hWgQWLn7BHmfwehpRcjTrSZY2leGKan+rQvlAL+KAy
         QVnzhanCsc49uzBhiZjUmkZtbUeR98CEpMg43o3oEYzZqYNG3RM/jmkCjveiXcWsvWpQ
         x05sAnDnKGNb5VOIUdsLvN9mu47DbhWT/fmqNmz3fHsrL2I2LBt0Ep3G+4vudH5NpPHH
         LKbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765205294; x=1765810094;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ZXzV8bIzCOjJ2HpUVee80SkQHtt/CPc9R7iYfZDYIw=;
        b=XN32WaAV3XMZwgNCcIG73s3PJHcDqogu3pV1UNC3uuojS6oBcEPG8kx18l9i66tLVg
         6eJqLxkFtOHQKhW1By0/LGKqx9fGRIwea+n7EN3oLMdvuy1tsymu79zJVa1crHz1VcYK
         o1JvXKLCTfZGwG4rElFpXN1cjxnktW7dTuQ0nvUqnTIwA9koYOGH0yPOOL9TKYq/VLDK
         dD3ue7gXwNk2C0Lw1svQr1rycFhbuue+X1/D8O+pGr4bblAU0DrFfoaODTrEU9ChFyq9
         KK5e63RanNCeY80e9tY3Vcsq2l3GL/sYE/16Y9DTRqDz3SBhPDiBX4pRp2QAutuI9NNr
         WFQg==
X-Gm-Message-State: AOJu0YxlrMiqGE6/X8zo9PvCaOVHJibyZ2AkYZjyeOfh6R1iACeUy78q
	9y4LwzUdIKAymP4WSZaNm7tk+wREyr+SIPjokFMgxQ2Be5JgcBpIq2H3b8Pxg8KY8Wwau9MqJEB
	VYy/d
X-Gm-Gg: ASbGncuC/dD953p8PNFSyKIn+ODliA1OpTzuea73x2Fa3nXYvTP7IGSyo07yE3aMbfz
	osbt80z8qqPw4qdYBStao/zfzVuUFMJZ7xCEFJ6IyX+rNw9ToIk4F3jBPtqyzWe+b3IgYAdFmK/
	AkoYA0CWxK2eGGlDahno7K3zhl0Xv33H3sL8k9G98MYMFaOoklkwS8/cAd+BaqKk4kSlSYtCEA5
	+mkyR631Q0yfv6/Ua6CxJ6pb/0OgAlZS1MBC/MnJBI5hvoK3sRUgA68S9jaOaqCyLZ2OsxNdQOk
	hhAevcMTuFjNhlVIMgtwiJbfaHgGT0drp//Ky/zvTo9Udkw78JlUuapJQ4Ezlniv4VvuTPk6yq+
	EH2LSBertaS90igDnAbltsDDdo/olNf85M+AazF9f3z7rWboJLtRnofDYRBQc1VI+xtW9eeKOcl
	gRkMOgtmpJ+Zi/E0gllPp3gPMvsevuueFZSAE7Wmgk94vUPbh9WqNbhPdWUd/g2oiHZEJJYu5Tc
	D4RDN9Q163iWKk0PsfwJILWgS0LyEzSLqNR2o0XR1/dHOQ=
X-Google-Smtp-Source: AGHT+IFsKsYzvWCtxN1yKAMiHRTojpvW/1tBSVBIipXSjfZqyY5uLMb2vCyL0CdWHTJbD4WmTwt93Q==
X-Received: by 2002:a05:6000:26ca:b0:42b:3963:d08d with SMTP id ffacd0b85a97d-42f89f0c7f9mr8256521f8f.21.1765205293742;
        Mon, 08 Dec 2025 06:48:13 -0800 (PST)
Received: from ?IPv6:2003:de:373a:d100:7c9:709f:eaee:b67f? (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfeadesm25585655f8f.10.2025.12.08.06.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Dec 2025 06:48:13 -0800 (PST)
Message-ID: <9519a9d057155f892fef2d7ac145aebbfc286e54.camel@suse.com>
Subject: Re: [PATCH 0/4] multipath-tools: Yet Another PR fix
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 08 Dec 2025 15:48:12 +0100
In-Reply-To: <20251202030213.1432964-1-bmarzins@redhat.com>
References: <20251202030213.1432964-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

T24gTW9uLCAyMDI1LTEyLTAxIGF0IDIyOjAyIC0wNTAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6Cj4gSSByYW4gaW50byBzb21lIGNhc2VzIHdoZXJlIGNoZWNraW5nIHRoZSBudW1iZXIgb2Yg
cmVnaXN0ZXJlZCBrZXlzCj4gbWFkZQo+IG11bHRpcGF0aGQgdGhpbmsgYWxsIHBhdGhzIGhhZCBi
ZWVuIHJlZ2lzdGVyZWQsIHdoZW4gdGhleSBoYWRuJ3QuIFRoZQo+IGxhc3QgdHdvIHBhdGNoZXMg
aW4gdGhpcyBwYXRjaHNldCByZXdvcmsgdGhhdCBjb2RlLiBUaGUgZmlyc3QgdHdvIGFyZQo+IGp1
c3QgZml4ZXMgdG8gb3RoZXIgaXNzdWVzIEkgaGFwcGVuZWQgdG8gbm90aWNlIHdoaWxlIHdvcmtp
bmcgb24gdGhpcwo+IGNvZGUuCj4gCj4gQmVuamFtaW4gTWFyemluc2tpICg0KToKPiDCoCBsaWJt
cGF0aHBlcnNpc3Q6IGZpeCByZWdpc3RlciByZXRyeSBzdGF0dXMgY2hlY2tpbmcKPiDCoCBtdWx0
aXBhdGgtdG9vbHMgbWFuIHBhZ2VzOiBmaXggbXVsdGlwYXRoZCBjb21tYW5kcyBrZXl3b3JkIG9y
ZGVyaW5nCj4gwqAgbXVsdGlwYXRoZDogcmVtZW1iZXIgbnVtYmVyIG9mIHJlZ2lzdGVyZWQga2V5
cyB3aGVuIGlvY3RsIGZhaWxzCj4gwqAgbGlibXBhdGhwZXJzaXN0OiBmaXggY29kZSBmb3Igc2tp
cHBpbmcgbXVsdGlwYXRoZCBwYXRoIHJlZ2lzdHJhdGlvbgo+IAo+IMKgbGlibXBhdGhwZXJzaXN0
L21wYXRoX3BlcnNpc3RfaW50LmMgfCAyMCArKysrLS0tLQo+IMKgbGlibXBhdGhwZXJzaXN0L21w
YXRoX3VwZGF0ZXByLmPCoMKgwqAgfCA0OCArKysrKysrKysrKysrKy0tLS0tCj4gwqBsaWJtcGF0
aHBlcnNpc3QvbXBhdGhwci5owqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDQgKy0KPiDCoG11bHRp
cGF0aGQvY2FsbGJhY2tzLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMSArCj4gwqBt
dWx0aXBhdGhkL2NsaS5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKg
IDEgKwo+IMKgbXVsdGlwYXRoZC9jbGkuaMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHzCoCAyICsKPiDCoG11bHRpcGF0aGQvY2xpX2hhbmRsZXJzLmPCoMKgwqDCoMKgwqDC
oMKgwqDCoCB8IDM5ICsrKysrKysrKysrKysrLS0KPiDCoG11bHRpcGF0aGQvbWFpbi5jwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgNzIgKysrKysrKysrKysrKysrKysrKy0t
LS0tLS0tCj4gLS0KPiDCoG11bHRpcGF0aGQvbWFpbi5owqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHzCoCAzICstCj4gwqBtdWx0aXBhdGhkL211bHRpcGF0aGQuOC5pbsKgwqDC
oMKgwqDCoMKgwqDCoCB8IDI0ICsrKysrKy0tLS0KPiDCoDEwIGZpbGVzIGNoYW5nZWQsIDE1NSBp
bnNlcnRpb25zKCspLCA1OSBkZWxldGlvbnMoLSkKCkZvciB0aGUgc2VyaWVzLCBleGNlcHQgNC80
OgpSZXZpZXdlZC1ieTogTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+Cg==

