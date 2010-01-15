From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [RFC PATCH] dm: Remove dm_get() from
	dm_table_get_md()
Date: Fri, 15 Jan 2010 19:01:19 +0000
Message-ID: <20100115190118.GF17760@agk-dp.fab.redhat.com>
References: <4B41A699.5080802@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4B41A699.5080802@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Jan 04, 2010 at 05:28:09PM +0900, Kiyoshi Ueda wrote:
> I'd like to remove dm_get() in dm_table_get_md() because
> dm_table_get_md() could be called from presuspend/postsuspend,
> which are called while mapped_device is in DMF_FREEING state,
> where dm_get() is not allowed.

I haven't spotted any problems with this, so I'm queueing it to
linux-next.

Alasdair
