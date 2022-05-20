Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66113C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 20 May 2022 06:07:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-ydJ_KSZiMLicOjpm4jXckw-1; Fri, 20 May 2022 02:07:52 -0400
X-MC-Unique: ydJ_KSZiMLicOjpm4jXckw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFEF41801386;
	Fri, 20 May 2022 06:07:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7E1562166B26;
	Fri, 20 May 2022 06:07:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 31810194705A;
	Fri, 20 May 2022 06:07:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B34B11947058
 for <dm-devel@listman.corp.redhat.com>; Fri, 20 May 2022 06:07:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9078E492CA2; Fri, 20 May 2022 06:07:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C479492C3B
 for <dm-devel@redhat.com>; Fri, 20 May 2022 06:07:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7404A29AB3E9
 for <dm-devel@redhat.com>; Fri, 20 May 2022 06:07:47 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-rWhMAOIIMqOWoA69r8G8PQ-1; Fri, 20 May 2022 02:07:45 -0400
X-MC-Unique: rWhMAOIIMqOWoA69r8G8PQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id B37C91F9A9;
 Fri, 20 May 2022 06:07:43 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4C49D13A5F;
 Fri, 20 May 2022 06:07:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id QUrNEC8wh2KlEAAAMHmgww
 (envelope-from <hare@suse.de>); Fri, 20 May 2022 06:07:43 +0000
Message-ID: <16f3f9ee-7db7-2173-840c-534f67bcaf04@suse.de>
Date: Fri, 20 May 2022 08:07:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 Luis Chamberlain <mcgrof@kernel.org>
References: <CGME20220516165418eucas1p2be592d9cd4b35f6b71d39ccbe87f3fef@eucas1p2.samsung.com>
 <20220516165416.171196-1-p.raghav@samsung.com>
 <20220517081048.GA13947@lst.de> <YoPAnj9ufkt5nh1G@mit.edu>
 <7f9cb19b-621b-75ea-7273-2d2769237851@opensource.wdc.com>
 <20220519031237.sw45lvzrydrm7fpb@garbanzo>
 <69f06f90-d31b-620b-9009-188d1d641562@opensource.wdc.com>
 <PH0PR04MB74166C87F694B150A5AE0F009BD09@PH0PR04MB7416.namprd04.prod.outlook.com>
 <4a8f0e1b-0acb-1ed4-8d7a-c9ba93fcfd02@opensource.wdc.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <4a8f0e1b-0acb-1ed4-8d7a-c9ba93fcfd02@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v4 00/13] support non power of 2 zoned devices
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
 Theodore Ts'o <tytso@mit.edu>, "pankydev8@gmail.com" <pankydev8@gmail.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "jiangbo.365@bytedance.com" <jiangbo.365@bytedance.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dsterba@suse.com" <dsterba@suse.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Christoph Hellwig <hch@lst.de>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
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

T24gNS8xOS8yMiAyMDo0NywgRGFtaWVuIExlIE1vYWwgd3JvdGU6Cj4gT24gNS8xOS8yMiAxNjoz
NCwgSm9oYW5uZXMgVGh1bXNoaXJuIHdyb3RlOgo+PiBPbiAxOS8wNS8yMDIyIDA1OjE5LCBEYW1p
ZW4gTGUgTW9hbCB3cm90ZToKPj4+IE9uIDUvMTkvMjIgMTI6MTIsIEx1aXMgQ2hhbWJlcmxhaW4g
d3JvdGU6Cj4+Pj4gT24gVGh1LCBNYXkgMTksIDIwMjIgYXQgMTI6MDg6MjZQTSArMDkwMCwgRGFt
aWVuIExlIE1vYWwgd3JvdGU6Cj4+Pj4+IE9uIDUvMTgvMjIgMDA6MzQsIFRoZW9kb3JlIFRzJ28g
d3JvdGU6Cj4+Pj4+PiBPbiBUdWUsIE1heSAxNywgMjAyMiBhdCAxMDoxMDo0OEFNICswMjAwLCBD
aHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPj4+Pj4+PiBJJ20gYSBsaXR0bGUgc3VycHJpc2VkIGFi
b3V0IGFsbCB0aGlzIGFjdGl2aXR5Lgo+Pj4+Pj4+Cj4+Pj4+Pj4gSSB0aG91Z2ggdGhlIGNvbmNs
dXNpb24gYXQgTFNGL01NIHdhcyB0aGF0IGZvciBMaW51eCBpdHNlbGYgdGhlcmUKPj4+Pj4+PiBp
cyB2ZXJ5IGxpdHRsZSBiZW5lZml0IGluIHN1cHBvcnRpbmcgdGhpcyBzY2hlbWUuICBJdCB3aWxs
IG1hc3NpdmVseQo+Pj4+Pj4+IGZyYWdtZW50IHRoZSBzdXBwb3J0ZWQgYmFzZWQgb2YgZGV2aWNl
cyBhbmQgYXBwbGljYXRpb25zLCB3aGlsZSBvbmx5Cj4+Pj4+Pj4gaGF2aW5nIHRoZSBiZW5lZml0
IG9mIHN1cHBvcnRpbmcgc29tZSBTYW1zdW5nIGxlZ2FjeSBkZXZpY2VzLgo+Pj4+Pj4KPj4+Pj4+
IEZXSVcsCj4+Pj4+Pgo+Pj4+Pj4gVGhhdCB3YXNuJ3QgbXkgaW1wcmVzc2lvbiBmcm9tIHRoYXQg
TFNGL01NIHNlc3Npb24sIGJ1dCBvbmNlIHRoZQo+Pj4+Pj4gdmlkZW9zIGJlY29tZSBhdmFpbGFi
bGUsIGZvbGtzIGNhbiBkZWNpZGUgZm9yIHRoZW1zZWx2ZXMuCj4+Pj4+Cj4+Pj4+IFRoZXJlIHdh
cyBubyByZWFsIGRpc2N1c3Npb24gYWJvdXQgem9uZSBzaXplIGNvbnN0cmFpbnQgb24gdGhlIHpv
bmUKPj4+Pj4gc3RvcmFnZSBCb0YuIE1hbnkgZGlzY3Vzc2lvbnMgaGFwcGVuZWQgaW4gdGhlIGhh
bGx3YXkgdHJhY2sgdGhvdWdoLgo+Pj4+Cj4+Pj4gUmlnaHQgc28gbm8gZGlyZWN0IGNsZWFyIGJs
b2NrZXJzIG1lbnRpb25lZCBhdCBhbGwgZHVyaW5nIHRoZSBCb0YuCj4+Pgo+Pj4gTm9yIGFueSBj
bGVhciBPSy4KPj4KPj4gU28gd2hhdCBhYm91dCBjcmVhdGluZyBhIGRldmljZS1tYXBwZXIgdGFy
Z2V0LCB0aGF0J3MgdGFraW5nIG5wbzIgZHJpdmVzIGFuZAo+PiBtYWtlcyB0aGVtIHBvMiBkcml2
ZXMgZm9yIHRoZSBGUyBsYXllcnM/IEl0IHdpbGwgYmUgdmVyeSBzaW1pbGFyIGNvZGUgdG8KPj4g
ZG0tbGluZWFyLgo+IAo+ICsxCj4gCj4gVGhpcyB3aWxsIHNpbXBsaWZ5IHRoZSBzdXBwb3J0IGZv
ciBGU2VzLCBhdCBsZWFzdCBmb3IgdGhlIGluaXRpYWwgZHJvcCAoaWYKPiBhY2NlcHRlZCkuCj4g
Cj4gQW5kIG1vcmUgaW1wb3J0YW50bHksIHRoaXMgd2lsbCBhbHNvIGFsbG93IGFkZHJlc3Npbmcg
YW55IHBvdGVudGlhbAo+IHByb2JsZW0gd2l0aCB1c2VyIHNwYWNlIGJyZWFraW5nIGJlY2F1c2Ug
b2YgdGhlIG5vbiBwb3dlciBvZiAyIHpvbmUgc2l6ZS4KPiAKU2Vjb25kZWQgKG9yIG1heWJlIHRo
aXJkZWQpLgoKVGhlIGNoYW5nZXMgdG8gc3VwcG9ydCBucG8yIGluIHRoZSBibG9jayBsYXllciBh
cmUgcHJldHR5IHNpbXBsZSwgYW5kIApyZWFsbHkgSSBkb24ndCBoYXZlIGFuIGlzc3VlIHdpdGgg
dGhvc2UuClRoZW4gYWRkaW5nIGEgZGV2aWNlLW1hcHBlciB0YXJnZXQgdHJhbnNmb3JtaW5nIG5w
bzIgZHJpdmVzIGluIHBvMiBibG9jayAKZGV2aWNlcyBzaG91bGQgYmUgcHJldHR5IHRyaXZpYWwu
CgpBbmQgb25jZSB0aGF0IGlzIGluIHlvdSBjYW4gc3RhcnQgYXJndWluZyB3aXRoIHRoZSB0aGUg
RlMgZm9sa3Mgb24gCndoZXRoZXIgdG8gaW1wbGVtZW50IGl0IG5hdGl2ZWx5LgoKQ2hlZXJzLAoK
SGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAgICAgIEtlcm5lbCBTdG9y
YWdlIEFyY2hpdGVjdApoYXJlQHN1c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAr
NDkgOTExIDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHbWJILCBNYXhmZWxkc3Ry
LiA1LCA5MDQwOSBOw7xybmJlcmcKSFJCIDM2ODA5IChBRyBOw7xybmJlcmcpLCBHZXNjaMOkZnRz
ZsO8aHJlcjogSXZvIFRvdGV2LCBBbmRyZXcKTXllcnMsIEFuZHJldyBNY0RvbmFsZCwgTWFydGpl
IEJvdWRpZW4gTW9lcm1hbgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhh
dC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZl
bAo=

