Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6F91C63709
	for <dm-devel@archiver.kernel.org>; Thu,  8 Dec 2022 00:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670459836;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=X/pnzw7XN5ShS1A4e/VdiHvdOwhqFWBS9SmBGtI3MyA=;
	b=TVQHSpp/PSfm0b85a0LOZFMT9zOeLOBApC1JivykEv6kThn2kULEC5y2UMNFP1dGO7xwl1
	jFM2NLrKmCZZ7wEYZEL2rcknsnMqcnLhYvtsHNOJ8500w69baVzIwnAHj9B014AO3cNFdC
	H2uyVPYIcCQ3rMPfICbSvMngVK9niAs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-WnzzJ8WvMF6gs6yQ0aJRHQ-1; Wed, 07 Dec 2022 19:37:13 -0500
X-MC-Unique: WnzzJ8WvMF6gs6yQ0aJRHQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2F1D1C05ACE;
	Thu,  8 Dec 2022 00:37:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 93316492B04;
	Thu,  8 Dec 2022 00:37:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 66F5719465B9;
	Thu,  8 Dec 2022 00:37:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BA83819465B1
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Dec 2022 00:37:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5A535112131E; Thu,  8 Dec 2022 00:37:10 +0000 (UTC)
Received: from T590 (ovpn-8-18.pek2.redhat.com [10.72.8.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 247241121314;
 Thu,  8 Dec 2022 00:36:54 +0000 (UTC)
Date: Thu, 8 Dec 2022 08:36:49 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Gulam Mohamed <gulam.mohamed@oracle.com>
Message-ID: <Y5ExoZ+7Am6Nm8+h@T590>
References: <20221207223204.22459-1-gulam.mohamed@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20221207223204.22459-1-gulam.mohamed@oracle.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [RFC for-6.2/block V2] block: Change the granularity
 of io ticks from ms to ns
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
 drbd-dev@lists.linbit.com, dave.jiang@intel.com, minchan@kernel.org,
 vishal.l.verma@intel.com, konrad.wilk@oracle.com, joe.jin@oracle.com,
 kent.overstreet@gmail.com, ngupta@vflare.org, kch@nvidia.com,
 senozhatsky@chromium.org, snitzer@kernel.org, colyli@suse.de,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 dan.j.williams@intel.com, ming.lei@redhat.com, axboe@kernel.dk,
 linux-raid@vger.kernel.org, martin.petersen@oracle.com,
 philipp.reisner@linbit.com, junxiao.bi@oracle.com,
 christoph.boehmwalder@linbit.com, lars.ellenberg@linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBEZWMgMDcsIDIwMjIgYXQgMTA6MzI6MDRQTSArMDAwMCwgR3VsYW0gTW9oYW1lZCB3
cm90ZToKPiBBcyBwZXIgdGhlIHJldmlldyBjb21tZW50IGZyb20gSmVucyBBeGJvZSwgSSBhbSBy
ZS1zZW5kaW5nIHRoaXMgcGF0Y2gKPiBhZ2FpbnN0ICJmb3ItNi4yL2Jsb2NrIi4KPiAKPiAKPiBV
c2Uga3RpbWUgdG8gY2hhbmdlIHRoZSBncmFudWxhcml0eSBvZiBJTyBhY2NvdW50aW5nIGluIGJs
b2NrIGxheWVyIGZyb20KPiBtaWxsaS1zZWNvbmRzIHRvIG5hbm8tc2Vjb25kcyB0byBnZXQgdGhl
IHByb3BlciBsYXRlbmN5IHZhbHVlcyBmb3IgdGhlCj4gZGV2aWNlcyB3aG9zZSBsYXRlbmN5IGlz
IGluIG1pY3JvLXNlY29uZHMuIEFmdGVyIGNoYW5naW5nIHRoZSBncmFudWxhcml0eQo+IHRvIG5h
bm8tc2Vjb25kcyB0aGUgaW9zdGF0IGNvbW1hbmQsIHdoaWNoIHdhcyBzaG93aW5nIGluY29ycmVj
dCB2YWx1ZXMgZm9yCj4gJXV0aWwsIGlzIG5vdyBzaG93aW5nIGNvcnJlY3QgdmFsdWVzLgoKUGxl
YXNlIGFkZCB0aGUgdGhlb3J5IGJlaGluZCB3aHkgdXNpbmcgbmFuby1zZWNvbmRzIGNhbiBnZXQg
Y29ycmVjdCBhY2NvdW50aW5nLgoKPiAKPiBXZSBkaWQgbm90IHdvcmsgb24gdGhlIHBhdGNoIHRv
IGRyb3AgdGhlIGxvZ2ljIGZvcgo+IFNUQVRfUFJFQ0lTRV9USU1FU1RBTVBTIHlldC4gV2lsbCBk
byBpdCBpZiB0aGlzIHBhdGNoIGlzIG9rLgo+IAo+IFRoZSBpb3N0YXQgY29tbWFuZCB3YXMgcnVu
IGFmdGVyIHN0YXJ0aW5nIHRoZSBmaW8gd2l0aCBmb2xsb3dpbmcgY29tbWFuZAo+IG9uIGFuIE5W
TUUgZGlzay4gRm9yIHRoZSBzYW1lIGZpbyBjb21tYW5kLCB0aGUgaW9zdGF0ICV1dGlsIHdhcyBz
aG93aW5nCj4gfjEwMCUgZm9yIHRoZSBkaXNrcyB3aG9zZSBsYXRlbmNpZXMgYXJlIGluIHRoZSBy
YW5nZSBvZiBtaWNyb3NlY29uZHMuCj4gV2l0aCB0aGUga2VybmVsIGNoYW5nZXMgKGdyYW51bGFy
aXR5IHRvIG5hbm8tc2Vjb25kcyksIHRoZSAldXRpbCB3YXMKPiBzaG93aW5nIGNvcnJlY3QgdmFs
dWVzLiBGb2xsb3dpbmcgYXJlIHRoZSBkZXRhaWxzIG9mIHRoZSB0ZXN0IGFuZCB0aGVpcgo+IG91
dHB1dDoKPiAKPiBmaW8gY29tbWFuZAo+IC0tLS0tLS0tLS0tCj4gW2dsb2JhbF0KPiBicz0xMjhL
Cj4gaW9kZXB0aD0xCj4gZGlyZWN0PTEKPiBpb2VuZ2luZT1saWJhaW8KPiBncm91cF9yZXBvcnRp
bmcKPiB0aW1lX2Jhc2VkCj4gcnVudGltZT05MAo+IHRoaW5rdGltZT0xbXMKPiBudW1qb2JzPTEK
PiBuYW1lPXJhdy13cml0ZQo+IHJ3PXJhbmRydwo+IGlnbm9yZV9lcnJvcj1FSU86RUlPCj4gW2pv
YjFdCj4gZmlsZW5hbWU9L2Rldi9udm1lMG4xCj4gCj4gQ29ycmVjdCB2YWx1ZXMgYWZ0ZXIga2Vy
bmVsIGNoYW5nZXM6Cj4gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Cj4gaW9z
dGF0IG91dHB1dAo+IC0tLS0tLS0tLS0tLS0KPiBpb3N0YXQgLWQgL2Rldi9udm1lMG4xIC14IDEK
PiAKPiBEZXZpY2UgICAgICAgICAgICByX2F3YWl0IHdfYXdhaXQgYXF1LXN6IHJhcmVxLXN6IHdh
cmVxLXN6ICBzdmN0bSAgJXV0aWwKPiBudm1lMG4xICAgICAgICAgICAgICAwLjA4ICAgIDAuMDUg
ICAwLjA2ICAgMTI4LjAwICAgMTI4LjAwICAgMC4wNyAgIDYuNTAKPiAKPiBEZXZpY2UgICAgICAg
ICAgICByX2F3YWl0IHdfYXdhaXQgYXF1LXN6IHJhcmVxLXN6IHdhcmVxLXN6ICBzdmN0bSAgJXV0
aWwKPiBudm1lMG4xICAgICAgICAgICAgICAwLjA4ICAgIDAuMDYgICAwLjA2ICAgMTI4LjAwICAg
MTI4LjAwICAgMC4wNyAgIDYuMzAKPiAKPiBEZXZpY2UgICAgICAgICAgICByX2F3YWl0IHdfYXdh
aXQgYXF1LXN6IHJhcmVxLXN6IHdhcmVxLXN6ICBzdmN0bSAgJXV0aWwKPiBudm1lMG4xICAgICAg
ICAgICAgICAwLjA2ICAgIDAuMDUgICAwLjA2ICAgMTI4LjAwICAgMTI4LjAwICAgMC4wNiAgIDUu
NzAKPiAKPiBGcm9tIGZpbwo+IC0tLS0tLS0tCj4gUmVhZCBMYXRlbmN5OiBjbGF0ICh1c2VjKTog
bWluPTMyLCBtYXg9MjMzNSwgYXZnPTc5LjU0LCBzdGRldj0yOS45NQo+IFdyaXRlIExhdGVuY3k6
IGNsYXQgKHVzZWMpOiBtaW49MzgsIG1heD0xMzAsIGF2Zz01Ny43Niwgc3RkZXY9IDMuMjUKCkNh
biB5b3UgZXhwbGFpbiBhIGJpdCB3aHkgdGhlIGFib3ZlICV1dGlsIGlzIGNvcnJlY3Q/CgpCVFcs
ICV1dGlsIGlzIHVzdWFsbHkgbm90IGltcG9ydGFudCBmb3IgU1NEcywgcGxlYXNlIHNlZSAnbWFu
IGlvc3RhdCc6CgogICAgICV1dGlsCiAgICAgICAgICAgIFBlcmNlbnRhZ2Ugb2YgZWxhcHNlZCB0
aW1lIGR1cmluZyB3aGljaCBJL08gcmVxdWVzdHMgd2VyZSBpc3N1ZWQgdG8gdGhlIGRldmljZSAo
YmFuZHdpZHRoICB1dGnigJAKICAgICAgICAgICAgbGl6YXRpb24gZm9yIHRoZSBkZXZpY2UpLiBE
ZXZpY2Ugc2F0dXJhdGlvbiBvY2N1cnMgd2hlbiB0aGlzIHZhbHVlIGlzIGNsb3NlIHRvIDEwMCUg
Zm9yIGRldmljZXMKICAgICAgICAgICAgc2VydmluZyByZXF1ZXN0cyBzZXJpYWxseS4gIEJ1dCBm
b3IgZGV2aWNlcyBzZXJ2aW5nIHJlcXVlc3RzIGluIHBhcmFsbGVsLCBzdWNoIGFzICBSQUlEICBh
cnJheXMKICAgICAgICAgICAgYW5kIG1vZGVybiBTU0RzLCB0aGlzIG51bWJlciBkb2VzIG5vdCBy
ZWZsZWN0IHRoZWlyIHBlcmZvcm1hbmNlIGxpbWl0cy4KCgpUaGFua3MsIApNaW5nCi0tCmRtLWRl
dmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

