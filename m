From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1 of 1] Updated cluster log patch
Date: Tue, 7 Apr 2009 02:05:05 +0100
Message-ID: <20090407010505.GH5688@agk.fab.redhat.com>
References: <1238683235.24108.5.camel@hydrogen.msp.redhat.com>
	<20090407005253.GG5688@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090407005253.GG5688@agk.fab.redhat.com>
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

Actually, last time we wanted to use netlink we ended up using uevents
instead IIRC.

So I think we should also document the reason why netlink was selected
as the most appropriate interface for this particular use.

Alasdair
-- 
agk@redhat.com
