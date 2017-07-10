From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] dm-zoned: Fix overflow when converting zone
	ID to sectors
Date: Mon, 10 Jul 2017 16:25:57 +0000
Message-ID: <1499703955.3555.11.camel@wdc.com>
References: <20170703064458.8091-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170703064458.8091-1-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <CF03057B1C8EBB48AEFCD9BA68A9D225@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, "agk@redhat.com" <agk@redhat.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: dm-devel.ids

On Mon, 2017-07-03 at 15:44 +0900, Damien Le Moal wrote:
> A zone ID is a 32 bits unsigned int which can overflow when doing the
> bit shifts calculations in dmz_start_sect(). With a 256 MB zone size
> drive, the overflow happens for a zone ID >= 8192.

Does the data from this example apply to a sector size of 512 bytes only?
Should this be mentioned in the patch description?

Anyway,

Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
