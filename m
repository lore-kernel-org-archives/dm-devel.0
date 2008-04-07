From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Desynchronizing dm-raid1
Date: Mon, 7 Apr 2008 19:27:40 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0804071923180.3742@porkchop.devel.redhat.com>
References: <Pine.LNX.4.64.0803181921380.10939@porkchop.devel.redhat.com>
	<20080318233955.GA12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803181942140.20490@porkchop.devel.redhat.com>
	<20080319000241.GB12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803182015001.21077@porkchop.devel.redhat.com>
	<20080319011757.GD12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0804021444120.22485@porkchop.devel.redhat.com>
	<20080403091936.GA9901@redhat.com> <20080403142154.GA11878@us.ibm.com>
	<20080407142517.GA7327@redhat.com> <20080407154106.GC3114@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080407154106.GC3114@us.ibm.com>
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

On Mon, 7 Apr 2008, malahal@us.ibm.com wrote:

> Heinz Mauelshagen [mauelshagen@redhat.com] wrote:
>>>> RH_MAYBE_DIRTY sounds superfluous at first glance, because when all writes
>>>> to a region drained, we can set RH_CLEAN_CANDIDATE, run the sync() and check
>>>> if that state persists in order to trigger the dirty log update.
>
> If I understand your above description: a region's state is set to
> RH_DIRTY when an I/O is scheduled in the region and is set to
> RH_CLEAN_CANDIDATE when all I/O is completed. In other words, a region's
> state is RH_CLEAN_CANDIDATE when there is no pending I/O to that region.
> Did I get it right so far?
>
> Then we invoke sync(). Now, if the region's state is RH_CLEAN_CANDIDATE,

The problem is, that if sync() wrote to that region, it waits until all 
writes drain and sets the region to RH_CLEAN_CANDIDATE too. So we couldn't 
distinguish the cases, if the sync() wrote to the region or not.

During this sync() write, anyone else may modify the data too, so if the 
sync() touched the region, we don't know if it's in-sync or isn't.

> you set the region's state to RH_CLEAN. If the region's state is
> anything other than RH_CLEAN_CANDIDATE, you don't do anything. Am I
> correct?
>
>>> I don't think the state RH_MAYBE_DIRTY is superfluous.  If the region
>>> state is RH_CLEAN_CANDIDATE after the sync(), that means no 'write'
>>> happened since we set RH_CLEAN_CANDIDATE. If there was any write, the
>>> region state would be 'RH_DIRTY' or 'RH_MAYBE_DIRTY'.
>>
>> Hrm, sound like a contradiction in your statement.
>> Either it stays RH_CLEAN_CANDIDATE because of no writes *or*
>> it's state-changing to RH_DIRTY, no ?
>
> The state would be RH_CLEAN_CANDIDATE if there were ***NO*** writes as
> part of sync(). The next statement only describes what would happen if
> there were any writes as part of sync().

The sync() does write just like any other process, so it may create 
RH_CLEAN_CANDIDATE state too. To check that the region was not written 
during sync(), you need an extra state and make sure that no other code 
sets this state, except your syncing thread.

Mikulas

> --Malahal.
> PS: Any comments from the original submitter if he thinks the state
> is really superfluous?
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
