From: Shinobu Kinjo <skinjo@redhat.com>
Subject: Unexpected iface shutdown, probably normal but...
Date: Sun, 1 May 2016 02:30:22 -0400 (EDT)
Message-ID: <1469932803.22925636.1462084222414.JavaMail.zimbra@redhat.com>
References: <352412236.22925245.1462083480603.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <352412236.22925245.1462083480603.JavaMail.zimbra@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi,

One of device mappers was lost unexpectedly:

 iscsid: [warning] Connection7:0 to [target: iqn.1992-04.xxx.xxx:cx.xxxxxxxxxxxxxxxxx.b7, portal: xxx.xxx.xx.xx,3260] through [iface: default] is shutdown.

Just after recovering:

 Entering recovery mode: max_retries=60

Before losing connection, there was a only operation to remove a path:

 multipathd: [notice] xxxx [66:64]: path removed from map xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

After one day which is *too* long, path was operational which is normal.

 iscsid: [warning] Connection9:0 to [target: iqn.1992-04.xxx.xxx:cx.xxxxxxxxxxxxxxxxx.b7, portal: xxx.xxx.xx.xx,3260] through [iface: default] is operational now

My question is what could cause "[iface: default] is shutdown" without any manual operation, and network connectivity.
Iscsi connection is fine because of multipath. I just want to know any potential reason. Why it's cleaned up after max retries.

Thank you for your suggestion in advance.

Cheers,
Shinobu
