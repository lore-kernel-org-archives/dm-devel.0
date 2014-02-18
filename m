From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: Another metadata corruption issue in dm-cache
Date: Tue, 18 Feb 2014 15:25:56 +0100
Message-ID: <20140218142556.GA22119@sesse.net>
References: <20140216165113.GA7518@sesse.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140216165113.GA7518@sesse.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Feb 16, 2014 at 05:51:13PM +0100, Steinar H. Gunderson wrote:
>   [233728.674456] device-mapper: space map common: unable to decrement a reference count below 0

Actually a similar issue to this seems to have manifested itself in 3.13 even
after I nuked all the metadata; the dmsetup status line now reads:

cache: 0 35161337856 cache 1728/131072 2772587 12086450 2085299 1111070 0 260440 265439 4294967295 1 writeback 2 migration_threshold 2048 4 random_threshold 8 sequential_threshold 512

Occasionally, the 4294967295 dips up to 0 or 1, and then goes straight back
down again. So there seems to be an off-by-one somewhere in the counting of
blocks.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
