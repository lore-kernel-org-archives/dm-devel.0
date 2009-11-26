From: malahal@us.ibm.com
Subject: Re: [PATCH 7/7] Hold all write bios when errors are handled
Date: Wed, 25 Nov 2009 16:30:43 -0800
Message-ID: <20091126003043.GA6840@us.ibm.com>
References: <Pine.LNX.4.64.0911180713150.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180718540.21358@hs20-bc2-1.build.redhat.com>
	<20091123055835.GA28981@us.ibm.com>
	<Pine.LNX.4.64.0911240638250.27545@hs20-bc2-1.build.redhat.com>
	<20091124191704.GB7971@us.ibm.com>
	<Pine.LNX.4.64.0911250807500.14481@hs20-bc2-1.build.redhat.com>
	<20091125202346.GB1673@us.ibm.com> <4B0DB408.6020906@redhat.com>
	<20091125232010.GA5968@us.ibm.com> <4B0DC2C0.9020008@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4B0DC2C0.9020008@redhat.com>
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

Takahiro Yasui [tyasui@redhat.com] wrote:
> >> I haven't checked the contents of log disk, but I guess we can't
> >> differentiate these cases from log disks.
> > 
> > There were plans to add a new region state to make sure that all the
> > mirror legs have same data after a "crash". Currently your best bet is a
> > complete resync after a crash!
> 
> Please let me clarify this. There are two legs and system crash happens.
> Then, how can we resync? We have only one leg (secondary) after boot.
> When we use "mirror", we expect the last device to contain valid data,
> don't we?

I was actually referring to a problem that I mentioned in a DM/LVM
meeting.  Mikulas posted it here and there were some discussions.
http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/5392

If I remember, the proposed solution would add another state bit. If it
is implemented, then we can use that information to differentiate the
cases you mentioned. Essentially, if there are only 'dirty' regions, we
can safely use the secondary. On the other hand, if th log has some 'out
of sync' regions, then we can't use the secondary.

You can ignore my reference to "complete resynchronization". I was
referring to an existing problem with system crashes!
 
> > Or just have LVM meta data that records a device failure. Suspend writes
> > [for any kind of leg] and record device failure in the LVM meta data and
> > restart writes. This requires LVM meta data change though!
> 
> Do you mean that write I/Os need to be blocked when the secondary leg fails
> in order to update LVM meta data by lvm commands called by dmeventd?

Yes, that is correct. We need to stop write I/O for any leg failure if
we chose LVM meta data method.

Thanks, Malahal.
