From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: dm log writes: make sure the log super sectors are
 written in order
Date: Mon, 3 Jun 2019 15:02:45 -0400
Message-ID: <20190603190243.zqbfsgz22k3wghby@MacBook-Pro-91.local>
References: <1559571534-16467-1-git-send-email-yi.zhang@huawei.com>
	<20190603144608.GA22116@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190603144608.GA22116@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Josef Bacik <jbacik@fb.com>, dm-devel@redhat.com, houtao1@huawei.com, agk@redhat.com, "zhangyi (F)" <yi.zhang@huawei.com>
List-Id: dm-devel.ids

On Mon, Jun 03, 2019 at 10:46:08AM -0400, Mike Snitzer wrote:
> On Mon, Jun 03 2019 at 10:18am -0400,
> zhangyi (F) <yi.zhang@huawei.com> wrote:
> 
> > Currently, although we submit super bios in log-write thread orderly
> > (the super.nr_entries is incremented by each logged entry), the
> > submit_bio() cannot make sure that each super sector is written to log
> > device in order. So the submitting bio of each super sector may be
> > out-of-order, and then the final nr_entries maybe small than the real
> > entries submitted.
> > 
> > This problem can be reproduced by the xfstests generic/455 with ext4,
> > which may complained below after running the test:
> > 
> >   QA output created by 455
> >  -Silence is golden
> >  +mark 'end' does not exist
> > 
> > This patch serialize submitting super secotrs to make sure each super
> > sectors are written to log disk in order.
> > 
> > Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> 
> This doesn't feel right.
> 
> You raised 2 things you're trying to address:
> 1) IO is out of order
> 2) accounting (nr_entries) isn't correct
> 
> I'll need to reviewer closer but serializing "super" bios doesn't seem
> like the best fix.
> 
> Josef, any chance you can weigh in on this?  AFAIK you are still "the
> man" for dm-log-writes ;)
> 

Well the #2 is caused by #1, we submit the bio for a super two times in a row
and it's a crapshoot which one makes it to disk.  So he's right, and it's kind
of funny because this is the sort of problem that dm-log-writes was written to
catch, and I fucked it up here ;).  That being said this is a bit
over-engineered, can we just add a completion to the log buff and do a
wait_for_completion() when we're writing out the super?  It's not like this thing
needs to be super performant.  Thanks,

Josef
