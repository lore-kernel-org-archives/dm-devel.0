From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/2] dm-switch: quickly load repetitive pattern
Date: Mon, 28 Jul 2014 17:47:00 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1407281743120.26574@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
Cc: Jay Wang <jwang@nimblestorage.com>
List-Id: dm-devel.ids

Hi

Jay Wang requested a way to quickly load repetitive pattern into the 
dm-switch target. I created these two patches, Jay tested them in their 
product and they work as expected. So, I'm submitting the patches upstream 
for the next merge window.

Mikulas
