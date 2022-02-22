Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C519CC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Feb 2022 22:49:55 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-odUFVL27PnClZuU8YTfECA-1; Tue, 22 Feb 2022 17:49:51 -0500
X-MC-Unique: odUFVL27PnClZuU8YTfECA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 232B01006AA8;
	Tue, 22 Feb 2022 22:49:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D983B4E2B1;
	Tue, 22 Feb 2022 22:49:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EB2F01809C98;
	Tue, 22 Feb 2022 22:49:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21MMnhjw020647 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Feb 2022 17:49:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E4979492D49; Tue, 22 Feb 2022 22:49:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E0770492D48
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 22:49:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C66E41066680
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 22:49:42 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-433-ktE0GkM_MjeKjMJuw7xo2g-1; Tue, 22 Feb 2022 17:49:39 -0500
X-MC-Unique: ktE0GkM_MjeKjMJuw7xo2g-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 52E8221129;
	Tue, 22 Feb 2022 22:49:37 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BF3F413C33;
	Tue, 22 Feb 2022 22:49:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 6Cc2H3xoFWIeWAAAMHmgww
	(envelope-from <neilb@suse.de>); Tue, 22 Feb 2022 22:49:32 +0000
MIME-Version: 1.0
From: "NeilBrown" <neilb@suse.de>
To: "Martin Wilck" <mwilck@suse.com>
In-reply-to: <4b61ca1eafb35e3fdfbc9bb260dc89d56d181499.camel@suse.com>
References: <20220216205914.7575-1-mwilck@suse.com>,
	<164504936873.10228.7361167610237544463@noble.neil.brown.name>,
	<e8720e3f8734cbad1af34d5e54afc47ba3ef1b8f.camel@suse.com>,
	<20220217130934.lh2b33255kyx2pax@alatyr-rpi.brq.redhat.com>,
	<164548656531.8827.3365536065813085321@noble.neil.brown.name>,
	<4b61ca1eafb35e3fdfbc9bb260dc89d56d181499.camel@suse.com>
Date: Wed, 23 Feb 2022 09:49:27 +1100
Message-id: <164557016782.28944.17731814770525408828@noble.neil.brown.name>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21MMnhjw020647
X-loop: dm-devel@redhat.com
Cc: Jes Sorensen <jsorensen@fb.com>, Coly Li <colyli@suse.com>,
	Peter Rajnoha <prajnoha@redhat.com>, lvm-devel@redhat.com,
	linux-raid@vger.kernel.org, dm-devel@redhat.com,
	Heming Zhao <heming.zhao@suse.com>
Subject: Re: [dm-devel] [PATCH] udev-md-raid-assembly.rules: skip if
 DM_UDEV_DISABLE_OTHER_RULES_FLAG
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCAyMyBGZWIgMjAyMiwgTWFydGluIFdpbGNrIHdyb3RlOgo+IE5laWwsCj4gCj4gT24g
VHVlLCAyMDIyLTAyLTIyIGF0IDEwOjM2ICsxMTAwLCBOZWlsQnJvd24gd3JvdGU6Cj4gPiAKPiA+
ID4gVGhlIGZsYWdzIHRoYXQgRE0gdXNlIGZvciB1ZGV2IHdlcmUgaW50cm9kdWNlZCBiZWZvcmUg
c3lzdGVtZAo+ID4gPiBwcm9qZWN0Cj4gPiA+IGV2ZW4gZXhpc3RlZC4gV2UgbmVlZGVkIHRvIGlu
dHJvZHVjZSB0aGUKPiA+ID4gRE1fVURFVl9ESVNBQkxFX09USEVSX1JVTEVTX0ZMQUcKPiA+ID4g
dG8gaGF2ZSBhIHBvc3NpYmlsaXR5IGZvciBhbGwgdGhlICJvdGhlciIgKG5vbi1kbSkgdWRldiBy
dWxlcyB0bwo+ID4gPiBjaGVjawo+ID4gPiBmb3IgaWYgdGhlcmUncyBhbm90aGVyIHN1YnN5c3Rl
bSBzdGFja2luZyBpdHMgb3duIGRldmljZXMgb24gdG9wIG9mCj4gPiA+IERNCj4gPiA+IG9uZXMu
Cj4gPiAKPiA+IElmIHRoaXMgaXMgYW4gZXN0YWJsaXNoZWQgQVBJIHRoYXQgRE0gdXNlcywgdGhl
biBwcmVzdW1hYmx5IGl0IGlzCj4gPiBkb2N1bWVudGVkIHNvbWV3aGVyZS7CoCBJZiBhIGxpbmsg
dG8gdGhhdCBkb2N1bWVudGF0aW9uIHdlcmUgcHJvdmlkZWQsCj4gPiBpdAo+ID4gd291bGQgbG9v
ayBhIGEgd2hvbGUgbG90IGxlc3MgbGlrZSBhIGhhY2suCj4gCj4gUGV0ZXIgaGFzIHByb3ZpZGVk
IGEgbGluayB0byBsaWJkZXZtYXBwZXIuaCBpbiBoaXMgcHJldmlvdXMgcG9zdCBpbgo+IHRoaXMg
dGhyZWFkLiBJcyB0aGlzIGEgcmVxdWVzdCBmb3IgbWUgdG8gaW5jbHVkZSB0aGF0IGxpbmsgaW4g
dGhlIHBhdGNoCj4gZGVzY3JpcHRpb24/CgpJZiBsaWJkZXZtYXBwZXIuaCBpcyB0aGUgYmVzdCBk
b2N1bWVudGF0aW9uIHRoZXJlIGlzIGZvciB0aGlzIHZhcmlhYmxlLAp0aGVuIGhvcGVmdWxseSB5
b3UgY2FuIHNlZSB3aHkgaXQgZmVlbHMgdG8gYW4gb3V0c2lkZXIgbGlrZSBhIGhhY2suCgpJdCBp
c24ndCBldmVuIGltbWVkaWF0ZWx5IGNsZWFyIHRoYXQgdGhlIHRleHQgdGhlcmUgaXMgdGFsa2lu
ZyBhYm91dAplbnZpcm9ubWVudCB2YXJpYWJsZXMgdmlzaWJsZSBpbiB1ZGV2LgpJZiB0aGVyZSBp
cyBhbiBleHBlY3RhdGlvbiB0aGF0IHRvb2xzIG91dHNpZGUgb2YgbHZtMiB3aWxsIHVzZSB0aGVz
ZSwKdGhlbiB0aGV5IHJlYWxseSBzaG91bGQgYmUgZG9jdW1lbnRlZCBwcm9wZXJseS4gIFNZU1RF
TURfUkVBRFkgaXMKZG9jdW1lbnRlZCBpbiAibWFuIHN5c3RlbWQuZGV2aWNlIi4gIEhvdyBoYXJk
IHdvdWxkIGl0IGJlIHRvIHdyaXRlIGEKImRtLXVkZXYiIG1hbiBwYWdlIHdoaWNoIGV4cGxhaW5z
IGFsbCB0aGlzLgoKQnV0IGlmIGxpYmRldm1hcHBlci5oIGlzIHRoZSBiZXN0IHlvdSBoYXZlLCB0
aGVuIG1heWJlIGl0J2xsIGhhdmUgdG8gZG8uCkl0IGlzIHVwIHRvIEplcyB3aGF0IGhlIGFjY2Vw
dHMgb2YgY291cnNlLgoKVGhhbmtzLApOZWlsQnJvd24KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlz
dApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWw=

