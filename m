From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [patch] leastpending_io load balancing policy
Date: Wed, 3 Dec 2008 23:01:40 +0000
Message-ID: <20081203230140.GE5098@agk.fab.redhat.com>
References: <2118D41AB77C214BBF7D2330CD977BCF1BB395790D@GVW1162EXB.americas.hpqcorp.net>
	<20081203220819.GO26097@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20081203220819.GO26097@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Balasubramanian, Vijayakumar (STSD)" <vijayakumar@hp.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Also look at request based multipath patch rqdm-dlb-02-queue-length-dlb.patch
which addresses some but not all of those points.

In particular I'd be interested in evidence as to whether repeat counts or 
thresholds work better.

Alasdair
-- 
agk@redhat.com
