From: Hannes Reinecke <hare@suse.de>
Subject: Re: data corruption with 'splt' workload to XFS on DM
 cache with its 3 underlying devices being on same NVMe device
Date: Tue, 24 Jul 2018 08:00:23 +0200
Message-ID: <e761830f-e3f7-3e88-1697-b4b150e84e5f@suse.de>
References: <20180723163357.GA29658@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180723163357.GA29658@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 07/23/2018 06:33 PM, Mike Snitzer wrote:
> Hi,
> 
> I've opened the following public BZ:
> https://bugzilla.redhat.com/show_bug.cgi?id=1607527
> 
> Feel free to add comments to that BZ if you have a redhat bugzilla
> account.
> 
> But otherwise, happy to get as much feedback and discussion going purely
> on the relevant lists.  I've taken ~1.5 weeks to categorize and isolate
> this issue.  But I've reached a point where I'm getting diminishing
> returns and could _really_ use the collective eyeballs and expertise of
> the community.  This is by far one of the most nasty cases of corruption
> I've seen in a while.  Not sure where the ultimate cause of corruption
> lies (that the money question) but it _feels_ rooted in NVMe and is
> unique to this particular workload I've stumbled onto via customer
> escalation and then trying to replicate an rbd device using a more
> approachable one (request-based DM multipath in this case).
> 
I might be stating the obvious, but so far we only have considered 
request-based multipath as being active for the _entire_ device.
To my knowledge we've never tested that when running on a partition.

So, have you tested that request-based multipathing works on a partition 
_at all_? I'm not sure if partition mapping is done correctly here; we 
never remap the start of the request (nor bio, come to speak of it), so 
it looks as if we would be doing the wrong things here.

Have you checked that partition remapping is done correctly?

Cheers,

Hannes
