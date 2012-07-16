From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/3] Fix discards on dm-thin
Date: Mon, 16 Jul 2012 14:34:23 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1207161432310.3859@file.rdu.redhat.com>
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
Cc: dm-devel@redhat.com, Edward Thornber <thornber@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

Hi

There three patches fix some discard bugs on dm-thin. The patches should 
be placed in Alasdair's patchset after 
"dm-thin-optimize-power-of-two-block-size.patch". They shouldn't be set 
upstream because the bugs they fix exist only in Alasdair's patchset, not 
upstream.

Mikulas
