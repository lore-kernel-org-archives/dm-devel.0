From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/2] dm-ioband: I/O bandwidth controller
	v1.10.0: Source code and patch
Date: Tue, 20 Jan 2009 15:53:34 +0000
Message-ID: <20090120155334.GH9859@agk.fab.redhat.com>
References: <20090120.141022.193708059.ryov@valinux.co.jp>
	<20090120.141114.226778416.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090120.141114.226778416.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

So, what needs to be reviewed?


1. General style/layout/naming cleanup.
- It's pretty good compared to a lot of patches that get sent, but there are
still a few things we can improve.

Lindent is throwing up some stuff (but remember it doesn't get things
perfect so don't make all the changes it recommends).
Remove double blank lines, plenty of unnecessary braces, "unsigned int" ->
"unsigned".  
Review the names - should a few more things get a DM_ or dm_ prefix?
Are all the names consistent and as self-explanatory as they can reasonably be?
(e.g. a variable called 'new' - new what?)


2. A high-level review.
Review the documentation and what the code does and how it does it.
- Does it make sense to add this to the kernel in this way?


3. A device-mapper review.
- Does the code fit into device-mapper correctly, using all the dm interfaces properly?


4. A detailed code review.
- Checking for correctness, fixing typos, improving messages, looking for ways
  to improve the code structure etc.


So, it needs volunteers on this list to take on aspects of that and lend their
support to the patch.

I consider items 1, 2 and 3 as blockers that must be completed satisfactorily before
I can push it upstream.  (Items 1 and 3 should be quick; 2 may take a bit
longer.)  Item 4 is of course open-ended so does not have to be finished before
it can be included.

Alasdair
-- 
agk@redhat.com
