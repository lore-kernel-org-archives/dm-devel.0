From: Milan Broz <gmazyland@gmail.com>
Subject: Re: dm-crypt: Reject sector_size feature if device
 length is not aligned to it
Date: Tue, 3 Oct 2017 22:33:53 +0200
Message-ID: <ddef2346-99af-c20d-903f-f77af35925b6@gmail.com>
References: <20170913134556.23145-1-gmazyland@gmail.com>
	<b6c539ce-c841-a21c-1a2c-4ee93d826680@gmail.com>
	<alpine.LRH.2.02.1710021034380.2597@file01.intranet.prod.int.rdu2.redhat.com>
	<20171003120508.GA9979@agk-dp.fab.redhat.com>
	<20171003180804.GA25465@redhat.com>
	<20171003190934.GB9979@agk-dp.fab.redhat.com>
	<alpine.LRH.2.02.1710031606140.8739@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1710031606140.8739@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 10/03/2017 10:08 PM, Mikulas Patocka wrote:
> 
> It would be interesting to know, why Milan wants the table load to fail.

I mentioned this on IRC:
the only situation I care about in load is that size (dm-table length) is unaligned to optional sector_size.
create fails in this case, load should imho fail as well. 
...
if we say that dmsetup table output is always directly usable (as a mapping table),
then why should there be an exception for dmsetup table --inactive? (now it can print apparently invalid mapping)

Anyway, I am ok if it fails in resume - but do not keep the device suspended after the fail!

> It could be possible to check the validity of the alignment in the 
> cryptsetup tool and not attempt to load invalid tables at all. Is there 
> any reason, why we need to detect the misalignment in the kernel?

Cryptsetup already rejects such a mapping before even calling dm-ioctl.

But anyone can use dmsetup tool to do that. I just think that incompatible
sector vs. device size should be rejected in target constructor.
(IOW my former patch for dm-crypt that rejects only this exact situation without
doing more device-related tests like your generalized patch in table_load.)

Milan
