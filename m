From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: back-ported dm-cache not forwarding read-ahead bios
	to origin
Date: Mon, 20 Jul 2015 13:22:26 -0400
Message-ID: <20150720172226.GA27018@redhat.com>
References: <CAM2wQBv43BGGhe+NHOEAz+usppL6CcR-2m_ratKNKR65GB+XVA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAM2wQBv43BGGhe+NHOEAz+usppL6CcR-2m_ratKNKR65GB+XVA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Thanos Makatos <thanos.makatos@onapp.com>
Cc: device-mapper development <dm-devel@redhat.com>, ejt@redhat.com, Mauelshagen@redhat.com
List-Id: dm-devel.ids

On Mon, Jul 20 2015 at 12:50pm -0400,
Thanos Makatos <thanos.makatos@onapp.com> wrote:

> I'm working on a back-ported dm-cache version for kernel 2.6.32-431.29.2
> (the CentOS 6 patched one) and I'm trying to solve a corruption bug
> apparently introduced during the back-port. I can consistently reproduce it
> by simply mounting an ext4 file-system that contains some data and running
> stat(1) against a specific directory. stat(1) fails with "Input/output
> error" and dmesg says:"EXT4-fs error (device dm-8): ext4_lookup: deleted
> inode referenced: 29". The file-system is mounted with options
> "data=writeback,ro,nodiscard,inode_readahead_blks=1" in order to minimise
> noise.

Upstream backports to RHEL6 are tricky because it doesn't have
upstream's latest block changes.  Care must be taken during the
backport.  I could easily see someone less aware of the pitfalls
producing a buggy kernel that cause corruption like you've reported.

The last dm-cache backport to RHEL6 was kernel-2.6.32-528.el6.
That backport sync'd dm-cache changes through upstream Linux 3.19.

I'm not going to put any time to this report.  Your best bet is to
rebase to the >= 528.el6 kernel and go from there (this translates to
the forthcoming RHEL6.7 kernel as the first publicly available release
with the changes in question).

Mike
