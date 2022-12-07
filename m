Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63028C352A1
	for <dm-devel@archiver.kernel.org>; Wed,  7 Dec 2022 03:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670382975;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=s+1u3Qspyybs2NeMUyt/bH+qUX9ykyWPuku4SVTQwUo=;
	b=JA2lpAWy9a245+ra2/PN5svlWXUDaGoVmdSKCrFyOXoQYpTEwymeg8cbBmJCFLxA2sbGAV
	xnyLS3cL4L2D8f0vBDVz7+MjtBpkEyoH21VOIP33C2j+jaET6TvVbdM6m2KbKM92dSIQPb
	AzQvMzxs7VAJWsLCLS28tNBsOVSzYyc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-533-wdvt5SeJOoujUWLmB7T85g-1; Tue, 06 Dec 2022 22:16:12 -0500
X-MC-Unique: wdvt5SeJOoujUWLmB7T85g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05F731C0514F;
	Wed,  7 Dec 2022 03:16:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4282740C6EC2;
	Wed,  7 Dec 2022 03:16:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2088119465A0;
	Wed,  7 Dec 2022 03:16:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 332261946586
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Dec 2022 03:16:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C7DC99E70; Wed,  7 Dec 2022 03:16:05 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A29517AE5;
 Wed,  7 Dec 2022 03:15:49 +0000 (UTC)
Date: Wed, 7 Dec 2022 11:15:43 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <Y5AFX4sxLRLV4uSt@T590>
References: <20221206181536.13333-1-gulam.mohamed@oracle.com>
 <936a498b-19fe-36d5-ff32-817f153e57e3@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <936a498b-19fe-36d5-ff32-817f153e57e3@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [RFC] block: Change the granularity of io ticks from
 ms to ns
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
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, song@kernel.org,
 dm-devel@redhat.com, ira.weiny@intel.com, agk@redhat.com,
 drbd-dev@lists.linbit.com, dave.jiang@intel.com,
 christoph.boehmwalder@linbit.com, vishal.l.verma@intel.com,
 konrad.wilk@oracle.com, "yukuai \(C\)" <yukuai3@huawei.com>,
 kent.overstreet@gmail.com, ngupta@vflare.org, kch@nvidia.com,
 senozhatsky@chromium.org, Gulam Mohamed <gulam.mohamed@oracle.com>,
 snitzer@kernel.org, colyli@suse.de, linux-block@vger.kernel.org,
 linux-bcache@vger.kernel.org, dan.j.williams@intel.com, axboe@kernel.dk,
 linux-raid@vger.kernel.org, martin.petersen@oracle.com,
 philipp.reisner@linbit.com, junxiao.bi@oracle.com, minchan@kernel.org,
 lars.ellenberg@linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBEZWMgMDcsIDIwMjIgYXQgMTA6MTk6MDhBTSArMDgwMCwgWXUgS3VhaSB3cm90ZToK
PiBIaSwKPiAKPiDlnKggMjAyMi8xMi8wNyAyOjE1LCBHdWxhbSBNb2hhbWVkIOWGmemBkzoKPiA+
IFVzZSBrdGltZSB0byBjaGFuZ2UgdGhlIGdyYW51bGFyaXR5IG9mIElPIGFjY291bnRpbmcgaW4g
YmxvY2sgbGF5ZXIgZnJvbQo+ID4gbWlsbGktc2Vjb25kcyB0byBuYW5vLXNlY29uZHMgdG8gZ2V0
IHRoZSBwcm9wZXIgbGF0ZW5jeSB2YWx1ZXMgZm9yIHRoZQo+ID4gZGV2aWNlcyB3aG9zZSBsYXRl
bmN5IGlzIGluIG1pY3JvLXNlY29uZHMuIEFmdGVyIGNoYW5naW5nIHRoZSBncmFudWxhcml0eQo+
ID4gdG8gbmFuby1zZWNvbmRzIHRoZSBpb3N0YXQgY29tbWFuZCwgd2hpY2ggd2FzIHNob3dpbmcg
aW5jb3JyZWN0IHZhbHVlcyBmb3IKPiA+ICV1dGlsLCBpcyBub3cgc2hvd2luZyBjb3JyZWN0IHZh
bHVlcy4KPiAKPiBUaGlzIHBhdGNoIGRpZG4ndCBjb3JyZWN0IHRoZSBjb3VudGluZyBvZiBpb190
aWNrcywganVzdCBtYWtlIHRoZQo+IGVycm9yIGFjY291bnRpbmcgZnJvbSBqaWZmaWVzKG1zKSB0
byBucy4gVGhlIHByb2JsZW0gdGhhdCB1dGlsIGNhbiBiZQo+IHNtYWxsZXIgb3IgbGFyZ2VyIHN0
aWxsIGV4aXN0LgoKQWdyZWUuCgo+IAo+IEhvd2V2ZXIsIEkgdGhpbmsgdGhpcyBjaGFuZ2UgbWFr
ZSBzZW5zZSBjb25zaWRlciB0aGF0IGVycm9yIG1hcmdpbiBpcwo+IG11Y2ggc21hbGxlciwgYW5k
IHBlcmZvcm1hbmNlIG92ZXJoZWFkIHNob3VsZCBiZSBtaW5pbXVtLgo+IAo+IEhpLCBNaW5nLCBo
b3cgZG8geW91IHRoaW5rPwoKSSByZW1lbWJlcmVkIHRoYXQga3RpbWVfZ2V0KCkgaGFzIG5vbi1u
ZWdsaWdpYmxlIG92ZXJoZWFkLCBpcyB0aGVyZSBhbnkKdGVzdCBkYXRhKGlvcHMvY3B1IHV0aWxp
emF0aW9uKSB3aGVuIHJ1bm5pbmcgZmlvIG9yIHQvaW9fdXJpbmcgb24KbnVsbF9ibGsgd2l0aCB0
aGlzIHBhdGNoPwoKClRoYW5rcywgCk1pbmcKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRl
dmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbAo=

