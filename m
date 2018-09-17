From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm raid: Remove bogus const from
 decipher_sync_action() return type
Date: Mon, 17 Sep 2018 13:58:31 +0200
Message-ID: <3623d6d7-a94f-2a35-83a9-dd475136d936@redhat.com>
References: <20180917080234.10909-1-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180917080234.10909-1-geert@linux-m68k.org>
Content-Language: en-MW
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: dm-devel.ids

Yes, the compiler is right to warn about a meaningless 'const' return by 
value.

Acked-by: Heinz Mauelshagen <heinzm@redhat.com>


On 09/17/2018 10:02 AM, Geert Uytterhoeven wrote:
> With gcc-4.1.2:
>
>      drivers/md/dm-raid.c:3357: warning: type qualifiers ignored on function return type
>
> Remove the "const" keyword to fix this.
>
> Fixes: 36a240a706d43383 ("dm raid: fix RAID leg rebuild errors")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>   drivers/md/dm-raid.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 5ba067fa0c729bc8..c44925e4e4813d24 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3353,7 +3353,7 @@ static const char *sync_str(enum sync_state state)
>   };
>   
>   /* Return enum sync_state for @mddev derived from @recovery flags */
> -static const enum sync_state decipher_sync_action(struct mddev *mddev, unsigned long recovery)
> +static enum sync_state decipher_sync_action(struct mddev *mddev, unsigned long recovery)
>   {
>   	if (test_bit(MD_RECOVERY_FROZEN, &recovery))
>   		return st_frozen;
