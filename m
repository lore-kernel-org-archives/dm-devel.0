Return-Path: <SRS0=awJs=ET=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C67C388F7
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:02:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 27A9A221EB
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:02:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27A9A221EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-nL_cLZQpMHibl4wq2AuGoA-1; Fri, 13 Nov 2020 03:02:52 -0500
X-MC-Unique: nL_cLZQpMHibl4wq2AuGoA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6CF451019635;
	Fri, 13 Nov 2020 08:02:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5183D5D9F7;
	Fri, 13 Nov 2020 08:02:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2612A181A07B;
	Fri, 13 Nov 2020 08:02:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ACM2cFJ007770 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Nov 2020 17:02:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B0B08107668; Thu, 12 Nov 2020 22:02:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB2F210711D
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 22:02:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 632BF181E3E1
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 22:02:36 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-488-eiKzBwuOOFijJbQ4LRNj1g-1;
	Thu, 12 Nov 2020 17:02:34 -0500
X-MC-Unique: eiKzBwuOOFijJbQ4LRNj1g-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id D983D20C2875;
	Thu, 12 Nov 2020 14:02:31 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D983D20C2875
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
References: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
	<20201101222626.6111-5-tusharsu@linux.microsoft.com>
	<6d835878af2f11c837633510775742e57a1506eb.camel@linux.ibm.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <85f392a2-7c81-a744-0bd2-ed97fbc7f66e@linux.microsoft.com>
Date: Thu, 12 Nov 2020 14:02:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6d835878af2f11c837633510775742e57a1506eb.camel@linux.ibm.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0ACM2cFJ007770
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 13 Nov 2020 03:02:15 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v5 4/7] IMA: add policy to measure critical
	data
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAyMDIwLTExLTA2IDU6NDMgYS5tLiwgTWltaSBab2hhciB3cm90ZToKPiBIaSBUdXNoYXIs
Cj4gCj4gT24gU3VuLCAyMDIwLTExLTAxIGF0IDE0OjI2IC0wODAwLCBUdXNoYXIgU3VnYW5kaGkg
d3JvdGU6Cj4+IFN5c3RlbSBhZG1pbmlzdHJhdG9ycyBzaG91bGQgYmUgYWJsZSB0byBjaG9vc2Ug
d2hpY2gga2VybmVsIHN1YnN5c3RlbXMKPj4gdGhleSB3YW50IHRvIG1lYXN1cmUgdGhlIGNyaXRp
Y2FsIGRhdGEgZm9yLiBUbyBlbmFibGUgdGhhdCwgYW4gSU1BIHBvbGljeQo+PiBvcHRpb24gdG8g
Y2hvb3NlIHNwZWNpZmljIGtlcm5lbCBzdWJzeXN0ZW1zIGlzIG5lZWRlZC4gVGhpcyBwb2xpY3kg
b3B0aW9uCj4+IHdvdWxkIGNvbnN0cmFpbiB0aGUgbWVhc3VyZW1lbnQgb2YgdGhlIGNyaXRpY2Fs
IGRhdGEgdG8gdGhlIGdpdmVuIGtlcm5lbAo+PiBzdWJzeXN0ZW1zLgo+IAo+IE1lYXN1cmluZyBj
cml0aWNhbCBkYXRhIHNob3VsZCBub3QgYmUgZGVwZW5kZW50IG9uIHRoZSBzb3VyY2Ugb2YgdGhl
Cj4gY3JpdGljYWwgZGF0YS4gICBUaGlzIHBhdGNoIG5lZWRzIHRvIGJlIHNwbGl0IHVwLiAgVGhl
ICJkYXRhIHNvdXJjZXMiCj4gc2hvdWxkIGJlIG1vdmUgdG8gaXQncyBvd24gc2VwYXJhdGUgcGF0
Y2guICBUaGlzIHBhdGNoIHNob3VsZCBiZQo+IGxpbWl0ZWQgdG8gYWRkaW5nIHRoZSBwb2xpY3kg
Y29kZSBuZWVkZWQgZm9yIG1lYXN1cmluZyBjcml0aWNpYWwgZGF0YS4KPiBMaW1pdGluZyBjcml0
aWNhbCBkYXRhIHNvdXJjZXMgc2hvdWxkIGJlIHRoZSBsYXN0IHBhdGNoIGluIHRoaXMgc2VyaWVz
Lgo+IAo+IHRoYW5rcywKPiAKPiBNaW1pCj4gClRoYW5rcyBNaW1pLgoKT2suIEkgd2lsbCBzcGxp
dCB0aGUgcGF0Y2hlcyBhcyB5b3Ugc3VnZ2VzdGVkLgpQYXRjaCAjMSAodGhpcyBwYXRjaCkgd2ls
bCBoYXZlIHRoZSBwb2xpY3kgY29kZSBuZWVkZWQgZm9yIG1lYXN1cmluZwpjcml0aWNhbCBkYXRh
LgpwYXRjaCAjMiBMaW1pdGluZyB0aGUgY3JpdGljYWwg4oCcZGF0YV9zb3VyY2Vz4oCdLgoKKlF1
ZXN0aW9uIDEqClNpbmNlIHlvdSBzYWlkIHBhdGNoICMyIHNob3VsZCBiZSB0aGUgbGFzdCBwYXRj
aCBpbiB0aGlzIHNlcmllcywgZG8geW91IAptZWFuIG1lcmdpbmcgcGF0Y2ggIzIgd2l0aCB0aGUg
U2VMaW51eCBwYXRjaD8gKHBhdGNoIDcvNyBvZiB0aGlzIHNlcmllcykKT3IgYSBzZXBhcmF0ZSBw
YXRjaCBiZWZvcmUgNy83PwoKKlF1ZXN0aW9uIDIqCklmIEkgdW5kZXJzdGFuZCBpdCBjb3JyZWN0
bHksIHRoZSBmb2xsb3dpbmcgY29kZSBzaG91bGQgYmUgbW92ZWQgZnJvbSAKdGhpcyBwYXRjaCB0
byBwYXRjaCAjMi4gRGlkIEkgbWlzcyBhbnl0aGluZz8KCiAgc3RhdGljIGNvbnN0IG1hdGNoX3Rh
YmxlX3QgcG9saWN5X3Rva2VucyA9IHsKQEAgLTk1Nyw2ICs5NzEsNyBAQCBzdGF0aWMgY29uc3Qg
bWF0Y2hfdGFibGVfdCBwb2xpY3lfdG9rZW5zID0gewogIAl7T3B0X3BjciwgInBjcj0lcyJ9LAog
IAl7T3B0X3RlbXBsYXRlLCAidGVtcGxhdGU9JXMifSwKICAJe09wdF9rZXlyaW5ncywgImtleXJp
bmdzPSVzIn0sCisJe09wdF9kYXRhX3NvdXJjZXMsICJkYXRhX3NvdXJjZXM9JXMifSwKICAJe09w
dF9lcnIsIE5VTEx9CiAgfTsKCgorCQljYXNlIE9wdF9kYXRhX3NvdXJjZXM6CisJCQlpbWFfbG9n
X3N0cmluZyhhYiwgImRhdGFfc291cmNlcyIsCisJCQkJICAgICAgIGFyZ3NbMF0uZnJvbSk7CisK
KwkJCWlmIChlbnRyeS0+ZGF0YV9zb3VyY2VzKSB7CisJCQkJcmVzdWx0ID0gLUVJTlZBTDsKKwkJ
CQlicmVhazsKKwkJCX0KKworCQkJZW50cnktPmRhdGFfc291cmNlcyA9IGltYV9hbGxvY19ydWxl
X29wdF9saXN0KGFyZ3MpOworCQkJaWYgKElTX0VSUihlbnRyeS0+ZGF0YV9zb3VyY2VzKSkgewor
CQkJCXJlc3VsdCA9IFBUUl9FUlIoZW50cnktPmRhdGFfc291cmNlcyk7CisJCQkJZW50cnktPmRh
dGFfc291cmNlcyA9IE5VTEw7CisJCQkJYnJlYWs7CisJCQl9CisKKwkJCWVudHJ5LT5mbGFncyB8
PSBJTUFfREFUQV9TT1VSQ0VTOworCQkJYnJlYWs7CgorCWlmIChlbnRyeS0+ZmxhZ3MgJiBJTUFf
REFUQV9TT1VSQ0VTKSB7CisJCXNlcV9wdXRzKG0sICJkYXRhX3NvdXJjZXM9Iik7CisJCWltYV9z
aG93X3J1bGVfb3B0X2xpc3QobSwgZW50cnktPmRhdGFfc291cmNlcyk7CisJCXNlcV9wdXRzKG0s
ICIgIik7CisJfQorCgp+VHVzaGFyCgo+Pgo+PiBBZGQgYSBuZXcgSU1BIHBvbGljeSBvcHRpb24g
LSAiZGF0YV9zb3VyY2VzOj0iIHRvIHRoZSBJTUEgZnVuYwo+PiBDUklUSUNBTF9EQVRBIHRvIGFs
bG93IG1lYXN1cmVtZW50IG9mIHZhcmlvdXMga2VybmVsIHN1YnN5c3RlbXMuIFRoaXMKPj4gcG9s
aWN5IG9wdGlvbiB3b3VsZCBlbmFibGUgdGhlIHN5c3RlbSBhZG1pbmlzdHJhdG9ycyB0byBsaW1p
dCB0aGUKPj4gbWVhc3VyZW1lbnQgdG8gdGhlIHN1YnN5c3RlbXMgbGlzdGVkIGluICJkYXRhX3Nv
dXJjZXM6PSIsIGlmIHRoZQo+PiBzdWJzeXN0ZW0gbWVhc3VyZXMgaXRzIGRhdGEgYnkgY2FsbGlu
ZyBpbWFfbWVhc3VyZV9jcml0aWNhbF9kYXRhKCkuCj4+Cj4+IExpbWl0IHRoZSBtZWFzdXJlbWVu
dCB0byB0aGUgc3Vic3lzdGVtcyB0aGF0IGFyZSBzcGVjaWZpZWQgaW4gdGhlIElNQQo+PiBwb2xp
Y3kgLSBDUklUSUNBTF9EQVRBKyJkYXRhX3NvdXJjZXM6PSIuIElmICJkYXRhX3NvdXJjZXM6PSIg
aXMgbm90Cj4+IHByb3ZpZGVkIHdpdGggdGhlIGZ1bmMgQ1JJVElDQUxfREFUQSwgbWVhc3VyZSB0
aGUgZGF0YSBmcm9tIGFsbCB0aGUKPj4gc3VwcG9ydGVkIGtlcm5lbCBzdWJzeXN0ZW1zLgo+Pgo+
PiBTaWduZWQtb2ZmLWJ5OiBUdXNoYXIgU3VnYW5kaGkgPHR1c2hhcnN1QGxpbnV4Lm1pY3Jvc29m
dC5jb20+CgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0
cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

