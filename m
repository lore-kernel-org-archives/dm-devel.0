From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: RFC: dm patches for 2.6.16
Date: Tue, 5 Dec 2006 20:25:59 +0000
Message-ID: <20061205202559.GY4409@agk.surrey.redhat.com>
References: <20061124032444.GH28363@stusta.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20061124032444.GH28363@stusta.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Adrian Bunk <bunk@stusta.de>
Cc: Mark McLoughlin <markmc@redhat.com>, Michal Miroslaw <mirq-linux@rere.qmqm.pl>, dm-devel@redhat.com, Daniel Kobras <kobras@linux.de>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Nov 24, 2006 at 04:24:44AM +0100, Adrian Bunk wrote:
> The following attached patches seem to make sense for 2.6.16:
> 
> Added in 2.6.17.11 and 2.6.18:
> dm: BUG/OOPS fix
> 
> Added in 2.6.17.12 and 2.6.18:
> dm snapshot: unify chunk_size
> dm: add module ref counting
> dm: mirror sector offset fix
> dm: Fix deadlock under high i/o load in raid1 setup.
> 
> Added in 2.6.19:
> dm snapshot: fix metadata writing when suspending
> 
> Do these patches look OK for 2.6.16, 

Yes.

> Are there any critical patches I missed?
 
The general rule for patches I send to linux-kernel is that any patch with
'fix' in the title is a candidate for stable trees (together with any
earlier patches they depend upon).

Alasdair
-- 
agk@redhat.com
