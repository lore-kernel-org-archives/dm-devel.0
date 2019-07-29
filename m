From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: [PATCH] md/raid0: Fail BIOs if their underlying
 block device is gone
Date: Mon, 29 Jul 2019 23:14:37 +0200
Message-ID: <01a849c9-0b9c-2ba7-f866-c92e7ebac1d5@thelounge.net>
References: <20190729193359.11040-1-gpiccoli@canonical.com>
	<20190730011850.2f19e140@natsu>
	<053c88e1-06ec-0db1-de8f-68f63a3a1305@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <053c88e1-06ec-0db1-de8f-68f63a3a1305@canonical.com>
Content-Language: de-CH
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Guilherme G. Piccoli" <gpiccoli@canonical.com>, Roman Mamedov <rm@romanrm.net>
Cc: linux-block@vger.kernel.org, Song Liu <songliubraving@fb.com>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com, jay.vosburgh@canonical.com
List-Id: dm-devel.ids



Am 29.07.19 um 22:27 schrieb Guilherme G. Piccoli:
>> If that's correct, then this seems to be a critical weak point in cases when
>> we have a RAID0 as a member device in RAID1/5/6/10 arrays.
> 
> Hi Roman, I don't think this is usual setup. I understand that there are
> RAID10 (also known as RAID 0+1) in which we can have like 4 devices, and
> they pair in 2 sets of two disks using stripping, then these sets are
> paired using mirroring. This is handled by raid10 driver however, so it
> won't suffer for this issue.
> 
> I don't think it's common or even makes sense to back a raid1 with 2
> pure raid0 devices.
if i would have been aware that RAID10 don't support "--write-mostly" to
make a hybrid HDD/SSD RAID (https://www.tansi.org/hybrid/) i would
likely have done exactly that to buy only 2 instead 4 x 2 TB SSD disks
here and frankly i have another 5 machines where this limitation of
RAID110 on linux sucks
