From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 00/14] multipath-tools series: some cleanups
 and fixes checked by codedex tool
Date: Fri, 04 Sep 2020 23:28:21 +0200
Message-ID: <2e64d235b13042a015c7d1df63f6fd8222c85182.camel@suse.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
	<73d14f51e1ca6aeb8dbd40f5a22c21508b6d4401.camel@suse.com>
	<20200904200032.GB11108@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200904200032.GB11108@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: lixiaokeng <lixiaokeng@huawei.com>, dm-devel mailing list <dm-devel@redhat.com>, linfeilong <linfeilong@huawei.com>, "liuzhiqiang
	(I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Fri, 2020-09-04 at 15:00 -0500, Benjamin Marzinski wrote:
> On Thu, Sep 03, 2020 at 10:08:53PM +0200, Martin Wilck wrote:
> > Hello Lixiaokeng,
> > 
> > On Wed, 2020-09-02 at 14:40 +0800, lixiaokeng wrote:
> > > Hi:
> > >     Now, we check multipath-tools codes with codedex tool. Here
> > > are some some cleanups and fixes.
> > 
> > Thank you. However I'm going to nack all patches that add error
> > messages after unsuccesful memory allocations. Such messages are
> > unhelpful most of the time, and increase the code size without a
> > true
> > benefit. I've actually considered to get rid of all these, and
> > replace
> > them by a log_oom() macro.
> 
> O.k. This answers my question from patch 0005. I'm fine with this.

Great, thanks.

> As a side note: man, those are some ugly preprocessor hoops you need
> to
> jump through to stringify __LINE__.

Yeah, it took me some attempts to get it right. 
It's actually documented:
https://gcc.gnu.org/onlinedocs/gcc-4.8.5/cpp/Stringification.html

Thanks,
Martin
