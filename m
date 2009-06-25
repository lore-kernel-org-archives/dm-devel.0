From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Re: [2.6.31-rc1] device-mapper: target device sda6 is
	misaligned
Date: Thu, 25 Jun 2009 12:05:47 -0400
Message-ID: <yq1prcsqox0.fsf@sermon.lab.mkp.net>
References: <200906250904.57149.elendil@planet.nl>
	<yq1tz24qqaj.fsf@sermon.lab.mkp.net>
	<200906251748.45475.elendil@planet.nl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200906251748.45475.elendil@planet.nl> (Frans Pop's message of
	"Thu, 25 Jun 2009 17:48:44 +0200")
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
Cc: linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

>>>>> "Frans" == Frans Pop <elendil@planet.nl> writes:

Frans> I've just also tested rc1 in the Hercules s390 emulator, and I
Frans> get exactly the same there on a virtual dasd disk:

Frans> dasd-eckd 0.0.0121: New DASD 3390/02 (CU 3990/02) with 1113
Frans> cylinders, 15 heads, 224 sectors dasd-eckd 0.0.0121: DASD with 4
Frans> KB/block, 801360 KB total size, 48 KB/track, compatible disk

DASD uses 4KB blocks so that makes more sense.

The SATA thing is weird.

-- 
Martin K. Petersen	Oracle Linux Engineering
