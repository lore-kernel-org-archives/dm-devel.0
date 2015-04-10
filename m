From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm crypt: fix deadlock when algo returns
	-EBUSY
Date: Fri, 10 Apr 2015 15:52:23 -0400
Message-ID: <20150410195223.GA17880@redhat.com>
References: <1428077387-2292-1-git-send-email-ben.c@servergy.com>
	<20150407155501.GA29040@redhat.com>
	<20150407162842.GA54137@redhat.com>
	<BA6189A5-1C3D-4A43-B494-D6FEC7200E7D@servergy.com>
	<20150410151113.GA16795@redhat.com>
	<CCE29825-C051-4612-86DD-1CA7A5CF095F@servergy.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CCE29825-C051-4612-86DD-1CA7A5CF095F@servergy.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ben Collins <ben.c@servergy.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Apr 10 2015 at  1:56pm -0400,
Ben Collins <ben.c@servergy.com> wrote:

> 
> > On Apr 10, 2015, at 11:11 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> > 
> > On Tue, Apr 07 2015 at  1:10pm -0400,
> > Ben Collins <ben.c@servergy.com> wrote:
> > 
> >> 
> >>> On Apr 7, 2015, at 11:28 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> >>> 
> >>> On Tue, Apr 07 2015 at 11:55P -0400,
> >>> Mike Snitzer <snitzer@redhat.com> wrote:
> >>> 
> >>>> It looks like you're _always_ using the completion regardless of whether
> >>>> crypt_convert() will be waiting (e.g. even if error is 0).
> >>>> 
> >>>> I can see this "working" but it seems less than ideal.  Would it be
> >>>> better to record the need to use the completion in ctx and then
> >>>> conditionally call complete()?
> >>> 
> >>> Actually, how about using !completion_done() before calling complete()?
> >>> If you think this would be OK, any chance you could re-test with this?
> >> 
> >> I'll be able to test it before Friday (out of town). Thanks
> > 
> > Hi Ben,
> > 
> > I'm still waiting for test feedback from you on v2.  Fairly certain
> > you'll have the same results but I'd like to be certain before pushing
> > this upstream.
> 
> As expected, this patch works as well as what I had originally done.
> Thanks for reviewing it.

OK, thanks.  I've staged the change in linux-next, with a slightly
revised header, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=223c1aa8360a386
