From: Burn Alting <burn@goldweb.com.au>
Subject: RFC - new multi path scheduler - Striped
Date: Thu, 21 Feb 2008 21:42:15 +1100
Message-ID: <1203590536.7756.112.camel@swtf.comptex.com.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

I'd like to propose a new multipath scheduler - striped.  The idea is
that, given a stripe size, S, we stripe the io in S block segments across
the available multiple paths.  If a path fails then a pre-determined
division of the stripe size reallocates which path gets the missing
paths data.

Taking the case of two paths and a stripe size of S blocks,

stripe number 0, blocks   0 thru   S - 1 goes via the first path;
stripe number 1, blocks   S thru 2*S - 1 goes via the second path;
stripe number 2, blocks 2*S thru 3*S - 1 goes via the first path and so forth.

If a path fails, then the surviving path gets all io.

Taking the general case of N paths and a stripe size of S blocks.

stripe number   0, blocks       0 thru   S - 1 goes via the first path
stripe number   1, blocks       S thru 2*S - 1 goes via the second path
stripe number   2, blocks     2*S thru 3*S - 1 goes via the third path
stripe number   3, blocks     3*S thru 4*S - 1 goes via the third path
stripe number N-1, blocks (N-1)*S thru N*S - 1 goes via the (N-1)th path
and so on

If a path fails, then we could say flush/drain all io's, redirect the
io's for the failed path to an adjacent path and then recompute the
stripe from N to N - 1 - ie keep the io balanced.


WHY?

For active-active multi-controller raid environments. I believe, if
we select an appropriate stripe size, then there would be minimal
interlock/cache clashes on the raid controllers and so we lessening
the chance of delay due to the raid controllers interlocking.

Raids tend to have a set stripe size, so the 'S' stripe size one would choose for
the multi-path driver would need to be a multiple of the raid controller's stripe size.

Can people comment on this?

Burn Alting
