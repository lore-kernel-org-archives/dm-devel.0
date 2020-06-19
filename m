From: Bryan Gurney <bgurney@redhat.com>
Subject: Re: [PATCH v3 1/4] dm dust: report some message results
	back to user directly
Date: Fri, 19 Jun 2020 13:43:45 -0400
Message-ID: <CAHhmqcTJgDPBg8YOtrxtJW1ONkz8pz=nqZa-EXM84=dcQ165Fg@mail.gmail.com>
References: <20200619123803.1441373-1-yangerkun@huawei.com>
	<20200619123803.1441373-2-yangerkun@huawei.com>
	<CAHhmqcTdxeTrpBuJBLqch9FzYuv=k+73fOjStsd-NmoDRyFffQ@mail.gmail.com>
	<20200619154445.GA24500@redhat.com>
	<CAHhmqcSB_bd8dO75pQny=MxNxd1=3mpHDCtX_faiO2VUFx616w@mail.gmail.com>
	<20200619172947.GA24951@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200619172947.GA24951@redhat.com>
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
Cc: yangerkun <yangerkun@huawei.com>, dm-devel@redhat.com, bmr@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Jun 19, 2020 at 1:29 PM Mike Snitzer <snitzer@redhat.com> wrote:
>
> On Fri, Jun 19 2020 at  1:23pm -0400,
> Bryan Gurney <bgurney@redhat.com> wrote:
>
> > On Fri, Jun 19, 2020 at 11:45 AM Mike Snitzer <snitzer@redhat.com> wrote:
> > >
> > > On Fri, Jun 19 2020 at 11:40am -0400,
> > > Bryan Gurney <bgurney@redhat.com> wrote:
> > >
> > > > On Fri, Jun 19, 2020 at 8:37 AM yangerkun <yangerkun@huawei.com> wrote:
> > > > >
> > > > > Some type of message(queryblock/countbadblocks/removebadblock) may better
> > > > > report results to user directly. Do it with DMEMIT.
> > > > >
> > > > > Signed-off-by: yangerkun <yangerkun@huawei.com>
> > > > > ---
> > > > >  drivers/md/dm-dust.c | 31 ++++++++++++++++++-------------
> > > > >  1 file changed, 18 insertions(+), 13 deletions(-)
> > > > >
> > > > > diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
> > > > > index ff03b90072c5..a0c75c104de0 100644
> > > > > --- a/drivers/md/dm-dust.c
> > > > > +++ b/drivers/md/dm-dust.c
> > > > > @@ -138,20 +138,22 @@ static int dust_add_block(struct dust_device *dd, unsigned long long block,
> > > > >         return 0;
> > > > >  }
> > > > >
> > > > > -static int dust_query_block(struct dust_device *dd, unsigned long long block)
> > > > > +static int dust_query_block(struct dust_device *dd, unsigned long long block, char *result,
> > > > > +                           unsigned int maxlen, unsigned int *sz_ptr)
> > > > >  {
> > > > >         struct badblock *bblock;
> > > > >         unsigned long flags;
> > > > > +       unsigned int sz = *sz_ptr;
> > > > >
> > > > >         spin_lock_irqsave(&dd->dust_lock, flags);
> > > > >         bblock = dust_rb_search(&dd->badblocklist, block);
> > > > >         if (bblock != NULL)
> > > > > -               DMINFO("%s: block %llu found in badblocklist", __func__, block);
> > > > > +               DMEMIT("block %llu found in badblocklist", block);
> > > > >         else
> > > > > -               DMINFO("%s: block %llu not found in badblocklist", __func__, block);
> > > > > +               DMEMIT("block %llu not found in badblocklist", block);
> > > > >         spin_unlock_irqrestore(&dd->dust_lock, flags);
> > > > >
> > > > > -       return 0;
> > > > > +       return 1;
> > > >
> > > > First, thank you very much for this patch.  After the concerns to
> > > > convert some functions to use DMEMIT were brought up, I was trying to
> > > > start the conversion, when this patch arrived, so I installed it, and
> > > > tested it.
> > > >
> > > > I do have a question, though:
> > > >
> > > > First, I see that in dust_query_block() (above) and
> > > > dust_clear_badblocks(), the "return 0" statement is changed to "return
> > > > 1".
> > > >
> > > > (Additionally, there is a change from "r = 0" to  "r = 1", in the
> > > > "countbadblocks" message handler)
> > > >
> > > > On testing the functions, they still work, but why was this change
> > > > made?  Is it related to the use of DMEMIT?
> > >
> > > It is, but we need to review the returns closer.  Looked to me that 1
> > > was being returned even if nothing was DMEMIT()'d.. but I could be wrong
> > > (only looked quickly).
> > >
> > > I also noticed that some output was changed to not include __func__.
> > > Please review that the output reflects what you'd like displayed.
> > >
> > > Mike
> > >
> >
> > After adding __func__ back into the string, here's what it looks like:
> >
> > $ sudo dmsetup message dust1 0 addbadblock 60
> > $ sudo dmsetup message dust1 0 queryblock 60
> > dust_query_block: block 60 found in badblocklist
> > $ sudo dmsetup message dust1 0 queryblock 61
> > dust_query_block: block 61 not found in badblocklist
> >
> > I feel that the output's origin is more clear, so I'd like to leave
> > __func__ in the output.
> >
> > I took a look at the DMEMIT calls, and in all three cases, it looks
> > like there's something DMEMIT()'d:
> >
> > dust_query_block: either "block found", or "block not found".
> > dust_clear_badblocks: either "no badblocks found", or "badblocks cleared".
> > result of "message ... countbadblocks": always prints "%llu badblocks found".
>
> OK, can you provide an incremental patch that restores the __func__
> where you'd like?  I can deal with it, but I'll be slower to do so.
>
> Mike
>

Yes, I just sent the patch to dm-devel.


Thanks,

Bryan
