From: Mikulas Patocka <mpatocka@redhat.com>
Subject: bvec_merge_fn
Date: Wed, 28 Apr 2010 12:13:04 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1004281206400.793@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

See this bug: https://bugzilla.redhat.com/show_bug.cgi?id=223947

It shows that md-raid doesn't split bio and it relies on bios not being 
larger than what bvec_merge_fn allows. If you split a small bio that 
crosses md-raid stripe bounday, it aborts it with the errors shown in the 
bug report.

So, unfortunatelly, bvec_merge_fn is not advisory. I think it would be 
better if it were, but it isn't.



As you talked about "accepting any size bio in dm and always process it 
correctly", this would mean two-level splitting:

1. split it on target boundary and t->split_io (as it is being done now)
2. submit it to the target
3. the target decides, where the bio goes
4. check the limits for the destination device and its bvec_merge_fn, and 
maybe split the bio second time, to match it. (this split can't be done at 
step 1, because at step 1 we don't know the destination device)

Mikulas
