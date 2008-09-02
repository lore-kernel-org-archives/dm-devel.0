From: Tejun Heo <tj@kernel.org>
Subject: Re: Re: Problem w/ CONFIG_DEBUG_BLOCK_EXT_DEVT
Date: Tue, 02 Sep 2008 14:23:13 +0200
Message-ID: <48BD3031.3090905@kernel.org>
References: <48BD173B.3090600@hp.com> <48BD19B1.9040207@kernel.org>
	<48BD1BA5.1020604@hp.com> <48BD1E30.8040602@kernel.org>
	<20080902122006.GN15123@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080902122006.GN15123@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, "Alan D. Brunelle" <Alan.Brunelle@hp.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

Alasdair G Kergon wrote:
> On Tue, Sep 02, 2008 at 01:06:24PM +0200, Tejun Heo wrote:
>> Well, dev_t is 32bits and MINORBITS is 20.  So, major 12 bits, minor 20
>> bits, so 4 characters for major, 7 characters for minor.
>  
> Upstream libdevmapper CVS patched - will appear in next release (1.02.28).

Alright, thanks.  What about the /proc/devices one?  Would adding an
entry help?  I'm kind of lost /proc/devices.  It's now mostly
non-functional legacy stuff we've been carrying around.  Is it
deprecated or do we intend to keep it around forever?

Ooh.. which also reminds me that I forgot to reserve the major number w/
lanana.  Will do that.

Thanks.

-- 
tejun
