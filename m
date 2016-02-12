From: Hannes Reinecke <hare@suse.de>
Subject: Re: RCU-ified dm-mpath for testing/review
Date: Fri, 12 Feb 2016 16:18:47 +0100
Message-ID: <56BDF7D7.8040106@suse.de>
References: <56B7659C.8040601@dev.mellanox.co.il>
	<56B772D6.2090403@sandisk.com> <56B77444.3030106@dev.mellanox.co.il>
	<56B776DE.30101@dev.mellanox.co.il> <20160207172055.GA6477@redhat.com>
	<56B99A49.5050400@suse.de> <20160209145547.GA21623@redhat.com>
	<56BA0689.9030007@suse.de> <20160210004518.GA23646@redhat.com>
	<20160211015030.GA4481@redhat.com> <20160211153452.GA7827@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160211153452.GA7827@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "keith.busch@intel.com" <keith.busch@intel.com>, Christoph Hellwig <hch@infradead.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On 02/11/2016 04:34 PM, Mike Snitzer wrote:
> On Wed, Feb 10 2016 at  8:50pm -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> =

>> On Tue, Feb 09 2016 at  7:45pm -0500,
>> Mike Snitzer <snitzer@redhat.com> wrote:
>>
>>>
>>> OK, I took a crack at embracing RCU.  Only slightly better performance
>>> on my single NUMA node testbed.  (But I'll have to track down a system
>>> with multiple NUMA nodes to do any justice to the next wave of this
>>> optimization effort)
>>>
>>> This RCU work is very heavy-handed and way too fiddley (there could
>>> easily be bugs).  Anyway, please see:
>>> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=
=3Ddevel2&id=3Dd80a7e4f8b5be9c81e4d452137623b003fa64745
>>>
>>> But this might give you something to build on to arrive at something
>>> more scalable?
>>
>> I've a bit more polished version of this work (broken up into multiple
>> commits, with some fixes, etc) here:
>> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=3Dd=
evel3
>>
>> Hannes and/or Sagi, if you get a chance to try this on your NUMA system
>> please let me know how it goes.
> =

> Initial review has uncovered some locking problems with the current code
> (nothing that caused crashes or hangs in my testing but...) so please
> hold off on testing until you hear from me (hopefully tomorrow).
> =

Good news is that I've managed to hit the roof for my array with the
devel2 version of those patches. (And a _heavily_ patched-up lpfc
driver :-)
So from that perspective everything's fine now; we've reached the
hardware limit for my setup.
Which in itself is quite impressive; beating Intel P3700 with 16FC
is not bad methinks :-)

So thanks for all your work here.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
