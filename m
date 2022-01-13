Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BFBBC4332F
	for <dm-devel@archiver.kernel.org>; Thu, 13 Jan 2022 11:01:48 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-W9uy7r-BMKuDMmDJzLkfSw-1; Thu, 13 Jan 2022 06:01:44 -0500
X-MC-Unique: W9uy7r-BMKuDMmDJzLkfSw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2042781EE60;
	Thu, 13 Jan 2022 11:01:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F1FF37A2EF;
	Thu, 13 Jan 2022 11:01:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B01BD1809CBA;
	Thu, 13 Jan 2022 11:01:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20DAwIo9001625 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 13 Jan 2022 05:58:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9F9AE200A39A; Thu, 13 Jan 2022 10:58:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 96B9F2028CE7
	for <dm-devel@redhat.com>; Thu, 13 Jan 2022 10:58:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9740F810B43
	for <dm-devel@redhat.com>; Thu, 13 Jan 2022 10:58:15 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1642071495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:mime-version:mime-version:content-type:content-type:
	dkim-signature; bh=/p7PB3kTdkpWPT//FrosgaPg9u+pHubpDqED6WfIQ1U=;
	b=Yj/2OVg4F7vDQH46pj/FAT2Ngg3SiCgsr5G8tBt1j+80XehAqwgbbBxsp0BDfTmg9AfdkI
	TmaVTEQTVM3yhD+A6sjlvYPsOzRrSyAA+dP1np0W2Db2+Sf7i4frtPiD/+bjjze0aeDgDu
	p4J1l0v0zjWAFMFxQgsboFZImAv0E3j7oJ3f8AHELg3OgR6YrfmSRA1ATqh4xZ828r54xA
	NEuG/IW6OD/Uthy8MdL649IlXdDWAAQAyNy9vP6F69EPE6UtqCxzUhWiEkiiDbXWjyvDti
	+7mKwtfEK07dG0DMlm37eq1iT6fHlY5Py/u3ZFK0Ac/xX8Xu7/sBJ9U3QYNt7Q==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1642071495; a=rsa-sha256;
	cv=none;
	b=biAvhDRYlJWFI+eq+qIngMwe6ZNVgu6q/2eZA5HCSy1mtLO6g4VuG9iwfzlsBJlbi2D0jA
	Co9YmW4+zQqot/iCfJXsz1kMfUGuC9gCAcJy/WvJlnsxD9PVOKVxD93KoaCYi1NCc5tDWP
	amXye2y5G1puVk6YDc/s725x9z7SYALQDvbUzAvJEA3GmfVphzux2PTYA5T2dnYSxmyWWv
	GKyz/7kgu35TgwgDgs9/bbbUSZbGUDSnCmKg7QnQoaMZ0A6wpuNu0ONvNkyZ3ww+zWHYi1
	WJ0q+iC6kvYOVF+e2vsC8PG5vPqn6/ZrG27TWshO0kn6yNeBGVTSr9DnJCibPg==
ARC-Authentication-Results: i=1; relay.mimecast.com;
	dkim=pass header.d=gmail.com header.s=20210112 header.b=Fw87OCDV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (relay.mimecast.com: domain of gmazyland@gmail.com designates
	209.85.208.47 as permitted sender)
	smtp.mailfrom=gmazyland@gmail.com
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com
	[209.85.208.47]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-549-Dwm65N23MU-FF9xI57boFg-1; Thu, 13 Jan 2022 05:58:13 -0500
X-MC-Unique: Dwm65N23MU-FF9xI57boFg-1
Received: by mail-ed1-f47.google.com with SMTP id c71so21576849edf.6
	for <dm-devel@redhat.com>; Thu, 13 Jan 2022 02:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
	h=message-id:date:mime-version:user-agent:from:subject
	:content-language:to;
	bh=13i87tMO13rhcve6tLJmbJeAi24UsOE6Ctym1lAxd1o=;
	b=Fw87OCDVtdl7JKBdzRqOScDi+Ej6JzTQ0j1RZVVqPDXoT+RjxpAu3bGxUfOx1SQkRo
	lX+JKqTUH04MlGhuy4tuCh9kxyZ5rP/yHOOIBtr+YlrAbT6o6UAH0aJMcs/RzOYwbU//
	ad9r0v6ZOpeHz4PDGvJlVHzDzNP85Cpzw4PmkwD4Geg2LdOhYI9XWvVcKICofmvUD145
	hDPoU94rcCoDBY/kiZJ/fTaI0fRyw58Cyr78SS6ZeWkmplmZD+IDegSLw2qv+x+KtnRB
	xh2P08sx5mpKntq6BjX8sSFQCWX9nSS5WDRneJpZl4Zs7qBinSatxL1OYELaYX/qBX9Z
	oU8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:from
	:subject:content-language:to;
	bh=13i87tMO13rhcve6tLJmbJeAi24UsOE6Ctym1lAxd1o=;
	b=PYcHchTrsFNAELJsErWaSMdw9pVKr4+UD4YIkPyUslZrwxukqDpvCzBKqToaQmwgMH
	2xPfmcc8bp/VGITdwPaz4eYJFpsSvysesIuC5WO4vArMwVmqCx5QHOC39y7ok0WTp99z
	VQPAvt6snxJBzCBNn48O2o9qascROexVA80pDSCQQSdjUNngrnb85PEzo1yKS9udEXbJ
	JByYDJ3IWoXL/SfLJ219kPBlEf1obDOPKTKjFaon0nfMpwbsazUp6s93cO0N2zNwAADy
	8OiO0u1fvlwdoHk+o6D/3XmQ3ma7VjOZC7+DEhiLvA0GEOc3LNbNXBSRhGARSwtBvUBp
	sYQg==
X-Gm-Message-State: AOAM531XOCMi/3q8gvbRCI+hADcpgBvUTepfSTfg8CgGPakh0Yy1YnG8
	R6IjxK9+eiV6JB5UL/3a/f9V1BPYZVw=
X-Google-Smtp-Source: ABdhPJxixgzQKJwHgZCk9guqCRD2u3CACR7S6IYsVzVO8FqQ+/rsD///IdjG9Tg1YX66U9D6NvzSng==
X-Received: by 2002:a17:906:fa8d:: with SMTP id
	lt13mr740737ejb.711.1642071491838; 
	Thu, 13 Jan 2022 02:58:11 -0800 (PST)
Received: from [192.168.2.27] (113.151.broadband3.iol.cz. [85.70.151.113])
	by smtp.gmail.com with ESMTPSA id g21sm988566edt.12.2022.01.13.02.58.10
	for <dm-devel@redhat.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 13 Jan 2022 02:58:11 -0800 (PST)
Message-ID: <d3f7ade5-7814-b7c1-3e4e-b2b0b0fd8c32@gmail.com>
Date: Thu, 13 Jan 2022 11:58:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.4.1
From: Milan Broz <gmazyland@gmail.com>
To: device-mapper development <dm-devel@redhat.com>
Authentication-Results: relay.mimecast.com;
	dkim=pass header.d=gmail.com header.s=20210112 header.b=Fw87OCDV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (relay.mimecast.com: domain of gmazyland@gmail.com designates
	209.85.208.47 as permitted sender)
	smtp.mailfrom=gmazyland@gmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [ANNOUNCE] cryptsetup 2.4.3 (CVE-2021-4122 fix)
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
Content-Type: multipart/mixed; boundary="===============0166651868430962252=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============0166651868430962252==
Content-Language: en-US
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="------------acuLe0ojw1LS3K7CT7uq7gki"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------acuLe0ojw1LS3K7CT7uq7gki
Content-Type: multipart/mixed; boundary="------------zWPsdfhXNWEaA5GJ9Rx6jsBS";
	protected-headers="v1"
From: Milan Broz <gmazyland@gmail.com>
To: device-mapper development <dm-devel@redhat.com>
Message-ID: <d3f7ade5-7814-b7c1-3e4e-b2b0b0fd8c32@gmail.com>
Subject: [ANNOUNCE] cryptsetup 2.4.3 (CVE-2021-4122 fix)

--------------zWPsdfhXNWEaA5GJ9Rx6jsBS
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

W0l0IGFwcGVhcnMgdGhhdCBkbS1jcnlwdCBtYWlsaW5nIGxpc3Qgbm8gbG9uZ2VyIHdvcmtzLCBj
b3B5IHRvIGRtLWRldmVsXQ0KDQpUaGUgY3J5cHRzZXR1cCAyLjQuMyBzdGFibGUgcmVsZWFzZSBp
cyBhdmFpbGFibGUgYXQNCg0KICAgICAgICBodHRwczovL2dpdGxhYi5jb20vY3J5cHRzZXR1cC9j
cnlwdHNldHVwDQoNClBsZWFzZSBub3RlIHRoYXQgcmVsZWFzZSBwYWNrYWdlcyBhcmUgbG9jYXRl
ZCBvbiBrZXJuZWwub3JnDQoNCiAgICAgICAgaHR0cHM6Ly93d3cua2VybmVsLm9yZy9wdWIvbGlu
dXgvdXRpbHMvY3J5cHRzZXR1cC92Mi40Lw0KDQpGZWVkYmFjayBhbmQgYnVnIHJlcG9ydHMgYXJl
IHdlbGNvbWVkLg0KDQpDcnlwdHNldHVwIDIuNC4zIFJlbGVhc2UgTm90ZXMNCj09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PQ0KU3RhYmxlIHNlY3VyaXR5IGJ1Zy1maXggcmVsZWFzZSB0aGF0
IGZpeGVzIENWRS0yMDIxLTQxMjIuDQoNCkFsbCB1c2VycyBvZiBjcnlwdHNldHVwIDIuNC54IG11
c3QgdXBncmFkZSB0byB0aGlzIHZlcnNpb24uDQoNCkNoYW5nZXMgc2luY2UgdmVyc2lvbiAyLjQu
Mg0Kfn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+DQoNCiogRml4IHBvc3NpYmxlIGF0dGFja3Mg
YWdhaW5zdCBkYXRhIGNvbmZpZGVudGlhbGl0eSB0aHJvdWdoIExVS1MyIG9ubGluZQ0KICAgIHJl
ZW5jcnlwdGlvbiBleHRlbnNpb24gY3Jhc2ggcmVjb3ZlcnkgKENWRS0yMDIxLTQxMjIpLg0KDQog
ICAgQW4gYXR0YWNrZXIgY2FuIG1vZGlmeSBvbi1kaXNrIG1ldGFkYXRhIHRvIHNpbXVsYXRlIGRl
Y3J5cHRpb24gaW4NCiAgICBwcm9ncmVzcyB3aXRoIGNyYXNoZWQgKHVuZmluaXNoZWQpIHJlZW5j
cnlwdGlvbiBzdGVwIGFuZCBwZXJzaXN0ZW50bHkNCiAgICBkZWNyeXB0IHBhcnQgb2YgdGhlIExV
S1MgZGV2aWNlLg0KDQogICAgVGhpcyBhdHRhY2sgcmVxdWlyZXMgcmVwZWF0ZWQgcGh5c2ljYWwg
YWNjZXNzIHRvIHRoZSBMVUtTIGRldmljZSBidXQNCiAgICBubyBrbm93bGVkZ2Ugb2YgdXNlciBw
YXNzcGhyYXNlcy4NCg0KICAgIFRoZSBkZWNyeXB0aW9uIHN0ZXAgaXMgcGVyZm9ybWVkIGFmdGVy
IGEgdmFsaWQgdXNlciBhY3RpdmF0ZXMNCiAgICB0aGUgZGV2aWNlIHdpdGggYSBjb3JyZWN0IHBh
c3NwaHJhc2UgYW5kIG1vZGlmaWVkIG1ldGFkYXRhLg0KICAgIFRoZXJlIGFyZSBubyB2aXNpYmxl
IHdhcm5pbmdzIGZvciB0aGUgdXNlciB0aGF0IHN1Y2ggcmVjb3ZlcnkgaGFwcGVuZWQNCiAgICAo
ZXhjZXB0IHVzaW5nIHRoZSBsdWtzRHVtcCBjb21tYW5kKS4gVGhlIGF0dGFjayBjYW4gYWxzbyBi
ZSByZXZlcnNlZA0KICAgIGFmdGVyd2FyZCAoc2ltdWxhdGluZyBjcmFzaGVkIGVuY3J5cHRpb24g
ZnJvbSBhIHBsYWludGV4dCkgd2l0aA0KICAgIHBvc3NpYmxlIG1vZGlmaWNhdGlvbiBvZiByZXZl
YWxlZCBwbGFpbnRleHQuDQoNCiAgICBUaGUgc2l6ZSBvZiBwb3NzaWJsZSBkZWNyeXB0ZWQgZGF0
YSBkZXBlbmRzIG9uIGNvbmZpZ3VyZWQgTFVLUzIgaGVhZGVyDQogICAgc2l6ZSAobWV0YWRhdGEg
c2l6ZSBpcyBjb25maWd1cmFibGUgZm9yIExVS1MyKS4NCiAgICBXaXRoIHRoZSBkZWZhdWx0IHBh
cmFtZXRlcnMgKDE2IE1pQiBMVUtTMiBoZWFkZXIpIGFuZCBvbmx5IG9uZQ0KICAgIGFsbG9jYXRl
ZCBrZXlzbG90ICg1MTIgYml0IGtleSBmb3IgQUVTLVhUUyksIHNpbXVsYXRlZCBkZWNyeXB0aW9u
IHdpdGgNCiAgICBjaGVja3N1bSByZXNpbGllbmNlIFNIQTEgKDIwIGJ5dGVzIGNoZWNrc3VtIGZv
ciA0MDk2LWJ5dGUgYmxvY2tzKSwNCiAgICB0aGUgbWF4aW1hbCBkZWNyeXB0ZWQgc2l6ZSBjYW4g
YmUgb3ZlciAzR2lCLg0KDQogICAgVGhlIGF0dGFjayBpcyBub3QgYXBwbGljYWJsZSB0byBMVUtT
MSBmb3JtYXQsIGJ1dCB0aGUgYXR0YWNrZXIgY2FuDQogICAgdXBkYXRlIG1ldGFkYXRhIGluIHBs
YWNlIHRvIExVS1MyIGZvcm1hdCBhcyBhbiBhZGRpdGlvbmFsIHN0ZXAuDQogICAgRm9yIHN1Y2gg
YSBjb252ZXJ0ZWQgTFVLUzIgaGVhZGVyLCB0aGUga2V5c2xvdCBhcmVhIGlzIGxpbWl0ZWQgdG8N
CiAgICBkZWNyeXB0ZWQgc2l6ZSAod2l0aCBTSEExIGNoZWNrc3Vtcykgb3ZlciAzMDAgTWlCLg0K
DQogICAgVGhlIGlzc3VlIGlzIHByZXNlbnQgaW4gYWxsIGNyeXB0c2V0dXAgcmVsZWFzZXMgc2lu
Y2UgMi4yLjAuDQogICAgVmVyc2lvbnMgMS54LCAyLjAueCwgYW5kIDIuMS54IGFyZSBub3QgYWZm
ZWN0ZWQsIGFzIHRoZXNlIGRvIG5vdA0KICAgIGNvbnRhaW4gTFVLUzIgcmVlbmNyeXB0aW9uIGV4
dGVuc2lvbi4NCg0KICAgIFRoZSBwcm9ibGVtIHdhcyBjYXVzZWQgYnkgcmV1c2luZyBhIG1lY2hh
bmlzbSBkZXNpZ25lZCBmb3IgYWN0dWFsDQogICAgcmVlbmNyeXB0aW9uIG9wZXJhdGlvbiB3aXRo
b3V0IHJlYXNzZXNzaW5nIHRoZSBzZWN1cml0eSBpbXBhY3QgZm9yIG5ldw0KICAgIGVuY3J5cHRp
b24gYW5kIGRlY3J5cHRpb24gb3BlcmF0aW9ucy4gV2hpbGUgdGhlIHJlZW5jcnlwdGlvbiByZXF1
aXJlcw0KICAgIGNhbGN1bGF0aW5nIGFuZCB2ZXJpZnlpbmcgYm90aCBrZXkgZGlnZXN0cywgbm8g
ZGlnZXN0IHdhcyBuZWVkZWQgdG8NCiAgICBpbml0aWF0ZSBkZWNyeXB0aW9uIHJlY292ZXJ5IGlm
IHRoZSBkZXN0aW5hdGlvbiBpcyBwbGFpbnRleHQgKG5vDQogICAgZW5jcnlwdGlvbiBrZXkpLiBB
bHNvLCBzb21lIG1ldGFkYXRhIChsaWtlIGVuY3J5cHRpb24gY2lwaGVyKSBpcyBub3QNCiAgICBw
cm90ZWN0ZWQsIGFuZCBhbiBhdHRhY2tlciBjb3VsZCBjaGFuZ2UgaXQuIE5vdGUgdGhhdCBMVUtT
MiBwcm90ZWN0cw0KICAgIHZpc2libGUgbWV0YWRhdGEgb25seSB3aGVuIGEgcmFuZG9tIGNoYW5n
ZSBvY2N1cnMuIEl0IGRvZXMgbm90IHByb3RlY3QNCiAgICBhZ2FpbnN0IGludGVudGlvbmFsIG1v
ZGlmaWNhdGlvbiBidXQgc3VjaCBtb2RpZmljYXRpb24gbXVzdCBub3QgY2F1c2UNCiAgICBhIHZp
b2xhdGlvbiBvZiBkYXRhIGNvbmZpZGVudGlhbGl0eS4NCg0KICAgIFRoZSBmaXggaW50cm9kdWNl
cyBhZGRpdGlvbmFsIGRpZ2VzdCBwcm90ZWN0aW9uIG9mIHJlZW5jcnlwdGlvbg0KICAgIG1ldGFk
YXRhLiBUaGUgZGlnZXN0IGlzIGNhbGN1bGF0ZWQgZnJvbSBrbm93biBrZXlzIGFuZCBjcml0aWNh
bA0KICAgIHJlZW5jcnlwdGlvbiBtZXRhZGF0YS4gTm93IGFuIGF0dGFja2VyIGNhbm5vdCBjcmVh
dGUgY29ycmVjdCBtZXRhZGF0YQ0KICAgIGRpZ2VzdCB3aXRob3V0IGtub3dsZWRnZSBvZiBhIHBh
c3NwaHJhc2UgZm9yIHVzZWQga2V5c2xvdHMuDQogICAgRm9yIG1vcmUgZGV0YWlscywgc2VlIExV
S1MyIE9uLURpc2sgRm9ybWF0IFNwZWNpZmljYXRpb24gdmVyc2lvbiAxLjEuMC4NCg0KICAgIFRo
ZSBmb3JtZXIgcmVlbmNyeXB0aW9uIG9wZXJhdGlvbiAod2l0aG91dCB0aGUgYWRkaXRpb25hbCBk
aWdlc3QpIGlzIG5vDQogICAgbG9uZ2VyIHN1cHBvcnRlZCAocmVlbmNyeXB0aW9uIHdpdGggdGhl
IGRpZ2VzdCBpcyBub3QgYmFja3dhcmQNCiAgICBjb21wYXRpYmxlKS4gWW91IG5lZWQgdG8gZmlu
aXNoIGluLXByb2dyZXNzIHJlZW5jcnlwdGlvbiBiZWZvcmUNCiAgICB1cGRhdGluZyB0byBuZXcg
cGFja2FnZXMuIFRoZSBhbHRlcm5hdGl2ZSBhcHByb2FjaCBpcyB0byBwZXJmb3JtDQogICAgYSBy
ZXBhaXIgY29tbWFuZCBmcm9tIHRoZSB1cGRhdGVkIHBhY2thZ2UgdG8gcmVjYWxjdWxhdGUgcmVl
bmNyeXB0aW9uDQogICAgZGlnZXN0IGFuZCBmaXggbWV0YWRhdGEuDQogICAgVGhlIHJlZW5jcnlw
dGlvbiByZXBhaXIgb3BlcmF0aW9uIGFsd2F5cyByZXF1aXJlIGEgdXNlciBwYXNzcGhyYXNlLg0K
DQogICAgV0FSTklORzogRGV2aWNlcyB3aXRoIG9sZGVyIHJlZW5jcnlwdGlvbiBpbiBwcm9ncmVz
cyBjYW4gYmUgbm8gbG9uZ2VyDQogICAgYWN0aXZhdGVkIHdpdGhvdXQgcGVyZm9ybWluZyB0aGUg
YWN0aW9uIG1lbnRpb25lZCBhYm92ZS4NCg0KICAgIEVuY3J5cHRpb24gaW4gcHJvZ3Jlc3MgY2Fu
IGJlIGRldGVjdGVkIGJ5IHJ1bm5pbmcgdGhlIGx1a3NEdW1wIGNvbW1hbmQNCiAgICAob3V0cHV0
IGluY2x1ZGVzIHJlZW5jcnlwdCBrZXlzbG90IHdpdGggcmVlbmNyeXB0aW9uIHBhcmFtZXRlcnMp
LiBBbHNvLA0KICAgIGR1cmluZyB0aGUgYWN0aXZlIHJlZW5jcnlwdGlvbiwgbm8ga2V5c2xvdCBv
cGVyYXRpb25zIGFyZSBhdmFpbGFibGUNCiAgICAoY2hhbmdlIG9mIHBhc3NwaHJhc2VzLCBldGMu
KS4NCg0KICAgIFRoZSBpc3N1ZSB3YXMgZm91bmQgYnkgTWlsYW4gQnJveiBhcyBjcnlwdHNldHVw
IG1haW50YWluZXIuDQoNCk90aGVyIGNoYW5nZXMNCn5+fn5+fn5+fn5+fn4NCiogQWRkIGNvbmZp
Z3VyZSBvcHRpb24gLS1kaXNhYmxlLWx1a3MyLXJlZW5jcnlwdGlvbiB0byBjb21wbGV0ZWx5IGRp
c2FibGUNCiAgICBMVUtTMiByZWVuY3J5cHRpb24gY29kZS4NCg0KICAgIFdoZW4gdXNlZCwgdGhl
IGxpYmNyeXB0c2V0dXAgbGlicmFyeSBjYW4gcmVhZCBtZXRhZGF0YSB3aXRoDQogICAgcmVlbmNy
eXB0aW9uIGNvZGUsIGJ1dCBhbGwgcmVlbmNyeXB0aW9uIEFQSSBjYWxscyBhbmQgY3J5cHRzZXR1
cA0KICAgIHJlZW5jcnlwdCBjb21tYW5kcyBhcmUgZGlzYWJsZWQuDQoNCiAgICBEZXZpY2VzIHdp
dGggb25saW5lIHJlZW5jcnlwdGlvbiBpbiBwcm9ncmVzcyBjYW5ub3QgYmUgYWN0aXZhdGVkLg0K
ICAgIFRoaXMgb3B0aW9uIGNhbiBjYXVzZSBzb21lIGluY29tcGF0aWJpbGl0aWVzLiBQbGVhc2Ug
dXNlIHdpdGggY2FyZS4NCg0KKiBJbXByb3ZlIGludGVybmFsIG1ldGFkYXRhIHZhbGlkYXRpb24g
Y29kZSBmb3IgcmVlbmNyeXB0aW9uIG1ldGFkYXRhLg0KDQoqIEFkZCB1cGRhdGVkIGRvY3VtZW50
YXRpb24gZm9yIExVS1MyIE9uLURpc2sgRm9ybWF0IFNwZWNpZmljYXRpb24NCiAgICB2ZXJzaW9u
IDEuMS4wICh3aXRoIHJlZW5jcnlwdGlvbiBleHRlbnNpb24gZGVzY3JpcHRpb24gYW5kIHVwZGF0
ZWQNCiAgICBtZXRhZGF0YSBkZXNjcmlwdGlvbikuIFNlZSBkb2NzL29uLWRpc2stZm9ybWF0LWx1
a3MyLnBkZiBvciBvbmxpbmUNCiAgICB2ZXJzaW9uIGluIGh0dHBzOi8vZ2l0bGFiLmNvbS9jcnlw
dHNldHVwL0xVS1MyLWRvY3MgcmVwb3NpdG9yeS4NCg0KKiBGaXggc3VwcG9ydCBmb3IgYml0bGsg
KEJpdExvY2tlciBjb21wYXRpYmxlKSBzdGFydHVwIGtleSB3aXRoIG5ldw0KICAgIG1ldGFkYXRh
IGVudHJ5IGludHJvZHVjZWQgaW4gV2luZG93cyAxMS4NCg0KKiBGaXggc3BhY2UgcmVzdHJpY3Rp
b24gZm9yIExVS1MyIHJlZW5jcnlwdGlvbiB3aXRoIGRhdGEgc2hpZnQuDQogICAgVGhlIGNvZGUg
cmVxdWlyZWQgbW9yZSBzcGFjZSB0aGFuIHdhcyBuZWVkZWQuDQoNCg==
--------------zWPsdfhXNWEaA5GJ9Rx6jsBS--

--------------acuLe0ojw1LS3K7CT7uq7gki
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEKikYJD/eRmSNBob52bBXe9k+mPwFAmHgBbsACgkQ2bBXe9k+
mPzgLRAAyNA/0v5aObujxHXDfzx+b0dLMha1Mwdyp3yMtvKpq7RldEy6H0oMaNx4
REKaBQHoj6YbZUiTlC+luHPu8dYTg16upkzp67/AoTDe4woIUNVx1hMBl2EvAaY6
2wxSYRsQ7l4LlkliMnDvV3F0nVz8ByKu959blutt3MuVtPWbpJo0iFPo/kWDq/Cy
FziME9kuS0Oa4tdsJS5DqULlXNhpNRCPNnQdJiSqVOXRjQohZpVtniNdkeqx89Uh
7rp7TE9cLHeNQgkQgOhcH7BOgvcSPuOW2gbbshZmUgJOOhUZ7EQTT1zEvPcPkXl2
Vdz8c0s2KYtsdMTL1GIAIsu7IsnyaOK2RHFDWXFA2V5HXLEqSu/SKu3je/VY1/1o
JjjPeRFSmcg0HzbsuYzNVXODc4cdG0YznnRJTAut7oRLhwfkVZ/Ssnxtd1ZKqPEL
UcUQ4f1VZL0UD0Kpu7vG0JwhUzNhs8t30qVko9qEjLHg+MGPzenfQU5JITarZIz1
wjRiR73qHcEtNr2R3C488Y1tW9sxT3Ge8p2ByOcmGA73aceo69IMDlkMXO7IQ14z
6MRW56NiZAp2iLYWlpA7bqbsNukcWOfAnTWUAJcvH6oeMv76aqVS3sFmh2xEUnNF
BrFRGpL/gLFe9X3Ka268l2190UMKOZXjYM97m9Ai2MDs1DMT4Bs=
=HjaK
-----END PGP SIGNATURE-----

--------------acuLe0ojw1LS3K7CT7uq7gki--


--===============0166651868430962252==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============0166651868430962252==--

