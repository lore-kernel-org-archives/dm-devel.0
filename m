Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6478BC7EE2D
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 08:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677485920;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DtUiiXsdZ2LH5OpPOd003/NZyfM0D46t8Redirx5Q6g=;
	b=LDyf9TAP4Q1zM5t08KuSwE0ZFLcXmKO306kiHfyCl1nB9KiOa+V/+GKcyGg+2bjwTo7cYW
	g2+tgwXUu5UOtzLGjZ+Fi+2bpnFewnxNbbwmRvrHrrcxuP0tPDxrYAep328BE8EduGHwUL
	/bVEJitv+qqOzjF9DQ6zLr5BUQNvQu8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-tx4ZWymWO-Wm5An82u6USA-1; Mon, 27 Feb 2023 03:18:37 -0500
X-MC-Unique: tx4ZWymWO-Wm5An82u6USA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1835F3814593;
	Mon, 27 Feb 2023 08:18:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3576843FBB;
	Mon, 27 Feb 2023 08:18:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 228971946589;
	Mon, 27 Feb 2023 08:18:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CE8FA1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Feb 2023 08:18:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BDE4D492B0F; Mon, 27 Feb 2023 08:18:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B5C2F492B0E
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 08:18:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 875A195D626
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 08:18:31 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-641-VtSy_zoAM7iBZNfPu26rHg-1; Mon,
 27 Feb 2023 03:18:30 -0500
X-MC-Unique: VtSy_zoAM7iBZNfPu26rHg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 1070E219EF;
 Mon, 27 Feb 2023 08:12:42 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B42F913A43;
 Mon, 27 Feb 2023 08:12:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id vmw1K/ll/GOcLwAAMHmgww
 (envelope-from <hare@suse.de>); Mon, 27 Feb 2023 08:12:41 +0000
Message-ID: <5ca0ebcb-b714-81fe-ee24-adbdcb830320@suse.de>
Date: Mon, 27 Feb 2023 09:12:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
To: Steve French <smfrench@gmail.com>,
 James Bottomley <James.Bottomley@hansenpartnership.com>
References: <2896937.1676998541@warthog.procyon.org.uk>
 <96463a32a97dc40bc30c47ddcdf19a5803de32d8.camel@HansenPartnership.com>
 <CAH2r5mtLFW3x46rTACqk0XsjdHq_UMG-bLgQJx0LtyF9DF9cwg@mail.gmail.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <CAH2r5mtLFW3x46rTACqk0XsjdHq_UMG-bLgQJx0LtyF9DF9cwg@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [LSF/MM/BPF TOPIC] Linux Security Summit cross-over?
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
Cc: David Howells <dhowells@redhat.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Chuck Lever <chuck.lever@oracle.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 lsf-pc <lsf-pc@lists.linux-foundation.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMi8yNC8yMyAyMjozNywgU3RldmUgRnJlbmNoIHdyb3RlOgo+IEkgZGlkIG9uZSBvbiBuZXR3
b3JrIGZzIHNlY3VyaXR5IGF0IGEgc2VjdXJpdHkgc3VtbWl0IGJlZm9yZSB0aGF0IHdvdWxkIAo+
IHN0aWxsIGJlIHJlbGV2YW50IHRvIGJvdGgKPiAKPiBPbiBUdWUsIEZlYiAyMSwgMjAyMywgMTY6
MTYgSmFtZXMgQm90dG9tbGV5IAo+IDxKYW1lcy5Cb3R0b21sZXlAaGFuc2VucGFydG5lcnNoaXAu
Y29tIAo+IDxtYWlsdG86SmFtZXMuQm90dG9tbGV5QGhhbnNlbnBhcnRuZXJzaGlwLmNvbT4+IHdy
b3RlOgo+IAo+ICAgICBPbiBUdWUsIDIwMjMtMDItMjEgYXQgMTY6NTUgKzAwMDAsIERhdmlkIEhv
d2VsbHMgd3JvdGU6Cj4gICAgICA+Cj4gICAgICA+IFNpbmNlIHRoZSBmaXJzdCBkYXkgb2YgdGhl
IExTUyBpcyB0aGUgc2FtZSBhcyB0aGUgZmluYWwgZGF5IG9mIExTRgo+ICAgICAgPiBhbmQgaW4g
dGhlIHNhbWUgdmVudWUsIGFyZSB0aGVyZSBhbnkgZmlsZXN5c3RlbSArIHNlY3VyaXR5IHN1Ympl
Y3RzCj4gICAgICA+IHRoYXQgd291bGQgbWVyaXQgYSBjb21tb24gc2Vzc2lvbj8KPiAKPiAKPiAg
ICAgSSd2ZSBnb3Qgb25lOsKgIENyeXB0b2dyYXBoaWMgbWF0ZXJpYWwgaGFuZGxpbmcuCj4gCj4g
ICAgIFN1YnRpdGxlIGNvdWxkIGJlOiBtYWtpbmcga2V5cmluZ3MgbW9yZSB1c2FibGUuCj4gCj4g
ICAgIFRoZSBicm9hZCBwcm9ibGVtIGlzIHRoYXQgdGhlIHVzZSBvZiBlbmNyeXB0aW9uIHdpdGhp
biB0aGUga2VybmVsIGlzCj4gICAgIGdyb3dpbmcgKGZyb20gdGhlIG9sZCBkbS1jcnlwdCB0byB0
aGUgbmV3ZXIgZnNjcnlwdCBhbmQgYmV5b25kKSB5ZXQKPiAgICAgcHJldHR5IG11Y2ggYWxsIG9m
IG91ciBjcnlwdG9ncmFwaGljIGtleSBtYXRlcmlhbCBoYW5kbGluZyB2aW9sYXRlcyB0aGUKPiAg
ICAgcHJpbmNpcGxlIG9mIGxlYXN0IHByaXZpbGVnZS7CoCBUaGUgbGF0ZXN0IG9uZSAod2hpY2gg
SSBoYXBwZW5lZCB0bwo+ICAgICBub3RpY2UgYmVpbmcgaW50ZXJlc3RlZCBpbiBUUE1zKSBpcyB0
aGUgc3lzdGVtZCB0cG0yIGNyeXB0ZW5yb2xsLsKgIFRoZQo+ICAgICBzcGVjaWZpYyB2aW9sYXRp
b24gaXMgdGhhdCBrZXkgdW53cmFwcGluZyBzaG91bGQgb2NjdXIgYXMgY2xvc2UgYXMKPiAgICAg
cG9zc2libGUgdG8gdXNlOiB3aGVuIHRoZSBrZXJuZWwgdXNlcyBhIGtleSwgaXQgc2hvdWxkIGJl
IHRoZSBrZXJuZWwKPiAgICAgdW53cmFwcGluZyBpdCBub3QgdW53cmFwcGluZyBpbiB1c2VyIHNw
YWNlIGFuZCBoYW5kaW5nIHRoZSB1bndyYXBwZWQKPiAgICAga2V5IGRvd24gdG8gdGhlIGtlcm5l
bCBiZWNhdXNlIHRoYXQgZ2l2ZXMgYSB3YXkuwqAgV2UgZ290IGhlcmUgYmVjYXVzZQo+ICAgICBp
biBtb3N0IG9mIHRoZSBvbGQgdXNlcywgdGhlIGtleSBpcyBkZXJpdmVkIGZyb20gYSBwYXNzcGhy
YXNlIGFuZCB0aGUKPiAgICAga2VybmVsIGNhbid0IHByb21wdCB0aGUgdXNlciwgc28gcGllY2Vz
IG9mIHVzZXIgc3BhY2UgaGF2ZSB0byBnYXRoZXIKPiAgICAgdGhlIHByZWN1cnNvciBjcnlwdG9n
cmFwaGljIG1hdGVyaWFsIGFueXdheS7CoCBIb3dldmVyLCB3ZSdyZSBtb3ZpbmcKPiAgICAgdG93
YXJkcyB1c2luZyBjcnlwdG9ncmFwaGljIGRldmljZXMgKGxpa2UgdGhlIFRQTSwga2V5IGZvYnMg
YW5kIHRoZQo+ICAgICBsaWtlKSB0byBzdG9yZSBrZXlzIHdlIHJlYWxseSBzaG91bGQgYmUgcGFz
c2luZyB0aGUgd3JhcHBlZCBrZXkgaW50bwo+ICAgICB0aGUga2VybmVsIGFuZCBsZXR0aW5nIGl0
IGRvIHRoZSB1bndyYXAgdG8gcHJlc2VydmUgbGVhc3QgcHJpdmlsZWdlLgo+ICAgICBkbS1jcnlw
dCBoYXMgc29tZSBzdXBwb3J0IGZvciB1c2luZyBrZXJuZWwgYmFzZWQgVFBNIGtleXMgKHRoZSB0
cnVzdGVkCj4gICAgIGtleSBzdWJzeXN0ZW0pLCBidXQgdGhpcyBpc24ndCBwcm9wYWdhdGVkIGlu
dG8gc3lzdGVtZC1jcnlwdGVucm9sbCBhbmQKPiAgICAgcHJldHR5IG11Y2ggbm9uZSBvZiB0aGUg
b3RoZXIgZW5jcnlwdGlvbiBzeXN0ZW1zIG1ha2UgYW55IGF0dGVtcHQgdG8KPiAgICAgdXNlIGtl
eXJpbmdzIGZvciB1bndyYXAgaGFuZGxpbmcsIGV2ZW4gaWYgdGhleSB1c2Uga2V5cmluZ3MgdG8g
c3RvcmUKPiAgICAgY3J5cHRvZ3JhcGhpYyBtYXRlcmlhbC4KPiAKPiAgICAgUGFydCBvZiB0aGUg
cmVhc29uIHNlZW1zIHRvIGJlIHRoYXQgdGhlIGtleXJpbmdzIHN1YnN5c3RlbSBpdHNlbGYgaXMK
PiAgICAgaGFyZCB0byB1c2UgYXMgYSBnZW5lcmljICJ1bndyYXBwZXIiIHNpbmNlIHRoZSBjb25z
dW1lciBvZiB0aGUga2V5cyBoYXMKPiAgICAgdG8ga25vdyBleGFjdGx5IHRoZSBrZXkgdHlwZSB0
byBjb25zdW1lIHRoZSBwcm90ZWN0ZWQgcGF5bG9hZC7CoCBXZQo+ICAgICBjb3VsZCBwb3NzaWJs
eSBmaXggdGhpcyBieSBhZGRpbmcgYSBwYXlsb2FkIGFjY2Vzc29yIGZ1bmN0aW9uIHNvIHRoZQo+
ICAgICBrZXlyaW5nIGNvbnN1bWVyIGNvdWxkIGFjY2VzcyBhIHBheWxvYWQgZnJvbSBhbnkga2V5
IHR5cGUgYW5kIHRodXMKPiAgICAgYmVuZWZpdCBmcm9tIGluLWtlcm5lbCB1bndyYXBwaW5nLCBi
dXQgdGhlcmUgYXJlIGxpa2VseSBhIGhvc3Qgb2Ygb3RoZXIKPiAgICAgaXNzdWVzIHRoYXQgbmVl
ZCB0byBiZSBzb2x2ZWQuwqAgU28gd2hhdCBJJ2QgcmVhbGx5IGxpa2UgdG8gZGlzY3VzcyBpczoK
PiAKPiAgICAgR2l2ZW4gdGhlIHNlY3VyaXR5IG5lZWQgZm9yIGEgZ2VuZXJpYyBpbi1rZXJuZWwg
dW53cmFwcGVyLCBzaG91bGQgd2UKPiAgICAgbWFrZSBrZXlyaW5ncyBkbyB0aGlzIGFuZCBpZiBz
bywgaG93Pwo+IFRoYXQncyBvbmUgd2hlcmUgSSdkIGJlIGludGVyZXN0ZWQgaW4sIHRvbzsgZm9y
IE5WTWUtb3Zlci1UTFMgd2UnbGwgYmUgCnVzaW5nIGtleXJpbmdzLCB0b28sIGFuZCBoYXZlIHRo
ZSBzYW1lIGlzc3VlIGFzIHRvIGhvdyBhbmQgd2hlcmUga2V5cyAKc2hvdWxkIGJlIGRlY29kZWQg
KGVnIGZvciBYLjUwOSBoYW5kbGluZykuCgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMg
UmVpbmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3Vz
ZS5kZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0Ug
U29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpI
UkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBJdm8gVG90ZXYsIEFu
ZHJldwpNeWVycywgQW5kcmV3IE1jRG9uYWxkLCBNYXJ0amUgQm91ZGllbiBNb2VybWFuCgotLQpk
bS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4u
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

