From: Mikulas Patocka <mpatocka@redhat.com>
Subject: A question about bio alignment
Date: Sat, 24 Sep 2011 16:34:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1109241627030.30282@hs20-bc2-1.build.redhat.com>
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
To: Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Jens

Please tell me, what is the required alignment of "bv_offset" and "bv_len" 
fields in "struct bio_vec", so that the bio can be handled by any block 
device driver?

Mikulas
