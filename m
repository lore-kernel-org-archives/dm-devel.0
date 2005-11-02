From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: udev user specified or human readable /dev names
Date: Tue, 1 Nov 2005 18:01:56 -0800
Message-ID: <20051102020156.GA17330@us.ibm.com>
References: <20051101225357.GA13215@us.ibm.com> <20051102000531.GB17207@vrfy.org> <20051102003531.GA15854@us.ibm.com> <20051102010615.GA18684@vrfy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-hotplug-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20051102010615.GA18684@vrfy.org>
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Errors-To: linux-hotplug-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-hotplug-devel@lists.sourceforge.net, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Nov 02, 2005 at 02:06:15AM +0100, Kay Sievers wrote:
> On Tue, Nov 01, 2005 at 04:35:31PM -0800, Patrick Mansfield wrote:

> > But it still would not match, per the issue below, right?
> 
> Right, it wouldn't work.
> 
> You want this:
>   ENV{ID_FULL_PATH}=="disk/by-id/scsi-360a98000686f68656c6e7a416f4b6849" SYMLINK+="media-files"
> 
> but why don't you just do:
>   ENV{ID_BUS}=="scsi", ENV{ID_SERIAL}=="360a98000686f68656c6e7a416f4b6849", SYMLINK+="media-files"
> 
> The second already works, is independent from all other rules and I think
> is simpler.

Yes, I just disagree with it being simpler for all busses/devices.

I was thinking of the sys admin or a tool looking at the current
/dev/disk/by-* and adding rule(s) based on those values to a udev rule
file.

And is there a way to rename or add /dev entries without removing and
adding back a device?


Using ID_BUS and ID_SERIAL via the following lines like this works:

KERNEL=="sd*[!0-9]", ENV{ID_BUS}=="scsi" ENV{ID_SERIAL}=="360a98000686f68656c6e7a416f4b6849", SYMLINK+="user/databaseA"
KERNEL=="sd*[0-9]|dasd*[0-9]", ENV{ID_SERIAL}=="360a98000686f68656c6e7a416f4b6849", SYMLINK+="user/databaseA-part%n"

KERNEL=="sd*[!0-9]", ENV{ID_BUS}=="scsi" ENV{ID_SERIAL}=="360a98000686f68656c6e7a416f4b2f55", SYMLINK+="user/databaseB"
KERNEL=="sd*[0-9]", ENV{ID_SERIAL}=="360a98000686f68656c6e7a416f4b2f55", SYMLINK+="user/databaseB-part%n"

Adding the devices then creates:

[root@elm3a49 rules.d]# ls -l /dev/user
total 0
lrwxrwxrwx  1 root root 6 Nov  1 17:46 databaseA -> ../sdm
lrwxrwxrwx  1 root root 7 Nov  1 17:47 databaseA-part1 -> ../sdm1
lrwxrwxrwx  1 root root 6 Nov  1 17:46 databaseB -> ../sdi
lrwxrwxrwx  1 root root 7 Nov  1 17:46 databaseB-part1 -> ../sdi1
lrwxrwxrwx  1 root root 7 Nov  1 17:46 databaseB-part2 -> ../sdi2

-- Patrick Mansfield


-------------------------------------------------------
SF.Net email is sponsored by:
Tame your development challenges with Apache's Geronimo App Server. Download
it for free - -and be entered to win a 42" plasma tv or your very own
Sony(tm)PSP.  Click here to play: http://sourceforge.net/geronimo.php
