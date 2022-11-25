Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29F66C4332F
	for <dm-devel@archiver.kernel.org>; Fri, 25 Nov 2022 01:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669340643;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Nu97BSg/QDZWkpul0ZHKkcxeaLrq1p5DxtmoVZlzmZs=;
	b=Z8UbnFFGe/UIt3fsCNdwbWPpktu0VJgA2EQnRLg2oBtEqADkdh6auS8UgHwc/efLO+T4mw
	a0l1qzjHHMsu+JE8Jhyza4Sk8GTsCRK5PG5czr+6FpUJWcmsTJxHyoV/+PlZ58oTKqJV7A
	ZzMhWZu51ae1bulqmR2eH8jvGSnMoU4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-0rzDhJnONz2qmlGCFE0KLw-1; Thu, 24 Nov 2022 20:43:59 -0500
X-MC-Unique: 0rzDhJnONz2qmlGCFE0KLw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41BFA811E81;
	Fri, 25 Nov 2022 01:43:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 19964111E3EB;
	Fri, 25 Nov 2022 01:43:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B8E111946589;
	Fri, 25 Nov 2022 01:43:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 25028194658C
 for <dm-devel@listman.corp.redhat.com>; Fri, 25 Nov 2022 01:43:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 13523C15BA8; Fri, 25 Nov 2022 01:43:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B9B5C15BA5
 for <dm-devel@redhat.com>; Fri, 25 Nov 2022 01:43:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8957299E760
 for <dm-devel@redhat.com>; Fri, 25 Nov 2022 01:43:51 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
 [45.249.212.187]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-VAh7hdsQNH2uSCZJ2jbHVw-1; Thu, 24 Nov 2022 20:43:48 -0500
X-MC-Unique: VAh7hdsQNH2uSCZJ2jbHVw-1
Received: from kwepemi500002.china.huawei.com (unknown [172.30.72.53])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NJHHs2VTqzmW9T;
 Fri, 25 Nov 2022 09:26:01 +0800 (CST)
Received: from [10.174.179.167] (10.174.179.167) by
 kwepemi500002.china.huawei.com (7.221.188.171) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 09:26:34 +0800
Message-ID: <feab383d-f3fa-fb8d-caf2-10830757522b@huawei.com>
Date: Fri, 25 Nov 2022 09:26:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
 <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>, dm-devel mailing list
 <dm-devel@redhat.com>
From: miaoguanqin <miaoguanqin@huawei.com>
X-Originating-IP: [10.174.179.167]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500002.china.huawei.com (7.221.188.171)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH] multipathd: Fixed multipathd parameter invoking
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
Cc: linfeilong <linfeilong@huawei.com>, lixiaokeng@huawei.com,
 "liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

VXNlcnMgbWF5IGZhaWwgdG8gZXhlY3V0ZSBjb21tYW5kOiBtdWx0aXBhdGhkIGFuZCBtcGF0aHBl
cnNpc3QuCgpXaGVuIHdlIGV4ZWN1dGUgdGhlIGNvbW1hbmQgbXBhdGhwZXJzaXN077yaCm1wYXRo
cGVyc2lzdCAtLW91dCAtLXJlZ2lzdGVyIC0tcGFyYW0tc2Fyaz0xMjMgLS1wcm91dC10eXBlPTUg
Ci9kZXYvbWFwcGVyL21wYXRoYgpJdCByZXR1cm4gYW4gZXJyb3IgOiBNaXNzaW5nIGFyZ3VlbWVu
dC4gVGhlIHByZWNlZGluZyBjb21tYW5kIGNhbGxzIHRoZSAKZnVuY3Rpb24KY2xpX3NldHBya2V5
LCB3aGljaCBpcyBjYWxsZWQgYnkgY2hlY2tpbmcgd2hldGhlciB0aGUgaGFuZGxlIHZhbHVlcyBh
cmUgCmNvbnNpc3RlbnQKd2l0aCB0aGUgY29tbWFuZCBpbnB1dC4gQ1ZFLTIwMjItNDE5NzQgY2hh
bmdlZCB0aGUgaGFuZGxlciB2YWx1ZSBvZiAKZnVuY3Rpb24gYW5kCmNoYW5nZWQgdGhlIG1vZGUg
b2YgY2FsY3VsYXRpbmcgaGFuZGxlLiAgVGhlIGhhbmRsZXIgdmFsdWUgaXMgbm90IGVxdWFsIAp0
byB0aGUKY29tbWFuZCBpbnB1dCwgY2F1c2luZyBtdWx0aXBhdGhkIGNhbiBub3QgZXhlY3V0ZSB0
aGUgdHJ1ZSBmdW5jaW9uLiBJdCAKY291bGQgYmUKYW4gc2FtZSBlcnJvciBmb3IgZXhlY3V0aW5n
IG11bHRpcGF0aGQgYnkgdGhlIG9sZCBtb2RlLgoKbXVsdGlwYXRoZCBpbnZva2VzIHRoZSBjb3Jy
ZXNwb25kaW5nIGZ1bmN0aW9uIGJhc2VkIG9uIHRoZSBoYW5kbGUgdmFsdWUuCkNWRS0yMDIyLTQx
OTY0IGNoYW5nZWQgdGhlIG1ldGhvZCBvZiBjYWxjdWxhdGluZyBoYW5kbGVyIHZhbHVlLiBNb2Rp
ZnkgCnRoZSBoYW5kbGUKdmFsdWUgc28gdGhhdCB0aGUgY29ycmVzcG9uZGluZyBmdW5jdGlvbiBj
YW4gYmUgY29ycmVjdGx5IGV4ZWN1dGUuCgpTaWduZWQtb2ZmLWJ5OiBtaWFvZ3VhbnFpbiA8bWlh
b2d1YW5xaW5AaHVhd2VpLmNvbT4KU2lnbmVkLW9mZi1ieTogbGl4aWFva2VuZyA8bGl4aWFva2Vu
Z0BodWF3ZWkuY29tPgotLS0KICBtdWx0aXBhdGhkL2NhbGxiYWNrcy5jIHwgMTggKysrKysrKysr
LS0tLS0tLS0tCiAgbXVsdGlwYXRoZC9jbGkuaCAgICAgICB8ICA5ICsrKysrKysrLQogIDIgZmls
ZXMgY2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvbXVsdGlwYXRoZC9jYWxsYmFja3MuYyBiL211bHRpcGF0aGQvY2FsbGJhY2tzLmMKaW5kZXgg
ZmI4N2IyODAuLmYzMjY2NmJlIDEwMDY0NAotLS0gYS9tdWx0aXBhdGhkL2NhbGxiYWNrcy5jCisr
KyBiL211bHRpcGF0aGQvY2FsbGJhY2tzLmMKQEAgLTU3LDE2ICs1NywxNiBAQCB2b2lkIGluaXRf
aGFuZGxlcl9jYWxsYmFja3Modm9pZCkKICAJc2V0X2hhbmRsZXJfY2FsbGJhY2soVlJCX1JFU1RP
UkVRIHwgUTFfTUFQUywgCkhBTkRMRVIoY2xpX3Jlc3RvcmVfYWxsX3F1ZXVlaW5nKSk7CiAgCXNl
dF91bmxvY2tlZF9oYW5kbGVyX2NhbGxiYWNrKFZSQl9RVUlULCBIQU5ETEVSKGNsaV9xdWl0KSk7
CiAgCXNldF91bmxvY2tlZF9oYW5kbGVyX2NhbGxiYWNrKFZSQl9TSFVURE9XTiwgSEFORExFUihj
bGlfc2h1dGRvd24pKTsKLQlzZXRfaGFuZGxlcl9jYWxsYmFjayhWUkJfR0VUUFJTVEFUVVMgfCBR
MV9NQVAsIEhBTkRMRVIoY2xpX2dldHByc3RhdHVzKSk7Ci0Jc2V0X2hhbmRsZXJfY2FsbGJhY2so
VlJCX1NFVFBSU1RBVFVTIHwgUTFfTUFQLCBIQU5ETEVSKGNsaV9zZXRwcnN0YXR1cykpOwotCXNl
dF9oYW5kbGVyX2NhbGxiYWNrKFZSQl9VTlNFVFBSU1RBVFVTIHwgUTFfTUFQLCAKSEFORExFUihj
bGlfdW5zZXRwcnN0YXR1cykpOworCXNldF9oYW5kbGVyX2NhbGxiYWNrKEtFWV9NQVAgfCBRMV9H
RVRQUlNUQVRVUywgSEFORExFUihjbGlfZ2V0cHJzdGF0dXMpKTsKKwlzZXRfaGFuZGxlcl9jYWxs
YmFjayhLRVlfTUFQIHwgUTFfU0VUU1RBVFVTLCBIQU5ETEVSKGNsaV9zZXRwcnN0YXR1cykpOwor
CXNldF9oYW5kbGVyX2NhbGxiYWNrKEtFWV9NQVAgfCBRMV9VTlNFVFNUQVRVUywgCkhBTkRMRVIo
Y2xpX3Vuc2V0cHJzdGF0dXMpKTsKICAJc2V0X2hhbmRsZXJfY2FsbGJhY2soVlJCX0ZPUkNFUSB8
IFExX0RBRU1PTiwgCkhBTkRMRVIoY2xpX2ZvcmNlX25vX2RhZW1vbl9xKSk7CiAgCXNldF9oYW5k
bGVyX2NhbGxiYWNrKFZSQl9SRVNUT1JFUSB8IFExX0RBRU1PTiwgCkhBTkRMRVIoY2xpX3Jlc3Rv
cmVfbm9fZGFlbW9uX3EpKTsKLQlzZXRfaGFuZGxlcl9jYWxsYmFjayhWUkJfR0VUUFJLRVkgfCBR
MV9NQVAsIEhBTkRMRVIoY2xpX2dldHBya2V5KSk7Ci0Jc2V0X2hhbmRsZXJfY2FsbGJhY2soVlJC
X1NFVFBSS0VZIHwgUTFfTUFQIHwgUTJfS0VZLCAKSEFORExFUihjbGlfc2V0cHJrZXkpKTsKLQlz
ZXRfaGFuZGxlcl9jYWxsYmFjayhWUkJfVU5TRVRQUktFWSB8IFExX01BUCwgSEFORExFUihjbGlf
dW5zZXRwcmtleSkpOwotCXNldF9oYW5kbGVyX2NhbGxiYWNrKFZSQl9TRVRNQVJHSU5BTCB8IFEx
X1BBVEgsIApIQU5ETEVSKGNsaV9zZXRfbWFyZ2luYWwpKTsKLQlzZXRfaGFuZGxlcl9jYWxsYmFj
ayhWUkJfVU5TRVRNQVJHSU5BTCB8IFExX1BBVEgsIApIQU5ETEVSKGNsaV91bnNldF9tYXJnaW5h
bCkpOwotCXNldF9oYW5kbGVyX2NhbGxiYWNrKFZSQl9VTlNFVE1BUkdJTkFMIHwgUTFfTUFQLAor
CXNldF9oYW5kbGVyX2NhbGxiYWNrKEtFWV9NQVAgfCBRMV9HRVRQUktFWSwgSEFORExFUihjbGlf
Z2V0cHJrZXkpKTsKKwlzZXRfaGFuZGxlcl9jYWxsYmFjayhLRVlfTUFQIHwgUTFfU0VUS0VZIHwg
UTJfS0VZLCBIQU5ETEVSKGNsaV9zZXRwcmtleSkpOworCXNldF9oYW5kbGVyX2NhbGxiYWNrKEtF
WV9NQVAgfCBRMV9VTlNFVEtFWSwgSEFORExFUihjbGlfdW5zZXRwcmtleSkpOworCXNldF9oYW5k
bGVyX2NhbGxiYWNrKEtFWV9QQVRIIHwgUTFfU0VUTUFSR0lOQUwsIApIQU5ETEVSKGNsaV9zZXRf
bWFyZ2luYWwpKTsKKwlzZXRfaGFuZGxlcl9jYWxsYmFjayhLRVlfUEFUSCB8IFExX1VOU0VUTUFS
R0lOQUwsIApIQU5ETEVSKGNsaV91bnNldF9tYXJnaW5hbCkpOworCXNldF9oYW5kbGVyX2NhbGxi
YWNrKEtFWV9NQVAgfCBRMV9VTlNFVE1BUkdJTkFMLAogIAkJCSAgICAgSEFORExFUihjbGlfdW5z
ZXRfYWxsX21hcmdpbmFsKSk7CiAgfQpkaWZmIC0tZ2l0IGEvbXVsdGlwYXRoZC9jbGkuaCBiL211
bHRpcGF0aGQvY2xpLmgKaW5kZXggYzZiNzljOWQuLjA4ZWU1YzhkIDEwMDY0NAotLS0gYS9tdWx0
aXBhdGhkL2NsaS5oCisrKyBiL211bHRpcGF0aGQvY2xpLmgKQEAgLTgwLDcgKzgwLDE0IEBAIGVu
dW0gewogIAlRMV9BTEwJCQk9IEtFWV9BTEwgPDwgOCwKICAJUTFfREFFTU9OCQk9IEtFWV9EQUVN
T04gPDwgOCwKICAJUTFfU1RBVFVTCQk9IEtFWV9TVEFUVVMgPDwgOCwKLQorCVExX1NFVEtFWQkJ
PSBWUkJfU0VUUFJLRVkgPDwgOCwKKwlRMV9VTlNFVEtFWQkJPSBWUkJfVU5TRVRQUktFWSA8PCA4
LAorCVExX1NFVFNUQVRVUwkJPSBWUkJfU0VUUFJTVEFUVVMgPDwgOCwKKwlRMV9VTlNFVFNUQVRV
UwkJPSBWUkJfVU5TRVRQUlNUQVRVUyA8PCA4LAorCVExX0dFVFBSU1RBVFVTCQk9IFZSQl9HRVRQ
UlNUQVRVUyA8PCA4LAorCVExX0dFVFBSS0VZCQk9IFZSQl9HRVRQUktFWSA8PCA4LAorCVExX1NF
VE1BUkdJTkFMCQk9IFZSQl9TRVRNQVJHSU5BTCA8PCA4LAorCVExX1VOU0VUTUFSR0lOQUwJPSBW
UkJfVU5TRVRNQVJHSU5BTCA8PCA4LAogIAkvKiBieXRlIDI6IHF1YWxpZmllciAyICovCiAgCVEy
X0ZNVAkJCT0gS0VZX0ZNVCA8PCAxNiwKICAJUTJfUkFXCQkJPSBLRVlfUkFXIDw8IDE2LAotLSAK
Mi4zMy4wCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

