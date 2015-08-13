From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] dm-raid.txt: document discard support
Date: Thu, 13 Aug 2015 13:31:43 -0400
Message-ID: <yq1oaibaydc.fsf@sermon.lab.mkp.net>
References: <1438872279-30693-1-git-send-email-heinzm@redhat.com>
	<yq14mk9iw4d.fsf@sermon.lab.mkp.net> <55CB4931.6050306@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <55CB4931.6050306@redhat.com> (Heinz Mauelshagen's message of
	"Wed, 12 Aug 2015 15:25:05 +0200")
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

>>>>> "Heinz" == Heinz Mauelshagen <heinzm@redhat.com> writes:

Heinz,

Heinz> so can we rely on discard_zeroes_data if reported 100% now?

The intent is for the reporting to be accurate, yes.

This means that for SCSI we only turn it on when using the WRITE
SAME(10/16) commands. These require the storage to physically zero out
any portions of the request that can not be successfully deallocated.

For SATA we can't trust the protocol but vendors are sometimes willing
to provide guarantees above and beyond what is in the spec. I explicitly
whitelist devices from vendors that have done so.

It appears Microsoft is as disenchanted with the standards bodies as we
are and are now requiring vendors to provide hard guarantees. As a
result we should be able to leverage Windows qualifications going
forward.

That said, all storage is buggy so there is always some risk involved.
But as of 3.19, discard_zeroes_data=1 has much stricter requirements
than it did in prior kernels.

-- 
Martin K. Petersen	Oracle Linux Engineering
