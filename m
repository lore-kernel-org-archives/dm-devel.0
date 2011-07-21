From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCHES] improve sysfs performance, make it O(log n)
Date: Thu, 21 Jul 2011 09:34:55 +0100
Message-ID: <20110721083454.GD3700@ubuntu>
References: <Pine.LNX.4.64.1107201836310.4812@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1107201836310.4812@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, Milan Broz <mbroz@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com, gregkh@suse.de, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Jul 20, 2011 at 06:56:50PM -0400, Mikulas Patocka wrote:
> Performance testing --- 10000 dm devices created with dmsetup:
> 
> The numbers are time in seconds to perform these operations:
> 1. create 10000 devices
> 2. ls -la /sys/block
> 3. ls -al /sys/block after a cache flush (echo 3 >/proc/sys/vm/drop_caches)
> 4. dmsetup remove_all
> 
> no patches	109	9.8	12	1624
> patch 1		109	9.1	12	15
> patches 1,2	120	0.19	3.0	16
> patches 1,2,3	68	0.17	0.47	12
> patches 1,2,3,4	68	0.15	0.48	11
> all patches	37	0.16	0.46	3.3

Fantastic improvement Mikulas!
