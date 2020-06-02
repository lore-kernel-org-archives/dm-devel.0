From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCHv4 00/15] dm-zoned: multiple drive support
Date: Tue, 2 Jun 2020 18:27:19 -0400
Message-ID: <20200602222719.GA14318@redhat.com>
References: <20200602110956.121170-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200602110956.121170-1-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Hannes Reinecke <hare@suse.de>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Jun 02 2020 at  7:09am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> Hi all,
> 
> here's the second version of my patchset to support multiple zoned
> drives with dm-zoned.
> This patchset:
> - Converts the zone array to using xarray for better scalability
> - Separates out shared structures into per-device structure
> - Enforce drive-locality for allocating and reclaiming zones
> - Lifts the restriction of 2 devices to handle an arbitrary number
>   of drives.
> 
> This gives me a near-perfect scalability by increasing the write
> speed from 150MB/s (for a cache and one zoned drive) to 300MB/s
> (for a cache and two zoned drives).
> 
> Changes to v1:
> - Include reviews from Damien
> - Reshuffle patches
> Changes to v2:
> - Add reviews from Damien
> - Merge patches 'dynamic device allocation' and
>   'support arbitrary number of devices'
> - Fix memory leak when reading tertiary superblocks
> Changes to v3:
> - Add reviews from Damien
> - Add patch to ensure correct device ordering

I've picked this series up for 5.8 (yes, I know it is last minute).  But
I saw no benefit to merging the initial 2 device step in 5.8 only to
then churn the code and interface to support an arbitrary number of
devices in 5.9.  Easier to support one major update to the code now.

As such the target's version number was _not_ bumped from 2.0.0 to
3.0.0.

I tweaked various patch headers (_please_ "dm zoned" instead of
"dm-zoned" in commit subjects, also don't ever say "we" or "this patch"
in a commit header... if you do, I am forced to rewrite the header).

BTW, just so I feel like I said it: all these changes to use additional
device(s) really seems like a tradeoff between performance and reduced
MTBF -- there is increased potential for failure with each additional
device that is added to the dm-zoned device... there I've said it ;)

Thanks,
Mike
