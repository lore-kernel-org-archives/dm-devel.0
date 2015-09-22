From: Andrey Korolyov <andrey@xdel.ru>
Subject: Re: Severe performance degradation for dm-cache mq since
	c86c3070
Date: Tue, 22 Sep 2015 14:24:59 +0300
Message-ID: <CABYiri8+k9HQRG5twPtJhxGPrP95YQqJ=nh_wgyeQ0yxLjbqsA@mail.gmail.com>
References: <CABYiri_eRp7wzhTXCmDm4HUB3ZMsPUZxsS65-29c5o+RoWOX6w@mail.gmail.com>
	<CABYiri_=f=kh9b_OJz_NBeXC5uUt=y=CTJEkR2Uo5zn-vakVQQ@mail.gmail.com>
	<20150918153015.GA5045@rh-vpn>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150918153015.GA5045@rh-vpn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrey Korolyov <andrey@xdel.ru>, snitzer@redhat.com, ejt@redhat.com, heinzm@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Sep 18, 2015 at 6:30 PM, Joe Thornber <thornber@redhat.com> wrote:
> On Fri, Sep 11, 2015 at 11:32:38PM +0300, Andrey Korolyov wrote:
>> Please take a look on an
>> attached results - at a given cache size smq outperforms all other
>> algorithms but both new mq and smq performs poorly when cache fills up
>> and issuing demotions.
>
> Having looked at your results again I think there are two issues here:
>
> i) You're expecting dm-cache to be a writeback cache that streams
> _all_ writes to the SSD, and then updates the spindle in the
> background.  It's not, it's a slow moving cache that promotes specific
> regions of the spindle to the SSD.
>
> ii) You're doing random, small, sync IO.  Which evenly hits all areas.
> In this case the cache has a really hard time improving over the
> performance of the spindle.  In your tests I think you have around 6G
> of SSD and 48G of active data.  So only 1 in 8 IOs are going to hit the
> SSD; any benefits will be marginal.  You use the same SSD size when
> running with an 8G work load, so nearly every IO hits the SSD.  Hence
> better performance.
>
> Does this benchmark really reflect your use case?

Not really, I tried to reproduce worst possible case for writeback
cache. The main problem for fine representation of the production SDS
workload is a lack of hot read/write spots and apparent lack in
pattern differences - writes tends to be sequential and group over
several spots at most and reads are mostly scattered. Despite
relatively small difference b/w 3.10 and 3.18 policy in fio test above
the real-world workload with described r/w patterns differs more
heavily, but I`m afraid that nobody from the list would want to set up
a Ceph/Gluster cluster to put a couple of VMs on to to reproduce that.

For a random worst-case randrw I assume that the current SMQ *could*
be outperformed by modified version which delays block eviction in a
same manner as it was in 3.10. If I miss a case where delayed eviction
would perform worse, please point me at those.
