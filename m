From: Ric Wheeler <ric@emc.com>
Subject: Re: Re: [PATCH] Implement barrier support for single device
	DM devices
Date: Mon, 18 Feb 2008 07:48:07 -0500
Message-ID: <47B97E87.6040209@emc.com>
References: <20080215120821.GA8267@basil.nowhere.org>
	<20080215122002.GM29914@agk.fab.redhat.com>
	<47B58EAA.8040405@msgid.tls.msk.ru>
	<20080215142010.GA29552@one.firstfloor.org>
	<20080215141229.GB1788@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080215141229.GB1788@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Alasdair G Kergon wrote:
> On Fri, Feb 15, 2008 at 03:20:10PM +0100, Andi Kleen wrote:
>> On Fri, Feb 15, 2008 at 04:07:54PM +0300, Michael Tokarev wrote:
>>> I wonder if it's worth the effort to try to implement this.
> 
> My personal view (which seems to be in the minority) is that it's a
> waste of our development time *except* in the (rare?) cases similar to
> the ones Andi is talking about.

Using working barriers is important for normal users when you really 
care about data loss and have normal drives in a box. We do power fail 
testing on boxes (with reiserfs and ext3) and can definitely see a lot 
of file system corruption eliminated over power failures when barriers 
are enabled properly.

It is not unreasonable for some machines to disable barriers to get a 
performance boost, but I would not do that when you are storing things 
you really need back.

Of course, you don't need barriers when you either disable the write 
cache on the drives or use a battery backed RAID array which gives you a 
write cache that will survive power outages...

ric
