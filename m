Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3465EC433E0
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AE3B62068D
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE3B62068D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=126.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-Ph_b77U5MdCkjAM4_cQy6Q-1; Mon, 04 Jan 2021 14:03:54 -0500
X-MC-Unique: Ph_b77U5MdCkjAM4_cQy6Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F3E71005504;
	Mon,  4 Jan 2021 19:03:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E60F5100239A;
	Mon,  4 Jan 2021 19:03:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BAA6650037;
	Mon,  4 Jan 2021 19:03:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BG74PAw026253 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 02:04:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F153FAE7C3; Wed, 16 Dec 2020 07:04:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EAAB1AE7C5
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 07:04:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65C34186E124
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 07:04:21 +0000 (UTC)
Received: from m153.mail.126.com (m153.mail.126.com [220.181.15.3]) by
	relay.mimecast.com with ESMTP id us-mta-558-HNSDyzDjNd655VSSM60qeA-1;
	Wed, 16 Dec 2020 02:04:15 -0500
X-MC-Unique: HNSDyzDjNd655VSSM60qeA-1
Received: from silenceocean$126.com ( [202.80.192.21] ) by
	ajax-webmail-wmsvr3 (Coremail) ; Wed, 16 Dec 2020 14:32:18 +0800
	(GMT+08:00)
X-Originating-IP: [202.80.192.21]
Date: Wed, 16 Dec 2020 14:32:18 +0800 (GMT+08:00)
From: wu <silenceocean@126.com>
To: "Martin Wilck" <mwilck@suse.com>,
	"Benjamin Marzinski" <bmarzins@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
X-Priority: 3
MIME-Version: 1.0
Message-ID: <313fc3d2.1363.1766a3fdd25.Coremail.silenceocean@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: A8qowADnC770qdlfADZuAA--.65295W
X-CM-SenderInfo: pvlov05fhruvldq6ij2wof0z/1tbiZwP8Sl16fu3T3gABsq
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Subject: [dm-devel] [PATCH] multipath: fix path checkint not changed when
 path state
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============7916653890853182913=="

--===============7916653890853182913==
Content-Type: multipart/alternative; 
	boundary="----=_Part_14663_684333014.1608100338980"

------=_Part_14663_684333014.1608100338980
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64

SGkgbWFydGluLCBiZW4gYW5kIGFsbCwKCgpDb3VsZCB5b3UgaGVscCB0byB2aWV3IGJlbG93IHBh
dGNoLCB0aGFua3MgYSBsb3R+CgoKRnJvbSAwMzVmNTEzMDU3NjY4NzliMWJkNDM2ZWY0NDA5Y2Nm
MzIyMTVhMjcxIE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBDaG9uZ3l1biBXdSA8d3Vj
eTExQGNoaW5hdGVsZWNvbS5jbj4KRGF0ZTogV2VkLCAxNiBEZWMgMjAyMCAxMzo1OToxNiArMDgw
MApTdWJqZWN0OiBbUEFUQ0hdIG11bHRpcGF0aGQ6IGZpeCBwYXRoIGNoZWNraW50IG5vdCBjaGFu
Z2VkIHdoZW4gcGF0aCBzdGF0ZQogZm9ybSBkZWxheSB0byBmYWlsZWQKCgpDaGVja19wYXRoOiB3
aGVuIHBhdGggc3RhdGUgY2hhbmdlIGJhY2sgdG8gZmFpbGVkIGZyb20gZGVsYXkgc3RhdGUsIHNo
b3VsZCBjaGFuZ2UKdGhpcyBwYXRoJ3MgY2hlY2sgaW50ZXJ2YWwgdGltZSB0byB0aGUgc2hvcnRl
c3QgZGVsYXkgdG8gZmFzdGVyIHBhdGggc3RhdGUgY2hlY2suCgoKU2lnbmVkLW9mZi1ieTogQ2hv
bmd5dW4gV3UgPHd1Y3kxMUBjaGluYXRlbGVjb20uY24+Ci0tLQogbXVsdGlwYXRoZC9tYWluLmMg
fCA3ICsrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKykKCgpkaWZmIC0tZ2l0
IGEvbXVsdGlwYXRoZC9tYWluLmMgYi9tdWx0aXBhdGhkL21haW4uYwppbmRleCBhNGFiYmIyNy4u
OGFiMmQ4NDggMTAwNjQ0Ci0tLSBhL211bHRpcGF0aGQvbWFpbi5jCisrKyBiL211bHRpcGF0aGQv
bWFpbi5jCkBAIC0yMTY2LDYgKzIxNjYsMTMgQEAgY2hlY2tfcGF0aCAoc3RydWN0IHZlY3RvcnMg
KiB2ZWNzLCBzdHJ1Y3QgcGF0aCAqIHBwLCB1bnNpZ25lZCBpbnQgdGlja3MpCiAgICAocHAtPnN0
YXRlID09IFBBVEhfREVMQVlFRCkpIHsKICAgLyogSWYgcGF0aCBzdGF0ZSBiZWNvbWUgZmFpbGVk
IGFnYWluIGNhbmNlbCBwYXRoIGRlbGF5IHN0YXRlICovCiAgIHBwLT5zdGF0ZSA9IG5ld3N0YXRl
OworIC8qCisgKiBwYXRoIHN0YXRlIGJhZCBhZ2FpbiBzaG91bGQgY2hhbmdlIHRoZSBjaGVjayBp
bnRlcnZhbCB0aW1lCisgKiB0byB0aGUgc2hvcnRlc3QgZGVsYXkKKyAqLworIGNvbmYgPSBnZXRf
bXVsdGlwYXRoX2NvbmZpZygpOworIHBwLT5jaGVja2ludCA9IGNvbmYtPmNoZWNraW50OworIHB1
dF9tdWx0aXBhdGhfY29uZmlnKGNvbmYpOwogICByZXR1cm4gMTsKICB9CiAgaWYgKCFwcC0+bXBw
KSB7Ci0tIAoyLjI5LjIud2luZG93cy4zCgoKQmVzdCBSZWdhcmQsCkNob25neXVuIFd1
------=_Part_14663_684333014.1608100338980
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGh0bWw+CjxoZWFkPgogICAgPG1ldGEgaHR0cC1lcXVpdj0iQ29udGVudC1UeXBlIiBjb250ZW50
PSJ0ZXh0L2h0bWw7IGNoYXJzZXQ9VVRGLTgiPgo8L2hlYWQ+Cjxib2R5Pgo8c3R5bGU+CiAgICBm
b250ewogICAgICAgIGxpbmUtaGVpZ2h0OiAxLjY7CiAgICB9CiAgICB1bCxvbHsKICAgICAgICBw
YWRkaW5nLWxlZnQ6IDIwcHg7CiAgICAgICAgbGlzdC1zdHlsZS1wb3NpdGlvbjogaW5zaWRlOwog
ICAgfQo8L3N0eWxlPgo8ZGl2IHN0eWxlPSJmb250LWZhbWlseTrlvq7ova/pm4Xpu5EsVmVyZGFu
YSwmcXVvdDtNaWNyb3NvZnQgWWFoZWkmcXVvdDssU2ltU3VuLHNhbnMtc2VyaWY7Zm9udC1zaXpl
OjE0cHg7IGxpbmUtaGVpZ2h0OjEuNjsiPgogICAgPGRpdj48L2Rpdj48ZGl2PgogICAgPGRpdj48
c3Bhbj5IaSBtYXJ0aW4sIGJlbiBhbmQgYWxsLDwvc3Bhbj48L2Rpdj48ZGl2Pjxicj48L2Rpdj48
ZGl2PkNvdWxkIHlvdSBoZWxwIHRvIHZpZXcgYmVsb3cgcGF0Y2gsIHRoYW5rcyBhIGxvdH48L2Rp
dj48ZGl2PjxzcGFuPjxicj48L3NwYW4+PC9kaXY+PGRpdj4KICAgICAgICA8c3Bhbj5Gcm9tIDAz
NWY1MTMwNTc2Njg3OWIxYmQ0MzZlZjQ0MDljY2YzMjIxNWEyNzEgTW9uIFNlcCAxNyAwMDowMDow
MCAyMDAxCiAgICAgICAgPC9zcGFuPgogICAgPC9kaXY+PGRpdj48c3Bhbj5Gcm9tOiBDaG9uZ3l1
biBXdSAmbHQ7d3VjeTExQGNoaW5hdGVsZWNvbS5jbiZndDs8L3NwYW4+PC9kaXY+PGRpdj48c3Bh
bj5EYXRlOiBXZWQsIDE2IERlYyAyMDIwIDEzOjU5OjE2ICswODAwPC9zcGFuPjwvZGl2PjxkaXY+
PHNwYW4+U3ViamVjdDogW1BBVENIXSBtdWx0aXBhdGhkOiBmaXggcGF0aCBjaGVja2ludCBub3Qg
Y2hhbmdlZCB3aGVuIHBhdGggc3RhdGU8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj4mbmJzcDtmb3Jt
IGRlbGF5IHRvIGZhaWxlZDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPjxicj48L3NwYW4+PC9kaXY+
PGRpdj48c3Bhbj5DaGVja19wYXRoOiB3aGVuIHBhdGggc3RhdGUgY2hhbmdlIGJhY2sgdG8gZmFp
bGVkIGZyb20gZGVsYXkgc3RhdGUsIHNob3VsZCBjaGFuZ2U8L3NwYW4+PC9kaXY+PGRpdj48c3Bh
bj50aGlzIHBhdGgncyBjaGVjayBpbnRlcnZhbCB0aW1lIHRvIHRoZSBzaG9ydGVzdCBkZWxheSB0
byBmYXN0ZXIgcGF0aCBzdGF0ZSBjaGVjay48L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj48YnI+PC9z
cGFuPjwvZGl2PjxkaXY+PHNwYW4+U2lnbmVkLW9mZi1ieTogQ2hvbmd5dW4gV3UgJmx0O3d1Y3kx
MUBjaGluYXRlbGVjb20uY24mZ3Q7PC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+LS0tPC9zcGFuPjwv
ZGl2PjxkaXY+PHNwYW4+Jm5ic3A7bXVsdGlwYXRoZC9tYWluLmMgfCA3ICsrKysrKys8L3NwYW4+
PC9kaXY+PGRpdj48c3Bhbj4mbmJzcDsxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspPC9z
cGFuPjwvZGl2PjxkaXY+PHNwYW4+PGJyPjwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPmRpZmYgLS1n
aXQgYS9tdWx0aXBhdGhkL21haW4uYyBiL211bHRpcGF0aGQvbWFpbi5jPC9zcGFuPjwvZGl2Pjxk
aXY+PHNwYW4+aW5kZXggYTRhYmJiMjcuLjhhYjJkODQ4IDEwMDY0NDwvc3Bhbj48L2Rpdj48ZGl2
PjxzcGFuPi0tLSBhL211bHRpcGF0aGQvbWFpbi5jPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+Kysr
IGIvbXVsdGlwYXRoZC9tYWluLmM8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5AQCAtMjE2Niw2ICsy
MTY2LDEzIEBAIGNoZWNrX3BhdGggKHN0cnVjdCB2ZWN0b3JzICogdmVjcywgc3RydWN0IHBhdGgg
KiBwcCwgdW5zaWduZWQgaW50IHRpY2tzKTwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPiZuYnNwOyAm
bmJzcDsgKHBwLSZndDtzdGF0ZSA9PSBQQVRIX0RFTEFZRUQpKSB7PC9zcGFuPjwvZGl2PjxkaXY+
PHNwYW4+Jm5ic3A7ICZuYnNwOy8qIElmIHBhdGggc3RhdGUgYmVjb21lIGZhaWxlZCBhZ2FpbiBj
YW5jZWwgcGF0aCBkZWxheSBzdGF0ZSAqLzwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPiZuYnNwOyAm
bmJzcDtwcC0mZ3Q7c3RhdGUgPSBuZXdzdGF0ZTs8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj4rCQkv
Kjwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPisJCSAqIHBhdGggc3RhdGUgYmFkIGFnYWluIHNob3Vs
ZCBjaGFuZ2UgdGhlIGNoZWNrIGludGVydmFsIHRpbWU8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj4r
CQkgKiB0byB0aGUgc2hvcnRlc3QgZGVsYXk8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj4rCQkgKi88
L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj4rCQljb25mID0gZ2V0X211bHRpcGF0aF9jb25maWcoKTs8
L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj4rCQlwcC0mZ3Q7Y2hlY2tpbnQgPSBjb25mLSZndDtjaGVj
a2ludDs8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj4rCQlwdXRfbXVsdGlwYXRoX2NvbmZpZyhjb25m
KTs8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj4mbmJzcDsgJm5ic3A7cmV0dXJuIDE7PC9zcGFuPjwv
ZGl2PjxkaXY+PHNwYW4+Jm5ic3A7IH08L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj4mbmJzcDsgaWYg
KCFwcC0mZ3Q7bXBwKSB7PC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+LS0mbmJzcDs8L3NwYW4+PC9k
aXY+PGRpdj48c3Bhbj4yLjI5LjIud2luZG93cy4zPC9zcGFuPjwvZGl2PgogICAgPGRpdj4KICAg
ICAgICA8c3Bhbj4KICAgICAgICAgICAgPGJyPgogICAgICAgIDwvc3Bhbj4KICAgIDwvZGl2Pgog
ICAgPGRpdiBpZD0ibnRlcy1wY21hYy1zaWduYXR1cmUiIHN0eWxlPSJmb250LWZhbWlseTon5b6u
6L2v6ZuF6buRJyI+CiAgICAgICAgIDxkaXYgc3R5bGU9ImZvbnQtc2l6ZToxNHB4OyBwYWRkaW5n
OiAwOyAgbWFyZ2luOjA7Ij4KICAgICAgICA8ZGl2IHN0eWxlPSJwYWRkaW5nLWJvdHRvbToxMHB4
O21hcmdpbi1ib3R0b206MTBweDtkaXNwbGF5OmlubGluZS1ibG9jazsiPgogICAgICAgICAgICA8
ZGl2IHN0eWxlPSJtYXJnaW46MDsiPkJlc3QgUmVnYXJkLDwvZGl2PjxkaXYgc3R5bGU9Im1hcmdp
bjowOyI+Q2hvbmd5dW4gV3U8L2Rpdj4KICAgICAgICA8L2Rpdj4KICAgIDwvZGl2PgogICAgIDwv
ZGl2Pgo8L2Rpdj48IS0t8J+YgC0tPgo8L2Rpdj4KPC9ib2R5Pgo8L2h0bWw+
------=_Part_14663_684333014.1608100338980--

--===============7916653890853182913==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============7916653890853182913==--

