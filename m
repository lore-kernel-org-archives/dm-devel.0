Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 919BAC77B7A
	for <dm-devel@archiver.kernel.org>; Fri, 26 May 2023 01:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685064990;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vtd0wZWEJjMQMit8SM8mW1Lq8jTsW3RgYUjRwHGWIMM=;
	b=DADs5qxdtQCr91XDung2vwb2tTucZegZ5495zr71E97y2e+GgRHqB0oinJKDBuEOZqer0N
	3zpY817IkZ65vJ7wz5N+gRglFAHrlvLLV4BKaCYTBNn0KXqrSURH6oL2acdSbk5kTCwfX7
	Ms2tHheDIGWJFAYOmMNcg1c0pG2rZA0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-cZRl7MbLOHO2n4FhRObhgQ-1; Thu, 25 May 2023 21:36:27 -0400
X-MC-Unique: cZRl7MbLOHO2n4FhRObhgQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10B0E3850549;
	Fri, 26 May 2023 01:36:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 37D4640C6CDD;
	Fri, 26 May 2023 01:36:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 103C219465A4;
	Fri, 26 May 2023 01:36:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1044E19465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 May 2023 01:36:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C59CC1121319; Fri, 26 May 2023 01:36:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BE0661121314
 for <dm-devel@redhat.com>; Fri, 26 May 2023 01:36:15 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99C9F1C07542
 for <dm-devel@redhat.com>; Fri, 26 May 2023 01:36:15 +0000 (UTC)
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com
 [209.85.210.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-wGssXBQqNxCdI-xTLB_F4w-1; Thu, 25 May 2023 21:36:13 -0400
X-MC-Unique: wGssXBQqNxCdI-xTLB_F4w-1
Received: by mail-pf1-f172.google.com with SMTP id
 d2e1a72fcca58-64d30ab1ef2so333879b3a.2
 for <dm-devel@redhat.com>; Thu, 25 May 2023 18:36:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685064973; x=1687656973;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=bR3UToISzSLbX8ZQkHUE42zju/u1Pd13Qxkfw1ihU0s=;
 b=IrJJGP02vhd95BaOW4az00dJqmyIsZnsjoH3+o9YQD4kog5P+kAsCCFAsZvf8TrlkN
 NJV9oSi/ZwqfD0IE5WUECZ6MdHWuENG05MIciGvqiMeGpXpgGZ60vfV7T3fU2No+gNqb
 JnHd5KEas7j2L7EaYQoDwisJsV+oMWgbF41CDjz+diq5mSDrcUymwDY+p66G8Y6oorp2
 E3D5kfLxlcrUCYzJC3SkEjyH3yxKbjWw88G2LOO0jnlNPnG4GiFISd2PYos/50xRHkug
 3aB5K6QI6yr2Yw70f+nfrtK4zZq2CmBCBQ1z5CUdxX0MM/Yp+vBJPTAfVBR4r+qY0XZh
 yc/A==
X-Gm-Message-State: AC+VfDzJPNO8aqt+LFkjKMVRVXwuTw2LSxZLmb5RC5pi/nBpXVZTiSsM
 xVsHprUaDBX/vq4YazdfWiFLzg==
X-Google-Smtp-Source: ACHHUZ6sPdmuQonaj/olpSGroUfK3OoVqwjZ0hrzZiUIv4Qa66jySy12bySeqpIr9yyQSaUMpmfRQA==
X-Received: by 2002:a05:6a00:124a:b0:643:96bc:b292 with SMTP id
 u10-20020a056a00124a00b0064396bcb292mr1061741pfi.5.1685064972718; 
 Thu, 25 May 2023 18:36:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au.
 [49.179.0.188]) by smtp.gmail.com with ESMTPSA id
 g9-20020a62e309000000b0063efe2f3ecdsm1679539pfh.204.2023.05.25.18.36.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 25 May 2023 18:36:11 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1q2MNF-003wt9-15;
 Fri, 26 May 2023 11:36:09 +1000
Date: Fri, 26 May 2023 11:36:09 +1000
From: Dave Chinner <david@fromorbit.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZHANCbnHuhnwCrGz@dread.disaster.area>
References: <ZGeKm+jcBxzkMXQs@redhat.com>
 <ZGgBQhsbU9b0RiT1@dread.disaster.area>
 <ZGu0LaQfREvOQO4h@redhat.com> <ZGzIJlCE2pcqQRFJ@bfoster>
 <ZGzbGg35SqMrWfpr@redhat.com>
 <ZG1dAtHmbQ53aOhA@dread.disaster.area>
 <ZG5taYoXDRymo/e9@redhat.com>
 <ZG9JD+4Zu36lnm4F@dread.disaster.area>
 <ZG+GKwFC7M3FfAO5@redhat.com>
 <CAG9=OMNhCNFhTcktxSMYbc5WXkSZ-vVVPtb4ak6B3Z2-kEVX0Q@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAG9=OMNhCNFhTcktxSMYbc5WXkSZ-vVVPtb4ak6B3Z2-kEVX0Q@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
 Theodore Ts'o <tytso@mit.edu>, dm-devel@redhat.com,
 "Michael S. Tsirkin" <mst@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Brian Foster <bfoster@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBNYXkgMjUsIDIwMjMgYXQgMDM6NDc6MjFQTSAtMDcwMCwgU2FydGhhayBLdWtyZXRp
IHdyb3RlOgo+IE9uIFRodSwgTWF5IDI1LCAyMDIzIGF0IDk6MDDigK9BTSBNaWtlIFNuaXR6ZXIg
PHNuaXR6ZXJAa2VybmVsLm9yZz4gd3JvdGU6Cj4gPiBPbiBUaHUsIE1heSAyNSAyMDIzIGF0ICA3
OjM5UCAtMDQwMCwKPiA+IERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJvbW9yYml0LmNvbT4gd3JvdGU6
Cj4gPiA+IE9uIFdlZCwgTWF5IDI0LCAyMDIzIGF0IDA0OjAyOjQ5UE0gLTA0MDAsIE1pa2UgU25p
dHplciB3cm90ZToKPiA+ID4gPiBPbiBUdWUsIE1heSAyMyAyMDIzIGF0ICA4OjQwUCAtMDQwMCwK
PiA+ID4gPiBEYXZlIENoaW5uZXIgPGRhdmlkQGZyb21vcmJpdC5jb20+IHdyb3RlOgo+ID4gPiA+
ID4gSXQncyB3b3J0aCBub3RpbmcgdGhhdCBYRlMgYWxyZWFkeSBoYXMgYSBjb2Fyc2UtZ3JhaW5l
ZAo+ID4gPiA+ID4gaW1wbGVtZW50YXRpb24gb2YgcHJlZmVycmVkIHJlZ2lvbnMgZm9yIG1ldGFk
YXRhIHN0b3JhZ2UuIEl0IHdpbGwKPiA+ID4gPiA+IGN1cnJlbnRseSBub3QgdXNlIHRob3NlIG1l
dGFkYXRhLXByZWZlcnJlZCByZWdpb25zIGZvciB1c2VyIGRhdGEKPiA+ID4gPiA+IHVubGVzcyBh
bGwgdGhlIHJlbWFpbmluZyB1c2VyIGRhdGEgc3BhY2UgaXMgZnVsbC4gIEhlbmNlIEknbSBwcmV0
dHkKPiA+ID4gPiA+IHN1cmUgdGhhdCBhIHByZS1wcm92aXNpb25pbmcgZW5oYW5jbWVudCBsaWtl
IHRoaXMgY2FuIGJlIGRvbmUKPiA+ID4gPiA+IGVudGlyZWx5IGluLW1lbW9yeSB3aXRob3V0IHJl
cXVpcmluZyBhbnkgbmV3IG9uLWRpc2sgc3RhdGUgdG8gYmUKPiA+ID4gPiA+IGFkZGVkLgo+ID4g
PiA+ID4KPiA+ID4gPiA+IFN1cmUsIGlmIHdlIGNyYXNoIGFuZCByZW1vdW50LCB0aGVuIHdlIG1p
Z2h0IGNob3NlIGEgZGlmZmVyZW50IExCQQo+ID4gPiA+ID4gcmVnaW9uIGZvciBwcmUtcHJvdmlz
aW9uaW5nLiBCdXQgdGhhdCdzIG5vdCByZWFsbHkgYSBodWdlIGRlYWwgYXMgd2UKPiA+ID4gPiA+
IGNvdWxkIGFsc28gcnVuIGFuIGludGVybmFsIGJhY2tncm91bmQgcG9zdC1tb3VudCBmc3RyaW0g
b3BlcmF0aW9uIHRvCj4gPiA+ID4gPiByZW1vdmUgYW55IHVudXNlZCBwcmUtcHJvdmlzaW9uaW5n
IHRoYXQgd2FzIGxlZnQgb3ZlciBmcm9tIHdoZW4gdGhlCj4gPiA+ID4gPiBzeXN0ZW0gd2VudCBk
b3duLgo+ID4gPiA+Cj4gPiA+ID4gVGhpcyB3b3VsZCBiZSB0aGUgRklUUklNIHdpdGggZXh0ZW5z
aW9uIHlvdSBtZW50aW9uIGJlbG93PyBXaGljaCBpcyBhCj4gPiA+ID4gZmlsZXN5c3RlbSBpbnRl
cmZhY2UgZGV0YWlsPwo+ID4gPgo+ID4gPiBOby4gV2UgbWlnaHQgcmV1c2Ugc29tZSBvZiB0aGUg
aW50ZXJuYWwgaW5mcmFzdHJ1Y3R1cmUgd2UgdXNlIHRvCj4gPiA+IGltcGxlbWVudCBGSVRSSU0s
IGJ1dCB0aGF0J3MgYWJvdXQgaXQuIEl0J3MganVzdCBzb21ldGhpbmcga2luZGEKPiA+ID4gbGlr
ZSBGSVRSSU0gYnV0IHdpdGggZGlmZmVyZW50IGNvbnN0cmFpbnRzIGRldGVybWluZWQgYnkgdGhl
Cj4gPiA+IGZpbGVzeXN0ZW0gcmF0aGVyIHRoYW4gdGhlIHVzZXIuLi4KPiA+ID4KPiA+ID4gQXMg
aXQgaXMsIEknbSBub3Qgc3VyZSB3ZSdkIGV2ZW4gbmVlZCBpdCAtIGEgcHJlaW9kaWMgdXNlcnNw
YWNlCj4gPiA+IEZJVFJJTSB3b3VsZCBhY2hlaXZlIHRoZSBzYW1lIHJlc3VsdCwgc28gbGVha2Vk
IHByb3Zpc2lvbmVkIHNwYWNlcwo+ID4gPiB3b3VsZCBnZXQgY2xlYW5lZCB1cCBldmVudHVhbGx5
IHdpdGhvdXQgdGhlIGZpbGVzeXN0ZW0gaGF2aW5nIHRvIGRvCj4gPiA+IGFueXRoaW5nIHNwZWNp
ZmljLi4uCj4gPiA+Cj4gPiA+ID4gU28gZG0tdGhpbnAgd291bGQgX25vdF8gbmVlZCB0byBoYXZl
IG5ldwo+ID4gPiA+IHN0YXRlIHRoYXQgdHJhY2tzICJwcm92aXNpb25lZCBidXQgdW51c2VkIiBi
bG9jaz8KPiA+ID4KPiA+ID4gTm8gaWRlYSAtIHRoYXQncyB5b3VyIGRvbWFpbi4gOikKPiA+ID4K
PiA+ID4gZG0tc25hcHNob3QsIGZvciBjZXJ0YWluLCB3aWxsIG5lZWQgdG8gdHJhY2sgcHJvdmlz
aW9uZWQgcmVnaW9ucwo+ID4gPiBiZWNhdXNlIGl0IGhhcyB0byBndWFyYW50ZWUgdGhhdCBvdmVy
d3JpdGVzIHRvIHByb3Zpc2lvbmVkIHNwYWNlIGluCj4gPiA+IHRoZSBvcmlnaW4gZGV2aWNlIHdp
bGwgYWx3YXlzIHN1Y2NlZWQuIEhlbmNlIGl0IG5lZWRzIHRvIGtub3cgaG93Cj4gPiA+IG11Y2gg
c3BhY2UgYnJlYWtpbmcgc2hhcmluZyBpbiBwcm92aXNpb25lZCByZWdpb25zIGFmdGVyIGEgc25h
cHNob3QKPiA+ID4gaGFzIGJlZW4gdGFrZW4gd2l0aCBiZSByZXF1aXJlZC4uLgo+ID4KPiA+IGRt
LXRoaW5wIG9mZmVycyBpdHMgb3duIG11Y2ggbW9yZSBzY2FsYWJsZSBzbmFwc2hvdCBzdXBwb3J0
IChkb2Vzbid0Cj4gPiB1c2Ugb2xkIGRtLXNuYXBzaG90IE4td2F5IGNvcHlvdXQgdGFyZ2V0KS4K
PiA+Cj4gPiBkbS1zbmFwc2hvdCBpc24ndCBnb2luZyB0byBiZSBtb2RpZmllZCB0byBzdXBwb3J0
IHRoaXMgbGV2ZWwgb2YKPiA+IGhhcmRlbmluZyAoZG0tc25hcHNob3QgaXMgYmFzaWNhbGx5IGlu
ICJtYWludGVuYW5jZSBvbmx5IiBub3cpLgoKQWgsIG9mIGNvdXJzZS4gU29ycnkgZm9yIHRoZSBj
b25mdXNpb24sIEkgd2FzIGtpbmRhIHVzaW5nCmRtLXNuYXBzaG90IGFzIHNob3J0aGFuZCBmb3Ig
ImRtLXRoaW5wICsgc25hcHNob3RzIi4KCj4gPiBCdXQgSSB1bmRlcnN0YW5kIHlvdXIgbWVhbmlu
Zzogd2hhdCB5b3Ugc2FpZCBpcyAxMDAlIGFwcGxpY2FibGUgdG8KPiA+IGRtLXRoaW5wJ3Mgc25h
cHNob3QgaW1wbGVtZW50YXRpb24gYW5kIG5lZWRzIHRvIGJlIGFjY291bnRlZCBmb3IgaW4KPiA+
IHRoaW5wJ3MgbWV0YWRhdGEgKGluaGVyZW50ICdwcm92aXNpb25lZCcgZmxhZykuCgoqbm9kKgoK
PiBBIGJpdCBvcnRob2dvbmFsOiB3b3VsZCBkbS10aGlucCBuZWVkIHRvIGRpZmZlcmVudGlhdGUg
YmV0d2Vlbgo+IHVzZXItdHJpZ2dlcmVkIHByb3Zpc2lvbiByZXF1ZXN0cyAoZWcuIGZyb20gZmFs
bG9jYXRlKCkpIHZzCj4gZnMtdHJpZ2dlcmVkIHJlcXVlc3RzPwoKV2h5PyAgSG93IGlzIHRoZSBn
dWFyYW50ZWUgdGhlIGJsb2NrIGRldmljZSBoYXMgdG8gcHJvdmlkZSB0bwpwcm92aXNpb25lZCBh
cmVhcyBkaWZmZXJlbnQgZm9yIHVzZXIgdnMgZmlsZXN5c3RlbSBpbnRlcm5hbApwcm92aXNpb25l
ZCBzcGFjZT8KCj4gSSB3b3VsZCBsZWFuIHRvd2FyZHMgdXNlciBwcm92aXNpb25lZCBhcmVhcyBu
b3QKPiBnZXR0aW5nIGRlZHVwJ2Qgb24gc25hcHNob3QgY3JlYXRpb24sCgo8dHdpdGNoPgoKU25h
cHNob3R0aW5nIGlzIGEgY2xvbmUgb3BlcmF0aW9uLCBub3QgYSBkZWR1cGUgb3BlcmF0aW9uLgoK
WWVzLCB0aGUgZW5kIHJlc3VsdCBvZiBib3RoIGlzIHRoYXQgeW91IGhhdmUgYSBibG9jayBzaGFy
ZWQgYmV0d2VlbgptdWx0aXBsZSBpbmRleGVzIHRoYXQgbmVlZHMgQ09XIG9uIHRoZSBuZXh0IG92
ZXJ3cml0ZSwgYnV0IHRoZSB0d28Kb3BlcmF0aW9ucyB0aGF0IGdldCB0byB0aGF0IHBvaW50IGFy
ZSB2ZXJ5IGRpZmZlcmVudC4uLgoKPC9wZWRhbnRpYyBtb2RlIGRpc2VnYWdlZD4KCj4gYnV0IHRo
YXQgd291bGQgZW50YWlsIHRyYWNraW5nCj4gdGhlIHN0YXRlIG9mIHRoZSBvcmlnaW5hbCByZXF1
ZXN0IGFuZCBwb3NzaWJseSBhIHByb3Zpc2lvbiByZXF1ZXN0Cj4gZmxhZyAoUkVRX1BST1ZJU0lP
Tl9ERURVUF9PTl9TTkFQU0hPVCkgb3IgYW4gaW52ZXJzZSBmbGFnCj4gKFJFUV9QUk9WSVNJT05f
Tk9ERURVUCkuIFBvc3NpYmx5IHRvbyBjb252b2x1dGVkLi4uCgpMZXQncyBub3QgdHJ5IHRvIGFk
ZCBldmVyeW9uZSdzIGZhdm91cml0ZSBwb255IHRvIHRoaXMgaW50ZXJmYWNlCmJlZm9yZSB3ZSd2
ZSBldmVuIGdvdCBpdCBvZmYgdGhlIGdyb3VuZC4KCkl0J3MgdGhlIHNpbXBsZSBwcmVjaXNpb24g
b2YgdGhlIEFQSSwgdGhlIGxhY2sgb2YgY3Jvc3MtbGF5ZXIKY29tbXVuaWNhdGlvbiByZXF1aXJl
bWVudHMgYW5kIHRoZSBhYmlsaXR5IHRvIGltcGxlbWVudCBhbmQgb3B0aW1pc2UKdGhlIGluZGVw
ZW5kZW50IGxheWVycyBpbmRlcGVuZGVudGx5IHRoYXQgbWFrZXMgdGhpcyBhIHZlcnkKYXBwZWFs
aW5nIHNvbHV0aW9uLgoKV2UgbmVlZCB0byBzdGFydCB3aXRoIGdldHRpbmcgdGhlIHNpbXBsZSBz
dHVmZiB3b3JraW5nIGFuZCBwcm92ZSB0aGUKY29uY2VwdC4gVGhlbiBvbmNlIHdlIGNhbiBvYnNl
cnZlIHRoZSBiZWhhdmlvdXIgb2YgYSB3b3JraW5nIHN5c3RlbQp3ZSBjYW4gc3RhcnQgd29ya2lu
ZyBvbiBvcHRpbWlzaW5nIGluZGl2aWR1YWwgbGF5ZXJzIGZvciBlZmZpY2llbmN5CmFuZCBwZXJm
b3JtYW5jZS4uLi4KCkNoZWVycywKCkRhdmUuCi0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJvbW9y
Yml0LmNvbQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0
cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

