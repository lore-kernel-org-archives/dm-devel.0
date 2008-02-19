From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH] Implement barrier support for single
	device DM devices
Date: Tue, 19 Feb 2008 02:45:33 +0000
Message-ID: <20080219024533.GC4066@agk.fab.redhat.com>
References: <20080215120821.GA8267@basil.nowhere.org>
	<20080215122002.GM29914@agk.fab.redhat.com>
	<47B58EAA.8040405@msgid.tls.msk.ru>
	<20080215142010.GA29552@one.firstfloor.org>
	<20080215141229.GB1788@agk.fab.redhat.com>
	<47B97E87.6040209@emc.com> <47B9870B.8060005@msgid.tls.msk.ru>
	<47B98D8A.7090506@emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <47B98D8A.7090506@emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ric Wheeler <ric@emc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Andi Kleen <andi@firstfloor.org>, Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Feb 18, 2008 at 08:52:10AM -0500, Ric Wheeler wrote:
> I understand that. Most of the time, dm or md devices are composed of 
> uniform components which will uniformly support (or not) the cache flush 
> commands used by barriers.
 
As a dm developer, it's "almost none of the time" because trivial
configurations aren't the ones that require lots of testing effort.

Let's stop arguing over "most of the time":-)

As Andi points out, there are certainly enough real-world users of
"single linear or crypt target using one physical device" for it to be
worth our supporting it.

Alasdair
-- 
agk@redhat.com
