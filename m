From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 2 Oct 2009 11:31:17 -0400
Message-ID: <20091002153117.GB4494@redhat.com>
References: <200910021255.27689.czoccolo@gmail.com>
	<20091002124921.GA4494@redhat.com>
	<4e5e476b0910020827s23e827b1n847c64e355999d4a@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4e5e476b0910020827s23e827b1n847c64e355999d4a@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, Jens Axboe <jens.axboe@oracle.com>, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Ingo Molnar <mingo@elte.hu>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, containers@lists.linux-foundation.org, Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Fri, Oct 02, 2009 at 05:27:55PM +0200, Corrado Zoccolo wrote:
> On Fri, Oct 2, 2009 at 2:49 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Fri, Oct 02, 2009 at 12:55:25PM +0200, Corrado Zoccolo wrote:
> >
> > Actually I am not touching this code. Looking at the V10, I have not
> > changed anything here in idling code.
> 
> I based my analisys on the original patch:
> http://lkml.indiana.edu/hypermail/linux/kernel/0907.1/01793.html
> 

Oh.., you are talking about fairness for seeky process patch. I thought
you are talking about current IO controller patches. Actually they both
have this notion of "fairness=1" parameter but do different things in 
patches, hence the confusion. 

Thanks
Vivek


> Mike, can you confirm which version of the fairness patch did you use
> in your tests?
> 
> Corrado
> 
> > Thanks
> > Vivek
> >
