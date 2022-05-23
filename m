Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B9C6C4321E
	for <dm-devel@archiver.kernel.org>; Mon, 23 May 2022 08:25:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-IAKhDzGeORS1Td4v9BkiFQ-1; Mon, 23 May 2022 04:25:39 -0400
X-MC-Unique: IAKhDzGeORS1Td4v9BkiFQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 881C13AF42A2;
	Mon, 23 May 2022 08:25:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A71DD2026D6A;
	Mon, 23 May 2022 08:25:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 663F5194705A;
	Mon, 23 May 2022 08:25:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5D06B1947059
 for <dm-devel@listman.corp.redhat.com>; Mon, 23 May 2022 08:25:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 481AA1121319; Mon, 23 May 2022 08:25:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 432AA1121314
 for <dm-devel@redhat.com>; Mon, 23 May 2022 08:25:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28746811E76
 for <dm-devel@redhat.com>; Mon, 23 May 2022 08:25:33 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-494-QS1g12RkOPSjFCG9fgUu9A-1; Mon, 23 May 2022 04:25:30 -0400
X-MC-Unique: QS1g12RkOPSjFCG9fgUu9A-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220523082529euoutp01d0fb407e745411fe78cd6c2a924b60ce~xrm7rbGDh1786117861euoutp01f
 for <dm-devel@redhat.com>; Mon, 23 May 2022 08:25:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220523082529euoutp01d0fb407e745411fe78cd6c2a924b60ce~xrm7rbGDh1786117861euoutp01f
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220523082529eucas1p16589ffdf204dbfad55d0aefbf2f68dc4~xrm7SFYkL1415614156eucas1p1n;
 Mon, 23 May 2022 08:25:29 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id AD.47.10260.9F44B826; Mon, 23
 May 2022 09:25:29 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220523082528eucas1p154de304dc76b15b99d571399400530f3~xrm6ymVAt2444124441eucas1p1a;
 Mon, 23 May 2022 08:25:28 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220523082528eusmtrp2fe33f2de7b5f28c5c3c8fa8198f3e58b~xrm6xlJgz1491314913eusmtrp2F;
 Mon, 23 May 2022 08:25:28 +0000 (GMT)
X-AuditID: cbfec7f5-bddff70000002814-7d-628b44f9a9ab
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 1B.D1.09522.8F44B826; Mon, 23
 May 2022 09:25:28 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220523082528eusmtip137c716859f4c05ff6297ff5668064f79~xrm6ktjUt2896028960eusmtip1F;
 Mon, 23 May 2022 08:25:28 +0000 (GMT)
Received: from [106.110.32.130] (106.110.32.130) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Mon, 23 May 2022 09:25:23 +0100
Message-ID: <43bac47d-5ef6-2b6c-e747-58e5a2fb7b52@samsung.com>
Date: Mon, 23 May 2022 10:25:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
To: <dsterba@suse.cz>, Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier.gonz@samsung.com>, Hannes Reinecke
 <hare@suse.de>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Mike
 Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, Luis
 Chamberlain <mcgrof@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
 "axboe@kernel.dk" <axboe@kernel.dk>, "pankydev8@gmail.com"
 <pankydev8@gmail.com>, "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "jiangbo.365@bytedance.com" <jiangbo.365@bytedance.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, "dsterba@suse.com"
 <dsterba@suse.com>, "linux-btrfs@vger.kernel.org"
 <linux-btrfs@vger.kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Keith Busch
 <kbusch@kernel.org>, Adam Manzanares <a.manzanares@samsung.com>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <20220520171830.GR18596@twin.jikos.cz>
X-Originating-IP: [106.110.32.130]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0xbVRzHPbeXey+NhbuC4YSxqnXOiFpqIMtJ9tB1GK5PmBofxMjuypU1
 K2VpV3yQRZiWt8BKgllhlDDdsN1ESwF5TVYpjNC6aWEryMbMYI/ihgiMlQq49m6G/z6/8/t+
 c77fk0MJxEVELKXSHOC0GlYtJYR4W7//3HP+5LI98qPjBLJeqiRQwH1OgHpu14ah83cLMHQs
 sIij7kYjhr6zOjE02WwSoPLev3G0XHoZQ0bHBYB6xp5Bv19tIlF3zyCOPJ11BDIfnyKRt2oK
 oJOjUzgq/HEBIEO5n3wxmlk5e5JgOkyXSMbj1jM2SwnBtHzzOdM1mk8wh1xOAdNhmAhjZk6P
 EEyzfQRnXA19JNMylMfM2SRMUW8ZlhaRLtyayalVuZw2Yftu4V6v5xDYb8Q/mXGcCMsHxwSl
 IJyCdBI0X5vES4GQEtNNAN6x+jF+mAdwZtQcxg9zAJ6Z7sEfWFar/yX4xQkAb7prif9VluVV
 kh+6AJydrQlZRPR2aJswEEHG6SehvaKY4M/XwcEjkyHNI/R7sMbkCp1H0anwcOd4iAV0DByb
 NIdCRdOtFDzfVn3vBooi6HhYUEIGNeF0Irx85SrJ65+GhvbAfX4Utt+qEwTlkJbCWo+Mb3AQ
 nup3hXJC+ogQmk934bwmGfbVR/KaKOgbsJM8x8HVjmCEIOfBKW9AwHu/BLCyo5ngvVtghUvN
 4w5Y4NzFYwT03lrHh4mAxrav74cRweJCcRXYaFrzDKY1dU1rqpjWVGkAuAXEcHpddhanS9Rw
 H8t0bLZOr8mSKXOybeDeXx1aGVj4CTT5ZmUOgFHAASAlkEaL2tniPWJRJvvpZ5w2J0OrV3M6
 B1hP4dIYkVL1Ayums9gD3D6O289pH2wxKjw2HzMoMi+Ul2iM7upX0x7u9n7R+tjC7jnJ98Nx
 yhtv/jkY7yl4Ac4ffv8lyZZtVUs+e/1D/fa4LDixil3Ji60Fv+0cWOp+x9t7UaV+vGR69on1
 9b4PkpMWG1ZsAXbDrkLwbq5s5PpMZ0oGWdmfUHNcuWKR30j9ZXORzbIvY975lPG1zXfdMuWO
 wVSV9Lr7muLlXO/trz5K23hzvMI3YZSnWH9NX8xpbmwcfns5SZstCf/DZrRfvKNjWvuc3NlM
 keLZKGyo7pV5xwbVwb/Gf27Vp06/Jdw0lPLPGC45sy1yk/DoG5HTO7fKxz70JyhfbymzwsXK
 JaX8VP6wIrExQVE5zH6rTJfiur3s8/ECrY79Dy66qUsaBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t/xu7o/XLqTDC5+UrRYfbefzeL32fPM
 FnvfzWa1uPCjkcli8e/vLBZ7Fk1isli5+iiTxZP1s5gteg58YLH423WPyWLSoWuMFntvaVtc
 eryC3WLP3pMsFpd3zWGzmL/sKbvFjQlPGS3W3HzKYtG28SujRWvPT3YHEY9/J9aweeycdZfd
 4/LZUo9NqzrZPDYvqffYfbOBzaPpzFFmj52t91k93u+7yuaxfstVFo8zC46we2w+Xe3xeZOc
 R/uBbqYAvig9m6L80pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNTJX07m5TUnMyy1CJ9
 uwS9jBuXmxgLJrFUvD+0nLWBcTFzFyMnh4SAicT/yX/Yuhi5OIQEljJKzDp1jBEiISPx6cpH
 dghbWOLPtS6ooo+MEvumHmUCSQgJ7GaU6FshB2LzCthJbLrfygZiswioSmzp62CDiAtKnJz5
 hAXEFhWIkHiw+ywriC0s4CtxdcobsDizgLjErSfzmUAWiAhs5pD49W8Z1IItrBIvX+Z1MXJw
 sAloSTR2gh3EKWAsce/BY3aIXk2J1u2/oWx5ie1v5zCDlEsIKEnMvqwHcX+txKv7uxknMIrM
 QnLRLCSbZyGZNAvJpAWMLKsYRVJLi3PTc4sN9YoTc4tL89L1kvNzNzEC0862Yz8372Cc9+qj
 3iFGJg7GQ4wSHMxKIrzbEzuShHhTEiurUovy44tKc1KLDzGaAoNlIrOUaHI+MPHllcQbmhmY
 GpqYWRqYWpoZK4nzehZ0JAoJpCeWpGanphakFsH0MXFwSjUwxe17x7rj/5vnH5fG9B80T49V
 MX0zYfXp/e7Bs+y9lk3//vFU8l+WfX2xZ5cvPV76p0pb99ieS9pTK38pezHJfV4YuKl8lXPj
 UxvbjE7NCtU5/9s37jL5mLR+SkcRr7Be/6Pv1h/k4yX/Lj0VL+pjvH3jzSaNWJ7Vs6cv+HH4
 4dVLiy/k5Tg9mZKm9+ZoZPCZSC/bB3/NZZ4miFUeO9xafesCa9CrugdLTgdu+WrI1TLjUvEU
 jeyNte2OH1kZlrOv22NxScJ+tsoXIW/1jfv0Vvkosf/kjt0uf/S5+g7fAG77HXp+KbP3PKuN
 2LaRa9euN/eMH308WmH35q2Ixc+Atk7ul4ey6xwZTU5+PX2wTkOJpTgj0VCLuag4EQB2tdxI
 xAMAAA==
X-CMS-MailID: 20220523082528eucas1p154de304dc76b15b99d571399400530f3
X-Msg-Generator: CA
X-RootMTR: 20220520172257eucas1p1b94b150d71352587ced5d46b8c3f3537
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220520172257eucas1p1b94b150d71352587ced5d46b8c3f3537
References: <YoPAnj9ufkt5nh1G@mit.edu>
 <7f9cb19b-621b-75ea-7273-2d2769237851@opensource.wdc.com>
 <20220519031237.sw45lvzrydrm7fpb@garbanzo>
 <69f06f90-d31b-620b-9009-188d1d641562@opensource.wdc.com>
 <PH0PR04MB74166C87F694B150A5AE0F009BD09@PH0PR04MB7416.namprd04.prod.outlook.com>
 <4a8f0e1b-0acb-1ed4-8d7a-c9ba93fcfd02@opensource.wdc.com>
 <16f3f9ee-7db7-2173-840c-534f67bcaf04@suse.de>
 <20220520062720.wxdcp5lkscesppch@mpHalley-2.localdomain>
 <be429864-09cb-e3fb-2afe-46a3453c4d73@opensource.wdc.com>
 <aee22e8a-b89b-378c-3d5b-238c1215b01d@samsung.com>
 <CGME20220520172257eucas1p1b94b150d71352587ced5d46b8c3f3537@eucas1p1.samsung.com>
 <20220520171830.GR18596@twin.jikos.cz>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/20/22 19:18, David Sterba wrote:
>> I see that many people in the community feel it is better to target the
>> dm layer for the initial support of npo2 devices. I can give it a shot
>> and maintain a native out-of-tree support for FSs for npo2 devices and
>> merge it upstream as we see fit later.
> 
> Some of the changes from your patchset are cleanups or abstracting the
> alignment and zone calculations, so this can be merged to minimize the
> out of tree code.
Sounds good. I will send it separately. Thanks.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

