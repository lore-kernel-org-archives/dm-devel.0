Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2369BC4321E
	for <dm-devel@archiver.kernel.org>; Sat,  3 Dec 2022 00:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670025663;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tdyn+lUZSKwcRLXiZ3ioZvYEThbnSa1cjhQZjThVA6w=;
	b=cHD8ek3nYYiXLocQNOl+H4G8+Q1Y7gJtb8bPAVq60dN6UarHIHH3lnrqlUO9XISfXrL1XH
	RboRtlHXHDlFHCIN0RgYAEB2w0diUrBe3qDBvYqlZtXkmctm5DQKeTyxOMTNzhCj+wwoYy
	h4H7FOBTiKSfB9h5+v9Fzap7e4Asl54=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-rDjU0NQhOve-59mkKrdOow-1; Fri, 02 Dec 2022 19:01:00 -0500
X-MC-Unique: rDjU0NQhOve-59mkKrdOow-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DAE238041C4;
	Sat,  3 Dec 2022 00:00:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 12FC040CA40C;
	Sat,  3 Dec 2022 00:00:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D898C194658F;
	Sat,  3 Dec 2022 00:00:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7E5F11946587
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Dec 2022 00:00:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 61451403350; Sat,  3 Dec 2022 00:00:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 59B4B492B06
 for <dm-devel@redhat.com>; Sat,  3 Dec 2022 00:00:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F09B101A52A
 for <dm-devel@redhat.com>; Sat,  3 Dec 2022 00:00:55 +0000 (UTC)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com
 [209.85.128.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-590-8mtRKgjfMkyv1xvxzzFYYQ-1; Fri, 02 Dec 2022 19:00:51 -0500
X-MC-Unique: 8mtRKgjfMkyv1xvxzzFYYQ-1
Received: by mail-wm1-f46.google.com with SMTP id
 h4-20020a1c2104000000b003d0760654d3so6249236wmh.4; 
 Fri, 02 Dec 2022 16:00:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=C7wXUnlikAnQqaemMaxFq8uoLGv5gyQiZ2+h29eSArQ=;
 b=Gqcro0QSdmTD66KzghsDEvbMp9kaboQUUUCJYJv31H0Kai7zkTQR4nINLvVe+2Ri4c
 9mzDz0IuEUkwDVM87M6qXH6/2TquV5ZdN6fLG417c3W7AEO52pkxelxltxf9k9iGRDYq
 hwPb9mEkXNxcxclkY+QG53pQefDNZrEfmsZELweVud9KtHOZEt8Ir/IT0cyHbwnaaPQI
 9yFINx6XEvcMLAMHd25mdqNZCgWpbDlnqwQzu77AwODp8v7mNIy3OeH5oQah47IhjQ6V
 GrtfPh1NZWcD9m5OLvQlFZ2yn4fMsHvr2xGi3vRSKFhBQvZOsu72qSnHRxhlPVKTo7iA
 TO5w==
X-Gm-Message-State: ANoB5pkOFWYCTFuAeZ1jNcWn8l6SscK+aaqWhze7jzKW20mzQmeWZnhu
 oEog+K7ChxE16xm6pWlhGrurXIkoNw==
X-Google-Smtp-Source: AA0mqf5ga0vrEovwAJhuHOj9e9wfwxPUKl7ZW3s5dQ/9Xqy7zgQGyRnAt3ZVGKFiASoWP08yAMsuIw==
X-Received: by 2002:a05:600c:540a:b0:3d0:50c4:432c with SMTP id
 he10-20020a05600c540a00b003d050c4432cmr23554971wmb.67.1670025650104; 
 Fri, 02 Dec 2022 16:00:50 -0800 (PST)
Received: from localhost (230.red-81-44-152.dynamicip.rima-tde.net.
 [81.44.152.230]) by smtp.gmail.com with ESMTPSA id
 i1-20020adfaac1000000b002238ea5750csm10103569wrc.72.2022.12.02.16.00.49
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 02 Dec 2022 16:00:49 -0800 (PST)
Message-ID: <8f752418-2136-c464-34bb-1099e8491642@gmail.com>
Date: Sat, 3 Dec 2022 01:00:49 +0100
MIME-Version: 1.0
To: Martin Wilck <mwilck@suse.com>, Roger Heflin <rogerheflin@gmail.com>
References: <20221201103238.2601-1-mwilck@suse.com>
 <20221201103238.2601-2-mwilck@suse.com>
 <1d35c16a-105f-a2aa-ca5d-a952e505d9b0@gmail.com>
 <90467d9459a95a6910f55f3e0f93163a6541429a.camel@suse.com>
 <91e6e7158648b2f5f2bc583e62c9563f5d8fe914.camel@suse.com>
 <CAAMCDec=joUfwX3TFGPTAFB8UP7ihxqOz5EiLR-Mp2yJQtSsnQ@mail.gmail.com>
 <e506d4c8d63e0fda3c28297c4316b49c0e2a9fb1.camel@suse.com>
 <CAAMCDeeAQL8yaq2HVE+hFdYv=Ax7aSCn0gqKEW2AV-jzzN9esg@mail.gmail.com>
 <cf398b5ccefd3a1a6f458ab5e4811f8f6afc415c.camel@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <cf398b5ccefd3a1a6f458ab5e4811f8f6afc415c.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 2/2] multipath.conf(5): improve documentation
 of dev_loss_tmo
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTIvMy8yMiAwMDo1MCwgTWFydGluIFdpbGNrIHdyb3RlOgoKPiBPbiBGcmksIDIwMjItMTIt
MDIgYXQgMTc6NDQgLTA2MDAsIFJvZ2VyIEhlZmxpbiB3cm90ZToKPj4gVGhhbmtzLgo+Pgo+PiBU
aGUgb2xkZXIgZGlzdHJpYnV0aW9uIEkgY2hlY2tlZCBoYXMgdGhpcyBmb3IgLVQKPj4gIMKgIMKg
wqAgLVQgdG06dmFsaWQKPj4gIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNoZWNrIGlmIHRtIG1hdGNo
ZXMgdGhlIG11bHRpcGF0aGQgY29uZmlndXJhdGlvbgo+PiB0aW1lc3RhbXAgdmFsdWUgZnJvbSAv
cnVuL211bHRpcGF0aGQvdGltZXN0YW1wIElmIHNvLCByZXR1cm4gc3VjY2Vzcwo+PiBpZiB2YWxp
ZCBpcyAxLiBPdGhlcndpc2UsIHJldHVybiBmYWlsdXJlLiBJZiB0aGUgdGltZXN0YW1wIGRvZXNu
J3QKPj4gbWF0Y2ggY29udGludWUgd2l0aCBtdWx0aXBhdGggZXhlY3V0aW9uLsKgIFRoaXMgb3B0
aW9uIGlzIGRlc2lnbmVkIHRvCj4+IGJlIHVzZWQgd2l0aCAtYyBieSB0aGUgdWRldiBydWxlcy4K
PiAKPiBTdHJhbmdlLCBJIGNhbid0IGZpbmQgdGhpcyBhbnl3aGVyZSBpbiB0aGUgc291cmNlcyBJ
IGtub3cuCj4gV2hhdCBkaXN0cm8gaXMgdGhpcz8gIm11bHRpcGF0aCAtVCIgaW4gdGhlIHNlbnNl
IEkgZGVzY3JpYmVkIGhhcwo+IGV4aXN0ZWQgc2luY2UgMC43LjcsIHNvIGZvciBtb3JlIHRoYW4g
NCB5ZWFycy4KClJIOiBodHRwczovL3NyYy5mZWRvcmFwcm9qZWN0Lm9yZy9ycG1zL2RldmljZS1t
YXBwZXItbXVsdGlwYXRoL2Jsb2IvNjczOGIzNGEwYjBhYWJmMWJjOGMxNWQ1NDBiYWZhMjljYTk5
YzU4Zi9mLzAxNTgtUkhCWi0xMzE4NTgxLXRpbWVzdGFtcC1kb2MtZml4LnBhdGNoCgotLQpkbS1k
ZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

