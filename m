Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC13FC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  1 Jun 2022 20:26:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-aPXYHQpgN_ehVcQVemxHGA-1; Wed, 01 Jun 2022 16:26:54 -0400
X-MC-Unique: aPXYHQpgN_ehVcQVemxHGA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4562680A0AD;
	Wed,  1 Jun 2022 20:26:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3539D492C3B;
	Wed,  1 Jun 2022 20:26:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1295719452D8;
	Wed,  1 Jun 2022 20:26:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6C3F5194707F
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Jun 2022 20:26:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4D3B941047E9; Wed,  1 Jun 2022 20:26:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 494EB41047E8
 for <dm-devel@redhat.com>; Wed,  1 Jun 2022 20:26:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A45A1C3E984
 for <dm-devel@redhat.com>; Wed,  1 Jun 2022 20:26:48 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-0rWdoB8XPkagJS-oBURkXA-1; Wed, 01 Jun 2022 16:26:46 -0400
X-MC-Unique: 0rWdoB8XPkagJS-oBURkXA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id D46C621B24;
 Wed,  1 Jun 2022 20:26:44 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 934831330F;
 Wed,  1 Jun 2022 20:26:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id kOBYIoTLl2IFJwAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 01 Jun 2022 20:26:44 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Steven Schremmer <Steve.Schremmer@netapp.com>
Date: Wed,  1 Jun 2022 22:26:27 +0200
Message-Id: <20220601202628.5469-2-mwilck@suse.com>
In-Reply-To: <20220601202628.5469-1-mwilck@suse.com>
References: <20220601202628.5469-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH 1/2] libmultipath: hwtable: new defaults for NVMe
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

RnJvbTogTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+CgpTbyBmYXIgd2Ugd2VyZSB1c2lu
ZyB0aGUgZ2VuZXJhbCBkZWZhdWx0cyAocGdwb2xpY3kgPSBGQUlMT1ZFUiwKcGdmYWlsYmFjayA9
IC1GQUlMQkFDS19NQU5VQUwpLiBYb3PDqSdzIGxhdGUgcGF0Y2hlcyB3ZXJlIHNldHRpbmcgdGhp
cyB0bwplaXRoZXIgTVVMVElCVVMgb3IgQU5BLCBhbmQgLUZBSUxCQUNLX0lNTUVESUFURSwgcmVz
cGVjdGl2ZWx5CmZvciBtb3N0IHNwZWNpZmljIGFycmF5cy4gQXQgdGhlIHNhbWUgdGltZSwgc29t
ZSB2ZW5kb3JzIGRvbid0IGxpa2UKc2VlaW5nIHRoZWlyIE5WTWUgYXJyYXlzIGxpc3RlZCBzcGVj
aWZpY2FsbHkgaW4gdGhlIG11bHRpcGF0aC10b29scwpod3RhYmxlLgoKSU1PIGl0IG1ha2VzIHNl
bnNlIHRvIGNoYW5nZSB0aGUgZ2VuZXJhbCBkZWZhdWx0cy4KCmRldGVjdF9wcmlvIGlzIHRoZSBk
ZWZhdWx0LCBhbmQgd2UgcHJvYmUgZm9yIEFOQSBzdXBwb3J0LiBUaHVzIHByaW8Kd2lsbCBiZSAi
YW5hIiBmb3IgYXJyYXlzIHRoYXQgc3VwcG9ydCBpdCwgYW5kICJjb25zdCIgb3RoZXJ3aXNlLgpX
aXRoICJjb25zdCIsIEdST1VQX0JZX1BSSU8gZGVnZW5lcmF0ZXMgdG8gTVVMVElCVVMsIGFuZCBw
Z2ZhaWxiYWNrCndvbid0IGhhcHBlbiBhbnl3YXkuIFRoaXMgd2F5LCBvdXIgZGVmYXVsdHMgbWF0
Y2ggbW9zdCBYb3PDqSdzIG5ldyBlbnRyaWVzLiBUaGUKb25seSBkZXZpY2VzIGZvciB3aGljaCB0
aGlzIHBhdGNoIGNoYW5nZXMgYmVoYXZpb3IgKGZyb20gRkFJTE9WRVIgdG8gTVVMVElCVVMpCmFy
ZSB0aG9zZSBnZW5lcmljIGRldmljZXMgdGhhdCBhcmVuJ3QgbGlzdGVkLCBhbmQgZG9uJ3Qgc3Vw
cG9ydCBBTkEuCgpJIGNvbnNpZGVyZWQgY2hhbmdpbmcgdGhlIGRlZmF1bHQgZm9yIG5vX3BhdGhf
cmV0cnksIHRvbywgYnV0IGRlY2lkZWQgYWdhaW5zdAppdC4gVGhlIGRlZmF1bHQgaXMgImZhaWwi
LCBhbmQgdXNlcnMgd2hvIGRpc2xpa2UgdGhhdCB3aWxsIG5lZWQgdG8gY2hhbmdlIGl0Lgpub19w
YXRoX3JldHJ5IGlzIG1vcmUgYSBwb2xpY3kgc2V0dGluZyB0aGFuIGEgaGFyZHdhcmUgcHJvcGVy
dHksIGFueXdheS4KLS0tCiBsaWJtdWx0aXBhdGgvaHd0YWJsZS5jIHwgMyArKy0KIDEgZmlsZSBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9saWJt
dWx0aXBhdGgvaHd0YWJsZS5jIGIvbGlibXVsdGlwYXRoL2h3dGFibGUuYwppbmRleCAzOWRhYWRj
Li5lMGRjZTg0IDEwMDY0NAotLS0gYS9saWJtdWx0aXBhdGgvaHd0YWJsZS5jCisrKyBiL2xpYm11
bHRpcGF0aC9od3RhYmxlLmMKQEAgLTkwLDcgKzkwLDggQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5
IGRlZmF1bHRfaHdbXSA9IHsKIAkJLnByb2R1Y3QgICAgICAgPSAiLioiLAogCQkudWlkX2F0dHJp
YnV0ZSA9IERFRkFVTFRfTlZNRV9VSURfQVRUUklCVVRFLAogCQkuY2hlY2tlcl9uYW1lICA9IE5P
TkUsCi0JCS5yZXRhaW5faHdoYW5kbGVyID0gUkVUQUlOX0hXSEFORExFUl9PRkYsCisJCS5wZ3Bv
bGljeSAgICAgID0gR1JPVVBfQllfUFJJTywKKwkJLnBnZmFpbGJhY2sgICAgPSAtRkFJTEJBQ0tf
SU1NRURJQVRFLAogCX0sCiAJLyoKIAkgKiBBcHBsZQotLSAKMi4zNi4xCgotLQpkbS1kZXZlbCBt
YWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

