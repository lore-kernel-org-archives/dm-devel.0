From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Fw: BUG: Files corrupt after moving LVM volume to USB
	disk
Date: Thu, 22 Mar 2007 15:33:01 +0000
Message-ID: <20070322153301.GN27600@agk.surrey.redhat.com>
References: <20070322000348.92631512.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070322000348.92631512.akpm@linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Marti Raudsepp <marti@juffo.org>
Cc: dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>
List-Id: dm-devel.ids

On Thu, Mar 22, 2007 at 12:03:48AM -0800, Andrew Morton wrote:
> ho hum I'm getting rather bored of redirecting emails to the correct lists.
> Does anyone there read linux-kernel?
 
I for one generally only spot things with 'lvm' or device-mapper/dm in
the subject line.  The original subject line included no clue this one
had anything to do with device-mapper:-(

A couple of patches to try:
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/2.6.19/dm-io-fix-bi_max_vecs.patch
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-merge-max_hw_sector.patch

and perhaps these three:
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-crypt-fix-call-to-clone_init.patch
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-crypt-fix-avoid-cloned-bio-ref-after-free.patch
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-crypt-fix-remove-first_clone.patch

Alasdair
-- 
agk@redhat.com
