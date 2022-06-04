Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B545DC43334
	for <dm-devel@archiver.kernel.org>; Sat,  4 Jun 2022 07:38:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-rDaGVRFZOx-wUyY5mzS8uA-1; Sat, 04 Jun 2022 03:38:20 -0400
X-MC-Unique: rDaGVRFZOx-wUyY5mzS8uA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7476785A5B9;
	Sat,  4 Jun 2022 07:38:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 043342166B29;
	Sat,  4 Jun 2022 07:38:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C3B601947052;
	Sat,  4 Jun 2022 07:38:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 95628194704D
 for <dm-devel@listman.corp.redhat.com>; Sat,  4 Jun 2022 07:38:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 64861C28103; Sat,  4 Jun 2022 07:38:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FE0AC28101
 for <dm-devel@redhat.com>; Sat,  4 Jun 2022 07:38:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4809D185A79C
 for <dm-devel@redhat.com>; Sat,  4 Jun 2022 07:38:10 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-cG5PkZ_yMpqra2F_9nNTXQ-1; Sat, 04 Jun 2022 03:38:08 -0400
X-MC-Unique: cG5PkZ_yMpqra2F_9nNTXQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id DD23B1F8DE;
 Sat,  4 Jun 2022 07:38:06 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 965CA13A5F;
 Sat,  4 Jun 2022 07:38:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id I6rzIt4Lm2KfSwAAMHmgww
 (envelope-from <hare@suse.de>); Sat, 04 Jun 2022 07:38:06 +0000
Message-ID: <fdd77f3b-691a-a9bf-b31f-0aa845e68e59@suse.de>
Date: Sat, 4 Jun 2022 09:38:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
To: Keith Busch <kbusch@kernel.org>,
 Mike Christie <michael.christie@oracle.com>
References: <20220603065536.5641-1-michael.christie@oracle.com>
 <20220603065536.5641-10-michael.christie@oracle.com>
 <Yppkz4HIPVxr54hn@kbusch-mbp.dhcp.thefacebook.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <Yppkz4HIPVxr54hn@kbusch-mbp.dhcp.thefacebook.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNi8zLzIyIDIxOjQ1LCBLZWl0aCBCdXNjaCB3cm90ZToKPiBPbiBGcmksIEp1biAwMywgMjAy
MiBhdCAwMTo1NTozNEFNIC0wNTAwLCBNaWtlIENocmlzdGllIHdyb3RlOgo+PiBAQCAtMTcxLDYg
KzE3MSw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgewo+PiAgIAkvKiB6b25lIGRldmljZSBzcGVj
aWZpYyBlcnJvcnMgKi8KPj4gICAJW0JMS19TVFNfWk9ORV9PUEVOX1JFU09VUkNFXQk9IHsgLUVU
T09NQU5ZUkVGUywgIm9wZW4gem9uZXMgZXhjZWVkZWQiIH0sCj4+ICAgCVtCTEtfU1RTX1pPTkVf
QUNUSVZFX1JFU09VUkNFXQk9IHsgLUVPVkVSRkxPVywgImFjdGl2ZSB6b25lcyBleGNlZWRlZCIg
fSwKPj4gKwlbQkxLX1NUU19SU1ZfQ09ORkxJQ1RdCT0geyAtRUJBREUsCSJyZXNldmF0aW9uIGNv
bmZsaWN0IiB9LAo+IAo+IFlvdSBtaXNzcGVsbGVkICJyZXNlcnZhdGlvbiIuIDopCj4gCj4gQW5k
IHNpbmNlIHlvdSB3YW50IGEgZGlmZmVyZW50IGVycm9yLCB3aHkgcmV1c2UgRUJBREUgZm9yIHRo
ZSBlcnJubz8gVGhhdCBpcwo+IGFscmVhZHkgdXNlZCBmb3IgQkxLX1NUU19ORVhVUyB0aGF0IHlv
dSdyZSB0cnlpbmcgdG8gZGlmZmVyZW50aWF0ZSBmcm9tLCByaWdodD8KPiBBdCBsZWFzdCBmb3Ig
bnZtZSwgdGhpcyBlcnJvciBjb2RlIGlzIHJldHVybmVkIHdoZW4gdGhlIGhvc3QgbGFja3Mgc3Vm
ZmljaWVudAo+IHJpZ2h0cywgc28gc29tZXRoaW5nIGxpa2UgRUFDQ0VTUyBtaWdodCBtYWtlIHNl
bnNlLgo+IAo+IExvb2tzIGdvb2Qgb3RoZXJ3aXNlLgoKV2VsbGwgLi4uIEJMS19TVFNfTkVYVVMg
X2lzXyB0aGUgcmVzZXJ2YXRpb24gZXJyb3IuCgpJJ2QgcmF0aGVyIG1vZGlmeSB0aGUgZXhpc3Rp
bmcgY29kZSB0byByZXR1cm4gQkxLX1NUU19SU1ZfQ09ORkxJQ1QgCmluc3RlYWQgb2YgQkxLX1NU
U19ORVhVUywgYnV0IGtlZXAgdGhlICdFQkFERScgbWFwcGluZy4KVXNlcnNwYWNlIEFCSSBhbmQg
YWxsIHRoYXQuCgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAg
ICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRp
b25zIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7D
vHJuYmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBJdm8gVG90ZXYsIEFuZHJldwpNeWVycywgQW5k
cmV3IE1jRG9uYWxkLCBNYXJ0amUgQm91ZGllbiBNb2VybWFuCgotLQpkbS1kZXZlbCBtYWlsaW5n
IGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWls
bWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

