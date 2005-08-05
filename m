From: "Gary Funck" <gary@intrepid.com>
Subject: how to de-install LVM on the root partition?
Date: Thu, 4 Aug 2005 18:57:05 -0700
Message-ID: <HLEPJEEBEKBMAHLBCNMMOEDNCEAA.gary@intrepid.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
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


Hello,

We're running Fedora FC4, and when we did the install, we set up '/'
as a managed volume.  I'd like to revert '/' back to a regular
ext3 filesystem, but am uncertain as to how to do that.  I'm guessing
that parted won't cooperate if I ask it to change the partition from
LVM to ext3, or will it?  I know that I'll need to edit grub.conf,
and /etc/fstab once I've reverted '/', but need to know if there's
a way to do this other reformatting and restoring files from a
backup?
