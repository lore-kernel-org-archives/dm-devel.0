Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794686367;
	b=p3kC0ikrgG8YacUga/ScVdXMtgkuQ7tUkwQHzeOrILHD4GUBIWJe/MMNRv+vaZoX8AJD
	 sTEp2U+UuSMD1j0/xN4Vq2RipRiBD8G/sDByM5nTzbxBJkds4hTmCod8Lz62CuWlCQET5
	 tdrgN6o2IUAePuB2mFwHNggUrXzYM7tGwgFKcjCYttqyTcVW8XWZOuS/fvPlWxXyydapE
	 TeAxcsLnRinSbjzZaxgjxxfIqKR/Rz+Xb0AYmQ7hNUmWRUnI7hn5GBrT04Uf8sP0ci+LN
	 cq5OOcfzPZs7o8H5s8L3bqR0X3ogMQ7UJKTKhH3oVOer7S87KCOvhHxcMHIy9yDNuXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794686367;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:User-Agent:MIME-Version:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type:
	 Content-Transfer-Encoding;
	bh=FNHcsFInRg6O/+cM6rrKb1TT4rbjRwnXWB+glwR9lSk=;
	b=tfKCjWlrNHskFzUzQUaZmII6T3taehO8dMNFluJzAt15pllXxR478DVDY6nh3tZcLcBb
	 SDIMxuBJH/eqQRxkggCJRCklZR+zb7jdiNBRvJcwoCJB3zom2SlyVYc7Vw36GTX3jCcZ8
	 Ica5cZXR/9qtrATZtETZPr0RQfN5m3PCqqjH84e+oUujtA/1V8vE33O1H3KTg0aEyhHPr
	 v1UMrUrOhdw9CbZua8unqChyyuTy/Ema+IOVVoPe4NoQwZg5ud3u7bL+dL72Mesn2q/QT
	 1rypb6+I3CD/ew9yMakMz9qWzl6m1UBCOBUXMuhw51qZ9guBZg8P9BvRe5Brmw3dsLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hCl1aTcE;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1A3606A323
	for <dm-devel@lists.linux.dev>; Sat, 14 Nov 2026 19:59:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F1A3606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hCl1aTcE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794686366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FNHcsFInRg6O/+cM6rrKb1TT4rbjRwnXWB+glwR9lSk=;
	b=hCl1aTcEa2wN9A30/SYv5Yr/SmFZoZJO+2VLtO3QvoHFSAl6qowczOiE+mV4vikUCO5o2I
	1QqauKS36ZB0TG9hv/S1Bfq5mF0pCJlii16XC9uoynCedUYUd6YFfBvp6JFrgJUAJxA8mg
	qM4LSP9qcNy9zwzmJyAXu0Bq5alvRhs=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-LYZDBD2XMWax6dcerzB72A-1; Sat, 14 Nov 2026 14:59:22 -0500
X-MC-Unique: LYZDBD2XMWax6dcerzB72A-1
X-Mimecast-MFC-AGG-ID: LYZDBD2XMWax6dcerzB72A_1794686362
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-55c16eb248eso22004741cf.2
        for <dm-devel@lists.linux.dev>; Sat, 14 Nov 2026 11:59:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686362; x=1795291162;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uFXNoy6gP0yH6T4s0vbljgaUMgktLJ38QS3jqGJ3hsM=;
        b=BKqK0q9F13Aw/jh91mJkNFQwyY3LbZGJxpTTS2cNI+wkCo8+QMapV1TWswFo9VQ2kB
         oht2gTFGflTa8fTTiudBoAiWC5/xZNJutCWswZH8hPm80CzYBU0TDyq94l9WouUzImEr
         a4OMZiCYT9gE/FgtGFc3ZC2HNghtNkrIoh4RrZrrYbhjeA9UY4OcK4xj6Mo5qVKlfHh7
         bmRYsb/rqc4HGG+H2oGPrzW/ILEgdH8EoBlqYybaepMaK060z8/hK0L/3VTBei0oDugA
         RZolwEzTMaRpQ1lLJTeCJ0Lm4cuVBROphkALXHYk9uHJsyLA7KKSGAuFMY0NfRbjixNC
         KEcQ==
X-Forwarded-Encrypted: i=1; AL+hErERcG/yxOWfmdQ3NgyLoLeh0URgr2zVYH7KtW8hzAVteiRJ6jw1eDjgm9uMXmeX06N7sIVMO+m55g==@lists.linux.dev
X-Gm-Message-State: APuU4Z9MtPLmrtCIw5kQzu1Em7BGiTnn4dh+91QpBOkOrCv1msf85PT1
	Gh1GMlex5emJPq3f3WdL/55EyzabaB7KqXot5gkwTmggipGauxf5lPl1wXJukKxm9W6zMBEH+cY
	STKBjpxcCWod4rUIRGe/mV6qv3LX/WYwUrN9ma0Z1H+YSv7oungo/myz5wCFs
X-Gm-Gg: AYBFou3tNT4w+2t9gohxGIgFcU43n97dPlgKYlMDUUQr1Zo14z2yHTURPFxAqQiPjUl
	f/PcRboDJgzlq3QLndI4Ifpjf4mLak8zN65chw17AWa4gkS9dxu9mF0Bm3rq1KXt+vCxmThVfrS
	3G+2bFnuv1Xsdlx9qG/BDpHEfPis4amACbfposvDsxRQTr0jNA8soX+/a9di5DE8h1gZrPBVyQQ
	/45zzzf6pdLiNKDB8NAKNobq5q+zHCyKOZRwame1w2OulbjBkCwjIdVUlTit6CSKe1Kb7QZCp20
	Ca2PqbLLN/NUog7z0seiO48MxvlygsUjpeHXvfgtS47NQ0qcRQzEpYWBT7zjcP5bkcIb00CyzMU
	BKMTxsPpRAIw/WeoB3j9r48cbBVY8Dnr+QazD4AKsPEKVyHoKWLHD8J34/vyh0+CyCwmTHu3Qo2
	JlDWWmOZscH4yBuQcAxp3/vsiycozz0Rj+dyQxlxoQNwtrqhIKVhUOpeAWNH6WMvd4AHHL8A==
X-Received: by 2002:a05:622a:598e:b0:55c:f671:99be with SMTP id d75a77b69052e-55cf6719b5bmr26849041cf.47.1794686361901;
        Sat, 14 Nov 2026 11:59:21 -0800 (PST)
X-Received: by 2002:a05:622a:598e:b0:55c:f671:99be with SMTP id d75a77b69052e-55cf6719b5bmr26848801cf.47.1794686361370;
        Sat, 14 Nov 2026 11:59:21 -0800 (PST)
Received: from loberman-thinkpadp1gen5.rmtusma.csb ([2600:6c65:2440:d8c:929c:b769:6def:faa3])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55ad043f2f7sm46189161cf.5.2026.11.14.11.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 11:59:20 -0800 (PST)
Message-ID: <74d88ab7faf32dbcfd22e508defa695c217c0a67.camel@redhat.com>
Subject: Re: [PATCH v9 00/29] Native SCSI Multipath support
From: Laurence Oberman <loberman@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, John Garry
	 <john.garry@linux.dev>
Cc: hare@suse.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, 	snitzer@kernel.org, jmeneghi@redhat.com,
 dm-devel@lists.linux.dev, hch@lst.de, 	michael.christie@oracle.com, "James
 E.J. Bottomley"	 <James.Bottomley@HansenPartnership.com>, mkp@kernel.org,
 Benjamin Marzinski	 <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>
Date: Sat, 14 Nov 2026 14:59:19 -0500
In-Reply-To: <72c69ee88f292a008173bb84a7335330d3415b71.camel@redhat.com>
References: <20261108204733.557995-1-john.garry@linux.dev>
		 <9b90edc29d5b3be49f5bd0e0ecec5f1701e089bf.camel@redhat.com>
		 <3332329d-b922-45a4-8333-e8353e983885@linux.dev>
		 <00e03246-95dc-46dd-a2f9-89ad88f177d1@gmail.com>
	 <72c69ee88f292a008173bb84a7335330d3415b71.camel@redhat.com>
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
X-Mimecast-MFC-PROC-ID: Xk54HDnoMTU45u5qofnNyBg7Lsns_MDo0fwamrHz-Qc_1794686362
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64

T24gU2F0LCAyMDI2LTExLTE0IGF0IDExOjI5IC0wNTAwLCBMYXVyZW5jZSBPYmVybWFuIHdyb3Rl
Ogo+IE9uIFNhdCwgMjAyNi0xMS0xNCBhdCAxNDowMyArMDEwMCwgWG9zZSBWYXpxdWV6IFBlcmV6
IHdyb3RlOgo+ID4gT24gMTEvMTAvMjYgMTA6MDUgQU0sIEpvaG4gR2Fycnkgd3JvdGU6Cj4gPiAK
PiA+ID4gT24gMTEvOS8yNiAyMDoxOSwgTGF1cmVuY2UgT2Jlcm1hbiB3cm90ZToKPiA+ID4gPiAz
LiBTbWFsbGVyIHBvaW50cwo+ID4gPiA+IAo+ID4gPiA+IC0gbnVtYSB3aXRoIGVxdWFsIE5VTUEg
ZGlzdGFuY2UgdXNlcyBvbmUgcGF0aCBwZXIgTFVOLCBzbyB3aXRoCj4gPiA+ID4gdHdvIEFPCj4g
PiA+ID4gwqDCoCBwYXRocyB0aHJvdWdoIHR3byBIQkFzLCBoYWxmIHRoZSBvcHRpbWl6ZWQgYmFu
ZHdpZHRoIGlzIGlkbGUKPiA+ID4gPiAoc2RsOjIKPiA+ID4gPiDCoMKgIGFib3ZlIHVuZGVyIG51
bWEpLiBUaGF0IG1hdGNoZXMgTlZNZSwgYnV0IHVzZXJzIGNvbWluZyBmcm9tCj4gPiA+ID4gwqDC
oCBkbS1tdWx0aXBhdGggc2VydmljZS10aW1lIHdpbGwgbm90aWNlLiBXb3VsZCByb3VuZC1yb2Jp
biBvcgo+ID4gPiA+IMKgwqAgcXVldWUtZGVwdGggYmUgYSBiZXR0ZXIgZGVmYXVsdCBmb3IgU0NT
ST8KPiA+ID4gCj4gPiA+IE1heWJlLCBidXQgcm91bmQtcm9iaW4gbWF5IG5vdCBiZSBhbHdheXMg
aWRlYWwgY29uc2lkZXJpbmcgb25seSBhCj4gPiA+IGJpbyBtb2RlIG9mIG9wZXJhdGlvbiBpcyBz
dXBwb3J0ZWQgYW5kIG5vIG1lcmdpbmcgbGlrZSBkbS1tcGF0aAo+ID4gPiBSUQo+ID4gPiBtb2Rl
Lgo+ID4gCj4gPiBpb3BvbGljeSBjYW4gZWFzaWx5IGJlIGN1c3RvbWl6ZWQgcGVyIGFycmF5L2Rl
dmljZSB2aWEgdWRldiBydWxlcy4KPiA+IEp1c3QgbGlrZSBpdCdzIGRvbmUgZm9yIE5WTWU6Cj4g
PiBodHRwczovL2dpdGh1Yi5jb20vbGludXgtbnZtZS9udm1lLWNsaS9ibG9iL21hc3Rlci9udm1m
LWF1dG9jb25uZWN0L3VkZXYtcnVsZXMvNzEtbnZtZi1ocGUucnVsZXMuaW4KPiA+IAo+ID4gQWRk
aXRpb25hbGx5LCAic2VydmljZS10aW1lIiBhbmQgImxhdGVuY3kiIEkvTyBwb2xpY2llcyBhcmUK
PiA+IGN1cnJlbnRseQo+ID4gdW5kZXIKPiA+IGRldmVsb3BtZW50Ogo+ID4gaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvbGludXgtbnZtZS8yMDI2MTAyNjExMTAxOS4zNzI0NDY1LTEta2FuaWVAbGlu
dXguYWxpYmFiYS5jb20vVC8KPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LW52bWUv
MjAyNjA4MTUxNzM1MDIuMTE4NTkyOS0xLW5pbGF5QGxpbnV4LmlibS5jb20vVC8KPiA+IAo+ID4g
PiA+IC0gVGhlcmUgaXMgbm8gdXNlcnNwYWNlIHRvb2wgeWV0IHRvIHNob3cgaGVhZHMsIHBhdGhz
IGFuZCBBTFVBCj4gPiA+ID4gc3RhdGUKPiA+ID4gPiDCoMKgICh0aGUgZXF1aXZhbGVudCBvZiBt
dWx0aXBhdGggLWxsIG9yIG52bWUgbGlzdC1zdWJzeXMpLiBJCj4gPiA+ID4gdXNlZAo+ID4gPiA+
IGEKPiA+ID4gPiDCoMKgIHNtYWxsIHN5c2ZzIHNjcmlwdCBmb3IgdGhpcyB0ZXN0aW5nLiBCZW4s
IGlzIG5hdGl2ZSBTQ1NJCj4gPiA+ID4gbXVsdGlwYXRoCj4gPiA+ID4gwqDCoCBzdXBwb3J0IGlu
IG11bHRpcGF0aC10b29scyBwbGFubmVkPwo+ID4gPiAKPiA+ID4gV2VsbCwgdGhlIHdob2xlIHBv
aW50IGlzIHRoYXQgd2UgZG9uJ3QgbmVlZCB1c2Vyc3BhY2UgdG9vbHMuCj4gPiA+IEhvd2V2ZXIs
IEkgYXBwcmVjaWF0ZSB0aGF0IHRoZXJlIGlzIG5vIGdlbmVyYWwgU0NTSSB0b29saW5nIHdoaWNo
Cj4gPiA+IGNvdWxkIGhlbHAgaGVyZS4gSSBrbm93IHRoYXQgSGltYW5zaHUgTSBkaWQgd29yayBv
biBhIFNDU0kKPiA+ID4gdmVyc2lvbgo+ID4gPiBvZiAKPiA+ID4gbnZtZS1jbGkgdG9vbCBwcmV2
aW91c2x5LiBNYXJ0aW4gbWF5IGtub3cgdGhlIHN0YXR1cyBvZiB0aGF0Lgo+ID4gCj4gPiBBZ3Jl
ZWQgdGhhdCB1c2Vyc3BhY2UgdG9vbHMgYXJlIG5vdCBzdHJpY3RseSBuZWVkZWQgZm9yCj4gPiBj
b25maWd1cmF0aW9uLCBidXQKPiA+IG9ic2VydmFiaWxpdHkgaXMga2V5Lgo+ID4gQSBzdGFuZGFy
ZCB1dGlsaXR5IHRvIHZpc3VhbGl6ZSB0aGUgZGV2aWNlIHRvcG9sb2d5LCBwYXRoIGhlYWx0aAo+
ID4gYW5kCj4gPiBBTFVBCj4gPiBzdGF0ZXMgYXQgYSBnbGFuY2UsIHNpbWlsYXIgdG8gd2hhdCBt
dWx0aXBhdGgtdG9vbHMgcHJvdmlkZXMsIHdvdWxkCj4gPiBzYXZlIGEKPiA+IGxvdCBvZiBmcmlj
dGlvbiBmb3Igc3lzYWRtaW5zIG1pZ3JhdGluZyBhd2F5IGZyb20gZG0tbXVsdGlwYXRoLgo+ID4g
UmVseWluZyBzb2xlbHkgb24gYWQtaG9jIHNjcmlwdHMgb3IgbWFudWFsIHN5c2ZzIHBhcnNpbmcg
Y2FuIGJlY29tZQo+ID4gcXVpdGUKPiA+IHRlZGlvdXMgaW4gcHJvZHVjdGlvbiBlbnZpcm9ubWVu
dHMuCj4gSGVsbG8gWG9zZQo+IAo+IEkgaGF2ZSBhIHdvcmtpbmcgcnVzdCBiYXNlZCB1c2Vyc3Bh
Y2UgdG9vbCBmb3IgdGhpcy4gSXQgc3RhcnRlZCBhcyBhCj4gcGF0aCBhbmQgSU9QUyBtb25pdG9y
IGFuZCB3b3JrcyB3ZWxsLiBJIGFtIGNsZWFuaW5nIGl0IHVwIHRoaXMKPiB3ZWVrZW5kCj4gYW5k
IHdpbGwgc2hhcmUgYSByZXBvIG5leHQgd2Vlay4KPiAKPiBUaGUgZW1haWwgY2xpZW50IHdyYXBz
IHRoZSBsaW5lcywgbG9va3MgYmV0dGVyIG9uIHRoZSB3aWRlciBzY3JlZW4KPiAKPiAKPiA9PT0g
TlZNZSBQZXItUGF0aCBNb25pdG9yID09PQo+IAo+IG52bWUtc3Vic3lzMMKgwqDCoMKgIE5RTjog
bG9iZQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlvcG9saWN5OiBudW1hCj4g
Cj4gU2FtcGxlIGludGVydmFsOiAxcyB8IGxhdGVuY3k6IGF2ZXJhZ2UgcGVyIGNvbXBsZXRlZCBJ
L08gaW4gdGhpcwo+IGludGVydmFsCj4gCj4gUEFUSMKgwqDCoMKgwqDCoMKgwqDCoMKgIENUUkzC
oMKgwqDCoMKgwqAgQU5BIFNUQVRFwqDCoMKgwqDCoCBUUkFOU1BPUlTCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIFIKPiBJT1BTwqDCoCBXIElPUFPCoCBSIEFWRyBMQVTCoCBXIEFW
RyBMQVTCoMKgwqDCoMKgIFJFQUQgQlfCoMKgwqDCoCBXUklURSBCVwo+IOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgAo+IOKUgOKUgAo+IAo+IOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgAo+IG52bWUwYzFu
McKgwqDCoMKgwqAgbnZtZTHCoMKgwqDCoMKgIG9wdGltaXplZMKgwqDCoMKgwqAgcmRtYToxOTIu
MTY4LjIuMjU0OjQ0MjDCoMKgwqAgCj4gNTkuNUvCoMKgwqAgNTkuNkvCoMKgwqAgMTcuODJtc8Kg
wqDCoCAxNS43Nm1zwqDCoCAyMzIuMyBNQi9zwqDCoCAyMzIuOCBNQi9zCj4gbnZtZTBjMm4xwqDC
oMKgwqDCoCBudm1lMsKgwqDCoMKgwqAgb3B0aW1pemVkwqDCoMKgwqDCoCByZG1hOjE5Mi4xNjgu
MS4yNTQ6NDQyMMKgwqDCoMKgwqAKPiAwwqDCoMKgwqDCoMKgwqAgMMKgwqDCoMKgwqDCoMKgwqDC
oCAtwqDCoMKgwqDCoMKgwqDCoMKgIC3CoMKgwqDCoMKgwqDCoCAwIEIvc8KgwqDCoMKgwqDCoMKg
IDAgQi9zCj4gCj4gQ2hhbmdlIHRvIHJvdW5kLXJvYmluCj4gCj4gPT09IE5WTWUgUGVyLVBhdGgg
TW9uaXRvciA9PT0KPiAKPiBudm1lLXN1YnN5czDCoMKgwqDCoCBOUU46IGxvYmUKPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpb3BvbGljeTogcm91bmQtcm9iaW4KPiAKPiBTYW1w
bGUgaW50ZXJ2YWw6IDFzIHwgbGF0ZW5jeTogYXZlcmFnZSBwZXIgY29tcGxldGVkIEkvTyBpbiB0
aGlzCj4gaW50ZXJ2YWwKPiAKPiBQQVRIwqDCoMKgwqDCoMKgwqDCoMKgwqAgQ1RSTMKgwqDCoMKg
wqDCoCBBTkEgU1RBVEXCoMKgwqDCoMKgIFRSQU5TUE9SVMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgUgo+IElPUFPCoMKgIFcgSU9QU8KgIFIgQVZHIExBVMKgIFcgQVZHIExBVMKg
wqDCoMKgwqAgUkVBRCBCV8KgwqDCoMKgIFdSSVRFIEJXCj4g4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSACj4g4pSA4pSACj4gCj4g4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSACj4gbnZtZTBjMW4xwqDCoMKg
wqDCoCBudm1lMcKgwqDCoMKgwqAgb3B0aW1pemVkwqDCoMKgwqDCoCByZG1hOjE5Mi4xNjguMi4y
NTQ6NDQyMMKgwqDCoCAKPiAxNS4yS8KgwqDCoCAxNS4yS8KgwqDCoCAxMy41Mm1zwqDCoMKgIDEx
LjA0bXPCoMKgIDExOC44IE1CL3PCoMKgIDExOC42IE1CL3MKPiBudm1lMGMybjHCoMKgwqDCoMKg
IG52bWUywqDCoMKgwqDCoCBvcHRpbWl6ZWTCoMKgwqDCoMKgIHJkbWE6MTkyLjE2OC4xLjI1NDo0
NDIwwqDCoMKgIAo+IDE0LjlLwqDCoMKgIDE1LjVLwqDCoMKgIDU0LjIybXPCoMKgwqAgNjMuMjNt
c8KgwqAgMTE2LjYgTUIvc8KgwqAgMTIxLjEgTUIvcwo+IAo+IFRoYW5rcwo+IExhdXJlbmNlCgpT
ZWUgdGhlIFJFQURNRS5tZCwgbmVlZHMgY2FyZ28vcnVzdCB0byBidWlsZCBpdC4KCmdpdCBjbG9u
ZSBodHRwczovL2dpdGh1Yi5jb20vbG9iZXJtYW4vbnZtZS1zY3NpLXBhdGgtaW9wcy5naXQKY2Qg
bnZtZS1zY3NpLXBhdGgtaW9wcwpjYXJnbyBidWlsZCAtLXJlbGVhc2UKQmluYXJ5IHdpbGwgYmUg
aW4gdGFyZ2V0L3JlbGVhc2UvbnZtZS1wYXRoLWlvcHMKClRoaXMgaXMgd29ya2luZyB3ZWxsIGZv
ciBtZSB3aXRoIG5hdGl2ZSBudm1lIG11bHRpcGF0aCBhbmQgbmF0aXZlIHNjc2kKbXVsdGlwYXRo
LgoKTGV0IG1lIGtub3cgaWYgeW91IGxpa2UgaXQuCgpodHRwczovL2dpdGh1Yi5jb20vbG9iZXJt
YW4vbnZtZS1zY3NpLXBhdGgtaW9wcy5naXQKDQo=

