From: Richard Davies <richard@arachsys.com>
Subject: Occasional dmsetup resume lockups
Date: Thu, 11 Feb 2016 20:47:37 +0000
Message-ID: <20160211204736.GA18164@alpha.arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hi,

We have been seeing occasional "dmsetup resume" lockups on a variety of
kernels when swapping tables.

I am wondering if we are making a simple scripting mistake
(e.g. we do not run "dmsetup suspend", but my impression is that the need
for this was replaced by INACTIVE tables?)

Alternatively, what can we do to help debug this further, please?


In more detail:

We have a script which backs up a live block device DRIVE using a
temporary dm-raid1.

While a backup is going on, there are 3 devices:

ORIGIN is a dm-crypt over a local block device (the original)
SYNC is a dm-linear over a remote iscsi device (the backup)
DRIVE is a dm-raid1 of ORIGIN and SYNC (doing the backup)

Several minutes after the raid array for DRIVE is in-sync, we run:

  blockdev --flushbufs DRIVE
  TABLE=`dmsetup --showkeys table ORIGIN`
  // We don't run dmsetup suspend here, we think it is no longer required?
  dmsetup reload DRIVE --table "$TABLE"
  dmsetup resume DRIVE

Most of the time this works, but sometimes "dmsetup resume" hangs forever.
strace shows it hanging in the DM_DEV_SUSPEND ioctl.

While a hang is ongoing:

"dmsetup info DRIVE" shows "Tables present: LIVE". The INACTIVE table is no
longer listed.

"dmsetup --showkeys table DRIVE" still shows the dm-raid1

We have seen this on kernels from 3.8.6 to 4.1.12.

There is nothing in the kernel log after the dm-raid1 rebuild logging.


Do we have a script bug, or if not, how can we help debug this further?

Thanks,

Richard.
