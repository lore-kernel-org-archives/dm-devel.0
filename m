From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [Bugme-new] [Bug 7158] New: Out of memory happen in
	snapshot
Date: Thu, 14 Sep 2006 14:33:28 +0100
Message-ID: <20060914133328.GW13859@agk.surrey.redhat.com>
References: <20060913223638.fcb73078.akpm@osdl.org>
	<200609140644.k8E6iib1026888@mail.thecus.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200609140644.k8E6iib1026888@mail.thecus.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: kevin Cheng <kevin_cheng@thecus.com>
Cc: 'Andrew Morton' <akpm@osdl.org>, dm-devel@redhat.com, agk@redhat.com, "'bugme-daemon@kernel-bugs.osdl.org'" <bugme-daemon@bugzilla.kernel.org>
List-Id: dm-devel.ids

What is the output of these three commands?

  dmsetup info -c
  dmsetup table
  dmsetup status

The current snapshot implementation does require a lot of kernel memory
to store each snapshot's exception table, which grows as there is new I/O.
Eight snapshots means eight times the memory needed by one snapshot.

Are you using the default chunk size?  If so, try a larger one (lvcreate -c).

Alasdair
-- 
agk@redhat.com
