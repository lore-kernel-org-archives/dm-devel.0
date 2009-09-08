From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] shared snapshots
Date: Mon, 7 Sep 2009 23:15:18 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0909072313050.26479@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0909071505070.6165@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0909071505070.6165@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

[ the previous message was eaten by mailing-list server, probably because 
it was too long, so I am reposting it without the patch. The patch is at 
the URL below. ]

Hi

This is patch for shared snapshots to be included in the next merge 
window. The patch only adds new modules dm_multisnapshot and 
dm_store_mikulas, it doesn't modify any existing code.

It already works with userspace code.

The disk format is supposed to be stable, there would be hopefully no more 
changes to it.

The patch can be downloaded at 
http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/r10/dm-multisnap-mikulas.patch

Mikulas
