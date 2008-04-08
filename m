From: malahal@us.ibm.com
Subject: Re: Desynchronizing dm-raid1
Date: Mon, 7 Apr 2008 17:04:23 -0700
Message-ID: <20080408000422.GA3246@us.ibm.com>
References: <Pine.LNX.4.64.0803181942140.20490@porkchop.devel.redhat.com>
	<20080319000241.GB12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803182015001.21077@porkchop.devel.redhat.com>
	<20080319011757.GD12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0804021444120.22485@porkchop.devel.redhat.com>
	<20080403091936.GA9901@redhat.com>
	<20080403142154.GA11878@us.ibm.com>
	<20080407142517.GA7327@redhat.com>
	<20080407154106.GC3114@us.ibm.com>
	<Pine.LNX.4.64.0804071923180.3742@porkchop.devel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804071923180.3742@porkchop.devel.redhat.com>
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

Mikulas Patocka [mpatocka@redhat.com] wrote:
> On Mon, 7 Apr 2008, malahal@us.ibm.com wrote:
>
>>>> I don't think the state RH_MAYBE_DIRTY is superfluous.  If the region
>>>> state is RH_CLEAN_CANDIDATE after the sync(), that means no 'write'
>>>> happened since we set RH_CLEAN_CANDIDATE. If there was any write, the
>>>> region state would be 'RH_DIRTY' or 'RH_MAYBE_DIRTY'.
>>>
>>> Hrm, sound like a contradiction in your statement.
>>> Either it stays RH_CLEAN_CANDIDATE because of no writes *or*
>>> it's state-changing to RH_DIRTY, no ?
>>
>> The state would be RH_CLEAN_CANDIDATE if there were ***NO*** writes as
>> part of sync(). The next statement only describes what would happen if
>> there were any writes as part of sync().
>
> The sync() does write just like any other process, so it may create 
> RH_CLEAN_CANDIDATE state too. To check that the region was not written 
> during sync(), you need an extra state and make sure that no other code 
> sets this state, except your syncing thread.

Exactly my point. Thanks for putting it better.
