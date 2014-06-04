From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: disable WRITE SAME if it fails
Date: Tue, 3 Jun 2014 20:06:09 -0400
Message-ID: <20140604000609.GA10208@redhat.com>
References: <53042F91.4050201@huawei.com> <53899812.50403@huawei.com>
	<20140531150517.GJ29705@agk-dp.fab.redhat.com>
	<20140602183635.GA1396@redhat.com>
	<20140603165859.GA8091@redhat.com>
	<yq1fvjl38h7.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1fvjl38h7.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Milan Broz <asi@seznam.cz>, Mike Anderson <andmike@linux.vnet.ibm.com>, christophe varoqui <christophe.varoqui@free.fr>, alex chen <alex.chen@huawei.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Joseph Qi <joseph.qi@huawei.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Jun 03 2014 at  6:59pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> >> > Shouldn't this code be taken out of mpath and moved to dm.c and
> >> > applied to all targets (both bio and rq-based, at least where WRITE
> >> > SAME is supported)?
> 
> Mike> FYI, I pushed a revised version of this patch to linux-next,
> 
> I haven't tested the patch but I definitely agree with this approach.
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

Thanks, added.
