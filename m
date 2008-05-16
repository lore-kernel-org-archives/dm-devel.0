From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Re: [PATCH] Implement barrier support for single device
	DM devices
Date: Fri, 16 May 2008 23:48:21 +0200
Message-ID: <482E0125.7070701@firstfloor.org>
References: <20080215120821.GA8267@basil.nowhere.org>	
	<20080215122002.GM29914@agk.fab.redhat.com>	
	<47B58EAA.8040405@msgid.tls.msk.ru>	
	<20080215142010.GA29552@one.firstfloor.org>	
	<20080215141229.GB1788@agk.fab.redhat.com>
	<47B97E87.6040209@emc.com>	 <47B9870B.8060005@msgid.tls.msk.ru>
	<47B98D8A.7090506@emc.com>	
	<20080219024533.GC4066@agk.fab.redhat.com>
	<170fa0d20805161255i31d768ceh3b15c2640f06524b@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <170fa0d20805161255i31d768ceh3b15c2640f06524b@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, agk@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Mike Snitzer wrote:

> Given that you feel supporting barriers on single device DM targets is
> a good thing, what is the status of such support (like Andi's patch)
> making it upstream?

It's not in 2.6.26-rc2. I was also a little surprised by it missing.

-Andi
