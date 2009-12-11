From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: todays git regression (2.6.32-04008.g3ff6a46): lot
	of device mapper warnings
Date: Fri, 11 Dec 2009 10:28:05 +0100
Message-ID: <200912111028.05512.borntraeger@de.ibm.com>
References: <200912091049.12604.borntraeger@de.ibm.com>
	<170fa0d20912091656s31575d0cneaf899e1781bdc16@mail.gmail.com>
	<yq1bpi7vdes.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <yq1bpi7vdes.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, Heinz Diehl <htd@fancy-poultry.org>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

Am Donnerstag 10 Dezember 2009 02:14:03 schrieb Martin K. Petersen:
> The warning is caused by an error in stacking discard granularity.  I
> have a fix but I'd like to run verify all my oddball alignment combos
> before submitting.

Martin,

any news on the final fix? Do you want Heinz and me to verify your fix
on our systems?

Christian
