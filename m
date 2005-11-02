From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: udev user specified or human readable /dev names
Date: Thu, 3 Nov 2005 00:49:20 +0100
Message-ID: <20051102234920.GB30226@vrfy.org>
References: <20051101225357.GA13215@us.ibm.com> <20051102000531.GB17207@vrfy.org> <20051102003531.GA15854@us.ibm.com> <20051102010615.GA18684@vrfy.org> <20051102020156.GA17330@us.ibm.com> <20051102025345.GA19174@vrfy.org> <20051102153018.GA30686@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-hotplug-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20051102153018.GA30686@us.ibm.com>
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

On Wed, Nov 02, 2005 at 07:30:18AM -0800, Patrick Mansfield wrote:
> On Wed, Nov 02, 2005 at 03:53:45AM +0100, Kay Sievers wrote:
> 
> > Sure, that may be easier.
> > But such a tool is only useful if the devices are already present on the
> > system, right? Then you can read all current available ID_* variables from
> > the udev database and compose a nice rule from it. :)
> 
> Yes looks like that can work (again I *was* thinking symlinks, and not
> env variables) .

If that does not work well, let me know and we can make the needed changes.

> > > And is there a way to rename or add /dev entries without removing and
> > > adding back a device?
> > 
> > You can run udevstart again, if its not configured to do some weird
> > stuff.
> 
> That is rather slow, and didn't removing links (like a rename would want).

Sure.

> > The current devel kernel has a "uevent" file, which triggers the
> > hotplug event again, this could be used to create additional configured
> > links.
> > 
> > Also:
> >   ACTION=add DEVPATH=/block/sdm /sbin/udev block
> > would do it.
> 
> Those don't remove links either.

  ACTION=remove DEVPATH=/block/sdm /sbin/udev block
  ACTION=add DEVPATH=/block/sdm /sbin/udev block

But sure, we may want to add something smarter than this, cause the
node will disappear for a short time and the inode number of the node
will change which isn't nice if you want to recreate symlinks only.

We will need something like this anyway, cause if you change a volume label
of a filesystem, you have a similar problem.

> > Or do you mean adding a link temporarily, so that it get tracked and
> > removed when the device goes away?
> 
> No.

Ah bad, that's what I like to have for a pam_console/udev solution. :)

Kay


-------------------------------------------------------
SF.Net email is sponsored by:
Tame your development challenges with Apache's Geronimo App Server. Download
it for free - -and be entered to win a 42" plasma tv or your very own
Sony(tm)PSP.  Click here to play: http://sourceforge.net/geronimo.php
