From: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Subject: [PATCH v6 0/3] dm: boot a mapped device without an
	initramfs
Date: Tue, 18 Apr 2017 18:42:37 +0200
Message-ID: <20170418164240.18079-1-enric.balletbo@collabora.com>
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
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>
Cc: Guenter Roeck <groeck@google.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>
List-Id: dm-devel.ids

Hello,

Some of these patches were send few years back, I saw that first
version was send to this list in 2010, and after version 4 did not
land [1]. Some days ago I resend the patches [2] and few hours later I
noticed that one year ago was send a v5 version [3] and I was not aware.

There was some discussion about v5 and during the discussion Mike Snitzer
proposed that at least a change of the syntax is required, we're really
interested on see this upstream as is extensively used in ChromeOS based
devices so I'm wondering if we can restart the discussion and hopefully
we will be able to do the modifications needed.

So my first question is, apart of the change of the syntax, what more
should be changed?

Thanks for your help,
 Enric

[1] Patchwork links:
    https://patchwork.kernel.org/patch/104857/
    https://patchwork.kernel.org/patch/104856/
    https://patchwork.kernel.org/patch/104858/

[2] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1375276.html

[3] https://www.redhat.com/archives/dm-devel/2016-February/msg00112.html


Brian Norris (1):
  dm: make some mapped_device functions available

Will Drewry (2):
  dm: export a table+mapped device to the ioctl interface
  init: add support to directly boot to a mapped device

 Documentation/admin-guide/kernel-parameters.rst |   1 +
 Documentation/admin-guide/kernel-parameters.txt |   3 +
 Documentation/device-mapper/boot.txt            |  65 ++++
 drivers/md/dm-ioctl.c                           |  36 ++
 drivers/md/dm.h                                 |   8 -
 include/linux/device-mapper.h                   |  19 +
 init/Makefile                                   |   1 +
 init/do_mounts.c                                |   1 +
 init/do_mounts.h                                |  10 +
 init/do_mounts_dm.c                             | 448 ++++++++++++++++++++++++
 10 files changed, 584 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/device-mapper/boot.txt
 create mode 100644 init/do_mounts_dm.c

-- 
2.9.3
