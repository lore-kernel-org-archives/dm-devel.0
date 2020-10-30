Return-Path: <SRS0=GC9A=EF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7007DC00A89
	for <dm-devel@archiver.kernel.org>; Fri, 30 Oct 2020 20:35:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B7BEA2076D
	for <dm-devel@archiver.kernel.org>; Fri, 30 Oct 2020 20:35:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7BEA2076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-z43GX3RgMIuNopNgL4C42g-1; Fri, 30 Oct 2020 16:34:57 -0400
X-MC-Unique: z43GX3RgMIuNopNgL4C42g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C6B81005E77;
	Fri, 30 Oct 2020 20:34:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EA6D19482;
	Fri, 30 Oct 2020 20:34:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E081E181A06C;
	Fri, 30 Oct 2020 20:34:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09UKYjPj013578 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 30 Oct 2020 16:34:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A910A117A947; Fri, 30 Oct 2020 20:34:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A2224117A943
	for <dm-devel@redhat.com>; Fri, 30 Oct 2020 20:34:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4346D80351B
	for <dm-devel@redhat.com>; Fri, 30 Oct 2020 20:34:43 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-423-xERNLSJRPy6ykTkr_eWgkQ-1;
	Fri, 30 Oct 2020 16:34:40 -0400
X-MC-Unique: xERNLSJRPy6ykTkr_eWgkQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 8BC11AC6D;
	Fri, 30 Oct 2020 20:34:38 +0000 (UTC)
Message-ID: <c75f584a7475a0094e90a91786d5ef114a761b3a.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Fri, 30 Oct 2020 21:34:37 +0100
In-Reply-To: <20201028141411.23806-1-xose.vazquez@gmail.com>
References: <20201028141411.23806-1-xose.vazquez@gmail.com>
User-Agent: Evolution 3.36.5
MIME-Version: 1.0
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
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipath-tools: delete auto-generated
 tests/test-log.d file with make clean
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="=-P1s2AIrZIq54tFCABULj"

--=-P1s2AIrZIq54tFCABULj
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit

On Wed, 2020-10-28 at 15:14 +0100, Xose Vazquez Perez wrote:
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---

Nack. The correct fix is attached.


--=-P1s2AIrZIq54tFCABULj
Content-Disposition: attachment;
	filename*0=0001-libmultipath-tests-delete-test-log.d-during-make-cle.pat;
	filename*1=ch
Content-Transfer-Encoding: base64
Content-Type: text/x-patch;
	name="0001-libmultipath-tests-delete-test-log.d-during-make-cle.patch"; 
	charset="ISO-8859-15"

RnJvbSAwZDBlMjkxYWVkNmUxNjkzZTI2YWE4ZDc3ZjAzYTVjMGY1ODNmM2Y1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4KRGF0ZTog
RnJpLCAzMCBPY3QgMjAyMCAyMTozMjo1NyArMDEwMApTdWJqZWN0OiBbUEFUQ0hdIGxpYm11bHRp
cGF0aCB0ZXN0czogZGVsZXRlIHRlc3QtbG9nLmQgZHVyaW5nICJtYWtlIGNsZWFuIgoKdGVzdC1s
b2cuZCB3YXMgbm90IGNsZWFuZWQgb3V0LiBGaXggaXQuCgpTaWduZWQtb2ZmLWJ5OiBNYXJ0aW4g
V2lsY2sgPG13aWxja0BzdXNlLmNvbT4KLS0tCiB0ZXN0cy9NYWtlZmlsZSB8IDMgKystCiAxIGZp
bGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEv
dGVzdHMvTWFrZWZpbGUgYi90ZXN0cy9NYWtlZmlsZQppbmRleCAzYmFjYWJkLi5kMjZiM2NlIDEw
MDY0NAotLS0gYS90ZXN0cy9NYWtlZmlsZQorKysgYi90ZXN0cy9NYWtlZmlsZQpAQCAtMTQsNiAr
MTQsNyBAQCBMSUJERVBTICs9IC1MJChtdWx0aXBhdGhkaXIpIC1MJChtcGF0aGNtZGRpcikgLWxt
dWx0aXBhdGggLWxtcGF0aGNtZCAtbGNtb2NrYQogCiBURVNUUyA6PSB1ZXZlbnQgcGFyc2VyIHV0
aWwgZG1ldmVudHMgaHd0YWJsZSBibGFja2xpc3QgdW5hbGlnbmVkIHZwZCBwZ3BvbGljeSBcCiAJ
IGFsaWFzIGRpcmVjdGlvIHZhbGlkIGRldnQKK0hFTFBFUlMgOj0gdGVzdC1saWIubyB0ZXN0LWxv
Zy5vCiAKIC5TSUxFTlQ6ICQoVEVTVFM6JT0lLm8pCiAuUFJFQ0lPVVM6ICQoVEVTVFM6JT0lLXRl
c3QpCkBAIC03NCw3ICs3NSw3IEBAIGxpYi9saWJjaGVja3R1ci5zbzoKIAlATERfTElCUkFSWV9Q
QVRIPSQobXVsdGlwYXRoZGlyKTokKG1wYXRoY21kZGlyKSBcCiAJCXZhbGdyaW5kIC0tbGVhay1j
aGVjaz1mdWxsIC0tZXJyb3ItZXhpdGNvZGU9MTI4IC4vJDwgPiRAIDI+JjEKIAotT0JKUyA9ICQo
VEVTVFM6JT0lLm8pIHRlc3QtbGliLm8KK09CSlMgPSAkKFRFU1RTOiU9JS5vKSAkKEhFTFBFUlMp
CiAKIHRlc3RfY2xlYW46CiAJJChSTSkgJChURVNUUzolPSUub3V0KSAkKFRFU1RTOiU9JS52Z3Ip
Ci0tIAoyLjI5LjAKCg==
--=-P1s2AIrZIq54tFCABULj
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--=-P1s2AIrZIq54tFCABULj--

