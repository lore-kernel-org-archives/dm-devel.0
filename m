From: Joe Thornber <thornber@redhat.com>
Subject: Re: A patchset to limit the number of outstanding bios
Date: Mon, 13 Oct 2014 17:03:18 +0100
Message-ID: <20141013160317.GD27596@debian>
References: <alpine.LRH.2.02.1410131113450.3569@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1410131113450.3569@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Oct 13, 2014 at 11:27:20AM -0400, Mikulas Patocka wrote:
> Hi
> 
> I'm announcing the release of a patchset that limits the number of 
> outstanding bios in the device mapper.

Interesting; Mike and I were considering this for throttling io to
thinp a couple of weeks ago.  The reason we didn't go with this was,
for thinp, there are cheap bios (eg, a quick remap) and expensive bios
(eg, one that triggers a copy on write exception).  This means it's
very hard to come up with a single number that represents too many
bios.  Instead I throttle by looking at how long it's taking the
worker thread to get through it's work queue.

Could you make this limit optional please?  eg, setting the limit to 0
turns it off, and I'd prefer a default of 0/off.

- Joe
