Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D59EC433FE
	for <dm-devel@archiver.kernel.org>; Fri, 20 May 2022 06:41:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-dkszVnLfO8Gc5yx1xx300g-1; Fri, 20 May 2022 02:41:48 -0400
X-MC-Unique: dkszVnLfO8Gc5yx1xx300g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9E8F80419F;
	Fri, 20 May 2022 06:41:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B93D02024CAE;
	Fri, 20 May 2022 06:41:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 85AD7194705A;
	Fri, 20 May 2022 06:41:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 76FA51947058
 for <dm-devel@listman.corp.redhat.com>; Fri, 20 May 2022 06:41:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6476FC53362; Fri, 20 May 2022 06:41:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 606A0C53360
 for <dm-devel@redhat.com>; Fri, 20 May 2022 06:41:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 351643C138CE
 for <dm-devel@redhat.com>; Fri, 20 May 2022 06:41:44 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-BLf4BhfoOrijhQ3Wyu5FkQ-1; Fri, 20 May 2022 02:41:41 -0400
X-MC-Unique: BLf4BhfoOrijhQ3Wyu5FkQ-1
X-IronPort-AV: E=Sophos;i="5.91,238,1647273600"; d="scan'208";a="205748306"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 20 May 2022 14:41:40 +0800
IronPort-SDR: ryHATG2hi5fq51HhjXFvlABXzWlQ8v68RIfLr1PR1wOTju+SOjqtMzInG7Q4zskPfIWwqJHnXe
 Sy3no3eakHlpl0qDynak+jqu+u2AK3pRhoIn7j4Wqd1Jrqm4vpVOiDPzU3+uEAzcJ1vFapFTZ/
 pbz5J0MPZGf9RhEKEV7VcGYCoJCsusL9m6bG/JRVxCFhUhw9PvcGUixIVrCwH8hZ4MsjY1mva7
 kxFzUnQEAFcujTvxJO/FDbc8T2XTaYQqX4FT2JyXp0HOuVngN2jYBtkkXLNCASpjUfZHWHZnI0
 YSahSqoLSLxu45kdy4T9HFWO
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 19 May 2022 23:07:03 -0700
IronPort-SDR: A6z/V5yGfSUDCbrYbnphxP3JiDd3It/X53I+goqrd/GFmZ+wUOE9g50Wc4TgibJLcPRIXBtK/J
 NO2MhPXg2rfTmS7nazTTG7gotGqefD9sDYBzBDLCzNPT2wWiEF3YrU8FgkihHmqnAB2oz0SKbs
 iZBrdIGiSvujfagBC3lNDzpRguAmilznjmZxGO/W9iwQUvEdQoImuDdAR0dr/JmM22gr/Tsymw
 EeoefCcqgFnkrGIW113uxRyG2CZJGy8FiQ9doKmWGGJDKe4GdsZ5blurRp/XH+WKj8Fm3/hEJm
 bhI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 19 May 2022 23:41:40 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4L4HFH2NWyz1Rwrw
 for <dm-devel@redhat.com>; Thu, 19 May 2022 23:41:39 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id Aeh0yGbcqUjX for <dm-devel@redhat.com>;
 Thu, 19 May 2022 23:41:38 -0700 (PDT)
Received: from [10.225.163.45] (unknown [10.225.163.45])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4L4HFC1ffTz1Rvlc;
 Thu, 19 May 2022 23:41:34 -0700 (PDT)
Message-ID: <be429864-09cb-e3fb-2afe-46a3453c4d73@opensource.wdc.com>
Date: Fri, 20 May 2022 15:41:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
To: =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier.gonz@samsung.com>,
 Hannes Reinecke <hare@suse.de>
References: <CGME20220516165418eucas1p2be592d9cd4b35f6b71d39ccbe87f3fef@eucas1p2.samsung.com>
 <20220516165416.171196-1-p.raghav@samsung.com>
 <20220517081048.GA13947@lst.de> <YoPAnj9ufkt5nh1G@mit.edu>
 <7f9cb19b-621b-75ea-7273-2d2769237851@opensource.wdc.com>
 <20220519031237.sw45lvzrydrm7fpb@garbanzo>
 <69f06f90-d31b-620b-9009-188d1d641562@opensource.wdc.com>
 <PH0PR04MB74166C87F694B150A5AE0F009BD09@PH0PR04MB7416.namprd04.prod.outlook.com>
 <4a8f0e1b-0acb-1ed4-8d7a-c9ba93fcfd02@opensource.wdc.com>
 <16f3f9ee-7db7-2173-840c-534f67bcaf04@suse.de>
 <20220520062720.wxdcp5lkscesppch@mpHalley-2.localdomain>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220520062720.wxdcp5lkscesppch@mpHalley-2.localdomain>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
 Theodore Ts'o <tytso@mit.edu>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 "jiangbo.365@bytedance.com" <jiangbo.365@bytedance.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dsterba@suse.com" <dsterba@suse.com>, Luis Chamberlain <mcgrof@kernel.org>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNS8yMC8yMiAxNToyNywgSmF2aWVyIEdvbnrDoWxleiB3cm90ZToKPiBPbiAyMC4wNS4yMDIy
IDA4OjA3LCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6Cj4+IE9uIDUvMTkvMjIgMjA6NDcsIERhbWll
biBMZSBNb2FsIHdyb3RlOgo+Pj4gT24gNS8xOS8yMiAxNjozNCwgSm9oYW5uZXMgVGh1bXNoaXJu
IHdyb3RlOgo+Pj4+IE9uIDE5LzA1LzIwMjIgMDU6MTksIERhbWllbiBMZSBNb2FsIHdyb3RlOgo+
Pj4+PiBPbiA1LzE5LzIyIDEyOjEyLCBMdWlzIENoYW1iZXJsYWluIHdyb3RlOgo+Pj4+Pj4gT24g
VGh1LCBNYXkgMTksIDIwMjIgYXQgMTI6MDg6MjZQTSArMDkwMCwgRGFtaWVuIExlIE1vYWwgd3Jv
dGU6Cj4+Pj4+Pj4gT24gNS8xOC8yMiAwMDozNCwgVGhlb2RvcmUgVHMnbyB3cm90ZToKPj4+Pj4+
Pj4gT24gVHVlLCBNYXkgMTcsIDIwMjIgYXQgMTA6MTA6NDhBTSArMDIwMCwgQ2hyaXN0b3BoIEhl
bGx3aWcgd3JvdGU6Cj4+Pj4+Pj4+PiBJJ20gYSBsaXR0bGUgc3VycHJpc2VkIGFib3V0IGFsbCB0
aGlzIGFjdGl2aXR5Lgo+Pj4+Pj4+Pj4KPj4+Pj4+Pj4+IEkgdGhvdWdoIHRoZSBjb25jbHVzaW9u
IGF0IExTRi9NTSB3YXMgdGhhdCBmb3IgTGludXggaXRzZWxmIHRoZXJlCj4+Pj4+Pj4+PiBpcyB2
ZXJ5IGxpdHRsZSBiZW5lZml0IGluIHN1cHBvcnRpbmcgdGhpcyBzY2hlbWUuICBJdCB3aWxsIG1h
c3NpdmVseQo+Pj4+Pj4+Pj4gZnJhZ21lbnQgdGhlIHN1cHBvcnRlZCBiYXNlZCBvZiBkZXZpY2Vz
IGFuZCBhcHBsaWNhdGlvbnMsIHdoaWxlIG9ubHkKPj4+Pj4+Pj4+IGhhdmluZyB0aGUgYmVuZWZp
dCBvZiBzdXBwb3J0aW5nIHNvbWUgU2Ftc3VuZyBsZWdhY3kgZGV2aWNlcy4KPj4+Pj4+Pj4KPj4+
Pj4+Pj4gRldJVywKPj4+Pj4+Pj4KPj4+Pj4+Pj4gVGhhdCB3YXNuJ3QgbXkgaW1wcmVzc2lvbiBm
cm9tIHRoYXQgTFNGL01NIHNlc3Npb24sIGJ1dCBvbmNlIHRoZQo+Pj4+Pj4+PiB2aWRlb3MgYmVj
b21lIGF2YWlsYWJsZSwgZm9sa3MgY2FuIGRlY2lkZSBmb3IgdGhlbXNlbHZlcy4KPj4+Pj4+Pgo+
Pj4+Pj4+IFRoZXJlIHdhcyBubyByZWFsIGRpc2N1c3Npb24gYWJvdXQgem9uZSBzaXplIGNvbnN0
cmFpbnQgb24gdGhlIHpvbmUKPj4+Pj4+PiBzdG9yYWdlIEJvRi4gTWFueSBkaXNjdXNzaW9ucyBo
YXBwZW5lZCBpbiB0aGUgaGFsbHdheSB0cmFjayB0aG91Z2guCj4+Pj4+Pgo+Pj4+Pj4gUmlnaHQg
c28gbm8gZGlyZWN0IGNsZWFyIGJsb2NrZXJzIG1lbnRpb25lZCBhdCBhbGwgZHVyaW5nIHRoZSBC
b0YuCj4+Pj4+Cj4+Pj4+IE5vciBhbnkgY2xlYXIgT0suCj4+Pj4KPj4+PiBTbyB3aGF0IGFib3V0
IGNyZWF0aW5nIGEgZGV2aWNlLW1hcHBlciB0YXJnZXQsIHRoYXQncyB0YWtpbmcgbnBvMiBkcml2
ZXMgYW5kCj4+Pj4gbWFrZXMgdGhlbSBwbzIgZHJpdmVzIGZvciB0aGUgRlMgbGF5ZXJzPyBJdCB3
aWxsIGJlIHZlcnkgc2ltaWxhciBjb2RlIHRvCj4+Pj4gZG0tbGluZWFyLgo+Pj4KPj4+ICsxCj4+
Pgo+Pj4gVGhpcyB3aWxsIHNpbXBsaWZ5IHRoZSBzdXBwb3J0IGZvciBGU2VzLCBhdCBsZWFzdCBm
b3IgdGhlIGluaXRpYWwgZHJvcCAoaWYKPj4+IGFjY2VwdGVkKS4KPj4+Cj4+PiBBbmQgbW9yZSBp
bXBvcnRhbnRseSwgdGhpcyB3aWxsIGFsc28gYWxsb3cgYWRkcmVzc2luZyBhbnkgcG90ZW50aWFs
Cj4+PiBwcm9ibGVtIHdpdGggdXNlciBzcGFjZSBicmVha2luZyBiZWNhdXNlIG9mIHRoZSBub24g
cG93ZXIgb2YgMiB6b25lIHNpemUuCj4+Pgo+PiBTZWNvbmRlZCAob3IgbWF5YmUgdGhpcmRlZCku
Cj4+Cj4+IFRoZSBjaGFuZ2VzIHRvIHN1cHBvcnQgbnBvMiBpbiB0aGUgYmxvY2sgbGF5ZXIgYXJl
IHByZXR0eSBzaW1wbGUsIGFuZCAKPj4gcmVhbGx5IEkgZG9uJ3QgaGF2ZSBhbiBpc3N1ZSB3aXRo
IHRob3NlLgo+PiBUaGVuIGFkZGluZyBhIGRldmljZS1tYXBwZXIgdGFyZ2V0IHRyYW5zZm9ybWlu
ZyBucG8yIGRyaXZlcyBpbiBwbzIgCj4+IGJsb2NrIGRldmljZXMgc2hvdWxkIGJlIHByZXR0eSB0
cml2aWFsLgo+Pgo+PiBBbmQgb25jZSB0aGF0IGlzIGluIHlvdSBjYW4gc3RhcnQgYXJndWluZyB3
aXRoIHRoZSB0aGUgRlMgZm9sa3Mgb24gCj4+IHdoZXRoZXIgdG8gaW1wbGVtZW50IGl0IG5hdGl2
ZWx5Lgo+Pgo+IAo+IFNvIHlvdSBhcmUgc3VnZ2VzdGluZyBhZGRpbmcgc3VwcG9ydCBmb3IgIVBP
MiBpbiB0aGUgYmxvY2sgbGF5ZXIgYW5kCj4gdGhlbiBhIGRtIHRvIHByZXNlbnQgdGhlIGRldmlj
ZSBhcyBhIFBPMiB0byB0aGUgRlM/IFRoaXMgYXQgbGVhc3QKPiBhZGRyZXNzZXMgdGhlIGhvbGUg
aXNzdWUgZm9yIHJhdyB6b25lZCBibG9jayBkZXZpY2VzLCBzbyBpdCBjYW4gYmUgYQo+IGZpcnN0
IHN0ZXAuCgpZZXMsIGFuZCBpdCBhbHNvIGFsbG93cyBzdXBwb3J0aW5nIHRoZXNlIG5ldyAhcG8y
IGRldmljZXMgd2l0aG91dApyZWdyZXNzaW9ucyAocmVhZCBsYWNrIG9mKSBpbiB0aGUgc3VwcG9y
dCBhdCBGUyBsZXZlbC4KCj4gCj4gVGhpcyBzYWlkLCBpdCBzZWVtcyB0byBtZSB0aGF0IHRoZSBj
aGFuZ2VzIHRvIHRoZSBGUyBhcmUgbm90IGJlaW5nIGEKPiByZWFsIGlzc3VlLiBJbiBmYWN0LCB3
ZSBhcmUgZXhwb3Npbmcgc29tZSBidWdzIHdoaWxlIHdlIGdlbmVyYWxpemUgdGhlCj4gem9uZSBz
aXplIHN1cHBvcnQuCgpOb3QgYXJndWluZyB3aXRoIHRoYXQuIEJ1dCBzaW5jZSB3ZSBhcmUgc3Rp
bGwgc3RhYmlsaXppbmcgYnRyZnMgWk5TCnN1cHBvcnQsIGFkZGluZyBtb3JlIGNvZGUgcmlnaHQg
bm93IGlzIGEgbGl0dGxlIHBhaW5mdWwuCgo+IAo+IENvdWxkIHlvdSBwb2ludCBvdXQgd2hhdCB0
aGUgY2hhbGxlbmdlcyBpbiBidHJmcyBhcmUgaW4gdGhlIGN1cnJlbnQKPiBwYXRjaGVzLCB0aGF0
IGl0IG1ha2VzIHNlbnNlIHRvIGFkZCBhbiBleHRyYSBkbSBsYXllcj8KClNlZSBhYm92ZS4gTm8g
cmVhbCBjaGFsbGVuZ2UsIGp1c3QgbmVlZHMgdG8gYmUgZG9uZSBpZiBhIGNsZWFyIGFncmVlbWVu
dApjYW4gYmUgcmVhY2hlZCBvbiB6b25lIHNpemUgYWxpZ25tZW50IGNvbnN0cmFpbnRzLiBBcyBt
ZW50aW9uZWQgYWJvdmUsIHRoZQpidHJmcyBjaGFuZ2VzIHRpbWluZyBpcyBub3QgaWRlYWwgcmln
aHQgbm93IHRob3VnaC4KCkFsc28gcGxlYXNlIGRvIG5vdCBmb3JnZXQgYXBwbGljYXRpb25zIHRo
YXQgbWF5IGV4cGVjdCBhIHBvd2VyIG9mIDIgem9uZQpzaXplLiBBIGRtLXpzcDIgd291bGQgYmUg
YSBuaWNlIHNvbHV0aW9uIGZvciB0aGVzZS4gU28gcmVnYXJkbGVzcyBvZiB0aGUKRlMgd29yaywg
dGhhdCBuZXcgRE0gdGFyZ2V0IHdpbGwgYmUgKnZlcnkqIG5pY2UgdG8gaGF2ZS4KCj4gCj4gTm90
ZSB0aGF0IGZvciBGMkZTIHRoZXJlIGlzIG5vIGJsb2NrZXIuIEphZWdldWsgcGlja2VkIHRoZSBp
bml0aWFsCj4gcGF0Y2hlcywgYW5kIGhlIGFncmVlZCB0byBhZGQgbmF0aXZlIHN1cHBvcnQuCgpB
bmQgdW50aWwgdGhhdCBpcyBkb25lLCBmMmZzIHdpbGwgbm90IHdvcmsgd2l0aCB0aGVzZSBuZXcg
IXBvMiBkZXZpY2VzLi4uCkhhdmluZyB0aGUgbmV3IGRtIHdpbGwgYXZvaWQgdGhhdCBzdXBwb3J0
IGZyYWdtZW50YXRpb24gd2hpY2ggSSBwZXJzb25hbGx5CnJlYWxseSBkaXNsaWtlLiBXaXRoIHRo
ZSBuZXcgZG0sIHdlIGNhbiBrZWVwIHN1cHBvcnQgZm9yICphbGwqIHpvbmVkIGJsb2NrCmRldmlj
ZXMsIGFsYmVpdCBuZWVkaW5nIGEgZGlmZmVyZW50IHNldHVwIGRlcGVuZGluZyBvbiB0aGUgZGV2
aWNlLiBUaGF0IGlzCm5vdCBuaWNlIGF0IGFsbCBidXQgYXQgbGVhc3QgdGhlcmUgaXMgYSB3YXkg
dG8gbWFrZSB0aGluZ3Mgd29yayBjb250aW51b3VzbHkuCgotLSAKRGFtaWVuIExlIE1vYWwKV2Vz
dGVybiBEaWdpdGFsIFJlc2VhcmNoCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxA
cmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVsCg==

