From: Bryan Gurney <bgurney@redhat.com>
Subject: Re: [PATCH v3 2/4] dm dust: update doc after message
 results report to user directly
Date: Fri, 19 Jun 2020 11:50:51 -0400
Message-ID: <CAHhmqcThF3TCaNUAu3rSHJFfkMARweZuChtbRmdsfNVE0DfBeA@mail.gmail.com>
References: <20200619123803.1441373-1-yangerkun@huawei.com>
	<20200619123803.1441373-3-yangerkun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200619123803.1441373-3-yangerkun@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: yangerkun <yangerkun@huawei.com>
Cc: bmr@redhat.com, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Fri, Jun 19, 2020 at 8:37 AM yangerkun <yangerkun@huawei.com> wrote:
>
> Since some type of message will report the results to user directly,
> we should update the doc too.
>
> Signed-off-by: yangerkun <yangerkun@huawei.com>
> ---
>  .../admin-guide/device-mapper/dm-dust.rst         | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/admin-guide/device-mapper/dm-dust.rst b/Documentation/admin-guide/device-mapper/dm-dust.rst
> index b6e7e7ead831..84149c08b68f 100644
> --- a/Documentation/admin-guide/device-mapper/dm-dust.rst
> +++ b/Documentation/admin-guide/device-mapper/dm-dust.rst
> @@ -69,10 +69,11 @@ Create the dm-dust device:
>          $ sudo dmsetup create dust1 --table '0 33552384 dust /dev/vdb1 0 4096'
>
>  Check the status of the read behavior ("bypass" indicates that all I/O
> -will be passed through to the underlying device)::
> +will be passed through to the underlying device, "verbose" indicates that
> +we will log everythings like bad blocks added, removed, or "remapped")::

Thanks for the addition here, and the revision of the "dmsetup status"
output example below.  Here's a quick grammatical fix:

'..."verbose" indicates that bad block additions, removals, and remaps
will be verbosely logged'

After that change,

Reviewed-by: Bryan Gurney <bgurney@redhat.com>


Thanks,

Bryan

>
>          $ sudo dmsetup status dust1
> -        0 33552384 dust 252:17 bypass
> +        0 33552384 dust 252:17 bypass verbose
>
>          $ sudo dd if=/dev/mapper/dust1 of=/dev/null bs=512 count=128 iflag=direct
>          128+0 records in
> @@ -164,7 +165,7 @@ following message command::
>  A message will print with the number of bad blocks currently
>  configured on the device::
>
> -        kernel: device-mapper: dust: countbadblocks: 895 badblock(s) found
> +        countbadblocks: 895 badblock(s) found
>
>  Querying for specific bad blocks
>  --------------------------------
> @@ -176,11 +177,11 @@ following message command::
>
>  The following message will print if the block is in the list::
>
> -        device-mapper: dust: queryblock: block 72 found in badblocklist
> +        block 72 found in badblocklist
>
>  The following message will print if the block is not in the list::
>
> -        device-mapper: dust: queryblock: block 72 not found in badblocklist
> +        block 72 not found in badblocklist
>
>  The "queryblock" message command will work in both the "enabled"
>  and "disabled" modes, allowing the verification of whether a block
> @@ -198,12 +199,12 @@ following message command::
>
>  After clearing the bad block list, the following message will appear::
>
> -        kernel: device-mapper: dust: clearbadblocks: badblocks cleared
> +        badblocks cleared
>
>  If there were no bad blocks to clear, the following message will
>  appear::
>
> -        kernel: device-mapper: dust: clearbadblocks: no badblocks found
> +        no badblocks found
>
>  Message commands list
>  ---------------------
> --
> 2.25.4
>
