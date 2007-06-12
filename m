From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [2.6.22-rc1-mm1 PATCH]
	dm-raid1-clear-region-outside-spinlock.patch
Date: Tue, 12 Jun 2007 17:08:09 +0100
Message-ID: <20070612160809.GQ25091@agk.fab.redhat.com>
References: <1179764750.13913.3.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1179764750.13913.3.camel@hydrogen.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Jon, please would you put together a more-detailed patch header before I
send this upstream?  I have already seen this analysis, but please
include it with the patch so other people can review it too.

It needs to mention:

  1) all the code reordering in the patch
  2) the fact clear_region() is no longer protected by the lock

and why these changes are all OK.

Alasdair
-- 
agk@redhat.com
