From: "Busch, Keith" <keith.busch@intel.com>
Subject: Re: awful request merge results while simulating high
	IOPS multipath
Date: Wed, 25 Feb 2015 18:17:18 +0000
Message-ID: <B58D82457FDA0744A320A2FC5AC253B93BA8BF21@fmsmsx104.amr.corp.intel.com>
References: <1424796250-38553-1-git-send-email-snitzer@redhat.com>
	<1424796250-38553-5-git-send-email-snitzer@redhat.com>
	<54ECAC08.7040603@kernel.dk> <20150224172259.GA39226@redhat.com>
	<54ECBA78.6020204@kernel.dk> <20150224181257.GA11444@redhat.com>
	<54ECC000.40604@kernel.dk> <20150224183256.GA11566@redhat.com>
	<20150225005608.GA13348@redhat.com>
	<alpine.LNX.2.00.1502250401330.32385@localhost.lm.intel.com>
	<54EDE62D.7010308@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54EDE62D.7010308@kernel.dk>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Cc: "jmoyer@redhat.com" <jmoyer@redhat.com>, "shivakrishna.merla@netapp.com" <shivakrishna.merla@netapp.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids

Sorry, my reply was non sequitur to this thread. We don't do merging in NVMe.

Our first bottleneck appears to be the device mapper's single lock request queue.

> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Wednesday, February 25, 2015 8:12 AM
> To: Busch, Keith; Mike Snitzer
> Cc: jmoyer@redhat.com; dm-devel@redhat.com; shivakrishna.merla@netapp.com; Bart Van Assche
> Subject: Re: awful request merge results while simulating high IOPS multipath
> 
> On 02/24/2015 08:14 PM, Keith Busch wrote:
> > To be honest, we also see underwhelming performance on high IOPS PCIe
> > SSDs. We know of some bottlenecks and ideas to test, but hoping to work
> > out the kinks in those ideas before Vault in two weeks.
> 
> Related to merging, or?
> 
> --
> Jens Axboe
