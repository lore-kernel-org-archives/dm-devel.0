Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4B56C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  7 Jun 2022 07:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1654586215;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NfGRE5eHS8EXv1rLp/wceCfGdBCHmYvQ1k8L0OGvQHI=;
	b=UYbzlK3A/W2pn/vQvOd0VcEh1KAKKkWE3V3lHssoCAFMEYcM3fON/To+m6Gc6CaZBY/xcH
	+fw0xWS6VUPmZQz86aLgDtXZwYhZe6WnoJ7/wWFwy4osvqtbfLRRhwE0xZLijPkyMhzYuW
	NDz79xV4hD1PLRuO/8XBUL+wNu535d0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-RU_RyqR0NTy3SC5VWmJpBg-1; Tue, 07 Jun 2022 03:16:52 -0400
X-MC-Unique: RU_RyqR0NTy3SC5VWmJpBg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C06773C0F720;
	Tue,  7 Jun 2022 07:16:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 097F4492C3B;
	Tue,  7 Jun 2022 07:16:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8D71119451EF;
	Tue,  7 Jun 2022 07:16:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5DA37194707B
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Jun 2022 15:44:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4E4CF2166B29; Mon,  6 Jun 2022 15:44:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A8AF2166B26
 for <dm-devel@redhat.com>; Mon,  6 Jun 2022 15:44:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FC82395AFFA
 for <dm-devel@redhat.com>; Mon,  6 Jun 2022 15:44:02 +0000 (UTC)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-W-dM898sORq6eD0xcSkdAg-1; Mon, 06 Jun 2022 11:44:01 -0400
X-MC-Unique: W-dM898sORq6eD0xcSkdAg-1
Received: by mail-qv1-f69.google.com with SMTP id
 j2-20020a0cfd42000000b0045ad9cba5deso9005612qvs.5
 for <dm-devel@redhat.com>; Mon, 06 Jun 2022 08:44:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent
 :content-language:to:from:subject:content-transfer-encoding;
 bh=2J3pVn6Ghuh9BzQP42X/eKoEzcD+jEfFYQVoV++CGuw=;
 b=181I9XRgu61hcAirTinhQkNXC6msf+q78Tz/QaRQPuAdzkNuzL+7EtvJkKZSXiYrSd
 wjyG5sfhfjd08ajY3iEVhX82f65hZkLjOtdP1B/X6iJoEaoRFaoXl+cYsBCYmfV04mSi
 C2Zor21Fac1LYiMamTr8hpoc2KIvT+FEhVWQHSpZufEQS5qzDcy2uZvZX+X+ri0FwnZD
 IC8aApXNTWu1mOwPfsGv3Y8HsYD1bVgXHENRmVeAtD01VoWQQd4S+MVl58WqbWt2m2SS
 gmC9xVjPOnr4lByp1Oe6lXZ6d0hC1EHZqBgv+Mff4180CHT/aubARXRX9synFQ0QBamr
 VfvQ==
X-Gm-Message-State: AOAM532LSvULuqlHTLxqdY7kGHL0AAOT+3Md6w7UYQQFz6pp/8pP/wWP
 YuOvy9QFiXUeJQiO++cd3UupWFEbnu5on2gy4VTHmvu3zZNJCd7HdCywNfkb5h9RAcD14gn2qKV
 LTi6yfmJkcGkx88NgvcxH9Jm37YmNzeuG/bQO3HQWI8ugX7EPg+AFEOXDlRXN7v7OBQ==
X-Received: by 2002:a05:622a:1212:b0:303:8ea3:2070 with SMTP id
 y18-20020a05622a121200b003038ea32070mr19035106qtx.269.1654530240171; 
 Mon, 06 Jun 2022 08:44:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9+qR0QMWxRiCSqK9kSS+yznPMb4Z4PRpz5nABTZKvuD0MqsKKURtGdhvvn81eKAdxvxsJNQ==
X-Received: by 2002:a05:622a:1212:b0:303:8ea3:2070 with SMTP id
 y18-20020a05622a121200b003038ea32070mr19035082qtx.269.1654530239834; 
 Mon, 06 Jun 2022 08:43:59 -0700 (PDT)
Received: from ?IPV6:2600:1000:b024:4ef8:4c3:4879:d098:e730?
 ([2600:1000:b024:4ef8:4c3:4879:d098:e730])
 by smtp.gmail.com with ESMTPSA id
 bi35-20020a05620a31a300b006a671be3abesm10068537qkb.93.2022.06.06.08.43.59
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 06 Jun 2022 08:43:59 -0700 (PDT)
Message-ID: <b65d1bbb-7367-3a51-ba21-9de057a435fc@redhat.com>
Date: Mon, 6 Jun 2022 11:43:58 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: dm-devel@redhat.com
From: Tony Camuso <tcamuso@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mailman-Approved-At: Tue, 07 Jun 2022 07:16:47 +0000
Subject: [dm-devel] Device Mapper being derailed in tboot launch
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

Ck9ubHkgb25lIHN5c3RlbSBJJ3ZlIGVuY291bnRlcmVkIGV4aGliaXRzIHRoaXMgcHJvYmxlbSwg
dGhlCmxlbm92byBzdDI1MHYyLiBXaGVuIEkgYm9vdCBub3JtYWxseSwgYWxsIHRoZSBkZXZpY2Vz
IGFyZQpmb3VuZCBhbmQgYm9vdCBzdWNjZWVkcy4KCldoZW4gSSBib290IHRocm91Z2ggdGJvb3Qs
IERNIGRvZXMgbm90IHNlZW0gdG8gYmUgYWJsZSB0bwpmaW5kIHRoZSByb290IGFuZCBzd2FwIGRl
dmljZXMuCgpCZWxvdyBhcmUgYm9vdGxvZyBzbmlwcGV0cyBmcm9tIGEgc3VjY2Vzc2Z1bCBib290
IGFuZCBhIGZhaWxpbmcKYm9vdC4KCkNhbiBzb21lYm9keSB0ZWxsIG1lIHdoZXJlIHRvIGxvb2sg
Zm9yIHRoZSBzb3VyY2Ugb2YgdGhpcyBmYWlsdXJlPwpJcyB0aGVyZSBkZWJ1ZyBjb2RlIG9yIERN
IHV0aWxpdGllcyB0byBoZWxwIGlkZW50aWZ5IHRoZSBwcm9ibGVtPwpJcyB0aGVyZSBzb3VyY2Ug
Y29kZSBJIGNhbiBpbXBsZW1lbnQgdG8gaXNvbGF0ZSB0aGUgZmFpbHVyZSBwb2ludD8KCgpTdWNj
ZXNzZnVsIGJvb3Rsb2cgc25pcHBldDoKClsgICAgMy44NDM5MTFdIHNkIDU6MDowOjA6IFtzZGFd
IEF0dGFjaGVkIFNDU0kgZGlzawpbICAgIDMuODQ4MzcwXSBzZCA2OjA6MDowOiBbc2RiXSBBdHRh
Y2hlZCBTQ1NJIGRpc2sKWyAgICAzLjkyNTYzOV0gbWQxMjY6IGRldGVjdGVkIGNhcGFjaXR5IGNo
YW5nZSBmcm9tIDAgdG8gMTkwMDM4MjUxOTI5NgpbICAgIDMuOTQ2MzA3XSAgbWQxMjY6IHAxIHAy
IHAzClsgIE9LICBdIEZvdW5kIGRldmljZSAvZGV2L21hcHBlci9yaGVsX2xlbm92by0tc3QyNTB2
Mi0tMDItcm9vdC4KWyAgT0sgIF0gUmVhY2hlZCB0YXJnZXQgSW5pdHJkIFJvb3QgRGV2aWNlLgpb
ICBPSyAgXSBGb3VuZCBkZXZpY2UgL2Rldi9tYXBwZXIvcmhlbF9sZW5vdm8tLXN0MjUwdjItLTAy
LXN3YXAuCiAgICAgICAgICBTdGFydGluZyBSZXN1bWUgZnJvbSBoaWJlcm5hdGlvbiB1c+KApnIv
cmhlbF9sZW5vdm8tLXN0MjUwdjItLTAyLXN3YXAuLi4KWyAgT0sgIF0gU3RhcnRlZCBSZXN1bWUg
ZnJvbSBoaWJlcm5hdGlvbiB1c2nigKZwZXIvcmhlbF9sZW5vdm8tLXN0MjUwdjItLTAyLXN3YXAu
ClsgIE9LICBdIFJlYWNoZWQgdGFyZ2V0IExvY2FsIEZpbGUgU3lzdGVtcyAoUHJlKS4KCkZhaWxp
bmcgYm9vdGxvZyBzbmlwcGV0OgoKWyAgICA0LjU3ODIwNV0gc2QgNTowOjA6MDogW3NkYV0gQXR0
YWNoZWQgU0NTSSBkaXNrClsgICAgNC41ODEwMDBdIHNkIDY6MDowOjA6IFtzZGJdIEF0dGFjaGVk
IFNDU0kgZGlzawpbIFRJTUUgXSBUaW1lZCBvdXQgd2FpdGluZyBmb3IgZGV2aWNlIGRldi1tYeKA
pmRzdDI1MHYyXHgyZFx4MmQwMlx4MmRzd2FwLmRldmljZS4KW0RFUEVORF0gRGVwZW5kZW5jeSBm
YWlsZWQgZm9yIFJlc3VtZSBmcm9tIGjigKZwZXIvcmhlbF9sZW5vdm8tLXN0MjUwdjItLTAyLXN3
YXAuCiAgCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

