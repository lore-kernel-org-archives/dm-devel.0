From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/7] dm-snapshot prefetch patches
Date: Sat, 11 Jan 2014 12:28:15 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1401111222400.4018@file01.intranet.prod.int.rdu2.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

Here I'm sending the dm-snapshot prefetch patches.

Please find the system where prefetch is relevant (the system where it is 
most annoying to have long snapshot load times) and find the best number 
of read-ahead buffers for that system.

For my system (dm-loop on filesystem on 15k Seagate SCSI disk), it is best 
to prefetch 12 buffers. The patch series improves snapshot load time from 
2.8s to 1.7s.

Mikulas
