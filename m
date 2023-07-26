Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EBC3C41513
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jul 2023 06:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690438895;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tzSLiTx/8s13dNoTnD2lKNyiIQrbWrNZ/va7RCmaFf8=;
	b=dLOqDTXDBGhomg7nFZvkBfb++im9QF/QYXMwAORdDMfCzT8WZ6cuwnN8dIBh5qzGCh9m0x
	/DLnyv//7tO/ExD/AfsiniSmP349GqGTk8GJaVWGV7ieu+TdnoTKDCD3hG3PTEzIbjmrM4
	Pt2spJMZRBLjTAYWbFcMG6Yw6sG3rkg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-boJyqjcPMFWAK_A4GIS3pA-1; Thu, 27 Jul 2023 02:21:32 -0400
X-MC-Unique: boJyqjcPMFWAK_A4GIS3pA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33315856F67;
	Thu, 27 Jul 2023 06:21:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1D6894094DC0;
	Thu, 27 Jul 2023 06:21:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DC07C1946A71;
	Thu, 27 Jul 2023 06:21:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0FD591946A69
 for <dm-devel@listman.corp.redhat.com>; Wed, 26 Jul 2023 09:28:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C89774094DC1; Wed, 26 Jul 2023 09:28:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C0CB94094DC0
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 09:28:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 876053C11CC2
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 09:28:04 +0000 (UTC)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-19-tr5FhhH_MuyTqii18PCC9g-1; Wed, 26 Jul 2023 05:28:02 -0400
X-MC-Unique: tr5FhhH_MuyTqii18PCC9g-1
Received: by mail-pf1-f176.google.com with SMTP id
 d2e1a72fcca58-6864c144897so1488702b3a.1
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 02:28:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690363681; x=1690968481;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=3q/836hkNQMpcz/8YX2aFfQHacV0FqcsnRX2KDKmGK4=;
 b=ALSyKm8z507EP7aR1ouD9acJEFtz2TtucsOEU73WRZCBwcavA7+YVh/LUrtv9XGsQp
 0KPInz02enDDGsd83ZV6orQGCbjTPVWqPnmKj4FkOcNX70fWSQq8X/hxmV14jIJ3SN8T
 0gXweT4ckbHM0o4/xRlxB6OrjG7dj15uDqfu6RLD2boh6CWUF0o7Ub/oxF2NBMuTmpLO
 9rkbO7ctD/8t7/NDFOIJHtHYmh7KumyHmMKaEhA5/cT6kxeBSQIebmbXTF7FmFIW6i06
 yZVxHYfGsw1fg7JWhVC2qFxcGDknyrOLlmu9jQNRMcxW+Ce9uuU/3Wzg6yW0EKP++lQA
 p/mA==
X-Gm-Message-State: ABy/qLY0LGS6wNcNkhRPK/Uh9YalymCjNQBi5Y0cbjHy2CN/AX05pg27
 rb9cpubFsyjpqyD3wg22Y+Z3lQ==
X-Google-Smtp-Source: APBJJlFbGXVT1jvZWB8OqMMjwV1wWa8tPHrXXzsgQ/SF73jQ8jhDFJz/C4eSTJgkpJW81UF91auuJQ==
X-Received: by 2002:a05:6a20:3c90:b0:134:d4d3:f0a5 with SMTP id
 b16-20020a056a203c9000b00134d4d3f0a5mr1941746pzj.2.1690363681365; 
 Wed, 26 Jul 2023 02:28:01 -0700 (PDT)
Received: from [10.70.252.135] ([203.208.167.147])
 by smtp.gmail.com with ESMTPSA id
 l73-20020a633e4c000000b00563da87a52dsm1901427pga.40.2023.07.26.02.27.49
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 26 Jul 2023 02:28:01 -0700 (PDT)
Message-ID: <665ccd89-8434-fc45-4813-c6412ef80c10@bytedance.com>
Date: Wed, 26 Jul 2023 17:27:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
To: Muchun Song <muchun.song@linux.dev>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
 <20230724094354.90817-20-zhengqi.arch@bytedance.com>
 <d41d09bc-7c1c-f708-ecfa-ffac59bf58ad@linux.dev>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <d41d09bc-7c1c-f708-ecfa-ffac59bf58ad@linux.dev>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Thu, 27 Jul 2023 06:20:49 +0000
Subject: Re: [dm-devel] [PATCH v2 19/47] mm: thp: dynamically allocate the
 thp-related shrinkers
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
Cc: kvm@vger.kernel.org, djwong@kernel.org, roman.gushchin@linux.dev,
 david@fromorbit.com, dri-devel@lists.freedesktop.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org, cel@kernel.org,
 x86@kernel.org, steven.price@arm.com, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, paulmck@kernel.org,
 linux-arm-msm@vger.kernel.org, brauner@kernel.org, rcu@vger.kernel.org,
 linux-bcache@vger.kernel.org, yujie.liu@intel.com, vbabka@suse.cz,
 linux-raid@vger.kernel.org, linux-nfs@vger.kernel.org, tytso@mit.edu,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 senozhatsky@chromium.org, gregkh@linuxfoundation.org,
 linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAyMDIzLzcvMjYgMTU6MTAsIE11Y2h1biBTb25nIHdyb3RlOgo+IAo+IAo+IE9uIDIwMjMv
Ny8yNCAxNzo0MywgUWkgWmhlbmcgd3JvdGU6Cj4+IFVzZSBuZXcgQVBJcyB0byBkeW5hbWljYWxs
eSBhbGxvY2F0ZSB0aGUgdGhwLXplcm8gYW5kIHRocC1kZWZlcnJlZF9zcGxpdAo+PiBzaHJpbmtl
cnMuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IFFpIFpoZW5nIDx6aGVuZ3FpLmFyY2hAYnl0ZWRhbmNl
LmNvbT4KPj4gLS0tCj4+IMKgIG1tL2h1Z2VfbWVtb3J5LmMgfCA2OSArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0KPj4gwqAgMSBmaWxlIGNoYW5nZWQsIDQ1
IGluc2VydGlvbnMoKyksIDI0IGRlbGV0aW9ucygtKQo+Pgo+PiBkaWZmIC0tZ2l0IGEvbW0vaHVn
ZV9tZW1vcnkuYyBiL21tL2h1Z2VfbWVtb3J5LmMKPj4gaW5kZXggOGM5NGIzNDAyNGEyLi40ZGI1
YTE4MzRkODEgMTAwNjQ0Cj4+IC0tLSBhL21tL2h1Z2VfbWVtb3J5LmMKPj4gKysrIGIvbW0vaHVn
ZV9tZW1vcnkuYwo+PiBAQCAtNjUsNyArNjUsMTEgQEAgdW5zaWduZWQgbG9uZyB0cmFuc3BhcmVu
dF9odWdlcGFnZV9mbGFncyAKPj4gX19yZWFkX21vc3RseSA9Cj4+IMKgwqDCoMKgwqAgKDE8PFRS
QU5TUEFSRU5UX0hVR0VQQUdFX0RFRlJBR19LSFVHRVBBR0VEX0ZMQUcpfAo+PiDCoMKgwqDCoMKg
ICgxPDxUUkFOU1BBUkVOVF9IVUdFUEFHRV9VU0VfWkVST19QQUdFX0ZMQUcpOwo+PiAtc3RhdGlj
IHN0cnVjdCBzaHJpbmtlciBkZWZlcnJlZF9zcGxpdF9zaHJpbmtlcjsKPj4gK3N0YXRpYyBzdHJ1
Y3Qgc2hyaW5rZXIgKmRlZmVycmVkX3NwbGl0X3Nocmlua2VyOwo+PiArc3RhdGljIHVuc2lnbmVk
IGxvbmcgZGVmZXJyZWRfc3BsaXRfY291bnQoc3RydWN0IHNocmlua2VyICpzaHJpbmssCj4+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IHNocmlua19j
b250cm9sICpzYyk7Cj4+ICtzdGF0aWMgdW5zaWduZWQgbG9uZyBkZWZlcnJlZF9zcGxpdF9zY2Fu
KHN0cnVjdCBzaHJpbmtlciAqc2hyaW5rLAo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBzdHJ1Y3Qgc2hyaW5rX2NvbnRyb2wgKnNjKTsKPj4gwqAgc3RhdGljIGF0
b21pY190IGh1Z2VfemVyb19yZWZjb3VudDsKPj4gwqAgc3RydWN0IHBhZ2UgKmh1Z2VfemVyb19w
YWdlIF9fcmVhZF9tb3N0bHk7Cj4+IEBAIC0yMjksMTEgKzIzMyw3IEBAIHN0YXRpYyB1bnNpZ25l
ZCBsb25nIAo+PiBzaHJpbmtfaHVnZV96ZXJvX3BhZ2Vfc2NhbihzdHJ1Y3Qgc2hyaW5rZXIgKnNo
cmluaywKPj4gwqDCoMKgwqDCoCByZXR1cm4gMDsKPj4gwqAgfQo+PiAtc3RhdGljIHN0cnVjdCBz
aHJpbmtlciBodWdlX3plcm9fcGFnZV9zaHJpbmtlciA9IHsKPj4gLcKgwqDCoCAuY291bnRfb2Jq
ZWN0cyA9IHNocmlua19odWdlX3plcm9fcGFnZV9jb3VudCwKPj4gLcKgwqDCoCAuc2Nhbl9vYmpl
Y3RzID0gc2hyaW5rX2h1Z2VfemVyb19wYWdlX3NjYW4sCj4+IC3CoMKgwqAgLnNlZWtzID0gREVG
QVVMVF9TRUVLUywKPj4gLX07Cj4+ICtzdGF0aWMgc3RydWN0IHNocmlua2VyICpodWdlX3plcm9f
cGFnZV9zaHJpbmtlcjsKPiAKPiBTYW1lIGFzIHBhdGNoICMxNy4KCk9LLCB3aWxsIGRvLgoKPiAK
Pj4gwqAgI2lmZGVmIENPTkZJR19TWVNGUwo+PiDCoCBzdGF0aWMgc3NpemVfdCBlbmFibGVkX3No
b3coc3RydWN0IGtvYmplY3QgKmtvYmosCj4+IEBAIC00NTQsNiArNDU0LDQwIEBAIHN0YXRpYyBp
bmxpbmUgdm9pZCBodWdlcGFnZV9leGl0X3N5c2ZzKHN0cnVjdCAKPj4ga29iamVjdCAqaHVnZXBh
Z2Vfa29iaikKPj4gwqAgfQo+PiDCoCAjZW5kaWYgLyogQ09ORklHX1NZU0ZTICovCj4+ICtzdGF0
aWMgaW50IHRocF9zaHJpbmtlcl9pbml0KHZvaWQpCj4gCj4gQmV0dGVyIHRvIGRlY2xhcmUgaXQg
YXMgX19pbml0LgoKV2lsbCBkby4KCj4gCj4+ICt7Cj4+ICvCoMKgwqAgaHVnZV96ZXJvX3BhZ2Vf
c2hyaW5rZXIgPSBzaHJpbmtlcl9hbGxvYygwLCAidGhwLXplcm8iKTsKPj4gK8KgwqDCoCBpZiAo
IWh1Z2VfemVyb19wYWdlX3Nocmlua2VyKQo+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FTk9N
RU07Cj4+ICsKPj4gK8KgwqDCoCBkZWZlcnJlZF9zcGxpdF9zaHJpbmtlciA9IHNocmlua2VyX2Fs
bG9jKFNIUklOS0VSX05VTUFfQVdBUkUgfAo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIFNIUklOS0VSX01FTUNHX0FXQVJFIHwKPj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBTSFJJTktFUl9OT05TTEFC
LAo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICJ0
aHAtZGVmZXJyZWRfc3BsaXQiKTsKPj4gK8KgwqDCoCBpZiAoIWRlZmVycmVkX3NwbGl0X3Nocmlu
a2VyKSB7Cj4+ICvCoMKgwqDCoMKgwqDCoCBzaHJpbmtlcl9mcmVlX25vbl9yZWdpc3RlcmVkKGh1
Z2VfemVyb19wYWdlX3Nocmlua2VyKTsKPj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybiAtRU5PTUVN
Owo+PiArwqDCoMKgIH0KPj4gKwo+PiArwqDCoMKgIGh1Z2VfemVyb19wYWdlX3Nocmlua2VyLT5j
b3VudF9vYmplY3RzID0gCj4+IHNocmlua19odWdlX3plcm9fcGFnZV9jb3VudDsKPj4gK8KgwqDC
oCBodWdlX3plcm9fcGFnZV9zaHJpbmtlci0+c2Nhbl9vYmplY3RzID0gc2hyaW5rX2h1Z2VfemVy
b19wYWdlX3NjYW47Cj4+ICvCoMKgwqAgaHVnZV96ZXJvX3BhZ2Vfc2hyaW5rZXItPnNlZWtzID0g
REVGQVVMVF9TRUVLUzsKPj4gK8KgwqDCoCBzaHJpbmtlcl9yZWdpc3RlcihodWdlX3plcm9fcGFn
ZV9zaHJpbmtlcik7Cj4+ICsKPj4gK8KgwqDCoCBkZWZlcnJlZF9zcGxpdF9zaHJpbmtlci0+Y291
bnRfb2JqZWN0cyA9IGRlZmVycmVkX3NwbGl0X2NvdW50Owo+PiArwqDCoMKgIGRlZmVycmVkX3Nw
bGl0X3Nocmlua2VyLT5zY2FuX29iamVjdHMgPSBkZWZlcnJlZF9zcGxpdF9zY2FuOwo+PiArwqDC
oMKgIGRlZmVycmVkX3NwbGl0X3Nocmlua2VyLT5zZWVrcyA9IERFRkFVTFRfU0VFS1M7Cj4+ICvC
oMKgwqAgc2hyaW5rZXJfcmVnaXN0ZXIoZGVmZXJyZWRfc3BsaXRfc2hyaW5rZXIpOwo+PiArCj4+
ICvCoMKgwqAgcmV0dXJuIDA7Cj4+ICt9Cj4+ICsKPj4gK3N0YXRpYyB2b2lkIHRocF9zaHJpbmtl
cl9leGl0KHZvaWQpCj4gCj4gU2FtZSBhcyBoZXJlLgoKV2lsbCBkby4KCj4gCj4+ICt7Cj4+ICvC
oMKgwqAgc2hyaW5rZXJfdW5yZWdpc3RlcihodWdlX3plcm9fcGFnZV9zaHJpbmtlcik7Cj4+ICvC
oMKgwqAgc2hyaW5rZXJfdW5yZWdpc3RlcihkZWZlcnJlZF9zcGxpdF9zaHJpbmtlcik7Cj4+ICt9
Cj4+ICsKPj4gwqAgc3RhdGljIGludCBfX2luaXQgaHVnZXBhZ2VfaW5pdCh2b2lkKQo+PiDCoCB7
Cj4+IMKgwqDCoMKgwqAgaW50IGVycjsKPj4gQEAgLTQ4MiwxMiArNTE2LDkgQEAgc3RhdGljIGlu
dCBfX2luaXQgaHVnZXBhZ2VfaW5pdCh2b2lkKQo+PiDCoMKgwqDCoMKgIGlmIChlcnIpCj4+IMKg
wqDCoMKgwqDCoMKgwqDCoCBnb3RvIGVycl9zbGFiOwo+PiAtwqDCoMKgIGVyciA9IHJlZ2lzdGVy
X3Nocmlua2VyKCZodWdlX3plcm9fcGFnZV9zaHJpbmtlciwgInRocC16ZXJvIik7Cj4+IC3CoMKg
wqAgaWYgKGVycikKPj4gLcKgwqDCoMKgwqDCoMKgIGdvdG8gZXJyX2h6cF9zaHJpbmtlcjsKPj4g
LcKgwqDCoCBlcnIgPSByZWdpc3Rlcl9zaHJpbmtlcigmZGVmZXJyZWRfc3BsaXRfc2hyaW5rZXIs
IAo+PiAidGhwLWRlZmVycmVkX3NwbGl0Iik7Cj4+ICvCoMKgwqAgZXJyID0gdGhwX3Nocmlua2Vy
X2luaXQoKTsKPj4gwqDCoMKgwqDCoCBpZiAoZXJyKQo+PiAtwqDCoMKgwqDCoMKgwqAgZ290byBl
cnJfc3BsaXRfc2hyaW5rZXI7Cj4+ICvCoMKgwqDCoMKgwqDCoCBnb3RvIGVycl9zaHJpbmtlcjsK
Pj4gwqDCoMKgwqDCoCAvKgo+PiDCoMKgwqDCoMKgwqAgKiBCeSBkZWZhdWx0IGRpc2FibGUgdHJh
bnNwYXJlbnQgaHVnZXBhZ2VzIG9uIHNtYWxsZXIgc3lzdGVtcywKPj4gQEAgLTUwNSwxMCArNTM2
LDggQEAgc3RhdGljIGludCBfX2luaXQgaHVnZXBhZ2VfaW5pdCh2b2lkKQo+PiDCoMKgwqDCoMKg
IHJldHVybiAwOwo+PiDCoCBlcnJfa2h1Z2VwYWdlZDoKPj4gLcKgwqDCoCB1bnJlZ2lzdGVyX3No
cmlua2VyKCZkZWZlcnJlZF9zcGxpdF9zaHJpbmtlcik7Cj4+IC1lcnJfc3BsaXRfc2hyaW5rZXI6
Cj4+IC3CoMKgwqAgdW5yZWdpc3Rlcl9zaHJpbmtlcigmaHVnZV96ZXJvX3BhZ2Vfc2hyaW5rZXIp
Owo+PiAtZXJyX2h6cF9zaHJpbmtlcjoKPj4gK8KgwqDCoCB0aHBfc2hyaW5rZXJfZXhpdCgpOwo+
PiArZXJyX3Nocmlua2VyOgo+PiDCoMKgwqDCoMKgIGtodWdlcGFnZWRfZGVzdHJveSgpOwo+PiDC
oCBlcnJfc2xhYjoKPj4gwqDCoMKgwqDCoCBodWdlcGFnZV9leGl0X3N5c2ZzKGh1Z2VwYWdlX2tv
YmopOwo+PiBAQCAtMjg1MSw3ICsyODgwLDcgQEAgdm9pZCBkZWZlcnJlZF9zcGxpdF9mb2xpbyhz
dHJ1Y3QgZm9saW8gKmZvbGlvKQo+PiDCoCAjaWZkZWYgQ09ORklHX01FTUNHCj4+IMKgwqDCoMKg
wqDCoMKgwqDCoCBpZiAobWVtY2cpCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNldF9z
aHJpbmtlcl9iaXQobWVtY2csIGZvbGlvX25pZChmb2xpbyksCj4+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRlZmVycmVkX3NwbGl0X3Nocmlua2VyLmlkKTsKPj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZGVmZXJyZWRfc3BsaXRf
c2hyaW5rZXItPmlkKTsKPj4gwqAgI2VuZGlmCj4+IMKgwqDCoMKgwqAgfQo+PiDCoMKgwqDCoMKg
IHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmRzX3F1ZXVlLT5zcGxpdF9xdWV1ZV9sb2NrLCBmbGFn
cyk7Cj4+IEBAIC0yOTI1LDE0ICsyOTU0LDYgQEAgc3RhdGljIHVuc2lnbmVkIGxvbmcgZGVmZXJy
ZWRfc3BsaXRfc2NhbihzdHJ1Y3QgCj4+IHNocmlua2VyICpzaHJpbmssCj4+IMKgwqDCoMKgwqAg
cmV0dXJuIHNwbGl0Owo+PiDCoCB9Cj4+IC1zdGF0aWMgc3RydWN0IHNocmlua2VyIGRlZmVycmVk
X3NwbGl0X3Nocmlua2VyID0gewo+PiAtwqDCoMKgIC5jb3VudF9vYmplY3RzID0gZGVmZXJyZWRf
c3BsaXRfY291bnQsCj4+IC3CoMKgwqAgLnNjYW5fb2JqZWN0cyA9IGRlZmVycmVkX3NwbGl0X3Nj
YW4sCj4+IC3CoMKgwqAgLnNlZWtzID0gREVGQVVMVF9TRUVLUywKPj4gLcKgwqDCoCAuZmxhZ3Mg
PSBTSFJJTktFUl9OVU1BX0FXQVJFIHwgU0hSSU5LRVJfTUVNQ0dfQVdBUkUgfAo+PiAtwqDCoMKg
wqDCoMKgwqDCoCBTSFJJTktFUl9OT05TTEFCLAo+PiAtfTsKPj4gLQo+PiDCoCAjaWZkZWYgQ09O
RklHX0RFQlVHX0ZTCj4+IMKgIHN0YXRpYyB2b2lkIHNwbGl0X2h1Z2VfcGFnZXNfYWxsKHZvaWQp
Cj4+IMKgIHsKPiAKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29t
Cmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

