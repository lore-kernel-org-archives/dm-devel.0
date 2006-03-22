From: Jens Axboe <axboe@suse.de>
Subject: Re: dm: bio split bvec fix
Date: Wed, 22 Mar 2006 12:32:35 +0100
Message-ID: <20060322113235.GC4285@suse.de>
References: <20060320192155.GU4724@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060320192155.GU4724@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 20 2006, Alasdair G Kergon wrote:
> The code that handles bios that span table target boundaries by breaking
> them up into smaller bios will not split an individual struct bio_vec
> into more than two pieces.  Sometimes more than that are required.
> 
> This patch adds a loop to break the second piece up into as many
> pieces as are necessary.

Why isn't this just handled in the merge callback? Can a single page bio
span > 2 targets?

-- 
Jens Axboe
