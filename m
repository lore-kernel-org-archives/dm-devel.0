From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Can DM pass SCSI command to path now?
Date: Fri, 17 Aug 2018 00:35:06 -0700
Message-ID: <20180817073506.GA8653@infradead.org>
References: <HK0PR06MB25611BB82C50809642EFC4C5D53E0@HK0PR06MB2561.apcprd06.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <HK0PR06MB25611BB82C50809642EFC4C5D53E0@HK0PR06MB2561.apcprd06.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Changwei Ge <gechangwei@live.cn>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "liu.cong@h3c.com" <liu.cong@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "changlimin@h3c.com" <changlimin@h3c.com>, "ge.changwei@h3c.com" <ge.changwei@h3c.com>
List-Id: dm-devel.ids

On Thu, Aug 16, 2018 at 11:56:48AM +0000, Changwei Ge wrote:
> Hi list,
> 
> Recently, I found that block request can't take SCSI CDB any more.
> 
> So, can we still pass SCSI command to DM device which will clone the 
> request and transfer it real path?

You never could before, as the infrastructure was always missing.
