From: "goggin, edward" <egoggin@emc.com>
Subject: RE: patch to dm.c to delay add_disk call for new mappe
	d device till a fter device's map is loaded
Date: Thu, 10 Nov 2005 20:21:29 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321ADEA@srmanning.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'Alasdair G Kergon' <agk@redhat.com>
Cc: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

> -----Original Message-----
> From: Alasdair G Kergon [mailto:agk@redhat.com] 
> Sent: Thursday, November 10, 2005 6:22 PM
> To: goggin, edward
> Cc: 'dm-devel@redhat.com'
> Subject: Re: [dm-devel] patch to dm.c to delay add_disk call 
> for new mapped device till a fter device's map is loaded
> 
> On Thu, Nov 10, 2005 at 01:53:53PM -0500, goggin, edward wrote:
> > Patch to dm.c to delay the add_disk call for a newly 
> created mapped device
> > until after the mapped device's map is loaded for the first 
> time in dev_load
> > so that an a hotplug/uevent handler will not fail to 
> acquire information
> > about
> > the mapped device's map.
>  
> I'm not keen on this one yet - I can see the problem, but 
> uevent is asynchronous
> so I'm not sure where the right place to fix this is.

I'm not either.

> [By the time the handler runs, anything could have happened 
> to the device's 
> state - the device could even have been deleted.  So when the 
> handler runs it
> can make *no* assumptions about the state of the device.  
> Particularly as
> uevents can get lost.]

I don't disagree with any of this.  But, without this change or
something like it, a call to dm to get information about the
mapped device associated with a uevent add event can fail even
without any of these atypical occurrences.  How is the uevent
handling code to differentiate one of the cases you describe
above from the case my patch is trying to fix.  It is difficult
to do without writing code to delay and retry on error.  This
is ugly code and must be written in every uevent handler for
these events.

> 
> If the handler wants to know what type of table, then it 
> should be notified
> every time a new table goes live - separately from when the 
> device is created.

I see that as a different issue.  This change is to enable a uevent
handler to deterministically tell if a one of the conditions you
cite above occurred (device was deleted before uevent handler got
to call into dm) without sleeping and retrying.

> 
> If the uuid holds the 'creating subsystem' as a prefix then 
> that's sufficient to
> identify it as multipath or EVMS or LVM2 etc. rather than 
> looking for a map.
> 
> And for snapshots, issuing a uevent when a table is activated 
> may risk problems
> - it needs thinking through.
> 
> Alasdair
> 
