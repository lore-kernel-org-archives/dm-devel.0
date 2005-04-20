From: Greg KH <gregkh@suse.de>
Subject: Re: A better solution than "md_component_detection = 1"
Date: Wed, 20 Apr 2005 16:42:56 -0700
Message-ID: <20050420234256.GA24033@suse.de>
References: <000001c5136d$3b3502a0$11051aac@pcp41116>
	<20050410172931.GF12752@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050410172931.GF12752@marowsky-bree.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, hare@suse.de
List-Id: dm-devel.ids

On Sun, Apr 10, 2005 at 07:29:31PM +0200, Lars Marowsky-Bree wrote:
> Proposed solution: Introduce sub-devices into the sysfs tree. (And,
> automatically, backlink those to parent devices, but that's just so the
> tree can be traversed in any order.)
> 
> For example, /sys/block/sda would have a sub/ directory with "dm-0" in
> there, pointing at /sys/block/dm-0 (surprise). The
> /sys/block/dm-0/parent/sd{a,b} entries would do a very surprising
> thing.

I don't have a problem with this, and I don't think udev would either.
There's nothing keeping this from happening today with regards to the
sysfs code.

thanks,

greg k-h
