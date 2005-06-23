From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: Snapshot hang problem
Date: Thu, 23 Jun 2005 19:04:46 +0100
Message-ID: <20050623180446.GF4195@agk.surrey.redhat.com>
References: <Pine.LNX.4.44.0506231600490.5464-100000@Server.mbss.org>
	<Pine.LNX.4.44.0506231850110.6690-100000@Server.mbss.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0506231850110.6690-100000@Server.mbss.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

There are known problems with snapshots - esp. of root filesystem (don't)
or under load - see list archives/Red Hat bugzilla.

Believe problem analysed & solution known, but involves a lot of 
code changes that aren't complete yet.

Alasdair
