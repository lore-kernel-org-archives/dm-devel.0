From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm: bind new table before destroying old
Date: Wed, 11 Nov 2009 15:11:10 +0000
Message-ID: <20091111151110.GO17055@agk-dp.fab.redhat.com>
References: <20091111011652.GK17055@agk-dp.fab.redhat.com>
	<4AFA6005.9060501@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AFA6005.9060501@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Heinz Mauelshagen <mauelshagen@redhat.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 11, 2009 at 03:56:05PM +0900, Kiyoshi Ueda wrote:
> I believe dm-mpath needs to flush such workqueues in postsuspend.

Yes - should be an easy change.

> Also, we need something to block message ioctl to suspended device.
 
> As for the message ioctl, I don't have any good idea, but...
>   - Reject message ioctl to suspended device in dm-ioctl

I think the crypt target expects to be able to do this to manipulate
the in-core encryption key.

>   - Targets must not kick any work influencing external themselves
>     in their message ioctl handlers.

So I think we'll need a target-specific approach like that here.

Alasdair
