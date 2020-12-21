Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C516C433E0
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 124652068D
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 124652068D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=chinatelecom.cn
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-RAGK9o0rM-uF24xOOyatnQ-1; Mon, 04 Jan 2021 14:03:36 -0500
X-MC-Unique: RAGK9o0rM-uF24xOOyatnQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA812107AD2E;
	Mon,  4 Jan 2021 19:03:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B4D7174AA7;
	Mon,  4 Jan 2021 19:03:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8325C50030;
	Mon,  4 Jan 2021 19:03:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BL3Drba028480 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 20 Dec 2020 22:13:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1D93D2026D49; Mon, 21 Dec 2020 03:13:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1896A2026D46
	for <dm-devel@redhat.com>; Mon, 21 Dec 2020 03:13:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAE94101A53F
	for <dm-devel@redhat.com>; Mon, 21 Dec 2020 03:13:50 +0000 (UTC)
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.223]) by
	relay.mimecast.com with ESMTP id us-mta-415-eYM4GBzJMdmwXrNJiXGAag-1;
	Sun, 20 Dec 2020 22:13:45 -0500
X-MC-Unique: eYM4GBzJMdmwXrNJiXGAag-1
HMM_SOURCE_IP: 172.18.0.92:25930.853389769
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.21?logid-a15af0c554974d1c87e4e92a20b04c30
	(unknown [172.18.0.92])
	by chinatelecom.cn (HERMES) with SMTP id F20662800B8;
	Mon, 21 Dec 2020 11:13:40 +0800 (CST)
X-189-SAVE-TO-SEND: wucy11@chinatelecom.cn
Received: from  ([172.18.0.92])
	by App0021 with ESMTP id a15af0c554974d1c87e4e92a20b04c30 for
	mwilck@suse.com; Mon Dec 21 11:13:41 2020
X-Transaction-ID: a15af0c554974d1c87e4e92a20b04c30
X-filter-score: filter<0>
X-Real-From: wucy11@chinatelecom.cn
X-Receive-IP: 172.18.0.92
X-MEDUSA-Status: 0
Date: Mon, 21 Dec 2020 11:13:38 +0800
From: wucy11 <wucy11@chinatelecom.cn>
To: "=?utf-8?Q?mwilck=40suse.com?=" <mwilck@suse.com>,
	"=?utf-8?Q?bmarzins=40redhat.com?=" <bmarzins@redhat.com>,
	"=?utf-8?Q?dm-devel=40redhat.com?=" <dm-devel@redhat.com>
Message-ID: <008F6ED7-7117-458B-A573-B7396E4EF537@chinatelecom.cn>
X-CUSTOM-MAIL-MASTER-SENT-ID: 8298793E-CBD7-4B4A-9549-842C80F89113
MIME-Version: 1.0
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
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Subject: [dm-devel] =?utf-8?q?_=5BPATCH_v3=5D_multipathd=3A_fix_path_check?=
 =?utf-8?q?int_not_changed_when_path_state_changed_from_delay_to_failed?=
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============8134494771957454526=="

--===============8134494771957454526==
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: base64

PGh0bWw+DQo8aGVhZD4NCiAgICA8bWV0YSBodHRwLWVxdWl2PSdDb250ZW50LVR5cGUnIGNvbnRl
bnQ9J3RleHQvaHRtbDsgY2hhcnNldD1VVEYtOCc+DQo8L2hlYWQ+DQo8Ym9keT4NCjxzdHlsZT4N
CiAgICBmb250ew0KICAgICAgICBsaW5lLWhlaWdodDogMS42Ow0KICAgIH0NCiAgICB1bCxvbHsN
CiAgICAgICAgcGFkZGluZy1sZWZ0OiAyMHB4Ow0KICAgICAgICBsaXN0LXN0eWxlLXBvc2l0aW9u
OiBpbnNpZGU7DQogICAgfQ0KPC9zdHlsZT4NCjxkaXYgc3R5bGUgPSAnZm9udC1mYW1pbHk65b6u
6L2v6ZuF6buRLFZlcmRhbmEsJnF1b3Q7TWljcm9zb2Z0IFlhaGVpJnF1b3Q7LFNpbVN1bixzYW5z
LXNlcmlmO2ZvbnQtc2l6ZToxNHB4OyBsaW5lLWhlaWdodDoxLjY7Jz4NCiAgICA8ZGl2ID48L2Rp
dj4KPHN0eWxlPgogICAgZm9udHsKICAgICAgICBsaW5lLWhlaWdodDogMS42OwogICAgfQogICAg
dWwsb2x7CiAgICAgICAgcGFkZGluZy1sZWZ0OiAyMHB4OwogICAgICAgIGxpc3Qtc3R5bGUtcG9z
aXRpb246IGluc2lkZTsKICAgIH0KPC9zdHlsZT4KPGRpdiBzdHlsZT0iZm9udC1mYW1pbHk65b6u
6L2v6ZuF6buRLFZlcmRhbmEsJnF1b3Q7TWljcm9zb2Z0IFlhaGVpJnF1b3Q7LFNpbVN1bixzYW5z
LXNlcmlmO2ZvbnQtc2l6ZToxNHB4OyBsaW5lLWhlaWdodDoxLjY7Ij4KICAgIDxkaXY+PC9kaXY+
PGRpdj4KICAgIDxkaXY+PGRpdiBzdHlsZT0iZm9udC1mYW1pbHk6IOW+rui9r+mbhem7kSwgVmVy
ZGFuYSwgJ01pY3Jvc29mdCBZYWhlaScsIFNpbVN1biwgc2Fucy1zZXJpZjsgbGluZS1oZWlnaHQ6
IDIyLjRweDsiPjxkaXYgc3R5bGU9ImxpbmUtaGVpZ2h0OiAyMi40cHg7Ij5IaSBhbGwsPC9kaXY+
PGRpdiBzdHlsZT0ibGluZS1oZWlnaHQ6IDIyLjRweDsiPjxzcGFuIHN0eWxlPSJsaW5lLWhlaWdo
dDogMS42OyI+VGhlIG5ldyBwYXRjaCBzaG93biBhcyBiZWxvdyBhPC9zcGFuPjxzcGFuIHN0eWxl
PSJsaW5lLWhlaWdodDogMjIuNHB4OyI+Y29jb3JkaW5nIHRvIGJlbidzIHN1Z2dlc3Rpb24sICZu
YnNwO3A8L3NwYW4+PHNwYW4gc3R5bGU9ImZvbnQtZmFtaWx5OiDlvq7ova/pm4Xpu5E7IGxpbmUt
aGVpZ2h0OiAxLjY7Ij5sZWFzZSBpZ25vcmUgdjIsIHRoYW5rcy48L3NwYW4+PC9kaXY+PC9kaXY+
PGRpdiBzdHlsZT0iZm9udC1mYW1pbHk6IOW+rui9r+mbhem7kSwgVmVyZGFuYSwgJ01pY3Jvc29m
dCBZYWhlaScsIFNpbVN1biwgc2Fucy1zZXJpZjsgbGluZS1oZWlnaHQ6IDIyLjRweDsiPjxicj48
L2Rpdj48ZGl2PjxkaXY+RnJvbSAzMWVjNGU5YzI3MGZmODU0YjhlZGM1MjZjNWJjYzliMjQ2MDhk
NzUxIE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMTwvZGl2PjxkaXY+RnJvbTogQ2hvbmd5dW4gV3Ug
Jmx0O3d1Y3kxMUBjaGluYXRlbGVjb20uY24mZ3Q7PC9kaXY+PGRpdj5EYXRlOiBXZWQsIDE2IERl
YyAyMDIwIDEzOjU5OjE2ICswODAwPC9kaXY+PGRpdj5TdWJqZWN0OiBbUEFUQ0hdIG11bHRpcGF0
aGQ6IGZpeCBwYXRoIGNoZWNraW50IG5vdCBjaGFuZ2VkIHdoZW4gcGF0aCBzdGF0ZTwvZGl2Pjxk
aXY+Jm5ic3A7Zm9ybSBkZWxheSB0byBmYWlsZWQ8L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2PkNo
ZWNrX3BhdGg6IHdoZW4gcGF0aCBzdGF0ZSBjaGFuZ2UgYmFjayB0byBmYWlsZWQgZnJvbSBkZWxh
eSBzdGF0ZSwgc2hvdWxkIGNoYW5nZTwvZGl2PjxkaXYgc3R5bGU9IiI+dGhpcyBwYXRoJ3MgY2hl
Y2sgaW50ZXJ2YWwgdGltZSB0byB0aGUgc2hvcnRlc3QgZGVsYXkgdG8gZmFzdGVyIHBhdGggc3Rh
dGUgY2hlY2suPC9kaXY+PGRpdj48YnI+PC9kaXY+PGRpdiBzdHlsZT0iIj5TaWduZWQtb2ZmLWJ5
OiBDaG9uZ3l1biBXdSAmbHQ7d3VjeTExQGNoaW5hdGVsZWNvbS5jbiZndDs8L2Rpdj48ZGl2IHN0
eWxlPSIiPi0tLTwvZGl2PjxkaXY+Jm5ic3A7bXVsdGlwYXRoZC9tYWluLmMgfCA1ICsrKysrPC9k
aXY+PGRpdj4mbmJzcDsxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspPC9kaXY+PGRpdj48
YnI+PC9kaXY+PGRpdj5kaWZmIC0tZ2l0IGEvbXVsdGlwYXRoZC9tYWluLmMgYi9tdWx0aXBhdGhk
L21haW4uYzwvZGl2PjxkaXY+aW5kZXggYTRhYmJiMjcuLjlmZDM0ZTk3IDEwMDY0NDwvZGl2Pjxk
aXY+LS0tIGEvbXVsdGlwYXRoZC9tYWluLmM8L2Rpdj48ZGl2PisrKyBiL211bHRpcGF0aGQvbWFp
bi5jPC9kaXY+PGRpdj5AQCAtMjE2Niw2ICsyMTY2LDExIEBAIGNoZWNrX3BhdGggKHN0cnVjdCB2
ZWN0b3JzICogdmVjcywgc3RydWN0IHBhdGggKiBwcCwgdW5zaWduZWQgaW50IHRpY2tzKTwvZGl2
PjxkaXY+Jm5ic3A7PHNwYW4gY2xhc3M9IkFwcGxlLXRhYi1zcGFuIiBzdHlsZT0id2hpdGUtc3Bh
Y2U6cHJlIj4JCQk8L3NwYW4+KHBwLSZndDtzdGF0ZSA9PSBQQVRIX0RFTEFZRUQpKSB7PC9kaXY+
PGRpdj4mbmJzcDs8c3BhbiBjbGFzcz0iQXBwbGUtdGFiLXNwYW4iIHN0eWxlPSJ3aGl0ZS1zcGFj
ZTpwcmUiPgkJPC9zcGFuPi8qIElmIHBhdGggc3RhdGUgYmVjb21lIGZhaWxlZCBhZ2FpbiBjYW5j
ZWwgcGF0aCBkZWxheSBzdGF0ZSAqLzwvZGl2PjxkaXY+Jm5ic3A7PHNwYW4gY2xhc3M9IkFwcGxl
LXRhYi1zcGFuIiBzdHlsZT0id2hpdGUtc3BhY2U6cHJlIj4JCTwvc3Bhbj5wcC0mZ3Q7c3RhdGUg
PSBuZXdzdGF0ZTs8L2Rpdj48ZGl2Pis8c3BhbiBjbGFzcz0iQXBwbGUtdGFiLXNwYW4iIHN0eWxl
PSJ3aGl0ZS1zcGFjZTpwcmUiPgkJPC9zcGFuPi8qPC9kaXY+PGRpdj4rPHNwYW4gY2xhc3M9IkFw
cGxlLXRhYi1zcGFuIiBzdHlsZT0id2hpdGUtc3BhY2U6cHJlIj4JCTwvc3Bhbj4gKiBwYXRoIHN0
YXRlIGJhZCBhZ2FpbiBzaG91bGQgY2hhbmdlIHRoZSBjaGVjayBpbnRlcnZhbCB0aW1lPC9kaXY+
PGRpdj4rPHNwYW4gY2xhc3M9IkFwcGxlLXRhYi1zcGFuIiBzdHlsZT0id2hpdGUtc3BhY2U6cHJl
Ij4JCTwvc3Bhbj4gKiB0byB0aGUgc2hvcnRlc3QgZGVsYXk8L2Rpdj48ZGl2Pis8c3BhbiBjbGFz
cz0iQXBwbGUtdGFiLXNwYW4iIHN0eWxlPSJ3aGl0ZS1zcGFjZTpwcmUiPgkJPC9zcGFuPiAqLzwv
ZGl2PjxkaXY+KzxzcGFuIGNsYXNzPSJBcHBsZS10YWItc3BhbiIgc3R5bGU9IndoaXRlLXNwYWNl
OnByZSI+CQk8L3NwYW4+cHAtJmd0O2NoZWNraW50ID0gY2hlY2tpbnQ7PC9kaXY+PGRpdj4mbmJz
cDs8c3BhbiBjbGFzcz0iQXBwbGUtdGFiLXNwYW4iIHN0eWxlPSJ3aGl0ZS1zcGFjZTpwcmUiPgkJ
PC9zcGFuPnJldHVybiAxOzwvZGl2PjxkaXY+Jm5ic3A7PHNwYW4gY2xhc3M9IkFwcGxlLXRhYi1z
cGFuIiBzdHlsZT0id2hpdGUtc3BhY2U6cHJlIj4JPC9zcGFuPn08L2Rpdj48ZGl2PiZuYnNwOzxz
cGFuIGNsYXNzPSJBcHBsZS10YWItc3BhbiIgc3R5bGU9IndoaXRlLXNwYWNlOnByZSI+CTwvc3Bh
bj5pZiAoIXBwLSZndDttcHApIHs8L2Rpdj48ZGl2Pi0tJm5ic3A7PC9kaXY+PGRpdj4yLjI5LjIu
d2luZG93cy4zPC9kaXY+PGRpdiBzdHlsZT0iZm9udC1mYW1pbHk6IOW+rui9r+mbhem7kSwgVmVy
ZGFuYSwgJ01pY3Jvc29mdCBZYWhlaScsIFNpbVN1biwgc2Fucy1zZXJpZjsgbGluZS1oZWlnaHQ6
IDIyLjRweDsiPjxicj48L2Rpdj48L2Rpdj48L2Rpdj48ZGl2PgogICAgPC9kaXY+CiAgICA8ZGl2
IGlkPSJudGVzLXBjbWFjLXNpZ25hdHVyZSIgc3R5bGU9ImZvbnQtZmFtaWx5Oiflvq7ova/pm4Xp
u5EnIj4KICAgICAgICAgPGRpdiBzdHlsZT0iZm9udC1zaXplOjE0cHg7IHBhZGRpbmc6IDA7ICBt
YXJnaW46MDsiPgogICAgICAgIDxkaXYgc3R5bGU9InBhZGRpbmctYm90dG9tOjEwcHg7bWFyZ2lu
LWJvdHRvbToxMHB4O2Rpc3BsYXk6aW5saW5lLWJsb2NrOyI+CiAgICAgICAgICAgIDxkaXYgc3R5
bGU9Im1hcmdpbjowOyI+QmVzdCBSZWdhcmQsPC9kaXY+PGRpdiBzdHlsZT0ibWFyZ2luOjA7Ij5D
aG9uZ3l1biBXdTwvZGl2PgogICAgICAgIDwvZGl2PgogICAgPC9kaXY+CiAgICAgPC9kaXY+Cjwv
ZGl2PjwhLS3wn5iALS0+CjwvZGl2PjwhLS3wn5iALS0+DQo8L2Rpdj4NCjwvYm9keT4NCjwvaHRt
bD4=
--===============8134494771957454526==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============8134494771957454526==--

