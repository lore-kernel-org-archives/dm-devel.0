Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A80EC77B7A
	for <dm-devel@archiver.kernel.org>; Fri,  2 Jun 2023 18:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685731488;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Sn3y2kyLNaouYMNaSNrv5Z2lguMp6/oinJ70Q2/t0s8=;
	b=isvmu6+A7n9V/WL/jdw4J2Q5QaQV5UxPbeWwjluUE5Y799W5Orn3QLGlIaWNB63mQpvWXr
	hYeJt9nBa4J1vHQdE3d/jn7an8B0wWU+jcafDdp/sEDN/qD1xonbBeIO5NLJKzbZrRu0DX
	kHe/kWAcd2glXH7iJSf/sNq2XyBS9sQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-1xCb2AWoMiy4Vwp78TJFdg-1; Fri, 02 Jun 2023 14:44:46 -0400
X-MC-Unique: 1xCb2AWoMiy4Vwp78TJFdg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B27BC811E7F;
	Fri,  2 Jun 2023 18:44:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EFB018162;
	Fri,  2 Jun 2023 18:44:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A31881946595;
	Fri,  2 Jun 2023 18:44:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 31AD5194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Jun 2023 18:44:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1E672492B00; Fri,  2 Jun 2023 18:44:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 168FB48205E
 for <dm-devel@redhat.com>; Fri,  2 Jun 2023 18:44:41 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9FB81C0515B
 for <dm-devel@redhat.com>; Fri,  2 Jun 2023 18:44:40 +0000 (UTC)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com
 [209.85.208.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-FBE_srNwOrOdpWpMz64EaQ-1; Fri, 02 Jun 2023 14:44:39 -0400
X-MC-Unique: FBE_srNwOrOdpWpMz64EaQ-1
Received: by mail-ed1-f48.google.com with SMTP id
 4fb4d7f45d1cf-5149bdb59daso3356073a12.2
 for <dm-devel@redhat.com>; Fri, 02 Jun 2023 11:44:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685731478; x=1688323478;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=VS2PPB5+6vCBsSxepSbGKCuyaQT9nPsi9usTi72Jayc=;
 b=AyyjCY+i6sIIv+rqcuvstPjYVJzWifDFQhj8vrBz0q2qZNOM0LbGrLuXQ2y4k5QeIY
 a5db9209oSzwZepiiPmv9Xc+QhwjytsSXiPDow0oij6p8Dx6BKBU4er3efTBbFQfhRzz
 p4jfTMoTTaCHZrKHZYrOPF+7maglv/jmOnMwiQWi+po8pteHBAsyboKeoczMbo4pgtwe
 VpsYUu96RCBurX1GezQkxRcmAitEhRfIMZRTu6Hv1tr3OLLFEH6n+eE8RCq77bDwmNNg
 bGFaHoVb+roVYNJNavX/sFsQbd+Pa2PLVQZjfHANJzRvVBpJgzVnKhkrhhqBAlokBr88
 lmLQ==
X-Gm-Message-State: AC+VfDw0R18g2HfswwAsuIOrZaaKJoSp4IL6uUq3vqQG3MG9wuvOap5H
 UcPXK9xpuszJWtOl8yQmm/nOHYXeJaaZgr5eASWf9A==
X-Google-Smtp-Source: ACHHUZ7H8ymmvsuV8pIQreDZRzT1x8Q5ySH7cuWVFpH38pUlAJ9sGk9vksaBVqGaNtyGZXGewzGH8jOcPNcYXgPHGa4=
X-Received: by 2002:a17:906:eec8:b0:970:c9f:2db6 with SMTP id
 wu8-20020a170906eec800b009700c9f2db6mr11444588ejb.63.1685731478182; Fri, 02
 Jun 2023 11:44:38 -0700 (PDT)
MIME-Version: 1.0
References: <ZGzIJlCE2pcqQRFJ@bfoster> <ZGzbGg35SqMrWfpr@redhat.com>
 <ZG1dAtHmbQ53aOhA@dread.disaster.area> <ZG+KoxDMeyogq4J0@bfoster>
 <ZHB954zGG1ag0E/t@dread.disaster.area>
 <CAJ0trDbspRaDKzTzTjFdPHdB9n0Q9unfu1cEk8giTWoNu3jP8g@mail.gmail.com>
 <ZHFEfngPyUOqlthr@dread.disaster.area>
 <CAJ0trDZJQwvAzngZLBJ1hB0XkQ1HRHQOdNQNTw9nK-U5i-0bLA@mail.gmail.com>
 <ZHYB/6l5Wi+xwkbQ@redhat.com>
 <CAJ0trDaUOevfiEpXasOESrLHTCcr=oz28ywJU+s+YOiuh7iWow@mail.gmail.com>
 <ZHYWAGmKhwwmTjW/@redhat.com>
In-Reply-To: <ZHYWAGmKhwwmTjW/@redhat.com>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Fri, 2 Jun 2023 11:44:27 -0700
Message-ID: <CAG9=OMMnDfN++-bJP3jLmUD6O=Q_ApV5Dr392_5GqsPAi_dDkg@mail.gmail.com>
To: Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v7 0/5] Introduce provisioning primitives
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Joe Thornber <thornber@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Brian Foster <bfoster@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
 Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Joe Thornber <ejt@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBNYXkgMzAsIDIwMjMgYXQgODoyOOKAr0FNIE1pa2UgU25pdHplciA8c25pdHplckBr
ZXJuZWwub3JnPiB3cm90ZToKPgo+IE9uIFR1ZSwgTWF5IDMwIDIwMjMgYXQgMTA6NTVQIC0wNDAw
LAo+IEpvZSBUaG9ybmJlciA8dGhvcm5iZXJAcmVkaGF0LmNvbT4gd3JvdGU6Cj4KPiA+IE9uIFR1
ZSwgTWF5IDMwLCAyMDIzIGF0IDM6MDLigK9QTSBNaWtlIFNuaXR6ZXIgPHNuaXR6ZXJAa2VybmVs
Lm9yZz4gd3JvdGU6Cj4gPgo+ID4gPgo+ID4gPiBBbHNvIEpvZSwgZm9yIHlvdSBwcm9wb3NlZCBk
bS10aGlucCBkZXNpZ24gd2hlcmUgeW91IGRpc3RpbnF1aXNoCj4gPiA+IGJldHdlZW4gInByb3Zp
c2lvbiIgYW5kICJyZXNlcnZlIjogV291bGQgaXQgbWFrZSBzZW5zZSBmb3IgUkVRX01FVEEKPiA+
ID4gKGUuZy4gYWxsIFhGUyBtZXRhZGF0YSkgd2l0aCBSRVFfUFJPVklTSU9OIHRvIGJlIHRyZWF0
ZWQgYXMgYW4KPiA+ID4gTEJBLXNwZWNpZmljIGhhcmQgcmVxdWVzdD8gIFdoZXJlYXMgUkVRX1BS
T1ZJU0lPTiBvbiBpdHMgb3duIHByb3ZpZGVzCj4gPiA+IG1vcmUgZnJlZWRvbSB0byBqdXN0IHJl
c2VydmUgdGhlIGxlbmd0aCBvZiBibG9ja3M/IChlLmcuIGZvciBYRlMKPiA+ID4gZGVsYWxsb2Mg
d2hlcmUgTEJBIHJhbmdlIGlzIHVua25vd24sIGJ1dCBkbS10aGlucCBjYW4gYmUgYXNrZWQgdG8K
PiA+ID4gcmVzZXJ2ZSBzcGFjZSB0byBhY2NvbW9kYXRlIGl0KS4KPiA+ID4KPiA+Cj4gPiBNeSBw
cm9wb3NhbCBvbmx5IGludm9sdmVzICdyZXNlcnZlJy4gIFByb3Zpc2lvbmluZyB3aWxsIGJlIGRv
bmUgYXMgcGFydCBvZgo+ID4gdGhlIHVzdWFsIGlvIHBhdGguCj4KPiBPSywgSSB0aGluayB3ZSdk
IGRvIHdlbGwgdG8gcGluIGRvd24gdGhlIHRvcC1sZXZlbCBibG9jayBpbnRlcmZhY2VzIGluCj4g
cXVlc3Rpb24uIEJlY2F1c2UgdGhpcyBwYXRjaHNldCdzIGJsb2NrIGludGVyZmFjZSBwYXRjaCAo
Mi81KSBoZWFkZXIKPiBzYXlzOgo+Cj4gIlRoaXMgcGF0Y2ggYWxzbyBhZGRzIHRoZSBjYXBhYmls
aXR5IHRvIGNhbGwgZmFsbG9jYXRlKCkgaW4gbW9kZSAwCj4gb24gYmxvY2sgZGV2aWNlcywgd2hp
Y2ggd2lsbCBzZW5kIFJFUV9PUF9QUk9WSVNJT04gdG8gdGhlIGJsb2NrCj4gZGV2aWNlIGZvciB0
aGUgc3BlY2lmaWVkIHJhbmdlLCIKPgo+IFNvIGl0IHdpcmVzIHVwIGJsa2Rldl9mYWxsb2NhdGUo
KSB0byBjYWxsIGJsa2Rldl9pc3N1ZV9wcm92aXNpb24oKS4gQQo+IHVzZXIgb2YgWEZTIGNvdWxk
IHRoZW4gdXNlIGZhbGxvY2F0ZSgpIGZvciB1c2VyIGRhdGEgLS0gd2hpY2ggd291bGQKPiBjYXVz
ZSB0aGlucCdzIHJlc2VydmUgdG8gX25vdF8gYmUgdXNlZCBmb3IgY3JpdGljYWwgbWV0YWRhdGEu
Cj4KPiBUaGUgb25seSB3YXkgdG8gZGlzdGlucXVpc2ggdGhlIGNhbGxlciAoYmV0d2VlbiBvbi1i
ZWhhbGYgb2YgdXNlciBkYXRhCj4gdnMgWEZTIG1ldGFkYXRhKSB3b3VsZCBiZSBSRVFfTUVUQT8K
Pgo+IFNvIHNob3VsZCBkbS10aGlucCBoYXZlIGEgUkVRX01FVEEtYmFzZWQgZGlzdGluY3Rpb24/
IE9yIGp1c3QgdHJlYXQKPiBhbGwgUkVRX09QX1BST1ZJU0lPTiB0aGUgc2FtZT8KPgpJJ20gaW4g
ZmF2b3Igb2YgYSBSRVFfTUVUQS1iYXNlZCBkaXN0aW5jdGlvbi4gRG9lcyB0aGF0IGltcGx5IHRo
YXQKUkVRX01FVEEgYWxzbyBuZWVkcyB0byBiZSBwYXNzZWQgdGhyb3VnaCB0aGUgYmxvY2svZmls
ZXN5c3RlbSBzdGFjawooZWcuIFJFUV9PUF9QUk9WSU9OICsgUkVRX01FVEEgb24gYSBsb29wIGRl
dmljZSB0cmFuc2xhdGVzIHRvIGEKZmFsbG9jYXRlKDxpbnNlcnQgbWV0YSBmbGFnIG5hbWU+KSB0
byB0aGUgdW5kZXJseWluZyBmaWxlKT8KCjxiaWtlc2hlZD4KSSB0aGluayB0aGF0IG1pZ2h0IGhh
dmUgYXBwbGljYXRpb25zIGJleW9uZCBqdXN0IHByb3Zpc2lvbmluZzoKY3VycmVudGx5LCBmb3Ig
c3RhY2tlZCBmaWxlc3lzdGVtcyAoZWcgZmlsZXN5c3RlbXMgcmVzaWRpbmcgaW4gYSBmaWxlCm9u
IHRvcCBvZiBhbm90aGVyIGZpbGVzeXN0ZW0pLCBldmVuIGlmIHRoZSB1cHBlciBmaWxlc3lzdGVt
IGlzc3VlcwpyZWFkL3dyaXRlIHJlcXVlc3RzIHdpdGggUkVRX01FVEEgfCBSRVFfUFJJTywgdGhl
c2UgZmxhZ3MgYXJlIGxvc3QgaW4KdHJhbnNsYXRpb24gYXQgdGhlIGxvb3AgZGV2aWNlIGxheWVy
LiAgQSBmbGFnIGxpa2UgdGhlIGFib3ZlIHdvdWxkCmFsbG93IHRoZSBwcmlvcml0aXphdGlvbiBv
ZiBzdGFja2VkIGZpbGVzeXN0ZW0gbWV0YWRhdGEgcmVxdWVzdHMuCjwvYmlrZXNoZWQ+CgpCcmlu
Z2luZyB0aGUgZGlzY3Vzc2lvbiBiYWNrIHRvIHRoaXMgc2VyaWVzIGZvciBhIGJpdCwgSSdtIHN0
aWxsCndhaXRpbmcgb24gZmVlZGJhY2sgZnJvbSB0aGUgQmxvY2sgbWFpbnRhaW5lcnMgYmVmb3Jl
IHNlbmRpbmcgb3V0IHY4Cih3aGljaCBhdCB0aGUgbW9tZW50LCBvbmx5IGhhdmUgYQpzL0VYUE9S
VF9TWU1CT0wvRVhQT1JUX1NZTUJPTF9HUEwvZykuIEkgYmVsaWV2ZSBmcm9tIHRoZSBjb252ZXJz
YXRpb24KbW9zdCBvZiB0aGUgYWJvdmUgaXMgZm9sbG93IHVwIHdvcmssIGJ1dCBwbGVhc2UgbGV0
IG1lIGtub3cgaWYgeW91J2QKcHJlZmVyIEkgYWRkIHNvbWUgb2YgdGhpcyB0byB0aGUgY3VycmVu
dCBzZXJpZXMhCgpCZXN0ClNhcnRoYWsKCj4gTWlrZQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0
CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9s
aXN0aW5mby9kbS1kZXZlbAo=

