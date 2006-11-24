From: Adrian Bunk <bunk@stusta.de>
Subject: RFC: dm patches for 2.6.16
Date: Fri, 24 Nov 2006 04:24:44 +0100
Message-ID: <20061124032444.GH28363@stusta.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="WIyZ46R2i8wDzkSu"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mark McLoughlin <markmc@redhat.com>, Michal Miroslaw <mirq-linux@rere.qmqm.pl>, Daniel Kobras <kobras@linux.de>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following attached patches seem to make sense for 2.6.16:

Added in 2.6.17.11 and 2.6.18:
dm: BUG/OOPS fix

Added in 2.6.17.12 and 2.6.18:
dm snapshot: unify chunk_size
dm: add module ref counting
dm: mirror sector offset fix
dm: Fix deadlock under high i/o load in raid1 setup.

Added in 2.6.19:
dm snapshot: fix metadata writing when suspending


For an easier review, I've attached the patches.

Do these patches look OK for 2.6.16, or should I not apply some or all?

Are there any critical patches I missed?

TIA
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dm-bug-oops-fix.patch"


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--WIyZ46R2i8wDzkSu--
