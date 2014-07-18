From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/5] Five small multipath-tools patches
Date: Fri, 18 Jul 2014 14:52:01 +0200
Message-ID: <53C91871.9070402@acm.org>
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
To: christophe.varoqui@opensvc.com
Cc: device-mapper development <dm-devel@redhat.com>, Sebastian Herbszt <herbszt@gmx.de>
List-Id: dm-devel.ids

This series consists of the following patches:

0001-ALUA-prioritizer-Remove-an-unused-variable.patch
0002-libmultipath-Simplify-read_line.patch
0003-libmultipath-Zero-terminate-sysfs_attr_get_value-res.patch
0004-libmultipath-Print-line-number-for-which-parsing-fai.patch
0005-libmultipath-Accept-as-a-valid-regular-expression.patch

Please note that I'm not a multipath-tools expert so a careful review of
these patches would be appreciated.
