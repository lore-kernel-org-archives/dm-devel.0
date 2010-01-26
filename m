From: Dave Wysochanski <dwysocha@redhat.com>
Subject: Re: dm_ioctl: Only send a change uevent when a resume
 ioctl changes the device.
Date: Tue, 26 Jan 2010 17:55:14 -0500
Message-ID: <1264546514.14340.0.camel@f10-node1>
References: <1264528570-10498-1-git-send-email-dwysocha@redhat.com>
	<20100126180929.GA17190@redhat.com> <1264531714.2572.6.camel@f10-node1>
	<1264532220.2572.8.camel@f10-node1> <20100126211219.GC17190@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100126211219.GC17190@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, 2010-01-26 at 16:12 -0500, Mike Snitzer wrote:
> > > > 
> > > 
> > > Nice simplification Mike, as discussed on IRC.
> > > 
> > > Ack.
> > > 
> > 
> > Actually, the more I think about it I am not sure about sending the
> > uevent in the case where dm_resume() fails.  Seems like we should send
> > it since the map could have changed - depends on whether we went through
> > that 'if (new_map)' block.
> 
> Pretty sure we resolved this.  As we discussed (just after you sent this
> last reply); for the benefit of others:
> 
> <dave> so the change uevent here really means "resume was successful"
> <mike> yes
> <dave> wait - if we suspend it, but resume fails, shouldn't we still
> send the event?
> <mike> in that case the device will be left suspended; in terms of udev
> that's not a "change"
> <mike> device is wedged (suspended)
> <mike> telling udev about it could just stack up other processes trying
> to issue IO to it
> <mike> but to be honest I don't know what the purist definition of what
> a "change" uevent is; I'm just treating it as telling some blackbox that
> DM device has changed and is functional
> <dave> that does make sense
> 

Yes, I should have stopped with my original Ack!
