From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: todays git regression (2.6.32-04008.g3ff6a46): lot
	of device mapper warnings
Date: Wed, 09 Dec 2009 20:14:03 -0500
Message-ID: <yq1bpi7vdes.fsf@sermon.lab.mkp.net>
References: <200912091049.12604.borntraeger@de.ibm.com>
	<20091209212516.GA6206@fancy-poultry.org>
	<20091209214501.GC8742@kernel.dk> <20091209220749.GD8742@kernel.dk>
	<170fa0d20912091656s31575d0cneaf899e1781bdc16@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <170fa0d20912091656s31575d0cneaf899e1781bdc16@mail.gmail.com>
	(Mike Snitzer's message of "Wed, 9 Dec 2009 19:56:46 -0500")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@gmail.com>
Cc: martin.petersen@oracle.com, linux-kernel@vger.kernel.org, Christian Borntraeger <borntraeger@de.ibm.com>, dm-devel@redhat.com, Jens Axboe <jens.axboe@oracle.com>, Heinz Diehl <htd@fancy-poultry.org>
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@gmail.com> writes:

Mike> On the surface I thought this might be the reason for the
Mike> warnings, but Martin's lcm() looks perfectly fine; can't see why
Mike> it would cause these warnings to appear all of a sudden... but I
Mike> figured I'd share.

The warning is caused by an error in stacking discard granularity.  I
have a fix but I'd like to run verify all my oddball alignment combos
before submitting.

-- 
Martin K. Petersen	Oracle Linux Engineering
