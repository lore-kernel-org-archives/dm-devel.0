From: Takashi Sato <t-sato@yk.jp.nec.com>
Subject: [RFC PATCH 0/3] freeze feature ver 1.2
Date: Mon, 28 Apr 2008 19:29:20 +0900
Message-ID: <20080428192920t-sato__44331.4004609876$1209378639$gmane$org@mail.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, dm-devel@redhat.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

Hi,

I have re-based my freeze patches from linux-2.6.25-rc7 to
linux-2.6.25.
There is no functional change from the previous version.
The patch-set consists of the following three patches.

[PATCH 1/3] Implement generic freeze feature
  The ioctls for the generic freeze feature are below.
  o Freeze the filesystem
    int ioctl(int fd, int FIFREEZE, arg)
      fd: The file descriptor of the mountpoint
      FIFREEZE: request code for the freeze
      arg: Ignored
      Return value: 0 if the operation succeeds. Otherwise, -1

  o Unfreeze the filesystem
    int ioctl(int fd, int FITHAW, arg)
      fd: The file descriptor of the mountpoint
      FITHAW: request code for unfreeze
      arg: Ignored
      Return value: 0 if the operation succeeds. Otherwise, -1

[PATCH 2/3] Remove XFS specific ioctl interfaces for freeze feature
  It removes XFS specific ioctl interfaces and request codes
  for freeze feature.
  This patch has been supplied by David Chinner.

[PATCH 3/3] Add timeout feature
  The timeout feature is added to freeze ioctl.  And new ioctl
  to reset the timeout period is added.
  o Freeze the filesystem
    int ioctl(int fd, int FIFREEZE, long *timeval)
    fd: The file descriptor of the mountpoint
    FIFREEZE: request code for the freeze
    timeval: the timeout period in seconds
             If it's 0 or 1, the timeout isn't set.
             This special case of "1" is implemented to keep
             the compatibility with XFS applications.
    Return value: 0 if the operation succeeds. Otherwise, -1

  o Reset the timeout period
    This is useful for the application to set the timeval more accurately.
    For example, the freezer resets the timeval to 10 seconds every 5
    seconds.  In this approach, even if the freezer causes a deadlock
    by accessing the frozen filesystem, it will be solved by the timeout
    in 10 seconds and the freezer can recognize that at the next reset
    of timeval.
    int ioctl(int fd, int FIFREEZE_RESET_TIMEOUT, long *timeval)
      fd:file descriptor of mountpoint
      FIFREEZE_RESET_TIMEOUT: request code for reset of timeout period
      timeval: new timeout period in seconds
      Return value: 0 if the operation succeeds. Otherwise, -1
      Error number: If the filesystem has already been unfrozen,
                    errno is set to EINVAL.

Any comments are very welcome.

Cheers, Takashi
