Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BEA8C54EBE
	for <dm-devel@archiver.kernel.org>; Fri, 13 Jan 2023 09:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673603027;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aH3IBnqat0rUyZXn4OeEt+8kYRVI7co78J3rB0yJbi0=;
	b=ZP0vD9ALNxvepTPTlfjTnBYaena7bTb+nXl59n8NM4K+jxYsT5uBngdDsfGQ9pLwZr8asK
	Uy/e59WXhKvqNfTFCujkRuW2yWjQxnED2xQ4UIM8BE0GKdl81MXB0Lj/wQgIh8Y8IputLl
	Mg1ZUdYrzbArJNxQLhts+k+ms63SWcM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-nixDTvsdNrqAm9DD5hXB-w-1; Fri, 13 Jan 2023 04:43:43 -0500
X-MC-Unique: nixDTvsdNrqAm9DD5hXB-w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78C2E101A52E;
	Fri, 13 Jan 2023 09:43:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 672BD2026D68;
	Fri, 13 Jan 2023 09:43:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5A3491947055;
	Fri, 13 Jan 2023 09:43:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 34DB81946A78
 for <dm-devel@listman.corp.redhat.com>; Fri, 13 Jan 2023 09:43:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1850E492B06; Fri, 13 Jan 2023 09:43:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 10C72492B05
 for <dm-devel@redhat.com>; Fri, 13 Jan 2023 09:43:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB449857A84
 for <dm-devel@redhat.com>; Fri, 13 Jan 2023 09:43:39 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-517-0LU14MtzN2CL-ZQQiHyRqg-1; Fri,
 13 Jan 2023 04:43:38 -0500
X-MC-Unique: 0LU14MtzN2CL-ZQQiHyRqg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id E3FFD5D7AD;
 Fri, 13 Jan 2023 09:43:36 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B7DC81358A;
 Fri, 13 Jan 2023 09:43:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id kA1aK8gnwWOafQAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 13 Jan 2023 09:43:36 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 13 Jan 2023 10:43:10 +0100
Message-Id: <20230113094310.20367-3-mwilck@suse.com>
In-Reply-To: <20230113094310.20367-1-mwilck@suse.com>
References: <20230113094310.20367-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH 2/2] libmultipath: pathinfo: don't fail for
 devices lacking INQUIRY properties
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

RnJvbTogTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+CgpTb21lIFNBUyBkZXZpY2VzIChl
LmcuIFNlYWdhdGUgZmFjdG9yeSByZWNlcnRpZmllZCAnd2hpdGUgbGFiZWwnIGRyaXZlcykgbWF5
CmNvbWUgd2l0aCB0aGUgVmVuZG9yIGZpZWxkIGJsYW5rLiBUaGlzIGNhdXNlcyBNdWx0aXBhdGgg
dG8gZmFpbCB0bwpjb21wbGV0ZSB0aGUgZGlzY292ZXJ5IG9mIHRob3NlIGRldmljZXMuCgpTdWNo
IGRldmljZXMgdmlvbGF0ZSB0aGUgU0NTSSBTcGVjLiBGcm9tIHRoZSBTUEMtNiwgwqc2LjcuMjoK
IlRoZSBUMTAgVkVORE9SIElERU5USUZJQ0FUSU9OIGZpZWxkIGNvbnRhaW5zIGVpZ2h0IGJ5dGVz
IG9mIGxlZnQtYWxpZ25lZApBU0NJSSBkYXRhIChzZWUgNC4zLjEpIGlkZW50aWZ5aW5nIHRoZSBt
YW51ZmFjdHVyZXIgb2YgdGhlIGxvZ2ljYWwgdW5pdC4gVGhlClQxMCB2ZW5kb3IgaWRlbnRpZmlj
YXRpb24gc2hhbGwgYmUgb25lIGFzc2lnbmVkIGJ5IElOQ0lUUy4iLgoKQnV0IGFzIHdlIGRvbid0
IGlkZW50aWZ5IFdXSURzIGJ5IHZlbmRvciBhbmQgcHJvZHVjdCwgd2UgZG9uJ3QgbmVlZCB0byBk
aXNjYXJkCnRoZXNlIGRldmljZXMgcmlnaHQgYXdheS4gV2UgY2FuIGdvIGFoZWFkIGZpbmdlcnMg
Y3Jvc3NlZCwgYW5kIGhvcGUgdGhhdCB0aGUKdGhlIG90aGVyIFZQRCBwYWdlcyBmb3IgdGhlIGRl
dmljZSBhcmUgY29ycmVjdC4KCldlIG9idmlvdXNseSBjYW4ndCBsb29rIHVwIHJlYXNvbmFibGUg
ZGV2aWNlIHByb3BlcnRpZXMgZm9yIHN1Y2ggZGV2aWNlcyBpbgpvdXIgaHd0YWJsZS4gSXQgd291
bGQgYmUgdXAgdG8gdGhlIHVzZXIgdG8gZGVhbCB3aXRoIHRoYXQuCgpSZXBvcnRlZCBieTogQWxs
eW4gTWFsdmVudGFubyAoZ2l0aHViLmNvbS9vcGVuc3ZjL211bHRpcGF0aC10b29scy9pc3N1ZXMv
NTYpClNpZ25lZC1vZmYtYnk6IE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPgotLS0KIGxp
Ym11bHRpcGF0aC9kaXNjb3ZlcnkuYyB8IDIyICsrKysrKysrKysrKystLS0tLS0tLS0KIDEgZmls
ZSBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2xpYm11bHRpcGF0aC9kaXNjb3ZlcnkuYyBiL2xpYm11bHRpcGF0aC9kaXNjb3ZlcnkuYwppbmRl
eCBkOWVlMmNiLi42N2FjMGU2IDEwMDY0NAotLS0gYS9saWJtdWx0aXBhdGgvZGlzY292ZXJ5LmMK
KysrIGIvbGlibXVsdGlwYXRoL2Rpc2NvdmVyeS5jCkBAIC0xNDcyLDYgKzE0NzIsNyBAQCBzY3Np
X3N5c2ZzX3BhdGhpbmZvIChzdHJ1Y3QgcGF0aCAqcHAsIGNvbnN0IHN0cnVjdCBfdmVjdG9yICpo
d3RhYmxlKQogewogCXN0cnVjdCB1ZGV2X2RldmljZSAqcGFyZW50OwogCWNvbnN0IGNoYXIgKmF0
dHJfcGF0aCA9IE5VTEw7CisJc3RhdGljIGNvbnN0IGNoYXIgdW5rbm93bltdID0gIlVOS05PV04i
OwogCiAJcGFyZW50ID0gcHAtPnVkZXY7CiAJd2hpbGUgKHBhcmVudCkgewpAQCAtMTQ5MiwxOSAr
MTQ5MywyMiBAQCBzY3NpX3N5c2ZzX3BhdGhpbmZvIChzdHJ1Y3QgcGF0aCAqcHAsIGNvbnN0IHN0
cnVjdCBfdmVjdG9yICpod3RhYmxlKQogCWlmICghYXR0cl9wYXRoIHx8IHBwLT5zZ19pZC5ob3N0
X25vID09IC0xKQogCQlyZXR1cm4gUEFUSElORk9fRkFJTEVEOwogCi0JaWYgKHN5c2ZzX2dldF92
ZW5kb3IocGFyZW50LCBwcC0+dmVuZG9yX2lkLCBTQ1NJX1ZFTkRPUl9TSVpFKSA8PSAwKQotCQly
ZXR1cm4gUEFUSElORk9fRkFJTEVEOzsKLQorCWlmIChzeXNmc19nZXRfdmVuZG9yKHBhcmVudCwg
cHAtPnZlbmRvcl9pZCwgU0NTSV9WRU5ET1JfU0laRSkgPD0gMCkgeworCQljb25kbG9nKDEsICIl
czogYnJva2VuIGRldmljZSB3aXRob3V0IHZlbmRvciBJRCIsIHBwLT5kZXYpOworCQlzdHJsY3B5
KHBwLT52ZW5kb3JfaWQsIHVua25vd24sIFNDU0lfVkVORE9SX1NJWkUpOworCX0KIAljb25kbG9n
KDMsICIlczogdmVuZG9yID0gJXMiLCBwcC0+ZGV2LCBwcC0+dmVuZG9yX2lkKTsKIAotCWlmIChz
eXNmc19nZXRfbW9kZWwocGFyZW50LCBwcC0+cHJvZHVjdF9pZCwgUEFUSF9QUk9EVUNUX1NJWkUp
IDw9IDApCi0JCXJldHVybiBQQVRISU5GT19GQUlMRUQ7OwotCisJaWYgKHN5c2ZzX2dldF9tb2Rl
bChwYXJlbnQsIHBwLT5wcm9kdWN0X2lkLCBQQVRIX1BST0RVQ1RfU0laRSkgPD0gMCkgeworCQlj
b25kbG9nKDEsICIlczogYnJva2VuIGRldmljZSB3aXRob3V0IHByb2R1Y3QgSUQiLCBwcC0+ZGV2
KTsKKwkJc3RybGNweShwcC0+cHJvZHVjdF9pZCwgdW5rbm93biwgUEFUSF9QUk9EVUNUX1NJWkUp
OworCX0KIAljb25kbG9nKDMsICIlczogcHJvZHVjdCA9ICVzIiwgcHAtPmRldiwgcHAtPnByb2R1
Y3RfaWQpOwogCi0JaWYgKHN5c2ZzX2dldF9yZXYocGFyZW50LCBwcC0+cmV2LCBQQVRIX1JFVl9T
SVpFKSA8IDApCi0JCXJldHVybiBQQVRISU5GT19GQUlMRUQ7OwotCisJaWYgKHN5c2ZzX2dldF9y
ZXYocGFyZW50LCBwcC0+cmV2LCBQQVRIX1JFVl9TSVpFKSA8IDApIHsKKwkJY29uZGxvZygyLCAi
JXM6IGJyb2tlbiBkZXZpY2Ugd2l0aG91dCByZXZpc2lvbiIsIHBwLT5kZXYpOworCQlzdHJsY3B5
KHBwLT5yZXYsIHVua25vd24sIFBBVEhfUkVWX1NJWkUpOworCX0KIAljb25kbG9nKDMsICIlczog
cmV2ID0gJXMiLCBwcC0+ZGV2LCBwcC0+cmV2KTsKIAogCS8qCi0tIAoyLjM5LjAKCi0tCmRtLWRl
dmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

