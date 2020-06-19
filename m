From: Bryan Gurney <bgurney@redhat.com>
Subject: Re: [PATCH v3 4/4] dm dust: introduce listbadblocks in
	the rst
Date: Fri, 19 Jun 2020 13:50:19 -0400
Message-ID: <CAHhmqcTDzJ4aMD5q-s5GfHVg8iNhYmunVUSsba2nPCRdD-G4WA@mail.gmail.com>
References: <20200619123803.1441373-1-yangerkun@huawei.com>
	<20200619123803.1441373-5-yangerkun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200619123803.1441373-5-yangerkun@huawei.com>
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
> Since we support the listbadblocks command, introduce the detail in the
> doc.
>
> Signed-off-by: yangerkun <yangerkun@huawei.com>
> ---
>  .../admin-guide/device-mapper/dm-dust.rst        | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/Documentation/admin-guide/device-mapper/dm-dust.rst b/Documentation/admin-guide/device-mapper/dm-dust.rst
> index 84149c08b68f..5c66a71e3442 100644
> --- a/Documentation/admin-guide/device-mapper/dm-dust.rst
> +++ b/Documentation/admin-guide/device-mapper/dm-dust.rst
> @@ -205,6 +205,21 @@ If there were no bad blocks to clear, the following message will
>  appear::
>
>          no badblocks found
> +Listing the bad block list
> +--------------------------
> +
> +To list all bad blocks in the bad block list(using an example device
> +with blocks 1 and 2 in the bad block list),run the following message
> +command::

There are a couple of missing spaces here, at these two locations:

"...bad block list(using..."
change to
"...bad block list (using..."

and

"...in the bad block list),run the..."
change to
"...in the bad block list), run the..."

> +
> +        $ sudo dmsetup message dust1 0 listbadblocks
> +        1
> +        2
> +
> +No bad block exists, same message will get following report::

This would be better as the following:

"If there are no bad blocks in the bad block list, the following
message will appear"

However, note that we discussed changing this to an empty line,
instead of "null", so we would need to update the documentation to
reflect that the output will be an empty line.


Thanks,

Bryan

> +
> +        $ sudo dmsetup message dust1 0 listbadblocks
> +        null
>
>  Message commands list
>  ---------------------
> @@ -224,6 +239,7 @@ Single argument message commands::
>
>          countbadblocks
>          clearbadblocks
> +        listbadblocks
>          disable
>          enable
>          quiet
> --
> 2.25.4
>
