Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43D58C4321E
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 06:19:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-SkQ1I9V-NB6u3PPB48Xs1g-1; Mon, 11 Apr 2022 02:19:27 -0400
X-MC-Unique: SkQ1I9V-NB6u3PPB48Xs1g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54E323C01C1B;
	Mon, 11 Apr 2022 06:19:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0A82540CF8E4;
	Mon, 11 Apr 2022 06:19:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0B225193F6E2;
	Mon, 11 Apr 2022 06:19:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AA42C1940341
 for <dm-devel@listman.corp.redhat.com>; Sat,  9 Apr 2022 08:17:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 95287492D17; Sat,  9 Apr 2022 08:17:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 90DAF492CAF
 for <dm-devel@redhat.com>; Sat,  9 Apr 2022 08:17:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 793B229AB443
 for <dm-devel@redhat.com>; Sat,  9 Apr 2022 08:17:04 +0000 (UTC)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com
 [209.85.221.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-2JTNT_I0O4yARQ8eixTn8A-1; Sat, 09 Apr 2022 04:17:02 -0400
X-MC-Unique: 2JTNT_I0O4yARQ8eixTn8A-1
Received: by mail-wr1-f51.google.com with SMTP id w21so16078221wra.2
 for <dm-devel@redhat.com>; Sat, 09 Apr 2022 01:17:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=Ga61vN/TMGQoWv5pdVva9yHEVEk7JvDu8SvkqTkiHOU=;
 b=njExP1onb6zC8Gz7F+TM7pS7lnJ2Xkd2w161fv7QQwZdamn/ILWREePUmRpiRFLzMu
 RD7qyWfMpjW15Uu3GdScwLgpo9b8+JwSAAPIA4xxibWTx7IckmaVrD9UVYFB1KAS4waF
 TVn9zYK2E5H4mYw8C2faZme2Q6Bern1LF950I9sjNhf4DPL68HhvrRrcJYd4qXJU6vZC
 KvTsWEinoyw0d8yh090w8wG38wwe10vzddQYeglk72x9eYUBRcWV1Yqgrws2zZ0hXxVC
 HgwAq5lfCkdBSO5Mq03sUrzaMsXcCBu18ZLvRGXeZY7ArsSGKknsb+6Evb+dZMJx7PKc
 HhJw==
X-Gm-Message-State: AOAM530oCKAiZhc1Pl2zLCefAnlzn5adI77QH/dFR6IKa1tiYDlXjieh
 WXThrp0mzBa/7KtDVwg+mvMxvWkuAlPi9AkC1Kk=
X-Google-Smtp-Source: ABdhPJyMl7hUdRWB67QUv24ZWK8mJRwBaxhnGq09ejE28bU5zjvkHivlidIC/JIf/EdWqVvIZNI6nA==
X-Received: by 2002:adf:9581:0:b0:1ed:c341:4ed1 with SMTP id
 p1-20020adf9581000000b001edc3414ed1mr16998132wrp.299.1649492221449; 
 Sat, 09 Apr 2022 01:17:01 -0700 (PDT)
Received: from [192.168.169.127] (178.115.52.210.wireless.dyn.drei.com.
 [178.115.52.210]) by smtp.gmail.com with ESMTPSA id
 r14-20020a05600c35ce00b0038c9f469979sm12169802wmq.40.2022.04.09.01.16.59
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 09 Apr 2022 01:17:01 -0700 (PDT)
Message-ID: <5a26cdb1-b63b-8d35-640b-bc0e0f78a181@linbit.com>
Date: Sat, 9 Apr 2022 10:16:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
To: Christoph Hellwig <hch@lst.de>
References: <20220409045043.23593-1-hch@lst.de>
 <20220409045043.23593-5-hch@lst.de>
From: =?UTF-8?Q?Christoph_B=c3=b6hmwalder?= <christoph.boehmwalder@linbit.com>
In-Reply-To: <20220409045043.23593-5-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Mon, 11 Apr 2022 06:19:20 +0000
Subject: Re: [dm-devel] [Drbd-dev] [PATCH 04/27] drbd: remove
 assign_p_sizes_qlim
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
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
 linux-um@lists.infradead.org, nbd@other.debian.org, linux-raid@vger.kernel.org,
 linux-bcache@vger.kernel.org, ceph-devel@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
 ocfs2-devel@oss.oracle.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMDkuMDQuMjIgMDY6NTAsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOgo+IEZvbGQgZWFjaCBi
cmFuY2ggaW50byBpdHMgb25seSBjYWxsZXIuCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3Bo
IEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gLS0tCj4gICBkcml2ZXJzL2Jsb2NrL2RyYmQvZHJiZF9t
YWluLmMgfCA0NyArKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tCj4gICAxIGZpbGUg
Y2hhbmdlZCwgMjAgaW5zZXJ0aW9ucygrKSwgMjcgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvYmxvY2svZHJiZC9kcmJkX21haW4uYyBiL2RyaXZlcnMvYmxvY2svZHJiZC9k
cmJkX21haW4uYwo+IGluZGV4IDk2NzZhMWQyMTRiYzUuLjEyNjJmZTFjMzM2MTggMTAwNjQ0Cj4g
LS0tIGEvZHJpdmVycy9ibG9jay9kcmJkL2RyYmRfbWFpbi5jCj4gKysrIGIvZHJpdmVycy9ibG9j
ay9kcmJkL2RyYmRfbWFpbi5jCj4gQEAgLTkwMywzMSArOTAzLDYgQEAgdm9pZCBkcmJkX2dlbl9h
bmRfc2VuZF9zeW5jX3V1aWQoc3RydWN0IGRyYmRfcGVlcl9kZXZpY2UgKnBlZXJfZGV2aWNlKQo+
ICAgCX0KPiAgIH0KPiAgIAo+IC0vKiBjb21tdW5pY2F0ZWQgaWYgKGFncmVlZF9mZWF0dXJlcyAm
IERSQkRfRkZfV1NBTUUpICovCj4gLXN0YXRpYyB2b2lkCj4gLWFzc2lnbl9wX3NpemVzX3FsaW0o
c3RydWN0IGRyYmRfZGV2aWNlICpkZXZpY2UsIHN0cnVjdCBwX3NpemVzICpwLAo+IC0JCQkJCXN0
cnVjdCByZXF1ZXN0X3F1ZXVlICpxKQo+IC17Cj4gLQlpZiAocSkgewo+IC0JCXAtPnFsaW0tPnBo
eXNpY2FsX2Jsb2NrX3NpemUgPSBjcHVfdG9fYmUzMihxdWV1ZV9waHlzaWNhbF9ibG9ja19zaXpl
KHEpKTsKPiAtCQlwLT5xbGltLT5sb2dpY2FsX2Jsb2NrX3NpemUgPSBjcHVfdG9fYmUzMihxdWV1
ZV9sb2dpY2FsX2Jsb2NrX3NpemUocSkpOwo+IC0JCXAtPnFsaW0tPmFsaWdubWVudF9vZmZzZXQg
PSBjcHVfdG9fYmUzMihxdWV1ZV9hbGlnbm1lbnRfb2Zmc2V0KHEpKTsKPiAtCQlwLT5xbGltLT5p
b19taW4gPSBjcHVfdG9fYmUzMihxdWV1ZV9pb19taW4ocSkpOwo+IC0JCXAtPnFsaW0tPmlvX29w
dCA9IGNwdV90b19iZTMyKHF1ZXVlX2lvX29wdChxKSk7Cj4gLQkJcC0+cWxpbS0+ZGlzY2FyZF9l
bmFibGVkID0gYmxrX3F1ZXVlX2Rpc2NhcmQocSk7Cj4gLQkJcC0+cWxpbS0+d3JpdGVfc2FtZV9j
YXBhYmxlID0gMDsKPiAtCX0gZWxzZSB7Cj4gLQkJcSA9IGRldmljZS0+cnFfcXVldWU7Cj4gLQkJ
cC0+cWxpbS0+cGh5c2ljYWxfYmxvY2tfc2l6ZSA9IGNwdV90b19iZTMyKHF1ZXVlX3BoeXNpY2Fs
X2Jsb2NrX3NpemUocSkpOwo+IC0JCXAtPnFsaW0tPmxvZ2ljYWxfYmxvY2tfc2l6ZSA9IGNwdV90
b19iZTMyKHF1ZXVlX2xvZ2ljYWxfYmxvY2tfc2l6ZShxKSk7Cj4gLQkJcC0+cWxpbS0+YWxpZ25t
ZW50X29mZnNldCA9IDA7Cj4gLQkJcC0+cWxpbS0+aW9fbWluID0gY3B1X3RvX2JlMzIocXVldWVf
aW9fbWluKHEpKTsKPiAtCQlwLT5xbGltLT5pb19vcHQgPSBjcHVfdG9fYmUzMihxdWV1ZV9pb19v
cHQocSkpOwo+IC0JCXAtPnFsaW0tPmRpc2NhcmRfZW5hYmxlZCA9IDA7Cj4gLQkJcC0+cWxpbS0+
d3JpdGVfc2FtZV9jYXBhYmxlID0gMDsKPiAtCX0KPiAtfQo+IC0KPiAgIGludCBkcmJkX3NlbmRf
c2l6ZXMoc3RydWN0IGRyYmRfcGVlcl9kZXZpY2UgKnBlZXJfZGV2aWNlLCBpbnQgdHJpZ2dlcl9y
ZXBseSwgZW51bSBkZHNfZmxhZ3MgZmxhZ3MpCj4gICB7Cj4gICAJc3RydWN0IGRyYmRfZGV2aWNl
ICpkZXZpY2UgPSBwZWVyX2RldmljZS0+ZGV2aWNlOwo+IEBAIC05NTcsMTQgKzkzMiwzMiBAQCBp
bnQgZHJiZF9zZW5kX3NpemVzKHN0cnVjdCBkcmJkX3BlZXJfZGV2aWNlICpwZWVyX2RldmljZSwg
aW50IHRyaWdnZXJfcmVwbHksIGVudQo+ICAgCQlxX29yZGVyX3R5cGUgPSBkcmJkX3F1ZXVlX29y
ZGVyX3R5cGUoZGV2aWNlKTsKPiAgIAkJbWF4X2Jpb19zaXplID0gcXVldWVfbWF4X2h3X3NlY3Rv
cnMocSkgPDwgOTsKPiAgIAkJbWF4X2Jpb19zaXplID0gbWluKG1heF9iaW9fc2l6ZSwgRFJCRF9N
QVhfQklPX1NJWkUpOwo+IC0JCWFzc2lnbl9wX3NpemVzX3FsaW0oZGV2aWNlLCBwLCBxKTsKPiAr
CQlwLT5xbGltLT5waHlzaWNhbF9ibG9ja19zaXplID0KPiArCQkJY3B1X3RvX2JlMzIocXVldWVf
cGh5c2ljYWxfYmxvY2tfc2l6ZShxKSk7Cj4gKwkJcC0+cWxpbS0+bG9naWNhbF9ibG9ja19zaXpl
ID0KPiArCQkJY3B1X3RvX2JlMzIocXVldWVfbG9naWNhbF9ibG9ja19zaXplKHEpKTsKPiArCQlw
LT5xbGltLT5hbGlnbm1lbnRfb2Zmc2V0ID0KPiArCQkJY3B1X3RvX2JlMzIocXVldWVfYWxpZ25t
ZW50X29mZnNldChxKSk7Cj4gKwkJcC0+cWxpbS0+aW9fbWluID0gY3B1X3RvX2JlMzIocXVldWVf
aW9fbWluKHEpKTsKPiArCQlwLT5xbGltLT5pb19vcHQgPSBjcHVfdG9fYmUzMihxdWV1ZV9pb19v
cHQocSkpOwo+ICsJCXAtPnFsaW0tPmRpc2NhcmRfZW5hYmxlZCA9IGJsa19xdWV1ZV9kaXNjYXJk
KHEpOwo+ICAgCQlwdXRfbGRldihkZXZpY2UpOwo+ICAgCX0gZWxzZSB7Cj4gKwkJc3RydWN0IHJl
cXVlc3RfcXVldWUgKnEgPSBkZXZpY2UtPnJxX3F1ZXVlOwo+ICsKPiArCQlwLT5xbGltLT5waHlz
aWNhbF9ibG9ja19zaXplID0KPiArCQkJY3B1X3RvX2JlMzIocXVldWVfcGh5c2ljYWxfYmxvY2tf
c2l6ZShxKSk7Cj4gKwkJcC0+cWxpbS0+bG9naWNhbF9ibG9ja19zaXplID0KPiArCQkJY3B1X3Rv
X2JlMzIocXVldWVfbG9naWNhbF9ibG9ja19zaXplKHEpKTsKPiArCQlwLT5xbGltLT5hbGlnbm1l
bnRfb2Zmc2V0ID0gMDsKPiArCQlwLT5xbGltLT5pb19taW4gPSBjcHVfdG9fYmUzMihxdWV1ZV9p
b19taW4ocSkpOwo+ICsJCXAtPnFsaW0tPmlvX29wdCA9IGNwdV90b19iZTMyKHF1ZXVlX2lvX29w
dChxKSk7Cj4gKwkJcC0+cWxpbS0+ZGlzY2FyZF9lbmFibGVkID0gMDsKPiArCj4gICAJCWRfc2l6
ZSA9IDA7Cj4gICAJCXVfc2l6ZSA9IDA7Cj4gICAJCXFfb3JkZXJfdHlwZSA9IFFVRVVFX09SREVS
RURfTk9ORTsKPiAgIAkJbWF4X2Jpb19zaXplID0gRFJCRF9NQVhfQklPX1NJWkU7IC8qIC4uLiBt
dWx0aXBsZSBCSU9zIHBlciBwZWVyX3JlcXVlc3QgKi8KPiAtCQlhc3NpZ25fcF9zaXplc19xbGlt
KGRldmljZSwgcCwgTlVMTCk7Cj4gICAJfQo+ICAgCj4gICAJaWYgKHBlZXJfZGV2aWNlLT5jb25u
ZWN0aW9uLT5hZ3JlZWRfcHJvX3ZlcnNpb24gPD0gOTQpCgpMR1RNIG5vdywgdGhhbmtzLgoKQWNr
ZWQtYnk6IENocmlzdG9waCBCw7ZobXdhbGRlciA8Y2hyaXN0b3BoLmJvZWhtd2FsZGVyQGxpbmJp
dC5jb20+CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

