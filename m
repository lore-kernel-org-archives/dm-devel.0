From: Douglas McClendon <dmc.lists@filteredperception.org>
Subject: Re: DM_snapshot_cow filesystem (dmsetup create snapshot)
Date: Wed, 30 Nov 2011 17:34:25 -0600
Message-ID: <4ED6BD81.4090609@filteredperception.org>
References: <4EABE131.8010706@googlemail.com>	<20111029204947.GU23336@agk-dp.fab.redhat.com>	<CAEcBt+Ux+GVmm7zBeFA7k5PHOQoSKLTKcifB95ne5dBtX400dQ@mail.gmail.com>	<4ED2DF0F.1070108@filteredperception.org>	<CAEcBt+UEJXSY7oK+j0gw9fkzjnWOUcBFhPdXCVFe3HZNh6zOTw@mail.gmail.com>	<4ED59040.50406@filteredperception.org>	<CAEcBt+XxVh8b=TJu-Z+3XBL=K6LUhs2QZyeZKGMGh_Lp+UBGbA@mail.gmail.com>
	<20111130220259.GA7595@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111130220259.GA7595@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On 11/30/2011 04:03 PM, Alasdair G Kergon wrote:
> On Wed, Nov 30, 2011 at 04:48:05PM -0500, Frederick Grose wrote:
>> snapshot Invalid  does seem to prevent even read-only access.
>
> Indeed - once it's invalid, that's the end of it.
> If we didn't do that, changes to areas of the origin that hadn't already
> changed would start to appear in the 'snapshot' and the snapshot would become a
> nonsensical hybrid of the two devices containing no information about which
> parts of it got corrupted.
>
> Don't allow your snapshots to run out of space!

So wouldn't it be much better as far as the user is concerned if, the 
instant a snapshot reached capacity, it fell over into a read-only state 
(instead of being marked invalid?), such that further corruption beyond 
such plug-pulling variety could/would not occur?  If so, would it be 
straightforward to write such a patch and would it be beneficial enough 
to end upstream?

-dmc


> If you want to see what you can recover, use that code I mentioned earlier.
>
> Alasdair
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
