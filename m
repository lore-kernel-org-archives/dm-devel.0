From: Yakov Hrebtov <hrebtov@gmail.com>
Subject: dm_crypt: very low performance of random IO operations
Date: Fri, 03 Sep 2010 14:28:41 +0600
Message-ID: <4C80B1B9.6040809@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060002060609040608080001"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------060002060609040608080001
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit

I'm experirncing problems with performance of random IO operations of 
dm_crypt-encrypted devices.
Sequential IO is good (using AES-NI gives almost no difference comparing with 
unencrypted device), but random IO is poor comparing with unencrypted devices.

For benchmarking i've used simple utility, that reading small pieces of data 
from a raw disk device, in a random access pattern. The utility measures the 
number of seeks per second (reading operations per second), the device can do.

The source code of utility is attached. Also avalilable via link 
http://www.linuxinsight.com/files/seeker.c

I've tested 2 RAID arrays:
1. RAID 10 of 4 x Intel X25-E SSD drives (/dev/sdb)
2. RAID 10 of 8 x Seagate Savvio 15K 2.5" SAS drives (/dv/sdc)

Both arrays is handled by Adaptec 5805Z RAID card.

I've created encrypted mappings with:
cryptsetup --cipher=aes-cbc-essiv:sha256 --key-size=256 create cfs1 /dev/sdb
cryptsetup --cipher=aes-cbc-essiv:sha256 --key-size=256 create cfs2 /dev/sdc

Testing results:
1. SSD array:
    /dev/sdb: 3320 seeks/second
    /dev/mapper/cfs1: 99 seeks/second
2. SAS array:
    /dev/sdc: 257 seeks/second
    /dev/mapper/cfs2: 85 seeks/second

As you see the difference between clear and encrypted devices is huge, 
especially in SSD case.

The current behavior makes almost impossible to use encrypted devices to handle 
databases. You know, the typical database workload is random IO operations.

These tests done using kernel:
2.6.32-24-server #39-Ubuntu SMP x86_64 GNU/Linux

Some months before i've investigated also other kernels and distributions. The 
behavior is very similar.
If you need any additional info, a can provide it.

What do you think about this issue?

Thank you.



--------------060002060609040608080001
Content-Type: image/x-xbitmap;
 name="seeker.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="seeker.c"

#define _LARGEFILE64_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <time.h>
#include <signal.h>
#include <sys/fcntl.h>
#include <sys/ioctl.h>
#include <linux/fs.h>

#define BLOCKSIZE 512
#define TIMEOUT 30

int count;
time_t start;

void done()
{
	time_t end;

	time(&end);

	if (end < start + TIMEOUT) {
		printf(".");
		alarm(1);
		return;
	}

	if (count) {
	  printf(".\nResults: %d seeks/second, %.2f ms random access time\n",
		 count / TIMEOUT, 1000.0 * TIMEOUT / count);
	}
	exit(EXIT_SUCCESS);
}

void handle(const char *string, int error)
{
	if (error) {
		perror(string);
		exit(EXIT_FAILURE);
	}
}

int main(int argc, char **argv)
{
	char buffer[BLOCKSIZE];
	int fd, retval;
	unsigned long numblocks;
	off64_t offset;

	setvbuf(stdout, NULL, _IONBF, 0);

	printf("Seeker v2.0, 2007-01-15, "
	       "http://www.linuxinsight.com/how_fast_is_your_disk.html\n");

	if (argc != 2) {
		printf("Usage: seeker <raw disk device>\n");
		exit(EXIT_SUCCESS);
	}

	fd = open(argv[1], O_RDONLY);
	handle("open", fd < 0);

	retval = ioctl(fd, BLKGETSIZE, &numblocks);
	handle("ioctl", retval == -1);
	printf("Benchmarking %s [%luMB], wait %d seconds",
	       argv[1], numblocks / 2048, TIMEOUT);

	time(&start);
	srand(start);
	signal(SIGALRM, &done);
	alarm(1);

	for (;;) {
		offset = (off64_t) numblocks * random() / RAND_MAX;
		retval = lseek64(fd, BLOCKSIZE * offset, SEEK_SET);
		handle("lseek64", retval == (off64_t) -1);
		retval = read(fd, buffer, BLOCKSIZE);
		handle("read", retval < 0);
		count++;
	}
	/* notreached */
}

--------------060002060609040608080001
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------060002060609040608080001--
