From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 0 of 5] dm-exception-store API
Date: Thu, 13 Nov 2008 04:12:13 -0600
Message-ID: <1226571133.6033.19.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, fujita.tomonori@lab.ntt.co.jp
List-Id: dm-devel.ids

I think the API patches are ready for serious review.  The API patches
are the first 3 of 5 that I will be sending.

The last 2 concern the refactoring of the "dm snapshot: shared exception
store" patches.  I left these in a somewhat rough state, and they will
need more work.  However, I hope it shows that we can create a clean
exception store API and adhere to it - even with the more exotic
exception stores.

 brassow
