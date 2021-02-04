Return-Path: <SRS0=5DIA=HG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F77C43381
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 11:26:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 573CE64DE9
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 11:26:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 573CE64DE9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-0sv4Q5dhNM2P82LtIcRNiA-1; Thu, 04 Feb 2021 06:26:15 -0500
X-MC-Unique: 0sv4Q5dhNM2P82LtIcRNiA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0333CE64B;
	Thu,  4 Feb 2021 11:26:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 179B96F968;
	Thu,  4 Feb 2021 11:26:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 73E6218095CB;
	Thu,  4 Feb 2021 11:26:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 114BQ6hA007650 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Feb 2021 06:26:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 67B752166B2D; Thu,  4 Feb 2021 11:26:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F9AC2166B30
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 11:26:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D98280122F
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 11:26:00 +0000 (UTC)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-511-2_Ln9xKiN_WPpVOc0nywCg-1; Thu, 04 Feb 2021 06:25:55 -0500
X-MC-Unique: 2_Ln9xKiN_WPpVOc0nywCg-1
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DWbmt6KMzzjHQf;
	Thu,  4 Feb 2021 19:24:46 +0800 (CST)
Received: from [10.174.178.113] (10.174.178.113) by
	DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server
	id 14.3.498.0; Thu, 4 Feb 2021 19:25:42 +0800
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel mailing list
	<dm-devel@redhat.com>
References: <063bbeeb-15aa-f7c0-b881-7526c3a2720c@huawei.com>
	<f86753b17cc7e85e7e0f7e711adec349323a7c5a.camel@suse.com>
	<d8ba8118-ce98-249a-cafd-021f0c1831a5@huawei.com>
	<f1961d4104b14c80183b161a53262e1766e0df70.camel@suse.com>
	<c52487a2-5c15-977c-704b-7cad5f6e275e@huawei.com>
	<cd3cae852bffc2d4a9be2e7f4334eb346cfaae8d.camel@suse.com>
	<ef4f29d8-a20b-2b4d-97ab-a83fb4bca5ac@huawei.com>
	<5440d76a18994a7a214321c30fe8a1e99c0a3988.camel@suse.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <342183ae-ead1-a13f-9384-459d09c04e6c@huawei.com>
Date: Thu, 4 Feb 2021 19:25:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5440d76a18994a7a214321c30fe8a1e99c0a3988.camel@suse.com>
X-Originating-IP: [10.174.178.113]
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 114BQ6hA007650
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>, lihaotian9@huawei.com
Subject: Re: [dm-devel] [QUESTION]: multipath device with wrong path lead to
	metadata err
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

CkhpIE1hcnRpbiwKCk9uIDIwMjEvMS8yNyA3OjExLCBNYXJ0aW4gV2lsY2sgd3JvdGU6Cj4gU28g
d2UgY2FuIG9ubHkgY29uY2x1ZGUgdGhhdCAoaWYgdGhlcmUncyBubyBrZXJuZWwgcmVmY291bnRp
bmcgYnVnLAo+IHdoaWNoIEkgZG91YnQpIGVpdGhlciBvcnBoYW5fcGF0aCgpLT51bmluaXRpYWxp
emVfcGF0aCgpIGhhZCBiZWVuCj4gY2FsbGVkIChjbG9zaW5nIHRoZSBmZCksICBvciB0aGF0IG9w
ZW5pbmcgdGhlIHNkIGRldmljZSBoYWQgZmFpbGVkIGluCj4gdGhlIGZpcnN0IHBsYWNlIChpbiB3
aGljaCBjYXNlIHRoZSBwYXRoIFdXSUQgc2hvdWxkIGhhdmUgYmVlbiBudWxsZWQgaW4KPiBwYXRo
aW5mbygpLiBJbiBib3RoIGNhc2VzIGl0IG1ha2VzIGxpdHRsZSBzZW5zZSB0aGF0IHRoZSBwYXRo
IHNob3VsZAo+IHN0aWxsIGJlIHBhcnQgb2YgYSBzdHJ1Y3QgbXVsdGlwYXRoLiAKCkkgaGF2ZSBh
biBpZGVhLgoKSWYgcHAtPmZkIDwgMCAoIkNvdWxkbid0IG9wZW4gZGV2aWNlIG5vZGUiKSwgcGF0
aGluZm8oKSByZXR1cm5zClBBVEhJTkZPX0ZBSUxFRC4gRG9uJ3QgY2xvc2UocHAtPmZkKSBpbiBv
cnBoYW5fcGF0aCgpLiBJdCBtYXkgc29sdmUgdGhlCnByb2JsZW0gKGRldmljZSB3aXRoIHdyb25n
IHBhdGgpLiBJIHdpbGwgdGFrZSBzb21lIHRpbWUgdG8gdGVzdCBpdC4KCkhvd2V2ZXIsIEkgZG9u
4oCZdCBrbm93IGlmIHRoZXJlIGFyZSBwb3RlbnRpYWwgcmlza3MuIERvIHlvdSBoYXZlCnN1Z2dl
c3Rpb25zIGFib3V0IHRoaXM/CgpSZWdhcmRzLApMaXhpYW9rZW5nCgoKLS0KZG0tZGV2ZWwgbWFp
bGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWls
bWFuL2xpc3RpbmZvL2RtLWRldmVs

