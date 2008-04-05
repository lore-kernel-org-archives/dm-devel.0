From: Clint Moore <clint@blueboxgrp.com>
Subject: Re: dm-ioband = smarter than me
Date: Fri, 4 Apr 2008 19:40:40 -0700
Message-ID: <CBD3275B-1B64-4EEF-A68C-73AB54429590@blueboxgrp.com>
References: <2EABDA74-5CC4-4CA2-9839-1EA2C89F2548@blueboxgrp.com>
	<20080405004520.GV2572@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080405004520.GV2572@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


On Apr 4, 2008, at 5:45 PM, Alasdair G Kergon wrote:
> On Fri, Apr 04, 2008 at 04:53:32PM -0700, Clint Moore wrote:
>> [root@ test 2.6.24]# echo "0 $(blockdev --getsize /dev/sda3) ioband /
>> dev/sda3 1" | dmsetup create ioband1
>           ^ why 1?

	I was following the directions to the letter as much as possible to  
just confirm that it actually worked.  Hence, just giving 1.

	I was following http://forum.openvz.org/index.php?t=tree&goto=26914&&srch=dm-ioband#msg_26914


> dmesg gives better error message

Here is the two lines from syslog:

device-mapper: table: 253:0: ioband: band: device lookup failed
device-mapper: ioctl: error adding target to table
