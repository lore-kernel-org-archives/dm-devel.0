From: Joe Thornber <thornber@redhat.com>
Subject: Re: Severe performance degradation for dm-cache mq since
	c86c3070
Date: Fri, 18 Sep 2015 16:30:16 +0100
Message-ID: <20150918153015.GA5045@rh-vpn>
References: <CABYiri_eRp7wzhTXCmDm4HUB3ZMsPUZxsS65-29c5o+RoWOX6w@mail.gmail.com>
	<CABYiri_=f=kh9b_OJz_NBeXC5uUt=y=CTJEkR2Uo5zn-vakVQQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CABYiri_=f=kh9b_OJz_NBeXC5uUt=y=CTJEkR2Uo5zn-vakVQQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrey Korolyov <andrey@xdel.ru>
Cc: heinzm@redhat.com, ejt@redhat.com, dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On Fri, Sep 11, 2015 at 11:32:38PM +0300, Andrey Korolyov wrote:
> Please take a look on an
> attached results - at a given cache size smq outperforms all other
> algorithms but both new mq and smq performs poorly when cache fills up
> and issuing demotions.

Having looked at your results again I think there are two issues here:

i) You're expecting dm-cache to be a writeback cache that streams
_all_ writes to the SSD, and then updates the spindle in the
background.  It's not, it's a slow moving cache that promotes specific
regions of the spindle to the SSD.

ii) You're doing random, small, sync IO.  Which evenly hits all areas.
In this case the cache has a really hard time improving over the
performance of the spindle.  In your tests I think you have around 6G
of SSD and 48G of active data.  So only 1 in 8 IOs are going to hit the
SSD; any benefits will be marginal.  You use the same SSD size when
running with an 8G work load, so nearly every IO hits the SSD.  Hence
better performance.

Does this benchmark really reflect your use case?

- Joe
