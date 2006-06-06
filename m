From: Maxim Kozover <maximkoz@netvision.net.il>
Subject: dm_multipath and O_DIRECT
Date: Tue, 06 Jun 2006 11:53:36 +0200
Message-ID: <1909357969.20060606115336@netvision.net.il>
Reply-To: Maxim Kozover <maximkoz@netvision.net.il>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi!
Tell me, please, if I open dm_multipath device /dev/mapper/... with
O_DIRECT, would all the transfers be synchronous all the way, i.e. via
underlying /dev/sd* devices down to physical layers?

Thanks,

Maxim.
