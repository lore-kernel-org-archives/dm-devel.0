From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: staged dm_internal_{suspend,
 resume} related changes for wider review
Date: Fri, 2 Jan 2015 17:56:44 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1501021741470.23294@file01.intranet.prod.int.rdu2.redhat.com>
References: <20141029012256.GF29288@redhat.com>
	<alpine.LRH.2.02.1411031823100.29299@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMM=eLd8iuMDtNr7f4Cu97ZEua3-pOW4pdSdVKji7g02mKXFwQ@mail.gmail.com>
	<20141105011619.GA11411@redhat.com>
	<alpine.LRH.2.02.1411050736410.11912@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1411050801270.19559@file01.intranet.prod.int.rdu2.redhat.com>
	<20141105141147.GA14285@redhat.com>
	<alpine.LRH.2.02.1411050925450.20317@file01.intranet.prod.int.rdu2.redhat.com>
	<20141105162912.GA17625@redhat.com>
	<alpine.LRH.2.02.1411071047430.21255@file01.intranet.prod.int.rdu2.redhat.com>
	<20141107183321.GA31022@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141107183321.GA31022@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, "Bryn M. Reeves" <breeves@redhat.com>, ejt@redhat.com, Alasdair G Kergon <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

Hi, I'm back.

I looked at current internal suspend code in 3.19.

One thing that seems strange is this:

static void __dm_internal_suspend(struct mapped_device *md, unsigned suspend_flags)
{
        struct dm_table *map = NULL;

        if (dm_suspended_internally_md(md))
                return; /* nested internal suspend */
....
static void __dm_internal_resume(struct mapped_device *md)
{
        if (!dm_suspended_internally_md(md))
                return; /* resume from nested internal suspend */

- the comments imply that the code supports nested internal suspend, while 
in fact it doesn't. If the caller calls:
* dm_internal_suspend_noflush
* dm_internal_suspend_noflush
* dm_internal_resume
the device is not suspended while it should be.

The "if" branch in __dm_internal_resume has nothing to do with nested 
suspend, it's called if the caller calls dm_internal_resume without 
dm_internal_suspend_noflush - that shouldn't happen, so there should be 
WARN or BUG.

If you want to support multiple internal suspends (which is needed if one 
table can have multiple dm-thin targets), you need a counter that counts 
how many times the device was suspended - the counter doesn't have to be 
atomic because the code already holds md->suspend_lock. If you don't want 
to support multiple internal suspends, there should be at least WARN when 
the caller attempts to do it.

Mikulas
