From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCHES] allocate per-bio data for targets
Date: Mon, 19 Nov 2012 19:42:34 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1211191940210.8231@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I placed patches that use per-bio data here:

http://people.redhat.com/~mpatocka/patches/kernel/per-request-data/series.html

The patches remove some mempools (and replace them with bio front pad 
allocated data) and they remove map_info for bio-based devices.

Mikulas
