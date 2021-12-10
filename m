Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D7A1C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 10 Dec 2021 01:07:33 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-k069p70JOCWbz-xWehQjQQ-1; Thu, 09 Dec 2021 20:07:29 -0500
X-MC-Unique: k069p70JOCWbz-xWehQjQQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D10B980BCAB;
	Fri, 10 Dec 2021 01:07:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BD06450E11;
	Fri, 10 Dec 2021 01:07:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 20A664BB7C;
	Fri, 10 Dec 2021 01:07:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BA17F9g026160 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 9 Dec 2021 20:07:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 32E85401DBC; Fri, 10 Dec 2021 01:07:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F896401DB1
	for <dm-devel@redhat.com>; Fri, 10 Dec 2021 01:07:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 168DE3C11D27
	for <dm-devel@redhat.com>; Fri, 10 Dec 2021 01:07:15 +0000 (UTC)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-525-3OEvJdSuOe-cdYOmbGlZUg-1; Thu, 09 Dec 2021 20:07:11 -0500
X-MC-Unique: 3OEvJdSuOe-cdYOmbGlZUg-1
To: Donald Buczek <buczek@molgen.mpg.de>, Paul Menzel <pmenzel@molgen.mpg.de>,
	song@kernel.org
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
	<36a660ed-b995-839e-ac82-dc4ca25ccb8a@molgen.mpg.de>
	<2cefad59-c0fc-d48f-f7a5-5d593931feb7@molgen.mpg.de>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
	include these headers.
From: Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <43ae2d60-4f28-07ea-95dc-ae722ca13b23@linux.dev>
Date: Fri, 10 Dec 2021 09:06:57 +0800
MIME-Version: 1.0
In-Reply-To: <2cefad59-c0fc-d48f-f7a5-5d593931feb7@molgen.mpg.de>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1BA17F9g026160
X-loop: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, it+raid@molgen.mpg.de,
	snitzer@redhat.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH V2] md: don't unregister sync_thread with
 reconfig_mutex held
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
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAxMi85LzIxIDg6NTcgUE0sIERvbmFsZCBCdWN6ZWsgd3JvdGU6Cj4gW1VwZGF0ZSBHdW9x
aW5n4oCZcyBlbWFpbCBhZGRyZXNzXQo+Cj4gT24gMTUuMDIuMjEgMTI6MDcsIFBhdWwgTWVuemVs
IHdyb3RlOgo+PiBbK2NjIERvbmFsZF0KPj4KPj4gQW0gMTMuMDIuMjEgdW0gMDE6NDkgc2Nocmll
YiBHdW9xaW5nIEppYW5nOgo+Pj4gVW5yZWdpc3RlciBzeW5jX3RocmVhZCBkb2Vzbid0IG5lZWQg
dG8gaG9sZCByZWNvbmZpZ19tdXRleCBzaW5jZSBpdAo+Pj4gZG9lc24ndCByZWNvbmZpZ3VyZSBh
cnJheS4KPj4+Cj4+PiBBbmQgaXQgY291bGQgY2F1c2UgZGVhZGxvY2sgcHJvYmxlbSBmb3IgcmFp
ZDUgYXMgZm9sbG93czoKPj4+Cj4+PiAxLiBwcm9jZXNzIEEgdHJpZWQgdG8gcmVhcCBzeW5jIHRo
cmVhZCB3aXRoIHJlY29uZmlnX211dGV4IGhlbGQgCj4+PiBhZnRlciBlY2hvCj4+PiDCoMKgwqAg
aWRsZSB0byBzeW5jX2FjdGlvbi4KPj4+IDIuIHJhaWQ1IHN5bmMgdGhyZWFkIHdhcyBibG9ja2Vk
IGlmIHRoZXJlIHdlcmUgdG9vIG1hbnkgYWN0aXZlIHN0cmlwZXMuCj4+PiAzLiBTQl9DSEFOR0Vf
UEVORElORyB3YXMgc2V0IChiZWNhdXNlIG9mIHdyaXRlIElPIGNvbWVzIGZyb20gdXBwZXIgCj4+
PiBsYXllcikKPj4+IMKgwqDCoCB3aGljaCBjYXVzZXMgdGhlIG51bWJlciBvZiBhY3RpdmUgc3Ry
aXBlcyBjYW4ndCBiZSBkZWNyZWFzZWQuCj4+PiA0LiBTQl9DSEFOR0VfUEVORElORyBjYW4ndCBi
ZSBjbGVhcmVkIHNpbmNlIG1kX2NoZWNrX3JlY292ZXJ5IHdhcyAKPj4+IG5vdCBhYmxlCj4+PiDC
oMKgwqAgdG8gaG9sZCByZWNvbmZpZ19tdXRleC4KPj4+Cj4+PiBNb3JlIGRldGFpbHMgaW4gdGhl
IGxpbms6Cj4+PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1yYWlkLzVlZDU0ZmZjLWNl
ODItYmY2Ni00ZWZmLTM5MGNiMjNiYzFhY0Btb2xnZW4ubXBnLmRlL1QvI3QgCj4+Pgo+Pj4KPj4+
IEFuZCBhZGQgb25lIHBhcmFtZXRlciB0byBtZF9yZWFwX3N5bmNfdGhyZWFkIHNpbmNlIGl0IGNv
dWxkIGJlIAo+Pj4gY2FsbGVkIGJ5Cj4+PiBkbS1yYWlkIHdoaWNoIGRvZXNuJ3QgaG9sZCByZWNv
bmZpZ19tdXRleC4KPj4+Cj4+PiBSZXBvcnRlZC1hbmQtdGVzdGVkLWJ5OiBEb25hbGQgQnVjemVr
IDxidWN6ZWtAbW9sZ2VuLm1wZy5kZT4KPgo+IFRoYW5rcywgUGF1bCwgZm9yIHB1dHRpbmcgbWUg
aW50byB0aGUgY2MuCj4KPiBHdW9xaW5nLCBJIGRvbid0IHRoaW5rLCBJJ3ZlIHRlc3RlZCB0aGlz
IHBhdGNoLiBQbGVhc2UgcmVtb3ZlIHRoZSAKPiB0ZXN0ZWQtYnkuCgpUaGlzIHZlcnNpb24gaXMg
YmFzaWNhbGx5IHRoZSBzaW1pbGFyIGFzIHRoZSBjaGFuZ2UgaW4gdGhlIHRocmVhZC4KCmh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXJhaWQvNWVkNTRmZmMtY2U4Mi1iZjY2LTRlZmYtMzkw
Y2IyM2JjMWFjQG1vbGdlbi5tcGcuZGUvVC8jbTU0NmQ4YzU1YTQyZjMwODk4NWI5ZDMxZDRiZTg1
ODMyZWRjZDE1YWIKCkFueXdheSwgSSB3aWxsIHJlbW92ZSB5b3VyIHRlc3RlZC1ieSBwZXIgdGhl
IHJlcXVlc3QgaWYgSSB3aWxsIHVwZGF0ZSAKdGhlIHBhdGNoLgoKVGhhbmtzLApHdW9xaW5nCgoK
LS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0
bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

