From: Mikulas Patocka <mpatocka@redhat.com>
Subject: question: deleting blocks
Date: Mon, 15 Aug 2011 14:27:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1108151426190.18170@hs20-bc2-1.build.redhat.com>
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
To: Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

BTW.

When you delete a block in the space map, how do you make sure that the 
block is not allocated for another purpose before commit?

Mikulas
