From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: udev user specified or human readable /dev names
Date: Wed, 2 Nov 2005 07:30:18 -0800
Message-ID: <20051102153018.GA30686@us.ibm.com>
References: <20051101225357.GA13215@us.ibm.com>
	<20051102000531.GB17207@vrfy.org>
	<20051102003531.GA15854@us.ibm.com>
	<20051102010615.GA18684@vrfy.org>
	<20051102020156.GA17330@us.ibm.com>
	<20051102025345.GA19174@vrfy.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20051102025345.GA19174@vrfy.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-hotplug-devel@lists.sourceforge.net, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Nov 02, 2005 at 03:53:45AM +0100, Kay Sievers wrote:

> Sure, that may be easier.
> But such a tool is only useful if the devices are already present on the
> system, right? Then you can read all current available ID_* variables from
> the udev database and compose a nice rule from it. :)

Yes looks like that can work (again I *was* thinking symlinks, and not
env variables) .

> > And is there a way to rename or add /dev entries without removing and
> > adding back a device?
> 
> You can run udevstart again, if its not configured to do some weird
> stuff.

That is rather slow, and didn't removing links (like a rename would want).

> The current devel kernel has a "uevent" file, which triggers the
> hotplug event again, this could be used to create additional configured
> links.
> 
> Also:
>   ACTION=add DEVPATH=/block/sdm /sbin/udev block
> would do it.

Those don't remove links either.

> Or do you mean adding a link temporarily, so that it get tracked and
> removed when the device goes away?

No.

Thanks,

-- Patrick Mansfield
