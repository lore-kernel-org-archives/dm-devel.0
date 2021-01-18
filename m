Return-Path: <SRS0=SDq8=GV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B723EC433DB
	for <dm-devel@archiver.kernel.org>; Mon, 18 Jan 2021 11:29:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A43C7223E8
	for <dm-devel@archiver.kernel.org>; Mon, 18 Jan 2021 11:29:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A43C7223E8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-4VV6fsYzPOivNNPAM9-xaA-1; Mon, 18 Jan 2021 06:29:04 -0500
X-MC-Unique: 4VV6fsYzPOivNNPAM9-xaA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BCF21842142;
	Mon, 18 Jan 2021 11:28:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DE372627DC;
	Mon, 18 Jan 2021 11:28:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7E444180954D;
	Mon, 18 Jan 2021 11:28:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10IBShXW006655 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 18 Jan 2021 06:28:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4BA325D208; Mon, 18 Jan 2021 11:28:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 45D4D5D203
	for <dm-devel@redhat.com>; Mon, 18 Jan 2021 11:28:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBC38811E85
	for <dm-devel@redhat.com>; Mon, 18 Jan 2021 11:28:40 +0000 (UTC)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com
	[45.249.212.191]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-585-ffnHxZlUM96Vojo0KJkolw-1; Mon, 18 Jan 2021 06:28:38 -0500
X-MC-Unique: ffnHxZlUM96Vojo0KJkolw-1
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DK8BH0cqWzMLR0;
	Mon, 18 Jan 2021 19:07:03 +0800 (CST)
Received: from [10.174.178.113] (10.174.178.113) by
	DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server
	id 14.3.498.0; Mon, 18 Jan 2021 19:08:15 +0800
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel mailing list
	<dm-devel@redhat.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <063bbeeb-15aa-f7c0-b881-7526c3a2720c@huawei.com>
Date: Mon, 18 Jan 2021 19:08:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10IBShXW006655
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>, lihaotian9@huawei.com
Subject: [dm-devel] [QUESTION]: multipath device with wrong path lead to
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkKICBXaGVuIHdlIG1ha2UgSU8gc3RyZXNzIHRlc3Qgb24gbXVsdGlwYXRoIGRldmljZSwgdGhl
cmUgd2lsbApiZSBhICBtZXRhZGF0YSBlcnIgYmVjYXVzZSBvZiB3cm9uZyBwYXRoLgoKVGhlcmUg
YXJlIHRocmVlIHRlc3Qgc2NyaXB0cy4KCkZpcnN0OgojIS9iaW4vYmFzaApkaXNrX2xpc3Q9Ii9k
ZXYvbWFwcGVyLzM2MDAxNDA1MzFmMDYzYjNlMTkzNDliYzgyMDI4ZTBjYwovZGV2L21hcHBlci8z
NjAwMTQwNWNhNTE2NTM2N2Q2NzQ0N2VhNjgxMDhlMWQKL2Rldi9tYXBwZXIvMzYwMDE0MDU4NGUx
MWViMTgxOGM0YWZhYjEyYzE3ODAwCi9kZXYvbWFwcGVyLzM2MDAxNDA1Yjc2NzliZDk2YjA5NGJj
Y2JmOTcxYmM5MCIKCgpmb3IgZGlzayBpbiAke2Rpc2tfbGlzdH0KZG8KICAgICAgICBta2ZzLmV4
dDQgLUYgJGRpc2sKZG9uZQoKd2hpbGUgdHJ1ZQpkbwogICAgICAgIGZvciBkaXNrIGluICR7ZGlz
a19saXN0fQogICAgICAgIGRvCiAgICAgICAgICAgICAgICB0ZXN0X2Rpcj0ke2Rpc2sjIyovfQog
ICAgICAgICAgICAgICAgWyAtZCAkdGVzdF9kaXIgXSAmJiB1bW91bnQgJHRlc3RfZGlyIHx8IG1r
ZGlyICR0ZXN0X2RpcgogICAgICAgICAgICAgICAgd2hpbGUgdHJ1ZQogICAgICAgICAgICAgICAg
ZG8KICAgICAgICAgICAgICAgICAgICAgICAgbW91bnQgLW8gZGF0YV9lcnI9YWJvcnQsZXJyb3Jz
PXJlbW91bnQtcm8gJGRpc2sgJHRlc3RfZGlyICYmIGJyZWFrCiAgICAgICAgICAgICAgICAgICAg
ICAgIHNsZWVwIDAuMQogICAgICAgICAgICAgICAgZG9uZQogICAgICAgICAgICAgICAgbm9odXAg
ZnNzdHJlc3MgLWQgJChwd2QpLyR0ZXN0X2RpciAtbCAxMCAtbiAxMDAwIC1wIDEwIC1YICY+L2Rl
di9udWxsICYKICAgICAgICBkb25lCiAgICAgICAgc2xlZXAgNQoKICAgICAgICB3aGlsZSBbIC1u
ICJgcGlkb2YgZnNzdHJlc3NgIiBdCiAgICAgICAgZG8KICAgICAgICAgICAgICAgIHNsZWVwIDEK
ICAgICAgICBkb25lCmRvbmUKClNlY29uZDoKIyEvYmluL2Jhc2gKd2hpbGUgdHJ1ZQpkbwogICAg
ICAgIHNsZWVwIDE1CiAgICAgICAgaT0wCiAgICAgICAgd2hpbGUgWyAkaSAtbGUgNSBdCiAgICAg
ICAgZG8KICAgICAgICAgICAgICAgIGlzY3NpYWRtIC1tIG5vZGUgLXAgMTAwLjEuMS4xIC11CiAg
ICAgICAgICAgICAgICBpc2NzaWFkbSAtbSBub2RlIC1wIDEwMC4xLjEuMSAtbAogICAgICAgICAg
ICAgICAgc2xlZXAgMQogICAgICAgICAgICAgICAgaXNjc2lhZG0gLW0gbm9kZSAtcCAxMDAuMS4y
LjEgLXUKICAgICAgICAgICAgICAgIGlzY3NpYWRtIC1tIG5vZGUgLXAgMTAwLjEuMi4xIC1sCiAg
ICAgICAgICAgICAgICBzbGVlcCAxCiAgICAgICAgICAgICAgICAoKGk9aSsxKSkKICAgICAgICBk
b25lCmRvbmUKClRoaXJkOgojIS9iaW4vYmFzaApmdW5jdGlvbiBpc2NzaV9xdWVyeSgpCnsKICAg
ICAgICBpbnRlcnZhbD01CiAgICAgICAgd2hpbGUgdHJ1ZQogICAgICAgIGRvCiAgICAgICAgICAg
ICAgICBpc2NzaWFkbSAtbSBub2RlIC1wIDEwMC4xLjEuMSAmPiAvZGV2L251bGwKICAgICAgICAg
ICAgICAgIGlzY3NpYWRtIC1tIG5vZGUgLXAgMTAwLjEuMi4xICY+IC9kZXYvbnVsbAogICAgICAg
ICAgICAgICAgaXNjc2lhZG0gLW0gc2Vzc2lvbiAmPiAvZGV2L251bGwKICAgICAgICAgICAgICAg
IHJlc2Nhbi1zY3NpLWJ1cy5zaCAmPiAvZGV2L251bGwKICAgICAgICAgICAgICAgIHNsZWVwICRp
bnRlcnZhbAogICAgICAgIGRvbmUKfQoKCmZ1bmN0aW9uIG11bHRpcGF0aF9xdWVyeSgpCnsKICAg
ICAgICBpbnRlcnZhbD0xCiAgICAgICAgd2hpbGUgdHJ1ZQogICAgICAgIGRvCiAgICAgICAgICAg
ICAgICBtdWx0aXBhdGggLUYgJj4gL2Rldi9udWxsCiAgICAgICAgICAgICAgICBtdWx0aXBhdGgg
LXIgJj4gL2Rldi9udWxsCiAgICAgICAgICAgICAgICBtdWx0aXBhdGggLXYyICY+IC9kZXYvbnVs
bAogICAgICAgICAgICAgICAgbXVsdGlwYXRoIC1sbCAmPiAvZGV2L251bGwKICAgICAgICAgICAg
ICAgIHNsZWVwICRpbnRlcnZhbAogICAgICAgIGRvbmUKfQoKZnVuY3Rpb24gbXVsdGlwYXRoZF9x
dWVyeSgpCnsKICAgICAgICBkaXNrX2Jhc2U9NjMgIyBzZGMKICAgICAgICBpbnRlcnZhbD0xCiAg
ICAgICAgd2hpbGUgdHJ1ZQogICAgICAgIGRvCiAgICAgICAgICAgICAgICBtdWx0aXBhdGhkIHNo
b3cgcGF0aHMgJj4gL2Rldi9udWxsCiAgICAgICAgICAgICAgICBtdWx0aXBhdGhkIHNob3cgc3Rh
dHVzICY+IC9kZXYvbnVsbAogICAgICAgICAgICAgICAgbXVsdGlwYXRoZCBzaG93IGRhZW1vbiAm
PiAvZGV2L251bGwKICAgICAgICAgICAgICAgIG11bHRpcGF0aGQgc2hvdyBtYXBzIGpzb24gJj4g
L2Rldi9udWxsCiAgICAgICAgICAgICAgICBtdWx0aXBhdGhkIHNob3cgY29uZmlnICY+IC9kZXYv
bnVsbAogICAgICAgICAgICAgICAgbXVsdGlwYXRoZCBzaG93IGNvbmZpZyBsb2NhbCAmPiAvZGV2
L251bGwKICAgICAgICAgICAgICAgIG11bHRpcGF0aGQgc2hvdyBibGFja2xpc3QgJj4gL2Rldi9u
dWxsCiAgICAgICAgICAgICAgICBtdWx0aXBhdGhkIHNob3cgZGV2aWNlcyAmPiAvZGV2L251bGwK
ICAgICAgICAgICAgICAgIG11bHRpcGF0aGQgcmVzZXQgbWFwcyBzdGF0cyAmPiAvZGV2L251bGwK
ICAgICAgICAgICAgICAgIG11bHRpcGF0aGQgZGlzYWJsZXF1ZXVlaW5nIG1hcHMgJj4gL2Rldi9u
dWxsCiAgICAgICAgICAgICAgICBtdWx0aXBhdGhkIHJlc3RvcmVxdWV1ZWluZyBtYXBzICY+IC9k
ZXYvbnVsbAogICAgICAgICAgICAgICAgbXVsdGlwYXRoZCBmb3JjZXF1ZXVlaW5nIGRhZW1vbiAm
PiAvZGV2L251bGwKICAgICAgICAgICAgICAgIG11bHRpcGF0aGQgcmVzdG9yZXF1ZXVlaW5nIGRh
ZW1vbiAmPiAvZGV2L251bGwKCiAgICAgICAgICAgICAgICBsZXQgZGlza19udW09ZGlza19iYXNl
K1JBTkRPTSU4CiAgICAgICAgICAgICAgICBkaXNrPXNkYGVjaG8gIiRkaXNrX251bSIgfCB4eGQg
LXAgLXJgCiAgICAgICAgICAgICAgICBtdWx0aXBhdGhkIHNob3cgcGF0aCAkZGlzayAmPiAvZGV2
L251bGwKICAgICAgICAgICAgICAgIG11bHRpcGF0aGQgZGVsIHBhdGggJGRpc2sgJj4gL2Rldi9u
dWxsCiAgICAgICAgICAgICAgICBtdWx0aXBhdGhkIGFkZCBwYXRoICRkaXNrICY+IC9kZXYvbnVs
bAogICAgICAgICAgICAgICAgbXVsdGlwYXRoZCBmYWlsIHBhdGggJGRpc2sgJj4gL2Rldi9udWxs
CiAgICAgICAgICAgICAgICBtdWx0aXBhdGhkIHJlaW5zdGF0ZSBwYXRoICRkaXNrICY+IC9kZXYv
bnVsbAogICAgICAgICAgICAgICAgbXVsdGlwYXRoZCBzaG93IHBhdGggJGRpc2sgJj4gL2Rldi9u
dWxsCgogICAgICAgICAgICAgICAgbWFwX2NvdW50PWBtdWx0aXBhdGhkIHNob3cgbWFwcyB8IGdy
ZXAgLXYgbmFtZSB8IHdjIC1sYAogICAgICAgICAgICAgICAgaWYgWyAkbWFwX2NvdW50IC1nZSAx
IF07dGhlbgogICAgICAgICAgICAgICAgICAgICAgICBsZXQgbWFwX251bT0oUkFORE9NJW1hcF9j
b3VudCkrMQogICAgICAgICAgICAgICAgICAgICAgICBtYXA9YG11bHRpcGF0aGQgc2hvdyBtYXBz
IHwgZ3JlcCAtdiBuYW1lIHwgYXdrICd7cHJpbnQgJDF9JyB8IHNlZCAtbiAiJG1hcF9udW0icGAK
ICAgICAgICAgICAgICAgICAgICAgICAgbXVsdGlwYXRoZCBzaG93IG1hcCAkbWFwICY+IC9kZXYv
bnVsbAogICAgICAgICAgICAgICAgICAgICAgICBtdWx0aXBhdGhkIHN1c3BlbmQgbWFwICRtYXAg
Jj4gL2Rldi9udWxsCiAgICAgICAgICAgICAgICAgICAgICAgIG11bHRpcGF0aGQgcmVzdW1lIG1h
cCAkbWFwICY+IC9kZXYvbnVsbAogICAgICAgICAgICAgICAgICAgICAgICBtdWx0aXBhdGhkIHJl
bG9hZCBtYXAgJG1hcCAmPiAvZGV2L251bGwKICAgICAgICAgICAgICAgICAgICAgICAgbXVsdGlw
YXRoZCByZXNldCBtYXAgJG1hcCAmPiAvZGV2L251bGwKICAgICAgICAgICAgICAgIGZpCgogICAg
ICAgICAgICAgICAgc2xlZXAgJGludGVydmFsCiAgICAgICAgZG9uZQp9CmlzY3NpX3F1ZXJ5ICYK
aXNjc2lfcXVlcnkgJgptdWx0aXBhdGhfcXVlcnkgJgptdWx0aXBhdGhfcXVlcnkgJgptdWx0aXBh
dGhkX3F1ZXJ5ICYKbXVsdGlwYXRoZF9xdWVyeSAmCgoKQWZ0ZXIgdGhlIHRlc3Qgc2NyaXB0cyBh
cmUgZXhlY3V0ZWQgZm9yIHNvbWUgdGltZSAoYWJvdXQgMjRoKSwgdGhlcmUgd2lsbAphIG1ldGFk
YXRhIGVycm9yLiBUaGUgcmVhc29uIGlzIHRoYXQgbXVsdGlwYXRoIGRldmljZSBoYXMgd3Jvbmcg
cGF0aC4gVGhlCmRldGFpbCBvZiB0aGUgZmlyc3Qgc2NlbmU6CgppcDE6Cm5vZGUgICAgICBkaXNr
ICBtaW5vcgo0OjA6MDowOiBbc2RkXSAgNDgKNDowOjA6MTogW3NkbV0gIDE5Mgo0OjA6MDoyOiBb
c2RrXSAgMTYwCjQ6MDowOjM6IFtzZGldICAxMjgKaXAyOgpub2RlICAgICAgZGlzayAgbWlub3IK
NTowOjA6MDogW3NkY10gIDMyCjU6MDowOjE6IFtzZGpdICAxNDQKNTowOjA6MjogW3NkZ10gIDk2
CjU6MDowOjM6IFtzZGVdICA2NAoKU2VxdWVuY2Ugb2YgZXZlbnRzOgooMSltdWx0aXBhdGggLXLv
vIwgaXAxIGxvZ291dCBhdCBzYW1lClRoZSBsb2FkIHRhYmxlIHBhcmFtcyBvZiAzNjAwMTQwNWNh
NTE2NTM2N2Q2NzQ0N2VhNjgxMDhlMWQgaXMKIjAgMSBhbHVhIDEgMSBzZXJ2aWNlLXRpbWUgMCAx
IDEgODoxMjggMSLvvIhUaGUgcmVhc29uIG5vIDEyOCBtYXkKYmUgbm90IGxvbmcgYWZ0ZXIgaXAy
IGxvZ2luIGFuZCBwYXRoX2Rpc2NvdmVyeSBkb2Vzbid0IGZpbmQgc2RlKS4KSG93ZXZlciwgZG9t
YXAgZmFpbGVkIGJlY2F1c2UgaXAxIGxvZ291dC4gVGhlIHBhdGggb2Ygc2RpIGlzCnN0aWxsIGlu
IGd2ZWNzLT5wYXRodmVjLgoKKDIpIG11bHRpcGF0aGQgYWRkIHBhdGggc2RlClRoZSBsb2FkIHRh
YmxlIHBhcmFtcyBvZiAzNjAwMTQwNWNhNTE2NTM2N2Q2NzQ0N2VhNjgxMDhlMWQgaXMKIjAgMSBh
bHVhIDIgMSBzZXJ2aWNlLXRpbWUgMCAxIDEgODo2NCAxIHNlcnZpY2UtdGltZSAwIDEgMSA4OjEy
OCAiCmFuZCBkb21hcCBzdWNjZXNzZXMuCkF0IHRoaXMgdGltZSwgMzYwMDE0MDVjYTUxNjUzNjdk
Njc0NDdlYTY4MTA4ZTFkIGhhcyB0d28gcGF0aCAoc2RlLCBzZGkpLApidXQgc2RpIGlzIGFjdHVh
bGx5IHRoZSBwYXRoIG9mIDM2MDAxNDA1Yjc2NzliZDk2YjA5NGJjY2JmOTcxYmM5MC4KCigzKSBt
ZXRhZGF0YSBvZiAzNjAwMTQwNWNhNTE2NTM2N2Q2NzQ0N2VhNjgxMDhlMWQgc3luYwpUaGUgbWV0
YWRhdGEgb2YgMzYwMDE0MDViNzY3OWJkOTZiMDk0YmNjYmY5NzFiYzkwIHdpbGwgYmUgY292ZXJl
ZC4KCig0KSB1bW91bnQgMzYwMDE0MDViNzY3OWJkOTZiMDk0YmNjYmY5NzFiYzkwCjM2MDAxNDA1
Yjc2NzliZDk2YjA5NGJjY2JmOTcxYmM5MCBoYXMgbm8gdXNhYmxlIHBhdGggd2hlbiB1bW91bnQs
CnNvIHRoZSBjb3JyZWN0IG1ldGFkYXRhIGRvZXNuJ3Qgc3luYy4KCig1KSBtb3VudCAzNjAwMTQw
NWI3Njc5YmQ5NmIwOTRiY2NiZjk3MWJjOTAKRmFpbGVkIGJlY2F1c2Ugb2YgZXJyIG1ldGFkYXRh
CgpJIHRoaW5rIHRoZXJlIG1heSBiZSBvdGhlciB3YXlzIHRvIGxlYWQgbWV0YWRhdGEgZXJyIHRv
by4gSSBoYXZlIG5vIGdvb2QKaWRlYSB0byBkZWFsIHRoaXMuIENhbiB5b3UgZ2l2ZSBhIGdyZWF0
IGFkdmljZSBhYm91dCB0aGlzLiBUaGFua3MgdmVyeSBtdWNoLgoKUmVnYXJkcywKTGl4aWFva2Vu
ZwoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
d3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

