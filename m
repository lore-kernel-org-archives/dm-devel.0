Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA5DCC433EF
	for <dm-devel@archiver.kernel.org>; Sun,  5 Jun 2022 09:42:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-227-tDNF4bm9PKKH4R3j_WtQuw-1; Sun, 05 Jun 2022 05:42:23 -0400
X-MC-Unique: tDNF4bm9PKKH4R3j_WtQuw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11D5F3804501;
	Sun,  5 Jun 2022 09:42:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C4B51140EBD5;
	Sun,  5 Jun 2022 09:42:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5DCFB194706A;
	Sun,  5 Jun 2022 09:42:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EC4961947056
 for <dm-devel@listman.corp.redhat.com>; Sun,  5 Jun 2022 09:42:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BD9E8402494D; Sun,  5 Jun 2022 09:42:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B9910405D4BF
 for <dm-devel@redhat.com>; Sun,  5 Jun 2022 09:42:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A189C85A5B9
 for <dm-devel@redhat.com>; Sun,  5 Jun 2022 09:42:17 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-UE1wMclZNhCRl02ssTUNww-1; Sun, 05 Jun 2022 05:42:14 -0400
X-MC-Unique: UE1wMclZNhCRl02ssTUNww-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 2062E21AD4;
 Sun,  5 Jun 2022 09:42:13 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AEA2713A90;
 Sun,  5 Jun 2022 09:42:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id wPj5InR6nGJRdwAAMHmgww
 (envelope-from <hare@suse.de>); Sun, 05 Jun 2022 09:42:12 +0000
Message-ID: <b612013c-46e4-d1c3-81f8-b28a026240e6@suse.de>
Date: Sun, 5 Jun 2022 11:42:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
To: michael.christie@oracle.com, Keith Busch <kbusch@kernel.org>
References: <20220603065536.5641-1-michael.christie@oracle.com>
 <20220603065536.5641-10-michael.christie@oracle.com>
 <Yppkz4HIPVxr54hn@kbusch-mbp.dhcp.thefacebook.com>
 <fdd77f3b-691a-a9bf-b31f-0aa845e68e59@suse.de>
 <6cc818cf-fac4-d485-ea9d-0b8597f24a33@oracle.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <6cc818cf-fac4-d485-ea9d-0b8597f24a33@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 09/11] block,
 nvme: Add error for reservation conflicts.
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
Cc: axboe@kernel.dk, james.bottomley@hansenpartnership.com,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com, snitzer@kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org,
 hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNi80LzIyIDE5OjEzLCBtaWNoYWVsLmNocmlzdGllQG9yYWNsZS5jb20gd3JvdGU6Cj4gT24g
Ni80LzIyIDI6MzggQU0sIEhhbm5lcyBSZWluZWNrZSB3cm90ZToKPj4gT24gNi8zLzIyIDIxOjQ1
LCBLZWl0aCBCdXNjaCB3cm90ZToKPj4+IE9uIEZyaSwgSnVuIDAzLCAyMDIyIGF0IDAxOjU1OjM0
QU0gLTA1MDAsIE1pa2UgQ2hyaXN0aWUgd3JvdGU6Cj4+Pj4gQEAgLTE3MSw2ICsxNzEsNyBAQCBz
dGF0aWMgY29uc3Qgc3RydWN0IHsKPj4+PiAgwqDCoMKgwqDCoCAvKiB6b25lIGRldmljZSBzcGVj
aWZpYyBlcnJvcnMgKi8KPj4+PiAgwqDCoMKgwqDCoCBbQkxLX1NUU19aT05FX09QRU5fUkVTT1VS
Q0VdwqDCoMKgID0geyAtRVRPT01BTllSRUZTLCAib3BlbiB6b25lcyBleGNlZWRlZCIgfSwKPj4+
PiAgwqDCoMKgwqDCoCBbQkxLX1NUU19aT05FX0FDVElWRV9SRVNPVVJDRV3CoMKgwqAgPSB7IC1F
T1ZFUkZMT1csICJhY3RpdmUgem9uZXMgZXhjZWVkZWQiIH0sCj4+Pj4gK8KgwqDCoCBbQkxLX1NU
U19SU1ZfQ09ORkxJQ1RdwqDCoMKgID0geyAtRUJBREUswqDCoMKgICJyZXNldmF0aW9uIGNvbmZs
aWN0IiB9LAo+Pj4KPj4+IFlvdSBtaXNzcGVsbGVkICJyZXNlcnZhdGlvbiIuIDopCj4+Pgo+Pj4g
QW5kIHNpbmNlIHlvdSB3YW50IGEgZGlmZmVyZW50IGVycm9yLCB3aHkgcmV1c2UgRUJBREUgZm9y
IHRoZSBlcnJubz8gVGhhdCBpcwo+Pj4gYWxyZWFkeSB1c2VkIGZvciBCTEtfU1RTX05FWFVTIHRo
YXQgeW91J3JlIHRyeWluZyB0byBkaWZmZXJlbnRpYXRlIGZyb20sIHJpZ2h0Pwo+Pj4gQXQgbGVh
c3QgZm9yIG52bWUsIHRoaXMgZXJyb3IgY29kZSBpcyByZXR1cm5lZCB3aGVuIHRoZSBob3N0IGxh
Y2tzIHN1ZmZpY2llbnQKPj4+IHJpZ2h0cywgc28gc29tZXRoaW5nIGxpa2UgRUFDQ0VTUyBtaWdo
dCBtYWtlIHNlbnNlLgo+Pj4KPj4+IExvb2tzIGdvb2Qgb3RoZXJ3aXNlLgo+Pgo+PiBXZWxsbCAu
Li4gQkxLX1NUU19ORVhVUyBfaXNfIHRoZSByZXNlcnZhdGlvbiBlcnJvci4KPiAKPiBJIHdhcyBu
b3Qgc3VyZSBvZiB4ZW4vdmlydGlvIHNjc2kgdXNlcyBvZiBCTEtfU1RTX05FWFVTL0RJRF9ORVhV
U19GQUlMVVJFLgo+IFRoZSB2aXJ0aW8gc3BlYydzIGRlc2NyaXB0aW9uIGZvciBWSVJUSU9fU0NT
SV9TX05FWFVTX0ZBSUxVUkU6Cj4gCj4gICAgICBpZiB0aGUgbmV4dXMgaXMgc3VmZmVyaW5nIGEg
ZmFpbHVyZSBidXQgcmV0cnlpbmcgb24gb3RoZXIgcGF0aHMgbWlnaHQKPiAgICAgIHlpZWxkIGEg
ZGlmZmVyZW50IHJlc3VsdC4KPiAKPiBsb29rcyBsaWtlIHRoZSBkZXNjcmlwdGlvbiBmb3IgRElE
X05FWFVTX0ZBSUxVUkUgaW4gc2NzaV9zdGF0dXMuaC4KPiBUbyBtZSB0aGUgdGhlIGRlc2NyaXB0
aW9uIHNvdW5kZWQgZ2VuZXJpYyB3aGVyZSBpdCBjb3VsZCB1c2VkIGZvcgo+IG90aGVyIGVycm9y
cyBsaWtlIHRoZSBlbmRwb2ludC9wb3J0IGZvciB0aGUgSV9UIGlzIHJlbW92ZWQuCj4gCj4gSG93
ZXZlciwgdGhlIHFlbXUgY29kZSBvbmx5IHVzZXMgVklSVElPX1NDU0lfU19ORVhVU19GQUlMVVJF
IGZvcgo+IHJlc2VydmF0aW9uIGNvbmZsaWN0cy4gSWYgd2UgYXJlIHNheWluZyB0aGF0IGlzIGFs
d2F5cyB0aGUgY2FzZSBpbgo+IG90aGVyIHZpcnQgaW1wbGVtZW50YXRpb25zLCBJIGRvbid0IGV2
ZW4gbmVlZCB0aGlzIHBhdGNoIDopIGFuZCB3ZQo+IGNhbiBkbyB3aGF0IHlvdSByZXF1ZXN0ZWQg
YW5kIGRvIG1vcmUgb2YgYSByZW5hbWUuCgpXZWxsIC4uLiB3ZSB0cmllZCB0byBmaW5kIGEgZ2Vu
ZXJpYyBlcnJvciBmb3IgcmVzZXJ2YXRpb24gZmFpbHVyZSwgYXMgd2UgCnRob3VnaHQgdGhhdCBy
ZXNlcnZhdGlvbiBmYWlsdXJlIHdhcyB0b28gU0NTSSBzcGVjaWZpYy4KQW5kIHdlIHdhbnRlZCB0
aGUgZXJyb3IgdG8gZGVzY3JpYmUgd2hhdCB0aGUgcmVzdWx0aW5nIGhhbmRsaW5nIHNob3VsZCAK
YmUsIG5vdCB3aGF0IHRoZSBjYXVzZSB3YXMuIEhlbmNlIHdlIGVuZGVkIHVwIHdpdGggQkxLX1NU
U19ORVhVUy4KCkJ1dCB0dXJucyBvdXQgdGhhdCBvdXIgaW5pdGlhbCBhc3N1bXB0aW9uIHdhc24n
dCB2YWxpZCwgYW5kIHRoYXQgCnJlc2VydmF0aW9ucyBhcmUgYSBnZW5lcmFsIGNvbmNlcHQuIFNv
IGJ5IGFsbCBtZWFucywgcmVuYW1lIApCTEtfU1RTX05FWFVTIHRvIEJMS19TVFNfUlNWX0NPTkZM
SUNUIHRvIG1ha2UgaXQgY2xlYXIgd2hhdCB0aGlzIGVycm9yIAppcyBhYm91dC4KCkNoZWVycywK
Ckhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3Rv
cmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
KzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0
ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0
c2bDvGhyZXI6IEl2byBUb3RldiwgQW5kcmV3Ck15ZXJzLCBBbmRyZXcgTWNEb25hbGQsIE1hcnRq
ZSBCb3VkaWVuIE1vZXJtYW4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRo
YXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2
ZWwK

