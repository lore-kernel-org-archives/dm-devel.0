From: Nicola Murino <n.murino@theorematica.it>
Subject: dm-emc doesn't works with vanilla kernel
Date: Sat, 08 Jul 2006 11:09:18 +0200
Message-ID: <1152349758.12950.14.camel@d810>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi all,

I'm successfully running multipath-tools on a gentoo server since almost
a year, only a problem:

if I use a kernel different from 2.6.13 after detaching a fibre path
dm-emc doesn't send trespass and the cx300 luns are not accessible, I
got this problem with kernel-2.6.14 and kernel-2.6.16.19, kernel-2.6.13
works ok. 

On another installation with centos, last kernel (2.6.9-34.01EL) and the
same storage all is fine.

Would be great if dm-emc works properly with the upstream kernels,

thanks
Nicola
