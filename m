From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: disable WRITE SAME if it fails
Date: Wed, 4 Jun 2014 09:52:14 -0400
Message-ID: <20140604135214.GB14235@redhat.com>
References: <53042F91.4050201@huawei.com> <53899812.50403@huawei.com>
	<20140531150517.GJ29705@agk-dp.fab.redhat.com>
	<20140602183635.GA1396@redhat.com> <538E9AAC.3020104@huawei.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <538E9AAC.3020104@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: alex chen <alex.chen@huawei.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Milan Broz <asi@seznam.cz>, Mike Anderson <andmike@linux.vnet.ibm.com>, christophe varoqui <christophe.varoqui@free.fr>, dm-devel@redhat.com, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Joseph Qi <joseph.qi@huawei.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Jun 04 2014 at 12:03am -0400,
alex chen <alex.chen@huawei.com> wrote:

> On 2014/6/3 2:36, Mike Snitzer wrote:
> > On Sat, May 31 2014 at 11:05am -0400,
> > Alasdair G Kergon <agk@redhat.com> wrote:
> > 
> >> On Sat, May 31, 2014 at 04:51:30PM +0800, alex chen wrote:
> >>> The original commit f84cb8a46a771f36a04a02c61ea635c968ed5f6a("dm mpath:
> >>> disable WRITE SAME if it fails") disables WRITE SAME in the DM multipath
> >>> device if it fails, but when the DM linear device stacks ontop of the
> >>> multipath device it doesn't help.
> >>> this patch adds DM linear end_io method to catch WRITE SAME errors and
> >>> disables WRITE SAME in the DM linear device's queue_limits if an
> >>> underlying device disables it.
> >>
> >> How does your patch address striped targets?
> >>  
> >> Shouldn't this code be taken out of mpath and moved to dm.c and applied to all
> >> targets (both bio and rq-based, at least where WRITE SAME is supported)?
> > 
> > Alex,
> > 
> > I've implemented what Alasdair and I have been suggesting.
> > Can you please test this untested patch?
> > 
> > Thanks,
> > Mike
> > 
> 
> I tested this patch, it is OK.
> Test cases is as follow:
> CASE 1:
> dm linear device(dm-23): ocfs2-fs;
> multipath device(dm-9);
> scsi device(sdr,sdv);
> 
> After WRITE SAME IO fails:
> linux-MOLybD:~ # cat /sys/block/dm-23/queue/write_same_max_bytes
> 0
> linux-MOLybD:~ # cat /sys/block/dm-9/queue/write_same_max_bytes
> 0
> linux-MOLybD:~ # cat /sys/block/sdr/queue/write_same_max_bytes
> 0
> linux-MOLybD:~ # cat /sys/block/sdv/queue/write_same_max_bytes
> 0
> 
> Result: pass
> 
> Tested-by: Alex Chen <alex.chen@huawei.com>

OK, thanks.. FYI, as I sahred before: I updated it slightly to check for
the specific -EREMOTEIO error code that SCSI returns for this case, see:

https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=7eee4ae2dbb2be0a15a4406718806e48b18ba831
