From: =?UTF-8?B?S2FpIEzDvGtl?= <kailueke@riseup.net>
Subject: Partition size set to 0 when resizing extended and
 adding logical partition with BLKPG
Date: Tue, 9 Apr 2019 18:41:04 +0200
Message-ID: <3e5e466a-dacf-d18e-9eff-e89b5f93bfd2@riseup.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------765FF5BEE1BA035E2CC76FE5"
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: de-DE
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: axboe@kernel.dk, vgoyal@redhat.com, psusi@ubuntu.com
Cc: "vtrefny@redhat.com" <vtrefny@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------765FF5BEE1BA035E2CC76FE5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hello,

I write to you because I believe that the BLKPG ioctl misbehaves when an
existing extended MBR partition is changed and a logical partition added
in it.
Should I report like this or should I sign up for bugzilla.kernel.org?

The /sys/block/sdx/sdxY/size entry is set to 0 and even opening the
extended partition fails.
This leads to e.g. udevd failing to have access.
https://github.com/storaged-project/udisks/issues/425

To fix this situation from userspace, a BLKRRPART ioctl is needed.

To reproduce it, I attached a small program, which you can run on this
prepared image or on any drive with a single extended partition on it.

$ wget http://kailueke.spline.de/test.img
$ udisksctl loop-setup -f test.img

$ sudo ./sim loop0
new size in /sys/block/loop0/loop0p1/size: 0
issuing BLKRRPART
new size in /sys/block/loop0/loop0p1/size: 2


Do you think that this should be fixed in the kernel?
Regards,
Kai Lüke


--------------765FF5BEE1BA035E2CC76FE5
Content-Type: text/x-csrc;
 name="sim.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sim.c"

#include <errno.h>
#include <fcntl.h>
#include <linux/blkpg.h>
#include <linux/fs.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

int resizepart(char *path, int start, int fd) {
  struct blkpg_partition part;
  struct blkpg_ioctl_arg ioctl_arg;
  memset(&part, 0, sizeof(part));
  part.start = start;
  part.length = 1;
  part.pno = 1;
  strncpy(part.devname, path, BLKPG_DEVNAMELTH);
  ioctl_arg.op = BLKPG_RESIZE_PARTITION;
  ioctl_arg.flags = 0;
  ioctl_arg.datalen = sizeof(struct blkpg_partition);
  ioctl_arg.data = (void *)&part;
  if (ioctl(fd, BLKPG, &ioctl_arg) == -1) {
    perror(strerror(errno));
    exit(errno);
  }
}

int addpart(char *path, int start, int fd) {
  struct blkpg_partition part;
  struct blkpg_ioctl_arg ioctl_arg;
  memset(&part, 0, sizeof(part));
  part.start = start + 2097152;
  part.length = 10485760; /* 10 MB */
  part.pno = 5;
  strncpy(part.devname, path, BLKPG_DEVNAMELTH);
  ioctl_arg.op = BLKPG_ADD_PARTITION;
  ioctl_arg.flags = 0;
  ioctl_arg.datalen = sizeof(struct blkpg_partition);
  ioctl_arg.data = (void *)&part;
  if (ioctl(fd, BLKPG, &ioctl_arg) == -1) {
    perror(strerror(errno));
    exit(errno);
  }
}

int main(int argc, char **argv) {
  char *disk;
  char *existing_extended_part;
  char *new_logical_part;
  int fd;
  int read_fd;
  char path[100];
  char buf[100];
  int start;
  const char *loopback = "";
  if (argc != 2) {
    printf("Usage: %s sdb \nAnnounces a logical sdb5 partition to the kernel "
           "on MBR drive /dev/sdb, which must only have a single extended "
           "partition (sdb1) and no logical partitons present yet.\nThis is "
           "done with BLKPG calls to issue a resize call for sdb1 and an add "
           "call for sdb5.\nThe observed problem is that the kernel then has a "
           "zero size for the extended partition (thus, nothing can access it "
           "anymore). Only a BLKRRPART can fix it again, as will be done here "
           "when a zero size is detected.\n\nEven when the BLKRRPART is "
           "removed here,"
           "after this program ends, udev will anyway trigger a BLKRRPART,"
           "therefore, you may have to pause udevd if it is"
           "interfering with a command you want to run afterwards:\n"
           "sudo kill -s STOP `pgrep udevd`\nThen, after running all you "
           "commands, "
           "you can continue udevd again:\nsudo kill -s CONT `pgrep udevd`",
           argv[0]);
    return -1;
  }
  disk = argv[1];
  if (strncmp(disk, "loop", 4) == 0)
    loopback = "p";
  memset(path, 0, sizeof(path));
  snprintf(path, sizeof(path), "/sys/block/%s/%s%s1/start", disk, disk,
           loopback);
  read_fd = open(path, O_RDONLY);
  if (read_fd == -1) {
    perror(strerror(errno));
    exit(errno);
  }
  memset(buf, 0, sizeof(buf));
  if (read(read_fd, buf, sizeof(buf)) == -1)
    return -1;
  close(read_fd);
  start = atoi(buf) * 512;
  memset(path, 0, sizeof(path));
  snprintf(path, sizeof(path), "/dev/%s", disk);
  fd = open(path, O_RDWR);
  if (fd == -1) {
    perror(strerror(errno));
    exit(errno);
  }
  /* order can be reversed to add/resize and the result is still the same:
   * /sys/block/sdb/sdb1/size containing a 0 instead of 1 or 2 */

  memset(path, 0, sizeof(path));
  snprintf(path, sizeof(path), "/dev/%s%s1", disk, loopback);
  resizepart(path, start, fd);

  memset(path, 0, sizeof(path));
  snprintf(path, sizeof(path), "/dev/%s%s5", disk, loopback);
  addpart(path, start, fd);

  /* even adding this again as last step does not help */
  memset(path, 0, sizeof(path));
  snprintf(path, sizeof(path), "/dev/%s%s1", disk, loopback);
  resizepart(path, start, fd);

  /* fetch value now for convenience and also because no interfering BLKRRPART
   * was done yet by other programs */
  memset(path, 0, sizeof(path));
  snprintf(path, sizeof(path), "/sys/block/%s/%s%s1/size", disk, disk,
           loopback);
  while (1) {
    memset(buf, 0, sizeof(buf));
    read_fd = open(path, O_RDONLY);
    if (read_fd == -1 || read(read_fd, buf, sizeof(buf)) == -1) {
      printf("could not fetch %s\n", path);
      if (read_fd != -1)
        close(read_fd);
      perror(strerror(errno));
      exit(errno);
    }
    close(read_fd);
    printf("new size in %s: %s\n", path, buf);
    if (atoi(buf) != 0) {
      break;
    }
    ioctl(fd, BLKRRPART, 0);
    printf("issuing BLKRRPART\n");
  }
  close(fd);
  return 0;
}

--------------765FF5BEE1BA035E2CC76FE5
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------765FF5BEE1BA035E2CC76FE5--
