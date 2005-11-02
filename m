From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: udev user specified or human readable /dev names
Date: Wed, 2 Nov 2005 01:05:31 +0100
Message-ID: <20051102000531.GB17207@vrfy.org>
References: <20051101225357.GA13215@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-hotplug-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20051101225357.GA13215@us.ibm.com>
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Errors-To: linux-hotplug-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-hotplug-devel@lists.sourceforge.net, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Nov 01, 2005 at 02:53:57PM -0800, Patrick Mansfield wrote:
> Per posts and an accepted patch on dm-devel about dm multipath user
> friendly names:
> 
> https://www.redhat.com/archives/dm-devel/2005-October/msg00004.html
> https://www.redhat.com/archives/dm-devel/2005-October/msg00067.html
> 
> But the above is a dm multipath only solution.
> 
> It's a good idea to allow user specified names on top of the
> /dev/disk/by-* device names. Though dm likely needs a dm_id in order to
> support the method outlined here.
> 
> If we could set and compare environment variables

Sure we can do that with ENV. '=' sets, '==' compares.

> or compare SYMLINK,

How would we compare the list of sysmlinks?
True, if on of them matches?

> separate rules file (doesn't have to be separate, just seems like a good
> idea) could be used to add symlinks to user specified names.

All the persistent symlinks are composed from variables still available
to match anytime later to add more links.

> i.e. move udev_rules.c:apply_format() into udev_utils.c, and call it
> before comparison as well as before (AFAIUI) generating names, though I
> somehow doubt the change is that simple.
> 
> Then, we could have rules like:
> 
> KERNEL=="sd*[!0-9]|sr*|dasd*[!0-9]", ENV{ID_SERIAL}=="?*", ENV{ID_FULL_PATH}="disk/by-id/$env{ID_BUS}-$env{ID_SERIAL}"
> ENV{ID_FULL_PATH}=="?*", SYMLINK+="$env{ID_FULL_PATH}"

Hmm, why this indirection? Can't you just use ID_SERIAL and ID_BUS in
the second rule again?

> And for each device that we want to give a user specified name, use (would
> also need partition specific rules):
> 
> ENV{ID_FULL_PATH}=="disk/by-id/scsi-360a98000686f68656c6e7a416f4b6849" SYMLINK+="media-files"
> 
> And similar for the other disk/by-* methods.
>
> Any comments on the above? 
>
> Is my rule just wrong, or is there a better method?
> 
> Running with udev 069 on FC rawhide, with these rules:
> 
> SYMLINK=="*foo*" SYMLINK+="user/bar"

SYMLINK lists can't be matched until now.

> KERNEL="sdm" ENV{VAL1}="somevalue"
> KERNEL="sdm" ENV{VAL2}="$env{VAL1}"

The value does not get expanded at the time you assign it, so the later compare
will look like:
  'somevalue' == '$env{VAL1}'

which does not match.

> KERNEL="sdm" SYMLINK+="user/show-val1-$env{VAL1}"
> KERNEL="sdm" SYMLINK+="user/show-val2-$env{VAL2}"
> 
> ENV{VAL1}=="somevalue" SYMLINK+="user/val1"
> ENV{VAL2}=="somevalue" SYMLINK+="user/val2"
> 
> Do not work as might be expected: since the env values are not expanded,
> the last rule never matches, and user/val2 link is never created. The
> above generated (sdaz is the last device found):
> 
> [elm3a49 ~]$ ls -l /dev/user
> total 0
> lrwxrwxrwx  1 root root 7 Nov  1 14:18 bar -> ../sdaz
> lrwxrwxrwx  1 root root 6 Nov  1 14:18 show-val1-somevalue -> ../sdm
> lrwxrwxrwx  1 root root 6 Nov  1 14:18 show-val2-somevalue -> ../sdm
> lrwxrwxrwx  1 root root 6 Nov  1 14:18 val1 -> ../sdm

Thanks,
Kay


-------------------------------------------------------
SF.Net email is sponsored by:
Tame your development challenges with Apache's Geronimo App Server. Download
it for free - -and be entered to win a 42" plasma tv or your very own
Sony(tm)PSP.  Click here to play: http://sourceforge.net/geronimo.php
