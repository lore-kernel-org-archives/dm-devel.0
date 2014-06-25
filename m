From: Vasily Tarasov <tarasov@vasily.name>
Subject: Re: dmdedup target mkfs.ext3 failed
Date: Wed, 25 Jun 2014 11:44:17 -0700
Message-ID: <CAFTzLMPLGvb7H2gyyni5B4Sg7=0j6K1P8Hn7ummh-qdVnKerWw@mail.gmail.com>
References: <BAY182-W11AC11F417AD568551DD7CD51E0@phx.gbl>
	<BAY182-W133FFDD90BFFAA99DE9704D5190@phx.gbl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <BAY182-W133FFDD90BFFAA99DE9704D5190@phx.gbl>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lvshuo <testfile82@hotmail.com>
Cc: Geoff Kuenning <geoff@cs.hmc.edu>, "hch@infradead.org" <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "philip.shilane@emc.com" <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, "ezk@fsl.cs.sunysb.edu" <ezk@fsl.cs.sunysb.edu>
List-Id: dm-devel.ids

In this command:

echo "0 8 dedup data_dev=/dev/sdb metadata_dev=/dev/sdd
mdbackend=cowbtree reconstruct=no" | dmsetup create mydedup

you set the size of the mydedup logical device to 8 sectors only.
That's why mkfs fails - it just runs out of space.

Vasily

On Tue, Jun 24, 2014 at 5:59 PM, lvshuo <testfile82@hotmail.com> wrote:
>
> when I user dedup target,
>
> echo "0 8 dedup data_dev=/dev/sdb metadata_dev=/dev/sdd mdbackend=cowbtree reconstruct=no" | dmsetup create mydedup
>
>  [root@localhost md]# mkfs.ext3  /dev/mapper/mydedup
>  mke2fs 1.41.12 (17-May-2010)
>  /dev/mapper/mydedup: Not enough space to build proposed filesystem while setting up superblock
>  [root@localhost md]#
>
>  why the create filesystem failed?  dedup have any problem?
>
>
>  [root@localhost md]# fdisk -l
>
>  Disk /dev/sdb: 2147 MB, 2147483648 bytes
>  255 heads, 63 sectors/track, 261 cylinders
>  Units = cylinders of 16065 * 512 = 8225280 bytes
>  Sector size (logical/physical): 512 bytes / 512 bytes
>  I/O size (minimum/optimal): 512 bytes / 512 bytes
>  Disk identifier: 0x00000000
>
>
>  Disk /dev/sdc: 1073 MB, 1073741824 bytes
>  255 heads, 63 sectors/track, 130 cylinders
>  Units = cylinders of 16065 * 512 = 8225280 bytes
>  Sector size (logical/physical): 512 bytes / 512 bytes
>  I/O size (minimum/optimal): 512 bytes / 512 bytes
>  Disk identifier: 0x00000000
>
>
>  Disk /dev/sdd: 8589 MB, 8589934592 bytes
>  255 heads, 63 sectors/track, 1044 cylinders
>   Units = cylinders of 16065 * 512 = 8225280 bytes
>  Sector size (logical/physical): 512 bytes / 512 bytes
>  I/O size (minimum/optimal): 512 bytes / 512 bytes
>  Disk identifier: 0x00000000
>
>
>
