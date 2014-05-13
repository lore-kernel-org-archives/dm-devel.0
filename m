From: Joe Thornber <thornber@redhat.com>
Subject: Re: Performance question when blocks in thin-pool are
 assume zeroed
Date: Tue, 13 May 2014 14:59:59 +0100
Message-ID: <20140513135959.GB21162@debian>
References: <CAGj=0YKhOOP7O2okP5MAhev5+FAnRt3i7HgMOLipaLhYUeJO2w@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAGj=0YKhOOP7O2okP5MAhev5+FAnRt3i7HgMOLipaLhYUeJO2w@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi Wayne,

I see you're using a 3.6 kernel.  Could I trouble you to try with 3.14
please?  Mike Snitzer wrote a very nice patch recently that implements
a separate deferred list for each thin device, and then sorts
individual bios using a btree.

https://github.com/jthornber/linux-2.6/commit/67324ea18812bc952ef96892fbd5817b9050413f

- Joe

On Mon, May 12, 2014 at 05:03:39PM +0800, Wayne Chou wrote:
> Hello,
> 
> I am using 4 drives to construct a RAID5 and build a thin
> volume on it. To get better performance, I use '-Zn' option
> in 'lvcreate' to make the thin pool assume all blocks are
> already zeroed.  The chunk size in RAID5 and thin-pool are
> both 512KB and the stripe_cache_size=4096 on RAID5.
