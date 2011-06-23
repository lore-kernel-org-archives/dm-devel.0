From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm: Introduce DMF_MERGE_IS_OPTIONAL flag
Date: Thu, 23 Jun 2011 02:14:15 +0100
Message-ID: <20110623011415.GB7497@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.1106221956590.9934@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1106221956590.9934@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Jun 22, 2011 at 07:57:49PM -0400, Mikulas Patocka wrote:
> dm: Introduce DMF_MERGE_IS_OPTIONAL flag
 
To summarise - and, again, we need some comments in the code:

If the new flag is set, it means that the device is capable of accepting
and processing correctly bios larger than the size the merge function
returns.  Or in other words, it means that the device is able to split
a bio itself if it is too big.

There are cases today where we are limited to submitting tiny bios as a
precaution against an underlying device being unable to split them if
it needs to.  The patch reduces the number of such cases.

Alasdair
