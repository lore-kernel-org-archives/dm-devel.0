From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Question about 'dmsetup remove' and dtr of target_type
Date: Sun, 9 Nov 2008 08:26:13 +0000
Message-ID: <20081109082612.GJ14593@agk.fab.redhat.com>
References: <60468f1e0811082127h3dac5b60h829d871fb38dd63a@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <60468f1e0811082127h3dac5b60h829d871fb38dd63a@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sun, Nov 09, 2008 at 12:27:24AM -0500, Reng Zeng wrote:
> However, I use "dmsetup remove" hundreds times, as the debug info, but it
> never enter the dtr function I defined.
> Anybody have idea on this? Or how to dig into that to discover the reason?

Something still holds a reference to the table?
E.g. you have dm_table_get() without a matching dm_table_put() somewhere.

Try a debugger like kgdb?  Check t->holders?

Or post your code here (assuming it's GPL) and someone might help.
 
Alasdair
-- 
agk@redhat.com
