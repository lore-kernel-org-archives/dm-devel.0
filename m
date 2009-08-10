From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH-v2 0/2] delay initializing queue for
	request-based dm
Date: Mon, 10 Aug 2009 16:18:12 +0530
Message-ID: <200908101618.12508.knikanth@suse.de>
References: <200908081025.54154.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200908081025.54154.knikanth@suse.de>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Saturday 08 August 2009 10:25:53 Nikanth Karthikesan wrote:
> Hi
>
> Currently for device-mapper devices, we initialize the mempool for requests
> and elevator at device creation time. But only request-based devices use
> the elevator and mempool. These patches change it to allocate the mempool
> and initialize the elevator only for request-based devices. This is done by
> allocating a queue at device creation time, but delaying the initialization
> of elevator and allocation of mempool till the first table load time, when
> the type of device would be known.
>
> [PATCH 1/2] Allow delaying initialization of queue after allocation
>
> [PATCH 2/2] Initialize mempool and elevator only for request-based dm
> devices
>
> Another approach would be to free the mempool and detach elevator, if it
> would be a bio-based device. But it is better to avoid initialization
> itself.
>

Changes since v1:
1. Refreshed on top of a4e7d46407d73f35d217013b363b79a8f8eafcaa
2. Added comments suggested by Mike Snitzer.
3. Cleaned up the second patch as suggested by Mike Snitzer.

Thanks
Nikanth
