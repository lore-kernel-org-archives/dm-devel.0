From: jbrassow@ovpn-117-28.phx2.redhat.com (Jonathan Brassow)
Subject: [PATCH 0 of 2] Various dm-raid.c clean-ups
Date: Mon,  2 Oct 2017 17:17:25 -0500 (CDT)
Message-ID: <20171002221725.693A21A4715B@ovpn-117-28.phx2.redhat.com>
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
To: -c@ovpn-117-28.phx2.redhat.com, dm-devel@redhat.com, heinzm@redhat.com
List-Id: dm-devel.ids

Hi,

One minor clean-up and a status fix.  (Heinz,) Please take a careful
look over the status clean-up.  While it fixes a bug, that code can
be a bit tricky to get right and I don't want other things going wrong.

Thanks,
 brassow
