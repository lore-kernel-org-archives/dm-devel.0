From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] dm-raid: add RAID discard support
Date: Thu, 02 Oct 2014 21:12:13 -0400
Message-ID: <yq1y4sygdn6.fsf@sermon.lab.mkp.net>
References: <1411491106-23676-1-git-send-email-heinzm@redhat.com>
	<yq18ulaszpk.fsf@sermon.lab.mkp.net>
	<20140924093308.120fe616@notabene.brown>
	<yq1zjdpsqry.fsf@sermon.lab.mkp.net>
	<7C39EB56-623A-4318-A558-258ABA32FF12@redhat.com>
	<20140924142157.33475baa@notabene.brown> <5422A4C4.4020707@redhat.com>
	<20141001125625.1e0d356a@notabene.brown> <542BE1C6.2050105@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <542BE1C6.2050105@redhat.com> (Heinz Mauelshagen's message of
	"Wed, 01 Oct 2014 13:13:10 +0200")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

>>>>> "Heinz" == Heinz Mauelshagen <heinzm@redhat.com> writes:

Heinz> BTW: we're referring to SSD discard_zeroes_data issues only so
Heinz> far it seems?  Can we be sure that SCSI unmap with the TPRZ bit
Heinz> set will always return zeroes on reads for arbitrary storage
Heinz> devices?

Only if we used WRITE SAME to discard.

-- 
Martin K. Petersen	Oracle Linux Engineering
