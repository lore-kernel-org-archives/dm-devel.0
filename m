From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Thin provisioning bug in interface
Date: Mon, 19 Sep 2011 12:59:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1109191245060.17525@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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
To: "Alasdair G. Kergon" <agk@redhat.com>, Edward Thornber <thornber@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The current thin interface works in the following way:

* you create a pool target and pass it two devices, one for metadata and 
the other for data

* you create a thin target and pass it a pool device and thin device id

Now the problem:

if you destroy the pool target (reload it with empty table or something 
like that) --- the pool structure can't be freed from memory (because a 
thin device is open) and it is still active. The problem: the data and 
metadata devices are closed. You can't keep them open because "dm_dev" is 
bound to a specific dm table and is force-closed when the table is 
destroyed.

I thought about fixing it, but concluded that this interface is 
fundamentally broken and there is no easy way to do the fix.

There is an unfixable flaw in thin provisioning interface. Something like 
"dmsetup remove_all" can trigger it.

I think the interface should be changed in such a way that "thin" target 
receives metadata and data devices as its parameters and looks up "pool" 
target using these parameters. If we change it this way, the "thin" target 
would keep "data" and "metadata" devices open, so if someone destroys the 
pool target, the devices would still be accessible and there would be no 
risk of crash becuase of using freed kernel structures.

I thin Joe said that Alasdair wanted to have current interface ("thin" 
target opens "pool"), but it suffers from an unfixable bug. So Alasdair, 
maybe you should change your mind? Or provide some explanation how this 
scenario should be fixed?

Mikulas
