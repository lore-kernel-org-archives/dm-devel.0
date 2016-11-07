From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: no_path_retry: NO_PATH_RETRY_FAIL vs
	NO_PATH_RETRY_UNDEF
Date: Mon, 7 Nov 2016 12:55:20 -0600
Message-ID: <20161107185520.GM1972@octiron.msp.redhat.com>
References: <de9f8dce-c3d4-b371-6c99-5cf9226d8f09@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <de9f8dce-c3d4-b371-6c99-5cf9226d8f09@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 07, 2016 at 05:11:33PM +0100, Xose Vazquez Perez wrote:
> Hi,
> 
> 
> NO_PATH_RETRY_UNDEF is 0
> 
> 
> no_path_retry    Specify what to do when all paths are down. Possible values are:
> 
>                     value > 0   number of retries until disable I/O queueing.
> 
>                     fail        for immediate failure (no I/O queueing).
> 
>                     queue       for never stop I/O queueing. Similar to queue_if_no_path.
> 
> 
> 
> Is there any real difference?

The idea was that if you have NO_PATH_RETRY_UNDEF, then you just use
whatever is in the features line. If you have NO_PATH_RETRY_FAIL, that
takes priority over the features line.

So if someone has

features "1 queue_if_no_path"

then NO_PATH_RETRY_UNDEF gets you the same results as
NO_PATH_RETRY_QUEUE.

-Ben

> 
> 
> Thank you.
