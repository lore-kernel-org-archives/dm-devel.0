From: Patrick Mansfield <patmans@us.ibm.com>
Subject: udev user specified or human readable /dev names
Date: Tue, 1 Nov 2005 14:53:57 -0800
Message-ID: <20051101225357.GA13215@us.ibm.com>
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
To: linux-hotplug-devel@lists.sourceforge.net, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi -

Per posts and an accepted patch on dm-devel about dm multipath user
friendly names:

https://www.redhat.com/archives/dm-devel/2005-October/msg00004.html
https://www.redhat.com/archives/dm-devel/2005-October/msg00067.html

But the above is a dm multipath only solution.

It's a good idea to allow user specified names on top of the
/dev/disk/by-* device names. Though dm likely needs a dm_id in order to
support the method outlined here.

If we could set and compare environment variables, or compare SYMLINK, a
separate rules file (doesn't have to be separate, just seems like a good
idea) could be used to add symlinks to user specified names.

i.e. move udev_rules.c:apply_format() into udev_utils.c, and call it
before comparison as well as before (AFAIUI) generating names, though I
somehow doubt the change is that simple.

Then, we could have rules like:

KERNEL=="sd*[!0-9]|sr*|dasd*[!0-9]", ENV{ID_SERIAL}=="?*", ENV{ID_FULL_PATH}="disk/by-id/$env{ID_BUS}-$env{ID_SERIAL}"
ENV{ID_FULL_PATH}=="?*", SYMLINK+="$env{ID_FULL_PATH}"

And for each device that we want to give a user specified name, use (would
also need partition specific rules):

ENV{ID_FULL_PATH}=="disk/by-id/scsi-360a98000686f68656c6e7a416f4b6849" SYMLINK+="media-files"

And similar for the other disk/by-* methods.

Any comments on the above? 

Is my rule just wrong, or is there a better method?

Running with udev 069 on FC rawhide, with these rules:

SYMLINK=="*foo*" SYMLINK+="user/bar"

KERNEL="sdm" ENV{VAL1}="somevalue"
KERNEL="sdm" ENV{VAL2}="$env{VAL1}"

KERNEL="sdm" SYMLINK+="user/show-val1-$env{VAL1}"
KERNEL="sdm" SYMLINK+="user/show-val2-$env{VAL2}"

ENV{VAL1}=="somevalue" SYMLINK+="user/val1"
ENV{VAL2}=="somevalue" SYMLINK+="user/val2"

Do not work as might be expected: since the env values are not expanded,
the last rule never matches, and user/val2 link is never created. The
above generated (sdaz is the last device found):

[elm3a49 ~]$ ls -l /dev/user
total 0
lrwxrwxrwx  1 root root 7 Nov  1 14:18 bar -> ../sdaz
lrwxrwxrwx  1 root root 6 Nov  1 14:18 show-val1-somevalue -> ../sdm
lrwxrwxrwx  1 root root 6 Nov  1 14:18 show-val2-somevalue -> ../sdm
lrwxrwxrwx  1 root root 6 Nov  1 14:18 val1 -> ../sdm

-- Patrick Mansfield
