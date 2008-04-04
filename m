From: Clint Moore <clint@blueboxgrp.com>
Subject: dm-ioband = smarter than me
Date: Fri, 4 Apr 2008 16:53:32 -0700
Message-ID: <2EABDA74-5CC4-4CA2-9839-1EA2C89F2548@blueboxgrp.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids


	I'm missing something and I'm not quite sure what it is.

Here's what I have:

[root@ test 2.6.24]# df -k
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda3            234414076   4047692 218266628   2% /
...
[root@test 2.6.24]# dmsetup targets
ioband           v0.0.3
...
[root@ test 2.6.24]# echo "0 $(blockdev --getsize /dev/sda3) ioband / 
dev/sda3 1" | dmsetup create ioband1
device-mapper: reload ioctl failed: Invalid argument
Command failed
[root@ test 2.6.24]#

  Is it obvious to anyone else what I'm missing or do I need to  
provide more info?

-cm
