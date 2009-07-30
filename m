From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] drop mutex in __set_size
Date: Fri, 31 Jul 2009 08:49:18 +0900
Message-ID: <4A72317E.5060701@ce.jp.nec.com>
References: <Pine.LNX.4.64.0904281211590.22533@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904281214120.22533@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904290223490.9079@hs20-bc2-1.build.redhat.com>
	<4A093417.6050007@ce.jp.nec.com> <4A6824DA.30205@ce.jp.nec.com>
	<Pine.LNX.4.64.0907271942001.10397@hs20-bc2-1.build.redhat.com>
	<4A6F945B.8040502@ce.jp.nec.com>
	<Pine.LNX.4.64.0907301114580.6696@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0907301114580.6696@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Mikulas,

Mikulas Patocka wrote:
> On Wed, 29 Jul 2009, Jun'ichi Nomura wrote:
>> Mikulas Patocka wrote:
>>> Drop the mutex.
>>>
>>> It doesn't make sense to lock it for a single assignment, this code can't
>>> be executed concurrently. The size should be read with i_size_read which
>>> is automatically protected against concurrent i_size_write.
>> But it seems there are codes which depend on i_mutex for
>> protected access to i_size: e.g. block_write_begin().
> 
> You are right, but I don't know what to do with it. Catch such uses and 
> convert them to i_size_read?

Or move the i_size_write outside of dm suspended state?
Not deeply examined, but I don't think it doesn't have
to be in the suspended code path.

>> And while my description only mentioned noflush suspend,
>> with 2.6.31-rc, the deadlock can occur under normal suspend
>> because the new barrier code may push bios to deferred queue.
> 
> It can deadlock with any code that takes i_mutex and submits or waits for 
> i/os, regardless of barriers.

Yes, you are right.

I attached a reproducer script for easy testing.

-- 
Jun'ichi Nomura, NEC Corporation

#!/bin/sh -x

# --------------------------------------------------------------------
#
# Reproducer for i_mutex deadlock
#
# Usage:
#   1. Edit variables in the config section (especially DEV and MAP)
#   2. Run this script and wait
#   3. The script should stall with the following output:
#        + dmsetup resume ${MAP}
#
# What this scripts do:
#   2 proceeses do the test.
#   One creates a dm dev and repeat resizing it.
#   The other writes to the dm dev and fsync, repeatedly.
#   If the dm resume is performed during the fsync() holding i_mutex,
#   the processes deadlock.
#
# --------------------------------------------------------------------

# --------------------------------------------------------------------
# Config section

# Device to use for testing. Contents will be destroyed.
DEV=/dev/sdX
# dm table name for testing. ${MAP} is overlaid on ${DEV}
MAP=map1
# SIZE1 and SIZE2 are the sizes (in sectors) of the dm dev ${MAP}
SIZE1=1000000
SIZE2=2000000
# Options for 'dmsetup suspend'
SUSPEND_OPTS="--nolockfs --noflush"

# Name of generated test program. Files ${TP}.c and ${TP} are generated.
TP=./fsync-io
# Total I/O size (in MB) that ${TP} should perform before fsync().
IOSIZE=400

## You don't need to edit codes below.
## But you might want to change the length of sleeps and/or
## print_table function for other target type.

# --------------------------------------------------------------------
# Create a test dev
#

function print_table() {
  local sz=$1
#  echo "0 ${sz} multipath 1 queue_if_no_path 0 1 1 round-robin 0 1 1 ${DEV} 2"
  echo "0 ${sz} linear ${DEV} 0"
}

print_table ${SIZE1} | dmsetup create ${MAP} || exit 1

# --------------------------------------------------------------------
# Repeat write+fsync on dm dev
#

lineno=$(cat $0 | sed -n '/^==BEGIN C CODE==/=')
cat $0 | sed -n "$((lineno + 1)),\$p" > ${TP}.c
gcc -o ${TP} ${TP}.c || exit 1

# Wait a while for the resizing routine to come up and start testing
(while [ -b /dev/mapper/${MAP} ] && ${TP} /dev/mapper/${MAP} ${IOSIZE}; do :; done) &

# --------------------------------------------------------------------
# Repeat resizing dm dev
#

while sleep 1; do
  for sz in $SIZE1 $SIZE2; do
    print_table ${sz} | dmsetup load ${MAP} \
	&& dmsetup suspend ${SUSPEND_OPTS} ${MAP} \
	&& sleep 1 && dmsetup resume ${MAP}
  done
done

exit

# --------------------------------------------------------------------
#
#
==BEGIN C CODE========================================================
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

char buf[1024*1024];

int
main(int argc, char** argv)
{
	int fd, i, size, cnt = 0;
	char *fname;

	if (argc < 3) {
		printf("Usage: <this prog> <dev> <size in MB>\n");
		exit(1);
	}

	fname = argv[1];
	size = atoi(argv[2]);

	fd = open(fname, O_RDWR);
	if (fd < 0) {
		perror("open");
		exit(1);
	}

	for (i = 0; i < size; i++)
		cnt += write(fd, buf, sizeof(buf));

	printf("%d Mbytes written\n", cnt >> 20);

	fsync(fd);
	printf("fsync done.\n");

	close(fd);
	return 0;
}
