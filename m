From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: patch to dm.c to delay add_disk call for new mapped
	device till a fter device's map is loaded
Date: Thu, 10 Nov 2005 23:22:04 +0000
Message-ID: <20051110232204.GL26394@agk.surrey.redhat.com>
References: <C2EEB4E538D3DC48BF57F391F422779321ADD9@srmanning.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321ADD9@srmanning.eng.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "goggin, edward" <egoggin@emc.com>
Cc: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Nov 10, 2005 at 01:53:53PM -0500, goggin, edward wrote:
> Patch to dm.c to delay the add_disk call for a newly created mapped device
> until after the mapped device's map is loaded for the first time in dev_load
> so that an a hotplug/uevent handler will not fail to acquire information
> about
> the mapped device's map.
 
I'm not keen on this one yet - I can see the problem, but uevent is asynchronous
so I'm not sure where the right place to fix this is.
[By the time the handler runs, anything could have happened to the device's 
state - the device could even have been deleted.  So when the handler runs it
can make *no* assumptions about the state of the device.  Particularly as
uevents can get lost.]

If the handler wants to know what type of table, then it should be notified
every time a new table goes live - separately from when the device is created.

If the uuid holds the 'creating subsystem' as a prefix then that's sufficient to
identify it as multipath or EVMS or LVM2 etc. rather than looking for a map.

And for snapshots, issuing a uevent when a table is activated may risk problems
- it needs thinking through.

Alasdair
