From: Tejun Heo <tj@kernel.org>
Subject: Re: Problem w/ CONFIG_DEBUG_BLOCK_EXT_DEVT
Date: Tue, 02 Sep 2008 13:06:24 +0200
Message-ID: <48BD1E30.8040602@kernel.org>
References: <48BD173B.3090600@hp.com> <48BD19B1.9040207@kernel.org>
	<48BD1BA5.1020604@hp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <48BD1BA5.1020604@hp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

Alan D. Brunelle wrote:
>>> (2) Device minor numbers can be quite large, and the 10-character limits
>>> in dm/lib/libdm-deptree.c are too small.
>> Would it be difficult to increase that?
> 
> No, but knowing the upper bound would be helpful.

Well, dev_t is 32bits and MINORBITS is 20.  So, major 12 bits, minor 20
bits, so 4 characters for major, 7 characters for minor.

-- 
tejun
