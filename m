From: Josh Triplett <josh@joshtriplett.org>
Subject: Bug#648367: device-mapper devices such as dm-crypt always have rotational=1; should inherit "rotational" setting from underlying devices
Date: Sun, 13 Nov 2011 18:26:44 -0800
Message-ID: <20111114022644.GB30421@leaf>
References: <20111110195943.12083.93273.reportbug@leaf>
 <1321232729.3059.42.camel@deadeye>
Reply-To: Josh Triplett <josh@joshtriplett.org>, 648367@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.648367.B648367.132123761232352@bugs.debian.org>
Content-Disposition: inline
In-Reply-To: <1321232729.3059.42.camel@deadeye>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: 648367@bugs.debian.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Nov 14, 2011 at 01:05:29AM +0000, Ben Hutchings wrote:
> On Thu, 2011-11-10 at 11:59 -0800, Josh Triplett wrote:
> > Source: linux-2.6
> > Version: 3.1.0-1~experimental.1
> > Severity: normal
> > 
> > I use dm-crypt on my system, and I have an SSD.  The underlying disk
> > device, sda, has rotational=0:
> > 
> > ~$ cat /sys/block/sda/queue/rotational
> > 0
> > 
> > However, the device-mapper devices have rotational=1:
> > 
> > ~$ head /sys/block/dm-*/queue/rotational
> > ==> /sys/block/dm-0/queue/rotational <==
> > 1
> > 
> > ==> /sys/block/dm-1/queue/rotational <==
> > 1
> > 
> > ==> /sys/block/dm-2/queue/rotational <==
> > 1
> > 
> > The device-mapper devices should inherit the setting for "rotational"
> > from their underlying devices.
> 
> I'm not sure that's true.  Since their queues should feed into the
> queues for the underlying devices, it may be that they shouldn't
> themselves be scheduled as if they are rotating media.

OK, I suppose I don't actually care what rotational shows for a
device-mapper device backed by rotating media.  The case I care about:
when the underlying media has rotational=0, the dm device definitely
shouldn't have rotational=1.

- Josh Triplett
