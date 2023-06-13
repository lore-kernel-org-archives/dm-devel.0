Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36DCBC7EE2E
	for <dm-devel@archiver.kernel.org>; Tue, 13 Jun 2023 12:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686659180;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DV/DCkN322KAIsBQv1VbJYTPO4RdP4xlphNcVOsA8j8=;
	b=FmSBYgN+H5NgRjH4iU8qlLP9EUupsHBGJrpNmPohm2XRHoI/mqWPh+ZzXT101qBlim7j9H
	XL+uXuiNqtisl6W0jR08q6bJAeAzLKBZtoJr70umpJ1jO+esiUjukby8MAVadEf521P/Ft
	0soPQP/MCdXVpJ2tPvXoXZX1td/Vb+c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-1SKI0puAMrKC0IaDZp0gng-1; Tue, 13 Jun 2023 08:26:17 -0400
X-MC-Unique: 1SKI0puAMrKC0IaDZp0gng-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CB2F8039C9;
	Tue, 13 Jun 2023 12:26:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4F51E2026834;
	Tue, 13 Jun 2023 12:26:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1F62A1946A42;
	Tue, 13 Jun 2023 12:26:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EE969194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 13 Jun 2023 12:26:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DCD88492B0B; Tue, 13 Jun 2023 12:26:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D54C3492C1B
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 12:26:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA7DE1C05AB8
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 12:26:12 +0000 (UTC)
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-228-TAVlA6beNNO70080K6eG-Q-1; Tue, 13 Jun 2023 08:26:11 -0400
X-MC-Unique: TAVlA6beNNO70080K6eG-Q-1
Received: by mail-oi1-f197.google.com with SMTP id
 5614622812f47-39aa9617c6bso3374896b6e.1
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 05:26:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686659170; x=1689251170;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=kdc7U94xkVs29WOVZE2o7NQmpfO54OWwBKACRIySOxQ=;
 b=TvlSanL0lyBLmfbofhA8iNeVJA431sEX4eFDj/u+GOT444JnRMDOt/sQMnbyVZ9Xji
 vA0huRlNxoZv3JAwkzNNPfobJKcpUfGbriFLRnQL71woRpqN5YaFe2Bb+Yz+8+p5fBQ+
 bXWTVxcEGjeAAIOkUWfH3QxLDAPDvWc0t4HPo78Fpef+fAfNik8tIpsVPAPAE5eOLzIG
 be/kNfcF0HrlPw/28u29c9a2SGGMx3j+t6KxT73PIB95ECPD5FTSGDMENPeUlJ1A7Q/B
 pavr+FZ+atpzbU7DhIom/GXN2khAh4RoNVYBJaaKGKCXgihtt7FOGxpp5JROcqbyVKls
 A/Rg==
X-Gm-Message-State: AC+VfDyC3FTtM8oPVtVa3cdNTi1/x97kisi+HaCuBPDslwp64U3Gjfjb
 5EE1w2/WGKiX0K3iIizEWjFciW/W6MZ+kQffGhPfGdNvmc30T6hUsUg3tswfvoSUmZOQl0k+YuO
 eHIa/pQ0+NqaAKoenwuxUx33O620ssfk=
X-Received: by 2002:a05:6808:aa6:b0:39c:7a71:945 with SMTP id
 r6-20020a0568080aa600b0039c7a710945mr6665210oij.56.1686659170674; 
 Tue, 13 Jun 2023 05:26:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ78NH/EDUObpqeiuWTv/ei0rcNTq2G3JcAYYkdP6lUVZNrwES4dFqTfrj6xUXLkqd2QPOhn4hynFlH1BTjrtsI=
X-Received: by 2002:a05:6808:aa6:b0:39c:7a71:945 with SMTP id
 r6-20020a0568080aa600b0039c7a710945mr6665199oij.56.1686659170481; Tue, 13 Jun
 2023 05:26:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-3-yukuai1@huaweicloud.com>
 <b780ccfd-66b1-fdd1-b33e-aa680fbd86f1@redhat.com>
 <1aaf9150-bbd3-87a8-8d54-8b5d63ab5ed3@huaweicloud.com>
In-Reply-To: <1aaf9150-bbd3-87a8-8d54-8b5d63ab5ed3@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 13 Jun 2023 20:25:59 +0800
Message-ID: <CALTww2-ta1NUJxcT3Dq5KP7iunnVx24X7RKj1OKYTYwEPeDNrg@mail.gmail.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH -next v2 2/6] md: refactor action_store() for
 'idle' and 'frozen'
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBKdW4gMTMsIDIwMjMgYXQgODowMOKAr1BNIFl1IEt1YWkgPHl1a3VhaTFAaHVhd2Vp
Y2xvdWQuY29tPiB3cm90ZToKPgo+IEhpLAo+Cj4g5ZyoIDIwMjMvMDYvMTMgMTY6MDIsIFhpYW8g
Tmkg5YaZ6YGTOgo+ID4KPiA+IOWcqCAyMDIzLzUvMjkg5LiL5Y2IOToyMCwgWXUgS3VhaSDlhpnp
gZM6Cj4gPj4gRnJvbTogWXUgS3VhaSA8eXVrdWFpM0BodWF3ZWkuY29tPgo+ID4+Cj4gPj4gUHJl
cGFyZSB0byBoYW5kbGUgJ2lkbGUnIGFuZCAnZnJvemVuJyBkaWZmZXJlbnRseSB0byBmaXggYSBk
ZWFkbG9jaywKPiA+PiB0aGVyZQo+ID4+IGFyZSBubyBmdW5jdGlvbmFsIGNoYW5nZXMgZXhjZXB0
IHRoYXQgTURfUkVDT1ZFUllfUlVOTklORyBpcyBjaGVja2VkCj4gPj4gYWdhaW4gYWZ0ZXIgJ3Jl
Y29uZmlnX211dGV4JyBpcyBoZWxkLgo+ID4KPiA+Cj4gPiBDYW4geW91IGV4cGxhaW4gbW9yZSBh
Ym91dCB3aHkgaXQgbmVlZHMgdG8gY2hlY2sgTURfUkVDT1ZFUllfUlVOTklORwo+ID4gYWdhaW4g
aGVyZT8KPgo+IEFzIEkgZXhwbGFpbiBpbiB0aGUgZm9sbG93aW5nIGNvbW1lbnQ6CgpIaQoKV2hv
IGNhbiBjbGVhciB0aGUgZmxhZyBiZWZvcmUgdGhlIGxvY2sgaXMgaGVsZD8KClJlZ2FyZHMKWGlh
bwo+ID4+ICsgICAgLyoKPiA+PiArICAgICAqIENoZWNrIGFnYWluIGluIGNhc2UgTURfUkVDT1ZF
UllfUlVOTklORyBpcyBjbGVhcmVkIGJlZm9yZSBsb2NrIGlzCj4gPj4gKyAgICAgKiBoZWxkLgo+
ID4+ICsgICAgICovCj4gPj4gKyAgICBpZiAoIXRlc3RfYml0KE1EX1JFQ09WRVJZX1JVTk5JTkcs
ICZtZGRldi0+cmVjb3ZlcnkpKSB7Cj4gPj4gKyAgICAgICAgbWRkZXZfdW5sb2NrKG1kZGV2KTsK
PiA+PiArICAgICAgICByZXR1cm47Cj4gPj4gKyAgICB9Cj4KPiBUaGFua3MsCj4gS3VhaQo+Cgot
LQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3Rt
YW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

