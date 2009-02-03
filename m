From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: shared snapshots
Date: Tue, 3 Feb 2009 15:48:13 +0900
Message-ID: <20090203154804V.fujita.tomonori@lab.ntt.co.jp>
References: <Pine.LNX.4.64.0902030118280.16888@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0902030118280.16888@hs20-bc2-1.build.redhat.com>
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

On Tue, 3 Feb 2009 01:25:30 -0500 (EST)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> If you are going to put shared storage into your snapshots, look at this: 
> http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/devel/
> 
> --- this is my snapshot store with Fujita/Daniel's store as a loadable 
> module.
> 
> So if you are going to do shared storage interface, you must accommodate 
> both of these implementations into it.
> 
> I still don't understand, how do you intend to patch it on the top of 
> existing snapshot code. Definitely, I wouldn't say that it will be an easy 
> task. Look at the code and have a fun with it.

I expect that we will support the shared implementation(s) on the top
of the existing snapshot code instead of inventing a new target_type
(as Mikulas do with multisnap_*).

If not, we can live without refactoring the existing snapshot code.

But surely supporting the shared implementation(s) on the top of the
existing snapshot code needs more refactoring. Jonathan, have you
already started to work on it?
