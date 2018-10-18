From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: LUKS2 - RAID0 - NVME : alignment issue
Date: Thu, 18 Oct 2018 13:51:01 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1810181342200.19328@file01.intranet.prod.int.rdu2.redhat.com>
References: <CAHzw6onNd8JskiB75PzFd4Zo45dP4fx3emoHFz8eTNkTV2+7+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="185206533-906627235-1539885061=:19328"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAHzw6onNd8JskiB75PzFd4Zo45dP4fx3emoHFz8eTNkTV2+7+A@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: laurent cop <laurent.cop@gmail.com>
Cc: dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185206533-906627235-1539885061=:19328
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Fri, 12 Oct 2018, laurent cop wrote:

> Hello,
> 
> I have trouble while in top of the stack :
> mkfs.ext4 /dev/mapper/raid0luks2
> /dev/mapper/raid0luks2 alignement is offset by 147456 bytes
> This may result in very poor performance (re-) partitioning is suggested.
> I have the same pb with mkfs.xfs

Just ignore this warning. dm-integrity interleaves data and metadata and 
consequently data are not aligned on raid stripe boundary.

> I am using following scheme:
> 
> LUKS2           => created with cryptsetup -v luksFormat --type luks2 /dev/md127 --cipher aes-gcm-random --integrity aeae
> RAID 0           => created with mdadm chunk=32
> 3 Disks NVME => partition with gdisk (fist sector : 2048)
> 
> I got this information with lsblk -t for each 3 disks, i got the same information.
> nvmeXn1
>        -> NvmeXn1p1                                 ALIGN = 0
>                   -> md127                               ALIGN = 0
>                            -> raid0luks2_dif           ALIGN = 147456
>                                        -> raid0luks2     ALIGN = 147456
> 1) How can I solve my alignment issue?
>
> 2) Is it normal to have low performances while writing with dd. I was 
> using LUKS previously and I got only one dev mapper. Now I got 2. Does 
> it have a big impact on performances?
> 
> Kind regards.

dm-integrity already slows down writes about 3 times. At this situation, 
trying to align accesses to raid stripe size doesn't make much sense.

If you want to improve performance, you may try to put two dm-ingerity 
images directly on the SSDs and create raid-0 on the top of them. It may 
perform better, but you'll have to benchmark it with the workload you are 
optimizing for.

Mikulas
--185206533-906627235-1539885061=:19328
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--185206533-906627235-1539885061=:19328--
