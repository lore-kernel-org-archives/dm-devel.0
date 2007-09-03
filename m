From: Guido Guenther <agx@sigxcpu.org>
Subject: Multipath device naming
Date: Mon, 3 Sep 2007 22:56:39 +0200
Message-ID: <20070903205638.GA28984@bogon.ms20.nix>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hi,
there seems to be little to no consensus on how the device naming of
multipathed devices should look like across distributions:

The current kpartx udev rule in the upstream source (the patch came from
Hannes) sets the device naming to: /dev/mapper/<wwid>-part[0-9]+ so I
assume this is what SuSE uses (or intends to use in the future).
Redhat/Fedora seems to skip the '-p -part' so partitions look like:
/dev/mapper/<path>p?[0-9]+. The 'p' being used if <path> already ends in
a number. No distro seems to use user_friendly_names=yes by default (in
which case <...> would become mpath[0-9]+). And there's /dev/disk/by-name/
of course which would use the WWID if alias wasn't set.

All this gives bootloaders like grub and installers a hard time (every
distro seems to have similar patches to grub-install, etc.). I wonder if
it wouldn't make sense to adopt a common naming scheme across
distributions and probably reserve the whole
/dev/mapper/mpath[0-9]+p[0-9]+ and /dev/mapper/mpath[0-9]-part[0-9]+
namespaces for multipath devices? Otherwise it might become increasingly
harder for tools like parted to find out the partitions of a device
(without the almost very same set of patches that every distro carries
around). Any thoughts?
Cheers,
 -- Guido
