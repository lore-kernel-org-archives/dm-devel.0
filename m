From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCHES] dm-crypt parallelization
Date: Mon, 24 Oct 2011 11:14:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1110241111100.13477@hs20-bc2-1.build.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

Here are patches for dm-crypt parallelization: 
http://people.redhat.com/mpatocka/patches/kernel/dm-crypt-paralelizace/

For each cpu, we create a kernel thread bound to that cpu. There is a 
global queue with sectors to be encrypted. We add requests to the queue 
and wake the per-cpu-threads. The threads pop requests from the queue and 
process them.

Mikulas
