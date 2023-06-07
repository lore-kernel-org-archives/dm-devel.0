Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 104F8C7EE29
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 02:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686103304;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=323XuQOJZeCiGrknexvjSN3pQZmwelIlJRQ3O698la0=;
	b=OqHCebY8E5KrNCMWK9lne/kPgREYZX2dG3GVrK1bzAISrPZBfK1U93KMIeDnLj6decRGlY
	wCCzll8whWfK35cuq0Zz8pIukBJpy7Q4jvilP89Aan6QbQfjgX4DtARreAgN05XE0Mnfpq
	yiyTzXiqVqvhWEX0tHPpW1H8piHOhWA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-aLcpZ5L_NkCPMLqIAV2bfg-1; Tue, 06 Jun 2023 22:01:41 -0400
X-MC-Unique: aLcpZ5L_NkCPMLqIAV2bfg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1116629A9CB4;
	Wed,  7 Jun 2023 02:01:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AAAEC492B00;
	Wed,  7 Jun 2023 02:01:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 53F2A19465BD;
	Wed,  7 Jun 2023 02:01:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 432E019465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 02:01:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CE4579E8D; Wed,  7 Jun 2023 02:01:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C637F7AE4
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 02:01:33 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A53BD801182
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 02:01:33 +0000 (UTC)
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com
 [209.85.210.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-r9idzBmEMv6I9teQrVlzlw-1; Tue, 06 Jun 2023 22:01:32 -0400
X-MC-Unique: r9idzBmEMv6I9teQrVlzlw-1
Received: by mail-ot1-f45.google.com with SMTP id
 46e09a7af769-6b16c53a85aso1954630a34.2
 for <dm-devel@redhat.com>; Tue, 06 Jun 2023 19:01:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686103291; x=1688695291;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=j5Cy8tBCL9F/0/npHcEhwYUjt7WcWHdplqXcZoUtV+0=;
 b=ZmM3QsjVYFk+hocnqCM20GZ2pnuBB7vXtstynXHSxXYdYytOEX1yuK2RA4S/EQ2Ylx
 njgOBJX3jqLieap+9orTukMo8BHGHYx5s5ZKvsZXi5vEfhC+sp58JbwUs9WveM4k9InW
 cnBjw2cSbi90KwH/eHXH1QD2z8OsoETPj8z8lQJkFY8QrBAoLiXkRPPeieyQ7rCHMDCN
 MD1TYeGPvk7/PMQGs6kLyyK653o3SNf+kVZrANPT4+DD+UpxBhdf+cpv8GQQgnznA9vA
 XXsH+TTm7OJQTv0K8+hBjC9r/aQB6ft7qWfT3vq+HUjO/M82cBGQk75ZM4Ag9RvGDPU6
 6b7Q==
X-Gm-Message-State: AC+VfDwXQHtpGEZ13i9JNytRx8zQUhglApM1NHLMHzU3vV/822eqtZeU
 dDW0HrRhmiKQ7eWDCGElXUlZnA==
X-Google-Smtp-Source: ACHHUZ5VYVq+3IAbaiVsgoydY4WCLUW/jBSbIonSM1lHWrf78Rur1YGuoiyya2F8GsBWigs9zYnexA==
X-Received: by 2002:a05:6358:c525:b0:123:4444:e5f8 with SMTP id
 fb37-20020a056358c52500b001234444e5f8mr141321rwb.18.1686103290958; 
 Tue, 06 Jun 2023 19:01:30 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au.
 [49.179.79.151]) by smtp.gmail.com with ESMTPSA id
 q66-20020a17090a1b4800b002533ce5b261sm220132pjq.10.2023.06.06.19.01.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 06 Jun 2023 19:01:29 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1q6iUI-008iUT-2e;
 Wed, 07 Jun 2023 12:01:26 +1000
Date: Wed, 7 Jun 2023 12:01:26 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <ZH/k9ss2Cg9HYrEV@dread.disaster.area>
References: <ZHB954zGG1ag0E/t@dread.disaster.area>
 <CAJ0trDbspRaDKzTzTjFdPHdB9n0Q9unfu1cEk8giTWoNu3jP8g@mail.gmail.com>
 <ZHFEfngPyUOqlthr@dread.disaster.area>
 <CAJ0trDZJQwvAzngZLBJ1hB0XkQ1HRHQOdNQNTw9nK-U5i-0bLA@mail.gmail.com>
 <ZHYB/6l5Wi+xwkbQ@redhat.com>
 <CAJ0trDaUOevfiEpXasOESrLHTCcr=oz28ywJU+s+YOiuh7iWow@mail.gmail.com>
 <ZHYWAGmKhwwmTjW/@redhat.com>
 <CAG9=OMMnDfN++-bJP3jLmUD6O=Q_ApV5Dr392_5GqsPAi_dDkg@mail.gmail.com>
 <ZHqOvq3ORETQB31m@dread.disaster.area>
 <ZHti/MLnX5xGw9b7@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ZHti/MLnX5xGw9b7@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Joe Thornber <thornber@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 linux-kernel@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Sarthak Kukreti <sarthakkukreti@chromium.org>, linux-fsdevel@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Brian Foster <bfoster@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gU2F0LCBKdW4gMDMsIDIwMjMgYXQgMTE6NTc6NDhBTSAtMDQwMCwgTWlrZSBTbml0emVyIHdy
b3RlOgo+IE9uIEZyaSwgSnVuIDAyIDIwMjMgYXQgIDg6NTJQIC0wNDAwLAo+IERhdmUgQ2hpbm5l
ciA8ZGF2aWRAZnJvbW9yYml0LmNvbT4gd3JvdGU6Cj4gCj4gPiBPbiBGcmksIEp1biAwMiwgMjAy
MyBhdCAxMTo0NDoyN0FNIC0wNzAwLCBTYXJ0aGFrIEt1a3JldGkgd3JvdGU6Cj4gPiA+IE9uIFR1
ZSwgTWF5IDMwLCAyMDIzIGF0IDg6MjjigK9BTSBNaWtlIFNuaXR6ZXIgPHNuaXR6ZXJAa2VybmVs
Lm9yZz4gd3JvdGU6Cj4gPiA+ID4KPiA+ID4gPiBPbiBUdWUsIE1heSAzMCAyMDIzIGF0IDEwOjU1
UCAtMDQwMCwKPiA+ID4gPiBKb2UgVGhvcm5iZXIgPHRob3JuYmVyQHJlZGhhdC5jb20+IHdyb3Rl
Ogo+ID4gPiA+Cj4gPiA+ID4gPiBPbiBUdWUsIE1heSAzMCwgMjAyMyBhdCAzOjAy4oCvUE0gTWlr
ZSBTbml0emVyIDxzbml0emVyQGtlcm5lbC5vcmc+IHdyb3RlOgo+ID4gPiA+ID4KPiA+ID4gPiA+
ID4KPiA+ID4gPiA+ID4gQWxzbyBKb2UsIGZvciB5b3UgcHJvcG9zZWQgZG0tdGhpbnAgZGVzaWdu
IHdoZXJlIHlvdSBkaXN0aW5xdWlzaAo+ID4gPiA+ID4gPiBiZXR3ZWVuICJwcm92aXNpb24iIGFu
ZCAicmVzZXJ2ZSI6IFdvdWxkIGl0IG1ha2Ugc2Vuc2UgZm9yIFJFUV9NRVRBCj4gPiA+ID4gPiA+
IChlLmcuIGFsbCBYRlMgbWV0YWRhdGEpIHdpdGggUkVRX1BST1ZJU0lPTiB0byBiZSB0cmVhdGVk
IGFzIGFuCj4gPiA+ID4gPiA+IExCQS1zcGVjaWZpYyBoYXJkIHJlcXVlc3Q/ICBXaGVyZWFzIFJF
UV9QUk9WSVNJT04gb24gaXRzIG93biBwcm92aWRlcwo+ID4gPiA+ID4gPiBtb3JlIGZyZWVkb20g
dG8ganVzdCByZXNlcnZlIHRoZSBsZW5ndGggb2YgYmxvY2tzPyAoZS5nLiBmb3IgWEZTCj4gPiA+
ID4gPiA+IGRlbGFsbG9jIHdoZXJlIExCQSByYW5nZSBpcyB1bmtub3duLCBidXQgZG0tdGhpbnAg
Y2FuIGJlIGFza2VkIHRvCj4gPiA+ID4gPiA+IHJlc2VydmUgc3BhY2UgdG8gYWNjb21vZGF0ZSBp
dCkuCj4gPiA+ID4gPiA+Cj4gPiA+ID4gPgo+ID4gPiA+ID4gTXkgcHJvcG9zYWwgb25seSBpbnZv
bHZlcyAncmVzZXJ2ZScuICBQcm92aXNpb25pbmcgd2lsbCBiZSBkb25lIGFzIHBhcnQgb2YKPiA+
ID4gPiA+IHRoZSB1c3VhbCBpbyBwYXRoLgo+ID4gPiA+Cj4gPiA+ID4gT0ssIEkgdGhpbmsgd2Un
ZCBkbyB3ZWxsIHRvIHBpbiBkb3duIHRoZSB0b3AtbGV2ZWwgYmxvY2sgaW50ZXJmYWNlcyBpbgo+
ID4gPiA+IHF1ZXN0aW9uLiBCZWNhdXNlIHRoaXMgcGF0Y2hzZXQncyBibG9jayBpbnRlcmZhY2Ug
cGF0Y2ggKDIvNSkgaGVhZGVyCj4gPiA+ID4gc2F5czoKPiA+ID4gPgo+ID4gPiA+ICJUaGlzIHBh
dGNoIGFsc28gYWRkcyB0aGUgY2FwYWJpbGl0eSB0byBjYWxsIGZhbGxvY2F0ZSgpIGluIG1vZGUg
MAo+ID4gPiA+IG9uIGJsb2NrIGRldmljZXMsIHdoaWNoIHdpbGwgc2VuZCBSRVFfT1BfUFJPVklT
SU9OIHRvIHRoZSBibG9jawo+ID4gPiA+IGRldmljZSBmb3IgdGhlIHNwZWNpZmllZCByYW5nZSwi
Cj4gPiA+ID4KPiA+ID4gPiBTbyBpdCB3aXJlcyB1cCBibGtkZXZfZmFsbG9jYXRlKCkgdG8gY2Fs
bCBibGtkZXZfaXNzdWVfcHJvdmlzaW9uKCkuIEEKPiA+ID4gPiB1c2VyIG9mIFhGUyBjb3VsZCB0
aGVuIHVzZSBmYWxsb2NhdGUoKSBmb3IgdXNlciBkYXRhIC0tIHdoaWNoIHdvdWxkCj4gPiA+ID4g
Y2F1c2UgdGhpbnAncyByZXNlcnZlIHRvIF9ub3RfIGJlIHVzZWQgZm9yIGNyaXRpY2FsIG1ldGFk
YXRhLgo+ID4gCj4gPiBNaWtlLCBJIHRoaW5rIHlvdSBtaWdodCBoYXZlIG1pc3VuZGVyc3Rvb2Qg
d2hhdCBJIGhhdmUgYmVlbiBwcm9wb3NpbmcuCj4gPiBQb3NzaWJseSB1bmludGVudGlvbmFsbHks
IEkgZGlkbid0IGNhbGwgaXQgUkVRX09QX1BST1ZJU0lPTiBidXQKPiA+IHRoYXQncyB3aGF0IEkg
aW50ZW5kZWQgLSB0aGUgb3BlcmF0aW9uIGRvZXMgbm90IGNvbnRhaW4gZGF0YSBhdCBhbGwuCj4g
PiBJdCdzIGFuIG9wZXJhdGlvbiBsaWtlIFJFUV9PUF9ESVNDQVJEIG9yIFJFUV9PUF9XUklURV9a
RVJPUyAtIGl0Cj4gPiBjb250YWlucyBhIHJhbmdlIG9mIHNlY3RvcnMgdGhhdCBuZWVkIHRvIGJl
IHByb3Zpc2lvbmVkIChvcgo+ID4gZGlzY2FyZGVkKSwgYW5kIG5vdGhpbmcgZWxzZS4KPiAKPiBO
bywgSSB1bmRlcnN0b29kIHRoYXQuCj4gCj4gPiBUaGUgd3JpdGUgSU9zIHRoZW1zZWx2ZXMgYXJl
IG5vdCB0YWdnZWQgd2l0aCBhbnl0aGluZyBzcGVjaWFsIGF0IGFsbC4KPiAKPiBJIGtub3csIGJ1
dCBJJ3ZlIGJlZW4gbG9va2luZyBhdCBob3cgdG8gYWxzbyBoYW5kbGUgdGhlIGRlbGFsbG9jCj4g
dXNlY2FzZSAoYW5kIHllcyBJIGtub3cgeW91IGZlZWwgaXQgZG9lc24ndCBuZWVkIGhhbmRsaW5n
LCB0aGUgaXNzdWUKPiBpcyBYRlMgZG9lcyBkZWFsIG5pY2VseSB3aXRoIGVuc3VyaW5nIGl0IGhh
cyBzcGFjZSB3aGVuIGl0IHRyYWNrcyBpdHMKPiBhbGxvY2F0aW9ucyBvbiAidGhpY2siIHN0b3Jh
Z2UKCk9oLCBubyBpdCBkb2Vzbid0LiBJdCAtd29ya3MgZm9yIG1vc3QgY2FzZXMtLCBidXQgdGhh
dCBkb2VzIG5vdCBtZWFuCml0IHByb3ZpZGVzIGFueSBndWFyYW50ZWVzIGF0IGFsbC4gV2UgY2Fu
IHN0aWxsIGdldCBFTk9TUEMgZm9yIHVzZXIKZGF0YSB3aGVuIGRlbGF5ZWQgYWxsb2NhdGlvbiBy
ZXNlcnZhdGlvbnMgInJ1biBvdXQiLgoKVGhpcyBtYXkgYmUgbmV3cyB0byB5b3UsIGJ1dCB0aGUg
ZXBoZW1lcmFsIFhGUyBkZWxheWVkIGFsbG9jYXRpb24Kc3BhY2UgcmVzZXJ2YXRpb24gaXMgbm90
IGFjY3VyYXRlLiBJdCBjb250YWlucyBhICJmdWRnZSBmYWN0b3IiCmNhbGxlZCAiaW5kaXJlY3Qg
bGVuZ3RoIi4gVGhpcyBpcyBhICJ3ZXQgZmluZ2VyIGluIHRoZSB3aW5kIgplc3RpbWF0aW9uIG9m
IGhvdyBtdWNoIG5ldyBtZXRhZGF0YSB3aWxsIG5lZWQgdG8gYmUgYWxsb2NhdGVkIHRvCmluZGV4
IHRoZSBwaHlzaWNhbCBhbGxvY2F0aW9ucyB3aGVuIHRoZXkgYXJlIG1hZGUuIEl0IGFzc3VtZXMg
bGFyZ2UKZGF0YSBleHRlbnRzIGFyZSBhbGxvY2F0ZWQsIHdoaWNoIGlzIGdvb2QgZW5vdWdoIGZv
ciBtb3N0IGNhc2VzLCBidXQKaXQgaXMgbm8gZ3VhcmFudGVlIHdoZW4gdGhlcmUgYXJlIG5vIGxh
cmdlIGRhdGEgZXh0ZW50cyBhdmFpbGFibGUgdG8KYWxsb2NhdGUgKGUuZy4gbmVhciBFTk9TUEMh
KS4KCkFuZCB0aGVyZWluIGxpZXMgdGhlIGZ1bmRhbWVudGFsIHByb2JsZW0gd2l0aCBlcGhlbWVy
YWwgcmFuZ2UKcmVzZXJ2YXRpb25zOiBhdCB0aGUgdGltZSBvZiByZXNlcnZhdGlvbiwgd2UgZG9u
J3Qga25vdyBob3cgbWFueQppbmRpdmlkdWFsIHBoeXNpY2FsIExCQSByYW5nZXMgdGhlIHJlc2Vy
dmVkIGRhdGEgcmFuZ2UgaXMgYWN0dWFsbHkKZ29pbmcgdG8gc3Bhbi4KCkFzIGEgcmVzdWx0LCBY
RlMgZGVsYWxsb2MgcmVzZXJ2YXRpb25zIGFyZSBhICJjbG9zZS1idXQtbm90LXF1aXRlIgpyZXNl
cnZhdGlvbiBiYWNrZWQgYnkgYSBnbG9iYWwgcmVzZXJ2ZSBwb29sIHRoYXQgY2FuIGJlIGRpcHBl
ZCBpbnRvCmlmIHdlIHJ1biBvdXQgb2YgZGVsYWxsb2MgcmVzZXJ2YXRpb24uIElmIHRoZSByZXNl
cnZlIHBvb2wgaXMgdGhlbgpmdWxseSBkZXBsZXRlZCBiZWZvcmUgYWxsIGRlbGFsbG9jIGNvbnZl
cnNpb24gY29tcGxldGVzLCB3ZSdsbCBzdGlsbApnaXZlIEVOT1NQQy4gVGhlIHBvb2wgaXMgc2l6
ZWQgc3VjaCB0aGF0IHRoZSB2YXN0IG1ham9yaXR5IG9mCndvcmtsb2FkcyB3aWxsIGNvbXBsZXRl
IGRlbGFsbG9jIGNvbnZlcnNpb24gc3VjY2Vzc2Z1bGx5IGJlZm9yZSB0aGUKcG9vbCBpcyBkZXBs
ZXRlZC4KCkhlbmNlIFhGUyBnaXZlcyBldmVyeW9uZSB0aGUgLWFwcGVhcmFuY2UtIHRoYXQgaXQg
ZGVhbHMgbmljZWx5IHdpdGgKRU5PU1BDIGNvbmRpdGlvbnMsIGJ1dCBpdCBuZXZlciBwcm92aWRl
cyBhIC1ndWFyYW50ZWUtIHRoYXQgYW55CmFjY2VwdGVkIHdyaXRlIHdpbGwgYWx3YXlzIHN1Y2Nl
ZWQgd2l0aG91dCBFTk9TUEMuCgpJTU8sIHVzaW5nIHRoaXMgImNsb3NlLWJ1dC1ub3QtcXVpdGUi
IHJlc2VydmF0aW9uIGFzIHRoZSBiYXNpcyBvZgpzcGFjZSByZXF1aXJlbWVudHMgZm9yIG90aGVy
IGxheWVycyB0byBwcm92aWRlICJ3b24ndCBFTk9TUEMiCmd1YXJhbnRlZXMgaXMgZnJhdWdodCB3
aXRoIHByb2JsZW1zLiBXZSBhbHJlYWR5IGtub3cgdGhhdCBpdCBpcwppbnN1ZmZpY2llbnQgaW4g
aW1wb3J0YW50IGNvcm5lciBjYXNlcyBhdCB0aGUgZmlsZXN5c3RlbSBsZXZlbCwgYW5kCndlIGFs
c28ga25vdyB0aGF0IGxvd2VyIGxheWVycyB0cnlpbmcgdG8gZG8gZXBoZW1lcmFsIHNwYWNlCnJl
c2VydmF0aW9ucyB3aWxsIGhhdmUgZXhhY3RseSB0aGUgc2FtZSBwcm9ibGVtcyBwcm92aWRpbmcg
YQpndWFyYW50ZWUuIEFuZCB0aGVzZSBhcmUgcHJvYmxlbXMgd2UndmUgYmVlbiB1bmFibGUgdG8g
ZW5naW5lZXIKYXJvdW5kIGluIHRoZSBwYXN0LCBzbyB0aGUgbGlrZWxpaG9vZCB3ZSBjYW4gZW5n
aW5lZXIgYXJvdW5kIHRoZW0Kbm93IG9yIGluIHRoZSBmdXR1cmUgaXMgYWxzbyB2ZXJ5IHVubGlr
ZWx5LgoKPiAtLSBzbyBhZGRpbmcgY29vcmRpbmF0aW9uIGJldHdlZW4gWEZTCj4gYW5kIGRtLXRo
aW4gbGF5ZXJzIHByb3ZpZGVzIGNvbXBhcmFibGUgc2FmZXR5Li4gdGhhdCBzYWZldHkgaXMgYW4K
PiBleHBlY3RlZCBub3JtKS4KPgo+IEJ1dCByYXRoZXIgdGhhbiBkaXNjdXNzIGluIHRlcm1zIG9m
IGRhdGEgdnMgbWV0YWRhdGEsIHRoZSBkaXN0aW5jdGlvbgo+IGlzOgo+IDEpIExCQSByYW5nZSBy
ZXNlcnZhdGlvbiAobm9ybWFsIGNhc2UsIHlvdXIgcHJvcG9zYWwpCj4gMikgbm9uLUxCQSByZXNl
cnZhdGlvbiAoYWJzb2x1dGUgdmFsdWUsIExCQSByYW5nZSBpcyBrbm93biBhdCBsYXRlciBzdGFn
ZSkKPiAKPiBCdXQgSSdtIGNsZWFybHkgZ29pbmcgb2ZmIHNjcmlwdCBmb3IgZHdlbGxpbmcgb24g
d2FudGluZyB0byBoYW5kbGUKPiBib3RoLgoKUmlnaHQsIGJlY2F1c2UgaWYgd2UgZG8gMSkgdGhl
biB3ZSBkb24ndCBuZWVkIDIpLiA6KQoKPiBNeSBsb29raW5nIGF0IChhYil1c2luZyBSRVFfTUVU
QSBiZWluZyBzZXQgKHVzZSAxKSB2cyBub3QgKHVzZSAyKSB3YXMKPiBhIGNydWRlIHNpbXBsaWZp
Y2F0aW9uIGZvciBicmFuY2hpbmcgYmV0d2VlbiB0aGUgMiBhcHByb2FjaGVzLgo+IAo+IEFuZCBJ
IHVuZGVyc3RhbmQgSSBtYWRlIHlvdSBuZXJ2b3VzIGJ5IGV4cGFuZGluZyB0aGUgc2NvcGUgdG8g
YSBtdWNoCj4gbW9yZSBtdWRkbGVkL3NoaXR0eSBpbnRlcmZhY2UuIDspCgpOZXJ2b3VzPyBObywg
SSdtIHNpbXBseSB0cnlpbmcgdG8gbWFrZSBzdXJlIHRoYXQgZXZlcnlvbmUgaXMgb24gdGhlCnNh
bWUgcGFnZS4gaS5lLiB0aGF0IGlmIHdlIHdhdGVyIGRvd24gdGhlIGd1YXJhbnRlZSB0aGF0IDEp
IHJlbGllcwpvbiwgdGhlbiBpdCdzIG5vdCBhY3R1YWxseSB1c2VmdWwgdG8gZmlsZXN5c3RlbXMg
YXQgYWxsLgoKPiA+IEl0J3MganVzdCBub3QgcHJhY3RpY2FsIGZvciB0aGUgYmxvY2sgZGV2aWNl
IHRvIGFkZCBhcmJpdHJhcnkKPiA+IGNvbnN0cmFpbnRzIGJhc2VkIG9uIHRoZSB0eXBlIG9mIElP
IGJlY2F1c2Ugd2UgdGhlbiBoYXZlIHRvIGFkZAo+ID4gbWVjaGFuaXNtcyB0byB1c2Vyc3BhY2Ug
QVBJcyB0byBhbGxvdyB0aGVtIHRvIGNvbnRyb2wgdGhlIElPIGNvbnRleHQKPiA+IHNvIHRoZSBi
bG9jayBkZXZpY2Ugd2lsbCBkbyB0aGUgcmlnaHQgdGhpbmcuIEVzcGVjaWFsbHkgY29uc2lkZXJp
bmcKPiA+IHdlIHJlYWxseSBvbmx5IG5lZWQgb25lIHR5cGUgb2YgZ3VhcmFudGVlIHJlZ2FyZGxl
c3Mgb2Ygd2hlcmUgdGhlIElPCj4gPiBvcmlnaW5hdGVzIGZyb20gb3Igd2hhdCB0eXBlIG9mIGRh
dGEgdGhlIElPIGNvbnRhaW5zLi4uLgo+IAo+IElmIGFueXRoaW5nIG15IGRpc3Bvc2l0aW9uIG9u
IHRoZSBjb25kaXRpb25hbCB0byByZXF1aXJlIGEgUkVRX01FVEEKPiAob3Igc29tZSBmYWxsb2Nh
dGUgZ2VuZXJhdGVkIFJFUV9VTlNIQVJFIGRpdHRvIHRvIHJlZmxlY3QgdGhlIHNhbWUpIHRvCj4g
cGVyZm9ybSB5b3VyIGFwcHJvYWNoIHRvIFJFUV9PUF9QUk9WSVNJT04gYW5kIGhvbm9yIGZhbGxv
Y2F0ZSgpCj4gcmVxdWlyZW1lbnRzIGlzIGEgYmlnIHByb2JsZW0uICBXb3VsZCBiZSBtdWNoIGJl
dHRlciB0byBoYXZlIGEgZmxhZyB0bwo+IGV4cHJlc3MgInRoaXMgcmVzZXJ2YXRpb24gZG9lcyBu
b3QgaGF2ZSBhbiBMQkEgcmFuZ2UgX3lldF8sCj4gbmV2ZXJ0aGVsZXNzIHRyeSB0byBiZSBtaW5k
ZnVsIG9mIHRoaXMgZXhwZWN0ZWQgbmVhci10ZXJtIGJsb2NrCj4gYWxsb2NhdGlvbiIuCgpBbmQg
dGhhdCdzIHdoZXJlIGFsbCB0aGUgY29tcGxleGl0eSBzdGFydHMgOykKCj4gPiBQdXQgc2ltcGx5
OiBpZiB3ZSByZXN0cmljdCBSRVFfT1BfUFJPVklTSU9OIGd1YXJhbnRlZXMgdG8ganVzdAo+ID4g
UkVRX01FVEEgd3JpdGVzIChvciBhbnkgb3RoZXIgc3BlY2lmaWMgdHlwZSBvZiB3cml0ZSBvcGVy
YXRpb24pIHRoZW4KPiA+IGl0J3Mgc2ltcGx5IG5vdCB3b3J0aCBwZXJzdWluZyBhdCB0aGUgZmls
ZXN5c3RlbSBsZXZlbCBiZWNhdXNlIHRoZQo+ID4gZ3VhcmFudGVlcyB3ZSBhY3R1YWxseSBuZWVk
IGp1c3QgYXJlbid0IHRoZXJlIGFuZCB0aGUgY29tcGxleGl0eSBvZgo+ID4gZGlzY292ZXJpbmcg
YW5kIGhhbmRsaW5nIHRob3NlIGNvcm5lciBjYXNlcyBqdXN0IGlzbid0IHdvcnRoIHRoZQo+ID4g
ZWZmb3J0Lgo+IAo+IEhlcmUgaXMgd2hlcmUgSSBnZXQgdG8gc2F5OiBJIHRoaW5rIHlvdSBtaXN1
bmRlcnN0b29kIG1lIChidXQgaXQgd2FzCj4gbXkgZmF1bHQgZm9yIG5vdCBiZWluZyBhYnNvbHV0
ZWx5IGNsZWFyOiBJJ20gdmVyeSBtdWNoIG9uIHRoZSBzYW1lCj4gcGFnZSBhcyB5b3UgYW5kIEpv
ZTsgYW5kIHlvdXIgdmlzaW9ucyBuZWVkIHRvIGp1c3QgYmUgaW1wbGVtZW50ZWQKPiBBU0FQKS4K
Ck9LLCBnb29kIHRoYXQgd2UndmUgY2xhcmlmaWVkIHRoZSBtaXN1bmRlcnN0YW5kaW5ncyBvbiBi
b3RoIHNpZGVzCnF1aWNrbHkgOikKCj4gSSB3YXMgdGFraW5nIHlvdXIgZGVzaWducyBhcyBhIGdp
dmVuLCBidXQgbG9va2luZyBmdXJ0aGVyIGF0OiBob3cgZG8KPiB3ZSBhbHNvIGhhbmRsZSB0aGUg
bm9uLUxCQSAoZGVsYWxsb2MpIHVzZWNhc2UgX2JlZm9yZV8gd2UgaW5jbHVkZQo+IFJFUV9PUF9Q
Uk9WSVNJT04gaW4ga2VybmVsLgo+IAo+IEJ1dCBJJ20gaGFwcHkgdG8gbGV0IHRoZSBkZWxhbGxv
YyBjYXNlIGdvICh3ZSBjYW4gcmV2aXNpdCBhZGRyZXNzaW5nCj4gaXQgaWYvd2hlbiBuZWVkZWQp
LgoKQWdhaW4sIEkgcmVhbGx5IGRvbid0IHRoaW5rIGZpbGVzeXN0ZW0gZGVsYWxsb2MgcmFuZ2Vz
IGV2ZXIgbmVlZCB0bwpiZSBjb3ZlcmVkIGJ5IGJsb2NrIGRldmljZSBwcm92aXNpb25pbmcgZ3Vh
cmFudGVlcyBiZWNhdXNlIHRoZQpmaWxlc3lzdGVtIGl0c2VsZiBwcm92aWRlcyBubyBndWFyYW50
ZWVzIGZvciB1bnByb3Zpc2lvbmVkIHdyaXRlcy4KCkkgc3VzcGVjdCB0aGF0IGlmLCBpbiBmdXR1
cmUsIHdlIHdhbnQgdG8gbWFuYWdlIHVucHJvdmlzaW9uZWQgc3BhY2UKaW4gZGlmZmVyZW50IHdh
eXMsIHdlJ3JlIGJldHRlciBvZmYgdGFraW5nIHRoaXMgc29ydCBvZiBhcHByb2FjaDoKCmh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXhmcy8yMDE3MTAyNjA4MzMyMi4yMDQyOC0xLWRhdmlk
QGZyb21vcmJpdC5jb20vCgpiZWNhdXNlIHVzaW5nIGdyb3cvc2hyaW5rIHRvIG1hbmFnZSB0aGUg
ZmlsZXN5c3RlbSdzIHVucHJvdmlzaW9uZWQKc3BhY2UgaWYgZmFyLCBmYXIgc2ltcGxlciB0aGFu
IHRyeWluZyB0byB1c2UgZHluYW1pYywgY3Jvc3MgbGF5ZXIKZXBoZW1lcmFsIHJlc2VydmF0aW9u
cy4gIEluZGVlZCwgd2l0aCB0aGUgYmxvY2sgZGV2aWNlIGZpbGVzeXN0ZW0Kc2h1dGRvd24gcGF0
aCBDaHJpc3RvcGggcmVjZW50bHkgcG9zdGVkLCB3ZSBoYXZlIGEgbW9kZWwgZm9yIGFkZGluZwpp
bi1rZXJuZWwgZmlsZXN5c3RlbSBjb250cm9sIGludGVyZmFjZXMgZm9yIGJsb2NrIGRldmljZXMu
Li4KClRoZXJlJ3Mgc29tZXRoaW5nIHRvIGJlIHNhaWQgZm9yIHR1cm5pbmcgZXZlcnl0aGluZyB1
cHNpZGUgZG93bgpvY2Nhc2lvbmFsbHkuIDopCgpDaGVlcnMsCgpEYXZlLgotLSAKRGF2ZSBDaGlu
bmVyCmRhdmlkQGZyb21vcmJpdC5jb20KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZl
bEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWwK

