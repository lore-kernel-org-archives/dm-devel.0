From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [2.6.31-rc1] device-mapper: target device sda6 is
	misaligned
Date: Thu, 25 Jun 2009 11:36:04 -0400
Message-ID: <yq1tz24qqaj.fsf@sermon.lab.mkp.net>
References: <200906250904.57149.elendil@planet.nl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200906250904.57149.elendil@planet.nl> (Frans Pop's message of
	"Thu, 25 Jun 2009 09:04:56 +0200")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frans Pop <elendil@planet.nl>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

>>>>> "Frans" == Frans Pop <elendil@planet.nl> writes:

Frans> During boot of 2.6.31-rc1 on an arm EABI system I got the
Frans> following errors: device-mapper: ioctl: 4.15.0-ioctl (2009-04-01)
Frans> initialised: dm-devel@redhat.com device-mapper: table: 254:0:
Frans> target device sda6 is misaligned device-mapper: table: 254:0:
Frans> target device sda6 is misaligned device-mapper: table: 254:1:
Frans> target device sda6 is misaligned device-mapper: table: 254:1:
Frans> target device sda6 is misaligned

Frans> Please advise and let me know what additional info is needed.

What kind of disk is this?

-- 
Martin K. Petersen	Oracle Linux Engineering
