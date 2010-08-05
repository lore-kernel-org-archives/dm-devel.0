From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: direct-io regression [Was: How to track down abysmal
 performance ata - raid1 - crypto - vg/lv - xfs]
Date: Thu, 5 Aug 2010 18:35:19 +0200
Message-ID: <20100805163519.GA6604__47918.1218812757$1282181827$gmane$org@comet.dominikbrodowski.net>
References: <20100805123649.GA18672@dhcp231-156.rdu.redhat.com>
	<20100805113240.GA29846@think>
	<20100805153519.GA7242@comet.dominikbrodowski.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100805153519.GA7242@comet.dominikbrodowski.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chris Mason <chris.mason@oracle.com>, josef@redhat.com, Valdis.Kletnieks@vt.edu, Michael Monnerie <michael.monnerie@is.it-management.at>, Christoph Hellwig <hch@i>
List-Id: dm-devel.ids

Small correction:

On Thu, Aug 05, 2010 at 05:35:19PM +0200, Dominik Brodowski wrote:
> With this fix, I get proper speeds when doing dio reads from
> /dev/mapper/vg0-*_crypt; see the 17.3 MB/s above. Most strangely,
> also accesing /dev/mapper/vg0-* (un-encrypted) and the raw
> device at /dev/sda* speeds up (to up to 28 MB/s). Was only seeing around
> 16 to 18 MB/s without this patch for unencrypted access.

The speed-up of the unencrypted access (18 -> 28 MB/s) is caused by using a
different configuration for kernel 2.6.35; and seems to be unrelated to your
patch. Will try to track down which config option is the culprit.


kernel, dmcrypt?	| good config | bad config
-------------------------------------------------
patched 2.6.35, dmcrypt	  ~ 18 MB/s	~ 13 MB/s
patched 2.6.35		  ~ 28 MB/s	~ 18 MB/s
-------------------------------------------------
plain 2.6.35, dmcrypt	  ~  3 MB/s	~  3 MB/s
plain 2.6.35		  <not tested>	~ 16 MB/s	


Best,
	Dominik
