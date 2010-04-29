From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: semop failed for cookie?
Date: Thu, 29 Apr 2010 01:00:45 +0100
Message-ID: <20100429000045.GF29708@agk-dp.fab.redhat.com>
References: <4BD74F99.8020605@filteredperception.org>
	<20100427223323.GB29708@agk-dp.fab.redhat.com>
	<4BD8C0B2.7020509@filteredperception.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4BD8C0B2.7020509@filteredperception.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Douglas McClendon <dmc.fedora@filteredperception.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Apr 28, 2010 at 06:11:46PM -0500, Douglas McClendon wrote:
> device-mapper: snaphots: Unable to perform snapshot handover until  
> source is suspended.

It has never been OK to have the same snapshot metadata in use
simultaneously in two targets at once (because of caching in memory).
It's the responsibility of userspace to adhere to the correct semantics
or live with the potential data corruption if they are violated.  It
sounds like your process may fall into that second category.

Part of the process of adding snapshot merging support involved
providing a controlled method for handing over the snapshot metadata
from one target instance to another.

If you are trying to move a snapshot from one target to another, then
you must either deactivate the snapshot first (older kernels) or (newer
kernels) make use of the 'snapshot handover' mechanism as the message
suggests.

Alasdair
