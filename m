From: Changwei Ge <gechangwei@live.cn>
Subject: [RFC] Can DM pass SCSI command to path now?
Date: Thu, 16 Aug 2018 11:56:48 +0000
Message-ID: <HK0PR06MB25611BB82C50809642EFC4C5D53E0@HK0PR06MB2561.apcprd06.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
Content-ID: <48675B074E85A1469D68A5A413A79992@apcprd06.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Cc: "liu.cong@h3c.com" <liu.cong@h3c.com>, "ge.changwei@h3c.com" <ge.changwei@h3c.com>, "changlimin@h3c.com" <changlimin@h3c.com>
List-Id: dm-devel.ids

Hi list,

Recently, I found that block request can't take SCSI CDB any more.

So, can we still pass SCSI command to DM device which will clone the 
request and transfer it real path?

Otherwise, we query current path of DM each time before issuing a SCSI 
command?

Thanks,

Changwei
