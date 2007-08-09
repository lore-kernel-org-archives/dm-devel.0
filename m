From: Roger Heflin <rheflin@atipa.com>
Subject: Buffer I/o error on device dm-0 with no underlying
	hardware errors
Date: Thu, 09 Aug 2007 12:55:03 -0500
Message-ID: <46BB54F7.2030800@atipa.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I have a customer running a 2.6.9-42.0.10.ELsmp kernel,
with a MPT scsi card connected to an external array, several
times so far they have gotten an error similar to this:
  Buffer I/O error on device dm-0, logical block 742625682

There are no errors of any type before this error, and the
machine stays up and continues logging all errors
(this is not the boot device).  After 10-15 of these
errors with various block numbers ext3 of course notices
and starts giving errors that result in the filesystem
failing.

The setup is ext3 -> LVM -> sda

NFS is also being used but I don't think it plays any part
in the problem.

No errors of any type are being logged for sda, and
doing a dd if=/dev/sda of=/dev/null after the problem has
occured before the reboot finishes with no
errors being generated.

They previously used XFS and got similar failures.

I have searched everything I can find, and can only find
that this error should not be possible by itself.

Rebooting the machine fixes the problem until it happens
again several days to a week later.

Given no scsi errors and that the dm layer does not
yell about the scsi layer below it, it really does not
look like a hardware error.

So far nothing synthetic has been able to duplicate the
error.

The machine has ecc and it is being monitored by they
bluesmoke/edac modules and it not getting any memory errors.

                             Roger
