From: Jim Meyering <jim@meyering.net>
Subject: unofficial git mirror of LVM2 and device-mapper CVS
	repositories
Date: Sat, 28 Jul 2007 15:07:18 +0200
Message-ID: <87odhwwubd.fsf@rho.meyering.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: LVM <lvm-devel@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I've set up an automatically-sync'd git mirror for each of the
device-mapper and LVM2 cvs repositories.  Each mirror is updated
approximately every 15 minutes.  You can view the summaries via these
URLs:

    http://git.et.redhat.com/?p=lvm2.git
    http://git.et.redhat.com/?p=device-mapper.git

You can get a copy of either repository like this:
(this uses the efficient "git://" protocol, and is sort of
analogous to CVS pserver, i.e. anonymous, for read-only access)

    git clone git://et.redhat.com/lvm2
    git clone git://et.redhat.com/device-mapper

They're not big, just 6.6MB and 6.1MB respectively, yet
each contains the entire revision history for its project.
[For the record, each size above include a checked out copy of the
 sources as well as the ".git" repository.  Each repository itself
 is only 20-25% the size of the corresponding CVS repository. ]

Note, if you're new to "git", you typically do the "git clone" only
once, initially, and from then on, you "cd" into the directory and
download/merge the latest sources via "git pull".

Also, for now, these two repository mirrors are no more than a
personal project/service that I find useful.  Eventually, they may
be classified as "supported", but perhaps via a different host, e.g.,
git.fedoraproject.org.  If/when anything changes, I'll announce it here.
