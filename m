From: Anssi Hannula <anssi.hannula@iki.fi>
Subject: Re: [PATCH] dm cache: fix race affecting dirty block
	count
Date: Sun, 17 Aug 2014 23:24:32 +0300
Message-ID: <53F10F80.6080204@iki.fi>
References: <53D32999.6080206@iki.fi>	<1406831487-18750-1-git-send-email-anssi.hannula@iki.fi>
	<20140801151729.GA27644@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140801151729.GA27644@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

01.08.2014, 18:17, Joe Thornber kirjoitti:
> On Thu, Jul 31, 2014 at 09:31:27PM +0300, Anssi Hannula wrote:
>> nr_dirty is updated without locking, causing it to drift so that it is
>> non-zero (either a small positive integer, or a very large one when an
>> underflow occurs) even when there are no actual dirty blocks.
>> 
>> Fix that by using an atomic type for nr_dirty.
[...]
> Patch looks good.

Unfortunately it seems there is some other potentially more serious bug
still in there...

I'm again seeing spurious dirty counts on two volumes [1]. As expected
with the previous fix, they are now both positive (as nr_dirty should
now be perfectly in sync with dirty_bitset and the bitset can't have a
negative count).


My first suspect was this kind of scenario:

Thread 1                      Thread 2
enter clear_dirty(61)         .
clear dirty bit               .
.                             enter set_dirty(61)
.                             set dirty bit
.                             policy_set_dirty()
.                             => mq adds to dirty queue
policy_clear_dirty()          .
=> mq drops from dirty queue  .


So the block remains dirty on target side but clean on mq side, and it
never gets written back since it is not on the mq dirty queue.

However, if the above is really what happens, i.e. concurrent calls to
set_dirty()/clear_dirty() for the same block, is that something that is
supposed to happen? and is the block then really dirty or not?

Or maybe something else is going on...?

This is on 3.15.7 + previous patch.

[1]

0 101876654080 cache 8 30512/32768 128 936412/1978944 8028417 56720875
10942325 11368177 0 744175 13 1 writeback 2 migration_threshold 2048 mq
10 random_threshold 4 sequential_threshold 512
discard_promote_adjustment 1 read_promote_adjustment 4
write_promote_adjustment 8

0 5368709120 cache 8 7184/32768 128 366217/1978880 39346555 8471758
13307043 4709237 0 7055 1 1 writeback 2 migration_threshold 2048 mq 10
random_threshold 4 sequential_threshold 512 discard_promote_adjustment 1
read_promote_adjustment 4 write_promote_adjustment 8

-- 
Anssi Hannula
