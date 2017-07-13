From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-integrity
Date: Thu, 13 Jul 2017 09:22:37 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1707130647390.6653@file01.intranet.prod.int.rdu2.redhat.com>
References: <bbf2a91d-2eac-5b10-903d-50939acfb57a@yandex.ru>
	<4d2e0176-071a-1cb4-3eaa-3c3552a2ce09@gmail.com>
	<0d01c698-211e-a969-8c4a-e6bb4ab2cf9b@yandex.ru>
	<96314674-1b66-ce91-732e-17901d1f3236@yandex.ru>
	<ce9f9bdb-cb04-097d-5628-4f4ea0155195@gmail.com>
	<559a498c-c91a-62e0-aef5-783210d245b6@yandex.ru>
	<7c811e93-ff1c-420d-bc99-2b234d13ae30@gmail.com>
	<f694c673-96e4-692f-c3a2-31f2c5d07f84@yandex.ru>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="185206533-388901165-1499945789=:6653"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f694c673-96e4-692f-c3a2-31f2c5d07f84@yandex.ru>
Content-ID: <alpine.LRH.2.02.1707130914350.6653@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Renesanso <renesanso@yandex.ru>
Cc: dm-devel@redhat.com, Milan Broz <gmazyland@gmail.com>, dmitry.kasatkin@huawei.com
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185206533-388901165-1499945789=:6653
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LRH.2.02.1707130914351.6653@file01.intranet.prod.int.rdu2.redhat.com>

Hi

On Wed, 12 Jul 2017, Renesanso wrote:

> Hi. Please, give link to your blog.
> 
> I succesfully create configuration for virtual machines (and it works 
> fine), test force reboot many time (and machine have some problem with 
> ACPI table, thats why SATA controller reset links for all disks (now it 
> fixed), but only one disk is out from md-raid and system worked. when 
> controller problem was it heavy test I/O). E.g. I think, that with 
> journal and crc32 dm-integrity is stable. In one of tests I write 1Mb 
> with dd (with skip), then read (cat > /dev/null) LVM-partition on top of 
> md. dm-intergity succesfully detect corrution, generate i/o error and md 
> fencing disk, but still works.
> 
> 
> I use this configuration: 7 SATA disks => each with own dm-integrity => 
> md raid6 6 disks + 1 spare disk -> LVM for virtual machines.
> 
> If any disk gives up buggy info, dm-integrity will generate i/o error 
> and md fence disk from raid, but system continious working. You can say, 
> that I must use ZFS for this case, but I don't have SSD-cache, and 
> without SSD-cache ZFS is too slow, SLOWSLOWSLOW in future, when virtual 
> machines disks will fragment, e.g. CoW. My solution gives integrity 
> opportunity without fragmentation penalty.
> 
> Please, use this info in your blog, becase in production we want not 
> only know, that info from disk is buggy, but read non-buggy info and 
> continue working. If you will paste to your blog, please. change serial 
> numbers of my disks. :)
> 
> And one more think: after system boot and assemble script executed, it 
> eates ~4Gb RAM (only dm-intergity). What parameter doing it?

The journal must be kept in memory. You have journal size 836870912 for 7 
devices, that's 5858096384 bytes. If you want to reduce memory 
consumption, reduce the journal size.

> I use this sript on boot to assemle raid:
> 
> cd /root/local/integrity/src
> 
> LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup 
> --integrity=crc32 --buffer-sectors=414096 --journal-watermark=70 
> --journal-commit-time=60000 open 
> /dev/disk/by-id/ata-WDC_WD5000AADS-00S9B0_WD-WCAV90886975-part1 
> integra-WCAV90886975
> 
> LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup 
> --integrity=crc32 --buffer-sectors=414096 --journal-watermark=70 
> --journal-commit-time=60000 open 
> /dev/disk/by-id/ata-WDC_WD5003AZEX-00MK2A0_WD-WCC3F0SJX4T6-part1 
> integra-WCC3F0SJX4T6
> 
> LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup 
> --integrity=crc32 --buffer-sectors=414096 --journal-watermark=70 
> --journal-commit-time=60000 open 
> /dev/disk/by-id/ata-WDC_WD5001AALS-00J7B0_WD-WMATV7467797-part1 
> integra-WMATV7467797
> 
> LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup 
> --integrity=crc32 --buffer-sectors=414096 --journal-watermark=70 
> --journal-commit-time=60000 open 
> /dev/disk/by-id/ata-WDC_WD5003AZEX-00MK2A0_WD-WCC3F0YY89KN-part1 
> integra-WCC3F0YY89KN
> 
> LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup 
> --integrity=crc32 --buffer-sectors=414096 --journal-watermark=70 
> --journal-commit-time=60000 open 
> /dev/disk/by-id/ata-WDC_WD5003AZEX-00MK2A0_WD-WCC3F5HF3NN0-part1 
> integra-WCC3F5HF3NN0
> 
> LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup 
> --integrity=crc32 --buffer-sectors=414096 --journal-watermark=70 
> --journal-commit-time=60000 open 
> /dev/disk/by-id/ata-WDC_WD5003AZEX-00K3CA0_WD-WCC6Y4XEA1RS-part1 
> integra-WCC6Y4XEA1RS
> 
> LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup 
> --integrity=crc32 --buffer-sectors=414096 --journal-watermark=70 
> --journal-commit-time=60000 open 
> /dev/mapper/vg--super--blue-lv--super--spare integra-spare
> 
> cd /
> 
> mdadm --assemble --scan
> 
> sleep 6
> 
> echo 50000 > /proc/sys/dev/raid/speed_limit_min
> 
> echo 500000 > /proc/sys/dev/raid/speed_limit_max
> 
> echo 32768 > /sys/block/md0/md/stripe_cache_size
> 
> And this to create:
> 
> LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup -v 
> --sector-size=512 --integrity=crc32 --tag-size 32 
> --buffer-sectors=414096 --journal-size=836870912 format 
> /dev/disk/by-id/ata-WDC_WD5000AADS-00S9B0_WD-WCAV90886975-part1 ##-> 
> ../../sda1
>
> LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup -v 
> --sector-size=512 --integrity=crc32 --tag-size 32 
> --buffer-sectors=414096 --journal-size=836870912 format 
> /dev/disk/by-id/ata-WDC_WD5003AZEX-00MK2A0_WD-WCC3F0SJX4T6-part1 ##-> 
> ../../sdb1
>
> LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup -v 
> --sector-size=512 --integrity=crc32 --tag-size 32 
> --buffer-sectors=414096 --journal-size=836870912 format 
> /dev/disk/by-id/ata-WDC_WD5001AALS-00J7B0_WD-WMATV7467797-part1 ##-> 
> ../../sdc1
>
> LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup -v 
> --sector-size=512 --integrity=crc32 --tag-size 32 
> --buffer-sectors=414096 --journal-size=836870912 format 
> /dev/disk/by-id/ata-WDC_WD5003AZEX-00MK2A0_WD-WCC3F0YY89KN-part1 ##-> 
> ../../sdd1
>
> LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup -v 
> --sector-size=512 --integrity=crc32 --tag-size 32 
> --buffer-sectors=414096 --journal-size=836870912 format 
> /dev/disk/by-id/ata-WDC_WD5003AZEX-00MK2A0_WD-WCC3F5HF3NN0-part1 ##-> 
> ../../sde1
>
> LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup -v 
> --sector-size=512 --integrity=crc32 --tag-size 32 
> --buffer-sectors=414096 --journal-size=836870912 format 
> /dev/disk/by-id/ata-WDC_WD5003AZEX-00K3CA0_WD-WCC6Y4XEA1RS-part1 ##-> 
> ../../sdf1
>
> LD_PRELOAD='../lib/.libs/libcryptsetup.so.12' ./integritysetup -v 
> --sector-size=512 --integrity=crc32 --tag-size 32 
> --buffer-sectors=414096 --journal-size=836870912 format 
> /dev/mapper/vg--super--blue-lv--super--spare

Note that --tag-size is in bytes and it is useless to have 32 bytes for 
the crc32 function because crc32 returns just 4 bytes. These extra bytes 
just take up disk space and reduce performance. You should omit the 
--tag-size argument entirely - so that it defaults to the size of the 
crc32 function (4 bytes).

Also - for better performance, use sector size 4096 (you must use 
filesystem block size 4096 bytes as well). It makes sense to use small 
sector size only if you need small filesystem block size (if you intend to 
use the filesystem for storing many small files).

> mdadm --verbose --create /dev/md0  --bitmap=internal --bitmap-chunk=524288 -c 128  --level=6  --raid-devices=6 /dev/mapper/integra-WCAV90886975
> /dev/mapper/integra-WCC3F0SJX4T6 /dev/mapper/integra-WMATV7467797 /dev/mapper/integra-WCC3F0YY89KN /dev/mapper/integra-WCC3F5HF3NN0 /dev/mapper/integra-WCC6Y4XEA1RS
> --spare-devices=1 /dev/mapper/integra-spare
> 
> 
> 11.07.2017 12:52, Milan Broz ?????:
> 
> On 07/10/2017 05:53 PM, Renesanso wrote:
> 
> And I have other question: is it ready for production in crc32+journal 
> mode? Not as like IBM-like production, I mean, but it is not full> buggy, but stable now? :)

There were no data corruption reports from users. But this is new code, so 
not many users have tried it. Back up your data and then you can try it :)

Mikulas

> Hi,
> 
> well, there are some tests, we found and fixed some issues in 4.12-rcX
> (so be sure you are using code from released 4.12.0 or later!).
> 
> So I hope it is stable, but it would definitely need more users to test.
> If you find any problem, crash or anything related to kernel code, please send
> a report to the dm-devel@redhat.com list.
> 
> Thanks,
> Milan
> 
> 
> 
--185206533-388901165-1499945789=:6653
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--185206533-388901165-1499945789=:6653--
