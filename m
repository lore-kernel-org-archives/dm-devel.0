From: majianpeng <majianpeng@gmail.com>
Subject: How to use dm-cache-target?
Date: Mon, 11 Mar 2013 10:28:07 +0800
Message-ID: <513D4137.5090503@gmail.com>
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
To: agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi all,
    I am trying to use dm-cache-target on raid5.But i met a question.

 Supposed: /dev/sdb1(5GB) is metadata; /dev/sdb2(20GB) is cache;/dev/md0 is raid5.

1:sutup my_cache
dmsetup create my_cache --table '0 41943040 cache /dev/sdb1 /dev/sdb2 /dev/md0 131072 1 writethrough default 0'

2:mkfs.ext4
mkfs.ext4 /dev/mapper/my_cache

3:mount
mount /dev/mapper/my_cache /media

4:the size of ext4 is 20GB,but the /dev/md0 is 4TB.

I think maybe my methods error. If so, how to do use?

BTW, for dm-cache is it support plug-and-play?

Thanks!
Jianpeng Ma
