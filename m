Return-Path: <SRS0=UIu2=FN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A294C433FE
	for <dm-devel@archiver.kernel.org>; Wed,  9 Dec 2020 09:58:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3444023433
	for <dm-devel@archiver.kernel.org>; Wed,  9 Dec 2020 09:58:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3444023433
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=interlog.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-M6eNTCneNqyh8IKEs57cQg-1; Wed, 09 Dec 2020 04:57:58 -0500
X-MC-Unique: M6eNTCneNqyh8IKEs57cQg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2853B80ED9E;
	Wed,  9 Dec 2020 09:57:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BBDC13470;
	Wed,  9 Dec 2020 09:57:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D4DAD5002F;
	Wed,  9 Dec 2020 09:57:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B7MLcKO031061 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Dec 2020 17:21:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 56A28112D421; Mon,  7 Dec 2020 22:21:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 52EF0112D427
	for <dm-devel@redhat.com>; Mon,  7 Dec 2020 22:21:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D2C0100B16A
	for <dm-devel@redhat.com>; Mon,  7 Dec 2020 22:21:36 +0000 (UTC)
Received: from mail-1.ca.inter.net (mail-1.ca.inter.net [208.85.220.69])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-534-sX4t7eeKO2CraZzC2irWew-1; Mon, 07 Dec 2020 17:21:32 -0500
X-MC-Unique: sX4t7eeKO2CraZzC2irWew-1
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
	by mail-1.ca.inter.net (Postfix) with ESMTP id 57DD82EA0BF;
	Mon,  7 Dec 2020 17:12:22 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
	by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new,
	port 10024)
	with ESMTP id G7eYR5PKV6Ue; Mon,  7 Dec 2020 17:01:35 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca
	[104.157.204.209])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: dgilbert@interlog.com)
	by mail-1.ca.inter.net (Postfix) with ESMTPSA id 2ED332EA040;
	Mon,  7 Dec 2020 17:12:20 -0500 (EST)
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
	SelvaKumar S <selvakuma.s1@samsung.com>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
	<20201204094659.12732-1-selvakuma.s1@samsung.com>
	<20201207141123.GC31159@lst.de>
	<01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
From: Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <194d7813-8c8c-85c8-e0c8-94aaab7c291e@interlog.com>
Date: Mon, 7 Dec 2020 17:12:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B7MLcKO031061
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 09 Dec 2020 04:56:16 -0500
Cc: axboe@kernel.dk, damien.lemoal@wdc.com, sagi@grimberg.me,
	snitzer@redhat.com, selvajove@gmail.com,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>, joshi.k@samsung.com,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	kbusch@kernel.org, javier.gonz@samsung.com,
	linux-scsi@vger.kernel.org, nj.shetty@samsung.com,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [dm-devel] [RFC PATCH v2 0/2] add simple copy support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
Reply-To: dgilbert@interlog.com
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-CA
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMjAyMC0xMi0wNyA5OjU2IGEubS4sIEhhbm5lcyBSZWluZWNrZSB3cm90ZToKPiBPbiAxMi83
LzIwIDM6MTEgUE0sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOgo+PiBTbywgSSdtIHJlYWxseSB3
b3JyaWVkIGFib3V0Ogo+Pgo+PiDCoCBhKSBhIGdvb2QgdXNlIGNhc2UuwqAgR0MgaW4gZjJmcyBv
ciBidHJmcyBzZWVtIGxpa2UgZ29vZCB1c2UgY2FzZXMsIGFzCj4+IMKgwqDCoMKgIGRvZXMgYWNj
ZWxhdGluZyBkbS1rY29weWQuwqAgSSBhZ3JlZSB3aXRoIERhbWllbiB0aGF0IGxpZnRpbmcgZG0t
a2NvcHlkCj4+IMKgwqDCoMKgIHRvIGNvbW1vbiBjb2RlIHdvdWxkIGFsc28gYmUgcmVhbGx5IG5p
Y2UuwqAgSSdtIG5vdCAxMDAlIHN1cmUgaXQgc2hvdWxkCj4+IMKgwqDCoMKgIGJlIGEgcmVxdWly
ZW1lbnQsIGJ1dCBpdCBzdXJlIHdvdWxkIGJlIG5pY2UgdG8gaGF2ZQo+PiDCoMKgwqDCoCBJIGRv
bid0IHRoaW5rIGp1c3QgYWRkaW5nIGFuIGlvY3RsIGlzIGVub3VnaCBvZiBhIHVzZSBjYXNlIGZv
ciBjb21wbGV4Cj4+IMKgwqDCoMKgIGtlcm5lbCBpbmZyYXN0cnVjdHVyZS4KPj4gwqAgYikgV2Ug
aGFkIGEgYnVuY2ggb2YgZGlmZmVyZW50IGF0dGVtcHRzIGF0IFNDU0kgWENPUFkgc3VwcG9ydCBm
b3JtIElJUkMKPj4gwqDCoMKgwqAgTWFydGluLCBCYXJ0IGFuZCBNaWt1bGFzLsKgIEkgdGhpbmsg
d2UgbmVlZCB0byBwdWxsIHRoZW0gaW50byB0aGlzCj4+IMKgwqDCoMKgIGRpc2N1c3Npb24sIGFu
ZCBtYWtlIHN1cmUgd2hhdGV2ZXIgd2UgZG8gY292ZXJzIHRoZSBTQ1NJIG5lZWRzLgo+Pgo+IEFu
ZCB3ZSBzaG91bGRuJ3QgZm9yZ2V0IHRoYXQgdGhlIG1haW4gaXNzdWUgd2hpY2gga2lsbGVkIGFs
bCBwcmV2aW91cyAKPiBpbXBsZW1lbnRhdGlvbnMgd2FzIGEgbWlzc2luZyBRb1MgZ3VhcmFudGVl
Lgo+IEl0J3MgbmljZSB0byBoYXZlIHNpbXBseSBjb3B5LCBidXQgaWYgdGhlIGltcGxlbWVudGF0
aW9uIGlzIF9zbG93ZXJfIHRoYW4gZG9pbmcgCj4gaXQgYnkgaGFuZCBmcm9tIHRoZSBPUyB0aGVy
ZSBpcyB2ZXJ5IGxpdHRsZSBwb2ludCBpbiBldmVuIGF0dGVtcHRpbmcgdG8gZG8gc28uCj4gSSBj
YW4ndCBzZWUgYW55IHByb3Zpc2lvbnMgZm9yIHRoYXQgaW4gdGhlIFRQQVIsIGxlYWRpbmcgbWUg
dG8gdGhlIGFzc3VtcHRpb24gCj4gdGhhdCBOVk1lIHNpbXBsZSBjb3B5IHdpbGwgc3VmZmVyIGZy
b20gdGhlIHNhbWUgaXNzdWUuCj4gCj4gU28gaWYgd2UgY2FuJ3QgYWRkcmVzcyB0aGlzIEkgZ3Vl
c3MgdGhpcyBhdHRlbXB0IHdpbGwgZmFpbCwgdG9vLgoKSSBoYXZlIGJlZW4gZG9pbmcgcXVpdGUg
YSBsb3Qgb2Ygd29yayBhbmQgdGVzdGluZyBpbiBteSBzZyBkcml2ZXIgcmV3cml0ZQppbiB0aGUg
Y29weSBhbmQgY29tcGFyZSBhcmVhLiBUaGUgYmFzZWxpbmVzIGZvciBwZXJmb3JtYW5jZSBhcmUg
ZGQgYW5kCmlvX3VyaW5nLWNwIChpbiBsaWJ1cmluZykuIFRoZXJlIGFyZSBsb3RzIG9mIHdheXMg
dG8gaW1wcm92ZSBvbiB0aGVtLiBIZXJlCmFyZSBzb21lOgogICAgLSB0aGUgdXNlciBkYXRhIG5l
ZWQgbmV2ZXIgcGFzcyB0aHJvdWdoIHRoZSB1c2VyIHNwYWNlIChjb3VsZAogICAgICBtbWFwIGl0
IG91dCBkdXJpbmcgdGhlIFJFQUQgaWYgdGhlcmUgaXMgYSBnb29kIHJlYXNvbikuIE9ubHkgdGhl
CiAgICAgIG1ldGFkYXRhIChlLmcuIE5WTWUgb3IgU0NTSSBjb21tYW5kcykgbmVlZHMgdG8gY29t
ZSBmcm9tIHRoZSB1c2VyCiAgICAgIHNwYWNlIGFuZCBlcnJvcnMsIGlmIGFueSwgcmVwb3J0ZWQg
YmFjayB0byB0aGUgdXNlciBzcGFjZS4KICAgIC0gYnJlYWsgYSBsYXJnZSBjb3B5IChvciBjb21w
YXJlKSBpbnRvIHNlZ21lbnRzLCB3aXRoIGVhY2ggc2VnbWVudAogICAgICBhICJjb21mb3J0YWJs
ZSIgc2l6ZSBmb3IgdGhlIE9TIHRvIGhhbmRsZSwgc2F5IDI1NiBLQgogICAgLSB0aGVyZSBpcyBv
bmUgY29uc3RyYWludDogdGhlIFJFQUQgaW4gZWFjaCBzZWdtZW50IG11c3QgY29tcGxldGUKICAg
ICAgYmVmb3JlIGl0cyBwYWlyZWQgV1JJVEUgY2FuIGNvbW1lbmNlCiAgICAgIC0gZXh0cmEgY29u
c3RyYWludCBmb3Igc29tZSB6b25lZCBkaXNrczogV1JJVEVzIG11c3QgYmUKICAgICAgICBpc3N1
ZWQgaW4gb3JkZXIgKGFzc3VtaW5nIHRoZXkgYXJlIGFwcGxpZWQgaW4gdGhhdCBvcmRlciwgaWYK
ICAgICAgICBub3QsIG5lZWQgdG8gd2FpdCB1bnRpbCBlYWNoIFdSSVRFIGNvbXBsZXRlcykKICAg
IC0gYXJyYW5nZSBmb3IgUkVBRCBXUklURSBwYWlyIGluIGVhY2ggc2VnbWVudCB0byBzaGFyZSB0
aGUgc2FtZSBiaW8KICAgIC0gaGF2ZSBtdWx0aXBsZSBzbG90cyBlYWNoIGhvbGRpbmcgYSBzZWdt
ZW50IChpLmUuIGEgYmlvIGFuZAogICAgICBtZXRhZGF0YSB0byBwcm9jZXNzIGEgUkVBRC1XUklU
RSBwYWlyKQogICAgLSByZS11c2UgZWFjaCBzbG90J3MgYmlvIGZvciB0aGUgZm9sbG93aW5nIFJF
QUQtV1JJVEUgcGFpcgogICAgLSBpc3N1ZSB0aGUgUkVBRHMgaW4gZWFjaCBzbG90IGFzeW5jaHJv
bm91c2x5IGFuZCBkbyBhbiBpbnRlcmxlYXZlZAogICAgICAoaW8pcG9sbCBmb3IgY29tcGxldGlv
bi4gVGhlbiBpc3N1ZSB0aGUgcGFpcmVkIFdSSVRFCiAgICAgIGFzeW5jaHJvbm91c2x5CiAgICAt
IHRoZSBhYm92ZSAic2xvdCIgYWxnb3JpdGhtIHJ1bnMgaW4gb25lIHRocmVhZCwgc28gdGhlcmUg
Y2FuIGJlCiAgICAgIG11bHRpcGxlIHRocmVhZHMgZG9pbmcgdGhlIHNhbWUgYWxnb3JpdGhtLiBT
ZWdtZW50IG1hbmFnZXIgbmVlZHMKICAgICAgdG8gYmUgbG9ja2VkIChvciB1c2UgYW4gYXRvbWlj
cykgc28gdGhhdCBlYWNoIHNlZ21lbnQgKGlkZW50aWZpZWQKICAgICAgYnkgaXRzIHN0YXJ0aW5n
IExCQXMpIGlzIGlzc3VlZCBvbmNlIGFuZCBvbmx5IG9uY2Ugd2hlbiB0aGUKICAgICAgbmV4dCB0
aHJlYWQgd2FudHMgYSBzZWdtZW50IHRvIGNvcHkKClJ1bm5pbmcgbXVsdGlwbGUgdGhyZWFkcyBn
aXZlcyBkaW1pbmlzaGluZyBvciBldmVuIHdvcnNlbmluZyByZXR1cm5zLgpSdW50aW1lIG1ldHJp
Y3Mgb24gbG9jayBjb250ZW50aW9uIGFuZCBzdG9yYWdlIGJ1cyBjYXBhY2l0eSBtYXkgaGVscApj
aG9vc2luZyB0aGUgbnVtYmVyIG9mIHRocmVhZHMuIEEgc2ltcGxlciBhcHByb2FjaCBtaWdodCBi
ZSBhZGQgbW9yZQp0aHJlYWRzIHVudGlsIHRoZSBjb21iaW5lZCB0aHJvdWdocHV0IGluY3JlYXNl
IGlzIGxlc3MgdGhhbiAxMCUgc2F5LgoKClRoZSAnY29tcGFyZScgdGhhdCBJIG1lbnRpb24gaXMg
YmFzZWQgb24gdGhlIFNDU0kgVkVSSUZZKEJZVENISz0xKSBjb21tYW5kCihvciBOVk1lIE5WTSBD
b21wYXJlIGNvbW1hbmQpLiBVc2luZyBkZCBsb2dpYywgYSBkaXNrIHRvIGRpc2sgY29tcGFyZSBj
YW4KYmUgaW1wbGVtZW50ZWQgd2l0aCBub3QgbXVjaCBtb3JlIHdvcmsgdGhhbiBjaGFuZ2luZyB0
aGUgV1JJVEUgdG8gYSBWRVJJRlkKY29tbWFuZC4gVGhpcyBpcyBhIGRpZmZlcmVudCBhcHByb2Fj
aCB0byB0aGUgTGludXggY21wIHV0aWxpdHkgd2hpY2gKUkVBRHMgaW4gYm90aCBzaWRlcyBhbmQg
ZG9lcyBhIG1lbWNtcCgpIHR5cGUgb3BlcmF0aW9uLiBVc2luZyByYW1kaXNrcwooZnJvbSB0aGUg
c2NzaV9kZWJ1ZyBkcml2ZXIpIHRoZSBjb21wYXJlIG9wZXJhdGlvbiAobWF4IH4gMTAgR0Ivcykg
d2FzCmFjdHVhbGx5IGZhc3RlciB0aGFuIHRoZSBjb3B5IChtYXggfiA3IEdCL3MpLiBJIHB1dCB0
aGlzIGRvd24gdG8gV1JJVEUKb3BlcmF0aW9ucyB0YWtpbmcgYSB3cml0ZSBsb2NrIG92ZXIgdGhl
IHN0b3JlIHdoaWxlIHRoZSBWRVJJRlkgb25seQpuZWVkcyBhIHJlYWQgbG9jayBzbyBtYW55IFZF
UklGWSBvcGVyYXRpb25zIGNhbiBjby1leGlzdCBvbiB0aGUgc2FtZQpzdG9yZS4gVW5mb3J0dW5h
dGVseSBvbiByZWFsIFNBUyBhbmQgTlZNZSBTU0RzIHRoYXQgSSB0ZXN0ZWQgdGhlCnBlcmZvcm1h
bmNlIG9mIHRoZSBWRVJJRlkgYW5kIE5WTSBDb21wYXJlIGNvbW1hbmRzIGlzIHVuZGVyd2hlbG1p
bmcuCkZvciBjb21wYXJpc29uLCB1c2luZyBzY3NpX2RlYnVnIHJhbWRpc2tzLCBkZCBjb3B5IHRo
cm91Z2hwdXQgd2FzCjwgMSBHQi9zIGFuZCBpb191cmluZy1jcCB3YXMgYXJvdW5kIDItMyBHQi9z
LiBUaGUgc3lzdGVtIHdhcyBSeXplbgozNjAwIGJhc2VkLgoKRG91ZyBHaWxiZXJ0CgoKLS0KZG0t
ZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

