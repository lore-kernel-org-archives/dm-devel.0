From: malahal@us.ibm.com
Subject: Re: dm-ioband = smarter than me
Date: Fri, 4 Apr 2008 18:45:40 -0700
Message-ID: <20080405014540.GB10916@us.ibm.com>
References: <2EABDA74-5CC4-4CA2-9839-1EA2C89F2548@blueboxgrp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2EABDA74-5CC4-4CA2-9839-1EA2C89F2548@blueboxgrp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Clint Moore <clint@blueboxgrp.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Clint Moore [clint@blueboxgrp.com] wrote:
>
> 	I'm missing something and I'm not quite sure what it is.
>
> Here's what I have:
>
> [root@ test 2.6.24]# df -k
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sda3            234414076   4047692 218266628   2% /
> ...
> [root@test 2.6.24]# dmsetup targets
> ioband           v0.0.3
> ...
> [root@ test 2.6.24]# echo "0 $(blockdev --getsize /dev/sda3) ioband 
> /dev/sda3 1" | dmsetup create ioband1
> device-mapper: reload ioctl failed: Invalid argument
> Command failed

Don't you need to unmount first?
