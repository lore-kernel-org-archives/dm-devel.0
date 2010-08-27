From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: oblem with lvm and multipath on fedora 13
Date: Fri, 27 Aug 2010 11:26:34 -0700
Message-ID: <20100827182634.GB31618@us.ibm.com>
References: <C89D4C15.1070A%brian.p.stamper@nasa.gov>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C89D4C15.1070A%brian.p.stamper@nasa.gov>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Stamper, Brian P. (ARC-D)[Logyx LLC] [brian.p.stamper@nasa.gov] wrote:
> Last night I upgraded a box from Fedora 11 to Fedora 13, which upgraded
> multipath from 4.8-10 to 4.9-14.  After the upgrade, multipath is failing to
> create maps for some of my volumes.  The volumes are coming from a 3par
> system, which is directly attached to Qlogic HBAs.
> 
> The volumes I'm having problems with contain vgs and lvms.  They're also
> snapshot volumes.  I have a base volume (non-snapshot) that contains a vg
> that is working fine.  I would not expect that these volumes being snapshots
> would be significant, but it's the only common thread I've found so far.
> 
> It seems almost like a timing issue, where lvm is grabbing the disks before
> multipath has a chance to create the maps.  What I can't figure is why it
> only affects these volumes.  Looking through /var/log/messages from startup,
> I am seeing some "unknown partition type" messages that do seem to
> correspond to the volumes that dracut is reporting as duplicate PVs, so I'll
> investigate that.
> 
> Help would be much appreciated.

If you can, deactivate the affected VG, restart multipath (it should be
able to load maps now) and then activate the VG. If this works, then
there is something that is causing LVM to claim devices before multipath
does.

Thanks, Malahal.
PS: If you don't have multipath in initrd, LVM *may* claim paths as PV's
before the multipath from active root can claim them. Don't have enough
info on Fedora13 initrd if this can happen though.
