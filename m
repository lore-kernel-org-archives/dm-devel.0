From: shenghui <shhuiw@foxmail.com>
Subject: How to setup a basic writecache env?
Date: Sun, 21 Oct 2018 10:44:00 +0800
Message-ID: <17790.4479708106$1540203554@news.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Mikulas,

Sorry to trouble you.

I recently noticed dm-writecache in the dm dir, and want to have a try.
But I failed to setup a basic writecache dm using dmsetup:

# dmsetup create testwbc --table "0 512000000 writecache s /dev/md1p5 /dev/md1p6 1024"
device-mapper: reload ioctl on testwbc  failed: Invalid argument
Command failed

In dmesg, there is:
[ 7863.034468] device-mapper: table: 253:0: writecache: Invalid number of feature args
[ 7863.034476] device-mapper: ioctl: error adding target to table

I wonder what is the exact args to dmsetup?

Thanks,
shenghui
