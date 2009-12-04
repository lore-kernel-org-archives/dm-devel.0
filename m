From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [patch] memory leak dm-exception-store.c
Date: Fri, 4 Dec 2009 03:30:50 +0000
Message-ID: <20091204033050.GU22702@agk-dp.fab.redhat.com>
References: <20091128103113.GF10640@bicker>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091128103113.GF10640@bicker>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dan Carpenter <error27@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, Nov 28, 2009 at 12:31:13PM +0200, Dan Carpenter wrote:
> Without this change we would leak tmp_store.

Already fixed in linux-next.
  http://patchwork.kernel.org/patch/38657/

Alasdair
