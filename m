Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 493ECC433E6
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 224D72226A
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 224D72226A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=chinatelecom.cn
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-NZcuer2nP2KKLxoz8MHztg-1; Mon, 04 Jan 2021 14:03:33 -0500
X-MC-Unique: NZcuer2nP2KKLxoz8MHztg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4DF5879511;
	Mon,  4 Jan 2021 19:03:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 873D760D01;
	Mon,  4 Jan 2021 19:03:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5BFDF4EBC6;
	Mon,  4 Jan 2021 19:03:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BL1kOOa021000 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 20 Dec 2020 20:46:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F2DFE1111C66; Mon, 21 Dec 2020 01:46:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EB0B01111C67
	for <dm-devel@redhat.com>; Mon, 21 Dec 2020 01:46:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96B091875040
	for <dm-devel@redhat.com>; Mon, 21 Dec 2020 01:46:21 +0000 (UTC)
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.223]) by
	relay.mimecast.com with ESMTP id us-mta-239-pbq_IUMeP8aBPJJZa3_evw-1;
	Sun, 20 Dec 2020 20:46:18 -0500
X-MC-Unique: pbq_IUMeP8aBPJJZa3_evw-1
HMM_SOURCE_IP: 172.18.0.48:35727.273057104
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.21?logid-41c65b0b89ac40d8bcb75ca742536e89
	(unknown [172.18.0.48])
	by chinatelecom.cn (HERMES) with SMTP id 367DC28012F;
	Mon, 21 Dec 2020 09:39:03 +0800 (CST)
X-189-SAVE-TO-SEND: wucy11@chinatelecom.cn
Received: from  ([172.18.0.48])
	by App0024 with ESMTP id 41c65b0b89ac40d8bcb75ca742536e89 for
	mwilck@suse.com; Mon Dec 21 09:39:08 2020
X-Transaction-ID: 41c65b0b89ac40d8bcb75ca742536e89
X-filter-score: filter<0>
X-Real-From: wucy11@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Date: Mon, 21 Dec 2020 09:39:01 +0800
From: wucy11 <wucy11@chinatelecom.cn>
To: "=?utf-8?Q?mwilck=40suse.com?=" <mwilck@suse.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, "=?utf-8?Q?dm-devel=40redhat.com?="
	<dm-devel@redhat.com>
Message-ID: <7E35E693-82C8-4C7B-B9F5-1D680A853A7A@chinatelecom.cn>
X-CUSTOM-MAIL-MASTER-SENT-ID: 1F451008-280A-4D15-80F8-F42A9FA2DC02
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
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Subject: [dm-devel] =?utf-8?q?_=5BPATCH__v2=5D_multipath=3A_fix_path_check?=
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============5882673442748786927=="

--===============5882673442748786927==
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: base64

PGh0bWw+DQo8aGVhZD4NCiAgICA8bWV0YSBodHRwLWVxdWl2PSdDb250ZW50LVR5cGUnIGNvbnRl
bnQ9J3RleHQvaHRtbDsgY2hhcnNldD1VVEYtOCc+DQo8L2hlYWQ+DQo8Ym9keT4NCjxzdHlsZT4N
CiAgICBmb250ew0KICAgICAgICBsaW5lLWhlaWdodDogMS42Ow0KICAgIH0NCiAgICB1bCxvbHsN
CiAgICAgICAgcGFkZGluZy1sZWZ0OiAyMHB4Ow0KICAgICAgICBsaXN0LXN0eWxlLXBvc2l0aW9u
OiBpbnNpZGU7DQogICAgfQ0KPC9zdHlsZT4NCjxkaXYgc3R5bGUgPSAnZm9udC1mYW1pbHk65b6u
6L2v6ZuF6buRLFZlcmRhbmEsJnF1b3Q7TWljcm9zb2Z0IFlhaGVpJnF1b3Q7LFNpbVN1bixzYW5z
LXNlcmlmO2ZvbnQtc2l6ZToxNHB4OyBsaW5lLWhlaWdodDoxLjY7Jz4NCiAgICA8ZGl2ID48L2Rp
dj48ZGl2PgogICAgPGRpdj5IaSBhbGwsPC9kaXY+PGRpdj48c3BhbiBzdHlsZT0ibGluZS1oZWln
aHQ6IDEuNjsiPlRoZSBuZXcgcGF0Y2ggc2hvd24gYXMgYmVsb3cgYTwvc3Bhbj48c3BhbiBzdHls
ZT0ibGluZS1oZWlnaHQ6IDIyLjRweDsiPmNvY29yZGluZyB0byBiZW4ncyBzdWdnZXN0aW9uLCB0
aGFua3MuPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4gc3R5bGU9ImxpbmUtaGVpZ2h0OiAyMi40cHg7
Ij48YnI+PC9zcGFuPjwvZGl2PjxkaXY+CiAgICAgICAgPHNwYW4+RnJvbSAwMzVmNTEzMDU3NjY4
NzliMWJkNDM2ZWY0NDA5Y2NmMzIyMTVhMjcxIE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KICAg
ICAgICA8L3NwYW4+CiAgICA8L2Rpdj48ZGl2PjxzcGFuPkZyb206IENob25neXVuIFd1ICZsdDt3
dWN5MTFAY2hpbmF0ZWxlY29tLmNuJmd0Ow08L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5EYXRlOiBX
ZWQsIDE2IERlYyAyMDIwIDEzOjU5OjE2ICswODAwDTwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlN1
YmplY3Q6IFtQQVRDSF0gbXVsdGlwYXRoZDogZml4IHBhdGggY2hlY2tpbnQgbm90IGNoYW5nZWQg
d2hlbiBwYXRoIHN0YXRlDTwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPiZuYnNwO2Zvcm0gZGVsYXkg
dG8gZmFpbGVkDTwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPg08L3NwYW4+PC9kaXY+PGRpdj48c3Bh
bj5DaGVja19wYXRoOiB3aGVuIHBhdGggc3RhdGUgY2hhbmdlIGJhY2sgdG8gZmFpbGVkIGZyb20g
ZGVsYXkgc3RhdGUsIHNob3VsZCBjaGFuZ2UNPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+dGhpcyBw
YXRoJ3MgY2hlY2sgaW50ZXJ2YWwgdGltZSB0byB0aGUgc2hvcnRlc3QgZGVsYXkgdG8gZmFzdGVy
IHBhdGggc3RhdGUgY2hlY2suDTwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPg08L3NwYW4+PC9kaXY+
PGRpdj48c3Bhbj5TaWduZWQtb2ZmLWJ5OiBDaG9uZ3l1biBXdSAmbHQ7d3VjeTExQGNoaW5hdGVs
ZWNvbS5jbiZndDsNPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+LS0tDTwvc3Bhbj48L2Rpdj48ZGl2
PjxzcGFuPiZuYnNwO211bHRpcGF0aGQvbWFpbi5jIHwgNyArKysrKysrDTwvc3Bhbj48L2Rpdj48
ZGl2PjxzcGFuPiZuYnNwOzEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKykNPC9zcGFuPjwv
ZGl2PjxkaXY+PHNwYW4+DTwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPmRpZmYgLS1naXQgYS9tdWx0
aXBhdGhkL21haW4uYyBiL211bHRpcGF0aGQvbWFpbi5jDTwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFu
PmluZGV4IGE0YWJiYjI3Li44YWIyZDg0OCAxMDA2NDQNPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+
LS0tIGEvbXVsdGlwYXRoZC9tYWluLmMNPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+KysrIGIvbXVs
dGlwYXRoZC9tYWluLmMNPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+QEAgLTIxNjYsNiArMjE2Niwx
MyBAQCBjaGVja19wYXRoIChzdHJ1Y3QgdmVjdG9ycyAqIHZlY3MsIHN0cnVjdCBwYXRoICogcHAs
IHVuc2lnbmVkIGludCB0aWNrcykNPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+Jm5ic3A7ICZuYnNw
OyAocHAtJmd0O3N0YXRlID09IFBBVEhfREVMQVlFRCkpIHsNPC9zcGFuPjwvZGl2PjxkaXY+PHNw
YW4+Jm5ic3A7ICZuYnNwOy8qIElmIHBhdGggc3RhdGUgYmVjb21lIGZhaWxlZCBhZ2FpbiBjYW5j
ZWwgcGF0aCBkZWxheSBzdGF0ZSAqLw08L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj4mbmJzcDsgJm5i
c3A7cHAtJmd0O3N0YXRlID0gbmV3c3RhdGU7DTwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPisJLyoN
PC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+KwkqIHBhdGggc3RhdGUgYmFkIGFnYWluIHNob3VsZCBj
aGFuZ2UgdGhlIGNoZWNrIGludGVydmFsIHRpbWUNPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+Kwkq
IHRvIHRoZSBzaG9ydGVzdCBkZWxheQ08L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj4rCSovDTwvc3Bh
bj48L2Rpdj48ZGl2PjxzcGFuPisJcHAtJmd0O2NoZWNraW50ID0gY29uZi0mZ3Q7Y2hlY2tpbnQ7
DTwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPiZuYnNwOyAmbmJzcDtyZXR1cm4gMTsNPC9zcGFuPjwv
ZGl2PjxkaXY+PHNwYW4+Jm5ic3A7IH0NPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+Jm5ic3A7IGlm
ICghcHAtJmd0O21wcCkgew08L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj4tLSANPC9zcGFuPjwvZGl2
PjxkaXY+PHNwYW4+Mi4yOS4yLndpbmRvd3MuMzwvc3Bhbj48L2Rpdj4KICAgIDxkaXY+CiAgICAg
ICAgPHNwYW4+CiAgICAgICAgICAgIDxicj4KICAgICAgICA8L3NwYW4+CiAgICA8L2Rpdj4KICAg
IDxkaXYgaWQ9Im50ZXMtcGNtYWMtc2lnbmF0dXJlIiBzdHlsZT0iZm9udC1mYW1pbHk6J+W+rui9
r+mbhem7kSciPgogICAgICAgICA8ZGl2IHN0eWxlPSJmb250LXNpemU6MTRweDsgcGFkZGluZzog
MDsgIG1hcmdpbjowOyI+CiAgICAgICAgPGRpdiBzdHlsZT0icGFkZGluZy1ib3R0b206MTBweDtt
YXJnaW4tYm90dG9tOjEwcHg7ZGlzcGxheTppbmxpbmUtYmxvY2s7Ij4KICAgICAgICAgICAgPGRp
diBzdHlsZT0ibWFyZ2luOjA7Ij5CZXN0IFJlZ2FyZCw8L2Rpdj48ZGl2IHN0eWxlPSJtYXJnaW46
MDsiPkNob25neXVuIFd1PC9kaXY+CiAgICAgICAgPC9kaXY+CiAgICA8L2Rpdj4KICAgICA8L2Rp
dj4KPC9kaXY+PCEtLfCfmIAtLT4NCjwvZGl2Pg0KPC9ib2R5Pg0KPC9odG1sPg==
--===============5882673442748786927==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============5882673442748786927==--

