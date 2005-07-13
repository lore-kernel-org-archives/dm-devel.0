From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: pgcmp code nit
Date: Wed, 13 Jul 2005 14:17:40 -0500
Message-ID: <20050713191740.GA19555@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I was looking at the pgcmp code, and I noticed that there's a chance that
it will say that two maps equal when they are not.

For instance if you had a path group with 2 paths that had the addresses
0x10F0F0 and 0x100F00, and another path group with 2 paths that had the
addresses 0x100000 and 0x10FFF0, these two path groups would have the same
id. It seems to me that this could, if you were really unlucky, cause
multipath to not reload, even if there had been a topology change. Of course,
this isn't really likely, and rerunning multipath would probably fix it,
but it's still there.

Of course, I might be missing something that would keep this from happening.

-Ben
