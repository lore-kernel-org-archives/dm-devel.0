From: David Strand <dpstrand@gmail.com>
Subject: multipathd segfault
Date: Thu, 26 Mar 2009 17:25:29 -0700
Message-ID: <448b15030903261725x1fc4c02dx594c6df7b8daa11e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

I am getting a multipathd segfault when I have more than 26 devices,
and the device names become 4 characters. (i.e. /dev/sdz is consumed
and the next device is /dev/sdaa).

I was trying to hook gdb to a core dump, but it keeps complaining that
it needs device-mapper-libs-debuginfo, which I can not find. Can
anyone point me to this?

I built multipathd with -g turned on and did not strip it. Here is the
last few lines of output when I run it as multipathd -v9 -d:

Jul 04 05:01:26 | alpa-0x000080: discover
Jul 04 05:01:26 | libdevmapper: ioctl/libdm-iface.c(1606): dm table
alpa-0x000080  NF   [16384]
Jul 04 05:01:26 | *word = 0, len = 1
Jul 04 05:01:26 | *word = 0, len = 1
Jul 04 05:01:26 | *word = 1, len = 1
Jul 04 05:01:26 | *word = 1, len = 1
Jul 04 05:01:26 | *word = 1, len = 1
Jul 04 05:01:26 | *word = 1, len = 1
Jul 04 05:01:26 | *word = 65:160, len = 6
Jul 04 05:01:26 | *word = 1000, len = 4
Jul 04 05:01:26 | libdevmapper: ioctl/libdm-iface.c(1606): dm status
alpa-0x000080  NF   [16384]
Jul 04 05:01:26 | *word = 2, len = 1
Jul 04 05:01:26 | *word = 0, len = 1
Jul 04 05:01:26 | *word = 0, len = 1
Jul 04 05:01:26 | *word = 1, len = 1
Jul 04 05:01:26 | *word = E, len = 1
Jul 04 05:01:26 | *word = 1, len = 1
Jul 04 05:01:26 | *word = 0, len = 1
Jul 04 05:01:26 | *word = A, len = 1
Jul 04 05:01:26 | *word = 0, len = 1
Jul 04 05:01:26 | alpa-0x000080: rr_weight = 1 (internal default)
Jul 04 05:01:26 | alpa-0x000080: pgfailback = -2 (config file default)
Jul 04 05:01:26 | alpa-0x000080: no_path_retry = 3 (config file default)
Jul 04 05:01:26 | libdevmapper: ioctl/libdm-iface.c(1606): dm message
alpa-0x000080  NF  queue_if_no_path
 [16384]
Jul 04 05:01:26 | pg_timeout = NONE (internal default)
Jul 04 05:01:26 | alpa-0x000080: event checker started
Jul 04 05:01:26 | sdaa path added to devmap alpa-0x000080
Jul 04 05:01:26 | discard event on /block/sdaa/sdaa1
Segmentation fault
