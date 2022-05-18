Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13DA7C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 18 May 2022 09:16:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-6zNzZeYcMZ2RTGTvBryoYg-1; Wed, 18 May 2022 05:16:04 -0400
X-MC-Unique: 6zNzZeYcMZ2RTGTvBryoYg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C7EC8032E5;
	Wed, 18 May 2022 09:16:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D37F42026D6A;
	Wed, 18 May 2022 09:16:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9F9CC1947B8F;
	Wed, 18 May 2022 09:16:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C86D41947B84
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 May 2022 09:16:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 800E81410DD9; Wed, 18 May 2022 09:16:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B6721410DD5
 for <dm-devel@redhat.com>; Wed, 18 May 2022 09:16:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E43BA3C16191
 for <dm-devel@redhat.com>; Wed, 18 May 2022 09:16:00 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-245-0AIJZ8ZzPlKOF8OuDVUomw-1; Wed, 18 May 2022 05:15:58 -0400
X-MC-Unique: 0AIJZ8ZzPlKOF8OuDVUomw-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220518091556euoutp01ff5dd3f7a0ece8c771aaac4cf41b794e~wKEjcfvf51824018240euoutp01i
 for <dm-devel@redhat.com>; Wed, 18 May 2022 09:15:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220518091556euoutp01ff5dd3f7a0ece8c771aaac4cf41b794e~wKEjcfvf51824018240euoutp01i
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220518091556eucas1p23fa8121f563bd4cdb43b27949f0bacba~wKEi8vgjM1876518765eucas1p2c;
 Wed, 18 May 2022 09:15:56 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 92.DD.10009.B49B4826; Wed, 18
 May 2022 10:15:56 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220518091555eucas1p16a9ead30703054b30e76c2227cd4f629~wKEid_GJl2284822848eucas1p1W;
 Wed, 18 May 2022 09:15:55 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220518091555eusmtrp1e75ce65f06f2fb713ae2679ccd687280~wKEidEsht1304613046eusmtrp1J;
 Wed, 18 May 2022 09:15:55 +0000 (GMT)
X-AuditID: cbfec7f2-e7fff70000002719-42-6284b94b8d52
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 72.98.09522.B49B4826; Wed, 18
 May 2022 10:15:55 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20220518091555eusmtip2b2f3d735ee7a617445733660bddd54a0~wKEiS6z1b0225002250eusmtip2Y;
 Wed, 18 May 2022 09:15:55 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.7) by CAMSVWEXC01.scsc.local
 (106.1.227.71) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 May
 2022 10:15:53 +0100
Message-ID: <717a2c83-0678-9310-4c75-9ad5da0472f6@samsung.com>
Date: Wed, 18 May 2022 11:15:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
To: <dsterba@suse.cz>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <20220517124257.GD18596@twin.jikos.cz>
X-Originating-IP: [106.210.248.7]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (106.1.227.71) To
 CAMSVWEXC01.scsc.local (106.1.227.71)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsWy7djP87o+O1uSDHbdYLRYfbefzeL32fPM
 FnvfzWa1uPCjkcli8e/vLBYrVx9lsug58IHFYu8tbYtLj1ewW+zZe5LF4vKuOWwW85c9ZbdY
 c/MpiwOvx78Ta9g8ds66y+5x+Wypx+Yl9R67bzYARVrvs3q833eVzWP9lqssHmcWHGH3+LxJ
 LoArissmJTUnsyy1SN8ugStjX/MjtoLFChXnvs5jbWBcINnFyMkhIWAisfHvUdYuRi4OIYEV
 jBLbO2+yQzhfGCWW3VvHAuF8ZpQ48echO0zLmjOXmSASyxkl7s8+zQ5X9fT1QyhnDaPEiw33
 gPo5OHgF7CQWLNcD6WYRUJXYMqeXFcTmFRCUODnzCQuILSoQITFt1hk2kHJhgRSJHSuLQMLM
 AuISt57MZwKxRQREJS7tXwF2EbPASyaJ47+PsYPUswloSTR2gh3HKWAs0XDwAjtEr6ZE6/bf
 ULa8xPa3c5ghHlCUuLnyF9gqCYFkiQ0zwyDClzgl7j0KhbBdJCYfWMMKYQtLvDq+Bep3GYnT
 k3tYIOxqiac3fjODnCMh0MIo0b9zPdRMa4m+MzkQNY4Sl759ZoYI80nceCsIcQ2fxKRt05kn
 MKrOQgqHWUgenoXkgVlIHljAyLKKUTy1tDg3PbXYMC+1XK84Mbe4NC9dLzk/dxMjMNWd/nf8
 0w7Gua8+6h1iZOJgPMQowcGsJMLLmNuSJMSbklhZlVqUH19UmpNafIhRmoNFSZw3OXNDopBA
 emJJanZqakFqEUyWiYNTqoGpcsfk6tJ7W67wfGafVl50gely/u6izlUf3/82Nb169KSz/4TH
 Zrb8a9wb/L7G+D7ZVmttd8cu2jfghIxryJv+rZw8Jpwv4g1cGc7tvWy71PtYcPPcb2uKN3P0
 /hTZ6T6lZuWs3/uPrD5/tH+a2JTzF3ZmSLLplTT8kp7w927P1uUnUtrm839V1j4tsHR1wbcz
 VdM+La5rvsHj88Kre9lvC40Tzv++vLHOLzuQbHL9V6jtpg0sTaIHjpgF8FToRKyaIXNOnJtF
 cq6Y6KoPqxg+1O/fLq5SM0E6XNKxb8Hy670nrKZlTxJrMbgsGaC3dXVhlN5WBh7Z2Y+jr8Vr
 tv3jaevV53/E1BXrsC52fYSPEktxRqKhFnNRcSIAGQTGuOQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e/4PV3vnS1JBg9fyFmsvtvPZvH77Hlm
 i73vZrNaXPjRyGSx+Pd3FouVq48yWfQc+MBisfeWtsWlxyvYLfbsPclicXnXHDaL+cueslus
 ufmUxYHX49+JNWweO2fdZfe4fLbUY/OSeo/dNxuAIq33WT3e77vK5rF+y1UWjzMLjrB7fN4k
 F8AVpWdTlF9akqqQkV9cYqsUbWhhpGdoaaFnZGKpZ2hsHmtlZKqkb2eTkpqTWZZapG+XoJex
 r/kRW8FihYpzX+exNjAukOxi5OSQEDCRWHPmMlMXIxeHkMBSRokdDd1sEAkZiU9XPrJD2MIS
 f651sUEUfWSUaDr8EapjDaPE6a4zQBkODl4BO4kFy/VAGlgEVCW2zOllBbF5BQQlTs58wgJi
 iwpESDzYfRYsLiyQIvHo02wwm1lAXOLWk/lMILaIgKjEpf0rWCDmv2CUeN36jR3EYRZ4ySRx
 /PcxdpBlbAJaEo2dYNdxChhLNBy8wA4xSFOidftvKFteYvvbOcwQHyhK3Fz5C+xOCYFkib+3
 wicwis5Cct4sJGfMQjJpFpJJCxhZVjGKpJYW56bnFhvqFSfmFpfmpesl5+duYgQmiW3Hfm7e
 wTjv1Ue9Q4xMHIyHGCU4mJVEeBlzW5KEeFMSK6tSi/Lji0pzUosPMZoCw2gis5Rocj4wTeWV
 xBuaGZgamphZGphamhkrifN6FnQkCgmkJ5akZqemFqQWwfQxcXBKNTDN5TY72SWRv227Oh/f
 oYt8Uzln1+y2P3i2dL9whL+KznKXMvHlqx93vpbITjjZtC/pS2HDy49sL0X5pBqeSdzeyJv/
 qCF5X9mLuh8bE9eXKFyqToxlUf1yW/1fR3HKjEatnhN/n66WNU31ORK97u3GyL7XTt8fr77h
 8/s0Cxdf/Cuh84HcHtMr1r64eb69pivIwGTm4wyVU1fvHvrDEiFaGTJl+qTJpSlrS1fcVeiK
 5f0/59vpK+wvbcOc5hv83N+7mPP3aWWmixJ3fwo/2Wj3WHLFsscc7x9P1p+fsHHz6bfKshE3
 t7T1cAdwNjHKv28Ped6dmLw8vWKaKdvprWplGyaczJgv8PtmoknDmS03lFiKMxINtZiLihMB
 g5KR95sDAAA=
X-CMS-MailID: 20220518091555eucas1p16a9ead30703054b30e76c2227cd4f629
X-Msg-Generator: CA
X-RootMTR: 20220516165429eucas1p272c8b4325a488675f08f2d7016aa6230
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220516165429eucas1p272c8b4325a488675f08f2d7016aa6230
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165429eucas1p272c8b4325a488675f08f2d7016aa6230@eucas1p2.samsung.com>
 <20220516165416.171196-9-p.raghav@samsung.com>
 <20220517124257.GD18596@twin.jikos.cz>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v4 08/13] btrfs:zoned: make sb for npo2 zone
 devices align with sb log offsets
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
Cc: axboe@kernel.dk, pankydev8@gmail.com, gost.dev@samsung.com,
 damien.lemoal@opensource.wdc.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 dm-devel@redhat.com, dsterba@suse.com, hch@lst.de, linux-btrfs@vger.kernel.org
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

On 2022-05-17 14:42, David Sterba wrote:
> On Mon, May 16, 2022 at 06:54:11PM +0200, Pankaj Raghav wrote:
>> Superblocks for zoned devices are fixed as 2 zones at 0, 512GB and 4TB.
>> These are fixed at these locations so that recovery tools can reliably
>> retrieve the superblocks even if one of the mirror gets corrupted.
>>
>> power of 2 zone sizes align at these offsets irrespective of their
>> value but non power of 2 zone sizes will not align.
>>
>> To make sure the first zone at mirror 1 and mirror 2 align, write zero
>> operation is performed to move the write pointer of the first zone to
>> the expected offset. This operation is performed only after a zone reset
>> of the first zone, i.e., when the second zone that contains the sb is FULL.
> 
> Is it a good idea to do the "write zeros", instead of a plain "set write
> pointer"? I assume setting write pointer is instant, while writing
> potentially hundreds of megabytes may take significiant time. As the
> functions may be called from random contexts, the increased time may
> become a problem.
> 
Unfortunately it is not possible to just move the WP in zoned devices.
The only alternative that I could use is to do write zeroes which are
natively supported by some devices such as ZNS. It would be nice to know
if someone had a better solution to this instead of doing write zeroes
in zoned devices.

>> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
>> ---
>>  fs/btrfs/zoned.c | 68 ++++++++++++++++++++++++++++++++++++++++++++----
>>  1 file changed, 63 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
>> index 3023c871e..805aeaa76 100644
>> --- a/fs/btrfs/zoned.c
>> +++ b/fs/btrfs/zoned.c
>> @@ -760,11 +760,44 @@ int btrfs_check_mountopts_zoned(struct btrfs_fs_info *info)
>>  	return 0;
>>  }
>>  
>> +static int fill_sb_wp_offset(struct block_device *bdev, struct blk_zone *zone,
>> +			     int mirror, u64 *wp_ret)
>> +{
>> +	u64 offset = 0;
>> +	int ret = 0;
>> +
>> +	ASSERT(!is_power_of_two_u64(zone->len));
>> +	ASSERT(zone->wp == zone->start);
>> +	ASSERT(mirror != 0);
> 
> This could simply accept 0 as the mirror offset too, the calculation is
> trivial.
> 
Ok. I will fix it up!
>> +
>> +	switch (mirror) {
>> +	case 1:
>> +		div64_u64_rem(BTRFS_SB_LOG_FIRST_OFFSET >> SECTOR_SHIFT,
>> +			      zone->len, &offset);
>> +		break;
>> +	case 2:
>> +		div64_u64_rem(BTRFS_SB_LOG_SECOND_OFFSET >> SECTOR_SHIFT,
>> +			      zone->len, &offset);
>> +		break;
>> +	}
>> +
>> +	ret =  blkdev_issue_zeroout(bdev, zone->start, offset, GFP_NOFS, 0);
>> +	if (ret)
>> +		return ret;
>> +
>> +		/*
>> +		 * Non po2 zone sizes will not align naturally at
>> +		 * mirror 1 (512GB) and mirror 2 (4TB). The wp of the
>> +		 * 1st zone in those superblock mirrors need to be
>> +		 * moved to align at those offsets.
>> +		 */
> 
> Please move this comment to the helper fill_sb_wp_offset itself, there
> it's more discoverable.
> 
Ok.
>> +		is_sb_offset_write_req =
>> +			(zones_empty || (reset_zone_nr == 0)) && mirror &&
>> +			!is_power_of_2(zones[0].len);
> 
> Accepting 0 as the mirror number would also get rid of this wild
> expression substituting and 'if'.
> 
>>  
>>  		if (reset && reset->cond != BLK_ZONE_COND_EMPTY) {
>>  			ASSERT(sb_zone_is_full(reset));
>> @@ -795,6 +846,13 @@ static int sb_log_location(struct block_device *bdev, struct blk_zone *zones,
>>  			reset->cond = BLK_ZONE_COND_EMPTY;
>>  			reset->wp = reset->start;
>>  		}
>> +
>> +		if (is_sb_offset_write_req) {
> 
> And get rid of the conditional. The point of supporting both po2 and
> nonpo2 is to hide any implementation details to wrappers as much as
> possible.
> 
Alright. I will move the logic to the wrapper instead of having the
conditional in this function.
>> +			ret = fill_sb_wp_offset(bdev, &zones[0], mirror, &wp);
>> +			if (ret)
>> +				return ret;
>> +		}
>> +
>>  	} else if (ret != -ENOENT) {
>>  		/*
>>  		 * For READ, we want the previous one. Move write pointer to
Thanks for your comments.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

