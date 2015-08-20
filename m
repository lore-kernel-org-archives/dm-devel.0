From: "Walter A. Boring IV" <walter.boring@hp.com>
Subject: multipath -f with friendly names doesn't flush
Date: Thu, 20 Aug 2015 09:32:49 -0700
Message-ID: <55D60131.4090803@hp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.veroqui@opensvc.com
Cc: Andrew Patterson <andrew.patterson@hp.com>, "Rosa,
	Andrea (HP Cloud Services)" <andrea.rosa@hp.com>
List-Id: dm-devel.ids

Hello Christophe,
I couldn't find any other way to file a defect against the package, so 
I'm sending this email out.   I'm working on OpenStack and using the 
multipath daemon to discover mpath devices to pass in to nova VMs as 
well as flushing/removing mpath devices with multipath -f <WWN or 
dm-X>.  I'm the primary author of the OpenStack os-brick library
http://github.com/openstack/os-brick which is used to discover volume 
attachments and remove volumes from the host OS.

I'm seeing an issue with multipath v0.4.9 (on Ubuntu 14.04) that when 
friendly names are enabled in /etc/multipath.conf,
calls to
multipath -f <WWN or dm-X> does nothing.

All of the multipath entries in /dev/disk/by-id are not removed and the 
multipath device is still in the table.
I can run multipath -ll <WWN or dm-X> and it's still there.

Turning off friendly names makes multipath -f <WWN or dm-X> works and 
the multipath -ll <WWN or dm-X> entry is gone.

Cheers,
Walt
