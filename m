From: Alex Adriaanse <alex.adriaanse@gmail.com>
Subject: Re: Odd data corruption problem with LVM/ReiserFS
Date: Mon, 21 Feb 2005 21:19:50 -0600
Message-ID: <93ca306705022119195db84f6e@mail.gmail.com>
References: <93ca3067050220212518d94666@mail.gmail.com>
	<20050221151852.GE14097@agk.surrey.redhat.com>
Reply-To: Alex Adriaanse <alex.adriaanse@gmail.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050221151852.GE14097@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org, reiserfs-list@namesys.com, dm-devel@redhat.com
List-Id: dm-devel.ids

I found out some interesting things tonight.  I removed my /var and
/home snapshots, and all the corruption, with the exception of files I
had changed while /var and /home were in their corrupted state, had
disappeared!

I overwrote several files on /var that were corrupt with clean copies
from my backups, and verified that they were OK.  I then created a new
/var snapshot, mounted it, only to find out that the files on that
snapshot were still corrupt, but the files under the real /var were
still in good shape.  I umounted, lvremoved, lvcreated, and mounted
the /var snapshot, and saw the same results.  Even after removing the
snapshot, rebooting, and recreating the snapshot I saw the same thing
(real /var had correct file, snapshot /var had corrupt file).

Do you think my volume group has simply become corrupt and will need
to be recreated, or do you guys think this is a bug in dm-snapshot? 
If so, please let me know what I can do to help you guys debug this.

Thanks,

Alex


On Mon, 21 Feb 2005 15:18:52 +0000, Alasdair G Kergon <agk@redhat.com> wrote:
> On Sun, Feb 20, 2005 at 11:25:37PM -0600, Alex Adriaanse wrote:
> > This morning was the first time my backup script took
> > a snapshot since upgrading to 2.6.10-ac12 (yesterday I had taken a few
> > snapshots myself for testing purposes, this seemed to work fine).
> 
> a) Activating a snapshot requires a lot of memory;
> 
> b) If a snapshot can't get the memory it needs you have to back it
> out manually (using dmsetup - some combination of resume, remove &
> possibly reload) to avoid locking up the volume - what you have to do
> depends how far it got before it failed;
> 
> c) You should be OK once a snapshot is active and its origin has
> successfully had a block written to it.
> 
> Work is underway to address the various problems with snapshot activation
> - we think we understand them all - but until the fixes have worked their
> way through, unless you've enough memory in the machine it's best to avoid
> them.
> 
> Suggestions:
>   Only do one snapshot+backup at once;
>   Make sure logging in as root and using dmsetup does not depend on access
>   to anything in /var or /home (similar to the case of hard NFS mounts with
>   the server down) so you can still log in;
> 
> BTW Also never snapshot the root filesystem unless you've mounted it noatime
> or disabled hotplug etc. - e.g. the machine can lock up attempting to
> update the atime on /sbin/hotplug while writes to the filesystem are blocked
> 
> Alasdair
> --
> agk@redhat.com
>
