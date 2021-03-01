Return-Path: <SRS0=9wY3=H7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00C6BC433E0
	for <dm-devel@archiver.kernel.org>; Mon,  1 Mar 2021 13:54:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8728D64DCF
	for <dm-devel@archiver.kernel.org>; Mon,  1 Mar 2021 13:54:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8728D64DCF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cines.fr
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-sLdYEkGuPyC0ysE4e8FLVA-1; Mon, 01 Mar 2021 08:54:06 -0500
X-MC-Unique: sLdYEkGuPyC0ysE4e8FLVA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 271E7107ACE6;
	Mon,  1 Mar 2021 13:54:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9736D5D71F;
	Mon,  1 Mar 2021 13:53:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9B53A4EEF6;
	Mon,  1 Mar 2021 13:53:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 121Drr2p007888 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 1 Mar 2021 08:53:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C85282126C9E; Mon,  1 Mar 2021 13:53:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C295C200BD88
	for <dm-devel@redhat.com>; Mon,  1 Mar 2021 13:53:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AAC43100AFE2
	for <dm-devel@redhat.com>; Mon,  1 Mar 2021 13:53:50 +0000 (UTC)
Received: from sati.cines.fr (sati.cines.fr [193.48.169.59]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-340-G0E2IaKCOnyEd7tD1QnMhw-1;
	Mon, 01 Mar 2021 08:53:47 -0500
X-MC-Unique: G0E2IaKCOnyEd7tD1QnMhw-1
Received: from localhost (localhost.localdomain [127.0.0.1])
	by sati.cines.fr (Postfix) with ESMTP id 3E345262892D
	for <dm-devel@redhat.com>; Mon,  1 Mar 2021 14:44:36 +0100 (CET)
Received: from sati.cines.fr ([127.0.0.1])
	by localhost (sati.cines.fr [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id yLm9YNUg-6fE for <dm-devel@redhat.com>;
	Mon,  1 Mar 2021 14:44:36 +0100 (CET)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by sati.cines.fr (Postfix) with ESMTP id EF44C262892E
	for <dm-devel@redhat.com>; Mon,  1 Mar 2021 14:44:35 +0100 (CET)
X-Virus-Scanned: amavisd-new at sati.cines.fr
Received: from sati.cines.fr ([127.0.0.1])
	by localhost (sati.cines.fr [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 11hfAPEmSEui for <dm-devel@redhat.com>;
	Mon,  1 Mar 2021 14:44:35 +0100 (CET)
Received: from daksha.cines.fr (daksha.cines.fr [193.48.169.58])
	by sati.cines.fr (Postfix) with ESMTP id D5D1F262892D
	for <dm-devel@redhat.com>; Mon,  1 Mar 2021 14:44:35 +0100 (CET)
Date: Mon, 1 Mar 2021 14:44:35 +0100 (CET)
From: bchatelain@cines.fr
To: dm-devel@redhat.com
Message-ID: <388321540.261431070.1614606275832.JavaMail.zimbra@cines.fr>
MIME-Version: 1.0
X-Originating-IP: [192.168.52.3]
Thread-Index: ELpa8qlr5moYF5PeIS70mtQlJRX3vw==
Thread-Topic: multipath with SAS and FC.
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 121Drr2p007888
X-loop: dm-devel@redhat.com
Subject: [dm-devel] multipath with SAS and FC.
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGVsbG8sCgpJIHRyeSB0byB1c2UgbXVsdGlwYXRoIHdpdGggU0FTIGRpc2ssIHRyYW5zcG9ydGVk
IGJ5IEZpYmVyIENoYW5uZWwsIG9uCkRlbGwgQ29tcGVsbGVudC4KTXkgdm9sdW1lIGlzIGRldGVj
dGVkIG9uIDJ4IFI0NDAgUG93ZXJFZGdlIGhvc3RlZCBieSBDZW50b3MgOCBhbmQKb3JjaGVzdHJh
dGVkIGJ5IG9WaXJ0LgoKClByb2JsZW1hdGljIDoKCk9uIG15IHR3byBvdmlydCBub2RlIHdpdGgg
dGhlIHNhbWUgY29uZmlndXJhdGlvbiBhbmQgaGFyZHdhcmUKc3BlY2lmaWNhdGlvbnMsCkkgZ2l2
ZSB0aGlzIHNhbWUgYmVoYXZvciwgb25lIG9mIG15IHR3byBsaW5rLCBpcyBmbGFwcGluZyBBQ1RJ
VkUgdG8gRkFJTEVECgpTb21ldGhpbmcgbGlrZSB0aGlzIDoKIyBtdWx0aXBhdGggLWxsCjM2MDAw
ZDMxMDAzZDVjMjAwMDAwMDAwMDAwMDAwMDAxMCBkbS0zIENPTVBFTE5ULENvbXBlbGxlbnQgVm9s
CnNpemU9MS41VCBmZWF0dXJlcz0nMSBxdWV1ZV9pZl9ub19wYXRoJyBod2hhbmRsZXI9JzEgYWx1
YScgd3A9cncKYC0rLSBwb2xpY3k9J3NlcnZpY2UtdGltZSAwJyBwcmlvPTI1IHN0YXR1cz1hY3Rp
dmUKwqDCoCB8LSAxOjA6MDoyIHNkYiA4OjE2IGFjdGl2ZSByZWFkeSBydW5uaW5nCsKgwqAgYC0g
MTowOjE6MiBzZGMgODozMiBmYWlsZWQgcmVhZHkgcnVubmluZyDCoCAtLSBsb29waW5nIGZhaWxl
ZC9yZWFkeQoKClNvbWUgaW50ZXJlc3Rpbmcgc3R1ZmYgOgoKIyBtdWx0aXBhdGhkIHNob3cgY29u
ZmlnIDogRnVsbCBAIGh0dHBzOi8vcGFzdGViaW4uZnIvODU5NjUKCmJsYWNrbGlzdCB7CsK3wrfC
twrCoMKgIMKgIGRldmljZSB7CsKgwqAgwqAgwqAgwqAgdmVuZG9yICJDT01QRUxOVCIKwqDCoCDC
oCDCoCDCoCBwcm9kdWN0ICJDb21wZWxsZW50IFZvbCIKwqDCoCDCoCDCoCDCoCBwYXRoX2dyb3Vw
aW5nX3BvbGljeSAibXVsdGlidXMiCsKgwqAgwqAgwqAgwqAgbm9fcGF0aF9yZXRyeSAicXVldWUi
CsKgwqAgwqAgfQrCt8K3wrcKfQoKwqBMb2daIDogRnVsbCBAIGh0dHBzOi8vcGFzdGViaW4uZnIv
ODU5NjgKRmViIDI1IDExOjQ4OjI0IGlzaWxkdXItYWRtIGtlcm5lbDogZGV2aWNlLW1hcHBlcjog
bXVsdGlwYXRoOiAyNTM6MzogUmVpbnN0YXRpbmcgcGF0aCA4OjMyLgpGZWIgMjUgMTE6NDg6MjQg
aXNpbGR1ci1hZG0ga2VybmVsOiBzZCAxOjA6MToyOiBhbHVhOiBwb3J0IGdyb3VwIGYwMWMgc3Rh
dGUgUyBub24tcHJlZmVycmVkIHN1cHBvcnRzIHRvbHVTTkEKRmViIDI1IDExOjQ4OjI0IGlzaWxk
dXItYWRtIGtlcm5lbDogZGV2aWNlLW1hcHBlcjogbXVsdGlwYXRoOiAyNTM6MzogRmFpbGluZyBw
YXRoIDg6MzIuCkZlYiAyNSAxMTo0ODoyNSBpc2lsZHVyLWFkbSBtdWx0aXBhdGhkWzY1OTQ2MF06
IHNkYzogbWFyayBhcyBmYWlsZWQKCgrCoCMgbHNzY3NpIC1sClswOjI6MDowXSDCoCDCoGRpc2sg
wqAgwqBERUxMIMKgIMKgIFBFUkMgSDMzMCBBZHAgwqAgwqA0LjMwIMKgL2Rldi9zZGEKwqDCoCBz
dGF0ZT1ydW5uaW5nIHF1ZXVlX2RlcHRoPTI1NiBzY3NpX2xldmVsPTYgdHlwZT0wIGRldmljZV9i
bG9ja2VkPTAgdGltZW91dD05MApbMTowOjA6Ml0gwqAgwqBkaXNrIMKgIMKgQ09NUEVMTlQgQ29t
cGVsbGVudCBWb2wgwqAgMDcwNCDCoC9kZXYvc2RiCsKgwqAgc3RhdGU9cnVubmluZyBxdWV1ZV9k
ZXB0aD0yNTQgc2NzaV9sZXZlbD02IHR5cGU9MCBkZXZpY2VfYmxvY2tlZD0wIHRpbWVvdXQ9MzAK
WzE6MDoxOjJdIMKgIMKgZGlzayDCoCDCoENPTVBFTE5UIENvbXBlbGxlbnQgVm9sIMKgIDA3MDQg
wqAvZGV2L3NkYwrCoMKgIHN0YXRlPXJ1bm5pbmcgcXVldWVfZGVwdGg9MjU0IHNjc2lfbGV2ZWw9
NiB0eXBlPTAgZGV2aWNlX2Jsb2NrZWQ9MCB0aW1lb3V0PTMwCgoKwqAjIGxzbW9kIHwgZ3JlcCBm
YwpibngyZmMgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAxMTA1OTIgwqAwCmNuaWMgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgNjk2MzIgwqAxIGJueDJmYwpsaWJmY29lIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgNzc4MjQgwqAyIHFlZGYsYm54MmZjCmxpYmZjIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIDE0NzQ1NiDCoDMgcWVkZixibngyZmMsbGliZmNvZQpzY3NpX3RyYW5zcG9ydF9mYyDCoCDC
oCDCoDY5NjMyIMKgMyBxZWRmLGxpYmZjLGJueDJmYwoKCsKgIyBsc21vZCB8IGdyZXAgc2FzCm1w
dDNzYXMgwqAzMDMxMDQgNApyYWlkX2NsYXNzIMKgMTYzODQgMSBtcHQzc2FzCm1lZ2FyYWlkX3Nh
cyDCoDE3MjAzMiAyCnNjc2lfdHJhbnNwb3J0X3NhcyDCoDQ1MDU2IDFtcHQzc2FzCgoKCkkndmUg
bWFkZSBhIG1pc2NvbmZpZ3VyYXRpb24gPwpJcyBJdCBwb3NzaWJsZSB0byB1c2UgU0FTIG92ZXIg
RkMgPwoKVGhhbmsgeW91LgoKClJlZ2FyZHMsCkJlbm9pdCBDaGF0ZWxhaW4uCgoKLS0KZG0tZGV2
ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

