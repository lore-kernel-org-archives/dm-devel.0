From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [BUG] linux-next: 20081209 - kernel bug at __rcu_process_callbacks, while booting up
Date: Tue, 16 Dec 2008 15:37:21 +0100
Message-ID: <20081216143721.GT32491@kernel.dk>
References: <20081209185237.8bb715d7.sfr@canb.auug.org.au> <20081210115721.GB6107@linux.vnet.ibm.com> <20081210145414.GA6945@linux.vnet.ibm.com> <20081210163007.GA6391@linux.vnet.ibm.com> <20081210175338.GB6745@linux.vnet.ibm.com> <20081210180936.GD6391@linux.vnet.ibm.com> <20081210183302.GD6745@linux.vnet.ibm.com> <20081212194026.GA5455@linux.vnet.ibm.com> <20081212221611.GG6950@linux.vnet.ibm.com> <20081216143001.GA4365@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081216143001.GA4365@linux.vnet.ibm.com>
Sender: linux-next-owner@vger.kernel.org
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, tglx@linutronix.de, mel@csn.ul.ie
List-Id: dm-devel.ids

On Tue, Dec 16 2008, Kamalesh Babulal wrote:
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> [2008-12-12 14:16:11]:
> 
> > On Sat, Dec 13, 2008 at 01:10:26AM +0530, Kamalesh Babulal wrote:
> > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> [2008-12-10 10:33:02]:
> > > 
> > > > On Wed, Dec 10, 2008 at 11:39:36PM +0530, Kamalesh Babulal wrote:
> > > > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> [2008-12-10 09:53:38]:
> > > > > 
> > > > > > On Wed, Dec 10, 2008 at 10:00:07PM +0530, Kamalesh Babulal wrote:
> > > > > > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> [2008-12-10 06:54:14]:
> > > > > > > 
> > > > > > > > On Wed, Dec 10, 2008 at 05:27:21PM +0530, Kamalesh Babulal wrote:
> > > > > > > > > Hi,
> > > > > > > > > 
> > > > > > > > > 	Kernel bug is hit while booting up the next-20081208/09 kernels over
> > > > > > > > > the x86_64 box. The IP is pointing to 0x0 and its stuck at
> > > > > > > > > __rcu_process_callbacks.
> > > > > > > > 
> > > > > > > > Kernel config?
> > > > > > > > 
> > > > > > > > 							Thanx, Paul
> > > > > > > > 
> > > > > > > Hi Paul,
> > > > > > > 
> > > > > > > 	I have attached the kernel config file.
> > > > > > 
> > > > > > Hello, Kamalesh,
> > > > > > 
> > > > > > No significant recent changes in this area.  Is this consistent?
> > > > > > Any chance of "git bisect"?
> > > > > > 
> > > > > > 							Thanx, Paul
> > > > > > 
> > > > > Hi Paul,
> > > > > 
> > > > > 	I tried reproducing it for three times and I was successfull in reproducing it thrice.
> > > > > I have already started the git bisect, will update the results soon.
> > > > 
> > > > Very good, looking forward to seeing the result!
> > > > 
> > > > 							Thanx, Paul
> > > > 
> > > Hi Paul,
> > > 
> > > 	After a Complete round of git bisect, I was not able to reproduce the oops,
> > > but when I tried again with complete next-20081209 patch, I am getting
> > > different warning message altogether this time
> > 
> > Might be that the two oopses are different manifestations of the same
> > underlying problem, right?
> > 
> > 							Thanx, Paul
> > 
> Hi Paul,
> 
> 	Your were right, those were the manifestation of the same
> 	problem. Adding to it another calltrace was commonly visible
> 	during the git-bisect.

Did you try with a newer version? Should be fixed since last week.

-- 
Jens Axboe
