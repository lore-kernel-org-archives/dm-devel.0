From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [RFC] How to fix system stall on root volume multipath
Date: Thu, 20 Dec 2007 13:10:39 -0500 (EST)
Message-ID: <20071220.131039.41628927.k-ueda@ct.jp.nec.com>
References: <1194915684.6724.66.camel@localhost.localdomain>
	<1195202472.27535.27.camel@localhost.localdomain>
	<1195431462.27535.43.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1195431462.27535.43.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Christophe,

On Mon, 19 Nov 2007 01:17:41 +0100, Christophe Varoqui wrote:
> > > So I propose to start playing with your prioritizers-as-lib idea to see
> > > if it's practical.
> > > 
> > > I prepared the following patch to that effect. It is not complete
> > > (actually segfaults, no useful prioritizer ported) but can start fixing
> > > bugs and go where ever your personnal interest leads.
> >
> > I'm sorry I forgot to post the git-cached part of the changeset, i.e.
> > libprio/ files.
> > 
> > There it goes.
> 
> Upstream git hosts the initial libprio/ commit.
> 
> I ported all useful prioritizers, leaving balance_units in the dark.
> (If someone is actually using it, please say so)
> 
> This time, I cared for a bit of testing and the stuff seems to actually
> work.
> 
> Now I'm interested in feedback from the Netapp fault injection team.
> And any other feedback.

Thank you for the libprio coding.  And I'm sorry for my late reply.

I checked the commit and found a bug during my small testing.
I'll send a patch to fix it by another email.


I would like to note that we lost the priority callout feature
completely to fix the stall problem of root multipath.

Although below is just my humble opinion, I guess it was useful
for people who want to use new prioritizers on official distro's
environments until an update package including the prioritizer
is released.
So if such a case often happens, adding other ways to use external
prioritizers (perhaps dynamic loading library module like LVM2)
would be required in the near future.

Thanks,
Kiyoshi Ueda
