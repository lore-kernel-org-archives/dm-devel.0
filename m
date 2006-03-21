From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Fixes for clone_bio and __clone_and_map
	functions in dm.c
Date: Tue, 21 Mar 2006 14:35:15 +0000
Message-ID: <20060321143515.GL26428@agk.surrey.redhat.com>
References: <Pine.GSO.4.60.0603202032490.29527@cascade.cs.ubc.ca>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.60.0603202032490.29527@cascade.cs.ubc.ca>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

> I am a little confused about why is this not a problem. Isn't 
> clone->bi_vcnt 
> supposed to hold the number of bio vectors in the clone? Why does it hold 
> idx+bv_count instead? Please clarify.
 
idx is non-zero; bv_count variable is the number starting from idx.
clone->bi_vcnt is the total number.

       unsigned int     bi_vcnt;     /* how many bio_vec's */
       unsigned int     bi_idx;      /* current index into bio_vec array */

      clone_bio(bio, ci->sector, ci->idx, bio->bi_vcnt - ci->idx, ci->sector_count);
leads to clone->bi_vcnt = ci->idx + bio->bi_vcnt - ci->idx = bio->bi_vcnt

Like I said, obfuscated.

Alasdair
-- 
agk@redhat.com
