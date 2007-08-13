From: malahal@us.ibm.com
Subject: Re: BUG in dm/dm-mirror module?
Date: Mon, 13 Aug 2007 11:24:51 -0700
Message-ID: <20070813182450.GA24081@us.ibm.com>
References: <20070811010853.GA9952@us.ibm.com> <46BD78B7.3080200@redhat.com>
	<45517CCC-7B68-4B0F-92EC-04F4E81CDA0E@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <45517CCC-7B68-4B0F-92EC-04F4E81CDA0E@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Jonathan Brassow [jbrassow@redhat.com] wrote:
> 
> Let's say that the primary copy of the log dies or goes offline.  You  
> continue on because the log device is still "good".  If your machine  
> crashes and the primary log device is "rediscovered" on bootup, what  
> happens?  The contents of the stale side will be copied - resulting  
> in your log not properly reflecting the state of your mirror device  
> and maybe even leaving inconsistencies.

How does this work today with a normal mirror (does the disk log keep
enough info who should be the master on reboot?)?

> Ultimately, I think that in order to have a fast solution that allows  
> you to do the above (as well as a whole host of other advanced  
> features, like real-time mirroring) you need kernel accessible device  
> labels on each mirror device and log.  The labels would track things  
> like: who's the primary, who's a slave, who's in the group, who's  
> failed, etc.  I've seen some people advocate putting this in the log,  
> but the log can fail.  (I hope I've already conveyed why I don't  
> think it's a good idea to mirror the log.)  I don't have any good  
> ideas for making this happen right now.

Yes, having a kernel accessible label on the mirror device would be best
to handle these kinds of scenarios. Other possible option is to enhance
log module to handle 'mirrored log' which can update log device failures
in the log itself.

Thanks, Malahal.
