From: Akira Hayakawa <hayakawa@valinux.co.jp>
Subject: Re: [PATCH 9/9] dm crypt: sort writes
Date: Wed, 2 Apr 2014 08:21:13 +0900
Message-ID: <20140402082113.0665494c70af795d0746ddec@valinux.co.jp>
References: <1396037476-26595-1-git-send-email-snitzer@redhat.com>
	<1396037476-26595-10-git-send-email-snitzer@redhat.com>
	<53368043.5000808@gmail.com> <20140331123940.GB25683@redhat.com>
	<20140401083755.55afa738d5a98b6bc07aca71@valinux.co.jp>
	<20140401010129.GB9214@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140401010129.GB9214@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: "masami.hiramatsu.pt@hitachi.com" <masami.hiramatsu.pt@hitachi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

> OK.  FYI, I cleaned the code up a little today based on Milan's dislike
> for the #define within the function, see:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=039e943277604c3f4f6b4ee803b8793627d53d36

Thanks Mike, I did it last night (feature/sorted-writeback branch)
https://github.com/akiradeveloper/dm-writeboost/tree/feature/sorted-writeback/src

The codes in dm-crypt and dm-thin really helped.

Confirmed actually sorted.

Outline:
- In dm-writeboost.h
-- struct migrate_io is defined
- In dm-writeboost-daemon.c
-- prepare_migrate_ios() adds all migrate I/Os into the tree (add_migrate_io() is called for each)
-- submit_migrate_ios() tasks them out one by one in sorted order of pair (address, id) (compare_migrate_io() is the comparator)

--
Akira
