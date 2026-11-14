Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794673789;
	b=vh1kLRi28LLKM6SyPwmr5S6H+OpvLUxsCdo+WwK4vItmcWYW1i7p3OjC7WPQsoMxMVWG
	 mQ3hpYXrbESBfQQN07SjvwC7Z7S1N7A1M9EWwmJZC++Qp9+0htVuICpuo4Z+x/iyFvcQD
	 /GWP1fOK/nGrX3Oo9JT8gJNM8vyO2Wk7SNPlNETaTo+Am9hL+lKsEh7yl4zobyPE2pJ+4
	 h7MKsWI/hCGGya4OVMdN84JEqAzuC/F93Pl/urFu1QzI2ZHXvJj4IuUe7R/CIrIxugAW5
	 pUarkFYY9eN4up0qlpi1M9WaV08bDFDuDc4rcdDiDiSgLIDwUoDRR36R6EXi8AtK15g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794673789;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:User-Agent:MIME-Version:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type:
	 Content-Transfer-Encoding;
	bh=NmV0onUi4RY5n3YpNLKOgp62iNPsVgUbXzR7nNG0hK4=;
	b=Pb7v2L6LoQ8rTvrexu+zQ8DSkA2w0ES4Uk10ZSJaSZ4p/pAxKKWzgafHBmRvxvtX8Ktm
	 RIek/2tPgnTYPfhnGNxTL/3S64hN5D8dkLuHNgyLwAoDjp/9pWimUxGoaLs+pGFZ1i+1L
	 MrzdoUv/aXKGhTTEEnwGhRe1DL0CrtnQNivwkDk+r/AQgKt3YJ5a3dfLzDtuZUSZxvjcj
	 h4eiEnnkQTmxVFZTc/Lge414ZZU2hkwsZ7RURJjQ8qCxB21QGlpR2T0bNE+PGEGGztMLo
	 KrAWVgJzILDIkIJqFcufWEG80J5nZQ4rBKkFcC+yTXsP/cfs5a5A68gwEKvXwMD1VQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hNDvVdzp;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACF1606A333
	for <dm-devel@lists.linux.dev>; Sat, 14 Nov 2026 16:29:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4ACF1606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hNDvVdzp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794673787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NmV0onUi4RY5n3YpNLKOgp62iNPsVgUbXzR7nNG0hK4=;
	b=hNDvVdzpg5YmhXhocldUVm8dUlX8UluAZ48tU14LPI6OF4zgo/OOElB8Em5HC1KARzBBoC
	Hm8BEW888cweLP9rHUKs2obBDCm/CHz01im3c5WnnmD0V0sKA9aMO5W0qIhFhe9uCA93HP
	kngJEWt5v2AmZXFhuWTm/TkEQiQbJ4g=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-o1n-U1s7P4G-Tc_tY2ta7Q-1; Sat, 14 Nov 2026 11:29:46 -0500
X-MC-Unique: o1n-U1s7P4G-Tc_tY2ta7Q-1
X-Mimecast-MFC-AGG-ID: o1n-U1s7P4G-Tc_tY2ta7Q_1794673785
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5364f562140so43474601cf.0
        for <dm-devel@lists.linux.dev>; Sat, 14 Nov 2026 08:29:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794673785; x=1795278585;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n2A4Bzesj8lSex24jcQa4eIw8NYUbc0vDdMOEEExUHk=;
        b=cdeUaqIurJQMJezFIAvbxAyp5/VVwcLa+00Frkf6VwESlSJda+fE/f5CDBWYpykJ46
         efHf7fIzec8JpNyLjFW8/evnEVb9+bzkWe5qZ0l7WiDLzNghtSwbHDZQYtF/cYQyXM3Y
         KHrA/3ec3WQw6GKtZAphkEeyPd7auJz6DtqSpttW2UM38ZjVkKL9PqFSjLYRktr0eWCO
         QmqUoa80n1vYSys5zsgIKBAkXtwMKW/kzvmltUChbOKm7pMMzlC/4iLgGSvkb2LbRLKo
         ZWNps/1IghsnHb4JN7+4/nVvy2gLRmJXSJdi4ukolZOk0+bq/Lxgyx5o05rY0ISN8ELl
         R4cg==
X-Forwarded-Encrypted: i=1; AL+hErEslZXFdiqGHi1yLYgHq/SzWekajA/69q5GcVxPNKtOI6nzsotm4zW4iORu8xHdXylPezd6bzfINA==@lists.linux.dev
X-Gm-Message-State: APuU4Z+tdLXYjpPeClMf0pbN8JwBEsFrIWGQon+A4v7V2jt+3BfW406v
	lUwpUu0enuaBPsKhhQFIuAu1nccY88wZaGXOgW631SVdWsINyXc1hRnuYBDCmdYD3ZmeRiU1LpC
	6hgvmtiGDjTA7LFamWbz1P2Sa3XbY4DQCqBmQEELxQzWuGJ16hKHYDEf1WbiF
X-Gm-Gg: AYBFou2KAYNFjudC6ZErXL5Ao2+SqdNidnqfGrTgEC9AClNuOzwsu/A1aeUw86yRTOs
	r0MBbt2VVwIRh5MGgBhrSzHBNY7iArIOVewjaClFLPSvlm23E5EEJIiipy28Jq38sDEUr22ZHBK
	fVmQUjGavALcYC28yGg3tjOIyN8+oXKhJq04zTKVXSEae7FtV3GxsSMmQkvQdE2kB454uz123hK
	3WwfvV/CTlL9YSIn4RvGQw2vGwUrGtesKfAD/w+tmxQ7LlDRE7VMf1IXU502fZ9zpcj0F1XIFNX
	N5gHUqqcLhjlJHenza9YPZ6n6nEXLDfRZQIonNAIcnPXb7GCu/ov0zrwcGTIvVrdKp4vGxrgM2O
	hc+SZibwnQ4+mbI64uRAulmvV4uzwkxoiirfjHByJ16k607h+ISpXWrAwWzfHkRqBdeOUoGy874
	kKAPKvHVhVEue5aYMho+3RC9xL+kipMkhjUtQfrS2JnlQNpS2nBRraHN9s26P907Q7QUptHQ==
X-Received: by 2002:ac8:5d4b:0:b0:533:95c1:fb11 with SMTP id d75a77b69052e-55956e5d97cmr146589481cf.28.1794673785384;
        Sat, 14 Nov 2026 08:29:45 -0800 (PST)
X-Received: by 2002:ac8:5d4b:0:b0:533:95c1:fb11 with SMTP id d75a77b69052e-55956e5d97cmr146589201cf.28.1794673784936;
        Sat, 14 Nov 2026 08:29:44 -0800 (PST)
Received: from loberman-thinkpadp1gen5.rmtusma.csb ([2600:6c65:2440:d8c:929c:b769:6def:faa3])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d453casm46039086d6.10.2026.11.14.08.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 08:29:44 -0800 (PST)
Message-ID: <72c69ee88f292a008173bb84a7335330d3415b71.camel@redhat.com>
Subject: Re: [PATCH v9 00/29] Native SCSI Multipath support
From: Laurence Oberman <loberman@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, John Garry
	 <john.garry@linux.dev>
Cc: hare@suse.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, 	snitzer@kernel.org, jmeneghi@redhat.com,
 dm-devel@lists.linux.dev, hch@lst.de, 	michael.christie@oracle.com, "James
 E.J. Bottomley"	 <James.Bottomley@HansenPartnership.com>, mkp@kernel.org,
 Benjamin Marzinski	 <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>
Date: Sat, 14 Nov 2026 11:29:43 -0500
In-Reply-To: <00e03246-95dc-46dd-a2f9-89ad88f177d1@gmail.com>
References: <20261108204733.557995-1-john.garry@linux.dev>
	 <9b90edc29d5b3be49f5bd0e0ecec5f1701e089bf.camel@redhat.com>
	 <3332329d-b922-45a4-8333-e8353e983885@linux.dev>
	 <00e03246-95dc-46dd-a2f9-89ad88f177d1@gmail.com>
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E1w0XvfJ84NWYHGoo04xpAn9Y_NJiwcInDkLKtlpbQ8_1794673785
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64

T24gU2F0LCAyMDI2LTExLTE0IGF0IDE0OjAzICswMTAwLCBYb3NlIFZhenF1ZXogUGVyZXogd3Jv
dGU6Cj4gT24gMTEvMTAvMjYgMTA6MDUgQU0sIEpvaG4gR2Fycnkgd3JvdGU6Cj4gCj4gPiBPbiAx
MS85LzI2IDIwOjE5LCBMYXVyZW5jZSBPYmVybWFuIHdyb3RlOgo+ID4gPiAzLiBTbWFsbGVyIHBv
aW50cwo+ID4gPiAKPiA+ID4gLSBudW1hIHdpdGggZXF1YWwgTlVNQSBkaXN0YW5jZSB1c2VzIG9u
ZSBwYXRoIHBlciBMVU4sIHNvIHdpdGgKPiA+ID4gdHdvIEFPCj4gPiA+IMKgwqAgcGF0aHMgdGhy
b3VnaCB0d28gSEJBcywgaGFsZiB0aGUgb3B0aW1pemVkIGJhbmR3aWR0aCBpcyBpZGxlCj4gPiA+
IChzZGw6Mgo+ID4gPiDCoMKgIGFib3ZlIHVuZGVyIG51bWEpLiBUaGF0IG1hdGNoZXMgTlZNZSwg
YnV0IHVzZXJzIGNvbWluZyBmcm9tCj4gPiA+IMKgwqAgZG0tbXVsdGlwYXRoIHNlcnZpY2UtdGlt
ZSB3aWxsIG5vdGljZS4gV291bGQgcm91bmQtcm9iaW4gb3IKPiA+ID4gwqDCoCBxdWV1ZS1kZXB0
aCBiZSBhIGJldHRlciBkZWZhdWx0IGZvciBTQ1NJPwo+ID4gCj4gPiBNYXliZSwgYnV0IHJvdW5k
LXJvYmluIG1heSBub3QgYmUgYWx3YXlzIGlkZWFsIGNvbnNpZGVyaW5nIG9ubHkgYQo+ID4gYmlv
IG1vZGUgb2Ygb3BlcmF0aW9uIGlzIHN1cHBvcnRlZCBhbmQgbm8gbWVyZ2luZyBsaWtlIGRtLW1w
YXRoIFJRCj4gPiBtb2RlLgo+IAo+IGlvcG9saWN5IGNhbiBlYXNpbHkgYmUgY3VzdG9taXplZCBw
ZXIgYXJyYXkvZGV2aWNlIHZpYSB1ZGV2IHJ1bGVzLgo+IEp1c3QgbGlrZSBpdCdzIGRvbmUgZm9y
IE5WTWU6Cj4gaHR0cHM6Ly9naXRodWIuY29tL2xpbnV4LW52bWUvbnZtZS1jbGkvYmxvYi9tYXN0
ZXIvbnZtZi1hdXRvY29ubmVjdC91ZGV2LXJ1bGVzLzcxLW52bWYtaHBlLnJ1bGVzLmluCj4gCj4g
QWRkaXRpb25hbGx5LCAic2VydmljZS10aW1lIiBhbmQgImxhdGVuY3kiIEkvTyBwb2xpY2llcyBh
cmUgY3VycmVudGx5Cj4gdW5kZXIKPiBkZXZlbG9wbWVudDoKPiBodHRwczovL2xvcmUua2VybmVs
Lm9yZy9saW51eC1udm1lLzIwMjYxMDI2MTExMDE5LjM3MjQ0NjUtMS1rYW5pZUBsaW51eC5hbGli
YWJhLmNvbS9ULwo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LW52bWUvMjAyNjA4MTUx
NzM1MDIuMTE4NTkyOS0xLW5pbGF5QGxpbnV4LmlibS5jb20vVC8KPiAKPiA+ID4gLSBUaGVyZSBp
cyBubyB1c2Vyc3BhY2UgdG9vbCB5ZXQgdG8gc2hvdyBoZWFkcywgcGF0aHMgYW5kIEFMVUEKPiA+
ID4gc3RhdGUKPiA+ID4gwqDCoCAodGhlIGVxdWl2YWxlbnQgb2YgbXVsdGlwYXRoIC1sbCBvciBu
dm1lIGxpc3Qtc3Vic3lzKS4gSSB1c2VkCj4gPiA+IGEKPiA+ID4gwqDCoCBzbWFsbCBzeXNmcyBz
Y3JpcHQgZm9yIHRoaXMgdGVzdGluZy4gQmVuLCBpcyBuYXRpdmUgU0NTSQo+ID4gPiBtdWx0aXBh
dGgKPiA+ID4gwqDCoCBzdXBwb3J0IGluIG11bHRpcGF0aC10b29scyBwbGFubmVkPwo+ID4gCj4g
PiBXZWxsLCB0aGUgd2hvbGUgcG9pbnQgaXMgdGhhdCB3ZSBkb24ndCBuZWVkIHVzZXJzcGFjZSB0
b29scy4KPiA+IEhvd2V2ZXIsIEkgYXBwcmVjaWF0ZSB0aGF0IHRoZXJlIGlzIG5vIGdlbmVyYWwg
U0NTSSB0b29saW5nIHdoaWNoCj4gPiBjb3VsZCBoZWxwIGhlcmUuIEkga25vdyB0aGF0IEhpbWFu
c2h1IE0gZGlkIHdvcmsgb24gYSBTQ1NJIHZlcnNpb24KPiA+IG9mIAo+ID4gbnZtZS1jbGkgdG9v
bCBwcmV2aW91c2x5LiBNYXJ0aW4gbWF5IGtub3cgdGhlIHN0YXR1cyBvZiB0aGF0Lgo+IAo+IEFn
cmVlZCB0aGF0IHVzZXJzcGFjZSB0b29scyBhcmUgbm90IHN0cmljdGx5IG5lZWRlZCBmb3IKPiBj
b25maWd1cmF0aW9uLCBidXQKPiBvYnNlcnZhYmlsaXR5IGlzIGtleS4KPiBBIHN0YW5kYXJkIHV0
aWxpdHkgdG8gdmlzdWFsaXplIHRoZSBkZXZpY2UgdG9wb2xvZ3ksIHBhdGggaGVhbHRoIGFuZAo+
IEFMVUEKPiBzdGF0ZXMgYXQgYSBnbGFuY2UsIHNpbWlsYXIgdG8gd2hhdCBtdWx0aXBhdGgtdG9v
bHMgcHJvdmlkZXMsIHdvdWxkCj4gc2F2ZSBhCj4gbG90IG9mIGZyaWN0aW9uIGZvciBzeXNhZG1p
bnMgbWlncmF0aW5nIGF3YXkgZnJvbSBkbS1tdWx0aXBhdGguCj4gUmVseWluZyBzb2xlbHkgb24g
YWQtaG9jIHNjcmlwdHMgb3IgbWFudWFsIHN5c2ZzIHBhcnNpbmcgY2FuIGJlY29tZQo+IHF1aXRl
Cj4gdGVkaW91cyBpbiBwcm9kdWN0aW9uIGVudmlyb25tZW50cy4KSGVsbG8gWG9zZQoKSSBoYXZl
IGEgd29ya2luZyBydXN0IGJhc2VkIHVzZXJzcGFjZSB0b29sIGZvciB0aGlzLiBJdCBzdGFydGVk
IGFzIGEKcGF0aCBhbmQgSU9QUyBtb25pdG9yIGFuZCB3b3JrcyB3ZWxsLiBJIGFtIGNsZWFuaW5n
IGl0IHVwIHRoaXMgd2Vla2VuZAphbmQgd2lsbCBzaGFyZSBhIHJlcG8gbmV4dCB3ZWVrLgoKVGhl
IGVtYWlsIGNsaWVudCB3cmFwcyB0aGUgbGluZXMsIGxvb2tzIGJldHRlciBvbiB0aGUgd2lkZXIg
c2NyZWVuCgoKPT09IE5WTWUgUGVyLVBhdGggTW9uaXRvciA9PT0KCm52bWUtc3Vic3lzMCAgICAg
TlFOOiBsb2JlCiAgICAgICAgICAgICAgICAgaW9wb2xpY3k6IG51bWEKClNhbXBsZSBpbnRlcnZh
bDogMXMgfCBsYXRlbmN5OiBhdmVyYWdlIHBlciBjb21wbGV0ZWQgSS9PIGluIHRoaXMKaW50ZXJ2
YWwKClBBVEggICAgICAgICAgIENUUkwgICAgICAgQU5BIFNUQVRFICAgICAgVFJBTlNQT1JUICAg
ICAgICAgICAgICAgICAgUgpJT1BTICAgVyBJT1BTICBSIEFWRyBMQVQgIFcgQVZHIExBVCAgICAg
IFJFQUQgQlcgICAgIFdSSVRFIEJXCuKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgAoK4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSACm52bWUwYzFuMSAgICAgIG52bWUxICAgICAgb3B0aW1pemVkICAg
ICAgcmRtYToxOTIuMTY4LjIuMjU0OjQ0MjAgICAgCjU5LjVLICAgIDU5LjZLICAgIDE3LjgybXMg
ICAgMTUuNzZtcyAgIDIzMi4zIE1CL3MgICAyMzIuOCBNQi9zCm52bWUwYzJuMSAgICAgIG52bWUy
ICAgICAgb3B0aW1pemVkICAgICAgcmRtYToxOTIuMTY4LjEuMjU0OjQ0MjAgICAgICAKMCAgICAg
ICAgMCAgICAgICAgICAtICAgICAgICAgIC0gICAgICAgIDAgQi9zICAgICAgICAwIEIvcwoKQ2hh
bmdlIHRvIHJvdW5kLXJvYmluCgo9PT0gTlZNZSBQZXItUGF0aCBNb25pdG9yID09PQoKbnZtZS1z
dWJzeXMwICAgICBOUU46IGxvYmUKICAgICAgICAgICAgICAgICBpb3BvbGljeTogcm91bmQtcm9i
aW4KClNhbXBsZSBpbnRlcnZhbDogMXMgfCBsYXRlbmN5OiBhdmVyYWdlIHBlciBjb21wbGV0ZWQg
SS9PIGluIHRoaXMKaW50ZXJ2YWwKClBBVEggICAgICAgICAgIENUUkwgICAgICAgQU5BIFNUQVRF
ICAgICAgVFJBTlNQT1JUICAgICAgICAgICAgICAgICAgUgpJT1BTICAgVyBJT1BTICBSIEFWRyBM
QVQgIFcgQVZHIExBVCAgICAgIFJFQUQgQlcgICAgIFdSSVRFIEJXCuKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgAoK4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSACm52bWUwYzFuMSAgICAgIG52bWUx
ICAgICAgb3B0aW1pemVkICAgICAgcmRtYToxOTIuMTY4LjIuMjU0OjQ0MjAgICAgCjE1LjJLICAg
IDE1LjJLICAgIDEzLjUybXMgICAgMTEuMDRtcyAgIDExOC44IE1CL3MgICAxMTguNiBNQi9zCm52
bWUwYzJuMSAgICAgIG52bWUyICAgICAgb3B0aW1pemVkICAgICAgcmRtYToxOTIuMTY4LjEuMjU0
OjQ0MjAgICAgCjE0LjlLICAgIDE1LjVLICAgIDU0LjIybXMgICAgNjMuMjNtcyAgIDExNi42IE1C
L3MgICAxMjEuMSBNQi9zCgpUaGFua3MKTGF1cmVuY2UKDQo=

