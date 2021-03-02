Return-Path: <SRS0=Fgdj=IA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C0E8C433E0
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 10:15:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F41A464F0E
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 10:15:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F41A464F0E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-b5HVOnHdMS-AFvrv5SNb6A-1; Tue, 02 Mar 2021 05:15:38 -0500
X-MC-Unique: b5HVOnHdMS-AFvrv5SNb6A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 536A31966322;
	Tue,  2 Mar 2021 10:15:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 105FD5945F;
	Tue,  2 Mar 2021 10:15:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 10D5A18095CB;
	Tue,  2 Mar 2021 10:15:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 122AFRns015903 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Mar 2021 05:15:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 976122167D67; Tue,  2 Mar 2021 10:15:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 921272167D60
	for <dm-devel@redhat.com>; Tue,  2 Mar 2021 10:15:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D7A480A0A5
	for <dm-devel@redhat.com>; Tue,  2 Mar 2021 10:15:25 +0000 (UTC)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com
	[209.85.221.41]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-512-KTjWwh8KMHGEhIoPGddI4A-1; Tue, 02 Mar 2021 05:15:23 -0500
X-MC-Unique: KTjWwh8KMHGEhIoPGddI4A-1
Received: by mail-wr1-f41.google.com with SMTP id h98so19200268wrh.11
	for <dm-devel@redhat.com>; Tue, 02 Mar 2021 02:15:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:subject:to:references:message-id:date
	:mime-version:in-reply-to:content-language:content-transfer-encoding;
	bh=Aw2Mv6Mh4xBeSYbh9AhK1wS9kX61fULdBI6AlSjp+2M=;
	b=Ymaw4fiqnHBQlwQDYwYsTH6cpDL+hNSbTK/mSS04yEagV+oc6oBrVzjGsiH7ZsE819
	H7Kb6TBPM3RdW/KUP9ftQXdOKyKZy19Fm+mZ9RE81rEpMz64AV4E9mqI7o49srm/dCk4
	OVq/5emga535hIPql6OFjU9TI6Wu1bziHIbiW96d4D1VI1HmwppJD2ENNNqg26TZSh6e
	KeP5SW9YxB1EXGjoaqdtp+eJD6dhdJ2dVuGLzQ6EOO+9aca40tewf7TQ+q0xYG8SBlND
	eiRUL7lZvMjN3j3eHOcMwBqsBVhRmlt7OZU1VbzY13o9S7HXXz7qS8bEpilF/OtIJMbv
	pAzw==
X-Gm-Message-State: AOAM530FkeRdlksybjZ5/UCZBEp7TnwMPkivJR1kJqKgS0wtGhhUUdg4
	x/SamIXJHJ/bjXMAfrC/wUWVBFhIzQ==
X-Google-Smtp-Source: ABdhPJwHsmdegGix0pn0lILr4sNK3gNfhull3YwwRwfC/kEOguiWQ6L0zfQ5KpFKkvzjAbvBAhq+JA==
X-Received: by 2002:adf:aa08:: with SMTP id p8mr20863087wrd.232.1614680121864; 
	Tue, 02 Mar 2021 02:15:21 -0800 (PST)
Received: from localhost (85.red-83-52-39.dynamicip.rima-tde.net.
	[83.52.39.85])
	by smtp.gmail.com with ESMTPSA id f14sm2175620wmf.7.2021.03.02.02.15.21
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 02 Mar 2021 02:15:21 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: Benoit Chatelain <bchatelain@cines.fr>, DM-DEVEL ML <dm-devel@redhat.com>
References: <388321540.261431070.1614606275832.JavaMail.zimbra@cines.fr>
Message-ID: <e8c80d5b-419e-2799-072e-4a2e91940838@gmail.com>
Date: Tue, 2 Mar 2021 11:15:19 +0100
MIME-Version: 1.0
In-Reply-To: <388321540.261431070.1614606275832.JavaMail.zimbra@cines.fr>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] multipath with SAS and FC.
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMy8xLzIxIDI6NDQgUE0sIGJjaGF0ZWxhaW5AY2luZXMuZnIgd3JvdGU6Cgo+IEkgdHJ5IHRv
IHVzZSBtdWx0aXBhdGggd2l0aCBTQVMgZGlzaywgdHJhbnNwb3J0ZWQgYnkgRmliZXIgQ2hhbm5l
bCwgb24KPiBEZWxsIENvbXBlbGxlbnQuCj4gTXkgdm9sdW1lIGlzIGRldGVjdGVkIG9uIDJ4IFI0
NDAgUG93ZXJFZGdlIGhvc3RlZCBieSBDZW50b3MgOCBhbmQKPiBvcmNoZXN0cmF0ZWQgYnkgb1Zp
cnQuCj4gWy4uLl0KPiAjIG11bHRpcGF0aCAtbGwKPiAzNjAwMGQzMTAwM2Q1YzIwMDAwMDAwMDAw
MDAwMDAwMTAgZG0tMyBDT01QRUxOVCxDb21wZWxsZW50IFZvbAo+IHNpemU9MS41VCBmZWF0dXJl
cz0nMSBxdWV1ZV9pZl9ub19wYXRoJyBod2hhbmRsZXI9JzEgYWx1YScgd3A9cncKPiBgLSstIHBv
bGljeT0nc2VydmljZS10aW1lIDAnIHByaW89MjUgc3RhdHVzPWFjdGl2ZQo+ICDCoMKgIHwtIDE6
MDowOjIgc2RiIDg6MTYgYWN0aXZlIHJlYWR5IHJ1bm5pbmcKPiAgwqDCoCBgLSAxOjA6MToyIHNk
YyA4OjMyIGZhaWxlZCByZWFkeSBydW5uaW5nIMKgIC0tIGxvb3BpbmcgZmFpbGVkL3JlYWR5CgpU
aGUgZGVmYXVsdCBtcHQgY29uZmlnIGZvciAiQ09NUEVMTlQvQ29tcGVsbGVudCBWb2wiIGlzIGFs
cmVhZHkgIm11bHRpYnVzIi4KVGhlcmUgaXMgbm8gbmVlZCB0byBhZGQgYSBjdXN0b20gY29uZmln
IHRvIC9ldGMvbXVsdGlwYXRoLmNvbmYuCgpUcnk6CiMgc2F2ZSBvbGQgY29uZmlncwptdiAvZXRj
L211bHRpcGF0aC5jb25mIC9ldGMvX211bHRpcGF0aC5jb25mLSQoZGF0ZSArJXMpCmNwIC1hIC9l
dGMvbXVsdGlwYXRoL3d3aWRzIC9ldGMvbXVsdGlwYXRoL193d2lkcy0kKGRhdGUgKyVzKQojIHJl
Y29uZmlnIG1wCm1wYXRoY29uZiAtLWVuYWJsZSAtLXVzZXJfZnJpZW5kbHlfbmFtZXMgbgptdWx0
aXBhdGggLVcKc3lzdGVtY3RsIGVuYWJsZSBtdWx0aXBhdGhkLnNlcnZpY2UKIyByZWNyZWF0ZSBp
bml0cmQsIGFuZCByZWJvb3QgdGhlIHN5c3RlbQpkcmFjdXQgLWYKaW5pdCA2CgoKSWYgdGhlIGRl
ZmF1bHQgbW9kZSBvZiAiQ09NUEVMTlQvQ29tcGVsbGVudCBWb2wiIGFycmF5cyBXRVJFIENIQU5H
RUQgdG8gQUxVQSwKKGRtZXNnIC1UIHwgZ3JlcCAtaSBhbHVhKS4gVGhlIC9ldGMvbXVsdGlwYXRo
LmNvbmYgZmlsZSBtdXN0IGNvbnRhaW46CgpkZXZpY2VzIHsKCWRldmljZSB7CgkJdmVuZG9yICJD
T01QRUxOVCIKCQlwcm9kdWN0ICJDb21wZWxsZW50IFZvbCIKCQlwYXRoX2dyb3VwaW5nX3BvbGlj
eSAiZ3JvdXBfYnlfcHJpbyIKCQlwcmlvICJhbHVhIgoJCWZhaWxiYWNrICJpbW1lZGlhdGUiCgkJ
bm9fcGF0aF9yZXRyeSAzMAoJfQp9CgpGb2xsb3cgdGhlIHNhbWUgc3RlcHMsIGJ1dCBiZWZvcmUg
ImRyYWN1dCAtZiIgYWRkIHRoYXQgY29uZmlnIHRvIC9ldGMvbXVsdGlwYXRoLmNvbmYKCi0tCmRt
LWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5y
ZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

