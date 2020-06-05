From: Bryan Gurney <bgurney@redhat.com>
Subject: Re: [RFC 2/2] dm dust: introduce listbadblocks in the rst
Date: Fri, 5 Jun 2020 15:47:40 -0400
Message-ID: <CAHhmqcRaSBW0q1=Zj-eeTCH2mFxc5L5ec_x8ccQVHxSSN6VB7w@mail.gmail.com>
References: <20200605073201.1742675-1-yangerkun@huawei.com>
	<20200605073201.1742675-3-yangerkun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200605073201.1742675-3-yangerkun@huawei.com>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Jun 5, 2020 at 3:48 AM yangerkun <yangerkun@huawei.com> wrote:
>
> Since we support the listbadblocks command, introduce the detail in the
> doc.
>
> Signed-off-by: yangerkun <yangerkun@huawei.com>

Thank you for the documentation.  I have a few corrections listed below:

> ---
>  .../admin-guide/device-mapper/dm-dust.rst        | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/Documentation/admin-guide/device-mapper/dm-dust.rst b/Documentation/admin-guide/device-mapper/dm-dust.rst
> index b6e7e7ead831..185b3ce6298b 100644
> --- a/Documentation/admin-guide/device-mapper/dm-dust.rst
> +++ b/Documentation/admin-guide/device-mapper/dm-dust.rst
> @@ -205,6 +205,21 @@ appear::
>
>          kernel: device-mapper: dust: clearbadblocks: no badblocks found
>
> +Listling the bad block list

"Listing the bad block list"

> +---------------------------
> +
> +To list all bad block list, run the following message command::

"To list all bad blocks in the bad block list"

> +
> +        $ sudo dmsetup message dust1 0 listbadblocks
> +
> +We will get following message(image that we have insert block 1/2, and
> +we will list the block index in order)::

"The following message will appear, listing one bad block number per
line (using an example device with blocks 1 and 2 in the bad block
list)"

After those corrections are made,

Reviewed-by: Bryan Gurney <bgurney@redhat.com>


Thanks,

Bryan



> +
> +        device-mapper: dust: dust_list_badblocks: badblocks list as below:
> +        device-mapper: dust: bad block: 1
> +        device-mapper: dust: bad block: 2
> +        device-mapper: dust: dust_list_badblocks: badblocks list end.
> +
>  Message commands list
>  ---------------------
>
> @@ -223,6 +238,7 @@ Single argument message commands::
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
