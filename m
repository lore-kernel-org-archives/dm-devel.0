From: Hannes Reinecke <hare@suse.de>
Subject: Re: dm-multipath low performance with blk-mq
Date: Tue, 26 Jan 2016 15:01:05 +0100
Message-ID: <56A77C21.90605@suse.de>
References: <569E11EA.8000305@dev.mellanox.co.il>
	<20160119224512.GA10515@redhat.com> <20160125214016.GA10060@redhat.com>
	<20160125233717.GQ24960@octiron.msp.redhat.com>
	<20160126132939.GA23967@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160126132939.GA23967@redhat.com>
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

On 01/26/2016 02:29 PM, Mike Snitzer wrote:
> On Mon, Jan 25 2016 at  6:37pm -0500,
> Benjamin Marzinski <bmarzins@redhat.com> wrote:
> =

>> On Mon, Jan 25, 2016 at 04:40:16PM -0500, Mike Snitzer wrote:
>>> On Tue, Jan 19 2016 at  5:45P -0500,
>>> Mike Snitzer <snitzer@redhat.com> wrote:
>>
>> I don't think this is going to help __multipath_map() without some
>> configuration changes.  Now that we're running on already merged
>> requests instead of bios, the m->repeat_count is almost always set to 1,
>> so we call the path_selector every time, which means that we'll always
>> need the write lock. Bumping up the number of IOs we send before calling
>> the path selector again will give this patch a change to do some good
>> here.
>>
>> To do that you need to set:
>>
>> 	rr_min_io_rq <something_bigger_than_one>
>>
>> in the defaults section of /etc/multipath.conf and then reload the
>> multipathd service.
>>
>> The patch should hopefully help in multipath_busy() regardless of the
>> the rr_min_io_rq setting.
> =

> This patch, while generic, is meant to help the blk-mq case.  A blk-mq
> request_queue doesn't have an elevator so the requests will not have
> seen merging.
> =

> But yes, implied in the patch is the requirement to increase
> m->repeat_count via multipathd's rr_min_io_rq (I'll backfill a proper
> header once it is tested).
> =

But that would defeat load balancing, would it not?
IE when you want to do load balancing you would constantly change
paths, thereby always taking the write lock.
Which would render the patch pointless.

I was rather wondering if we could expose all active paths as
hardware contexts and let blk-mq do the I/O mapping.
That way we would only have to take the write lock if we have to
choose a new pgpath/priority group ie in the case the active
priority group goes down.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
