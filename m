From: Roman Mamedov <rm@romanrm.net>
Subject: Re: [PATCH] md/raid0: Fail BIOs if their underlying
 block device is gone
Date: Tue, 30 Jul 2019 01:36:55 +0500
Message-ID: <20190730013655.229020ea@natsu>
References: <20190729193359.11040-1-gpiccoli@canonical.com>
	<20190730011850.2f19e140@natsu>
	<053c88e1-06ec-0db1-de8f-68f63a3a1305@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <053c88e1-06ec-0db1-de8f-68f63a3a1305@canonical.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: linux-block@vger.kernel.org, Song Liu <songliubraving@fb.com>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com, jay.vosburgh@canonical.com
List-Id: dm-devel.ids

On Mon, 29 Jul 2019 17:27:15 -0300
"Guilherme G. Piccoli" <gpiccoli@canonical.com> wrote:

> Hi Roman, I don't think this is usual setup. I understand that there are
> RAID10 (also known as RAID 0+1) in which we can have like 4 devices, and
> they pair in 2 sets of two disks using stripping, then these sets are
> paired using mirroring. This is handled by raid10 driver however, so it
> won't suffer for this issue.
> 
> I don't think it's common or even makes sense to back a raid1 with 2
> pure raid0 devices.

It might be not a usual setup, but it is a nice possibility that you get with
MD. If for the moment you don't have drives of the needed size, but have
smaller drives. E.g.:

- had a 2x1TB RAID1;
- one disk fails;
- no 1TB disks at hand;
- but lots of 500GB disks;
- let's make a 2x500GB RAID0 and have that stand in for the missing 1TB
member for the time being;

Or here's for a detailed rationale of a more permanent scenario:
https://louwrentius.com/building-a-raid-6-array-of-mixed-drives.html

-- 
With respect,
Roman
