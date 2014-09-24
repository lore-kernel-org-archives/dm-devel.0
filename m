From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re:
 =?utf-8?q?reply=EF=BC=9A_Thinly-Provisioned_Logical_Vo?=
 =?utf-8?q?lumes?=
Date: Wed, 24 Sep 2014 09:02:40 +0200
Message-ID: <54226C90.4080305@redhat.com>
References: alpine.LRH.2.02.1409171425060.15315@file01.intranet.prod.int.rdu2.redhat.com	<b3abf2cc-2219-4b5a-b546-5f71301c40e4@aliyun.com>,
	541FC97F.9050700@redhat.com	<7adc0384-473b-41da-8ae0-08ee4b436388@aliyun.com>,
	54217EA6.1010408@redhat.com
	<ae586129-fc3a-41fe-8f2e-f3124c5ff58d@aliyun.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ae586129-fc3a-41fe-8f2e-f3124c5ff58d@aliyun.com>
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

Dne 24.9.2014 v 04:11 lilofile napsal(a):
> When I test thinly-provisioned logical volumes,I use dd if=/dev/zero of=/dev/mapper/mythinvolume count=1 bs=4k
> I only write 4k data in mythinvolume.but In thin_map functions, I found there are really  4K data written,but I found more read IO,probably dozens of read io. who issue these IO?
>

Hi

I'd have guessed those I/O are likely metadata update related - at most every 
second metadata are synchronized to your metadata storage volume.
(Thin pool consists of _tdata data volume where provisioned chunks are located 
and _tmeta metadata volume).

And btw you could use tools like thin_dump  to explore how is your pool used,
which chunks belong to which volume, which are share and so on....

Regards

Zdenek
