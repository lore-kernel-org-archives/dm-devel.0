Return-Path: <SRS0=hAiq=MV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F70C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 19:24:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5039B60462
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 19:24:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5039B60462
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-EP4F81MkO5WvA9BddPepZA-1; Thu, 29 Jul 2021 15:24:41 -0400
X-MC-Unique: EP4F81MkO5WvA9BddPepZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7E8B801E72;
	Thu, 29 Jul 2021 19:24:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 723A460C13;
	Thu, 29 Jul 2021 19:24:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C8E421800B9C;
	Thu, 29 Jul 2021 19:24:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16TJOVC4030246 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Jul 2021 15:24:32 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D215D20A8DC5; Thu, 29 Jul 2021 19:24:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CB8E820C15BD
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 19:24:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7B2118A0165
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 19:24:24 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-233-CeWUy4UJMjacq8nd71fQMg-1;
	Thu, 29 Jul 2021 15:24:20 -0400
X-MC-Unique: CeWUy4UJMjacq8nd71fQMg-1
Received: from [192.168.86.34] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 191172048040;
	Thu, 29 Jul 2021 12:24:19 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 191172048040
To: Thore Sommer <public@thson.de>
References: <c833339e-c4bf-6e78-5719-cd902fa8426f@linux.microsoft.com>
	<20210727101802.779067-1-public@thson.de>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <f73308f3-485f-46cb-0f20-6619edb541e6@linux.microsoft.com>
Date: Thu, 29 Jul 2021 12:24:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210727101802.779067-1-public@thson.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 16TJOVC4030246
X-loop: dm-devel@redhat.com
Cc: snitzer@redhat.com, zohar@linux.ibm.com, nramas@linux.microsoft.com,
	dm-devel@redhat.com, linux-integrity@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH 0/7] device mapper target measurements using
 IMA
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGkgVGhvcmUsClJlcGx5aW5nIHRvIGEgZmV3IHF1ZXN0aW9ucyB3aGljaCB3ZXJlIG5vdCBhbHJl
YWR5IGFuc3dlcmVkIGJ5IG1lL0FsYXNkYWlyLgoKCk9uIDcvMjcvMjEgMzoxOCBBTSwgVGhvcmUg
U29tbWVyIHdyb3RlOgoKPiBUaGVyZSBpcyBubyB3YXkgdG8gdmVyaWZ5IGlmIHRoZSByb290IGhh
c2ggd2FzIHZlcmlmaWVkIGFnYWluc3QgYSBzaWduYXR1cmUuIFdlCj4gaGF2ZSAicm9vdF9oYXNo
X3NpZ19rZXlfZGVzYyBTSUdOQVRVUkVfREVTQ1JJUFRJT04iIGluIHRoZSBkbSB0YWJsZS4KPiAi
U0lHTkFUVVJFX0RFU0NSSVBUSU9OIiBpdHNlbGYgaXMgbm90IHJlYWxseSB1c2VmdWwgYmVjYXVz
ZSBpdCBzZWVtcyB0aGF0IHdlCj4gY2Fubm90IG1hcCBpdCBiYWNrIHRvIHRoZSBjZXJ0aWZpY2F0
ZSB0aGF0IHdhcyB1c2VkIGZvciB2ZXJpZmljYXRpb24gYnV0IHRoZQo+IHByZXNlbmNlIG9mICJy
b290X2hhc2hfc2lnX2tleV9kZXNjIiBtaWdodCBiZSBlbm91Z2ggaW4gY29tYmluYXRpb24gd2l0
aAo+IG1lYXN1cmluZyB0aGUga2V5cmluZy4KClRoYW5rcyBmb3IgdGhlIHN1Z2dlc3Rpb24gVGhv
cmUuCkkgY2FuIHVwZGF0ZSB0aGUgdmVyaXR5X3N0YXR1cygpIHRvIG1lYXN1cmUgaWYgdi0+c2ln
bmF0dXJlX2tleV9kZXNjIGlzIApzZXQuCgpTb21ldGhpbmcgbGlrZToKRE1FTUlUKCJzaWduYXR1
cmVfa2V5X2Rlc2NfcHJlc2VudD0lYywiLCB2LT5zaWduYXR1cmVfa2V5X2Rlc2MgPyAneScgOgon
bicpOwoKQWxhc2RhaXIsIE1pa2UsCkNhbiB5b3UgdGVsbCBpZiB0aGlzIGlzIG5lZWRlZCBhbmQv
b3Igc3VmZmljaWVudD8KSWYgaXQgaXMgbmVlZGVkLCBzaG91bGQgd2UgbG9nIHRoZSBmdWxsIHN0
cmluZyAgdi0+c2lnbmF0dXJlX2tleV9kZXNjPwpJIGFtIGNvbmNlcm5lZCBhYm91dCBsb2dnaW5n
IHRoZSBmdWxsIHN0cmluZyBhcyBpdCBpcyBhbiB1bmJvdW5kZWQKYnVmZmVyIChhIGNoYXIqKSBj
b21pbmcgZnJvbSBVTS4gQW5kIGF0IHRoZSBzYW1lIHRpbWUsIG5vdCBzdXJlIGlmIGp1c3QKbG9n
Z2luZyB0aGUgcHJlc2VuY2UgaXMgc3VmZmljaWVudC4gVGhvdWdodHM/CgpUaG9yZSwKUGxlYXNl
IG5vdGUg4oCTIGV2ZW4gaWYgd2UgbWVhc3VyZSBzaWduYXR1cmVfa2V5X2Rlc2MgKGZ1bGwgc3Ry
aW5nIG9yIGp1c3QKaXRzIHByZXNlbmNlKTogaW4gb3JkZXIgdG8gdXNlIGl0IHdpdGggdGhlIGtl
eXJpbmdzLCB0aGUgSU1BIHBvbGljeSBhbHNvCm5lZWRzIHRvIGJlIHNldCB0byBtZWFzdXJlIGtl
eSByaW5ncyAodXNpbmcg4oCcbWVhc3VyZSBmdW5jPUtFWV9DSEVDSwouLi7igJ0pLiBJdCBpcyBp
bmRlcGVuZGVudCBmcm9tIG1lYXN1cmluZyB0aGUgZGV2aWNlIG1hcHBlciBkYXRhICh3aGljaCBp
cwptZWFzdXJlZCB3aGVuIHRoZSBwb2xpY3kgaXMgc2V0IHRvIOKAnG1lYXN1cmUgZnVuYz1DUklU
SUNBTF9EQVRBCmxhYmVsPWRldmljZS1tYXBwZXIgLi4u4oCdKS4KClRoZXJlZm9yZSBtZWFzdXJp
bmcga2V5cmluZ3MgdG9nZXRoZXIgKGkuZS4gaW4gdGhlIHNhbWUgSU1BIGxvZykgd2l0aCBETQpk
YXRhICBpcyBub3QgYWx3YXlzIGd1YXJhbnRlZWQsIHNpbmNlIGl0IGlzIGRpY3RhdGVkIGJ5IGhv
dyB0aGUgSU1BCnBvbGljeSBpcyBjb25maWd1cmVkLgoKSnVzdCBGWUkuCgo+IEZvciByZW1vdGUg
YXR0ZXN0YXRpb24gc2VydmljZXMgaXQgd291bGQgYmUgbmljZSBpZiB3ZSBoYXZlIGNsZWFyIGlu
ZGljYXRvciBmcm9tCj4gd2hhdCBjb21wb25lbnQgdGhlICJpbWEtYnVmIiBlbnRyeSB3YXMgZ2Vu
ZXJhdGVkLiBQcmVmaXhpbmcgYWxsICJuLW5nIiBmaWVsZAo+IGVudHJpZXMgd2l0aCBzb21ldGhp
bmcgbGlrZSAiZG1fIiB3b3VsZCBtYWtlIGl0IGVhc2llciBmb3IgdXMgdG8gYWRkIGRpZmZlcmVu
dAo+IHZhbGlkYXRvcnMgZm9yIGRpZmZlcmVudCBtZWFzdXJlbWVudHMgdGhhdCB1c2UgdGhlICJp
bWEtYnVmIiB0ZW1wbGF0ZS4gVGhlCj4ga2V5cmluZyBtZWFzdXJlbWVudHMgYWxyZWFkeSB1c2Ug
ImltYS1idWYiIGFuZCB1c2luZyBzb21lIGtpbmQgb2YgbmFtaW5nIHNjaGVtZQo+IHRvIGVhc2ls
eSBkaWZmZXJlbnRpYXRlIHRoZSBlbnRyaWVzIHdvdWxkIGJlIG5pY2UuClRoZSBldmVudCBuYW1l
cyB0eXBpY2FsbHkgY29tZSBmcm9tIGtlcm5lbCBjb21wb25lbnRzIHRoYXQgYXJlIGRvaW5nIHRo
ZQptZWFzdXJlbWVudCBvZiBjcml0aWNhbCBkYXRhLiBTbyBhbnkgZHVwbGljYXRlcyBzaG91bGQg
YmUgY2F1Z2h0IGluIHRoZQp1cHN0cmVhbSByZXZpZXcgb2YgdGhlIGtlcm5lbCBwYXRjaC4KCkJ1
dCB0aGFua3MgZm9yIHRoZSBzdWdnZXN0aW9uLiBJIHdpbGwgcHJlZml4IHRoZSBldmVudCBuYW1l
cyBpbiB0aGlzIApwYXRjaCBzZXJpZXMgd2l0aCDigJxkbV/igJ0gdG8gaW5kaWNhdGUgdGhleSBh
cmUgcmVsYXRlZCB0byBkZXZpY2UgbWFwcGVyLgoKVGhhbmtzLApUdXNoYXIKPiBSZWdhcmRzLAo+
IFRob3JlCj4gCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20K
aHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

