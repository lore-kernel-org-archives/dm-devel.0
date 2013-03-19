From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm-cache: Add handle to contlr
	if	cache_create failed.
Date: Tue, 19 Mar 2013 12:20:21 +0000
Message-ID: <20130319122020.GF20480@agk-dp.fab.redhat.com>
References: <5139441C.7000309@gmail.com>
	<20130308021027.GV8913@agk.fab.redhat.com>
	<20130318231357.GA10638@blackbox.djwong.org>
	<20130319004400.GE20480@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130319004400.GE20480@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>, majianpeng <majianpeng@gmail.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Joe Thornber <thornber@redhat.com>
List-Id: dm-devel.ids

Current pahole output (offsets/size on right):

struct cache_disk_superblock {
	__le32                     csum;                 /*     0     4 */
	__le32                     flags;                /*     4     4 */
	__le64                     blocknr;              /*     8     8 */
	__u8                       uuid[16];             /*    16    16 */
	__le64                     magic;                /*    32     8 */
	__le32                     version;              /*    40     4 */
	__u8                       policy_name[16];      /*    44    16 */
	__le32                     policy_hint_size;     /*    60     4 */
	/* --- cacheline 1 boundary (64 bytes) --- */
	__u8                       metadata_space_map_root[128]; /*    64   128 */
	/* --- cacheline 3 boundary (192 bytes) --- */
	__le64                     mapping_root;         /*   192     8 */
	__le64                     hint_root;            /*   200     8 */
	__le64                     discard_root;         /*   208     8 */
	__le64                     discard_block_size;   /*   216     8 */
	__le64                     discard_nr_blocks;    /*   224     8 */
	__le32                     data_block_size;      /*   232     4 */
	__le32                     metadata_block_size;  /*   236     4 */
	__le32                     cache_blocks;         /*   240     4 */
	__le32                     compat_flags;         /*   244     4 */
	__le32                     compat_ro_flags;      /*   248     4 */
	__le32                     incompat_flags;       /*   252     4 */
	/* --- cacheline 4 boundary (256 bytes) --- */
	__le32                     read_hits;            /*   256     4 */
	__le32                     read_misses;          /*   260     4 */
	__le32                     write_hits;           /*   264     4 */
	__le32                     write_misses;         /*   268     4 */
	__le32                     policy_version[3];    /*   272    12 */

	/* size: 288, cachelines: 5, members: 25 */
	/* padding: 4 */
	/* last cacheline: 32 bytes */
};

Alasdair
