Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D09CC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 13 Jan 2022 11:01:14 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-saBOIYpjOKyfoRfGwmOxFw-1; Thu, 13 Jan 2022 06:01:09 -0500
X-MC-Unique: saBOIYpjOKyfoRfGwmOxFw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 808D4192CC40;
	Thu, 13 Jan 2022 11:01:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C6BEB70D58;
	Thu, 13 Jan 2022 11:01:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 823AD1809CBF;
	Thu, 13 Jan 2022 11:01:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20DAwVTi001642 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 13 Jan 2022 05:58:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 194C746D1FD; Thu, 13 Jan 2022 10:58:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1539246D1E1
	for <dm-devel@redhat.com>; Thu, 13 Jan 2022 10:58:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECB3D3C01BB3
	for <dm-devel@redhat.com>; Thu, 13 Jan 2022 10:58:30 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1642071510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:mime-version:mime-version:content-type:content-type:
	dkim-signature; bh=bbfbLRtGfPCPgFQeXDPEJxxI+iQNmLYiOBldbyvOd9o=;
	b=CSKCejlCqtWF1sHXtOBuCLllm55gFFFLWnpf8huFgmaXiupn8Vwh2jhqgoJhKODVLHGbtn
	yt5TJ2g79Nuj4JPVlBo2plz7CC9Y0RFaVOuAGwnYGEMtHuz0Vy7XxRnAsmHC9CFGtqagJt
	5XFcYmVtYvDxEN6t12XT/8LhSzwLhCu32fn4isYyCd7MNCglVYwM3JZLYBYWOYcG+y+D2n
	3x0v7rgRZuVWjkCISKEUiAFRXtb2l2T+ZyqizA98pRsO94cmMqsUpajKphmYsa0lR9/u+j
	PGenZefI4nPYqTpCuVXAvucXxGUxZE+Oq+aOhRQ+YVuaK7DzE/1qnR4W668+Fw==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1642071510; a=rsa-sha256;
	cv=none;
	b=bfTeu9YNoBXmTM9CoEQ7UnJoboHY6YmRf0DFsgQJxD19USxe1EgXDkntGGvB8rGF7Id4hF
	iA2jpsougCZZsBSnV7AJYkuFgCYc9icVEiD4nw7vipoXMzBIHClotsEi927Jg7tOgR+sq2
	89vjCUpvOAQHQ93iRckAN+zOXXwlU/qfetZBbl8NDZ1E/8kauZEQ7/3+tUc3TIzp5/L32q
	m/dmdAZ9GdxUyMxqrP8hjCD0uOiP8gPb/gaMGK5ZPbJjkEAI0Lejjw++CqT6i+z5Nmn0Wq
	6ihpxYXFOSArQhbaIRQrPBppYSXdIpqwh+PwNRw9OjwqkQ0cIIyS2FNl2MCZdA==
ARC-Authentication-Results: i=1; relay.mimecast.com;
	dkim=pass header.d=gmail.com header.s=20210112 header.b=ZOEXo4dq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (relay.mimecast.com: domain of gmazyland@gmail.com designates
	209.85.208.51 as permitted sender)
	smtp.mailfrom=gmazyland@gmail.com
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com
	[209.85.208.51]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-249-keYiIh4OMXqYra6ux5l1Ag-1; Thu, 13 Jan 2022 05:58:26 -0500
X-MC-Unique: keYiIh4OMXqYra6ux5l1Ag-1
Received: by mail-ed1-f51.google.com with SMTP id k15so21435106edk.13
	for <dm-devel@redhat.com>; Thu, 13 Jan 2022 02:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
	h=message-id:date:mime-version:user-agent:from:subject:to
	:content-language;
	bh=l2mpLx3+Ywef1mDfjy4iKJiF4dSHKC4cHYnIvoa4iOg=;
	b=ZOEXo4dqYm0Ibzrfi1z2PQEUDbbAGOdpztGmUvGEGNgX/jwhaw44ZleTX0hZE+0UAA
	YsbzEvE5jwoSE5QcxRbNHwXZr2Wf5EVSQ9YKVX+/RQafSwOpG8+KtmGZ1Fs2N126SOoJ
	/INpp4EShgcVNpuij/cnfVjovkZH/VWzV0TPzGNvYnl/VxQbpek7hDfz5h2MeTwwMPbt
	k4cDcyy5Q4uKYQanGSyxRuM8EVw4EPIBCSb8BdPyHEGVQN8UEJ/Edz3bcnnK+/Vq8hVz
	bzXAGTw2Dl+XriE/7DMZKCLQeJyFB9Mu4jmiu1Q+OEH5XOejZWJ/o8d1F/7jJHxilJYC
	bK2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:from
	:subject:to:content-language;
	bh=l2mpLx3+Ywef1mDfjy4iKJiF4dSHKC4cHYnIvoa4iOg=;
	b=UMk6Gwr6D1zck5yfGj4zQh0j7Zj4v+h7ib5PChNXvt9tmXXwY5/BCry/tRNv1alb0E
	IhL9mzEm8ICCMXenZIV0l1Sl4ggqzD358wZBcLxM1LSJscXQUC1YXkdCfOlr2iEcCmQh
	/JSLioC3rX9BZUN+tEZesJt+C0pYE9gD5Qm5e7GG3c2ki2vwb1EYXxZ7hOgYO1tGdo4+
	AVpOqMzJmgkzu/iYp/U9igwFwqMGBHljrASEiZdF2qH2lqhYaJ75Tu9mD+tWXauzNSNW
	YFVH2/hr6q5+MlFZyFZBB0hS0ox4iUUQO5k9nQziSKmn6HK8LV+MZhhE9kZlaXCPuYag
	rK+g==
X-Gm-Message-State: AOAM531sE5d3VPAK+Xcuk9FG0k40S+Q+tRKUgICMgnEseUc8TctMvK3N
	/ocnzIg8xV3sp7zH0UAbLPR15iA+PsQ=
X-Google-Smtp-Source: ABdhPJy6fBGYpTDOyrumtYcOBzzYJ3q2svS+K76effmhKLgFWFj+tywNezUOfoH2dfh2lrtk0KZjZw==
X-Received: by 2002:aa7:c30f:: with SMTP id l15mr3543824edq.310.1642071505651; 
	Thu, 13 Jan 2022 02:58:25 -0800 (PST)
Received: from [192.168.2.27] (113.151.broadband3.iol.cz. [85.70.151.113])
	by smtp.gmail.com with ESMTPSA id
	go41sm765294ejc.200.2022.01.13.02.58.24 for <dm-devel@redhat.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 13 Jan 2022 02:58:25 -0800 (PST)
Message-ID: <df9c07c1-b3de-78c3-3c2a-d49ad7ea2790@gmail.com>
Date: Thu, 13 Jan 2022 11:58:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.4.1
From: Milan Broz <gmazyland@gmail.com>
To: device-mapper development <dm-devel@redhat.com>
Authentication-Results: relay.mimecast.com;
	dkim=pass header.d=gmail.com header.s=20210112 header.b=ZOEXo4dq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (relay.mimecast.com: domain of gmazyland@gmail.com designates
	209.85.208.51 as permitted sender)
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [ANNOUNCE] cryptsetup 2.3.7 (CVE-2021-4122 fix)
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
Content-Type: multipart/mixed; boundary="===============6724529842392906007=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============6724529842392906007==
Content-Language: en-US
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="------------41CMnrBrVoOxzSsAJKC50bHN"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------41CMnrBrVoOxzSsAJKC50bHN
Content-Type: multipart/mixed; boundary="------------M9pPbezcQUgPmXnDIViS4Ia4";
	protected-headers="v1"
From: Milan Broz <gmazyland@gmail.com>
To: device-mapper development <dm-devel@redhat.com>
Message-ID: <df9c07c1-b3de-78c3-3c2a-d49ad7ea2790@gmail.com>
Subject: [ANNOUNCE] cryptsetup 2.3.7 (CVE-2021-4122 fix)

--------------M9pPbezcQUgPmXnDIViS4Ia4
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

W0l0IGFwcGVhcnMgdGhhdCBkbS1jcnlwdCBtYWlsaW5nIGxpc3Qgbm8gbG9uZ2VyIHdvcmtzLCBj
b3B5IHRvIGRtLWRldmVsXQ0KDQpUaGUgY3J5cHRzZXR1cCAyLjMuNyBzdGFibGUgcmVsZWFzZSBp
cyBhdmFpbGFibGUgYXQNCg0KICAgICAgICBodHRwczovL2dpdGxhYi5jb20vY3J5cHRzZXR1cC9j
cnlwdHNldHVwDQoNClBsZWFzZSBub3RlIHRoYXQgcmVsZWFzZSBwYWNrYWdlcyBhcmUgbG9jYXRl
ZCBvbiBrZXJuZWwub3JnDQoNCiAgICAgICAgaHR0cHM6Ly93d3cua2VybmVsLm9yZy9wdWIvbGlu
dXgvdXRpbHMvY3J5cHRzZXR1cC92Mi4zLw0KDQpGZWVkYmFjayBhbmQgYnVnIHJlcG9ydHMgYXJl
IHdlbGNvbWVkLg0KDQpDcnlwdHNldHVwIDIuMy43IFJlbGVhc2UgTm90ZXMNCj09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PQ0KU3RhYmxlIHNlY3VyaXR5IGJ1Zy1maXggcmVsZWFzZSB0aGF0
IGZpeGVzIENWRS0yMDIxLTQxMjIuDQoNCkFsbCB1c2VycyBvZiBjcnlwdHNldHVwIDIuMy54IG11
c3QgdXBncmFkZSB0byB0aGlzIHZlcnNpb24uDQoNCkNoYW5nZXMgc2luY2UgdmVyc2lvbiAyLjMu
Ng0Kfn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+DQoNCiogRml4IHBvc3NpYmxlIGF0dGFja3Mg
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
dHNldHVwL0xVS1MyLWRvY3MgcmVwb3NpdG9yeS4NCg==
--------------M9pPbezcQUgPmXnDIViS4Ia4--

--------------41CMnrBrVoOxzSsAJKC50bHN
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEKikYJD/eRmSNBob52bBXe9k+mPwFAmHgBdAACgkQ2bBXe9k+
mPy7exAAk4E1PJFaiIkLjsI8KlvZaAu4dsVo1znHmfyt5zqPxKxJt/3KF7lPtewd
GD09hodm7iSmAFvo40rdxdoMyDSQI7DX7haFM4eN+PghEMYq6i1KjpHKGijJbWj/
0ClW6ya6h4geno4VD49qmjbPcIADQuOIOAdFaHh7cex/k70krUwz+mpzxaQ/gZ93
g9+V57CwMzQC4BM2DyBJQQgV7APCF3tNiGfkDLYUxXNFFPcYgpt5DrKNF0L15J/0
OPzCFhIMlqKKrOkPoWecsYVtZdYs6n2jZBNAK/Ehk5l6D/3FtpuViz+JXkR0Efnc
TJSFeASBb0B33Ub3JjybRo3nDL2RP7DxfDOfbIJAEjXrgfajDWy1Fvw2+SFckpKu
78RXUm4DHAqmIeL/Wyc9x0ESu8qnxmNFLQtZtblz6u65sKQ6Uwh1IW6gPP+mEnQM
GnMoF4MPw1LVEiXkjVBQAEOWdbKeNnoTAiy1A4CRcZj+Q6hujmn29nGd0OQ2itma
fa4OwIythj6nXyypyNK4b7CGAT7RxI3Dm5DUTKfzLvH3OO+ahVju1nm9su6JSIWP
V/I6ofBBWYsKGOnilCRI0gHy29E68/GkWqVAAGFyj49y8MhW45LqWq6zJIRsT7Pc
xPg3775PM0UPki2aPFv4DuMQPUsOHVcg7ouAgvkVdAAIz/M0rDk=
=ZmiX
-----END PGP SIGNATURE-----

--------------41CMnrBrVoOxzSsAJKC50bHN--


--===============6724529842392906007==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============6724529842392906007==--

