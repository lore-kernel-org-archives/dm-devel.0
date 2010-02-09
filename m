From: Daniel Stodden <daniel.stodden@citrix.com>
Subject: multipath: Path checks on open-iscsi software initiators
Date: Mon, 8 Feb 2010 17:18:09 -0800
Message-ID: <1265678289.2221.162.camel@agari.van.xensource.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-CzAwbdfsFmh4uFN5+l6P"
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--=-CzAwbdfsFmh4uFN5+l6P
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit


Hi.

I've recently been spending some time tracing path checks on iSCSI
targets.

Samples described here were taken with the directio checker on a netapp
lun, but I believe the target kind doesn't matter here, since most of
what I find is rather driven by the initiator side.

So what I see is:

1. The directio checker issues its aio read on sector0.

2. The request obviously will block until iscsi is giving up on it.
  This typically happens not before target pings (noop-out ops) 
  issued internally by the initiator time out. Look like:

  iscsid: Nop-out timedout after 15 seconds on connection 1:0 
  state (3). Dropping session.

  (period and timeouts depend on the configuration at hand).

3. Session failure still won't unblock the read. This is because the
  iscsi session will enter recovery mode, to avoid failing the
  data path right away. The device will enter blocked state during 
  that period. 

  Since I'm provoking a complete failure, this will time out as well, 
  but only later:

  iscsi: session recovery timed out after 15 secs

  (again, timeouts are iscsid.conf-dependent)

4. This will finally unblock the directio check with EIO, 
   triggering the path failure.


My main issue is that a device sitting on a software iscsi initiator

 a) performs its own path failure detection and
 b) defers data path operations to mask failures, 
    which obviously counteracts a checker based on
    data path operations.

Kernels somewhere during the 2.6.2x series apparently started to move
part of the session checks into the kernel (apparently including the
noop-out itself, but I don't). One side effect of that is that session
state can be queried via sysfs. 

So right now I'm mainly wondering if a multipath failure driven rather
by polling session state that a data read wouldn't be more effective? 

I've only been browsing part of the iscsi code by now, but I don't see
how data path failures wouldn't relate to session state.

There's some code attached below to demonstrate that. It presently jumps
through some extra loops to reverse-map fd back to the block device
node, but the basic thing was relatively straightforward to implement.

Thanks in advance for about any input on that matter.

Cheers,
Daniel 





   



--=-CzAwbdfsFmh4uFN5+l6P
Content-Disposition: attachment; filename="open-iscsi.c"
Content-Type: text/x-csrc; name="open-iscsi.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

/*
 * Copyright (c) 2010, Citrix Systems, Inc.
 * All rights reserved.
 *
 * Author: Daniel Stodden <daniel.stodden@citrix.com>
 *
 * This  library is  free  software; you  can  redistribute it  and/or
 * modify it under the terms  of the GNU Lesser General Public License
 * as published by  the Free Software Foundation; either  version 2 of
 * the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT  ANY  WARRANTY;  without   even  the  implied  warranty  of
 * MERCHANTABILITY or  FITNESS FOR A PARTICULAR PURPOSE.   See the GNU
 * Lesser General Public License for more details.
 *
 * You should  have received a copy  of the GNU  Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 * USA
 */

#define _BSD_SOURCE

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <linux/major.h>

#include "checkers.h"
#include "../libmultipath/debug.h"

#define MODULE OPEN_ISCSI

#define __MSG(_c, _fmt, _args ...) snprintf((c)->message, CHECKER_MSG_LEN, _fmt, ##_args);

struct open_iscsi_ctx {
	char state_path[128];
	char state_last[32];
};

static int
_major_idx(dev_t rdev)
{
	int _major = major(rdev);

	switch (_major) {
	case SCSI_DISK0_MAJOR:
		return 0;
	case SCSI_DISK1_MAJOR ... SCSI_DISK7_MAJOR:
		return _major - SCSI_DISK1_MAJOR + 1;
	case SCSI_DISK8_MAJOR ... SCSI_DISK15_MAJOR:
		return _major - SCSI_DISK8_MAJOR + 8;
	}

	return -EINVAL;
}

static int
scsi_disk_index(dev_t rdev)
{
	unsigned int index;
	int _minor;

	index  = _major_idx(rdev) << 4;
	if (index < 0)
		return index;

	_minor = minor(rdev);
	index |= ((_minor >> 4) & 0xf) | (_minor & 0xfff00);

	return index;
}

int
scsi_block_name(int fd, char *buf, size_t len)
{
	unsigned int index;
	struct stat st;
	int n, err;

	err = fstat(fd, &st);
	if (err)
		return -errno;

	index = scsi_disk_index(st.st_rdev);
	if (index < 0)
		return index;

	switch (index) {
	case 0 ... 26:
		n = snprintf(buf, len, "sd%c",
			     'a' + index % 26);
		break;
	case 27 ... (26 + 1) * 26:
		n = snprintf(buf, len, "sd%c%c",
			     'a' + index / 26 - 1,
			     'a' + index % 26);
		break;
	default:
		n = snprintf(buf, len, "sd%c%c%c",
			     'a' + (index / 26 - 1) / 26 - 1,
			     'a' + (index / 26 - 1) % 26,
			     'a' + index % 26);
	}

	if (n >= len)
		return -EFAULT;

	return 0;
}

static int
open_iscsi_session_path(int fd, char *path, size_t len)
{
	char name[8];
	char link[64];
	ssize_t n;
	int host, session, err;

	err = scsi_block_name(fd, name, sizeof(name));
	if (err)
		return err;

	n = snprintf(link, sizeof(link),
		     "/sys/block/%s/device", name);
	if (n >= sizeof(link))
		return -EFAULT;

	n = readlink(link, path, len);
	if (n < 0)
		return -errno;

	n = sscanf(path,
		   "../../devices/platform/host%d/session%d/target",
		   &host, &session);
	if (n != 2)
		return -EBADE;

	n = snprintf(path, len,
		     "/sys/class/iscsi_session/session%d/state",
		     session);
	if (n >= len)
		return -EFAULT;

	return 0;
}

int
open_iscsi_check(struct checker *c)
{
	struct open_iscsi_ctx *s = c->context;
	int fd, state, err;
	ssize_t n;

	fd = open(s->state_path, O_RDONLY);
	if (fd < 0) {
		err = -errno;
		goto fail;
	}

	n = read(fd, s->state_last, sizeof(s->state_last));
	if (n < 0) {
		err = -errno;
		goto fail;
	}
	if (!n || n >= sizeof(s->state_last)) {
		err = -EFAULT;
		goto fail;
	}

	s->state_last[n - 1] = 0;

	if (!strcmp(s->state_last, "LOGGED_IN\n"))
		state = PATH_UP;
	else
		state = PATH_DOWN;

out:
	if (fd)
		close(fd);

	return state;

fail:
	__MSG(c, MODULE ": path check failed: %s", strerror(-err));
	state = PATH_UP;
	goto out;
}

int
open_iscsi_init(struct checker * c)
{
	struct open_iscsi_ctx *s;
	int err;

	s = malloc(sizeof(struct open_iscsi_ctx));
	if (!s) {
		err = -errno;
		goto fail;
	}

	err = open_iscsi_session_path(c->fd,
				      s->state_path,
				      sizeof(s->state_path));
	if (err)
		goto fail;

	c->context = s;

	return 0;

fail:
	if (s)
		free(s);
	condlog(1, MODULE ": failed to initialize: %s", strerror(-err));
	return 1;
}

void
open_iscsi_free(struct checker * c)
{
	free(c->context);
	c->context = NULL;
}

--=-CzAwbdfsFmh4uFN5+l6P
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-CzAwbdfsFmh4uFN5+l6P--
