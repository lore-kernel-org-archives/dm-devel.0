From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm-verity: Add error handling modes
	for	corrupted blocks
Date: Tue, 17 Mar 2015 00:37:47 +0000
Message-ID: <20150317003746.GA21831@agk-dp.fab.redhat.com>
References: <20150316155559.GA32397@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150316155559.GA32397@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sami Tolvanen <samitolvanen@google.com>
Cc: wad@chromium.org, msb@chromium.org, mpatocka@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 16, 2015 at 03:55:59PM +0000, Sami Tolvanen wrote:
> +<mode>
> +    Optional. The mode of operation.
> +    0 is the normal mode of operation where a corrupted block will result in an

The usual dm style uses a word rather than hiding behind a numeric code that has
to be learned or looked up.

> +#define DM_VERITY_ENV_VAR_NAME		"VERITY_ERR_BLOCK_NR"

Missing DM_ prefix?

Alasdair
