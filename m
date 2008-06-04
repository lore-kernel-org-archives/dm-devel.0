From: Ron Peterson <rpeterso@mtholyoke.edu>
Subject: Re: kpartx and udev problem
Date: Wed, 4 Jun 2008 12:49:20 -0400
Message-ID: <20080604164920.GF9011@localhost.localdomain>
References: <20080603215743.GA6113@localhost.localdomain>
	<20080604064529.GA27327@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080604064529.GA27327@pentland.suse.de>
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

2008-06-04_02:45:29-0400 Hannes Reinecke <hare@suse.de>:

> Problem being the 'interesting' device-mapper design.
> Whenever a 'table create' operation is triggered from user-space, it's
> actually being broken down by the device-mapper library into 4 distinct
> operations:
> 1. create device dm-X
> 2. suspend device
> 3. load table definition
> 4. resume device
> 
> and you'll be getting an 'add' event for the first operation, and a
> 'change' event for the second and the forth operation.
> But clearly the 'add' event is pretty much pointless, as there is
> not table loaded at that time, so you wouldn't know what to do with
> it. And the device is locked between the second and the fourth
> operation, so kpartx would refuse to touch it.
> 
> So, in essence: 'add' is evil for device-mapper devices.
> Use the 'change' event and check if the dm-device is not suspended
> when you get the event.

Aha.  It took a little finagaling, but I finally got it.

I had to install an updated version of dmsetup, because the version on
etch doesn't support the options in the dmsetup_env script I pilfered.
I put my dmsetup in its own location, and compiled w/ LD_RUN_PATH set
to the location of its own local libdevmapper.so library, because I
didn't want to replace my system's libdevmapper.so, because I'm not
entirely sure of the consequences.

Everything appears to be working great.  Thanks!

-- 
Ron Peterson
Network & Systems Manager
Mount Holyoke College
http://www.mtholyoke.edu/~rpeterso
-
I wish my computer would do what I want it to do - not what I tell it to do.
