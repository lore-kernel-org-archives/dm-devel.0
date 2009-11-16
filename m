From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 1/2] dm-mpath: Add mutex to synchronize adding
	and flushing work
Date: Mon, 16 Nov 2009 18:16:38 +0900
Message-ID: <4B011876.1040101@ct.jp.nec.com>
References: <20091116073819.4070.40173.stgit@localhost.localdomain>
	<20091116073824.4070.71075.stgit@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091116073824.4070.71075.stgit@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Mike,

On 11/16/2009 04:38 PM +0900, Mike Anderson wrote:
> Add a mutex to allow possible creators of new work to synchronize with
> flushing work queues.
<snip>
> @@ -1268,7 +1271,11 @@ static void multipath_presuspend(struct dm_target *ti)
>  
>  static void multipath_postsuspend(struct dm_target *ti)
>  {
> +	struct multipath *m = (struct multipath *) ti->private;

Please drop the cast when it's from void.

For others,
Acked-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

Thanks,
Kiyoshi Ueda
