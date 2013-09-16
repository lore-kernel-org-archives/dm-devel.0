From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: [RFC] dm-writeboost: Porting daemon modulating migration
 from userland into the kernel
Date: Mon, 16 Sep 2013 17:54:15 +0900
Message-ID: <5236C737.7040306@gmail.com>
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
Cc: gregkh@linuxfoundation.org
List-Id: dm-devel.ids

Hi, DM Guys,

I am thinking of a little design change
as to autonomous migration feature.
I want to share this issue with you
to first ask for your advice
and for you to deeply understand the 
functionality of dm-writeboost at the same time.


dm-writeboost has a daemon that autonomouly turn on/off migration.
Migration means writing back from cache device to backing store.
The daemon checking the load of backing stores
and turn on/off migration accoding to the load.
Migration despite the backing store in high load
causes long queuing to the backing store
that makes the situation even worse.

The daemon is now implemented in Python using PythonDaemon module
since the daemon is not essential for dm-writeboost kernel module
to run without failure.

My idea is to port this daemon to in-kernel.

The reasons are:
1. The daemon can be said to be "nearly" essential.
   Who wants to use dm-writeboost without the daemon is my question.
   I think none.
2. Functionality of the kernel module should be self-sufficient in kernel.
3. I think I should not depend on PythonDaemon module anymore
   because the module sometime doesn't work as I expect,
   stopping the daemon but it remains running,
   and asking the maintainer doesn't respond for months.

I have studies the implementation
for this porting.

The current implementation is
parsing /proc/diskstats every seconds
and the relavant code in kernel is to read
disk_stats structure through part_stat_read(part, field) macro.

Also, I have a good idea for locking.
I supporse I don't need to add another lock in this porting.

However, of course, possible cons to my idea
is worrying the kernel code becoming more complex.


If you have experienced the same situation
and have some advice on this issue
please tell me.

Akira
