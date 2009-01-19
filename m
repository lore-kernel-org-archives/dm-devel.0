From: malahal@us.ibm.com
Subject: Re: Could device-mapper offer multi-tier storage?
Date: Mon, 19 Jan 2009 09:15:44 -0800
Message-ID: <20090119171544.GA1981@us.ibm.com>
References: <496E4063.5070502@nrel.colostate.edu>
	<D8A2BC50-9F46-4355-AF48-C83BC091F590@redhat.com>
	<4974A3C2.3090509@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4974A3C2.3090509@suse.de>
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

Hannes Reinecke [hare@suse.de] wrote:
> Well, maybe. Not so sure if device-mapper is the correct place to implement
> something like this.
>
> What you get if you use a device-mapper device as the 'middle' tier in
> this scenario is that this device will contain only random blocks,
> ie those actually accessed/modified/whatever.
> Only the underlying device will contain the full information about
> all blocks, and as such only the underlying device can be mounted
> and provides a meaningful filesystem.
> Any middle tier devices will contain a somewhat random update of
> several blocks, which cannot be interpreted at all.
>
> This makes error checking _really_ hard, as the middle tier devices
> can't be consistency checked at all; we have to hope the blocks on
> there make sense to the underlying device.

Are you proposing a "dm-cache" target here? That may work as HSM
(hierarchical Storage management) if dm-cache target can accept tier'ed
devices. But it has to keep track of access times on the blocks to move
them among tier'ed devices. Can be made to work, but I think it is
efficient to do it in the file system as you indicated.

>
> No, this scenario could be more efficiently handled on the filesystem
> level, as we then have an implicit consistency check as you're restricted
> to move _files_ to a different storage; but that's okay as the filesystems
> in on each device themselves will be consistent.
>
> Would be a grand application for union mount if and when it comes around.
> And probably btrfs already has it built-in, I wouldn't wonder.

I am not sure if "union mount" is really needed as the file system
driver can implicitly take care of HSM with a single mount.
