From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: dm-userspace (no in-kernel cache version)
Date: Tue, 12 Sep 2006 09:50:41 +0900
Message-ID: <20060912095041U.fujita.tomonori@lab.ntt.co.jp>
References: <20060912080748X.fujita.tomonori@lab.ntt.co.jp>
	<m3zmd5rk8y.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Tue_Sep_12_09:50:36_2006_809)--"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3zmd5rk8y.fsf@guaranine.beaverton.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

----Next_Part(Tue_Sep_12_09:50:36_2006_809)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

From: Dan Smith <danms@us.ibm.com>
Subject: Re: [dm-devel] dm-userspace (no in-kernel cache version)
Date: Mon, 11 Sep 2006 17:39:25 -0700

> FT> As explained, this removes rmap (in-kernel cache) and use mmaped
> FT> buffer instead of read/write system calls for user/kernel
> FT> communication.
> 
> Ok, I'll start looking over your changes tomorrow and will make an
> attempt at an apples-to-apples comparison with the map cache
> approach. 

Thanks a lot.


> Can you post your userspace code here too?

I've attached a modified version of your example program in libdmu.

----Next_Part(Tue_Sep_12_09:50:36_2006_809)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="example-rb.c"

/*
 * Copyright (C) International Business Machines Corp., 2006
 * Author: Dan Smith <danms@us.ibm.com>
 *
 * This file is subject to the terms and conditions of the GNU Lesser
 * General Public License. See the file COPYING in the main directory
 * of this archive for more details.
 *
 */
/*
 * This example program demonstrates a trivial use of the dmu library
 * for userspace orchestration of a device-mapper pseudo-device.
 * Here, we simply map all reads and writes to the device given as the
 * first argument to the program.  For example:
 *
 *  # ./example /dev/ram0
 *
 * will create a device /dev/mapper/foo in which all accesses are
 * redirected to /dev/ram0.
 */

#define aligned_u64 unsigned long long __attribute__((aligned(8)))

#include <errno.h>
#include <fcntl.h>
#include <libdevmapper.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <linux/dm-userspace.h>
#include <sys/stat.h>
#include <poll.h>
#include <sys/mman.h>

#define PAGE_SHIFT 12
#define PAGE_SIZE (1UL << PAGE_SHIFT)

#define MKDEV(x,y) (((x << 8) & 0xFF00) | (y & 0xFF))

struct uring {
	uint32_t idx;
	char *buf;
};

static struct uring kuring, ukring;
static int major, minor;

int dmu_ctl_open(char *ctl_dev, int flags)
{
	int ctl_fd;

	if (!ctl_dev)
		return -EEXIST;

	ctl_fd = open(ctl_dev, O_RDWR | flags);

	return ctl_fd;
}

static void get_dm_control_dev(char *dm_device, unsigned *maj, unsigned *min)
{
	struct dm_task *task;
	int ret;
	void *next = NULL;
	uint64_t start, length;
	char *ttype = NULL, *params = NULL;

	task = dm_task_create(DM_DEVICE_STATUS);

	ret = dm_task_set_name(task, dm_device);
	if (!ret) {
		printf("Failed to set name\n");
		dm_task_destroy(task);
		return;
	}

	ret = dm_task_run(task);
	if (!ret) {
		printf("Failed to run task\n");
		dm_task_destroy(task);
		return;
	}

	ret = 0;
	do {
		next = dm_get_next_target(task, next, &start, &length,
					  &ttype, &params);

		if (strcmp(ttype, "userspace") == 0) {
			ret = sscanf(params, "%x:%x", maj, min);
			if (ret == 2)
				break;
		}

	} while (next);
}

static int make_device_node(unsigned major, unsigned minor)
{
	char path[256];

	sprintf(path, "/dev/dmu%i", minor);

	return mknod(path, S_IFCHR, MKDEV(major, minor));
}

char *get_dmu_ctl_device(char *dm_device)
{
	unsigned ctl_major, ctl_minor;
	static char path[256];

	get_dm_control_dev(dm_device, &ctl_major, &ctl_minor);

	if (ctl_major == 0) {
		fprintf(stderr, "Unable to get device number\n");
		return NULL;
	}

	sprintf(path, "/dev/dmu%i", ctl_minor);

	if (access(path, R_OK | W_OK)) {
		if (make_device_node(ctl_major, ctl_minor))
			return NULL;
	}

	return path;
}

static inline void ring_index_inc(struct uring *ring)
{
	ring->idx = (ring->idx == DMU_MAX_EVENTS - 1) ? 0 : ring->idx + 1;
}

static inline struct dmu_event *head_ring_hdr(struct uring *ring)
{
	uint32_t pidx, off, pos;

	pidx = ring->idx / DMU_EVENT_PER_PAGE;
	off = ring->idx % DMU_EVENT_PER_PAGE;
	pos = pidx * PAGE_SIZE + off * sizeof(struct dmu_event);

	return (struct dmu_event *) (ring->buf + pos);
}

static int kreq_send(struct dmu_event *p)
{
	struct dmu_event *ev;
	ev = head_ring_hdr(&ukring);
	if (ev->status)
		return -ENOMEM;

	memcpy(ev, p, sizeof(*p));
	ring_index_inc(&ukring);
	ev->status = 1;

	return 0;
}

static int map_rsp_send(uint64_t id, uint64_t block)
{
	struct dmu_event ev;

	memset(&ev, 0, sizeof(ev));

	ev.type = DM_USERSPACE_MAP_BLOCK_RSP;
	ev.u.map_rsp.id = id;
	ev.u.map_rsp.flags = DMU_FLAG_VALID;
	ev.u.map_rsp.block = block;
	ev.u.map_rsp.dst_maj = major;
	ev.u.map_rsp.dst_min = minor;
	return kreq_send(&ev);
}

static void event_handler(int fd)
{
	struct dmu_event *ev;
	char buf[1];
	int err, count = 0;

retry:
	ev = head_ring_hdr(&kuring);
	if (!ev->status) {
		if (count)
			write(fd, buf, 1);
		return;
	}

	switch (ev->type) {
	case DM_USERSPACE_MAP_BLOCK_REQ:
		err = map_rsp_send(ev->k.map_req.id, ev->k.map_req.block);
		break;
	case DM_USERSPACE_MAP_BLOCK_DONE:
		break;
	default:
		printf("unknown event %u\n", ev->type);
	}

	if (err)
		write(fd, buf, 1);
	else {
		ev->status = 0;
		ring_index_inc(&kuring);
		count++;
		goto retry;
	}
}

int main(int argc, char **argv)
{
	int fd;
	char *buf;
	struct stat s;
	char path[1024];
	struct pollfd pfd[1];

	if (argc != 2) {
		printf("Usage: %s <device>\n", argv[0]);
		exit(1);
	}

	printf("I'm creating a device-mapper device called 'foo'.  \n"
	       "Be sure to remove it when you're done with this example\n"
	       "program! (run 'dmsetup remove foo')\n");

	if (stat(argv[1], &s)) {
		printf("fail to stat, %m\n");
		return -errno;
	}

	major = (s.st_rdev & 0xFF00) >> 8;
	minor = (s.st_rdev & 0x00FF);

	memset(path, 0, sizeof(path));
	/* Create a very simple device-mapper device with a small
	   section of sectors mapped to dm-userspace, at 512-byte
	   blocks */
	snprintf(path, sizeof(path),
		 "echo 0 8192 userspace foo 512 %d:%d | dmsetup create foo",
		 major, minor);

	system(path);

	/* Open the control device for the device-mapper device 'foo' */
	fd = dmu_ctl_open(get_dmu_ctl_device("foo"), 0);
	if (fd < 0) {
		printf("Failed to get control device\n");
		exit(1);
	}

	buf = mmap(NULL, DMU_RING_SIZE * 2, PROT_READ | PROT_WRITE,
		   MAP_SHARED, fd, 0);
	if (buf == MAP_FAILED) {
		printf("fail to mmap, %m\n");
		return -EINVAL;
	}

	printf("success\n");

	kuring.idx = ukring.idx = 0;
	kuring.buf = buf;
	ukring.buf = buf + DMU_RING_SIZE;

	pfd[0].fd = fd;
	pfd[0].events = POLLIN | POLLOUT;

	while (1) {
		poll(pfd, 1, -1);
		event_handler(fd);
	}

	return 0;
}

----Next_Part(Tue_Sep_12_09:50:36_2006_809)--
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


----Next_Part(Tue_Sep_12_09:50:36_2006_809)----
