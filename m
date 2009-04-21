From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH] DM Snapshot: snapshot-merge target
Date: Tue, 21 Apr 2009 15:07:09 -0500
Message-ID: <3B7E3A04-B1D3-4339-ACDC-30CA1B609001@redhat.com>
References: <1239995082.30836.4.camel@hydrogen.msp.redhat.com>
	<f73f7ab80904191749i6641e3bj38c0822ad7e47cd0@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f73f7ab80904191749i6641e3bj38c0822ad7e47cd0@mail.gmail.com>
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

I'm not so sure about that approach...

I've also posted a "shared" exception store (which has a long history  
of contributors), which allows for better space and performance  
efficiency.

I think you could achieve the same thing without the added complexity.

  brassow

On Apr 19, 2009, at 7:49 PM, Kyle Moffett wrote:

> On Fri, Apr 17, 2009 at 3:04 PM, Jonathan Brassow  
> <jbrassow@redhat.com> wrote:
>> This patch introduces the "snapshot-merge" target.  This target can  
>> be
>> used to merge a snapshot into an origin - amoung other uses.  The
>> constructor table is almost identical to the snapshot target.
>>
>> snapshot table      : <start> <len> snapshot       <real-origin>  
>> <exstore args>
>> snapshot-merge table: <start> <len> snapshot-merge <virt-origin>  
>> <exstore args>
>>
>> When you create a device-mapper "snapshot-origin" device, the  
>> device you
>> interface with is the 'virt-origin', while the device it covers is  
>> the
>> 'real-origin'.
>>
>> The benefit of using the 'virt-origin' in the snapshot-merge table  
>> is that
>> doing so will preserve all the other snapshots that were made  
>> against the
>> origin.  If you specify the 'real-origin', the other snapshots (the  
>> ones
>> you are not merging) would be corrupted.  [There are reasons for  
>> using the
>> underlying 'real' devices, though.  More on this later.]
>
> Hmm, this is very interesting...  I'd be inclined to use this as a way
> of storing temporary sequential backups.  Specifically, I would have a
> base device and a series of chained snapshots, set up in a tree so
> that the base device is perhaps several years old, with a snapshot
> dated one year later, with another snapshot dated one year later whose
> origin is the previous snapshot, etc.  That would go up to the
> beginning of the current year, where we would then have monthly
> snapshots up to a month or two ago, followed by weekly snapshots until
> a week or two ago, ..... until we get down to 15-minute-interval
> snapshots over the last hour or two.
>
> The benefit over same-origin snapshots would be that deltas are only
> stored once, and once a snapshot is no longer the "current snapshot"
> it can be marked read-only and be shrunk to fit.  As snapshots push
> across a change-in-frequency boundary (IE: daily snapshots become more
> than 2 weeks old, for example), they would be merged together.  Using
> the daily snapshot example, the first-day-of-the-week snapshot would
> be expanded to the total size of that week's snapshots and marked R/W
> again, then all the others would be sequentially merged into it.
>
> There would of course be some performance issues accessing
> long-unmodified data on the origin volume.  Specifically, accessing
> long-unmodified data on the origin volume would require looking
> through some 30 different exception tables to figure out precisely
> which snapshot it's on, but that might be worth the benefit for the
> very space-efficient history.
>
> Cheers,
> Kyle Moffett
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
