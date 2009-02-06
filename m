From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: shared snapshots
Date: Thu, 5 Feb 2009 22:44:33 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902052230570.5380@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0902030118280.16888@hs20-bc2-1.build.redhat.com>
	<20090203154804V.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090203154804V.fujita.tomonori@lab.ntt.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids



On Tue, 3 Feb 2009, FUJITA Tomonori wrote:

> On Tue, 3 Feb 2009 01:25:30 -0500 (EST)
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > If you are going to put shared storage into your snapshots, look at this: 
> > http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/devel/
> > 
> > --- this is my snapshot store with Fujita/Daniel's store as a loadable 
> > module.
> > 
> > So if you are going to do shared storage interface, you must accommodate 
> > both of these implementations into it.
> > 
> > I still don't understand, how do you intend to patch it on the top of 
> > existing snapshot code. Definitely, I wouldn't say that it will be an easy 
> > task. Look at the code and have a fun with it.
> 
> I expect that we will support the shared implementation(s) on the top
> of the existing snapshot code instead of inventing a new target_type
> (as Mikulas do with multisnap_*).

Alasdair is wanting to make it on the top of existing snapshots but I 
haven't heard from him any specific argument, just generalized talks how 
sharing code is good.

So, please start saying some specific nongeneralized ideas how do you 
imagine to do it.

I.e. instead od saying "sharing code is good", download stuff from 
http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/devel/ and 
say *EXACTLY* which code (structures, functions...) you you want to share 
with existing snapshots.

Instead of saying "we treat all snapshots like objects with method tables" 
look at actual method tables from in-kernel snapshots and my snapshots and 
say *WHICH* methods exactly are you going to join.

--- then, we can discuss it and go somewhere. Abstract ideas about 
software engineering make no sense at this stage.

> If not, we can live without refactoring the existing snapshot code.
> 
> But surely supporting the shared implementation(s) on the top of the
> existing snapshot code needs more refactoring. Jonathan, have you
> already started to work on it?
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

Mikulas
