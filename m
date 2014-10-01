From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] dm-raid: add RAID discard support
Date: Wed, 1 Oct 2014 13:57:24 -0500
Message-ID: <1D933D29-689C-407F-98BB-3092F99BDBD1@redhat.com>
References: <1411491106-23676-1-git-send-email-heinzm@redhat.com>
	<yq18ulaszpk.fsf@sermon.lab.mkp.net>
	<20140924093308.120fe616@notabene.brown>
	<yq1zjdpsqry.fsf@sermon.lab.mkp.net>
	<7C39EB56-623A-4318-A558-258ABA32FF12@redhat.com>
	<20140924142157.33475baa@notabene.brown>
	<5422A4C4.4020707@redhat.com>
	<20141001125625.1e0d356a@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141001125625.1e0d356a@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.de>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids


On Sep 30, 2014, at 9:56 PM, NeilBrown wrote:

> So that is probably what I would do:
>  - new version for bitmap which has 2 bits per region and encodes 3 states
>  - bitmap granularity matches chunk size (by default)
>  - decouple region size of bitmap from region size for internal 'dirty'
>    accounting
>  - write to a 'state 3' region sets it to 'state 2' and kicks off resync
>  - 'discard' sets state to '3'.

There are scenarios where we do not trust the bitmap and perform exhaustive searches (scrubbing).  When we do this, we assume that the bitmap has been correctly handled, but the data has been corrupted somehow.  When we scrub, we now could presumably use the bitmap to avoid those regions that have been discarded.  However, are there problems to be considered when the corruption is the other way around - i.e. when the bitmap/superblock are corrupted instead of the data area?  Do we consider problems like this unlikely because of the frequency of superblock writes?  (The bitrot that I am familiar with usually happens in areas that are not touched very often - especially if they exist near areas that /are/ touched very often.)

 brassow
