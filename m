From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/2] dm-userspace: userspace code
Date: Wed, 25 Oct 2006 19:44:13 +0900
Message-ID: <20061025194413C.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This userspace program works with both interfaces. Compile it with
USE_RB defined for the ring buffer interface.

---
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

#include <errno.h>
#include <fcntl.h>
#include <libdevmapper.h>
#include <stdlib.h>
#include <sched.h>
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

#define QUEUE_SIZE (1024 << 10)

#define MKDEV(x,y) (((x << 8) & 0xFF00) | (y & 0xFF))

struct uring {
	uint32_t idx;
	char *buf;
	int size;
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

static void __map_rsp(struct dmu_msg *req, struct dmu_msg *rsp)
{
	rsp->hdr.msg_type = DM_USERSPACE_MAP_BLOCK_RESP;

	rsp->payload.map_rsp.new_block = req->payload.map_req.org_block;
	rsp->payload.map_rsp.offset = 0;
	rsp->payload.map_rsp.id_of_req = req->hdr.id;
	rsp->payload.map_rsp.flags = 0;

	rsp->payload.map_rsp.dst_maj = major;
	rsp->payload.map_rsp.dst_min = minor;
}

#ifdef USE_RB
static inline void ring_index_inc(struct uring *ring)
{
	ring->idx = (ring->idx == DMU_MAX_EVENTS - 1) ? 0 : ring->idx + 1;
}

static inline struct dmu_msg *head_ring_hdr(struct uring *ring)
{
	uint32_t pidx, off, pos;

	pidx = ring->idx / DMU_EVENT_PER_PAGE;
	off = ring->idx % DMU_EVENT_PER_PAGE;
	pos = pidx * PAGE_SIZE + off * sizeof(struct dmu_msg);

	return (struct dmu_msg *) (ring->buf + pos);
}

static int map_rsp_send(struct dmu_msg *req)
{
	struct dmu_msg *msg;

	msg = head_ring_hdr(&ukring);
	if (msg->hdr.status)
		return -ENOMEM;

	__map_rsp(req, msg);

	ring_index_inc(&ukring);
	msg->hdr.status = 1;

	return 0;
}

static void event_handler(int fd)
{
	struct dmu_msg *msg;
	int err;

retry:
	msg = head_ring_hdr(&kuring);
	if (!msg->hdr.status) {
		write(fd, &err, 1);
		return;
	}

	switch (msg->hdr.msg_type) {
	case DM_USERSPACE_MAP_BLOCK_REQ:
		err = map_rsp_send(msg);
		break;
	default:
		printf("unknown event %u\n", msg->hdr.msg_type);
	}

	if (err)
		write(fd, &err, 1);
	else {
		msg->hdr.status = 0;
		ring_index_inc(&kuring);
		goto retry;
	}
}
#else
static void event_handler(int fd)
{
	int ret, offset;
	struct dmu_msg *req, *rsp;

	ret = read(fd, kuring.buf, QUEUE_SIZE);
	if (ret < 0)
		return;

	kuring.size = ret;
	offset = 0;

	ukring.size = 0;

	while (offset < kuring.size) {
		req = (struct dmu_msg *) (kuring.buf + offset);
		offset += sizeof(*req);

		switch (req->hdr.msg_type) {
		case DM_USERSPACE_MAP_BLOCK_REQ:
			if (ukring.size + sizeof(*rsp) > QUEUE_SIZE) {
				write(fd, ukring.buf, ukring.size);
				ukring.size = 0;
			}
			rsp = (struct dmu_msg *) (ukring.buf + ukring.size);
			ukring.size += sizeof(*rsp);
			__map_rsp(req, rsp);
			break;
		default:
			printf("unknown event %u\n", req->hdr.msg_type);
		}
	}

	if (ukring.size)
		write(fd, ukring.buf, ukring.size);
}
#endif

int main(int argc, char **argv)
{
	int fd, err, size;
	char *buf;
	struct stat s;
	char path[1024];
	struct pollfd pfd[1];
	struct sched_param sp;

	if (argc != 2) {
		printf("Usage: %s <device>\n", argv[0]);
		exit(1);
	}

	if (mlockall(MCL_CURRENT | MCL_FUTURE)) {
		printf("failed to mlockall, exiting...");
		exit(1);
	}

	sp.sched_priority = sched_get_priority_max(SCHED_FIFO);
	err = sched_setscheduler(0, SCHED_FIFO, &sp);
	if (err < 0) {
		printf("fail to setschedular, %m\n");
		exit(1);
	}

	printf("I'm creating a device-mapper device called 'foo'.  \n"
	       "Be sure to remove it when you're done with this example\n"
	       "program! (run 'dmsetup remove foo')\n");

	if (stat(argv[1], &s)) {
		printf("fail to stat, %m\n");
		exit(1);
	}

	major = (s.st_rdev & 0xFF00) >> 8;
	minor = (s.st_rdev & 0x00FF);

	memset(path, 0, sizeof(path));
	/* Create a very simple device-mapper device with a small
	   section of sectors mapped to dm-userspace, at 512-byte
	   blocks */

	snprintf(path, sizeof(path),
		 "echo 0 `blockdev --getsize %s` userspace foo 4096 %d:%d |"
		 "dmsetup create foo",
		 argv[1], major, minor);

	system(path);

	/* Open the control device for the device-mapper device 'foo' */
	fd = dmu_ctl_open(get_dmu_ctl_device("foo"), 0);
	if (fd < 0) {
		printf("Failed to get control device\n");
		exit(1);
	}

#ifdef USE_RB
	size = DMU_RING_SIZE;

	buf = mmap(NULL, size * 2, PROT_READ | PROT_WRITE,
		   MAP_SHARED, fd, 0);
	if (buf == MAP_FAILED) {
		printf("fail to mmap, %m\n");
		return -EINVAL;
	}

	printf("Using the mmap interface.\n");
#else
	size = QUEUE_SIZE;
	buf = malloc(size * 2);
	if (!buf) {
		printf("fail to malloc, %m\n");
		return -ENOMEM;
	}

	printf("Using the system call interface.\n");
#endif

	kuring.idx = ukring.idx = 0;
	kuring.buf = buf;
	ukring.buf = buf + size;

	pfd[0].fd = fd;
	pfd[0].events = POLLIN | POLLOUT;

	while (1) {
		poll(pfd, 1, -1);
		event_handler(fd);
	}

	return 0;
}
