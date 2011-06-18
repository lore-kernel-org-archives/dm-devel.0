From: Krzysztof =?UTF-8?Q?B=C5=82aszkowski?= <kb@sysmikro.com.pl>
Subject: newbie question regarding target_type's map callback
Date: Sat, 18 Jun 2011 17:57:29 +0200
Message-ID: <1308412649.23392.621.camel@linux-zhyd.site>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

I designed a target where constructor sets split_io. During tests on
local filesystem (ext3) with dbench (150 processes, dbench is modified
that way it leaves its files at exit) (kernels: 2.6.33.7 and 2.6.39.1) i
noticed that amount of bios can reach level of 250k.

I was thinking that i can use "throttling" facility if i added following
section in my map function:

if (mytgt->inbox.pending > 180000) {
	wait_event_timeout(mytgt->throttling.wait, (mytgt->inbox.pending <
150000), 2 * HZ);
}

and 
if (mytgt->inbox.pending < 150000)
	wake_up_all(&mytgt->throttling.wait); 
in function which frees resources for given bio from "inbox".

I noticed that after adding this "throttling" feature it turned out that
filesystem is inconsistent after single test run (but throttling works
of course. inbox.pending never exceeds 180k + 3 .. 7, i guess it is
amount of logical cores).

Interesting is that without the facility filesystem and dm are
periodically stalled as long as my target confirms some number of
pending bios but filesystem corruption doesn't happen.

I was thinking that any "upper" bio which is split into bios of size not
bigger than split_io is completed only when all these small bios are
ended with bio_endio() thus changing order of small bios execution
(delaying some of them) doesn't matter.

Was i right ?
if i was then what could be reasons of corrupting filesystem because of
"throttling" feature?
or maybe i missed something, did i ?

I was thinking about these following also:
Can someone explain benefits from using map vs map_rq ?
Does DM_MAPIO_REQUEUE (map callback) work properly ? I noticed that dm
from 2.6.33.7 seems to not handle this right and filesystem complains on
IOs with error code.

Thanks for giving me clues on these above.

Regards,

-- 
Krzysztof Blaszkowski
