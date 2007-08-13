From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: BUG in dm/dm-mirror module?
Date: Mon, 13 Aug 2007 12:48:06 -0400
Message-ID: <46C08B46.8040401@cfl.rr.com>
References: <20070811010853.GA9952@us.ibm.com> <46BD78B7.3080200@redhat.com>
	<45517CCC-7B68-4B0F-92EC-04F4E81CDA0E@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Jonathan Brassow wrote:
> On a different topic, why are you mirroring the log?  Isn't this 
> somewhat dangerous?
> 
> Let's say that the primary copy of the log dies or goes offline.  You 
> continue on because the log device is still "good".  If your machine 
> crashes and the primary log device is "rediscovered" on bootup, what 
> happens?  The contents of the stale side will be copied - resulting in 
> your log not properly reflecting the state of your mirror device and 
> maybe even leaving inconsistencies.

This is a problem with any mirror, not just one holding a mirror log.

> You might argue that we should update the metadata to exclude the failed 
> primary at the point of failure.  Two things come to mind:
> 1) log I/O will continue until you take action - leaving you open to the 
> scenario above
> 2) it would be simpler to just allocate a new log (since you are 
> changing metadata anyway) and initialize the log as "in-sync" if the 
> mirror is already "in-sync".

Yes, once one drive fails, the metadata on the other drive should 
indicate that the mirror is broken and this is now the most up to date 
copy.
