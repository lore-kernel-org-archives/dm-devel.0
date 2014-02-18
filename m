From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Latest 3.14 and corelog in mirror target
Date: Tue, 18 Feb 2014 08:45:42 -0500
Message-ID: <20140218134542.GB14522@redhat.com>
References: <52FEA238.7040003@redhat.com> <20140215002119.GA22044@redhat.com>
	<52FF3F22.3080405@redhat.com> <52FFB26A.7050802@redhat.com>
	<alpine.LRH.2.02.1402171213320.8698@file01.intranet.prod.int.rdu2.redhat.com>
	<5302706D.4020304@redhat.com>
	<alpine.LRH.2.02.1402172104140.19080@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1402172104140.19080@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Mon, Feb 17 2014 at  9:08pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> Subject: [PATCH] dm-mirror: Fix BUG when retrying read bio.
> 
> Increase bi_remaining when retrying the bio to avoid BUG at fs/bio.c:1753
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

I thought I got all the places where bi_remianing needed incrementing
(most recent bi_remaining fixup was commit 8d30726912).

I'll get this staged for dm-3.14-fixes.

BTW, in the future, please send a discrete mail for a patch,
e.g. Subject with "[PATCH] ..." etc.  A patch buried in a thread can
lead to patchwork not picking it up (as happened for this patch).
