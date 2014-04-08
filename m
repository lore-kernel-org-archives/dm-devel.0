From: Ondrej Kozina <okozina@redhat.com>
Subject: Re: [PATCH 0/9] dm-crypt patches
Date: Tue, 08 Apr 2014 17:25:17 +0200
Message-ID: <534414DD.1040500@redhat.com>
References: <alpine.LRH.2.02.1404051359500.8509@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1404051359500.8509@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

Hi,

I ran all tests again and with new version and everything passed even on 
raid5 back end, so it's right time to paste here some performance results:


Requirements:
------------
http://okozina.fedorapeople.org/dmcrypt-tests.tar.xz
compiled fio package

Performance tests are based on script in subdirectory 1/ in
http://okozina.fedorapeople.org/dmcrypt-tests.tar.xz

The result tables were aggregated from output of following fio command:

fio --output=log --latency-log=log --bandwidth-log=log \
--name=global --rw=$3 --size=1G --bsrange=1k-128k \
--filename=$1 \
--name=job1 --name=job2 --name=job3 --name=job4 \
--end_fsync=1

$1 - test device
$3 - read/write mode see explanation of TEST NAME column below

HW:
---
2-socket machine Intel(R) Xeon(TM) CPU 3.40GHz (4 logical CPUs, without 
HW acceleration for AES!)
4GB RAM
4x SEAGATE ST336753LC (rotational drive)

One disk was used for system data, the rest for testing

Explanation for tables below:
-----------------------------
In column TEST NAME:

- "disk_nocrypt" stands for pure device w/o any encryption in effect 
(it's single device or raid5 device using md)
- "zero" stands for encryption over dm-zero target. Basically this test 
is trying to measure the performance of dm-crypt core alone.
- "disk" is real device (same as in "disk_nocrypt") with encryption set 
up over it.

following suffixes after dash in TABLE NAME column:
(all correspond to permissible values for fio --rw option)

- read = sequential reads
- write = sequential writes
- randread = random reads
- randwrite = random writes
- rw = sequential mixed reads and writes
- randrw = random mixed reads and writes

Any mixed option above has separate line for aggregated READs and WRITEs 
operations.

For encryption I used aes-xts-plain64 cipher, but please note that the 
machine doesn't provide HW acceleration for AES algorithm.

The column AGGRB_A stands for results with vanilla 3.14
The column AGGRB_B stands for results with all Mikulas's patches applied.

The interesting results are prefixed with "zero-" and "disk-". The 
"disk_nocrypt-" results are just for reference to see real limits of HW.

The "zero-" prefixed lines doesn't require to be published multiple 
times but it can serve to demonstrate scatter of results even on idling 
machine (except for running tests).

The single device tests:

TEST NAME                 OPERATION AGGRB_A KB/s AGGRB_B KB/s DIFF A->B
------------------------- --------- ------------ ------------ ---------
disk_nocrypt-read         READ      260289       259339       -0.36 %
disk_nocrypt-write        WRITE     242950       242922       -0.01 %
disk_nocrypt-randread     READ       53095        52195       -1.70 %
disk_nocrypt-randwrite    WRITE     193665       194482        0.42 %
disk_nocrypt-rw           READ       64050        64037       -0.02 %
disk_nocrypt-rw           WRITE      64581        64567       -0.02 %
disk_nocrypt-randrw       READ       16792        17235        2.64 %
disk_nocrypt-randrw       WRITE      16796        17239        2.64 %
zero-read                 READ      187614       309748       65.10 %
zero-write                WRITE     240871       332301       37.96 %
zero-randread             READ      299024       325476        8.85 %
zero-randwrite            WRITE     108506       123805       14.10 %
zero-rw                   READ       81694       106583       30.47 %
zero-rw                   WRITE      82370       107465       30.47 %
zero-randrw               READ       60794        85574       40.76 %
zero-randrw               WRITE      60810        85597       40.76 %
disk-read                 READ      232603       238258        2.43 %
disk-write                WRITE     119649       218601       82.70 %
disk-randread             READ       52578        52249       -0.63 %
disk-randwrite            WRITE     153878       173487       12.74 %
disk-rw                   READ       61341        64629        5.36 %
disk-rw                   WRITE      61849        65164        5.36 %
disk-randrw               READ       16251        15229       -6.29 %
disk-randrw               WRITE      16255        15233       -6.29 %


md raid5 with 64KiB chunk size as basking device:

TEST NAME                 OPERATION AGGRB_A KB/s AGGRB_B KB/s DIFF A->B
------------------------- --------- ------------ ------------ ---------
disk_nocrypt-read         READ      391405       390276        -0.29 %
disk_nocrypt-write        WRITE     209736       210272         0.26 %
disk_nocrypt-randread     READ       84644        84319        -0.38 %
disk_nocrypt-randwrite    WRITE      30651        29174        -4.82 %
disk_nocrypt-rw           READ       64533        64472        -0.09 %
disk_nocrypt-rw           WRITE      65068        65005        -0.10 %
disk_nocrypt-randrw       READ       18586        18827         1.30 %
disk_nocrypt-randrw       WRITE      18591        18832         1.30 %
zero-read                 READ      190641       308042        61.58 %
zero-write                WRITE     343936       306533       -10.87 %
zero-randread             READ      298322       326007         9.28 %
zero-randwrite            WRITE     115462       122193         5.83 %
zero-rw                   READ       82092       114980        40.06 %
zero-rw                   WRITE      82771       115932        40.06 %
zero-randrw               READ       69730        90008        29.08 %
zero-randrw               WRITE      69748        90032        29.08 %
disk-read                 READ      283207       264641        -6.56 %
disk-write                WRITE     152088       176431        16.01 %
disk-randread             READ       82021        81720        -0.37 %
disk-randwrite            WRITE      20553        23880        16.19 %
disk-rw                   READ       56833        59059         3.92 %
disk-rw                   WRITE      57303        59548         3.92 %
disk-randrw               READ       15819        16726         5.73 %
disk-randrw               WRITE      15823        16730         5.73 %

md raid5 with 512KiB chunk size as basking device:

TEST NAME                 OPERATION AGGRB_A KB/s AGGRB_B KB/s DIFF A->B
------------------------- --------- ------------ ------------ ---------
disk_nocrypt-read         READ      463151       447822       -3.31 %
disk_nocrypt-write        WRITE     149476       149866        0.26 %
disk_nocrypt-randread     READ       99205        98393       -0.82 %
disk_nocrypt-randwrite    WRITE      34422        34535        0.33 %
disk_nocrypt-rw           READ       75898        77132        1.63 %
disk_nocrypt-rw           WRITE      76527        77770        1.62 %
disk_nocrypt-randrw       READ       21886        21928        0.19 %
disk_nocrypt-randrw       WRITE      21892        21934        0.19 %
zero-read                 READ      189735       305173       60.84 %
zero-write                WRITE     289402       289082       -0.11 %
zero-randread             READ      300373       317061        5.56 %
zero-randwrite            WRITE     128128       123838       -3.35 %
zero-rw                   READ       81956       114558       39.78 %
zero-rw                   WRITE      82635       115506       39.78 %
zero-randrw               READ       74406        86589       16.37 %
zero-randrw               WRITE      74426        86612       16.37 %
disk-read                 READ      333251       399153       19.78 %
disk-write                WRITE     139703       158574       13.51 %
disk-randread             READ       93669        92408       -1.35 %
disk-randwrite            WRITE      22994        26520       15.33 %
disk-rw                   READ       63573        73389       15.44 %
disk-rw                   WRITE      64099        73996       15.44 %
disk-randrw               READ       19045        19617        3.00 %
disk-randrw               WRITE      19050        19622        3.00 %

Ondrej
