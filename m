From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: multipath: DELL MD3000/MD3000i and MD32xx/MD32xxi regex
	too broad
Date: Sun, 29 Mar 2015 22:37:32 +0200
Message-ID: <5518628C.9090603@gmail.com>
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
To: brking@linux.vnet.ibm.com, device-mapper development <dm-devel@redhat.com>, christophe.varoqui@opensvc.com
List-Id: dm-devel.ids

Hi,

At libmultipath/hwtable.c:

regex of __.product       = "MD3000"__ also matches __.product       = "MD3000i"__

The same happens with:
.product       = "MD32xx"
.product       = "MD32xxi"

-thanks-
