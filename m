Return-Path: <SRS0=CL6l=HT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17197C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:41:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7E70064D9A
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:40:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E70064D9A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-rvVmXeE5Mw-bUWpAaqvUTw-1; Wed, 17 Feb 2021 10:40:56 -0500
X-MC-Unique: rvVmXeE5Mw-bUWpAaqvUTw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A06E984E240;
	Wed, 17 Feb 2021 15:40:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 811AA5D9C2;
	Wed, 17 Feb 2021 15:40:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 538A16B502;
	Wed, 17 Feb 2021 15:40:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11H2uMVM017582 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 16 Feb 2021 21:56:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B9F74115589D; Wed, 17 Feb 2021 02:56:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B5D70115589B
	for <dm-devel@redhat.com>; Wed, 17 Feb 2021 02:56:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2DEF800296
	for <dm-devel@redhat.com>; Wed, 17 Feb 2021 02:56:19 +0000 (UTC)
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by relay.mimecast.com with ESMTP id us-mta-430-3ZrfskVHOGqJ2QaRGXz1Uw-1;
	Tue, 16 Feb 2021 21:56:17 -0500
X-MC-Unique: 3ZrfskVHOGqJ2QaRGXz1Uw-1
X-IronPort-AV: E=Sophos;i="5.81,184,1610380800"; d="scan'208";a="104561557"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 17 Feb 2021 10:56:13 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id 374484CE72EC;
	Wed, 17 Feb 2021 10:56:13 +0800 (CST)
Received: from irides.mr (10.167.225.141) by G08CNEXMBPEKD05.g08.fujitsu.local
	(10.167.33.204) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Wed, 17 Feb 2021 10:56:11 +0800
To: Christoph Hellwig <hch@lst.de>
References: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com>
	<20210208105530.3072869-6-ruansy.fnst@cn.fujitsu.com>
	<20210210133347.GD30109@lst.de>
From: Ruan Shiyang <ruansy.fnst@cn.fujitsu.com>
Message-ID: <45a20d88-63ee-d678-ad86-6ccd8cdf7453@cn.fujitsu.com>
Date: Wed, 17 Feb 2021 10:56:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210210133347.GD30109@lst.de>
X-Originating-IP: [10.167.225.141]
X-ClientProxiedBy: G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) To
	G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204)
X-yoursite-MailScanner-ID: 374484CE72EC.AB75D
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 17 Feb 2021 10:31:26 -0500
Cc: y-goto@fujitsu.com, qi.fuli@fujitsu.com, snitzer@redhat.com,
	linux-nvdimm@lists.01.org, rgoldwyn@suse.de,
	darrick.wong@oracle.com, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v3 05/11] mm,
 fsdax: Refactor memory-failure handler for dax mapping
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAyMDIxLzIvMTAg5LiL5Y2IOTozMywgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4+ICtl
eHRlcm4gaW50IG1mX2RheF9tYXBwaW5nX2tpbGxfcHJvY3Moc3RydWN0IGFkZHJlc3Nfc3BhY2Ug
Km1hcHBpbmcsIHBnb2ZmX3QgaW5kZXgsIGludCBmbGFncyk7Cj4gCj4gTm8gbmVlIGZvciB0aGUg
ZXh0ZXJuLCBwbGVhc2UgYXZvaWQgdGhlIG92ZXJseSBsb25nIGxpbmUuCgpPSy4KCkknZCBsaWtl
IHRvIGNvbmZpcm0gb25lIHRoaW5nLi4uICBJIGhhdmUgY2hlY2tlZCBhbGwgb2YgdGhpcyBwYXRj
aHNldCBieSAKY2hlY2twYXRjaC5wbCBhbmQgaXQgZGlkIG5vdCByZXBvcnQgdGhlIG92ZXJseSBs
b25nIGxpbmUgd2FybmluZy4gIFNvLCBJIApzaG91bGQgc3RpbGwgb2JleSB0aGUgcnVsZSBvZiA4
MCBjaGFycyBvbmUgbGluZT8KCj4gCj4+IEBAIC0xMjAsNiArMTIxLDEzIEBAIHN0YXRpYyBpbnQg
aHdwb2lzb25fZmlsdGVyX2RldihzdHJ1Y3QgcGFnZSAqcCkKPj4gICAJaWYgKFBhZ2VTbGFiKHAp
KQo+PiAgIAkJcmV0dXJuIC1FSU5WQUw7Cj4+ICAgCj4+ICsJaWYgKHBmbl92YWxpZChwYWdlX3Rv
X3BmbihwKSkpIHsKPj4gKwkJaWYgKGlzX2RldmljZV9mc2RheF9wYWdlKHApKQo+PiArCQkJcmV0
dXJuIDA7Cj4+ICsJCWVsc2UKPj4gKwkJCXJldHVybiAtRUlOVkFMOwo+PiArCX0KPj4gKwo+IAo+
IFRoaXMgbG9va3Mgb2RkLiAgRm9yIG9uZSB0aGVyZSBpcyBubyBuZWVkIGZvciBhbiBlbHNlIGFm
dGVyIGEgcmV0dXJuLgo+IEJ1dCBtb3JlIGltcG9ydGFudGx5IHBhZ2VfbWFwcGluZygpIGFzIGNh
bGxlZCBiZWxvdyBwcmV0dHkgbXVjaCBhc3N1bWVzCj4gYSB2YWxpZCBQRk4sIHNvIHNvbWV0aGlu
ZyBpcyBmaXNoeSBpbiB0aGlzIGZ1bmN0aW9uLgoKWWVzLCBhIG1pc3Rha2UgaGVyZS4gIEknbGwg
Zml4IGl0LgoKPiAKPj4gKwlpZiAoaXNfem9uZV9kZXZpY2VfcGFnZShwKSkgewo+PiArCQlpZiAo
aXNfZGV2aWNlX2ZzZGF4X3BhZ2UocCkpCj4+ICsJCQl0ay0+YWRkciA9IHZtYS0+dm1fc3RhcnQg
Kwo+PiArCQkJCQkoKHBnb2ZmIC0gdm1hLT52bV9wZ29mZikgPDwgUEFHRV9TSElGVCk7Cj4gCj4g
VGhlIGFyaXRobWV0aWNzIGhlcmUgc2NyZWFtIGZvciBhIGNvbW1vbiBoZWxwZXIsIEkgc3VzcGVj
dCB0aGVyZSBtaWdodAo+IGJlIG90aGVyIHBsYWNlcyB0aGF0IGNvdWxkIHVzZSB0aGUgc2FtZSBo
ZWxwZXIuCj4gCj4+ICtpbnQgbWZfZGF4X21hcHBpbmdfa2lsbF9wcm9jcyhzdHJ1Y3QgYWRkcmVz
c19zcGFjZSAqbWFwcGluZywgcGdvZmZfdCBpbmRleCwgaW50IGZsYWdzKQo+IAo+IE92ZXJseSBs
b25nIGxpbmUuICBBbHNvIHRoZSBuYW1pbmcgc2NoZW1lIHdpdGggdGhlIG1mXyBzZWVtcyByYXRo
ZXIKPiB1bnVzdWFsLiBNYXliZSBkYXhfa2lsbF9tYXBwaW5nX3Byb2NzPyAgQWxzbyBwbGVhc2Ug
YWRkIGEga2VybmVsZG9jCj4gY29tbWVudCBkZXNjcmliaW5nIHRoZSBmdW5jdGlvbiBnaXZlbiB0
aGF0IGl0IGV4cG9ydGVkLgo+IAoKT0suICBUaGFua3MgZm9yIHlvdXIgZ3VpZGFuY2UuCgoKLS0K
VGhhbmtzLApSdWFuIFNoaXlhbmcuCgo+IAoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1k
ZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWw=

