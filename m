From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: FIXED! [was: awful request merge results while
 simulating high IOPS] multipath
Date: Tue, 24 Feb 2015 23:41:57 -0500
Message-ID: <20150225044156.GB14060@redhat.com>
References: <1424796250-38553-1-git-send-email-snitzer@redhat.com>
	<1424796250-38553-5-git-send-email-snitzer@redhat.com>
	<54ECAC08.7040603@kernel.dk> <20150224172259.GA39226@redhat.com>
	<54ECBA78.6020204@kernel.dk> <20150224181257.GA11444@redhat.com>
	<54ECC000.40604@kernel.dk> <20150224183256.GA11566@redhat.com>
	<20150225005608.GA13348@redhat.com>
	<20150225043808.GA14060@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150225043808.GA14060@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <keith.busch@intel.com>, jmoyer@redhat.com, shivakrishna.merla@netapp.com, dm-devel@redhat.com, Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids

On Tue, Feb 24 2015 at 11:38pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> New multipath results using these 2 additional DM patches:
> 
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=d379ecbac533d3ac45c7f155b1fc1b760abace6e
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=d379ecbac533d3ac45c7f155b1fc1b760abace6e
> 
> (the important one being the last patch, thanks to Jens for the suggestion!)

Bleh, pasted the same url twice, this is the less signifcant patch of
the 2:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=489ab49e738667ba9d40b6d2b0b47910b5194208
