From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Subject: fix corrupted thin pool
Date: Fri, 24 Oct 2014 23:59:20 +0400
Message-ID: <CACaajQsU_z8pwUGMHfD1y2dVkP_gKgajM6bBV1wFpxpF_7m1nA@mail.gmail.com>
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
To: LVM <linux-lvm@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello! By mistake i'm restore by vcfgrestore thin volume, after that i
have errors on this thin pool on all volumes like :
 lvchange -ay vg1/2735
  Thin pool transaction_id=120, while expected: 114.
Does it possible to recovery from this? I'm try lvconvert --recover
and get tp1_tmeta0 but i'm don't understand whan i need to do next..?


-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
