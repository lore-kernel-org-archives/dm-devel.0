From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/9] dm-crypt patches
Date: Sat, 5 Apr 2014 14:04:21 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1404051359500.8509@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Ondrej Kozina <okozina@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I fixed the bug that Ondrej found (it happened only under memory pressure, 
that's why I couldn't reproduce it), here I'm resending the dm-crypt 
patches.

Mikulas
