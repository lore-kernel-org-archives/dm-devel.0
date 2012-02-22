From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: Better number validation in sscanf
Date: Wed, 22 Feb 2012 11:11:41 -0500
Message-ID: <20120222161140.GB18966@redhat.com>
References: <Pine.LNX.4.64.1202221052450.19488@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1202221052450.19488@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Feb 22 2012 at 10:53am -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> dm: Better number validation in sscanf
> 
> Device mapper uses sscanf to convert arguments to numbers. The problem is that
> sscanf ignores additional unmatched characters in the scanned string.
> 
> For example, this `if (sscanf(string, "%d", &number) == 1)' will match a number,
> but also it will match number with some garbage appended, like "123abc".
> 
> sscanf is used this way at a lot of places in the device mapper and
> as a result, device mapper accepts garbage after some numbers, for example
> the command `dmsetup create vg1-new --table "0 16384 linear 254:1bla 34816bla"'
> will pass without an error.
> 
> This patch fixes all sscanf uses in device mapper. The patch appends "%c" with
> a pointer to a dummy character variable to every sscanf statement.
> 
> The construct `if (sscanf(string, "%d%c", &number, &dummy) == 1)' succeeds
> only if string is a null-terminated number (optinally preceeded by some
> whitespace characters). If there is some character appended after the number,
> sscanf matches "%c", writes the character to the dummy variable and returns 2.
> We check the return value for 1, consequently we reject numbers with some
> garbage appended.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Looks reasonable to me.

Acked-by: Mike Snitzer <snitzer@redhat.com>
