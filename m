From: Andrey Korolyov <andrey@xdel.ru>
Subject: Re: Severe performance degradation for dm-cache mq since
	c86c3070
Date: Sun, 13 Sep 2015 01:15:06 +0300
Message-ID: <CABYiri9aUyiqOsY4=PcksTF1Q+OhaEbJ3dUHHGFqPJVsCMaEqw@mail.gmail.com>
References: <CABYiri_eRp7wzhTXCmDm4HUB3ZMsPUZxsS65-29c5o+RoWOX6w@mail.gmail.com>
	<CABYiri_=f=kh9b_OJz_NBeXC5uUt=y=CTJEkR2Uo5zn-vakVQQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: thornber@redhat.com
Cc: heinzm@redhat.com, ejt@redhat.com, dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On Fri, Sep 11, 2015 at 11:32 PM, Andrey Korolyov <andrey@xdel.ru> wrote:
>> This was running a smaller test than you with only 2G per thread.
>
>> Have you tried playing with the migration_threshold tunable?  With
>> random IO such as this we really want the cache to initially populate
>> the cache but then do no churning.  Could you give me the status line
>> for the caches once you've run the tests please?  This would tell me
>> how many blocks are being demoted.
>
> Please CC me always, as I am not subscribed to dm-devel.
>
> Short-runs are tend to show better results on smq, but real-world
> applications have at most long-running workloads with sustained cache
> usage pattern where old algorithm shows a best result. I`ll give a try
> for tunables and post results separately. Please take a look on an
> attached results - at a given cache size smq outperforms all other
> algorithms but both new mq and smq performs poorly when cache fills up
> and issuing demotions. Status outputs are given right after test
> completion. Hardware platform was changed for test, so absolute values
> can differ from ones in original message.
>
> The r/w ratio, block size and random pattern are selected to represent
> a typical SDS workload on top of the cache, but, as I pointed earlier,
> it is a quite inaccurate simulation - the hit curve is impossible to
> reproduce with fio.

Replying to myself back - migration_threshold increase does not make
situation better, when reduction results in a worse situation than
with default value. As far as I can see 'new' mq suffers from the
immediate processing of the promoted blocks on update when 'old' one
delays their processing (not in a very good manner, though, because a
large plateau of the blocks which has every right to be demoted
remains in this case in front cache).
