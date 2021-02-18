Return-Path: <SRS0=AGY1=HV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A87ABC433DB
	for <dm-devel@archiver.kernel.org>; Fri, 19 Feb 2021 08:17:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E6FF864D5D
	for <dm-devel@archiver.kernel.org>; Fri, 19 Feb 2021 08:17:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E6FF864D5D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-i4BEabQVNCOhLnxudSrZKQ-1; Fri, 19 Feb 2021 03:17:53 -0500
X-MC-Unique: i4BEabQVNCOhLnxudSrZKQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6565E80364D;
	Fri, 19 Feb 2021 08:17:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7566418F0A;
	Fri, 19 Feb 2021 08:17:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 065A418095CB;
	Fri, 19 Feb 2021 08:17:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11I90CMx021947 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Feb 2021 04:00:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CFDBB202A45E; Thu, 18 Feb 2021 09:00:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CA69D201864E
	for <dm-devel@redhat.com>; Thu, 18 Feb 2021 09:00:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53E638007D9
	for <dm-devel@redhat.com>; Thu, 18 Feb 2021 09:00:10 +0000 (UTC)
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by relay.mimecast.com with ESMTP id us-mta-495-lYq6yjvuPoS8c9bHa3-3eQ-1;
	Thu, 18 Feb 2021 04:00:06 -0500
X-MC-Unique: lYq6yjvuPoS8c9bHa3-3eQ-1
X-IronPort-AV: E=Sophos;i="5.81,186,1610380800"; d="scan'208";a="104601999"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 18 Feb 2021 17:00:03 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id 2F5E34CE72E3;
	Thu, 18 Feb 2021 16:59:58 +0800 (CST)
Received: from irides.mr (10.167.225.141) by G08CNEXMBPEKD05.g08.fujitsu.local
	(10.167.33.204) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Thu, 18 Feb 2021 16:59:57 +0800
To: Christoph Hellwig <hch@lst.de>
References: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com>
	<20210208105530.3072869-6-ruansy.fnst@cn.fujitsu.com>
	<20210210133347.GD30109@lst.de>
	<45a20d88-63ee-d678-ad86-6ccd8cdf7453@cn.fujitsu.com>
	<20210218083230.GA17913@lst.de>
From: Ruan Shiyang <ruansy.fnst@cn.fujitsu.com>
Message-ID: <9edffa8e-faf8-3d29-6ec0-69ad512e7bb7@cn.fujitsu.com>
Date: Thu, 18 Feb 2021 16:59:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210218083230.GA17913@lst.de>
X-Originating-IP: [10.167.225.141]
X-ClientProxiedBy: G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) To
	G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204)
X-yoursite-MailScanner-ID: 2F5E34CE72E3.AE2D0
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 19 Feb 2021 03:17:40 -0500
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAyMDIxLzIvMTgg5LiL5Y2INDozMiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gT24g
V2VkLCBGZWIgMTcsIDIwMjEgYXQgMTA6NTY6MTFBTSArMDgwMCwgUnVhbiBTaGl5YW5nIHdyb3Rl
Ogo+PiBJJ2QgbGlrZSB0byBjb25maXJtIG9uZSB0aGluZy4uLiAgSSBoYXZlIGNoZWNrZWQgYWxs
IG9mIHRoaXMgcGF0Y2hzZXQgYnkKPj4gY2hlY2twYXRjaC5wbCBhbmQgaXQgZGlkIG5vdCByZXBv
cnQgdGhlIG92ZXJseSBsb25nIGxpbmUgd2FybmluZy4gIFNvLCBJCj4+IHNob3VsZCBzdGlsbCBv
YmV5IHRoZSBydWxlIG9mIDgwIGNoYXJzIG9uZSBsaW5lPwo+IAo+IGNoZWNrcGF0Y2gucGwgaXMg
Y29tcGxldGVseSBicm9rZW4sIEkgd291bGQgbm90IHJlbHkgb24gaXQuCj4gCj4gSGVyZSBpcyB0
aGUgcXVvdGUgZnJvbSB0aGUgY29kaW5nIHN0eWxlIGRvY3VtZW50Ogo+IAo+ICJUaGUgcHJlZmVy
cmVkIGxpbWl0IG9uIHRoZSBsZW5ndGggb2YgYSBzaW5nbGUgbGluZSBpcyA4MCBjb2x1bW5zLgo+
IAo+IFN0YXRlbWVudHMgbG9uZ2VyIHRoYW4gODAgY29sdW1ucyBzaG91bGQgYmUgYnJva2VuIGlu
dG8gc2Vuc2libGUgY2h1bmtzLAo+IHVubGVzcyBleGNlZWRpbmcgODAgY29sdW1ucyBzaWduaWZp
Y2FudGx5IGluY3JlYXNlcyByZWFkYWJpbGl0eSBhbmQgZG9lcwo+IG5vdCBoaWRlIGluZm9ybWF0
aW9uLiIKPiAKCk9LLiAgR290IGl0LiAgVGhhbmsgeW91LgoKCi0tClJ1YW4gU2hpeWFuZy4KPiAK
CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xp
c3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

