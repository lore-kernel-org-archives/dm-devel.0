From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: device-mapper: fix TB stripe data corruption
Date: Thu, 27 Jan 2005 18:06:44 -0600
Message-ID: <200501271806.44988.kevcorry@us.ibm.com>
References: <41F6A093.1020606@meditprofi.ru>
	<200501251448.31769.kevcorry@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200501251448.31769.kevcorry@us.ibm.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, Dmitry Yurtaev <yurtaev@meditprofi.ru>
Cc: DevMapper <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tuesday 25 January 2005 2:48 pm, Kevin Corry wrote:
> On Tuesday 25 January 2005 1:40 pm, Dmitry Yurtaev wrote:
> > i'm sorry for mailing you directly. i was trying to get lvm2 working
> > with 2 striped 1.8T volumes and came across your patch in the lklm. but
> > it didn't help. after some digging i've found few suspicious functions
> > in dm.h, especially this one:
> >
> > --- file: drivers/md/dm.h
> > static inline unsigned long dm_round_up(unsigned long n, unsigned long
> > size) {
> >          unsigned long r = n % size;
> >          return n + (r ? (size - r) : 0);
> > }
> >
> > it is called from drivers/md/dm.c:max_io_len() with two arguments of
> > sector_t type... i've made an ugly fix:
> >
> > static inline sector_t dm_round_up(sector_t n, unsigned long size)
> > {
> >          sector_t q = n;
> >          sector_t r = sector_div(q, size);
> >          return n + (r ? (size - r) : 0);
> > }
> >
> > and that plus your patch eliminated my problem with data corruption.
> >
> > it would be nice if someone knowlegeable will audit dm.[hc]... also it
> > looks to me like there're few places in dm-stripe.c which assume that a
> > stripe size is <2T...
>
> Here's a patch to implement the above change that you suggested. Thanks for
> the feedback!

Here's a corrected version of the dm.h patch from Tuesday. The previous 
version was missing another sector_div() in dm_div_up(). When I compiled it 
the first time, I had DM built as modules, and it all seemed to build 
correctly. Today I switched DM back to statically built and then noticed a 
compile error.

-- 
Kevin Corry
kevcorry@us.ibm.com
http://evms.sourceforge.net/



Make dm_round_up() and dm_div_up() 64-bit safe.

--- diff/drivers/md/dm.h 2005-01-27 18:00:17.918379224 -0600
+++ source/drivers/md/dm.h 2005-01-27 18:00:37.034473136 -0600
@@ -145,18 +145,21 @@
 /*
  * ceiling(n / size) * size
  */
-static inline unsigned long dm_round_up(unsigned long n, unsigned long size)
+static inline sector_t dm_round_up(sector_t n, unsigned long size)
 {
- unsigned long r = n % size;
+ sector_t q = n;
+ sector_t r = sector_div(q, size);
  return n + (r ? (size - r) : 0);
 }
 
 /*
  * Ceiling(n / size)
  */
-static inline unsigned long dm_div_up(unsigned long n, unsigned long size)
+static inline sector_t dm_div_up(sector_t n, unsigned long size)
 {
- return dm_round_up(n, size) / size;
+ sector_t r = dm_round_up(n, size);
+ sector_div(r, size);
+ return r;
 }
 
 static inline sector_t to_sector(unsigned long n)

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
