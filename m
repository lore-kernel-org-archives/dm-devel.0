From: Michae Lyulko <michaell@voltaire.com>
Subject: Re: Failover between two paths to one LU doesn't work
	onlinux-iscsi
Date: Tue, 10 Oct 2006 21:55:12 +0200
Message-ID: <452BFAA0.1000100@voltaire.com>
References: <452BD5C6.2080808@voltaire.com> <452BD768.30206@ilm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <452BD768.30206@ilm.com>
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

Eli Stair wrote:
>
> What versions of the tools and kernel are you running?  What are your 
> settings for multipath.conf?  Is multipathd running?  If you run 
> multipath -v2 manually, does it fail the path?  Etc.
>
>> 1. Are there any known problems that can cause fail-over not to happen
>> in linux-iscsi?
>
>> 2. Is there any way to get debug information in order to understand more
>> in-depth what's going on?
>
> man multipath && man multipathd
> multipathd -d
> multipath -v4
>
>> 3. How can I know what the timeouts are and how to change them?
>
> Timeouts occur at several levels.  Your HBA or iSCSI driver will have 
> (at least) one.  Check the documentation for the aspects of 
> software/hardware you're using (kernel module options), dm-multipath 
> docs, etc.
I meant Multipath timeouts. iSCSI driver definitely has some.
>
>> 4. If you need more specific information, please write what can help.
>
> http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=Home
>
> I've never done multipath-iscsi, so don't have direct experience.  Try 
> posting some more detailed info on your setup and what errors or info 
> messages are occuring.
>
>
> /eli
>
> -- 
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
Here is some additional info (includes versions, debug info from 
multipath -v4, etc.)
multipathd -d doesn't seem to add any info (strange),
multipath -v2 doesn't fail the path.
multipathd  is running.
I can work with the device via /dev/mapper/3600d02300063ccc60000006215c0b501
or via /dev/dm-0    --  mkfs was successful;
I ran iozone benchmark and manually failed one of two paths. There was 
no failover to second path.
The iSCSI initiator retried to reconnect to the first path - 
unsuccessfully. When I restored the first
path - the initiator reconnected to the target via the first path.

Thanks!

------------- INFO -------------
Versions:
device-mapper-1.01.01-1.6
multipath-tools-0.4.5-0.11

Machine:
2.6.5-7.244-smp; x86_64; SLES9 sp3


virgo4:~ # lsmod | grep dm_multipath
dm_multipath           38544  2 dm_round_robin
dm_mod                 77536  2 dm_multipath

virgo4:~ # ps -ef | grep multipathd
root     17078     1  0 22:04 pts/0    00:00:00 /sbin/multipathd
root     17228 10503  0 22:13 pts/0    00:00:00 grep multipathd


virgo4:~ # multipath -p failover
dm names   N
dm info 3600d02300063ccc60000006215c0b501  N
dm create 3600d02300063ccc60000006215c0b501 
3600d02300063ccc60000006215c0b501 O
dm reload 3600d02300063ccc60000006215c0b501  O
dm resume 3600d02300063ccc60000006215c0b501  N
dm message 3600d02300063ccc60000006215c0b501  N  switch_group 1

create: 3600d02300063ccc60000006215c0b501
[size=87 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=1]
 \_ 1:0:6:0 sda 8:0  [ready]
\_ round-robin 0 [prio=1]
 \_ 1:1:6:0 sdb 8:16 [ready]

virgo4:~ #


virgo4:~ # multipath -l
dm names   N
dm table 3600d02300063ccc60000006215c0b501  N
dm table 3600d02300063ccc60000006215c0b501  N
dm status 3600d02300063ccc60000006215c0b501  N
dm info 3600d02300063ccc60000006215c0b501  O
3600d02300063ccc60000006215c0b501
[size=87 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 1:0:6:0 sda 8:0  [active][ready]
\_ round-robin 0 [enabled]
 \_ 1:1:6:0 sdb 8:16 [active][ready]

virgo4:~ #
virgo4:~ #
virgo4:~ # multipath -v2
dm names   N
dm table 3600d02300063ccc60000006215c0b501  N
dm table 3600d02300063ccc60000006215c0b501  N
dm status 3600d02300063ccc60000006215c0b501  N
dm info 3600d02300063ccc60000006215c0b501  O
virgo4:~ #
virgo4:~ #
virgo4:~ #
virgo4:~ # multipath -v4
load path identifiers cache
3600d02300063ccc60000006215c0b501  1:0:6:0 sda 8:0  [ready] IFT     /ES 
A16F-G
3600d02300063ccc60000006215c0b501  1:1:6:0 sdb 8:16  [ready] IFT     /ES 
A16F-
dm-0 blacklisted
hda blacklisted
hdd blacklisted
loop0 blacklisted
loop1 blacklisted
loop2 blacklisted
loop3 blacklisted
loop4 blacklisted
loop5 blacklisted
loop6 blacklisted
loop7 blacklisted
md0 blacklisted
ram0 blacklisted
ram10 blacklisted
ram11 blacklisted
ram12 blacklisted
ram13 blacklisted
ram14 blacklisted
ram15 blacklisted
ram1 blacklisted
ram2 blacklisted
ram3 blacklisted
ram4 blacklisted
ram5 blacklisted
ram6 blacklisted
ram7 blacklisted
ram8 blacklisted
ram9 blacklisted
===== path info sda (mask 0x3f) =====
device sda is on bus scsi
bus = 1
dev_t = 8:0
size = 184320000
vendor = IFT
product = ES A16F-G
rev = 331J
h:b:t:l = 1:0:6:0
tgt_node_name =
open error (Device or resource busy)

claimed = 1
serial = 0000006215C0B501
path checker = readsector0 (internal default)
state = 2
getprio = (null) (internal default)
prio = 1
uid = 3600d02300063ccc60000006215c0b501 (cache)
===== path info sdb (mask 0x3f) =====
device sdb is on bus scsi
bus = 1
dev_t = 8:16
size = 184320000
vendor = IFT
product = ES A16F-G
rev = 331J
h:b:t:l = 1:1:6:0
tgt_node_name =
open error (Device or resource busy)

claimed = 1
serial = 0000006215C0B501
path checker = readsector0 (internal default)
state = 2
getprio = (null) (internal default)
prio = 1
uid = 3600d02300063ccc60000006215c0b501 (cache)
3600d02300063ccc60000006215c0b501  1:0:6:0 sda 8:0 1 [ready][claimed] IFT
3600d02300063ccc60000006215c0b501  1:1:6:0 sdb 8:16 1 [ready][claimed] IFT
dm names   N
dm table 3600d02300063ccc60000006215c0b501  N
dm table 3600d02300063ccc60000006215c0b501  N
dm status 3600d02300063ccc60000006215c0b501  N
dm info 3600d02300063ccc60000006215c0b501  O
get_dm_mpvec for (null)
params = 0 0 2 1 round-robin 0 1 1 8:0 1000 round-robin 0 1 1 8:16 1000
status = 1 0 0 2 1 A 0 1 0 8:0 A 0 E 0 1 0 8:16 A 0
*word = 0, len = 1
*word = 0, len = 1
*word = 2, len = 1
*word = 1, len = 1
*word = round-robin, len = 11
*word = 0, len = 1
*word = 1, len = 1
*word = 1, len = 1
*word = 8:0, len = 3
*word = 1, len = 1
*word = 1, len = 1
*word = 8:16, len = 4
*word = 1, len = 1
*word = 0, len = 1
*word = 2, len = 1
*word = A, len = 1
*word = 1, len = 1
*word = 0, len = 1
*word = A, len = 1
*word = 0, len = 1
*word = E, len = 1
*word = 1, len = 1
*word = 0, len = 1
*word = A, len = 1
*word = 0, len = 1
pgpolicy = failover (internal default)
selector = round-robin 0 (internal default)
features = 0 (internal default)
hwhandler = 0 (internal default)
rr_weight = 1 (internal default)
0 184320000 multipath 0 0 2 1 round-robin 0 1 1 8:0 1000 round-robin 0 1 
1 8:16 1000
set ACT_NOTHING: map unchanged
virgo4:~ #
