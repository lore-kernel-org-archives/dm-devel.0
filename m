From: "W. Michael Petullo" <mike@flyn.org>
Subject: Where did /dev/dm-X go?
Date: Sun, 26 Nov 2006 15:09:11 -0600
Message-ID: <20061126210911.GA8818@imp.flyn.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

I have been using the dm-crypt interface to perform disk encryption.
For example, I helped add dm-crypt/LUKS support to HAL[1].

Recently, I have found the cryptsetup no longer creates /dev/dm-X.
Instead, the only device node created by the utility is /dev/mapper/Y
(both were created previously.)  I am using an up to date Fedora Core 6.

I am trying to figure out what user-space tool/library was responsible
for creating /dev/dm-X and why this device node is no longer created when
I create a dm-crypt device.  Could anyone point me in the right direction?

The following bugs are related to this lack of /dev/dm-X device nodes
because these programs rely on these nodes to determine a dm-crypt
device's backing device:

Red Hat Bug 216538: Lack of /dev/dm-? breaks hal's encrypted/LUKS volume support
Red Hat Bug 124789: Add encrypted root filesystem support to mkinitrd

[1] http://www.redhat.com/magazine/012oct05/features/hal/

-- 
Mike

:wq
