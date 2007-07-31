From: Guido Guenther <agx@sigxcpu.org>
Subject: Re: New multipath-tools release?
Date: Tue, 31 Jul 2007 09:18:30 +0200
Message-ID: <20070731071830.GA15099@bogon.ms20.nix>
References: <46A72D1B.1040408@suse.de> <20070728161353.GA21276@bogon.ms20.nix>
	<46ADFA63.9020403@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46ADFA63.9020403@suse.de>
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
Cc: christophe varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

On Mon, Jul 30, 2007 at 04:49:07PM +0200, Hannes Reinecke wrote:
> In priciple a good idea. However, I do have some to-do items on my list
> yet:
> 
> - netlink messages: The FC transport class has a netlink interface
>   nowadays. It may be an idea to utilize this information in to update
>   the path status.
> - Enhance path checker. Currently the path checker is run at periodic
>   intervals regardless of the path state. This leads to quite some
>   load on systems with many paths, even when all paths are healthy.
>   We should rather call the path checker only if a path has failed,
>   as we're being notified by a failed path soon enough via I/O errors.
>   And we might even be using the netlink events from FC here, too.
> 
My point exactly: let's tag a new stable version and add these nice
things to the (then) next release. I think the stability of the master
branch improved quiet a bit during the last couple of commits, It'd be
nice to have this out of the door for distributions to build upon before
doing more intrusive changes again.
Cheers,
 -- Guido
