Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C663C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 20 May 2022 03:48:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-Q_UI6Ee6PUeZDMaj4I6oaw-1; Thu, 19 May 2022 23:48:20 -0400
X-MC-Unique: Q_UI6Ee6PUeZDMaj4I6oaw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C56AD802A5B;
	Fri, 20 May 2022 03:48:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DE56840CF8F5;
	Fri, 20 May 2022 03:48:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B6C08194705A;
	Fri, 20 May 2022 03:48:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1AD701947058
 for <dm-devel@listman.corp.redhat.com>; Fri, 20 May 2022 03:48:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0BA57C4C7CD; Fri, 20 May 2022 03:48:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 07C4DC4C7C7
 for <dm-devel@redhat.com>; Fri, 20 May 2022 03:48:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E3BC5811E75
 for <dm-devel@redhat.com>; Fri, 20 May 2022 03:48:15 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-508-k-BiFroBOJ6EOeuaqh9vDA-1; Thu, 19 May 2022 23:47:10 -0400
X-MC-Unique: k-BiFroBOJ6EOeuaqh9vDA-1
X-IronPort-AV: E=Sophos;i="5.91,238,1647273600"; d="scan'208";a="201724465"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 20 May 2022 11:47:09 +0800
IronPort-SDR: ItVvpX1vDYjC8K7/1Z5krtMUlBciBAEwcplf6utZewGey+1WLDqkoMAeZfw1n9ytuZNdOsbsIp
 Slj7DNmp1YIpEwvVOv0rq85S1qGt8NEnXU3e7Oq6R714Ez+hPaEZOlIwLq9kiA00yHg4fQo7H9
 inTdbSUeME0nHdPMBIXHMRmFAfdkFREbKpKdcsEWEuVinYpHiYUTTM55DnRyGcpyxLhKa3HMrR
 +nn1ucf6K6Cz8EbSw4AObp9rYZEjslQgryX4zjUIT2nc5c2RjJNBcMgtOSSuJlvvjQjylDriuZ
 jDLRXMFWz9XHmCoraxinwVbn
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 19 May 2022 20:09:59 -0700
IronPort-SDR: m47rM30AalSDwbfxdZGQTopnNYQRTw/cQ2jimvO+ixfAv3DjfcFY40JK91tElkdtu+MmcM5hfR
 9ZMzDJNX+2vOPcHYOHx3kl0U8yHMetShaaGJ15p/AuU+WOU4C1R+8TdTUKBorlbzrQrkXIXL4C
 PwvPYytuWIS8HSn5vBN7FaRFbTNLXtOtZZtsLhBSbOlnsWpgGwpQKxG+XfpAoUcHmkapBqabaC
 x+bOJwjyuP/8CUNZGZgtL+E2KU3qd0dw0tcTgCE0c6J2q1ghqSRFGz0h6s5XQbWYd027+UbCuq
 Fjo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 19 May 2022 20:47:09 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4L4CMw1hYYz1SHwl
 for <dm-devel@redhat.com>; Thu, 19 May 2022 20:47:07 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id XuXaNe5-vyvP for <dm-devel@redhat.com>;
 Thu, 19 May 2022 20:47:07 -0700 (PDT)
Received: from [10.225.163.45] (unknown [10.225.163.45])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4L4CMr5cBWz1Rvlc;
 Thu, 19 May 2022 20:47:04 -0700 (PDT)
Message-ID: <4a8f0e1b-0acb-1ed4-8d7a-c9ba93fcfd02@opensource.wdc.com>
Date: Fri, 20 May 2022 12:47:03 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 Luis Chamberlain <mcgrof@kernel.org>
References: <CGME20220516165418eucas1p2be592d9cd4b35f6b71d39ccbe87f3fef@eucas1p2.samsung.com>
 <20220516165416.171196-1-p.raghav@samsung.com>
 <20220517081048.GA13947@lst.de> <YoPAnj9ufkt5nh1G@mit.edu>
 <7f9cb19b-621b-75ea-7273-2d2769237851@opensource.wdc.com>
 <20220519031237.sw45lvzrydrm7fpb@garbanzo>
 <69f06f90-d31b-620b-9009-188d1d641562@opensource.wdc.com>
 <PH0PR04MB74166C87F694B150A5AE0F009BD09@PH0PR04MB7416.namprd04.prod.outlook.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <PH0PR04MB74166C87F694B150A5AE0F009BD09@PH0PR04MB7416.namprd04.prod.outlook.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/19/22 16:34, Johannes Thumshirn wrote:
> On 19/05/2022 05:19, Damien Le Moal wrote:
>> On 5/19/22 12:12, Luis Chamberlain wrote:
>>> On Thu, May 19, 2022 at 12:08:26PM +0900, Damien Le Moal wrote:
>>>> On 5/18/22 00:34, Theodore Ts'o wrote:
>>>>> On Tue, May 17, 2022 at 10:10:48AM +0200, Christoph Hellwig wrote:
>>>>>> I'm a little surprised about all this activity.
>>>>>>
>>>>>> I though the conclusion at LSF/MM was that for Linux itself there
>>>>>> is very little benefit in supporting this scheme.  It will massively
>>>>>> fragment the supported based of devices and applications, while only
>>>>>> having the benefit of supporting some Samsung legacy devices.
>>>>>
>>>>> FWIW,
>>>>>
>>>>> That wasn't my impression from that LSF/MM session, but once the
>>>>> videos become available, folks can decide for themselves.
>>>>
>>>> There was no real discussion about zone size constraint on the zone
>>>> storage BoF. Many discussions happened in the hallway track though.
>>>
>>> Right so no direct clear blockers mentioned at all during the BoF.
>>
>> Nor any clear OK.
> 
> So what about creating a device-mapper target, that's taking npo2 drives and
> makes them po2 drives for the FS layers? It will be very similar code to 
> dm-linear.

+1

This will simplify the support for FSes, at least for the initial drop (if
accepted).

And more importantly, this will also allow addressing any potential
problem with user space breaking because of the non power of 2 zone size.

> 
> After all zoned support for FSes started with a device-mapper (dm-zoned) and 
> as the need for a more integrated solution arose, it changed into natiive
> support.
> 
> And all that is there is simple arithmetic and a bio_clone(), if this is the
> slowest part of the stack involving a FS like f2fs or btrfs I'm throwing a
> round of anyone's favorite beverage at next year's LSFMM.
> 
> Byte,
> 	Johannes
> 


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

