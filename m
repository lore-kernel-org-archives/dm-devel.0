From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: Re: [RFC][PATCH 0/10] I/O context inheritance
Date: Tue, 22 Apr 2008 23:03:18 +0900 (JST)
Message-ID: <20080422.230318.112756414.taka@valinux.co.jp>
References: <20080422.224935.00673711.taka@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080422.224935.00673711.taka@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, agk@sourceware.org
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi,

Sorry, these patches are for linux-2.6.25.

> This series of patches make the block I/O layer and the I/O schedulers
> be able to determine the right io_context of every I/O.
> 
> The current implementation of the block I/O layer and the I/O schedulers
> assume that the current process is the one which issued the given I/O,
> then use the io_context of this process to control the I/O.
> But this assumption isn't quite right because several kernel threads
> will handle I/O requests on behalf of the processes which originated them.
> This often happens when you want to use device mapper modules.
> 
> The patches make every bio has a pointer to an io_context, which will
> be set when it is allocated or cloned. So it makes it possible to find
> the right io_context from any bio at any place.
> 
> I'm waiting for your comments.
> 
> Thank you,
> Hirokazu Takahashi.
