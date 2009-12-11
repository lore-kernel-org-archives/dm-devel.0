From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Re: todays git regression (2.6.32-04008.g3ff6a46): lot
	of device mapper warnings
Date: Fri, 11 Dec 2009 11:47:40 -0500
Message-ID: <yq13a3hv4nn.fsf@sermon.lab.mkp.net>
References: <200912091049.12604.borntraeger@de.ibm.com>
	<170fa0d20912091656s31575d0cneaf899e1781bdc16@mail.gmail.com>
	<yq1bpi7vdes.fsf@sermon.lab.mkp.net>
	<200912111028.05512.borntraeger@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200912111028.05512.borntraeger@de.ibm.com> (Christian
	Borntraeger's message of "Fri, 11 Dec 2009 10:28:05 +0100")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Heinz Diehl <htd@fancy-poultry.org>
List-Id: dm-devel.ids

>>>>> "Christian" == Christian Borntraeger <borntraeger@de.ibm.com> writes:

Christian> any news on the final fix? Do you want Heinz and me to verify
Christian> your fix on our systems?

Looking into this issue unearthed an unrelated problem with the topology
stacking algorithm that turns out to be much trickier to fix.  That's
what's taking time.

Since the first bug is simply causing a warning I'm inclined to get
everything fixed up before having Jens queue a fix.  Shouldn't be more
than a day or two before I have all this worked out.

-- 
Martin K. Petersen	Oracle Linux Engineering
