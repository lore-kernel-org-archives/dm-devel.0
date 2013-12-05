From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: [Question] btt -B doesn't output anything with DM device
Date: Thu, 05 Dec 2013 21:12:49 +0900
Message-ID: <52A06DC1.4070402@gmail.com>
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
To: linux-btrace@vger.kernel.org
Cc: dm-devel@redhat.com, devel@etsukata.com
List-Id: dm-devel.ids

Hi, Guys,

I am trying to visualize io pattern by bno_plot.
bno_plot requires an output from btt -B but
btt -B doesn't output anything for DM devices (e.g. /dev/mapper/mydev) while
it does for real block devices (e.g. /dev/sdc).


For narrowing down the problem
I reproduced this problem with simple linear device.

# Setup
root@Freedom:/home/akira# dmsetup create mydev --table "0 100000 linear /dev/sdc 0"
root@Freedom:/home/akira# dmsetup ls
pdc_fgaahfadb   (254:0)
mydev   (254:1) <- this

# Trace
root@Freedom:/home/akira# cat devlist
/dev/mapper/mydev
/dev/sdc
root@Freedom:/home/akira# blktrace -w 30 -I devlist -D mytrace
=== dm-1 ===
  CPU  0:                    0 events,        0 KiB data
  CPU  1:                  378 events,       18 KiB data
  Total:                   378 events (dropped 0),       18 KiB data
=== sdc ===
  CPU  0:                    0 events,        0 KiB data
  CPU  1:                  781 events,       37 KiB data
  Total:                   781 events (dropped 0),       37 KiB data
root@Freedom:/home/akira# ls mytrace/
dm-1.blktrace.0  dm-1.blktrace.1  sdc.blktrace.0  sdc.blktrace.1

# btt
root@Freedom:/home/akira# btt -i mytrace/sdc.blktrace.* -B sdc
root@Freedom:/home/akira# btt -i mytrace/dm-1.blktrace.* -B dm-1  
root@Freedom:/home/akira# ls *.dat
sdc_008,032_c.dat  sdc_008,032_r.dat


btt doesn't output anything with dm-1.blktrace.* .
Is this intentionally designed or just a (known/unknown) bug?
Or, do I forget something?


Thanks,
Akira
