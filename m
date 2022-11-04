Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 591F2C4167B
	for <dm-devel@archiver.kernel.org>; Fri,  4 Nov 2022 06:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667544613;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VnD48XddksWkUhf3n5n6n3ErOZGKwLBr/GR17rTk5/Y=;
	b=gASysdXH6Eys8Ps14iSlkYrGudgIlGvGqhauWU/4wDkT8Jc/XlBPmOB6OiqpIlWzdv+NCw
	n6vDgYOngSilSYkKn39FiNqNSTTvXQVn8r3SxJPKWw59GdbX4ypQKHrrzY6QLTnVksjFkB
	jnCo83WhALpAjrjMBLdz4UxBQMevTro=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-QD_9XJaLOgSSehLp4vieFg-1; Fri, 04 Nov 2022 02:50:11 -0400
X-MC-Unique: QD_9XJaLOgSSehLp4vieFg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B7B4833AF3;
	Fri,  4 Nov 2022 06:50:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1EFCE111E3E9;
	Fri,  4 Nov 2022 06:50:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DB5401947072;
	Fri,  4 Nov 2022 06:50:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 83A851946594
 for <dm-devel@listman.corp.redhat.com>; Fri,  4 Nov 2022 06:00:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E18D640C83EC; Fri,  4 Nov 2022 06:00:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D8DC940C83EB
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 06:00:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C19A6800B23
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 06:00:10 +0000 (UTC)
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-253-tchlULMtOOCw_ZiopSa6_g-1; Fri,
 04 Nov 2022 02:00:06 -0400
X-MC-Unique: tchlULMtOOCw_ZiopSa6_g-1
Received: from [192.168.0.185] (ip5f5aed63.dynamic.kabel-deutschland.de
 [95.90.237.99])
 (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested) (Authenticated sender: pmenzel)
 by mx.molgen.mpg.de (Postfix) with ESMTPSA id 2CF0F61EA192D;
 Fri,  4 Nov 2022 06:52:21 +0100 (CET)
Message-ID: <adf2fc44-f3d4-d96b-09a6-8e916a6f8449@molgen.mpg.de>
Date: Fri, 4 Nov 2022 06:52:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
To: NeilBrown <neilb@suse.de>
References: <alpine.LRH.2.21.2211031121070.18305@file01.intranet.prod.int.rdu2.redhat.com>
 <166753684502.19313.12105294223332649758@noble.neil.brown.name>
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <166753684502.19313.12105294223332649758@noble.neil.brown.name>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Fri, 04 Nov 2022 06:50:05 +0000
Subject: [dm-devel] Problems with email threading (was: [PATCH] md: fix a
 crash in mempool_free)
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
Cc: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, Guoqing Jiang <guoqing.jiang@linux.dev>,
 Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

RGVhciBOZWlsLAoKCkp1c3QgYSBoZWFkcy11cCwgTW96aWxsYSBUaHVuZGVyYmlyZCAxMDIuNC4x
IGRvZXMgbm90IHRocmVhZCB5b3VyIG1lc3NhZ2UuCgpZb3VyIHJlcGx5IGNvbnRhaW5zOgoKICAg
ICBJbi1yZXBseS10bzogCj0/dXRmLTg/cT89M0NhbHBpbmU9MkVMUkg9MkUyPTJFMjE9MkUyMjEx
MDMxMTIxMDcwPTJFMTgzMDU9NDBmaT89CiAgPT91dGYtOD9xP2xlMDE9MkVpbnRyYW5ldD0yRXBy
b2Q9MkVpbnQ9MkVyZHUyPTJFcmVkaGF0PTJFY29tPTNFPz0KICAgICBSZWZlcmVuY2VzOiAKPT91
dGYtOD9xPz0zQ2FscGluZT0yRUxSSD0yRTI9MkUyMT0yRTIyMTEwMzExMjEwNzA9MkUxODMwNT00
MGZpbD89CiAgPT91dGYtOD9xP2UwMT0yRWludHJhbmV0PTJFcHJvZD0yRWludD0yRXJkdTI9MkVy
ZWRoYXQ9MkVjb209M0U/PQoKTWlrdWxhc+KAmSBtZXNzYWdlIGhhczoKCiAgICAgTWVzc2FnZS1J
RDogCjxhbHBpbmUuTFJILjIuMjEuMjIxMTAzMTEyMTA3MC4xODMwNUBmaWxlMDEuaW50cmFuZXQu
cHJvZC5pbnQucmR1Mi5yZWRoYXQuY29tPgoKSXQgbG9va3Mgc3RyYW5nZSwgdGhhdCB0aGUgbWVz
c2FnZSBpZCwgdGhhdCBkb2VzIG5vdCBzZWVtIHRvIGNvbnRhaW4gYW55IApub24tQVNDSUkgY2hh
cmFjdGVycyBpcyDigJ5yZWVuY29kZWTigJwuIE5vIGlkZWEsIGlmIGl0IHZpb2xhdGVzIGFueSAK
c3RhbmRhcmRzIHRob3VnaC4KCgpLaW5kIHJlZ2FyZHMsCgpQYXVsCgotLQpkbS1kZXZlbCBtYWls
aW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9t
YWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

