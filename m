Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8F80EB64D9
	for <dm-devel@archiver.kernel.org>; Wed, 14 Jun 2023 07:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686726742;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LOgN2tuaxjgCUizGQH9s1y9Zb28o+OzjZ89mkm80q4c=;
	b=XRIO/LvbvaN2fpGyjSSw/8L8WI152GxYwsHoud3H/G6b1Zu2E5mbHn1dnD+ACgFfhmPT3D
	XOqPsKpt38Ox2aGMzJ4miuQ1zVcr0WfE53l3KdyMK2Fy2gyjmdSn5tKck1P/MUkeNAefDK
	OMADcH3uLRRPlY8hDHdjCw/Jn5Wuu98=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-LoxvXN8MPQqgcaZt2-XFVw-1; Wed, 14 Jun 2023 03:12:19 -0400
X-MC-Unique: LoxvXN8MPQqgcaZt2-XFVw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E08F68352CF;
	Wed, 14 Jun 2023 07:12:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8E9FAC1603B;
	Wed, 14 Jun 2023 07:12:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4BF3A19459F1;
	Wed, 14 Jun 2023 07:12:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5D07F194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Jun 2023 07:12:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3D6DE492CAC; Wed, 14 Jun 2023 07:12:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 35671492CA6
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 07:12:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A874185A795
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 07:12:15 +0000 (UTC)
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-OnGSCjSuM--MgHMefNSkwA-1; Wed, 14 Jun 2023 03:12:13 -0400
X-MC-Unique: OnGSCjSuM--MgHMefNSkwA-1
Received: by mail-pj1-f69.google.com with SMTP id
 98e67ed59e1d1-25e0bab24aaso174048a91.1
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 00:12:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686726732; x=1689318732;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=Y/U0BSwcxwtPDblW2SZCJPehi+/SQaSwVgJ0GDSC97g=;
 b=LvnNhCLalBOP+iErBWGx747IA9DuwBPW4LWQTNd9XrXUIhmtkhHWaDQHW29p1T4zK/
 7h9WgO5yz94chaGzWio992WFBuYImTmQ9X5g4ZDjlfyz8KFAQNklMTqrJ5TXBS0zILu9
 ldwOnENbsIMBu0FHm8kAtQwoqNFr5yTtlO4ZBW01EUKEhzxtvcHmZKk+OHK/yYf9aY9I
 6XTN31HB+3Kmauh5yKvA6b8mKvwz+UiVhZUcHUMi5w3pD7ndw0J6lhYjJ2sxeP8MdxxJ
 Fuq0RD4qsS07hxOyJWcFk4gSW7mgS6SXdh8NCr921VrHopgqYoHPh5YQiOxvI4261I3+
 PRIw==
X-Gm-Message-State: AC+VfDxt/82JLkpnc1Pc2WD702xP2CD9BymaRpR6DxG/rf4W+glXTqhK
 Ey+pHSNKXVSX1tFHyp3KHOkYbhsHvFkf5cNkb0f6nGIcUPUJeyDhAKOWv60dZHDKsACBS3Cq8cm
 tDOLUuFPimrqbr/rLD98IAEdQvHM5Uik=
X-Received: by 2002:a17:90a:1cf:b0:25b:ec4c:488b with SMTP id
 15-20020a17090a01cf00b0025bec4c488bmr836260pjd.34.1686726732571; 
 Wed, 14 Jun 2023 00:12:12 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5xfVTtramTVR8uEZ8x1k3b87HRutoNm0rx85rGzKvGkxcTI2Uo0acNpC2eoMSozO2LyB1S30w8RoTHzLfhCJo=
X-Received: by 2002:a17:90a:1cf:b0:25b:ec4c:488b with SMTP id
 15-20020a17090a01cf00b0025bec4c488bmr836251pjd.34.1686726732274; Wed, 14 Jun
 2023 00:12:12 -0700 (PDT)
MIME-Version: 1.0
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-5-yukuai1@huaweicloud.com>
 <05aa3b09-7bb9-a65a-6231-4707b4b078a0@redhat.com>
 <74b404c4-4fdb-6eb3-93f1-0e640793bba6@huaweicloud.com>
 <6e738d9b-6e92-20b7-f9d9-e1cf71d26d73@huaweicloud.com>
In-Reply-To: <6e738d9b-6e92-20b7-f9d9-e1cf71d26d73@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 14 Jun 2023 15:12:01 +0800
Message-ID: <CALTww292gwOe-WEjuBwJn0AXvJC4AbfMZXC43EvVt3GCeBoHfw@mail.gmail.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH -next v2 4/6] md: refactor
 idle/frozen_sync_thread() to fix deadlock
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org,
 dm-devel@redhat.com, guoqing.jiang@linux.dev,
 "yukuai \(C\)" <yukuai3@huawei.com>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBKdW4gMTQsIDIwMjMgYXQgMTA6MDTigK9BTSBZdSBLdWFpIDx5dWt1YWkxQGh1YXdl
aWNsb3VkLmNvbT4gd3JvdGU6Cj4KPiBIaSwKPgo+IOWcqCAyMDIzLzA2LzE0IDk6NDgsIFl1IEt1
YWkg5YaZ6YGTOgo+Cj4KPiA+Pgo+ID4+IEluIHRoZSBwYXRjaCwgc3luY19zZXEgaXMgYWRkZWQg
aW4gbWRfcmVhcF9zeW5jX3RocmVhZC4gSW4KPiA+PiBpZGxlX3N5bmNfdGhyZWFkLCBpZiBzeW5j
X3NlcSBpc24ndCBlcXVhbAo+ID4+Cj4gPj4gbWRkZXYtPnN5bmNfc2VxLCBpdCBzaG91bGQgbWVh
biB0aGVyZSBpcyBzb21lb25lIHRoYXQgc3RvcHMgdGhlIHN5bmMKPiA+PiB0aHJlYWQgYWxyZWFk
eSwgcmlnaHQ/IFdoeSBkbwo+ID4+Cj4gPj4geW91IHNheSAnbmV3IHN0YXJ0ZWQgc3luYyB0aHJl
YWQnIGhlcmU/Cj4KPiBJZiBzb21lb25lIHN0b3BzIHRoZSBzeW5jIHRocmVhZCwgYW5kIG5ldyBz
eW5jIHRocmVhZCBpcyBub3Qgc3RhcnRlZCwKPiB0aGVuIHRoaXMgc3luY19zZXEgd29uJ3QgbWFr
ZSBhIGRpZmZlcmVuY2UsIGFib3ZlIHdhaXRfZXZlbnQoKSB3aWxsIG5vdAo+IHdhaXQgYmVjYXVz
ZSAhdGVzdF9iaXQoTURfUkVDT1ZFUllfUlVOTklORywgJm1kZGV2LT5yZWNvdmVyeSkgd2lsbCBw
YXNzLgo+IFNvICdzeW5jX3NlcScgaXMgb25seSB1c2VkIHdoZW4gdGhlIG9sZCBzeW5jIHRocmVh
ZCBzdG9wcyBhbmQgbmV3IHN5bmMKPiB0aHJlYWQgc3RhcnRzLCBhZGQgJ3N5bmNfc2VxJyB3aWxs
IGJ5cGFzcyB0aGlzIGNhc2UuCgpIaQoKSWYgYSBuZXcgc3luYyB0aHJlYWQgc3RhcnRzLCB3aHkg
Y2FuIHN5bmNfc2VxIGJlIGRpZmZlcmVudD8gc3luY19zZXEKaXMgb25seSBhZGRlZCBpbiBtZF9y
ZWFwX3N5bmNfdGhyZWFkLiBBbmQgd2hlbiBhIG5ldyBzeW5jIHJlcXVlc3QKc3RhcnRzLCBpdCBj
YW4ndCBzdG9wIHRoZSBzeW5jIHJlcXVlc3QgYWdhaW4/CgpBZiBmaXJzdCwgdGhlIHN5bmNfc2Vx
IGlzIDAKCmFkbWluMQplY2hvIGlkbGUgPiBzeW5jX2FjdGlvbgppZGxlX3N5bmNfdGhyZWFkKHN5
bmNfc2VxIGlzIDEpCmVjaG8gcmVzeW5jID4gc3luY19hY3Rpb24gKG5ldyBzeW5jKQoKVGhlbiBh
ZG1pbjIgZWNob3MgaWRsZSA+IHN5bmNfYWN0aW9uLCBzeW5jX3NlcSBpcyBzdGlsbCAxCgpSZWdh
cmRzClhpYW8KCj4KPiBUaGFua3MsCj4gS3VhaQo+CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsCg==

