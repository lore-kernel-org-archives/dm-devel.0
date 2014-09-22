From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Thinly-Provisioned Logical Volumes
Date: Mon, 22 Sep 2014 09:02:23 +0200
Message-ID: <541FC97F.9050700@redhat.com>
References: alpine.LRH.2.02.1409171425060.15315@file01.intranet.prod.int.rdu2.redhat.com
	<b3abf2cc-2219-4b5a-b546-5f71301c40e4@aliyun.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <b3abf2cc-2219-4b5a-b546-5f71301c40e4@aliyun.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lilofile <lilofile@aliyun.com>, device-mapper development <dm-devel@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Ondrej Kozina <okozina@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Dne 20.9.2014 v 16:19 lilofile napsal(a):
> when I test Thinly-Provisioned Logical Volumes(use device thinprovison target),I found the random write performance is very low. What factors will influence the random write performance of  thin volume. how can i quickly understand dm-bufio.c?
>


In general 2 major factors -

1. - size of chunk/(provisioned block)

the bigger the block is - the better usually filesystem performs - since the 
all the aggregation logic and optimization of fs works.

on the other - the bigger the block is - the less efficient snapshot you get
(since much bigger chunk needs to be copied for i.e. single byte write)


2. - zeroing on provisionsing.

when the block provisioned for the first time - it's (by default config) fully 
zeroes - so you don't get random disk content from unwritten areas.

If you don't care about this - you could safely disable zeroing - number of 
filesystem usually already manages unwritten space well so if you use block 
device for ext4 so shouldn't normally be able to read unwritten areas.


So please try i.e.  256KB chunk size with non-zeroing (-c 256 -Zn) when 
creating thin-pool  -  do you still fell you get poor performance ?

Zdenek


NOTE: you could change zeroing with existing pool, but not your thin-pool 
chunk size for now (though future version might be less restrictive here).
