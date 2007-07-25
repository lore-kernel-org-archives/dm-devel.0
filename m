From: Guido Guenther <agx@sigxcpu.org>
Subject: Re: Re: [multipath 1/1] cache sysfs_devices
Date: Wed, 25 Jul 2007 18:37:49 +0200
Message-ID: <20070725163749.GA23411@bogon.ms20.nix>
References: <20070720172919.GA2497@bogon.ms20.nix>
	<20070720210343.GA11879@bogon.ms20.nix> <46A59DA4.1010703@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46A59DA4.1010703@suse.de>
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
Cc: Christophe Varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

On Tue, Jul 24, 2007 at 08:35:16AM +0200, Hannes Reinecke wrote:
> Guido Guenther wrote:
> > I give up on git-send-email - it always fools me. Nevertheless this one
> > fixes the described bug of paths coming back as different block
> > devices:
> > 
> > Keep a list of sysfs devices for sysfs_device_get() so uev_trigger() can look
> > up the necessary information for proper path removal in case of a 'remove'
> > uevent - the sysfs files in the filesystem might be long gone at this point.
> > 
> > This also plugs a memory leak where we'd malloc space for the same sysfs device
> > over and over again for every processed uevent.
> > 
> Hmm. But now we're running into the opposite trap: memory for a block device once
> existing will never be freed. So over time we're likely to become a memory hog.
So far we did not free any memory _and_ we would end up allocating memory
for every path that comes back up over and over again.

> Better it would be to remove the sysfs device from the cache once we're done
> with it.
Fair enough, we won't need the information then anyway.
Thanks,
 -- Guido
