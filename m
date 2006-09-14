From: "kevin Cheng" <kevin_cheng@thecus.com>
Subject: RE: [Bugme-new] [Bug 7158] New: Out of memory happen in
	snapshot
Date: Thu, 14 Sep 2006 14:44:53 +0800
Message-ID: <200609140644.k8E6iib1026888@mail.thecus.com>
References: <20060913223638.fcb73078.akpm@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060913223638.fcb73078.akpm@osdl.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'Andrew Morton' <akpm@osdl.org>
Cc: dm-devel@redhat.com, agk@redhat.com, "'bugme-daemon@kernel-bugs.osdl.org'" <bugme-daemon@bugzilla.kernel.org>
List-Id: dm-devel.ids

I have check before and after OOM-killer slabinfo 
There have some object have high counts. 
And dm-snapshot-ex always have high counts. Have any explain about those
value?


Kevin Cheng
----------------------------------------------------------------------------
-------------------------------------------------
Before: kcopyd-jobs          512    525    264   15    1 : tunables   54
27    0 : slabdata     35     35      0
After : kcopyd-jobs        16524  62685    264   15    1 : tunables   54
27    0 : slabdata   4179   4179      0

Before: dm-snapshot-in       128    177     64   59    1 : tunables  120
60    0 : slabdata      3      3      0
After : dm-snapshot-in     24833  73219     64   59    1 : tunables  120
60    0 : slabdata   1241   1241      0

Before: dm-snapshot-ex    780545 780680     24  145    1 : tunables  120
60    0 : slabdata   5384   5384      0

Before: dm_tio              5124   5278     16  203    1 : tunables  120
60    0 : slabdata     26     26      0
Before: dm_io               5133   5239     20  169    1 : tunables  120
60    0 : slabdata     31     31      0
After : dm_tio             23337  32277     16  203    1 : tunables  120
60    0 : slabdata    159    159      0
After : dm_io              23339  32448     20  169    1 : tunables  120
60    0 : slabdata    192    192      0

Before: journal_head           2     72     52   72    1 : tunables  120
60    0 : slabdata      1      1      0
After : journal_head       23029  25272     52   72    1 : tunables  120
60    0 : slabdata    351    351      0

Before: biovec-4              39     59     64   59    1 : tunables  120
60    0 : slabdata      1      1      0
Before: biovec-1              76    406     16  203    1 : tunables  120
60    0 : slabdata      2      2      0
Before: bio                  330    330    128   30    1 : tunables  120
60    0 : slabdata     11     11      0
After : biovec-4            2815   3717     64   59    1 : tunables  120
60    0 : slabdata     63     63      0
After : biovec-1           33507  47096     16  203    1 : tunables  120
60    0 : slabdata    232    232      0
After : bio                36390  50130    128   30    1 : tunables  120
60    0 : slabdata   1671   1671      0

Before: buffer_head        16360  16416     52   72    1 : tunables  120
60    0 : slabdata    228    228      0
After : buffer_head        24234  36000     52   72    1 : tunables  120
60    0 : slabdata    500    500      0

 

-----Original Message-----
From: Andrew Morton [mailto:akpm@osdl.org] 
Sent: Thursday, September 14, 2006 1:37 PM
To: kevin Cheng
Cc: 'bugme-daemon@kernel-bugs.osdl.org'; dm-devel@redhat.com; agk@redhat.com
Subject: Re: [Bugme-new] [Bug 7158] New: Out of memory happen in snapshot

On Thu, 14 Sep 2006 13:25:52 +0800
"kevin Cheng" <kevin_cheng@thecus.com> wrote:

> Dear Andrew:
>    Thanks for your message and help. 
> 
> Attech file is the slabinfo from my machine. Thanks!!
> 

OK, thanks.  A number of DM-related slab caches have really high object
counts.  So there's a good chance that this is either a mistuning/imbalance
issue in DM or an outright leak.

I'd ask the DM developers to take over here please.
