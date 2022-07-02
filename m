Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A5E2C43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119158;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cZzJ3hWg6AtmXeNWA+3Z+jhbJnB+rhkZIqRyBJCdPzE=;
	b=M80ynkCyW+S1H/lr7SP53jq4GPRE9WQFjy8J0EeZKxTxaHQ7rXI8JqGOtY/wYajJLzEZBV
	0IWSK9FRI6cR9F8FFsPc4+9SJAqn4ULCCISitbV5Y0shervoE9x7jlbCe9XWTUFy48ZXH/
	V+QLj/RfP84rq1P2ynGkywUfg9Gfa5E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-0PMpbhu7M9iJOcQfVeIamA-1; Wed, 06 Jul 2022 10:52:31 -0400
X-MC-Unique: 0PMpbhu7M9iJOcQfVeIamA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B05AA1C18263;
	Wed,  6 Jul 2022 14:52:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9E7A91121315;
	Wed,  6 Jul 2022 14:52:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6C6F61947063;
	Wed,  6 Jul 2022 14:52:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5DBED194705A
 for <dm-devel@listman.corp.redhat.com>; Sat,  2 Jul 2022 19:24:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5115BC28102; Sat,  2 Jul 2022 19:24:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D4BEC28100
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 19:24:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35FCB185A7A4
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 19:24:30 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp09.smtpout.orange.fr
 [80.12.242.131]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 us-mta-163-_BMfB-QaMk2x1IgvfHZSoQ-1; Sat, 02 Jul 2022 15:24:28 -0400
X-MC-Unique: _BMfB-QaMk2x1IgvfHZSoQ-1
Received: from [192.168.1.18] ([90.11.190.129]) by smtp.orange.fr with ESMTPA
 id 7ijBoXUXwOXCy7ijBodMg5; Sat, 02 Jul 2022 21:24:27 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 02 Jul 2022 21:24:27 +0200
X-ME-IP: 90.11.190.129
Message-ID: <6063ee97-1bbe-2391-78cb-57572851a52c@wanadoo.fr>
Date: Sat, 2 Jul 2022 21:24:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Newsgroups: gmane.linux.kernel.janitors, gmane.linux.kernel.device-mapper.devel,
 gmane.linux.kernel
References: <cover.1656785856.git.christophe.jaillet@wanadoo.fr>
 <3f2ad7fb91948525f6c52e0d36ec223cd3049c88.1656785856.git.christophe.jaillet@wanadoo.fr>
 <YsCUW6vT7LlAv2UE@smile.fi.intel.com>
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <YsCUW6vT7LlAv2UE@smile.fi.intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: Re: [dm-devel] [PATCH 1/4] s390/cio: Rename bitmap_size() as
 idset_bitmap_size()
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
Cc: linux-s390@vger.kernel.org, kernel-janitors@vger.kernel.org,
 ntfs3@lists.linux.dev, yury.norov@gmail.com, gor@linux.ibm.com,
 linux@rasmusvillemoes.dk, hca@linux.ibm.com, snitzer@kernel.org,
 oberpar@linux.ibm.com, linux-kernel@vger.kernel.org,
 almaz.alexandrovich@paragon-software.com, dm-devel@redhat.com,
 svens@linux.ibm.com, vneethv@linux.ibm.com, agordeev@linux.ibm.com,
 borntraeger@linux.ibm.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

TGUgMDIvMDcvMjAyMiDDoCAyMDo1NCwgQW5keSBTaGV2Y2hlbmtvIGEgw6ljcml0wqA6Cj4gT24g
U2F0LCBKdWwgMDIsIDIwMjIgYXQgMDg6Mjk6MDlQTSArMDIwMCwgQ2hyaXN0b3BoZSBKQUlMTEVU
IHdyb3RlOgo+PiBJbiBvcmRlciB0byBpbnRyb2R1Y2UgYSBiaXRtYXBfc2l6ZSgpIGZ1bmN0aW9u
IGluIHRoZSBiaXRtYXAgQVBJLCB3ZSBoYXZlCj4+IHRvIHJlbmFtZSBmdW5jdGlvbnMgd2l0aCBh
IHNpbWlsYXIgbmFtZS4KPj4KPj4gQWRkIGEgImlkc2V0XyIgcHJlZml4IGFuZCBjaGFuZ2UgYml0
bWFwX3NpemUoKSBpbnRvIGlkc2V0X2JpdG1hcF9zaXplKCkuCj4+Cj4+IE5vIGZ1bmN0aW9uYWwg
Y2hhbmdlLgo+IAo+IC4uLgo+IAo+PiAtCQltZW1zZXQoc2V0LT5iaXRtYXAsIDAsIGJpdG1hcF9z
aXplKG51bV9zc2lkLCBudW1faWQpKTsKPj4gKwkJbWVtc2V0KHNldC0+Yml0bWFwLCAwLCBpZHNl
dF9iaXRtYXBfc2l6ZShudW1fc3NpZCwgbnVtX2lkKSk7Cj4gCj4gV2h5IG5vdCB0byB1c2UgYml0
bWFwX3plcm8oKT8KPiAKPiAuLi4KPiAKPj4gLQltZW1zZXQoc2V0LT5iaXRtYXAsIDB4ZmYsIGJp
dG1hcF9zaXplKHNldC0+bnVtX3NzaWQsIHNldC0+bnVtX2lkKSk7Cj4+ICsJbWVtc2V0KHNldC0+
Yml0bWFwLCAweGZmLCBpZHNldF9iaXRtYXBfc2l6ZShzZXQtPm51bV9zc2lkLCBzZXQtPm51bV9p
ZCkpOwo+IAo+IFdoeSBub3QgdG8gdXNlIGJpdG1hcF9maWxsKCkgPwo+IAo+IAoKSGksCgpGb3Ig
dGhpcyBpbml0aWFsIHN0ZXAsIEkgd2FudGVkIHRvIGtlZXAgY2hhbmdlcyBhcyBtaW5pbWFsIGFz
IHBvc3NpYmxlIAooaS5lIGp1c3QgZnVuY3Rpb24gcmVuYW1pbmcpCgpJbiBmYWN0LCBJIHBsYW4g
dG8gc2VuZCBhIGZvbGxvdy11cCBwYXRjaCBvbiB0aGlzIGZpbGUuClRoaXMgd291bGQgcmVtb3Zl
IHRoZSBuZXdseSByZW5hbWVkIGlkc2V0X2JpdG1hcF9zaXplKCkgZnVuY3Rpb24sIHVzZSAKdGhl
IGJpdG1hcCBBUEkgZGlyZWN0bHkgKGFzIHlvdSBwb2ludGVkLW91dCkgd2l0aAoic2V0LT5udW1f
c3NpZCAqIHNldC0+bnVtX2lkIiBhcyBzaXplLgoKSXQgaXMgYWxyZWFkeSBkb25lIHRoaXMgd2F5
IGluIGlkc2V0X2lzX2VtcHR5KCksIHNvIGl0IHdvdWxkIGJlIG1vcmUgCmNvbnNpc3RlbnQuCgpJ
ZiB0aGUgc2VyaWUgbmVlZHMgYSB2MiAob3IgaWYgcmVxdWlyZWQpLCBJIGNhbiBhZGQgYW4gYWRk
aXRpb25hbCA1dGggCnBhdGNoIGZvciBpdC4gT3RoZXJ3aXNlIGl0IHdpbGwgc2VuZCBzZXBhcmF0
bHkgbGF0ZXIuCgpDSgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5j
b20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

