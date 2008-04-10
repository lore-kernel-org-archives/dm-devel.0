From: Clint Moore <clint@blueboxgrp.com>
Subject: ioband pebcak again, I'm sure.
Date: Thu, 10 Apr 2008 13:27:48 -0700
Message-ID: <E9C37B59-6A5E-41D7-8458-67E50D43661D@blueboxgrp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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


	Hopefully I'm doing something just as dumb this time as last time.

/dev/sdc and /dev/sdd are iscsi targets.

Cliff notes version is, after setting up ioband and adding a weight to  
two filesystems per the website docs, I can't mount them anywhere.  I  
tried this with a local device as well as iscsi targets.  Here's what  
I did to do this, perhaps I'm missing a step or something?


[root@gurn 302]# mount /dev/sdd1 /mnt
[root@gurn 302]# df -k
Filesystem           1K-blocks      Used Available Use% Mounted on
...
/dev/sdd1              1031888    172316    807156  18% /mnt
[root@gurn 302]# umount /mnt
[root@gurn 302]# mount /dev/sdc1 /mnt
Filesystem           1K-blocks      Used Available Use% Mounted on
...
/dev/sdc1              1031888    172316    807156  18% /mnt
[root@gurn 302]# umount /mnt

So the filesystems mount ok otherwise...

[root@gurn 302]# blockdev --getsize /dev/sdc1
2096753
[root@gurn 302]# echo "0 2096753 ioband /dev/sdc1 1" | dmsetup create  
ioband2
[root@gurn 302]# blockdev --getsize /dev/sdd1
2096753
[root@gurn 302]# echo "0 2096753 ioband /dev/sdd1 1" | dmsetup create  
ioband1
[root@gurn 302]# dmsetup message ioband1 0 weight 40
[root@gurn 302]# dmsetup message ioband2 0 weight 10
[root@gurn 302]# dmsetup ls --target ioband
ioband2	(253, 1)
ioband1	(253, 0)
[root@gurn 302]#

[root@gurn 302]# mount /dev/sdc1 /mnt
mount: /dev/sdc1 already mounted or /mnt busy
[root@gurn 302]# mount /dev/sdd1 /mnt
mount: /dev/sdd1 already mounted or /mnt busy
[root@gurn 302]# umount /dev/sdd1
umount: /dev/sdd1: not mounted
[root@gurn 302]# mkdir /honk
[root@gurn 302]# mount /dev/sdd1 /honk
mount: /dev/sdd1 already mounted or /honk busy

Here's the fun part:

[root@gurn 302]# dmsetup remove ioband1
[root@gurn 302]# dmsetup remove ioband2
[root@gurn 302]# mount /dev/sdc1 /mnt
[root@gurn 302]# mount /dev/sdd1 /honk
[root@gurn 302]# df -k
Filesystem           1K-blocks      Used Available Use% Mounted on
...
/dev/sdc1              1031888    172560    806912  18% /mnt
/dev/sdd1              1031888    172316    807156  18% /honk
[root@gurn 302]#
