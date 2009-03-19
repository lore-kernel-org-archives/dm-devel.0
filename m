From: Akio Takebe <takebe_akio@jp.fujitsu.com>
Subject: Test results of dm-ioband
Date: Thu, 19 Mar 2009 16:51:55 +0900
Message-ID: <49C1F99B.2030100@jp.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
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
To: dm-devel@redhat.com, Ryo Tsuruta <ryov@valinux.co.jp>
List-Id: dm-devel.ids

Hi, all

Nice to meet you. I'm new to device-mapper.
I'd like to use dm-ioband because it would be useful for virtual environment(kvm, xen).
So I tested dm-ioband, and my test results are below.
I hope it's a help that dm-ioband is committed to mainline.
Any comments are welcome.

Tested-by: Akio Takebe <takebe_akio@jp.fujitsu.com>

Test Discription:

Reference:
  http://people.valinux.co.jp/~ryov/bwctl/

Setup infomation:
  1. compile and loading module
    http://people.valinux.co.jp/~ryov/bwctl/
    http://people.valinux.co.jp/~ryov/dm-ioband/manual/setup.html
  2. setup dmioband
    # echo "0 $(blockdev --getsize /dev/sdb7) ioband /dev/sdb7 1 0 0 none" "weight 0 :40" | dmsetup create ioband1
    # echo "0 $(blockdev --getsize /dev/sdb8) ioband /dev/sdb8 1 0 0 none" "weight 0 :10" | dmsetup create ioband2
    # mkfs.ext3 /dev/mapper/ioband1
    # mkfs.ext3 /dev/mapper/ioband2
    # mount /dev/mapper/ioband1 /mnt1
    # mount /dev/mapper/ioband2 /mnt2

Test Items
- load/unload module : OK
- dmsetup targets show ioband: OK
- Performance test results (fio)
    Summary of results
                         throughput [KiB/s]    % of throughput of
    device   weight(%)   read  write  total    ioband1 + ioband2
    ioband1   40(80%)     328    335    663          79.59%
    ioband2   10(20%)      87     83    170          20.41%

- I/O load (dd):
  I used some I/O load with dd command.
  I confirmed that the filesystem didn't break down.
  The files written by dd were also sane.

Best Regards,

Akio Takebe
