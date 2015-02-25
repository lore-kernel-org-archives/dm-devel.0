From: Jens Axboe <axboe@kernel.dk>
Subject: Re: awful request merge results while simulating high
	IOPS multipath
Date: Wed, 25 Feb 2015 07:11:41 -0800
Message-ID: <54EDE62D.7010308@kernel.dk>
References: <1424796250-38553-1-git-send-email-snitzer@redhat.com>
	<1424796250-38553-5-git-send-email-snitzer@redhat.com>
	<54ECAC08.7040603@kernel.dk> <20150224172259.GA39226@redhat.com>
	<54ECBA78.6020204@kernel.dk>
	<20150224181257.GA11444@redhat.com> <54ECC000.40604@kernel.dk>
	<20150224183256.GA11566@redhat.com>
	<20150225005608.GA13348@redhat.com>
	<alpine.LNX.2.00.1502250401330.32385@localhost.lm.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LNX.2.00.1502250401330.32385@localhost.lm.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>, Mike Snitzer <snitzer@redhat.com>
Cc: jmoyer@redhat.com, shivakrishna.merla@netapp.com, dm-devel@redhat.com, Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids

On 02/24/2015 08:14 PM, Keith Busch wrote:
> To be honest, we also see underwhelming performance on high IOPS PCIe
> SSDs. We know of some bottlenecks and ideas to test, but hoping to work
> out the kinks in those ideas before Vault in two weeks.

Related to merging, or?

-- 
Jens Axboe
