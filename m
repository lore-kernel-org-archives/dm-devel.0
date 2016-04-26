From: Oliver Mangold <Oliver.Mangold@EMEA.NEC.COM>
Subject: Re: dm-devel Digest, Vol 146, Issue 24
Date: Tue, 26 Apr 2016 09:27:40 +0000
Message-ID: <571F348B.4030301@emea.nec.com>
References: <mailman.47.1461600008.1006.dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <mailman.47.1461600008.1006.dm-devel@redhat.com>
Content-Language: en-US
Content-ID: <66E3410817AFEF4EAAB35FF3CCF21C8D@EMEA.NEC.COM>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 25.04.2016 18:00, dm-devel-request@redhat.com wrote:
> Date: Mon, 25 Apr 2016 09:49:50 +0200 From: Hannes Reinecke 
> <hare@suse.de> To: dm-devel@redhat.com Subject: Re: [dm-devel] Upcall 
> prioritizer for multipath Message-ID: <571DCC1E.5000908@suse.de> 
> Content-Type: text/plain; charset=windows-1252
> Ah, the good old days. You do remember (of course, as you as a 
> diligent developer would have had a look through the archives, right?) 
> that we original did precisely that, namely using 'prio' as an 
> external callout. The reason why we moved away from this is a 
> deadlock: When all paths are down (ie the _one_ situation where you 
> absolutely _need_ multipath to work) you cannot reinstate any paths, 
> as for reinstating you would need to call the prio program. Which 
> happens to be an external program, which would need to be loaded from 
> disk. Which is not available. Say goodbye to your machine :-( So we've 
> moved to using a shared library mechanism, which can be mlock()ed at 
> boot to avoid these situations. Hence I would really _not_ use this 
> approach.
Thanks for your explanation. In fact I missed that discussion from 2007 
when searching the archive. Of course your point is valid, but it 
doesn't apply to my use case of a storage server, where multipath isn't 
used at all for the system disk.

Can't say I know the perfect solution, but as a user I still would like 
to point out, that handling JBODs (where you don't have stable WWIDs) is 
awkward with multipathd (as is), where everything is so static.

An alternative that should be safe from the mentioned deadlock (as I 
understand it) would be to create a prioritizer that reads the prio from 
an udev attribute. Then the callout can be done from an udev rule. This 
would fix my problem fine, but the disadvantage is of course, that it 
could not be used for dynamically changing path priorities, as udev 
won't reevaluate the rule periodically.
